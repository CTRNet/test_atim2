<?php

/**
 * Class UsersController
 */
class UsersController extends AppController
{

    public $uses = array(
        'User',
        'UserLoginAttempt',
        'Version'
    );

    /**
     * Before Filter Callback
     *
     * @return void
     */
    public function beforeFilter()
    {
        parent::beforeFilter();
        if (Configure::read('reset_forgotten_password_feature')) {
            $this->AtimAuth->allow('login', 'logout', 'resetForgottenPassword');
        } else {
            $this->AtimAuth->allow('login', 'logout');
        }
        if ($this->request->is('ajax')) {
            $this->AtimAuth->allow('getUserId');
        }
        $this->AtimAuth->authenticate = array(
            'Form' => array(
                'userModel' => 'User',
                'scope' => array(
                    'User.flag_active'
                )
            )
        );
        $this->set('atimStructure', $this->Structures->get('form', 'login'));
    }

    /**
     *
     * @return bool
     */
    private function doLogin()
    {
        $isLdap = Configure::read("if_use_ldap_authentication");
        
        if (empty($isLdap)) {
            return $this->AtimAuth->login();
        } elseif ($isLdap === true) {
            if (! isset($this->request->data['User']['username']) && ! isset($this->request->data['User']['password']) && $this->AtimAuth->login()) {
                return true;
            } elseif (isset($this->request->data['User']['username'])) {
                
                $username = (isset($this->request->data['User']['username'])) ? $this->request->data['User']['username'] : null;
                $password = (isset($this->request->data['User']['password'])) ? $this->request->data['User']['password'] : null;
                
                $conditions = array(
                    'User.username' => $username,
                    'User.deleted' => '0',
                    'User.flag_active' => 1
                );
                $user = $this->User->find('first', array(
                    'conditions' => $conditions
                ));
                $forcePasswordReset = (! empty($user)) ? $user['User']['force_password_reset'] : null;
                if (empty($forcePasswordReset)) {
                    $adServer = Configure::read('ldap_server');
                    $ldaprdn = Configure::read('ldap_domain');
                    
                    $ldaprdn = sprintf($ldaprdn, $username);
                    
                    $ldap = ldap_connect($adServer);
                    ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
                    ldap_set_option($ldap, LDAP_OPT_REFERRALS, 0);
                    
                    try {
                        $bind = @ldap_bind($ldap, $ldaprdn, $password);
                    } catch (Exception $ex) {
                        $bind = null;
                    }
                    
                    if (! empty($bind)) {
                        $conditions = array(
                            'User.username' => $username,
                            'User.deleted' => '0',
                            'User.flag_active' => 1
                        );
                        $user = $this->User->find('all', array(
                            'conditions' => $conditions
                        ));
                        if (empty($user)) {
                            return false;
                        } elseif (count($user) === 1) {
                            unset($user[0]['User']['password']);
                            $tempUser = $user[0]['User'];
                            $tempUser['Group'] = $user[0]['Group'];
                            $this->AtimAuth->login($tempUser);
                            return true;
                        } else {
                            return false;
                        }
                    }
                } else {
                    return $this->AtimAuth->login();
                }
            } else {
                return false;
            }
        }
    }

