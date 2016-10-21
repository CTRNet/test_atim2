<?php
App::uses('AppController', 'Controller');

/**
 * Class UsersController
 *
 * @property User $User
 * @property UserLoginAttempt $UserLoginAttempt
 * @property Version $Version
 */
class UsersController extends AppController {
   public $uses = array('User', 'UserLoginAttempt', 'Version');

   public function beforeFilter() {
      parent::beforeFilter();
      $this->Auth->allow('login', 'logout', 'reset_password');
      $this->Auth->authenticate = array('Form' => array(
         'userModel' => 'User',
         'scope' => array('User.flag_active')
      ));

      $this->set('atim_structure', $this->Structures->get('form', 'login'));
   }

   /**
    * @return \Cake\Network\Response|null
    */
   public function login() {
      if ($this->request->is('ajax') && !isset($this->passedArgs['login'])) {
         echo json_encode(array('logged_in' => isset($_SESSION['Auth']['User']), 'server_time' => time()));
         exit;
      }

      if ($this->request->is('post')) {

         $login_temporarily_disabled = $this->User->shouldLoginFromIpBeDisabledAfterFailedAttempts();

         if (!$login_temporarily_disabled && $this->Auth->login() && (!isset($this->passedArgs['login']))) {

            $this->UserLoginAttempt->saveSuccessfulLogin($this->request->data['User']['username']);

            // Init Session variables
            $this->Session->write('ctrapp_core.warning_no_trace_msg', array());
            $this->Session->write('ctrapp_core.warning_trace_msg', array());
            $this->Session->write('ctrapp_core.info_msg', array());

            //Authentication credentials expiration
            if ($this->User->isPasswordResetRequired()) {
               AppController::addWarningMsg(__('your password has expired. please change your password for security reason.'));
               return $this->redirect(array('action' => 'logout'));
            }

            $this->setSessionSearchId();
            $this->resetPermissions();

            if (isset($this->passedArgs['login'])) {
               return $this->render('ok');
            } else {
               return $this->redirect('/Menus');
            }
         } else {
            // Save failed login attempt
            $this->UserLoginAttempt->saveFailedLogin($this->request->data['User']['username']);
            $this->Flash->error(__('Login failed. Invalid username or password or disabled user.'));
         }
      } else {
         // Load version data and check if initialization is required
         $version_data = $this->Version->find('first', array('fields' => array('MAX(id) AS id')));
         $this->Version->id = $version_data[0]['id'];
         $this->Version->read();

         if ($this->Version->data['Version']['permissions_regenerated'] == 0) {
            $this->newVersionSetup();
         }

         $this->set('skip_expiration_cookie', TRUE);
      }

      //User got returned to the login page, tell him why
      if (isset($_SESSION['Message']['auth']['message'])) {
         $this->User->validationErrors[] = __($_SESSION['Message']['auth']['message']);
         unset($_SESSION['Message']['auth']);
      }

      if (isset($this->passedArgs['login'])) {
         AppController::addInfoMsg(__('your session has expired'));
      }

      $this->User->showErrorIfInternetExplorerIsBelowVersion8();
   }

   /**
    * Logs a user out
    */
   public function logout() {
      $this->Acl->flushCache();
      $this->redirect($this->Auth->logout());
   }

   /**
    * @return \Cake\Network\Response|null
    */
   public function reset_password() {
      $this->Structures->set('reset_password_struc');

      if ($this->request->is('post')) {
         $user_id = $this->User->field('id', array(
            'User.username' => $this->request->data['User']['username']
         ));

         if (!$user_id) {
            $this->validationErrors['username'][] = __('Username does not match');
         }

         $this->User->id = $user_id;

         $password_valid = $this->User->validatePassword($this->request->data);

         $data = array(
            'id' => $user_id,
            'password' => Security::hash($this->request->data['User']['new_password'], null, true),
            'password_modified' => date('Y-m-d H:i:s')
         );
         $this->User->check_writable_fields = false;
         // todo: Restrict fields that can be updated
         if ($password_valid && $this->User->save($data)) {
            $this->Flash->success('New password set');
            return $this->redirect(array('action' => 'login'));
         }
         $this->Flash->error('Could not save new password');
      }
   }

   /**
    *
    */
   protected function setSessionSearchId() {
      if (!$this->Session->read('search_id')) {
         $this->Session->write('search_id', 1);
         $this->Session->write('ctrapp_core.search', array());
      }
   }
}
