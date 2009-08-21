<?php

class StorageCoordinatesController extends StoragelayoutAppController {
	
	var $components = array('Storages');
	
	var $uses = array(
		'Storagelayout.StorageControl',
		'Storagelayout.StorageCoordinate',
		'Storagelayout.StorageMaster',
		
		'Inventorymanagement.AliquotMaster'
	);
	
	var $paginate = array('StorageCoordinate' => array('limit' => 10,'order' => 'StorageCoordinate.id ASC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	 function listAll($storage_master_id) {
		if (!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', NULL, TRUE); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	

		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_no_custom_coord_allowed', NULL, TRUE); 
		}

		// Get storage coordinates
		$this->data = $this->paginate($this->StorageCoordinate, array('StorageCoordinate.storage_master_id' => $storage_master_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_structure', $this->Structures->get('form', 'std_storage_coordinates'));	
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));
	}
	
	function add($storage_master_id) {
		if (!$storage_master_id) { $this->redirect('/pages/err_sto_no_stor_id', NULL, TRUE); }
				
		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	

		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_no_custom_coord_allowed', NULL, TRUE); 
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_structure', $this->Structures->get('form', 'std_storage_coordinates'));	
		$this->set('atim_menu_variables', array('StorageMaster.id' => $storage_master_id));

		// MANAGE DATA RECORD

		if (!empty($this->data)) {	
			// Set dimension
			$this->data['StorageCoordinate']['dimension'] = 'x';

			// Set storage id
			$this->data['StorageCoordinate']['storage_master_id'] = $storage_master_id;
			
			// Validates data
			$submitted_data_validates = TRUE;
			
			if($this->isDuplicatedValue($storage_master_id, $this->data['StorageCoordinate']['coordinate_value'])) {
				$submitted_data_validates = FALSE;
			}
			
			if($submitted_data_validates) {
				// Save data		
				if ($this->StorageCoordinate->save($this->data['StorageCoordinate'])) {
					$this->flash('Your data has been saved.', '/storagelayout/storage_coordinates/listAll/' . $storage_master_id);				
				}
			}
		}
	}

	function detail($storage_master_id, $storage_coordinate_id) {	
		if((!$storage_master_id) || (!$storage_coordinate_id)) { $this->redirect('/pages/err_sto_funct_param_missing', NULL, TRUE); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	

		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_no_custom_coord_allowed', NULL, TRUE); 
		}
		
		// Get the coordinate data
		$storage_coordinate_data = $this->StorageCoordinate->find('first', array('conditions' => array('StorageCoordinate.id' => $storage_coordinate_id, 'StorageCoordinate.storage_master_id' => $storage_master_id)));
		if(empty($storage_coordinate_data)) { $this->redirect('/pages/err_sto_no_stor_coord_data', NULL, TRUE); }		
		$this->data = $storage_coordinate_data; 
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_structure', $this->Structures->get('form', 'std_storage_coordinates'));	
		
		$atim_menu_variables = array();
		$atim_menu_variables['StorageMaster.id'] = $storage_master_id;
		$atim_menu_variables['StorageCoordinate.id'] = $storage_coordinate_id;		
		$this->set('atim_menu_variables', $atim_menu_variables);		
	}
	 
	function delete($storage_master_id, $storage_coordinate_id) {
		if((!$storage_master_id) || (!$storage_coordinate_id)) { $this->redirect('/pages/err_sto_funct_param_missing', NULL, TRUE); }

		// MANAGE DATA
		
		// Get the storage data
		$storage_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	

		if(!$this->Storages->allowCustomCoordinates($storage_data['StorageControl']['id'], array('StorageControl' => $storage_data['StorageControl']))) {
			// Check storage supports custom coordinates
			$this->redirect('/pages/err_sto_no_custom_coord_allowed', NULL, TRUE); 
		}
		
		// Get the coordinate data
		$storage_coordinate_data = $this->StorageCoordinate->find('first', array('conditions' => array('StorageCoordinate.id' => $storage_coordinate_id, 'StorageCoordinate.storage_master_id' => $storage_master_id)));
		if(empty($storage_coordinate_data)) { $this->redirect('/pages/err_sto_no_stor_coord_data', NULL, TRUE); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_data);
		if($arr_allow_deletion['allow_deletion']) {
			// Delete coordinate
			if($this->StorageCoordinate->atim_delete($storage_coordinate_id)) {
				$this->flash('Your data has been deleted.', '/storagelayout/storage_coordinates/listAll/' . $storage_master_id);
			} else {
				$this->flash('Error deleting data - Contact administrator.', '/storagelayout/storage_coordinates/detail/' . $storage_master_id . '/' . $storage_coordinate_id);
			}		
		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/storagelayout/storage_coordinates/detail/' . $storage_master_id . '/' . $storage_coordinate_id);
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
	 * 	['allow_deletion'] = TRUE/FALSE
	 * 	['msg'] = message to display when previous field equals FALSE
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	 
	function allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_data){
		// Check storage contains no chlidren storage stored within this position
		$nbr_children_storages = $this->StorageMaster->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id, 'StorageMaster.parent_storage_coord_x' => $storage_coordinate_data['StorageCoordinate']['coordinate_value'])));
		if($nbr_children_storages > 0) { return array('allow_deletion' => FALSE, 'msg' => 'children storage is stored within the storage at this position'); }
		
		// Verify storage contains no aliquots
		$nbr_storage_aliquots = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id, 'AliquotMaster.storage_coord_x ' =>  $storage_coordinate_data['StorageCoordinate']['coordinate_value'])));
		if($nbr_storage_aliquots > 0) { return array('allow_deletion' => FALSE, 'msg' => 'aliquot is stored within the storage at this position'); }
					
		return array('allow_deletion' => TRUE, 'msg' => '');
	}
	
	/**
	 * Check the coordinate value does not already exists and set error if not.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $new_coordinate_value New coordinate value.
	 * 
	 * @return Return TRUE if the storage coordinate has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	
	function isDuplicatedValue($storage_master_id, $new_coordinate_value) {	
		$nbr_coord_values = $this->StorageCoordinate->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id, 'StorageCoordinate.coordinate_value' => $new_coordinate_value)));
		if($nbr_coord_values == 0) { return FALSE; }

		// The value already exists: Set the errors
//TODO validate
		$this->StorageCoordinate->validationErrors['dimension']	= 'coordinate must be unique for the storage';

		return TRUE;		
	}
	
}

?>
