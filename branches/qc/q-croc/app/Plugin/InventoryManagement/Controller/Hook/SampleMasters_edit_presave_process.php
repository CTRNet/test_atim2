<?php
	
	$aliquots_to_update = array();
	if($sample_data['SampleControl']['sample_type'] == 'tissue') {
		if($sample_data['SpecimenDetail']['qcroc_collection_time'] != $this->request->data['SpecimenDetail']['qcroc_collection_time']) {
			$condtions = array(
					'AliquotMaster.sample_master_id' => $sample_master_id,
					'AliquotControl.aliquot_type' => 'tube');
			$joins = array(array(
					'table' => 'specimen_details',
					'alias'	=> 'SpecimenDetail',
					'type'	=> 'INNER',
					'conditions' => array('AliquotMaster.sample_master_id = SpecimenDetail.sample_master_id')));
			foreach($this->AliquotMaster->find('all', array('conditions' => $condtions, 'joins' => $joins, 'recursive' => 0)) as $new_aliquot_to_update) {
				$tmp_res = $this->AliquotMaster->calculateTimeRemainedInRNAlater($sample_data['Collection']['qcroc_collection_date'], $this->request->data['SpecimenDetail']['qcroc_collection_time'], $new_aliquot_to_update['AliquotMaster']['qcroc_transfer_date_sample_received']);			
				$aliquots_to_update[] = array('AliquotMaster' => array('id' => $new_aliquot_to_update['AliquotMaster']['id']), 'AliquotDetail' => array('time_remained_in_rna_later_days' => $tmp_res['time_remained']));
				if(!empty($tmp_res['error'])) {
					$submitted_data_validates = false;
					$this->SampleMaster->validationErrors['qcroc_collection_time'][$tmp_res['error']] = $tmp_res['error'];
				}
			}
		}
		
	}
	