    /**
     * Login Method
     *
     * @return \Cake\Network\Response|null
     */
    public function login()
    {
        $username = $this->UserLoginAttempt->find('first', array(
            'order' => 'attempt_time DESC'
        ));
        $username = (isset($username["UserLoginAttempt"]["username"]) ? $username["UserLoginAttempt"]["username"] : null);
        if (! empty($_SESSION['Auth']['User']) && ! isset($this->passedArgs['login'])) {
            if (API::isAPIMode()){
                    return;
            }
            return $this->redirect('/Menus');
        }
        
        if ($this->request->is('ajax') && ! isset($this->passedArgs['login'])) {
            echo json_encode(array(
                'logged_in' => isset($_SESSION['Auth']['User']),
                'server_time' => time()
            ));
            exit();
        }
        
        // Load version data and check if initialization is required
        $versionData = $this->Version->find('first', array(
            'fields' => array(
                'MAX(id) AS id'
            )
        ));
        $this->Version->id = $versionData[0]['id'];
        $this->Version->read();
        
        if ($this->Version->data['Version']['permissions_regenerated'] == 0) {
            $this->newVersionSetup();
        }
        
        $this->set('skipExpirationCookie', true);
        if ($this->User->shouldLoginFromIpBeDisabledAfterFailedAttempts()) {
            // Too many login attempts - froze atim for couple of minutes
            $this->request->data = array();
            $this->AtimAuth->flash(__('too many failed login attempts - connection to atim disabled temporarily for %s mn', Configure::read('time_mn_IP_disabled')));
            if (API::isAPIMode()){
                API::addToBundle(array("status"=>0, 'message'=>__('too many failed login attempts - connection to atim disabled temporarily'), 'data'=>array()), 'errors');
            }
        } elseif ((! isset($this->passedArgs['login'])) && $this->doLogin()) {
            // Log in user
            if ($this->request->data['User']['username']) {
                $this->UserLoginAttempt->saveSuccessfulLogin($this->request->data['User']['username']);
            }
            $this->_initializeNotificationSessionVariables();
            
            $this->_setSessionSearchId();
            $this->resetPermissions();
            
            // Authentication credentials expiration
            if ($this->User->isPasswordResetRequired()) {
                $this->Session->write('Auth.User.force_password_reset', '1');
                if (API::isAPIMode()){
                    API::addToBundle(array("status"=>0, 'message'=>__('force password reset').', '.__('You should change your password by ATiM.'), 'data'=>array()), 'errors');
                    API::sendDataAndClear();
                }
                return $this->redirect('/Customize/Passwords/index');
            }
            if (API::isAPIMode()){
                API::addToBundle(array("status"=>1, 'message'=>__('Login successful.'), 'data'=>array()), 'informations');
            }
            if (isset($this->passedArgs['login'])) {
                API::sendDataAndClear();
                return $this->render('ok');
            } else {
                if (API::isAPIMode()){
                    $this->AtimAuth->allowedActions = array(
                      'index'
                    );
                    return;
                }
                return $this->redirect('/Menus');
            }

        } elseif (isset($this->request->data['User']['username']) && ! isset($this->passedArgs['login'])) {
            // Save failed login attempt
            $this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
            if ($this->User->disableUserAfterTooManyFailedAttempts($this->request->data['User']['username'])) {
                AppController::addWarningMsg(__('your username has been disabled - contact your administartor'));
            }
            $this->request->data = array();
            $ldap = Configure::read("if_use_ldap_authentication");
            if (empty($ldap)) {
                $this->AtimAuth->flash(__('login failed - invalid username or password or disabled user'));
            } else {
                $this->AtimAuth->flash(__('login failed - invalid username or password or disabled user or LDAP server connection error'));
            }
        } elseif (isset($this->request->data['User']['username']) && isset($this->passedArgs['login']) && $username === $this->request->data['User']['username']) {
            if ($this->doLogin()) {
                // Log in user
                if ($this->request->data['User']['username']) {
                    $this->UserLoginAttempt->saveSuccessfulLogin($this->request->data['User']['username']);
                }
                $this->_initializeNotificationSessionVariables();
                
                $this->_setSessionSearchId();
                $this->resetPermissions();
                return $this->render('ok');
            }
        } elseif (isset($this->request->data['User']['username']) && isset($this->passedArgs['login']) && $username !== $this->request->data['User']['username']) {
            if ($this->doLogin()) {
                // Log in user
                if ($this->request->data['User']['username']) {
                    $this->UserLoginAttempt->saveSuccessfulLogin($this->request->data['User']['username']);
                }
                $this->_initializeNotificationSessionVariables();
                
                $this->_setSessionSearchId();
                $this->resetPermissions();
                
                return $this->render('nok');
            }
        }
        
        // User got returned to the login page, tell him why
        if (isset($_SESSION['Message']['auth']['message'])) {
            $this->User->validationErrors[] = __($_SESSION['Message']['auth']['message']) . ($_SESSION['Message']['auth']['message'] == "You are not authorized to access that location." ? __("if you were logged id, your session expired.") : '');
            $message=__($_SESSION['Message']['auth']['message']) . ($_SESSION['Message']['auth']['message'] == "You are not authorized to access that location." ? __("if you were logged id, your session expired.") : '');
            if (API::isAPIMode()){
                API::addToBundle(array("status"=>0, 'message'=>$message, 'data'=>array()), 'errors');
            }            
            unset($_SESSION['Message']['auth']);
        }
        
        if (isset($this->passedArgs['login'])) {
            if (API::isAPIMode()){
                API::addToBundle(array("status"=>0, 'message'=>__('your session has expired'), 'data'=>array()), 'errors');
            }            
            AppController::addInfoMsg(__('your session has expired'));
        }
        
        $this->User->showErrorIfInternetExplorerIsBelowVersion(8);
    }

