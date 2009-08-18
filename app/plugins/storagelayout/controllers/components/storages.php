<?php

class StoragesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	/**
	 * This function builds an array of storage records, except those having TMA type. 
	 * 
	 * When a storage master id is passed in arguments, this storage 
	 * plus all its children storages will be removed from the array.
	 * 
	 * @param $excluded_storage_master_id ID of the storage to remove.
	 * 
	 * @return Array of storage records.
	 * 	[storage_master_id] => array('StorageMaster'=>array(), 'StorageControl'=>array(), etc))
	 * 
	 * @author N. Luc
	 * @since 2007-05-22
	 * @updated A. Suggitt on 2009-07-22
	*/
	
	function getStorageList($excluded_storage_master_id = null) {	
		// Find control ID for all storages of type TMA. These will be excluded from the returned array
		$arr_tma_control_ids = $this->controller->StorageControl->find('list', array('conditions' => array('StorageControl.is_tma_block' => 'TRUE')));
			
		// Get all storage records excluding those of type TMA
		$arr_storages_list = $this->controller->StorageMaster->atim_list(array('conditions' => array('NOT' => array('StorageMaster.storage_control_id' => $arr_tma_control_ids)), 'order' => array('StorageMaster.selection_label')));
				
		if(empty($arr_storages_list)) {
			// No Storage exists in the system
			return array();	
		}					
		
		// The defined storage plus all its childrens that should be removed from the array
		$ids_to_remove = array();
		if(!is_null($excluded_storage_master_id)){
			$ids_to_remove = array($excluded_storage_master_id => $excluded_storage_master_id);
		}
		$studied_parent_ids = $ids_to_remove;
		
		while(!empty($studied_parent_ids)){
			$children_ids = $this->controller->StorageMaster->find('list', array('conditions'=>array('StorageMaster.parent_id' => $studied_parent_ids)));
			$ids_to_remove += $children_ids;
			$studied_parent_ids = $children_ids;
		}
		
		return array_diff_key($arr_storages_list, $ids_to_remove);
	}
	
	/**
	 * Define if the coordinate 'x' list of a storage having a specific type
	 * can be set by the application user.
	 * 
	 * Note: Only storage having storage type including one dimension and a coordinate type 'x'
	 * equals to 'list' can support custom coordinate 'x' list. 
	 * 
	 * @param $storage_control_id Storage Control ID of the studied storage.
	 * @param $storage_control_data Storage Control Data of the studied storage (not required).
	 * 
	 * @return TRUE when the coordinate 'x' list of a storage can be set by the user.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	
	function allowCustomCoordinates($storage_control_id, $storage_control_data = null) {	
		// Check for storage control data, if none get the control data
		if(empty($storage_control_data)) {
			$storage_control_data = $this->controller->StorageControl->find('first', array('conditions'=>array('StorageControl.id' => $storage_control_id)));
			if(empty($storage_control_data)) { $this->controller->redirect('/pages/err_sto_no_stor_cont_data', NULL, TRUE); }
		}
					
		if($storage_control_data['StorageControl']['id'] !== $storage_control_id) { $this->controller->redirect('/pages/err_sto_system_error', NULL, TRUE); }
		
		// Check the control data and set boolean for return.
		if(!((strcmp($storage_control_data['StorageControl']['coord_x_type'], 'list') == 0) 
		&& empty($storage_control_data['StorageControl']['coord_x_size'])
		&& empty($storage_control_data['StorageControl']['coord_y_type'])
		&& empty($storage_control_data['StorageControl']['coord_y_size']))) {
			return FALSE;
		} 

		return TRUE;
	 }	
	 
	/**
	 * Inactivate the storage coordinate menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateStorageCoordinateMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_coordinates/listall/') !== FALSE) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	 }	
	 
	/**
	 * Inactivate the storage layout menu.
	 * 
	 * @param $atim_menu ATiM menu.
	 * 
	 * @return Modified ATiM menu.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */
		 
	 function inactivateStorageLayoutMenu($atim_menu) {
 		foreach($atim_menu as $menu_group_id => $menu_group) {
			foreach($menu_group as $menu_id => $menu_data) {
				if(strpos($menu_data['Menu']['use_link'], '/storagelayout/storage_masters/seeStorageLayout/') !== FALSE) {
					$atim_menu[$menu_group_id][$menu_id]['Menu']['allowed'] = 0;
					return $atim_menu;
				}
			}
 		}	
 		
 		return $atim_menu;
	 }
	 
	/**
	 * Using the id of a storage, the function will return data of each of the parent storages 
	 * in turn plus the studied storage (starting from the root to the studied storage).
	 * 
	 * @param $studied_storage_master_id ID of the studied storage.
	 * 
	 * @return An array that contains data of a storage plus all its parents storage odered from
	 * root to studied storage.
	 * 
	 * @author N. Luc
	 * @since 2009-08-12
	 */ 
	 
	function getStoragePathData($studied_storage_master_id = null) {
		$storage_path_data = array();
		
		while(!empty($studied_storage_master_id)) {
			$storage_data = $this->controller->StorageMaster->find('first', array('conditions' => array('StorageMaster.id' => $studied_storage_master_id)));
			if(empty($storage_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }		
			array_unshift($storage_path_data, $storage_data);
			$studied_storage_master_id = $storage_data['StorageMaster']['parent_id'];
		}
		
		return $storage_path_data;
	}	 
	
}

?>