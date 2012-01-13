<?php

class UsersController extends AppController {

	var $helpers = array('Html', 'Form');
	var $uses = array('User', 'UserLoginAttempt', 'Group', 'Version');
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->allow('login', 'logout');
		$this->Auth->loginRedirect = '/Menus';
		$this->Auth->authenticate = array('Form' => array('userModel' => 'User', 'scope' => array('User.flag_active')));
		
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'login') );
	}
	
	function login(){
		if($this->request->is('ajax')){
			echo json_encode(array("logged_in" => isset($_SESSION['Auth']['User']), "server_time" => time()));
			exit;
		}

		$version_data = $this->Version->find('first', array('fields' => array('MAX(id) AS id')));
		$this->Version->id = $version_data[0]['id'];
		$this->Version->read();
		if($this->Version->data['Version']['permissions_regenerated'] == 0){
			$this->PermissionManager->buildAcl();
			AppController::addWarningMsg(__('permissions have been regenerated'));
			$this->Version->data = array('Version' => array('permissions_regenerated' => 1));
			$this->Version->save();
		}
		if($this->Version->data['Version']['version_number'] != __('core_app_version')){
			//update the i18n string
			$version_number = $this->Version->data['Version']['version_number'];
			$this->User->query("UPDATE i18n SET en='".$version_number."', fr ='".$version_number."' WHERE id='core_app_version'");
			
			AppController::addWarningMsg('The language files need to be regenerated. (Invalid translation for core_app_version.)');	
		}

		if($this->Auth->login()){
			if(!empty($this->request->data)){
				//successfulll login
				$login_data = array(
						"username"			=> $this->request->data['User']['username'],
						"ip_addr"			=> $_SERVER['REMOTE_ADDR'],
						"succeed"			=> true,
						"http_user_agent"	=> $_SERVER['HTTP_USER_AGENT']
				);
				$this->UserLoginAttempt->save($login_data);
				$_SESSION['ctrapp_core']['warning_msg'] = array();//init
				$_SESSION['ctrapp_core']['info_msg'] = array();//init
				
				//flush tmp batch sets
				$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
				$batch_set_model->deleteCurrentUserTmp();
			}
			$group = $this->Group->findById($_SESSION['Auth']['User']['group_id']);
			$_SESSION['Auth']['User']['flag_show_confidential'] = $group['Group']['flag_show_confidential'];
			if(!isset($_SESSION['Auth']['User']['search_id'])){
				$_SESSION['Auth']['User']['search_id'] = 1;
				$_SESSION['ctrapp_core']['search'] = array();
			}
			$this->redirect($this->Auth->redirect());
		}else if(isset($this->request->data['User'])){
			//failed login
			$login_data = array(
						"username" => $this->request->data['User']['username'],
						"ip_addr" => $_SERVER['REMOTE_ADDR'],
						"succeed" => false
			);
			$this->UserLoginAttempt->save($login_data);
			$data = $this->User->find('first', array('conditions' => array('User.username' => $this->request->data['User']['username'])));
			if(!$data['User']['flag_active'] && $data['User']['username'] == $this->request->data['User']['username']){
				$this->Auth->flash("that username is disabled");
			}else{
				$this->Auth->flash('Login failed. Invalid username or password.');
			}
		}
		
		
		//User got returned to the login page, tell him why
		if(isset($_SESSION) && isset($_SESSION['Message']) && isset($_SESSION['Message']['auth']['message'])){
			if($_SESSION['Message']['auth']['message'] == "You are not authorized to access that location."){
				$this->User->validationErrors[] = __($_SESSION['Message']['auth']['message'])." ".__("if you were logged id, your session expired.");
			}else{
				$this->User->validationErrors[] = __($_SESSION['Message']['auth']['message']);
			}
			unset($_SESSION['Message']['auth']);
		}
	}
	
	function logout() {
		$this->Acl->flushCache();
		$this->redirect($this->Auth->logout());
	}
}

?>