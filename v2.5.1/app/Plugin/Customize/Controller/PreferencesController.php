<?php

class PreferencesController extends CustomizeAppController {
	
	var $name = 'Preferences';
	var $uses = array('User', 'Config');
	
	function index() {
		$this->Structures->set('preferences' );
		
		$this->hook();
		
		// get USER data
		
			$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			
		// get CONFIG data
		
			$config_results	= false;
		
			// get CONFIG for logged in user
			if ( $_SESSION['Auth']['User']['id'] ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$_SESSION['Auth']['User']['id'].'"'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
			if ( $_SESSION['Auth']['User']['group_id'] && (!count($config_results) || !$config_results) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$_SESSION['Auth']['User']['group_id'].'" AND (user_id="0" OR user_id IS NULL)'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( !count($config_results) || !$config_results ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
			}
			
			$this->request->data['Config'] = $config_results['Config'];
	}
	
	function edit() {
		$this->Structures->set('preferences' );
		
		$config_id = NULL;
		
		// get CONFIG data
			
			$config_results	= false;
			
			// get CONFIG for logged in user
			if ( $_SESSION['Auth']['User']['id'] ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$_SESSION['Auth']['User']['id'].'"'));
				$config_id = $config_results['Config']['id']; // set ID for saves (add or edit)
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
			if ( $_SESSION['Auth']['User']['group_id'] && (!$config_results || !count($config_results)) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$_SESSION['Auth']['User']['group_id'].'" AND (user_id="0" OR user_id IS NULL)'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( (!$config_results || !count($config_results)) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
			}
		
		$this->hook();
		
		if(!empty($this->request->data)){
			
			$this->Config->id = $config_id;
			$this->Config->addWritableField(array('bank_id', 'group_id', 'user_id'));
			$this->request->data['Config']['bank_id'] = 0;
			$this->request->data['Config']['group_id'] = 0;
			$this->request->data['Config']['user_id'] = $_SESSION['Auth']['User']['id'];
			$this->request->data['Config']['define_time_format'] = $this->request->data['Config']['define_time_format'] == 24 ? 2 : 1;//fixes a cakePHP 2.0 issue with integer enums
			
			$this->User->set($this->request->data);
			$this->Config->set($this->request->data);
			
			if($this->Config->validates()) {
				if($this->Config->save($this->request->data, false)){
					$this->atimFlash('your data has been updated','/Customize/preferences/index');
				} else {
					$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
				}
			}
			
		}else{
			$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			$this->request->data['Config'] = $config_results['Config'];
		}
	}

}

?>