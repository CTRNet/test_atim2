<?php
	 
class AliquotMastersControllerCustom extends AliquotMastersController {
	
	/**
	 * Format Preselected Storages data array for display.
	 * 
	 * @param $arr_preselected_storages PreselectedStorages data
	 * 
	 * @return Preselected storage list into array having following structure: 
	 * 	array($storage_master_id => $storage_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 */	
	 
	function formatPreselectedStoragesForDisplay($arr_preselected_storages) {
		$formatted_data = array();
		
		if(!empty($arr_preselected_storages)) {
			foreach ($arr_preselected_storages as $storage_id => $storage_data) {
				$formatted_data[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' ' . $storage_data['StorageMaster']['qc_cusm_label_precision'] .' [' . $storage_data['StorageMaster']['code'] . ' ('.__($storage_data['StorageMaster']['storage_type'], TRUE) .')'. ']';
			}
		}
	
		return $formatted_data;
	}

}	