<?php

class PreferencesController extends CustomizeAppController {
	
	var $name = 'Preferences';
	var $uses = array('User', 'Config');
	
	function index() {
		$this->Structures->set('preferences' );
		
		$this->hook();
		
		// get USER data
		
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			
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
			
			$this->data['Config'] = $config_results['Config'];
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
		
		if(!empty($this->data)){
			
			$this->User->id = $_SESSION['Auth']['User']['id'];
			$this->data['User']['id'] = $_SESSION['Auth']['User']['id'];
			$this->data['User']['group_id'] = $_SESSION['Auth']['User']['group_id'];
			$this->data['Group']['id'] = $_SESSION['Auth']['User']['group_id'];
			
			$this->Config->id = $config_id;
			$this->data['Config']['bank_id'] = 0;
			$this->data['Config']['group_id'] = 0;
			$this->data['Config']['user_id'] = $_SESSION['Auth']['User']['id'];
			
			$this->User->set($this->data);
			$this->Config->set($this->data);
			
			if($this->User->validates() && $this->Config->validates()) {
				if($this->User->save($this->data, false) && $this->Config->save($this->data, false)){
					$this->atimFlash('your data has been updated','/customize/preferences/index');
				} else {
					$this->redirect( '/pages/err_cust_system_error', NULL, TRUE ); 
				}
			}
			
		}else{
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			$this->data['Config'] = $config_results['Config'];
		}
	}

}

?>