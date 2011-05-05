<?php

class StorageCoordinatesController extends StoragelayoutAppController {
	
	var $components = array();
	
	var $uses = array(
		'Storagelayout.StorageControl',
		'Storagelayout.StorageCoordinate',
		'Storagelayout.StorageMaster',
		
		'Inventorymanagement.AliquotMaster');
	
	var $paginate = array('StorageCoordinate' => array('limit' => pagination_amount,'order' => 'StorageCoordinate.order ASC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	 function listAll($storage_master_id) {
		if (!$storage_master_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// Get storage coordinates
		$this->data = $this->paginate($this->StorageCoordinate, array('StorageCoordinate.storage_master_id' => $storage_master_id));
			
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set('storage_coordinates');	
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add($storage_master_id) {
		if (!$storage_master_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
				
		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	

		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->Structures->set('storage_coordinates');	
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if (!empty($this->data)) {	
			// Set dimension
			$this->data['StorageCoordinate']['dimension'] = 'x';

			// Set storage id
			$this->data['StorageCoordinate']['storage_master_id'] = $storage_master_id;
			
			// Validates data
			$submitted_data_validates = true;
			
			if($this->StorageCoordinate->isDuplicatedValue($storage_master_id, $this->data['StorageCoordinate']['coordinate_value'])) {
				$submitted_data_validates = false;
			}
			
			if($this->StorageCoordinate->isDuplicatedOrder($storage_master_id, $this->data['StorageCoordinate']['order'])) {
				$submitted_data_validates = false;
			}
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }		
			
			if($submitted_data_validates) {
				// Save data		
				if ($this->StorageCoordinate->save($this->data['StorageCoordinate'])) {
					$this->atimFlash('your data has been saved', '/storagelayout/storage_coordinates/listAll/' . $storage_master_id);				
				}
			}
		}
	}
	 
	function delete($storage_master_id, $storage_coordinate_id) {
		if((!$storage_master_id) || (!$storage_coordinate_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	

		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// Get the coordinate data
		$storage_coordinate_data = $this->StorageCoordinate->find('first', array('conditions' => array('StorageCoordinate.id' => $storage_coordinate_id, 'StorageCoordinate.storage_master_id' => $storage_master_id)));
		if(empty($storage_coordinate_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->StorageCoordinate->allowDeletion($storage_master_id, $storage_coordinate_data);

		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		$flash_url = '/storagelayout/storage_coordinates/listAll/' . $storage_master_id;
		
		if($arr_allow_deletion['allow_deletion']) {
			// Delete coordinate
			if($this->StorageCoordinate->atim_delete($storage_coordinate_id)) {
				$this->atimFlash('your data has been deleted', $flash_url);
			} else {
				$this->flash('error deleting data - contact administrator', $flash_url);
			}		
		
		} else {
			$this->flash($arr_allow_deletion['msg'], $flash_url);
		}			
	}
}

?>
