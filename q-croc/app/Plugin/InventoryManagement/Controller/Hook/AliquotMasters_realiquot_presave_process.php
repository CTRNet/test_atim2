<?php
	
	if(empty($errors) && (strpos($child_aliquot_ctrl['AliquotControl']['detail_form_alias'], 'qcroc_ad_tissue_tubes') !== false)) {
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		//TODO Tissue Tube Creation
// 		$parent_aliquots = $this->AliquotMaster->find('all', array(
// 				'conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids)),
// 				'recursive' => 0,
// 				'joins' => array(
// 					array('table' => 'specimen_details',
// 						'alias' => 'SpecimenDetail',
// 						'type' => 'INNER',
// 						'conditions' => array('SpecimenDetail.sample_master_id = AliquotMaster.sample_master_id')))
				
// 		));
// 		$samples_data_from_id = array();
// 		foreach($parent_aliquots as $tmp_new_samples) $samples_data_from_id[$tmp_new_samples['SampleMaster']['id']] = $tmp_new_samples;
	
// 		$this->AliquotDetail->addWritableField(array('time_remained_in_rna_later_days'));
// 		foreach($this->request->data as &$created_aliquots){
// 			$studied_sample = $samples_data_from_id[$created_aliquots['parent']['AliquotMaster']['sample_master_id']];
// 			foreach($created_aliquots['children'] as &$new_aliquot_for_generated_data) {
// 				$new_aliquot_for_generated_data['AliquotDetail']['time_remained_in_rna_later_days'] = $this->AliquotMaster->calculateTimeRemainedInRNAlater($studied_sample['Collection']['qcroc_collection_date'], $studied_sample['SpecimenDetail']['qcroc_collection_time'], $new_aliquot_for_generated_data['AliquotDetail']['date_sample_received']);
// 			}
// 		}
	}
	