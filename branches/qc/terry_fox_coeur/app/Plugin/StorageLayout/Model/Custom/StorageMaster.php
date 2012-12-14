<?php

class StorageMasterCustom extends StorageMaster {
	
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function getLabel(array $children_array, $type_key, $label_key){
		if($type_key == 'AliquotMaster') {
			$SampleModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
			$sample_data = $SampleModel->find('first', array('conditions' => array('SampleMaster.id' => $children_array['AliquotMaster']['sample_master_id']), 'recursive' => '0'));		
			if($sample_data['ViewSample']['qc_tf_bank_identifier'] != CONFIDENTIAL_MARKER) {
				return $children_array['AliquotMaster']['aliquot_label'].' ['.$children_array['AliquotMaster']['barcode'].']'.' <FONT color=\'red\'>'.$sample_data['ViewSample']['qc_tf_bank_identifier'].'</FONT>';
			} else {
				return $children_array['AliquotMaster']['aliquot_label'].' ['.$children_array['AliquotMaster']['barcode'].']';
			}
		}
		
		return $children_array[$type_key][$label_key];
	}


}

?>
