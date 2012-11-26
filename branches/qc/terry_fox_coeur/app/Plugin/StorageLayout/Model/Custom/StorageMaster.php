<?php

class StorageMasterCustom extends StorageMaster {
	
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function getLabel(array $children_array, $type_key, $label_key){
		if(($type_key == 'AliquotMaster') && AppController::getInstance()->Session->read('flag_show_confidential')) {
			return $children_array['AliquotMaster']['aliquot_label'].' ['.$children_array['AliquotMaster']['barcode'].']';
		}
		
		return $children_array[$type_key][$label_key];
	}

}

?>
