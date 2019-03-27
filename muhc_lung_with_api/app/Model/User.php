<?php

/**
 * Class User
 */
class User extends AppModel
{

    const PASSWORD_MINIMAL_LENGTH = 8;

    public $belongsTo = array(
        'Group'
    );
    
    public $actsAs = array(
        'Acl' => array(
            'requester'
        )
    );
    
    public $hasMany = array(
        'UserApiKey'
    );    
    
    /**
     * Parent Node
     *
     * @return array
     * @throws Exception
     */
    public function parentNode()
    {
        if (isset($this->data['User']['group_id'])) {
            return array(
                'Group' => array(
                    'id' => $this->data['User']['group_id']
                )
            );
        }
        if (isset($this->data['User']['id'])) {
            $this->id = $this->data['User']['id'];
        }
        
        if (! $this->id) {
            throw new Exception('Insufficient data to determine parentNode');
        }
        $data = $this->find('first', array(
            'conditions' => array(
                'User.id' => $this->id,
                'User.deleted' => array(
                    0,
                    1
                )
            )
        ));
        return array(
            'Group' => array(
                'id' => $data['User']['group_id']
            )
        );
    }

    /**
     * Summary
     *
     * @param array $variables Variables
     *       
     * @return array|bool
     */
    public function summary(array $variables)
    {
        $return = false;
        
        if (isset($variables['User.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'User.id' => $variables['User.id']
                )
            ));
            
            $displayName = trim($result['User']['first_name'] . ' ' . $result['User']['last_name']);
            $displayName = $displayName ? $displayName : $result['User']['username'];
            
            $return = array(
                'menu' => array(
                    null,
                    $displayName
                ),
                'title' => array(
                    null,
                    $displayName
                ),
                'data' => $result,
                'structure alias' => 'users'
            );
        }
        
