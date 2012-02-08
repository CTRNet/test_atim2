<?php

class UsersController extends AppController {

	var $helpers = array('Html', 'Form');
	var $uses = array('User', 'UserLoginAttempt', 'Version');
	
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
			//new version installed!
			//regen permissions
			$this->PermissionManager->buildAcl();
			AppController::addWarningMsg(__('permissions have been regenerated'));
			
			//update the i18n string for version
			$i18n_model = new Model(array('table' => 'i18n', 'name' => 0));
			$version_number = $this->Version->data['Version']['version_number'];
			$i18n_model->save(array('id' => 'core_app_version', 'en' => $version_number, 'fr' => $version_number));
				
			//rebuild language files
			$filee = fopen("../../app/Locale/eng/LC_MESSAGES/default.po", "w+t") or die("Failed to open english file");
			$filef = fopen("../../app/Locale/fre/LC_MESSAGES/default.po", "w+t") or die("Failed to open french file");
			$i18n = $i18n_model->find('all');
			foreach ( $i18n as &$i18n_line){
				//Takes information returned by query and creates variable for each field
				$id = $i18n_line[0]['id'];
				$en = $i18n_line[0]['en'];
				$fr = $i18n_line[0]['fr'];
				if(strlen($en) > 1014){
					$error = "msgid\t\"$id\"\nen\t\"$en\"\n";
					$en = substr($en, 0, 1014);
				}
					
				if(strlen($fr) > 1014){
					if(strlen($error) > 2 ){
						$error = "$error\\nmsgstr\t\"$fr\"\n";
					}else{
						$error = "msgid\t\"$id\"\nmsgstr=\"$fr\"\n";
					}
					$fr = substr($fr, 0, 1014);
				}
				$english = "msgid\t\"$id\"\nmsgstr\t\"$en\"\n";
				$french = "msgid\t\"$id\"\nmsgstr\t\"$fr\"\n";
			
				//Writes output to file
				fwrite($filee, $english);
				fwrite($filef, $french);
			}
			
			///Close file
			fclose($filee);
			fclose($filef);
			
			AppController::addWarningMsg(__('language files have been rebuilt'));
			
			//clear cache
			Cache::clear(false, 'structures');
			Cache::clear(false, 'menus');
			Cache::clear(false, '_cake_core_');
			Cache::clear(false, '_cake_model_');
			AppController::addWarningMsg(__('cache has been cleared'));
			
			//update the permissions_regenerated flag and redirect
			$this->Version->data = array('Version' => array('permissions_regenerated' => 1));
			$this->Version->check_writable_fields = false;
			if($this->Version->save()){
				$this->redirect('/Users/login');
			}
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
			if(!$this->Session->read('search_id')){
				$this->Session->write('search_id', 1);
				$_SESSION['ctrapp_core']['search'] = array();
			}
			$this->resetPermissions();
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