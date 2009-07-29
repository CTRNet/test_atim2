<?php

class StorageCoordinatesController extends StoragelayoutAppController {
	
	var $uses 
		= array('Storagelayout.StorageControl',
				'Storagelayout.StorageCoordinate',
				'Storagelayout.StorageMaster',
				'Storagelayout.AliquotMaster'
	);
	
	var $useDbConfig = 'default';

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
	 * 
	 */
	 function listAll($storage_master_id = null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_no_stor_id'); 
			exit;
		}
		
		// ** get STORAGE info **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage supprot custom coordinates
		if(!$this->allowCustomCoordinates($storage_master_data['StorageMaster']['storage_control_id'], $storage_control_data)) {
			$this->redirect('/pages/err_sto_no_custom_coord_allowed'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_06', $storage_master_id ); 
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($storage_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('std_storage_coordinates'));

		// ** set DATA for echo on VIEW or to build link **
		$this->set('storage_master_id', $storage_master_id);
					
		// ** Search storage coordinate values **

		$criteria = array();
		$criteria['StorageCoordinate.storage_master_id'] = $storage_master_id;
		$criteria = array_filter($criteria);
			
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		$coordinates_list = $this->StorageCoordinate->findAll($criteria, NULL, $order, $limit, $page, 1);

		$this->set('coordinates_list', $coordinates_list);
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	} // End ListAll function
	
	/**
	 * Add a coordinate value attached to a storage.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
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
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}	
		
		// Verify storage supprot custom coordinates
		if(!$this->allowCustomCoordinates($storage_master_data['StorageMaster']['storage_control_id'], $storage_control_data)) {
			$this->redirect('/pages/err_sto_no_custom_coord_allowed'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_06', $storage_master_id ); 
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($storage_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('std_storage_coordinates'));

		// ** set DATA for echo on VIEW or to build link **
		$this->set('storage_master_id', $storage_master_id);
		$this->set('dimension', 'x');	// Only coordinate X could actually be attached to custom values
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (!empty($this->data)) {
			
			// ** SAVE DATA **
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('std_storage_coordinates') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;
			
			if($this->duplicatedValue($storage_master_id, $this->data['StorageCoordinate']['coordinate_value'])) {
				$this->data['StorageCoordinate']['coordinate_value'] = '';
			}
				
			// VALIDATE submitted data
			if (!$this->StorageCoordinate->validates($this->data['StorageCoordinate'])) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				if ($this->StorageCoordinate->save($this->data['StorageCoordinate'])) {
					$new_storage_coord_id = $this->StorageCoordinate->getLastInsertId();
					$this->flash('Your data has been saved.', 
						'/storage_coordinates/detail/'.$storage_master_id.'/'.$new_storage_coord_id);				
				} else {
					$this->redirect('/pages/err_inv_coll_record_err'); 
					exit;
				}
				
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
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// Verify storage supprot custom coordinates
		if(!$this->allowCustomCoordinates($storage_master_data['StorageMaster']['storage_control_id'], $storage_control_data)) {
			$this->redirect('/pages/err_sto_no_custom_coord_allowed'); 
			exit;			
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'sto_CAN_01', 'sto_CAN_06', $storage_master_id ); 
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// ** set SUMMARY variable from plugin's COMPONENTS ** 
		$this->set('ctrapp_summary', $this->Summaries->build($storage_master_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// ** set FORM variable, for HELPER call on VIEW  **	
		$this->set('ctrapp_form', $this->Forms->getFormArray('std_storage_coordinates'));

		// ** set DATA for echo on VIEW or to build link **
		$this->set('storage_master_id', $storage_master_id);
		
		// ** Get Storage Coordinate Data **			
		$this->StorageCoordinate->id = $storage_coordinate_id;
		$storage_coordinate_data = $this->StorageCoordinate->read();
		
		if(empty($storage_coordinate_data)){
			$this->redirect('/pages/err_sto_no_stor_coord_data'); 
			exit;
		}
		
		if(strcmp($storage_coordinate_data['StorageCoordinate']['storage_master_id'], $storage_master_id) != 0) {
			$this->redirect('/pages/err_sto_no_storage_id_map'); 
			exit;			
		}			
		
		$this->set('data', $storage_coordinate_data); 
	
		// ** Define if the storage coordinate can be deleted **
		$bool_allow_deletion 
			= $this->allowStorageCoordinateDeletion(
				$storage_master_id, 
				$storage_coordinate_data['StorageCoordinate']['coordinate_value']);
		$this->set('bool_allow_deletion', $bool_allow_deletion);
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}
	
	/**
	 * Delete a coordinate value attached to a storage.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $storage_coordinate_id Id of the studied storage coordinate.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * 
	 */	
	function delete($storage_master_id=null, $storage_coordinate_id=null) {
		
		// ** Parameters check **
		// Verify parameters have been set
		if(empty($storage_master_id) || empty($storage_master_id)) {
			$this->redirect('/pages/err_sto_funct_param_missing'); 
			exit;
		}
			
		// ** get STORAGE info **
		$this->StorageMaster->id = $storage_master_id;
		$storage_master_data = $this->StorageMaster->read();
		
		if(empty($storage_master_data)) {
			$this->redirect('/pages/err_sto_no_stor_data'); 
			exit;
		}

		//Look for storage control
		$this->StorageControl->id = $storage_master_data['StorageMaster']['storage_control_id'];
		$storage_control_data = $this->StorageControl->read();

		if(empty($storage_control_data)){
			$this->redirect('/pages/err_sto_no_stor_cont_data'); 
			exit;
		}
		
		// ** Get Storage Coordinate Data **			
		$this->StorageCoordinate->id = $storage_coordinate_id;
		$storage_coordinate_data = $this->StorageCoordinate->read();
		
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

		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
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
		
		$this->flash('Your data has been deleted.', '/storage_coordinates/listAll/'.$storage_master_id.'/');
		
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
	 */
	function allowStorageCoordinateDeletion($storage_master_id, $storage_coordinate_value){
		
		// verify storage contains no chlidren storage at this position
		$conditions = " StorageMaster.parent_id = '".$storage_master_id."' " .
				"AND StorageMaster.parent_storage_coord_x = '".$storage_coordinate_value."'";	
		$nbr_children_storages = $this->StorageMaster->findCount($conditions);

		if($nbr_children_storages > 0){
			return FALSE;
		}
		
		// verify storage contains no aliquots
		$conditions = " AliquotMaster.storage_master_id = '".$storage_master_id."' " .
				"AND AliquotMaster.storage_coord_x = '".$storage_coordinate_value."'";				
		$nbr_storage_aliquots = $this->AliquotMaster->findCount($conditions);

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
	 */
	function duplicatedValue($storage_master_id, $new_coordinate_value) {
		
		// verify storage contains no aliquots
		$conditions = " StorageCoordinate.storage_master_id = '".$storage_master_id."' " .
				"AND StorageCoordinate.coordinate_value = '".$new_coordinate_value."'";				
		$nbr_coord_values = $this->StorageCoordinate->findCount($conditions);

		if($nbr_coord_values > 0){
			return TRUE;
		}
					
		return FALSE;		
		
	}
	
}

?>
