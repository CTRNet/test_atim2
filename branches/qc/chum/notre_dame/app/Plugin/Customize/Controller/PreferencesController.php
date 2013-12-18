<?php

class PreferencesController extends CustomizeAppController {
	
	var $name = 'Preferences';
	var $uses = array('User', 'Config');
	
	function index() {
		$this->Structures->set('preferences' );
		
		// get USER data
		
		$config_results	= $this->Config->getConfig(
			$_SESSION['Auth']['User']['id'],
			$_SESSION['Auth']['User']['group_id']);
		
		$this->request->data['Config'] = $config_results['Config'];
	}
	
	function edit() {
		$this->Structures->set('preferences' );
		
		$config_results	= $this->Config->getConfig(
				$_SESSION['Auth']['User']['id'],
				$_SESSION['Auth']['User']['group_id']);
		
		if(!empty($this->request->data)){
			$this->Config->preSave($config_results,
								   $this->request->data,
								   $_SESSION['Auth']['User']['id'],
								   $_SESSION['Auth']['User']['group_id']);
			
			$this->Config->set($this->request->data);
			
			if($this->Config->save()){
				$this->atimFlash('your data has been updated','/Customize/Preferences/index');
			} else {
				$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
			}
			
		}else{
			$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
			$this->request->data['Config'] = $config_results['Config'];
		}
	}
}
