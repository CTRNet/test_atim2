<?php
class StorageMasterCustom extends StorageMaster {

	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function getLabel(array $children_array, $type_key, $label_key){
		if($type_key = 'AliquotMaster') return $children_array[$type_key]['aliquot_label'];
		return $children_array[$type_key][$label_key];
	}
}

?>
