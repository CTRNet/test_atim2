<?php

class PermissionsController extends AdministrateAppController {
	
	var $uses = array(
		'Aco',
		'Aro', 
		'ExternalLink', 
		'Group',
		'Administrate.PermissionsPreset',
		'Permission'
	);

	function beforeFilter() {
		parent::beforeFilter();
	
		if($this->Auth->user()) {
			$this->Auth->allowedActions = array('regenerate');
		}
	}
	
	function index(){
		
	}
	
	function regenerate(){
		$this->PermissionManager->buildAcl();
		$this->set('log', $this->PermissionManager->log);
		$this->SystemVar->setVar('permission_timestamp', time());
		Cache::clear(false, "menus");
	}
	
	function update($aro_id, $aco_id, $state){
		
		$this->autoRender = false;
		
		$aro = $this->Aro->find('first', array('conditions' => 'Aro.id = "'.$aro_id.'"', 'order'=>'alias ASC', 'recursive' => -1));
		$this->updatePermission($aro_id,$aco_id,$state);
		
		list($type,$id) = split('::',$aro['Aro']['alias']);
		switch($type){
		case 'Group':
			$this->redirect('/Administrate/Permissions/tree/'.$id);
			break;
		case 'User':
			$parent = $this->Aro->find('first', array('conditions' => 'Aro.id = "'.$aro['Aro']['parent_id'].'"', 'order'=>'alias ASC', 'recursive' => -1));
			list($type,$gid) = split('::',$parent['Aro']['alias']);
			$this->redirect('/Administrate/Permissions/tree/'.$gid.'/'.$id);
			break;
		}
		exit();
	}
	
