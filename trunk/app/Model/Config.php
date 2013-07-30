<?php
class Config extends AppModel {
	function getConfig($group_id, $user_id){
		$config_results = $this->find('first',
			array('conditions' => array('Config.user_id'  => $user_id,
											'Config.group_id' => $group_id)));
		if($config_results){
			return $config_results;
		}
		
		$config_results = $this->find('first',
			array('conditions' => array(array('OR' => array('Config.bank_id' => 0, 'Config.bank_id IS NULL')),
								 	   array('OR' => array('Config.group_id' => 0, 'Config.group_id IS NULL')),
								 	   'Config.user_id' => $user_id)));
		if($config_results){
			return $config_results;
		}
		
		$config_results = $this->find('first',
			array('conditions' => array(array('OR' => array('Config.bank_id' => "0", 'Config.bank_id IS NULL')),
										'Config.group_id' => $group_id, 
										array('OR' => array('Config.user_id' => "0", 'Config.user_id IS NULL')))));
		if($config_results){
			return $config_results;
		}
		
		return $this->find('first',
			array('conditions' => array(array('OR' => array('Config.bank_id' => "0", 'Config.bank_id IS NULL')),
										array('OR' => array('Config.group_id' => "0", 'Config.group_id IS NULL')),
										array('OR' => array('Config.user_id' => "0", 'Config.user_id IS NULL')))));
	}
	
	function preSave($config_results, &$request_data, $group_id, $user_id){
		if($config_results['Config']['user_id'] != 0){
			//own config, edit, otherwise will create a new one
			$this->id = $config_results['Config']['id'];
		}else{
			$request_data['Config']['user_id'] = $user_id;
			$request_data['Config']['group_id'] = $group_id;
			//$this->request->data['Config']['bank_id'] = TODO is it needed here???
			$this->addWritableField(array('user_id', 'group_id', 'bank_id'));
		}
		
		//fixes a cakePHP 2.0 issue with integer enums
		$request_data['Config']['define_time_format'] = 
			$request_data['Config']['define_time_format'] == 24 ? 2 : 1;
	}
}
