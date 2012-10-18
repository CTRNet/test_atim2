<?php
	
	$default_aliquot_data = array();
	if($this->request->data[0]['parent']['ViewSample']['sample_type'] == 'tissue' && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
		// Set default data for tissue tubes
		
		// Get full tissue data
		$tmp_full_tissues_data = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.id' => $sample_master_ids), 'recursive' => 0));
		$full_tissues_data_from_id = array();
		foreach($tmp_full_tissues_data as $tmp_rec) $full_tissues_data_from_id[$tmp_rec['SampleMaster']['id']] = $tmp_rec;

		foreach($this->request->data as $new_data_set){
			$tmp_default_aliquot_data = array();
		
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
			$label_prefix = '?';
			$joins = array(array(
					'table' => 'qcroc_ad_tissue_tubes',
					'alias'	=> 'AliquotDetail',
					'type'	=> 'INNER',
					'conditions' => array('AliquotMaster.id = AliquotDetail.aliquot_master_id', 'AliquotMaster.deleted <> 1')
			));
			$existing_tissue_tubes = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.collection_id' => $new_data_set['parent']['ViewSample']['collection_id']), 'joins' => $joins, 'recursive' => '0'));
			switch(sizeof($existing_tissue_tubes)) {
				case '0':
					$label_prefix = '1';
					$tmp_default_aliquot_data['AliquotDetail.tube_type'] = 'rnalater';
					$tmp_default_aliquot_data['AliquotDetail.time_placed_at_4c'] = $full_tissues_data_from_id[$new_data_set['parent']['ViewSample']['sample_master_id']]['SpecimenDetail']['qcroc_collection_time'];
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_shipping_date'] = $full_tissues_data_from_id[$new_data_set['parent']['ViewSample']['sample_master_id']]['Collection']['qcroc_collection_date'];
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_type'] = 'site to HDQ';
					$tmp_default_aliquot_data['AliquotMaster.qcroc_transfer_date_sample_received'] = date('Y-m-d');
					$tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = date('Y-m-d');
					break;
				case '1':
					$label_prefix = '2';
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
									'time_placed_at_4c')
					);
					foreach($fields_to_duplicate as $model => $model_field_names) {
						foreach($model_field_names as $field_name) {
							$tmp_default_aliquot_data[$model.'.'.$field_name] = $existing_tissue_tubes[0][$model][$field_name];
						}
					}
					$tmp_default_aliquot_data['FunctionManagement.recorded_storage_selection_label'] = $existing_tissue_tubes[0]['StorageMaster']['selection_label'];
					break;
				case '2':
					$label_prefix = '3';
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
					foreach($fields_to_duplicate as $model => $model_field_names) {
						foreach($model_field_names as $field_name) {
							$tmp_default_aliquot_data[$model.'.'.$field_name] = $existing_tissue_tubes[0][$model][$field_name];
						}
					}
					break;
				default:
					break;
			}
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $label_study.'-'.$label_pre_post.'-'.$label_patient_id.'-'.$label_prefix;
			
			$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
		}
	}
		
	$this->set('default_aliquot_data', $default_aliquot_data);
