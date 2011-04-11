<?php
class StorageMastersControllerCustom extends StorageMastersController {
	function getLabel($children_array, $type_key, $label_key){
		//USE THIS TO OVERRIDE THE DEFAULT LABEL
		if($type_key == 'AliquotMaster') $label_key = 'aliquot_label';
		return parent::getLabel($children_array, $type_key, $label_key);
	}
}
?>