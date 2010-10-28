<?php
class StorageMastersControllerCustom extends StorageMastersController {
	function getLabel($children_array, $type_key, $label_key){
		if($type_key == 'AliquotMaster') {
			return $children_array[$type_key]['qc_hb_label'];
		}
				
		return parent::getLabel($children_array, $type_key, $label_key);
	}
}
?>