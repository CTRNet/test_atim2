<?php
class StorageMasterCustom extends StorageMaster{
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function getLabel(array $children_array, $type_key, $label_key){
		//USE THIS TO OVERRIDE THE DEFAULT LABEL
		if($type_key == 'AliquotMaster'){
			return $children_array[$type_key]['aliquot_label'].' ['.$children_array[$type_key]['barcode'].']';
		}
		return parent::getLabel($children_array, $type_key, $label_key);
	}
}