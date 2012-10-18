<?php
	
	if(empty($errors) && (strpos($aliquot_control['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false)) {
		// Tissue Tube Creation
		$samples_data_from_id = array();
		foreach($this->SampleMaster->find('all', array('conditions' => array('SampleMaster.id' => $sample_master_ids), 'recursive' => 0)) as $tmp_new_samples) $samples_data_from_id[$tmp_new_samples['SampleMaster']['id']] = $tmp_new_samples;
		
		$this->AliquotDetail->addWritableField(array('time_remained_in_rna_later_days'));
		$record_counter = 0;
		foreach($this->request->data as &$created_aliquots){
			$record_counter++;
			$studied_sample = $samples_data_from_id[$created_aliquots['parent']['ViewSample']['sample_master_id']];
			$line_counter = 0;
			foreach($created_aliquots['children'] as &$new_aliquot_for_generated_data) {
				$line_counter++;
				$tmp_res = $this->AliquotMaster->calculateTimeRemainedInRNAlater($studied_sample['Collection']['qcroc_collection_date'], $studied_sample['SpecimenDetail']['qcroc_collection_time'], $new_aliquot_for_generated_data['AliquotMaster']['qcroc_transfer_date_sample_received']);
				if(!empty($tmp_res['error'])) $errors['qcroc_transfer_date_sample_received'][$tmp_res['error']][] = ($is_batch_process? $record_counter : $line_counter);
				$new_aliquot_for_generated_data['AliquotDetail']['time_remained_in_rna_later_days'] = $tmp_res['time_remained'];			
			}
		}
	}
	