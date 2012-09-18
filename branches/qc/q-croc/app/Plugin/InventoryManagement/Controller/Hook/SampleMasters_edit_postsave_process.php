<?php
	
	if($sample_data['SampleControl']['sample_type'] == 'tissue') {
		$old_qcroc_collection_time = $sample_data['SpecimenDetail']['qcroc_collection_time'];
		$new_qcroc_collection_time = $this->request->data['SpecimenDetail']['qcroc_collection_time'];
		
		if($old_qcroc_collection_time != $new_qcroc_collection_time) {
			$this->AliquotDetail = AppModel::getInstance("InventoryManagement", "AliquotDetail", true);
			$this->AliquotDetail->addWritableField(array('time_remained_in_rna_later_days'));
			$condtions = array(
					'AliquotMaster.sample_master_id' => $sample_master_id,
					'AliquotControl.aliquot_type' => 'tube');
			$joins = array(array(
					'table' => 'specimen_details',
					'alias'	=> 'SpecimenDetail',
					'type'	=> 'INNER',
					'conditions' => array('AliquotMaster.sample_master_id = SpecimenDetail.sample_master_id')));
			foreach($this->AliquotMaster->find('all', array('conditions' => $condtions, 'joins' => $joins, 'recursive' => 0)) as $new_aliquot_to_update) {
				$time_remained_in_rna_later_days = $this->AliquotMaster->calculateTimeRemainedInRNAlater($sample_data['Collection']['qcroc_collection_date'], $new_qcroc_collection_time, $new_aliquot_to_update['AliquotDetail']['date_sample_received']);			
				$this->AliquotMaster->data = array();
				$this->AliquotMaster->id = $new_aliquot_to_update['AliquotMaster']['id'];
				if(!$this->AliquotMaster->save(array('AliquotMaster' => array('id' => $new_aliquot_to_update['AliquotMaster']['id']), 'AliquotDetail' => array('time_remained_in_rna_later_days' => $time_remained_in_rna_later_days)), false)) {
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			}
		}
		
	}
	