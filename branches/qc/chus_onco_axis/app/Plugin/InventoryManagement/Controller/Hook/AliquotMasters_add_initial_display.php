<?php 
	
	//Get bank name from id
	
	$bank_model = AppModel::getInstance('Administrate', 'Bank');
	$all_banks = array();
	foreach($banks = $bank_model->find('all') as $new_bank) $all_banks[$new_bank['Bank']['id']] = $new_bank;
	
	//Set default data
	
	$default_data = array();
	$tmp_study_data_for_display_from_id = array();
	foreach($this->request->data as &$tmp_new_sample_set) {
		$tmp_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $tmp_new_sample_set['parent']['ViewSample']['sample_master_id']), 'recursive' => '0'));
		
		// 1- aliquot_label + volume
		
		$default_aliquot_label = (isset($all_banks[$tmp_new_sample_set['parent']['ViewSample']['bank_id']])? $all_banks[$tmp_new_sample_set['parent']['ViewSample']['bank_id']]['Bank']['name']: '?').'-'.$tmp_new_sample_set['parent']['ViewSample']['acquisition_label'];
		$tubes_to_create = 1;
		$next_suffix = null;
		switch($tmp_sample_data['SampleControl']['sample_type'].'-'.$aliquot_control['AliquotControl']['aliquot_type']) {
			case 'tissue-tube':
				$tubes_to_create = 6;
				$default_aliquot_label .= '-'.str_replace(array('unkown', 'normal', 'tumour'), array('U', 'N', 'T'), $tmp_sample_data['SampleDetail']['tissue_nature']).'F';
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotDetail.chus_storage_solution'] = 'none (fresh frozen)';
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotDetail.chus_storage_method'] = 'snap frozen';
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotDetail.chus_tissue_size_mm'] = '3X3X3';
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotDetail.chus_tissue_weight_mg'] = '75';
				break;
			case 'tissue-block':
				$tubes_to_create = 1;
				$default_aliquot_label .= '-'.str_replace(array('unkown', 'normal', 'tumour'), array('U', 'N', 'T'), $tmp_sample_data['SampleDetail']['tissue_nature']).'O';
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotDetail.block_type'] = 'OCT';
				break;
			case 'tissue-slide':
				$tubes_to_create = 1;
				$default_aliquot_label .= '-'.str_replace(array('unkown', 'normal', 'tumour'), array('U', 'N', 'T'), $tmp_sample_data['SampleDetail']['tissue_nature']).'O-HE';
				break;
			
			case 'blood-tube':
				$tubes_to_create = 9;
				$default_aliquot_label .= '-B'.
						($tmp_sample_data['SampleDetail']['blood_type'] == 'EDTA'?
								'E' :
								(preg_match('/heparin/', $tmp_sample_data['SampleDetail']['blood_type'])? 'H' : ''));
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotMaster.initial_volume'] = '500';
				break;
			
			case 'plasma-tube':
			case 'buffy coat-tube':
			case 'serum-tube':
				$tubes_to_create = 9;
				$tmp_parent_sample_data = $this->SampleMaster->getOrRedirect($tmp_new_sample_set['parent']['ViewSample']['parent_id']);
				$default_aliquot_label .= '-B'.
					($tmp_parent_sample_data['SampleDetail']['blood_type'] == 'EDTA'?
							'E' :
							(preg_match('/heparin/', $tmp_parent_sample_data['SampleDetail']['blood_type'])? 'H' : '')).
					($tmp_sample_data['SampleControl']['sample_type'] == 'plasma'? 
							'-P' : 
							($tmp_sample_data['SampleControl']['sample_type'] == 'buffy coat'? '-B' : '-?'));
				$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotMaster.initial_volume'] = '500';
				break;
			
			case 'dna-tube':
			case 'rna-tube':
			case 'protein-tube':
				$tubes_to_create = 6;
				$source_aliquots = $this->SourceAliquot->find('all', array('conditions' => array('SourceAliquot.sample_master_id' => $tmp_sample_data['SampleMaster']['id'])));
				if($source_aliquots && sizeof($source_aliquots) == 1) {
					$default_aliquot_label = $source_aliquots[0]['AliquotMaster']['aliquot_label'].'-'.str_replace(array('dna', 'rna', 'protein'), array('DNA', 'RNA', 'PROT'), $tmp_sample_data['SampleControl']['sample_type']);
				} else {
					$next_suffix = '1';
					$default_aliquot_label .= '-?-'.str_replace(array('dna', 'rna', 'protein'), array('DNA', 'RNA', 'PROT'), $tmp_sample_data['SampleControl']['sample_type']);
				}
				break;
				
			default:
				$next_suffix = '1';
				$default_aliquot_label .= '-?';
		}
		
		if(!$next_suffix) {
			$last_suffix = $this->AliquotMaster->find('first', array('conditions' => array("AliquotMaster.aliquot_label REGEXP '^".str_replace('-', '\-', $default_aliquot_label)."\-[0-9]{2}'"), 'fields' => array("SUBSTRING(AliquotMaster.aliquot_label, -2) AS last_id"), 'order' => array('AliquotMaster.aliquot_label DESC'), 'recursive' => '-1'));
			$next_suffix = empty($last_suffix)? '1' : ((int)$last_suffix[0]['last_id'] + 1);
		}
		
		if(isset(AppController::getInstance()->passedArgs['templateInitId'])) {
			$tubes_to_create = $quantity;
		}$tmp_new_sample_set['children'] = array();
		for($tmp_id = 0; $tmp_id < $tubes_to_create; $tmp_id++) {
			$tmp_new_sample_set['children'][]['AliquotMaster']['aliquot_label'] = $default_aliquot_label.'-'.sprintf("%02d", $next_suffix);
			$next_suffix++;
		}
		$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['AliquotMaster.aliquot_label'] = $default_aliquot_label;		
		
		// 2- study_summary_id
		
		if($tmp_new_sample_set['parent']['ViewSample']['chus_default_collection_study_summary_id']) {
			$chus_default_collection_study_summary_id = $tmp_new_sample_set['parent']['ViewSample']['chus_default_collection_study_summary_id'];
			if(!isset($tmp_study_data_for_display_from_id[$chus_default_collection_study_summary_id])) $tmp_study_data_for_display_from_id[$chus_default_collection_study_summary_id] = $this->StudySummary->getStudyDataAndCodeForDisplay(array('StudySummary' => array('id' => $chus_default_collection_study_summary_id)));
			$default_data[$tmp_new_sample_set['parent']['ViewSample']['sample_master_id']]['FunctionManagement.autocomplete_aliquot_master_study_summary_id'] = $tmp_study_data_for_display_from_id[$chus_default_collection_study_summary_id];
		}
	}
	$this->set('default_data', $default_data);
	
?>