    /**
     * Set Session Search Id
     *
     * @return void
     */
    public function _setSessionSearchId()
    {
        if (! $this->Session->read('search_id')) {
            $this->Session->write('search_id', 1);
            $this->Session->write('ctrapp_core.search', array());
        }
    }

    /**
     * Logs a user out
     *
     * @return void
     */
    public function logout()
    {
        $this->Acl->flushCache();
        $this->Session->destroy();
        if (API::isAPIMode()){
            $this->AtimAuth->logout();
            API::addToBundle(array("status"=>1, 'message'=>__('Logout successful.'), 'data'=>array()), 'informations');
            API::sendDataAndClear();
        }
        $this->redirect($this->AtimAuth->logout());
    }

    /**
     * initializeNotificationSessionVariables
     *
     * @return void
     */
    public function _initializeNotificationSessionVariables()
    {
        // Init Session variables
        $this->Session->write('ctrapp_core.warning_no_trace_msg', array());
        $this->Session->write('ctrapp_core.warning_trace_msg', array());
        $this->Session->write('ctrapp_core.info_msg', array());
        $this->Session->write('ctrapp_core.force_msg_display_in_popup', false);
    }

    /**
     * Reset a forgotten password of a user based on personnal questions.
     *
     * @return \Cake\Network\Response|null
     */
    public function resetForgottenPassword()
    {
        if (! Configure::read('reset_forgotten_password_feature')) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($this->Session->read('Auth.User.id')) {
            $this->redirect('/');
        }
        
        $ipTemporarilyDisabled = $this->User->shouldLoginFromIpBeDisabledAfterFailedAttempts();
        
        if (empty($this->request->data) || $ipTemporarilyDisabled) {
            // 1- Initial access to the function:
            // Display of the form to set the username.
            
            $this->Structures->set('username');
            if ($ipTemporarilyDisabled) {
                $this->User->validationErrors[][] = __('too many failed login attempts - connection to atim disabled temporarily for %s mn', Configure::read('time_mn_IP_disabled'));
            }
            
            $this->set('resetForgottenPasswordStep', '1');
        } else {
            // Check username exists in the database and is not disabled
            if (! isset($this->request->data['User']['username'])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $resetFormFields = $this->User->getForgottenPasswordResetFormFields();
            $resetFormQuestionFields = array_keys($resetFormFields);
            $dbUserData = $this->User->find('first', array(
                'conditions' => array(
                    'User.username' => $this->request->data['User']['username'],
                    'User.flag_active' => '1'
                )
            ));
            
            foreach ($resetFormFields as $questionFieldName => $answerFieldName) {
                if (empty($dbUserData['User'][$questionFieldName])) {
                    $this->atimFlashWarning(__('User has not been yet answered to the reset questions.'), array(
                        'action' => 'resetForgottenPassword'
                    ));
                }
            }
            
            if (! $dbUserData) {
                
                // 2- User name does not exist in the database or is disabled
                // Display or re-display the form to set the username
                
                $this->User->validationErrors['username'][] = __('invalid username or disabled user');
                $this->Structures->set('username');
                $this->set('resetForgottenPasswordStep', '1');
                $this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
                $this->request->data = array();
            } elseif (! array_key_exists(array_shift($resetFormQuestionFields), $this->request->data['User'])) {
                
                // 3- User name does exist in the database
                // Display the form to set the username confidential questions
                
                $this->Structures->set('forgotten_password_reset' . ((Configure::read('reset_forgotten_password_feature') != '1') ? ',other_user_login_to_forgotten_password_reset' : ''));
                $this->set('resetForgottenPasswordStep', '2');
                $this->request->data = array(
                    'User' => array(
                        'username' => $this->request->data['User']['username']
                    )
                );
                foreach ($resetFormFields as $questionFieldName => $answerFieldName) {
                    $this->request->data['User'][$questionFieldName] = $dbUserData['User'][$questionFieldName];
                }
            } else {
                
                // 4- User name does exist in the database and answers have been completed by the user
                // Check the answers set by the user to reset the password
                
                $this->Structures->set('forgotten_password_reset' . ((Configure::read('reset_forgotten_password_feature') != '1') ? ',other_user_login_to_forgotten_password_reset' : ''));
                $this->set('resetForgottenPasswordStep', '2');
                
                $submittedDataValidates = true;
                
                // Validate user questions answers
                foreach ($resetFormFields as $questionFieldName => $answerFieldName) {
                    // Check db/form questions matche
                    
                    if ($dbUserData['User'][$questionFieldName] != $this->request->data['User'][$questionFieldName]) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    // Check answers
                    if (! strlen($dbUserData['User'][$answerFieldName])) {
                        // No answer in db. Validation can not be done
                        $this->User->validationErrors['username']['#1'] = __('at least one error exists in the questions you answered - password can not be reset');
                        $submittedDataValidates = false;
                    }
                    if ($dbUserData['User'][$answerFieldName] !== $this->User->hashSecuritAsnwer($this->request->data['User'][$answerFieldName])) {
                        $this->User->validationErrors['username']['#1'] = __('at least one error exists in the questions you answered - password can not be reset');
                        $submittedDataValidates = false;
                    }
                }
                
                // Validate other user login
                
                if (Configure::read('reset_forgotten_password_feature') != '1') {
                    if (! isset($this->request->data['0']['other_user_check_username'])) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    $conditions = array(
                        'User.username' => $this->request->data['0']['other_user_check_username'],
                        'User.flag_active' => '1',
                        'User.password' => Security::hash($this->request->data['0']['other_user_check_password'], null, true)
                    );
                    if (! $this->User->find('count', array(
                        'conditions' => $conditions
                    ))) {
                        $this->User->validationErrors['other_user_check_username'][] = __('other user control') . ' : ' . __('invalid username or disabled user');
                        $submittedDataValidates = false;
                    }
                }
                
                if ($submittedDataValidates) {
                    // Save new password
                    $this->User->id = $dbUserData['User']['id'];
                    $suerDataToSave = array(
                        'User' => array(
                            'id' => $dbUserData['User']['id'],
                            'group_id' => $dbUserData['User']['group_id'],
                            'new_password' => $this->request->data['User']['new_password'],
                            'confirm_password' => $this->request->data['User']['confirm_password']
                        )
                    );
                    if ($this->User->savePassword($suerDataToSave, true)) {
                        $this->atimFlash(__('your data has been updated'), '/');
                    }
                } else {
                    // Save failed login attempt
                    $this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
                    if ($this->User->disableUserAfterTooManyFailedAttempts($this->request->data['User']['username'])) {
                        AppController::addWarningMsg(__('your username has been disabled - contact your administartor'));
                    }
                }
                
                // Flush login information
                $this->request->data['0']['other_user_check_username'] = '';
                $this->request->data['0']['other_user_check_password'] = '';
                $this->request->data['User']['new_password'] = '';
                $this->request->data['User']['confirm_password'] = '';
            }
        }
    }

    /**
     * Reset user Id and esncrypte it just in AJAX mode to front-end.
     */
    public function getUserId()
    {
        if ($this->request->is('ajax')) {
            ob_clean();
            die((! empty($_SESSION['Auth']['User']['id'])) ? AppController::encrypt($_SESSION['Auth']['User']['id']) : AppController::encrypt("nul string"));
        }
    }
}