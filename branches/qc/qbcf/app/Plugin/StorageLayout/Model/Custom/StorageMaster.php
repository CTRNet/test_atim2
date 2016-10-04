<?php
class StorageMasterCustom extends StorageMaster{
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function summary($variables = array()) {}
	
	function getLabel(array $children_array, $type_key, $label_key) {
		if(isset($children_array[$type_key]['qbcf_generated_label_for_display'])) {
			return $children_array[$type_key]['qbcf_generated_label_for_display'];
		}
		return $children_array[$type_key][$label_key];
	}
	
}