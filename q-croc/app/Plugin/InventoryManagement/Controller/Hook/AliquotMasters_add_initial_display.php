<?php
	
	$default_aliquot_data = array();
	
	if($this->request->data[0]['parent']['ViewSample']['sample_type'] == 'tissue' && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
		
		// ************ TISSUE TUBE ***************************
		
		foreach($this->request->data as $new_data_set){
			$tmp_default_aliquot_data = array();
		
			// Get all collection tissue data
			$tmp_full_tissues_data = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $new_data_set['parent']['ViewSample']['collection_id']), 'recursive' => 0));
			$full_tissues_data_from_id = array();
			$tissue_counter = 0;
			foreach($tmp_full_tissues_data as $tmp_rec) {
				$full_tissues_data_from_id[$tmp_rec['SampleMaster']['id']] = $tmp_rec;
				if($tmp_rec['SampleControl']['sample_type'] = 'tissue') $tissue_counter++;
			}
			
			$label_study = (preg_match("/^Q-CROC-([0-9]+)$/", $new_data_set['parent']['ViewSample']['qcroc_protocol'], $matches))? $matches[1] : '?';
			$label_pre_post = '?';
			switch($new_data_set['parent']['ViewSample']['qcroc_biopsy_type']) {
				case 'pre':
					$label_pre_post = '1';
					break;
				case 'post':
					$label_pre_post = '2';
					break;
				default:
			}
			$label_patient_id = empty($new_data_set['parent']['ViewSample']['participant_identifier'])? '?' : $new_data_set['parent']['ViewSample']['participant_identifier'];
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $label_study.'-'.$label_pre_post.'-'.$label_patient_id.'-'.(in_array($tissue_counter, array('1','2','3'))? $tissue_counter : '?');
					
			$fields_to_duplicate = array();
			switch($tissue_counter) {
				case '1':
					// ** FIRST TISSUE => rnalater
					$tmp_default_aliquot_data['AliquotDetail.tube_type'] = 'rnalater';
					$tmp_default_aliquot_data['AliquotDetail.time_placed_at_4c'] = $full_tissues_data_from_id[$new_data_set['parent']['ViewSample']['sample_master_id']]['SpecimenDetail']['qcroc_collection_time'];
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_shipping_date'] = $full_tissues_data_from_id[$new_data_set['parent']['ViewSample']['sample_master_id']]['Collection']['qcroc_collection_date'];
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_type'] = 'site to HDQ';
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_date_sample_received'] = date('Y-m-d');
					$tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = date('Y-m-d');
					break;
				
				case '2':
					// ** SCD TISSUE => rnalater
					$tmp_default_aliquot_data['AliquotDetail.tube_type'] = 'rnalater';
					$fields_to_duplicate = array(
							'AliquotMaster'  => array(
									'in_stock',
									'in_stock_detail',
									'storage_datetime',
									'qcroc_transfer_type',
									'qcroc_transfer_shipping_nbr',
									'qcroc_transfer_shipping_date',
									'qcroc_transfer_by',
									'qcroc_transfer_to',
									'qcroc_transfer_conditions',
									'qcroc_transfer_method_of_dispatch',
									'qcroc_transfer_date_sample_received',
									'qcroc_transfer_temperature_in_box_celsius',
									'qcroc_transfer_sample_condition_at_reception'),
							'AliquotDetail'  => array(
									'time_placed_at_4c'),
							'FunctionManagement' => array(
									'recorded_storage_selection_label')
					);
					break;
					
				case '3':
					// ** THIRD TISSUE => formaline
					$tmp_default_aliquot_data['AliquotDetail.tube_type'] = 'formaline';
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_type'] = 'site to JGH';
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_date_sample_received'] = date('Y-m-d');
					$tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = date('Y-m-d');
					$fields_to_duplicate = array(
							'AliquotMaster'  => array(
									'qcroc_transfer_type',
									'qcroc_transfer_shipping_date',
									'qcroc_transfer_by',
									'qcroc_transfer_conditions',
									'qcroc_transfer_method_of_dispatch'),
							'AliquotDetail'  => array(
									'time_placed_at_4c')
					);
					break;
					
				default:
					break;
			}			
			if($fields_to_duplicate) {
				$joins = array(array(
					'table' => 'qcroc_ad_tissue_tubes',
					'alias'	=> 'AliquotDetail',
					'type'	=> 'INNER',
					'conditions' => array('AliquotMaster.id = AliquotDetail.aliquot_master_id', 'AliquotMaster.deleted <> 1')
				));
				$existing_tissue_tubes = $this->AliquotMaster->find('first', array('conditions' => array('AliquotMaster.collection_id' => $new_data_set['parent']['ViewSample']['collection_id']), 'joins' => $joins, 'recursive' => '0', 'orders' => array('AliquotMaster.created DESC')));
				if(empty($existing_tissue_tubes)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				
				foreach($fields_to_duplicate as $model => $model_field_names) {
					foreach($model_field_names as $field_name) {
						if(($model.'.'.$field_name) == 'FunctionManagement.recorded_storage_selection_label') {
							$tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $existing_tissue_tubes['StorageMaster']['selection_label'];
						} else {
							$tmp_default_aliquot_data[$model.'.'.$field_name] = $existing_tissue_tubes[$model][$field_name];
						}	
					}
				}
			}
			
			$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
		}
		
	} else if(in_array($this->request->data[0]['parent']['ViewSample']['sample_type'], array('blood','pbmc','plasma')) && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
		
		// ************ TISSUE TUBE ***************************
		
		foreach($this->request->data as $new_data_set){
			$tmp_default_aliquot_data = array();
		
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'n/a';
			
			$default_nbr_of_tubes = 0;
			switch($this->request->data[0]['parent']['ViewSample']['sample_type']) {
				case 'blood':
					$tmp_default_aliquot_data['AliquotMaster.qcroc_barcode'] = 'n/a';
					break;
				case 'plasma':
					$default_nbr_of_tubes += 5;
				case 'pbmc':
					$default_nbr_of_tubes += 5;
					$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '500';
					break;		
			}	
			
			$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
			
			while(sizeof($this->request->data[0]['children']) < $default_nbr_of_tubes) $this->request->data[0]['children'][] = array();
		}
		
		
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