	private function updatePermission($aro_id, $aco_id, $state){
		
		if(intval($state) == 0 ){
			$sql = 'DELETE FROM aros_acos WHERE aro_id = "'.$aro_id.'" AND aco_id = "'.$aco_id.'"';
		}else{
			$sql = '
				INSERT INTO
					aros_acos
				(
					aro_id,
					aco_id,
					_create,
					_read,
					_update,
					_delete
				)
				VALUES(
					"'.$aro_id.'",
					"'.$aco_id.'",
					"'.$state.'",
					"'.$state.'",
					"'.$state.'",
					"'.$state.'"
				)
				ON DUPLICATE KEY UPDATE
					_create="'.$state.'",
					_read="'.$state.'",
					_update="'.$state.'",
					_delete="'.$state.'"
			';
		}
		
		try {
			$this->Aro->query($sql);
		}catch(Exception $e){
			$bt = debug_backtrace();
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.$bt[1]['function'].',line='.$bt[0]['line'], null, true );
		}
		
	}
	
	function tree($group_id=0, $user_id=0 ) {
		
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		$aro = $this->Aro->find('first', array('conditions' => 'Aro.alias = "Group::'.$group_id.'"', 'order'=>'alias ASC', 'recursive' => 1));
		$aco_id_extract = Set::extract('Aco.{n}.id',$aro);
		$aco_perm_extract = Set::extract('Aco.{n}.Permission',$aro);
		$known_acos = null;
		if(count($aco_id_extract) > 0 && count($aco_perm_extract) > 1){
			$known_acos = array_combine($aco_id_extract, $aco_perm_extract);
		}else{
			$known_acos = array();
		}
		$this->set('aro', $aro );
		$this->set('known_acos',$known_acos);
		if($this->request->data){
			$this->Group->id = $group_id;
			$this->Aro->pkey_safeguard = false;
			$this->Aro->check_writable_fields = false;
			$this->Group->addWritableField('flag_show_confidential');
			$this->Group->save($this->request->data['Group']);
			unset($this->request->data['Group']);
			foreach($this->request->data as $i => $aco){
				$this->updatePermission( 
					$aro['Aro']['id'], 
					$aco['Aco']['id'], 
					intval($aco['Aco']['state']) 
				);
			}
			
			if($group_id == 1){
				//make sure admin permissions are always allowed on the administrate module
				$permission_model = AppModel::getInstance('', 'Permission', false);
				$permission = $permission_model->find('first', array(
					'conditions' => array('Permission.aro_id' => 1, 'Permission.aco_id' => array(1, 2)),
					'order'	=> 'Permission.aco_id DESC',
					'recursive' => -1)
				);
				$altered_permissions = false;
				if($permission['Permission']['_create'] == -1){
					//highest node is blocked, allow it.
					$altered_permissions = true;
					$this->updatePermission(1, 2, 1);
				}
				$permissions = $this->Aco->children(2);//all administrate functions
				$permissions = AppController::defineArrayKey($permissions, 'Aco', 'id', true);
				$permissions_to_delete = $permission_model->find('all', array('conditions' => array('Permission.aco_id' => array_keys($permissions), 'Permission.aro_id' => 1), 'recursive' => -1));
				if($permissions_to_delete){
					$altered_permissions = true;
					foreach($permissions_to_delete as $permission_to_delete){
						$this->updatePermission(1, $permission_to_delete['Permission']['aco_id'], 0);
					}
				}
				
				if($altered_permissions){
					AppController::addWarningMsg(__('permissions were altered to grant group administrators all administrative privileges'));
				}
			}
			
			//check structure functions dependencies
			$dm_struct_fct_model = AppModel::getInstance('Datamart', 'DatamartStructureFunction');
			$dependent_fcts = $dm_struct_fct_model->find('all', array('conditions' => array('NOT' => array('DatamartStructureFunction.ref_single_fct_link' => ''))));
			$aro_str = "Group::".$group_id;
			$changed = false;
			$this->Permission->pkey_safeguard = false;
			$this->Permission->check_writable_fields = false;
			foreach($dependent_fcts as $dependent_fct){
				$batch = 'Controller'.$dependent_fct['DatamartStructureFunction']['link'];
				$unit = 'Controller'.$dependent_fct['DatamartStructureFunction']['ref_single_fct_link'];
				if(!$this->SessionAcl->check($aro_str, $unit) && $this->SessionAcl->check($aro_str, $batch)){
					$this->SessionAcl->deny($aro_str, $batch);
					$changed = true;
				}
			}
			
			if($changed){
				AppController::addWarningMsg(__('batch_alter_msg'));
			}
			
			$this->SystemVar->setVar('permission_timestamp', time());
			Cache::clear(false, "menus");
			//straight flash because we redirect to the edit screen
			$this->flash(__('your data has been updated'), '/Administrate/Permissions/tree/'.$group_id.'/'.$user_id);
			return;
		}
		
		try{
			$depth = $this->Aco->query('
				SELECT node.id, (COUNT(parent.id) - 1) AS depth
				FROM acos AS node, acos AS parent
				WHERE node.lft BETWEEN parent.lft AND parent.rght
				GROUP BY node.id
				ORDER BY node.lft;
			');
		}catch(Exception $e){
			$bt = debug_backtrace();
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.$bt[1]['function'].',line='.$bt[0]['line'], null, true );
		}
		
		$depth = array_combine(Set::extract('{n}.node.id',$depth),Set::extract('{n}.0.depth',$depth));
		
		$this->set('depth',$depth);
		
		$this->set('acos', $this->Aco->find('all', array('recursive' => -1, 'order'=>'Aco.lft ASC, Aco.alias ASC')) );
		
		
		$this->Aco->unbindModel(
			array(
				'hasAndBelongsToMany' => array('Aro')
			)
		);
		
		$this->Aco->bindModel(
			array(
				'hasAndBelongsToMany' => array(
					'Aro'	=> array(
						'className'					=> 'Aro',
						'joinTable'					=> 'aros_acos',
						'foreignKey'				=> 'aco_id',
						'associationForeignKey'	=> 'aro_id',
						'conditions'				=> array('Aro.model'=>'Group', 'Aro.foreign_key'=>$group_id)
					)
				)
			)
		);
		
		$threaded_data = $this->Aco->find('threaded', array('order' => 'Aco.alias'));
		$threaded_data = $this->addPermissionStateToThreadedData($threaded_data);
		
		$this->request->data = $threaded_data;
		if(!isset($this->request->data[0]['Aco']['state'])){
			//the root not is blank, display "denied" to make it easier to understand
			$this->request->data[0]['Aco']['state'] = -1;
		}
		$help_url = $this->ExternalLink->find('first', array('conditions' => array('name' => 'permissions_help')));
		$this->set("help_url", $help_url['ExternalLink']['link']);
		$this->Structures->set("permissions", "permissions");
		$this->Structures->set("permissions2", "permissions2");
		$this->set("group_data", $this->Group->find('first', array('conditions' => array('id' => $group_id), 'recursive' => 0)));
	}
	
	function addPermissionStateToThreadedData( $threaded_data=array() ) {
		foreach ( $threaded_data as $k=>$v ) {
			if ( isset($v['Aro'][0]) && isset($v['Aro'][0]['ArosAco']) && isset($v['Aro'][0]['ArosAco']['_create']) && $v['Aro'][0]['ArosAco']['_create'] != 0) {
				$threaded_data[$k]['Aco']['state'] = $v['Aro'][0]['ArosAco']['_create'];
			}
			
			unset($threaded_data[$k]['Aro']);
			
			if ( isset($v['children']) && count($v['children']) ) {
				$threaded_data[$k]['children'] = $this->addPermissionStateToThreadedData($v['children']);
			}
		}
		
		return $threaded_data;
	}
	
	function savePreset(){
		$this->Structures->set('permission_save_preset');
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		if(!empty($this->request->data)){
			$permission_preset = $this->PermissionsPreset->find('first', array('conditions' => array('PermissionsPreset.name' => $this->request->data['PermissionsPreset']['name'])));
			if(empty($permission_preset)){
				if($this->PermissionsPreset->save(array(
					'name' => $this->request->data['PermissionsPreset']['name'],
					'serialized_data' => serialize(array('allow' => $this->request->data[0]['allow'], 'deny' => $this->request->data[0]['deny'])),
					'description' => $this->request->data['PermissionsPreset']['description']
				))){
					echo 200;
					exit;
				}else{
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}else if($this->request->data[0]['overwrite']){
				if($this->PermissionsPreset->save(array(
					'id' => $permission_preset['PermissionsPreset']['id'],
					'serialized_data' => serialize(array('allow' => $this->request->data[0]['allow'], 'deny' => $this->request->data[0]['deny'])),
					'description' => $this->request->data['PermissionsPreset']['description']
				))){
					echo 200;
					exit;
				}else{
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}else{
				$this->PermissionsPreset->validationErrors['name'] = __('this name already exists')." ".__('select a new one or check the overwrite option');
			}
		}
	}
	
	function loadPreset(){
		$this->Structures->set('permission_save_preset');
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		$this->request->data = $this->PermissionsPreset->find('all', array('order' => array('PermissionsPreset.name')));
		foreach($this->request->data as &$unit){
			$unit['PermissionsPreset']['json'] = json_encode(unserialize($unit['PermissionsPreset']['serialized_data']));
		}
	}
	
	function deletePreset($preset_id){
		$this->layout = false;
		$this->render(false);
		$this->PermissionsPreset->atimDelete($preset_id);
	}
}

?>