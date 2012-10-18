<?php

	if($submitted_data_validates && (strpos($aliquot_data['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false) && $aliquot_data['AliquotMaster']['qcroc_transfer_date_sample_received'] != $this->request->data['AliquotMaster']['qcroc_transfer_date_sample_received']) {
		$tmp_new_samples = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $aliquot_data['SampleMaster']['id']), 'recursive' => 0));
		if(empty($tmp_new_samples)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
		$this->AliquotDetail->addWritableField(array('time_remained_in_rna_later_days'));
		$tmp_res = $this->AliquotMaster->calculateTimeRemainedInRNAlater($aliquot_data['Collection']['qcroc_collection_date'], $tmp_new_samples['SpecimenDetail']['qcroc_collection_time'], $this->request->data['AliquotMaster']['qcroc_transfer_date_sample_received']);
		if(!empty($tmp_res['error'])) {
			$this->AliquotMaster->validationErrors['qcroc_transfer_date_sample_received'][] = $tmp_res['error'];
			$submitted_data_validates = false;
		}
		$this->request->data['AliquotDetail']['time_remained_in_rna_later_days'] = $tmp_res['time_remained'];
	}
	
	