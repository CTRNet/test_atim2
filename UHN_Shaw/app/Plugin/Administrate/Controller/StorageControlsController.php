<?php

class StorageControlsController extends AdministrateAppController {

	var $components = array();
	
	var $uses = array(
		'StorageLayout.StorageMaster',
//		'StorageLayout.StorageControl',	//Not able to use this one because save process call afterSave() function of MasterDetailBehavior
		'Administrate.StorageCtrl',
		'StructurePermissibleValuesCustom',
		'StructurePermissibleValuesCustomControl');
	
	var $paginate = array('StorageCtrl' => array('limit' => pagination_amount, 'order' => 'StorageCtrl.storage_type ASC'));

	function listAll(){	
		$list_args = $this->StorageCtrl->getListArgs($this->passedArgs);	
		if(empty($list_args)) {
			if(!isset($_SESSION['StorageCtrl']['ListAllArgs'])) $_SESSION['StorageCtrl']['ListAllArgs'] = array();
		} else {
			$_SESSION['StorageCtrl']['ListAllArgs'] = $list_args;			
		}
				
		$this->Structures->set('storage_controls');
		
		$this->Paginator->settings = $_SESSION['StorageCtrl']['ListAllArgs'];
		$this->request->data = $this->paginate($this->StorageCtrl, array());
		foreach($this->request->data as &$new_row) {
			$new_row['FunctionManagement']['check_white_space'] = preg_match('/storage_w_spaces/', $new_row['StorageCtrl']['detail_form_alias'])? '1' : '';	
		}
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	function add($storage_category, $duplicated_parent_storage_control_id = null) {
		if($duplicated_parent_storage_control_id && empty($this->request->data)) {
			$this->request->data = $this->StorageCtrl->getOrRedirect($duplicated_parent_storage_control_id);
			if(preg_match('/storage_w_spaces/', $this->request->data['StorageCtrl']['detail_form_alias'])) $this->request->data['FunctionManagement']['check_white_space'] = '1';
			$this->request->data['StorageCtrl']['storage_type'] = '';
			$storage_category = $this->StorageCtrl->getStorageCategory($this->request->data);
		}
		$this->set('storage_category', $storage_category);
		$this->set('atim_menu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
		$this->Structures->set($this->StorageCtrl->getStructure($storage_category));

		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
				
		if(!$duplicated_parent_storage_control_id && !empty($this->request->data)) {
			// Set system value
			$this->request->data['StorageCtrl']['databrowser_label'] = 'custom#storage types#'.$this->request->data['StorageCtrl']['storage_type'];
			if(!isset($this->request->data['StorageCtrl']['set_temperature'])) $this->request->data['StorageCtrl']['set_temperature'] = '0';
			if(!isset($this->request->data['StorageCtrl']['check_conflicts'])) $this->request->data['StorageCtrl']['check_conflicts'] = '0';
			$this->request->data['StorageCtrl']['flag_active'] = '0';
			$this->request->data['StorageCtrl']['is_tma_block'] = ($storage_category == 'tma')? '1' : '0';
			$this->request->data['StorageCtrl']['detail_tablename'] = ($storage_category == 'tma')? 'std_tma_blocks' : 'std_customs';
			$detail_form_alias = array();
			if($storage_category == 'tma') $detail_form_alias[] = 'std_tma_blocks';
			if(isset($this->request->data['FunctionManagement']['check_white_space']) && $this->request->data['FunctionManagement']['check_white_space']) $detail_form_alias[] = 'storage_w_spaces';
			$this->request->data['StorageCtrl']['detail_form_alias'] = implode(',',$detail_form_alias);
			$this->StorageCtrl->addWritableField(array('databrowser_label', 'set_temperature', 'check_conflicts', 'flag_active', 'is_tma_block', 'detail_tablename', 'detail_form_alias'));
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
			
			if($submitted_data_validates) {
				$this->StorageCtrl->id = null;
				if($this->StorageCtrl->save($this->request->data)) {
					$control_data = $this->StructurePermissibleValuesCustomControl->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'storage types')));
					if(empty($control_data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					$existing_value = $this->StructurePermissibleValuesCustom->find('count', array('conditions' => array(
						'StructurePermissibleValuesCustom.control_id' => $control_data['StructurePermissibleValuesCustomControl']['id'],
						'StructurePermissibleValuesCustom.value' => $this->request->data['StorageCtrl']['storage_type'])));					
					if(!$existing_value) {
						$data_unit = array();
						$data_unit['StructurePermissibleValuesCustom']['control_id'] = $control_data['StructurePermissibleValuesCustomControl']['id'];
						$data_unit['StructurePermissibleValuesCustom']['value'] = $this->request->data['StorageCtrl']['storage_type'];
						$this->StructurePermissibleValuesCustom->addWritableField(array('control_id','value'));
						$this->StructurePermissibleValuesCustom->id = null;
						if(!$this->StructurePermissibleValuesCustom->save($data_unit)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					$this->atimFlash(__('your data has been saved').'<br>'.__('please use custom drop down list administration tool to add storage type translations'), '/Administrate/StorageControls/listAll/');					
				}
			}
		}
	}
			
	function edit($storage_control_id) {
		
		$storage_control_data = $this->StorageCtrl->getOrRedirect($storage_control_id);
		if($storage_control_data['StorageCtrl']['flag_active']) {
			$this->atimFlash('you are not allowed to work on active storage type', '/Administrate/StorageControls/listAll/');
			return;
		}
		
		$storage_category = $this->StorageCtrl->getStorageCategory($storage_control_data);
		$this->set('atim_menu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
		$this->Structures->set($this->StorageCtrl->getStructure($storage_category));
		$this->set('atim_menu_variables', array('StorageCtrl.id' => $storage_control_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
					
		if(empty($this->request->data)) {
			$storage_control_data['FunctionManagement']['check_white_space'] = (preg_match('/storage_w_spaces/', $storage_control_data['StorageCtrl']['detail_form_alias']))? '1' : '';
			$this->request->data = $storage_control_data;	
			
		} else {
			// Validates and set additional data
			$submitted_data_validates = true;
			
			if($this->request->data['StorageCtrl']['storage_type'] != $storage_control_data['StorageCtrl']['storage_type']) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			// Set system value
			if(isset($this->request->data['FunctionManagement']['check_white_space'])) {
				if($this->request->data['FunctionManagement']['check_white_space']) {
					if(!preg_match('/storage_w_spaces/', $storage_control_data['StorageCtrl']['detail_form_alias'])) {
						$detail_form_alias = explode(',',$storage_control_data['StorageCtrl']['detail_form_alias']);
						$detail_form_alias[] = 'storage_w_spaces';
						$this->request->data['StorageCtrl']['detail_form_alias'] = implode(',',$detail_form_alias);
						$this->StorageCtrl->addWritableField(array('detail_form_alias'));
					}
				} else if(preg_match('/storage_w_spaces/', $storage_control_data['StorageCtrl']['detail_form_alias'])) {
						$this->request->data['StorageCtrl']['detail_form_alias'] = str_replace(array('storage_w_spaces,', ',storage_w_spaces', 'storage_w_spaces'), array('', '', ''),$storage_control_data['StorageCtrl']['detail_form_alias']);
						$this->StorageCtrl->addWritableField(array('detail_form_alias'));	
				}
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
					
			if($submitted_data_validates) {
				// Save storage data
				$this->StorageCtrl->id = $storage_control_id;		
				if($this->StorageCtrl->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}	
					$this->atimFlash('your data has been updated', '/Administrate/StorageControls/listAll/'); 
				}	
			}
		}
	}
	
	function changeActiveStatus($storage_control_id) {		
		$storage_control_data = $this->StorageCtrl->getOrRedirect($storage_control_id);
		
		$new_data = array();
		if($storage_control_data['StorageCtrl']['flag_active']) {
			// Check no Storage Master use it
			$existing_storage_count = $this->StorageMaster->find('count', array('conditions' => array('StorageMaster.storage_control_id' => $storage_control_id, 'StorageMaster.deleted' => array('0','1'))));
			if($existing_storage_count) {
				$this->atimFlash('this storage type has already been used to build a storage - active status can not be changed', '/Administrate/StorageControls/listAll/');
				return;
			}
			$new_data['StorageCtrl']['flag_active'] = '0';
		} else {
			$new_data['StorageCtrl']['flag_active'] = '1';
		}
		$this->StorageCtrl->addWritableField(array('flag_active'));
		
		$this->StorageCtrl->data = array();
		$this->StorageCtrl->id = $storage_control_id;
		if($this->StorageCtrl->save($new_data)) {
			$this->atimFlash('your data has been updated', '/Administrate/StorageControls/listAll/');
		}
	}
	
	/**
	 * Display the content of a storage into a layout.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $is_ajax: Tells wheter the request has to be treated as ajax 
	 * query (required to counter issues in Chrome 15 back/forward button on the
	 * page and Opera 11.51 first ajax query that is not recognized as such)
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 */
	 
	function seeStorageLayout($storage_control_id){		
		$storage_control_data = $this->StorageCtrl->getOrRedirect($storage_control_id);
		$storage_category = $this->StorageCtrl->getStorageCategory($storage_control_data);
		if($storage_category == 'no_d') {
			$this->atimFlash('no layout exists', '/Administrate/StorageControls/listAll/');
			return;
		} else if($storage_control_data['StorageCtrl']['coord_x_type'] == 'list') {
			$this->atimFlash('custom layout will be built adding coordinates to a created storage', '/Administrate/StorageControls/listAll/');
			return;
		}
		$translated_storage_type = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('storage types', $storage_control_data['StorageCtrl']['storage_type']);
		$storage_control_data['StorageCtrl']['translated_storage_type'] = ($translated_storage_type !== false)? $translated_storage_type : $storage_control_data['StorageCtrl']['storage_type'];
		$this->set('storage_control_data', $storage_control_data);
		
		$this->set('atim_menu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
		$this->set('atim_menu_variables', array('StorageCtrl.id' => $storage_control_id));
		
		$this->Structures->set('empty', 'empty_structure');
	}
	
}