        return $return;
    }

    /**
     * Get a list of users
     *
     * @return array
     */
    public function getUsersList()
    {
        $allUsersData = $this->find('all', array(
            'recursive' => - 1
        ));
        $result = array();
        foreach ($allUsersData as $data) {
            $result[$data['User']['id']] = $data['User']['first_name'] . ' ' . $data['User']['last_name'];
        }
        return $result;
    }

    /**
     * Save Password
     *
     * @param array $data Form Data
     * @param bool $modifiedByUser
     *
     * @return True|False if save failed
     */
    public function savePassword(array $data, $modifiedByUser = true)
    {
        assert($this->id);
        if ($this->validatePassword($data)) {
            $this->read();
            $dataToSave = array(
                'User' => array(
                    'group_id' => $this->data['User']['group_id'],
                    'password' => Security::hash($data['User']['new_password'], null, true),
                    'password_modified' => date("Y-m-d H:i:s")
                )
            );
            $isLdap = Configure::read("if_use_ldap_authentication");
            $isLdap = ! empty($isLdap);
            if ($isLdap) {
                unset($dataToSave['User']['password']);
            }
            if (array_key_exists('force_password_reset', $data['User'])) {
                $dataToSave['User']['force_password_reset'] = $data['User']['force_password_reset'];
            }
            if ($modifiedByUser) {
                $dataToSave['User']['force_password_reset'] = '0';
            }
            
            $this->data = null;
            $this->checkWritableFields = false;
            if ($this->save($dataToSave)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Will throw a flash message if the password is not valid
     *
     * @param array $data Form data
     * @param string|null $createdUserName user_name of a created user
     *       
     * @return bool true if validation passes
     */
    public function validatePassword(array $data, $createdUserName = null)
    {
        $isLdap = Configure::read("if_use_ldap_authentication");
        $isLdap = ! empty($isLdap);
        $validationErrors = array();
        
        if (! isset($data['User']['new_password'], $data['User']['confirm_password']) || (! $this->id && ! $createdUserName)) {
            // Missing fields
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $dbUserData = $this->id ? $this->find('first', array(
            'conditions' => array(
                'User.id' => $this->id
            )
        )) : null;
        
        if ($data['User']['new_password'] !== $data['User']['confirm_password']) {
            $validationErrors['confirm_password'][] = 'passwords do not match';
        }
        if ($isLdap && empty($createdUserName)) {
            $adServer = Configure::read('ldap_server');
            $ldaprdn = Configure::read('ldap_domain');
            
            $username = ($_SESSION['Auth']['User']['username']) ? $_SESSION['Auth']['User']['username'] : null;
            $password = $data['User']['new_password'];
            
            $ldaprdn = sprintf($ldaprdn, $username);
            
            $ldap = ldap_connect($adServer);
            ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
            ldap_set_option($ldap, LDAP_OPT_REFERRALS, 0);
            
            try {
                $bind = @ldap_bind($ldap, $ldaprdn, $password);
            } catch (Exception $ex) {
                $bind = null;
            }
            
            if (empty($bind)) {
                $validationErrors['password'][] = 'Error: invalid username or password or disabled user or LDAP server connection error.';
                $validationErrors['password'][] = 'As new password, should enter your password for loging into your computer.';
            }
        } elseif (! $isLdap) {
            if ($createdUserName && $createdUserName === $data['User']['new_password']) {
                $validationErrors['password'][] = 'password should be different than username';
            }
            if ($dbUserData) {
                if ($dbUserData['User']['username'] === $data['User']['new_password']) {
                    $validationErrors['password'][] = 'password should be different than username';
                }
                if ($dbUserData['User']['password'] === Security::hash($data['User']['new_password'], null, true)) {
                    $validationErrors['password'][] = 'password should be different than the previous one';
                } else {
                    
                    $differentPasswordsNumber = (int) Configure::read('different_passwords_number_before_re_use');
                    if (! preg_match('/^[0-5]$/', $differentPasswordsNumber)) {
                        $differentPasswordsNumber = 5;
                    }
                    if ($differentPasswordsNumber) {
                        $previousPasswords = $this->tryCatchQuery("SELECT password FROM users_revs WHERE id = " . $this->id . " ORDER BY version_id DESC LIMIT 1, $differentPasswordsNumber"); // Take last revs record equals current record in consideration
                        foreach ($previousPasswords as $previousPassword) {
                            if ($previousPassword['users_revs']['password'] == Security::hash($data['User']['new_password'], null, true)) {
                                $validationErrors['password'][] = __('password should be different than the %s previous one', ($differentPasswordsNumber + 1));
                            }
                        }
                    }
                }
            }
            
            $passwordSecurityLevel = (int) Configure::read('password_security_level');
            if (! preg_match('/^[0-4]$/', $passwordSecurityLevel)) {
                $passwordSecurityLevel = 4;
            }
            $passwordFormatError = false;
            switch ($passwordSecurityLevel) {
                case 4:
                    if (! preg_match('/\W+/', $data['User']['new_password'])) {
                        $passwordFormatError = true;
                    }
                case 3:
                    if (! preg_match('/[A-Z]+/', $data['User']['new_password'])) {
                        $passwordFormatError = true;
                    }
                case 2:
                    if (! preg_match('/[0-9]+/', $data['User']['new_password'])) {
                        $passwordFormatError = true;
                    }
                case 1:
                    if (strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH) {
                        $passwordFormatError = true;
                    }
                    if (! preg_match('/[a-z]+/', $data['User']['new_password'])) {
                        $passwordFormatError = true;
                    }
                case 0:
                default:
            }
            if ($passwordFormatError) {
                $validationErrors['password'][] = 'password_format_error_msg_' . $passwordSecurityLevel;
            }
        }
        
        $this->validationErrors = array_merge($this->validationErrors, $validationErrors);
        return empty($validationErrors);
    }

    /**
     * Checks if a user failed at login too often from the same IP adress (Takes only IP address into account).
     *
     * @return bool True if the IP adress is still defiend as disabled|False if not.
     * @throws CakeException when you try to construct an interface or abstract class.
     */
    public function shouldLoginFromIpBeDisabledAfterFailedAttempts()
    {
        // Test last login results from IP address
        $maxLoginAttemptsFromIP = Configure::read('max_login_attempts_from_IP');
        if (! $maxLoginAttemptsFromIP) {
            return false;
        }
        $timeInMinutesBeforeIpIsReactivated = Configure::read('time_mn_IP_disabled');
        
        $modelUserLoginAttempt = ClassRegistry::init('UserLoginAttempt');
        $lastSuccessfulLoginTime = $modelUserLoginAttempt->field('attempt_time', array(
            'UserLoginAttempt.ip_addr' => AppModel::getRemoteIPAddress(),
            'UserLoginAttempt.succeed' => true
        ), array(
            'UserLoginAttempt.id DESC'
        ));
        
        // Set default in case user has never logged in before
        if (! $lastSuccessfulLoginTime) {
            $lastSuccessfulLoginTime = date('Y-m-d'); // Removed 'H:i:s' in case there is a server client time discrepency
        }
        
        $failedLoginAttemptsFromIp = $modelUserLoginAttempt->find('all', array(
            'conditions' => array(
                'UserLoginAttempt.ip_addr' => AppModel::getRemoteIPAddress(),
                'UserLoginAttempt.succeed' => false,
                'UserLoginAttempt.attempt_time >' => $lastSuccessfulLoginTime
            ),
            'fields' => 'UserLoginAttempt.attempt_time',
            'order' => array(
                'UserLoginAttempt.id DESC'
            ),
            'limit' => $maxLoginAttemptsFromIP
        ));
        
        if (count($failedLoginAttemptsFromIp) >= $maxLoginAttemptsFromIP) {
            $lastAttemptTime = $failedLoginAttemptsFromIp[0]['UserLoginAttempt']['attempt_time'];
            $startDate = new DateTime($lastAttemptTime);
            $endDate = new DateTime(date("Y-m-d H:i:s"));
            $interval = $startDate->diff($endDate);
            
            if ($interval->y || $interval->m || $interval->d) {
                return false;
            }
            if (($interval->h * 60 + $interval->i) < $timeInMinutesBeforeIpIsReactivated) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check if a user failed at login too often with the same user account and disable user account
     * if check succeed.
     *
     * @param string $userName User account used by the user to login.
     *       
     * @return bool True if function disabled user|False if not.
     * @throws CakeException when you try to construct an interface or abstract class.
     */
    public function disableUserAfterTooManyFailedAttempts($userName)
    {
        // Test last user login results
        $maxUserLoginAttempts = Configure::read('max_user_login_attempts');
        if (! $maxUserLoginAttempts)
            return false;
        
        $userData = $this->find('first', array(
            'conditions' => array(
                'User.username' => $userName,
                'User.flag_active' => '1'
            ),
            'recursive' => - 1
        ));
        if (! $userData)
            return false;
        
        $modelUserLoginAttempt = ClassRegistry::init('UserLoginAttempt');
        $lastSuccessfulLoginTime = $modelUserLoginAttempt->field('attempt_time', array(
            'UserLoginAttempt.username' => $userName,
            'UserLoginAttempt.succeed' => true
        ), array(
            'UserLoginAttempt.id DESC'
        ));
        
        // Set default in case user has never logged in before
        if (! $lastSuccessfulLoginTime) {
            $lastSuccessfulLoginTime = date('Y-m-d H:i:s');
        }
        
        $failedUserLoginAttempts = $modelUserLoginAttempt->find('count', array(
            'conditions' => array(
                'UserLoginAttempt.username' => $userName,
                'UserLoginAttempt.succeed' => false,
                'UserLoginAttempt.attempt_time >' => $lastSuccessfulLoginTime
            ),
            'order' => array(
                'UserLoginAttempt.id DESC'
            ),
            'limit' => $maxUserLoginAttempts
        ));
        
        if ($failedUserLoginAttempts && $failedUserLoginAttempts >= $maxUserLoginAttempts) {
            $this->disableUser($userData['User']['id']);
            return true;
        }
        
        return false;
    }

    /**
     * Disable a User
     *
     * @param int $id UserId
     *       
     * @return void
     */
    public function disableUser($id)
    {
        $this->checkWritableFields = false;
        $this->data = array();
        $this->id = $id;
        $this->save(array(
            'User' => array(
                'flag_active' => false
            )
        ));
    }

    /**
     * Error if IE below a version passed in args
     *
     * @param integer $version Version of internet explorer
     *       
     * @return void
     */
    public function showErrorIfInternetExplorerIsBelowVersion($version)
    {
        $matches = array();
        if (preg_match('/MSIE ([\d]+)/', $_SERVER['HTTP_USER_AGENT'], $matches)) {
            if ($matches[1] < $version) {
                $this->validationErrors[] = __('bad internet explorer version msg');
            }
        }
    }

    /**
     * Checks if Password Reset is required
     *
     * @return bool
     */
    public function isPasswordResetRequired()
    {
        // Check administartor forced user to reset the password
        if (AuthComponent::user('force_password_reset')) {
            return true;
        }
        
        // Check password validity
        
        $lastTimePasswordWasModified = AuthComponent::user('password_modified');
        $passwordValidityPeriodMonth = Configure::read('password_validity_period_month');
        
        if ($passwordValidityPeriodMonth) {
            if (! $lastTimePasswordWasModified) {
                return true;
            } else {
                $startDate = new DateTime($lastTimePasswordWasModified);
                $endDate = new DateTime(date("Y-m-d H:i:s"));
                $interval = $startDate->diff($endDate);
                if (($interval->y * 12 + $interval->m) >= $passwordValidityPeriodMonth) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Return the list of all fields of the 'users' database table used to record both personal questions and answers
     * used by the 'Forgotten Password Rest' process.
     *
     * @return array Table fields (key=[question field]/value=[answer field])
     */
    public function getForgottenPasswordResetFormFields()
    {
        $formFields = array();
        for ($questionId = 1; $questionId < 4; $questionId ++) {
            $formFields['forgotten_password_reset_question_' . $questionId] = 'forgotten_password_reset_answer_' . $questionId;
        }
        return $formFields;
    }

    /**
     * Return the encrypted answer to the questions used by the 'Forgotten Password Rest' process to be recorded into database.
     *
     * @param $answer
     * @return string encrypted answer
     */
    public function hashSecuritAsnwer($answer)
    {
        return Security::hash(strtolower(trim($answer)), null, true);
    }
}