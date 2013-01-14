<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';
	
	function regenerateAliquotBarcode() {
		$aliquots_to_update = $this->find('all', array('conditions' => array("AliquotMaster.barcode IS NULL OR AliquotMaster.barcode LIKE ''"), 'fields' => array('AliquotMaster.id')));
		foreach($aliquots_to_update as $new_aliquot) {
			$new_aliquot_id = $new_aliquot['AliquotMaster']['id'];
			$aliquot_data = array('AliquotMaster' => array('barcode' => $new_aliquot_id), 'AliquotDetail' => array());
				
			$this->id = $new_aliquot_id;
			$this->data = null;
			$this->addWritableField(array('barcode'));
			$this->save($aliquot_data, false);
		}
	}
	
	function updateTimeRemainedInRNAlater($collection_id, $sample_master_id = null, $aliquot_master_id = null) {
pr("updateTimeRemainedInRNAlater($collection_id, $sample_master_id, $aliquot_master_id");	
		$this->addWritableField(array('time_remained_in_rna_later_days'));	
		
		//Get All Tissue Tubes To Review
		$conditions = array(
			'Collection.id' => $collection_id,
			'SampleControl.sample_type' => 'tissue',
			'AliquotControl.aliquot_type' => 'tube');
		if($sample_master_id) $conditions['AliquotMaster.sample_master_id'] = $sample_master_id;
		if($aliquot_master_id) $conditions['AliquotMaster.id'] = $aliquot_master_id;
		$joins = array(
			array('table' => 'sd_spe_tissues',
				'alias' => 'SampleDetail',
				'type' => 'INNER',
				'conditions' => array('SampleDetail.sample_master_id = AliquotMaster.sample_master_id')),
			array('table' => 'specimen_details',
				'alias' => 'SpecimenDetail',
				'type' => 'INNER',
				'conditions' => array('SpecimenDetail.sample_master_id = AliquotMaster.sample_master_id')));
		$tissue_tubes = $this->find('all', array('conditions' => $conditions, 'joins' => $joins, 'recursive' => '0'));
				
		$aliquots_to_update = array();
		$warnings = array();
		foreach($tissue_tubes as $new_tissue_tube) {
			//New tissue tube	
			$tissue_tube_aliquot_master_id = $new_tissue_tube['AliquotMaster']['id'];
			$tissue_tube_qcroc_barcode = $new_tissue_tube['AliquotMaster']['qcroc_barcode'];
			$old_time_remained_in_rna_later_days = $new_tissue_tube['AliquotDetail']['time_remained_in_rna_later_days'];
			
			$qcroc_collection_date = $new_tissue_tube['Collection']['qcroc_collection_date'];
			$qcroc_collection_date_accuracy = $new_tissue_tube['Collection']['qcroc_collection_date_accuracy'];
			$qcroc_collection_time = $new_tissue_tube['SpecimenDetail']['qcroc_collection_time'];
			$processing_date = null;
			$processing_date_accuracy = null;			
			
			$new_time_remained_in_rna_later_days = '';
				
			if($new_tissue_tube['SampleDetail']['qcroc_tissue_storage_solution'] != 'rnalater'){
				//Tissue tube in formalin
				$new_time_remained_in_rna_later_days = '';
			} else {
				//Tissue tube in RNA later: Get blocks created from tubes
				$conditions = array(
					'Realiquoting.parent_aliquot_master_id' => $tissue_tube_aliquot_master_id,
					'Realiquoting.deleted <> 1',
					'AliquotControl.aliquot_type' => 'block',
					"Realiquoting.realiquoting_datetime != ''");
				$joins = array(
					array('table' => 'realiquotings',
						'alias' => 'Realiquoting',
						'type' => 'INNER',
						'conditions' => array('Realiquoting.child_aliquot_master_id = AliquotMaster.id')));
				$blocks = $this->find('all', array('conditions' => $conditions, 'joins' => $joins, 'recursive' => '0', 'order' => array('Realiquoting.realiquoting_datetime asc')));				
				foreach($blocks as $new_block) {
					if(!$processing_date && !empty($new_block['Realiquoting']['realiquoting_datetime'])) {
						$processing_date = $new_block['Realiquoting']['realiquoting_datetime'];
						$processing_date_accuracy = $new_block['Realiquoting']['realiquoting_datetime_accuracy'];
					}
				}
				if(!$processing_date) {
					$new_time_remained_in_rna_later_days = '';
				} else {
					//gere les accuracy + calcul
					if(!$qcroc_collection_date) {
						$new_time_remained_in_rna_later_days = '';
					} else if(in_array($processing_date_accuracy, array('c','i','h')) && $qcroc_collection_date_accuracy = 'c') {
						//On calcul
						if(in_array($processing_date_accuracy, array('i','h')) || empty($qcroc_collection_time)) {
							$warnings[__('time sample remained in rnalater has been calulcated on estimated dates')][] = $tissue_tube_qcroc_barcode;
							if(empty($qcroc_collection_time)) $qcroc_collection_time = '00:01:00';
						}
						$res  = $this->getSpentTime($qcroc_collection_date.' '.$qcroc_collection_time, $processing_date);
						if(!empty($res['message'])) {
							$new_time_remained_in_rna_later_days = '';
							$warnings[__('unable to calculate time sample remained in rnalater'). ' (' .  __($res['message']) .')'][] = $tissue_tube_qcroc_barcode;
						} else {
							$new_time_remained_in_rna_later_days = $res['days'];
						}
					} else {
						$new_time_remained_in_rna_later_days = '';
						$warnings[__('unable to calculate time sample remained in rnalater on estimated collection dates')][] = $tissue_tube_qcroc_barcode;
					}
				}
			}
			
pr("*** $tissue_tube_qcroc_barcode *** [$qcroc_collection_date($qcroc_collection_date_accuracy)|$qcroc_collection_time=>$processing_date($processing_date_accuracy) ccl: $old_time_remained_in_rna_later_days => $new_time_remained_in_rna_later_days ");			
			
			if($old_time_remained_in_rna_later_days != $new_time_remained_in_rna_later_days) {
				$aliquot_data_to_update = array(
					'AliquotMaster' => array('id' => $tissue_tube_aliquot_master_id),
					'AliquotDetail' => array('time_remained_in_rna_later_days' => $new_time_remained_in_rna_later_days));
				$this->data = array();
				$this->id = $tissue_tube_aliquot_master_id;
				if(!$this->save($aliquot_data_to_update, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		foreach($warnings as $new_msg => $tubes) {
			AppController::addWarningMsg($new_msg.' '.(str_replace('%s',implode(', ',$tubes),__('see tissue tube(s) # %s'))));
		}
		return;			
	}
}

?>
