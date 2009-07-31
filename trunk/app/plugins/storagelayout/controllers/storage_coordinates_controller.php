<?php

class StorageCoordinatesController extends StoragelayoutAppController {
	
	var $components = array('Storages');
	
	var $uses 
		= array('Storagelayout.StorageControl',
				'Storagelayout.StorageCoordinate',
				'Storagelayout.StorageMaster',
				'Storagelayout.AliquotMaster'
	);
	
	var $paginate = array('StorageCoordinate'=>array('limit'=>10,'order'=>'StorageCoordinate.id ASC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */	
	
	/**
	 * List all coordinates values attached to a storage.
	 * 
	 * Note: The current version will just allow user to set coordinate values for 
	 * the dimension 'x'.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 * 
	 */
	 function listall($storage_master_id = null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$storage_master_data = $this->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $storage_master_id)));
		pr ($storage_master_data);
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		$storage_control_data = $storage_master_data['StorageControl'];

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage supports custom coordinates
		if(!$this->Storages->allowCustomCoordinates($storage_master_data['StorageMaster']['storage_control_id'], $storage_control_data)) {
			$this->redirect('/pages/err_sto_no_custom_coord_allowed'); 
			exit;			
		}

		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id) );
		$this->data = $this->paginate($this->StorageCoordinate, array('StorageCoordinate.storage_master_id'=>$storage_master_id));
		
		$this->set('coordinates_list', $coordinates_list);
		$this->set('atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']));
		
	} // End ListAll function
	
	/**
	 * Add a coordinate value attached to a storage.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 * 
	 */
	function add($storage_master_id = null) {
		
		// ** Parameters check **
		if(isset($this->data['StorageCoordinate']['storage_master_id'])) {
			//User clicked on the Submit button to create the new storage coordinate
			$storage_master_id = $this->data['StorageCoordinate']['storage_master_id'];
		}
			
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
			
		// ** get STORAGE info **
		$storage_master_data =
			$this->StorageMaster->find('first', array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		$storage_control_data = $storage_master_data['StorageMaster'];
			
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage support custom coordinates
		if(!$this->Storages->allowCustomCoordinates($storage_master_data['StorageMaster']['storage_control_id'], $storage_control_data)) {
			$this->redirect('/pages/err_sto_no_custom_coord_allowed'); 
			exit;			
		}

		// ** set DATA for echo on VIEW or to build link **		
		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id) );
		$this->set('dimension', 'x');	// Only coordinate X could actually be attached to custom values
		$this->set('atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']));

		if (!empty($this->data)) {	
		
			if($this->duplicatedValue($storage_master_id, $this->data['StorageCoordinate']['coordinate_value'])) {
				$this->data['StorageCoordinate']['coordinate_value'] = '';
			}
			
			if ($this->StorageCoordinate->save($this->data['StorageCoordinate'])) {
				$new_storage_coord_id = $this->StorageCoordinate->getLastInsertId();
				$this->flash('Your data has been saved.', 
					'/storagelayout/storage_coordinates/detail/'.$storage_master_id.'/'.$new_storage_coord_id);				
			} else {
				$this->redirect('/pages/err_inv_coll_record_err'); 
				exit;
			}	
		}
	} // End Add function

	/**
	 * Detail a coordinate value attached to a storage.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $storage_coordinate_id Id of the studied storage coordinate.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 * 
	 */	
	function detail($storage_master_id=null, $storage_coordinate_id=null) {	
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id) || empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_funct_param_missing'); 
			exit;
		}
			
		// ** get STORAGE info **
		$storage_master_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		$storage_control_data = $storage_master_data['StorageMaster'];
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}
		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// Verify storage supprot custom coordinates
		if(!$this->allowCustomCoordinates($storage_master_data['StorageMaster']['storage_control_id'], $storage_control_data)) {
			$this->redirect('/pages/err_sto_no_custom_coord_allowed'); 
			exit;			
		}
	
		// ** Get Storage Coordinate Data **			
		$storage_coordinate_data = $this->StorageCoordinate->find('first', array('conditions'=>array('StorageCoordinate'=>$storage_coordinate_id)));
		if(empty($storage_coordinate_data)){
			$this->redirect('/pages/err_sto_no_stor_coord_data'); 
			exit;
		}
		
		if(strcmp($storage_coordinate_data['StorageCoordinate']['storage_master_id'], $storage_master_id) != 0) {
			$this->redirect('/pages/err_sto_no_storage_id_map'); 
			exit;			
		}			
		
		$this->data = $storage_coordinate_data; 

		// ** Define if the storage coordinate can be deleted **
		$bool_allow_deletion 
			= $this->allowStorageCoordinateDeletion(
				$storage_master_id, 
				$storage_coordinate_data['StorageCoordinate']['coordinate_value']);
		$this->set('bool_allow_deletion', $bool_allow_deletion);
				
		// ** set DATA for echo on VIEW or to build link **		
		$this->set( 'atim_menu_variables', array('StorageMaster.id'=>$storage_master_id) );
		$this->set('dimension', 'x');	// Only coordinate X could actually be attached to custom values
		$this->set('atim_structure', $this->Structures->get('form', $storage_control_data['StorageControl']['form_alias']));
	}
	
	/**
	 * Delete a coordinate value attached to a storage.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $storage_coordinate_id Id of the studied storage coordinate.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */	
	function delete($storage_master_id=null, $storage_coordinate_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id) || empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_funct_param_missing'); 
			exit;
		}

		// ** get STORAGE info **
		$storage_master_data = $this->StorageMaster->find('first',array('conditions'=>array('StorageMaster.id'=>$storage_master_id)));
		$storage_control_data = $storage_master_data['StorageMaster'];
				
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// ** Get Storage Coordinate Data **			
		$storage_coordinate_data = $this->StorageCoordinate->find('first', array('conditions'=>array('StorageCoordinate'=>$storage_coordinate_id)));
		if(empty($storage_coordinate_data)){
			$this->redirect('/pages/err_sto_no_stor_coord_data'); 
			exit;
		}
		
		if(strcmp($storage_coordinate_data['StorageCoordinate']['storage_master_id'], $storage_master_id) != 0) {
			$this->redirect('/pages/err_sto_no_storage_id_map'); 
			exit;			
		}			
		
		// ** check if the storage can be deleted **
		if(!$this->allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_data['StorageCoordinate']['coordinate_value'])){
			// Content exists, the storage can not be deleted
			$this->redirect('/pages/err_sto_stor_Coord_del_forbid'); 
			exit;			
		} 

		//Delete storage
		$bool_delete_storage_coord = TRUE;
		
		if(!$this->StorageCoordinate->del( $storage_coordinate_id )){
			$bool_delete_storage_coord = FALSE;		
		}	
		
		if(!$bool_delete_storage_coord){
			$this->redirect('/pages/err_sto_stor_coord_del_err'); 
			exit;
		}
		
		$this->flash('Your data has been deleted.', '/storagelayout/storage_coordinates/listall/'.$storage_master_id.'/');
	}

	/**
	 * Define if a storage coordinate can be deleted.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $storage_coordinate_id Id of the studied storage coordinate.
	 * 
	 * @return Return TRUE if the storage coordinate can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	function allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_value){

		// Verify storage contains no chlidren storage
		$nbr_children_storages =
			$this->StorageMaster->find('count', array('conditions'=>array('StorageMaster.parent_id'=>$storage_master_id, 'StorageMaster.parent_storage_coord_x'=>$storage_coordinate_value)));
		if($nbr_children_storages > 0) {
			return FALSE;
		}

		// Verify storage contains no aliquots
		$nbr_storage_aliquots =
			$this->AliquotMaster->find('count', array('conditions'=>array('AliquotMaster.storage_master_id'=>$storage_master_id, 'AliquotMaster.storage_coord_x'=>$storage_coordinate_value)));
		if($nbr_storage_aliquots > 0){
			return FALSE;
		}
					
		return TRUE;
	}
	
	/**
	 * Verify the coordinate value has not alread been set for a storage.
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
	function duplicatedValue($storage_master_id, $new_coordinate_value) {
		
		// Verify storage contains no aliquots
		$nbr_coord_values =
			$this->StorageCoordinate->find('count', array('conditions'=>array('StorageCoordinate.storage_master_id'=>$storage_master_id, 'StorageCoordinate.coordinate_value'=>$new_coordinate_value)));
		if($nbr_coord_values > 0){
			return TRUE;
		}
		return FALSE;		
	}
}

?>
