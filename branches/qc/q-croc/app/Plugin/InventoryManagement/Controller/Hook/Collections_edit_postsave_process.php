<?php

	$new_qcroc_collection_date = $this->request->data['Collection']['qcroc_collection_date']['year'].'-'.$this->request->data['Collection']['qcroc_collection_date']['month'].'-'.$this->request->data['Collection']['qcroc_collection_date']['day'];
	if($collection_data['Collection']['qcroc_collection_date'] != $new_qcroc_collection_date) {
		$this->AliquotDetail = AppModel::getInstance("InventoryManagement", "AliquotDetail", true);
		$this->AliquotDetail->addWritableField(array('time_remained_in_rna_later_days'));
		$condtions = array(
			'AliquotMaster.collection_id' => $collection_id, 
			'SampleControl.sample_type' => 'tissue',
			'AliquotControl.aliquot_type' => 'tube');
		$joins = array(array(
				'table' => 'specimen_details',
				'alias'	=> 'SpecimenDetail',
				'type'	=> 'INNER',
				'conditions' => array('AliquotMaster.sample_master_id = SpecimenDetail.sample_master_id')));
		
		foreach($this->AliquotMaster->find('all', array('conditions' => $condtions, 'joins' => $joins, 'recursive' => 0)) as $new_aliquot_to_update) {		
			$time_remained_in_rna_later_days = $this->AliquotMaster->calculateTimeRemainedInRNAlater($new_qcroc_collection_date, $new_aliquot_to_update['SpecimenDetail']['qcroc_collection_time'], $new_aliquot_to_update['AliquotMaster']['qcroc_transfer_date_sample_received']);
			$this->AliquotMaster->data = array();
			$this->AliquotMaster->id = $new_aliquot_to_update['AliquotMaster']['id'];
			if(!$this->AliquotMaster->save(array('AliquotMaster' => array('id' => $new_aliquot_to_update['AliquotMaster']['id']), 'AliquotDetail' => array('time_remained_in_rna_later_days' => $time_remained_in_rna_later_days)), false)) {
				$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
	}
