<?php

/**
 * Class PasswordsController
 * @property User $User
 */
class PasswordsController extends CustomizeAppController {

    public $name = 'Passwords';
    public $uses = array('User');

    public function index() {
		$this->Structures->set('old_password_for_change,password');
			
		$this->User->id = $this->Session->read('Auth.User.id');
		
		$this->hook();
		
		if ( empty($this->request->data) ) {
			$this->set( 'data', $this->User->read() );
		}else {
			//Check user entered his old password
			if($this->User->find('count', array(
			   'conditions' => array(
			      'User.id' => $this->User->id,
               'User.password' => Security::hash($this->request->data['FunctionManagement']['old_password'], null, true)
            )
         ))) {
				$flash_link = '/Customize/Passwords/index';
				$this->User->savePassword($this->request->data, $flash_link, $flash_link, true);
			} else {
				$this->User->validationErrors['old_password'][] = __('your old password is invalid');
				$this->request->data = array();
			}
		}
		
	}
}
