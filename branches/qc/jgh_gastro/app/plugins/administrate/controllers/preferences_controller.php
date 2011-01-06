<?php

class PreferencesController extends AdministrateAppController {
	
	var $name = 'Preferences';
	var $uses = array('User', 'Config');
	
	function index($group_id, $user_id ) {
		$this->Structures->set('preferences');
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		
		// get USER data
		
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
			
		// get CONFIG data
		
			$config_results	= false;
		
			// get CONFIG for logged in user
			if ( $_SESSION['Auth']['User']['id'] ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$user_id.'"'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
			if ( $_SESSION['Auth']['User']['group_id'] && (!count($config_results) || !$config_results) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$group_id.'" AND (user_id="0" OR user_id IS NULL)'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( !count($config_results) || !$config_results ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
			}
			
			$this->data['Config'] = $config_results['Config'];
	}
	
	function edit($group_id, $user_id ) {
		$this->Structures->set('preferences');
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$config_id = NULL;
		
		// get CONFIG data
			
			$config_results	= false;
			
			// get CONFIG for logged in user
			if ( $user_id ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND user_id="'.$user_id.'"'));
				$config_id = $config_results['Config']['id']; // set ID for saves (add or edit)
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for GROUP level
			if ( $group_id && (!$config_results || !count($config_results)) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND Config.group_id="'.$group_id.'" AND (user_id="0" OR user_id IS NULL)'));
			}
			// if not logged in user, or user has no CONFIG, get CONFIG for APP level
			if ( (!$config_results || !count($config_results)) ) {
				$config_results = $this->Config->find('first', array('conditions'=>'(bank_id="0" OR bank_id IS NULL) AND (group_id="0" OR group_id IS NULL) AND (user_id="0" OR user_id IS NULL)'));
			}
		
		if ( !empty($this->data) ) {
			// Set the user and group to the id's of the selected user, not currently logged in user.
			$this->User->id = $user_id;
			$this->data['User']['id'] = $user_id; 
			$this->data['User']['group_id'] = $group_id; 
			$this->data['Group']['id'] = $group_id;
			
			$this->Config->id = $config_id;
			$this->data['Config']['bank_id'] = 0;
			$this->data['Config']['group_id'] = 0;
			$this->data['Config']['user_id'] = $user_id;
			
			if ( $this->User->validates($this->data) && $this->Config->validates($this->data) ) {
				$this->User->save($this->data);
				$this->Config->save($this->data);
				
				$this->atimFlash( 'your data has been updated','/administrate/preferences/index/'.$bank_id.'/'.$group_id.'/'.$user_id );
			}
			
		} else {
			
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
			$this->data['Config'] = $config_results['Config'];
				
		}
	}
}

?>