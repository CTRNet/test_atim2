<?php
class StorageMasterCustom extends StorageMaster{
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	function summary($variables = array()) {
		$return = false;
	
		if (isset($variables['StorageMaster.id'])) {
			$result = $this->find('first', array('conditions' => array('StorageMaster.id' => $variables['StorageMaster.id'])));
			$title = __($result['StorageControl']['storage_type']);
			if($result['StorageControl']['is_tma_block'] && AppController::getInstance()->Session->read('flag_show_confidential')) {
				$title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
			}
			$return = array(
				'menu' => array(null, ($title . ' : ' . $result['StorageMaster']['short_label'])),
				'title' => array(null, ($title . ' : ' . $result['StorageMaster']['short_label'])),
				'data'				=> $result,
				'structure alias'	=> 'storagemasters'
			);
		}
	
		return $return;
	}
	
	function getLabel(array $children_array, $type_key, $label_key) {
		if(($type_key == 'AliquotMaster')) {
			if(($_SESSION['Auth']['User']['group_id'] != '1')) {
				return $children_array['AliquotMaster']['aliquot_label'].' ['.$children_array['AliquotMaster']['barcode'].']';
			} else {
				$SampleModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
				$sample_data = $SampleModel->find('first', array('conditions' => array('SampleMaster.id' => $children_array['AliquotMaster']['sample_master_id']), 'recursive' => '0'));
				if($sample_data['ViewSample']['qc_tf_bank_participant_identifier'] != CONFIDENTIAL_MARKER) {
					return( $sample_data['ViewSample']['qc_tf_bank_participant_identifier'].
						(isset($sample_data['SampleDetail']['qc_tf_collected_specimen_nature'])? ' '.__($sample_data['SampleDetail']['qc_tf_collected_specimen_nature']) : '').
						' ['.$children_array['AliquotMaster']['barcode'].']' );
				}
			}
		}
		
		return $children_array[$type_key][$label_key];
	}
}