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
		if (!$storage_master_id) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	
		
		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_system_error', null, true); 
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
		if (!$storage_master_id) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }
				
		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	

		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_system_error', null, true); 
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
			
			if($this->isDuplicatedValue($storage_master_id, $this->data['StorageCoordinate']['coordinate_value'])) {
				$submitted_data_validates = false;
			}
			
			if($this->isDuplicatedOrder($storage_master_id, $this->data['StorageCoordinate']['order'])) {
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
		if((!$storage_master_id) || (!$storage_coordinate_id)) { $this->redirect('/pages/err_sto_funct_param_missing', null, true); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }	

		if(!$this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_system_error', null, true); 
		}
		
		// Get the coordinate data
		$storage_coordinate_data = $this->StorageCoordinate->find('first', array('conditions' => array('StorageCoordinate.id' => $storage_coordinate_id, 'StorageCoordinate.storage_master_id' => $storage_master_id)));
		if(empty($storage_coordinate_data)) { $this->redirect('/pages/err_sto_no_data', null, true); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_data);

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

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */		
	
	/**
	 * Define if a storage coordinate can be deleted.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $storage_coordinate_data Storage coordinate data.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	 
	function allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_data){
		// Check storage contains no chlidren storage stored within this position
		$nbr_children_storages = $this->StorageMaster->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id, 'StorageMaster.parent_storage_coord_x' => $storage_coordinate_data['StorageCoordinate']['coordinate_value']), 'recursive' => '-1'));
		if($nbr_children_storages > 0) { return array('allow_deletion' => false, 'msg' => 'children storage is stored within the storage at this position'); }
		
		// Verify storage contains no aliquots
		$nbr_storage_aliquots = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id, 'AliquotMaster.storage_coord_x ' =>  $storage_coordinate_data['StorageCoordinate']['coordinate_value']), 'recursive' => '-1'));
		if($nbr_storage_aliquots > 0) { return array('allow_deletion' => false, 'msg' => 'aliquot is stored within the storage at this position'); }
					
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Check the coordinate value does not already exists and set error if not.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $new_coordinate_value New coordinate value.
	 * 
	 * @return Return true if the storage coordinate has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	
	function isDuplicatedValue($storage_master_id, $new_coordinate_value) {	
		$nbr_coord_values = $this->StorageCoordinate->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id, 'StorageCoordinate.coordinate_value' => $new_coordinate_value), 'recursive' => '-1'));
		
		if($nbr_coord_values == 0) { return false; }

		// The value already exists: Set the errors
		$this->StorageCoordinate->validationErrors['coordinate_value']	= 'coordinate must be unique for the storage';

		return true;		
	}
	
	/**
	 * Check the coordinate order does not already exists and set error if not.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $new_coordinate_order New coordinate order.
	 * 
	 * @return Return true if the storage coordinate order has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	
	function isDuplicatedOrder($storage_master_id, $new_coordinate_order) {	
		$nbr_coord_values = $this->StorageCoordinate->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id, 'StorageCoordinate.order' => $new_coordinate_order), 'recursive' => '-1'));
		
		if($nbr_coord_values == 0) { return false; }

		// The value already exists: Set the errors
		$this->StorageCoordinate->validationErrors['order']	= 'coordinate order must be unique for the storage';

		return true;		
	}	
}

?>