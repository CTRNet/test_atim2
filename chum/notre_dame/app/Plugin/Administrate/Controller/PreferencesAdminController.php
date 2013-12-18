<?php

class PreferencesAdminController extends AdministrateAppController {
	
	var $name = 'PreferencesAdmin';
	var $uses = array('User', 'Config');
	
	function index($group_id, $user_id ) {
		$this->Structures->set('preferences_lock,preferences');
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$user_id)));
		
		// get USER data
		
		$config_results	= $this->Config->getConfig(
				$user_id,
				$group_id);
		
		$this->request->data['Config'] = $config_results['Config'];
	}
	
	function edit($group_id, $user_id ){
		$this->Structures->set($_SESSION['Auth']['User']['id'] == $user_id ? 'preferences' : 'preferences_lock,preferences');
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$config_results	= $this->Config->getConfig(
				$user_id,
				$group_id);
		
		if(!empty($this->request->data)){
			$this->Config->preSave($config_results,
								   $this->request->data,
								   $user_id,
								   $group_id);
			
			$this->Config->set($this->request->data);
			
			if($this->Config->save()){
				$this->atimFlash( 'your data has been updated','/Administrate/PreferencesAdmin/index/'.$group_id.'/'.$user_id );
			}else{
				$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
			}
			
		}else{
			
			$this->request->data['Config'] = $config_results['Config'];
		}
	}
}

?>