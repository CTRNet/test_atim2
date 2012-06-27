<?php
class StorageMasterCustom extends StorageMaster{
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function getLabel($children_array, $type_key, $label_key){
		//USE THIS TO OVERRIDE THE DEFAULT LABEL
		if($type_key == 'AliquotMaster'){
			$label_key = 'aliquot_label';
		}
		return parent::getLabel($children_array, $type_key, $label_key);
	}
}