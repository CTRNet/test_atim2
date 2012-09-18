<?php
	
	$default_aliquot_data = array();
	foreach($this->request->data as $new_data_set){
		$tmp_default_aliquot_data = array();
		
		if($new_data_set['parent']['ViewSample']['sample_type'] == 'tissue' && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
			$label_study = (preg_match("/^Q-CROC-([0-9]+)$/", $new_data_set['parent']['ViewSample']['qcroc_protocol'], $matches))? $matches[1] : '?';
			$label_pre_post = '';
			switch($new_data_set['parent']['ViewSample']['qcroc_collection_type']) {
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
					break;
				case '1':
					$label_prefix = '2';
					$tmp_default_aliquot_data['AliquotDetail.tube_type'] = 'rnalater';
					foreach(array('time_placed_at_4c','date_sample_received','temperature_in_box_celsius','sample_condition_at_reception') as $field_name) $tmp_default_aliquot_data['AliquotDetail.'.$field_name] = $existing_tissue_tubes[0]['AliquotDetail'][$field_name];
					break;
				case '2':
					$label_prefix = '3';
					$tmp_default_aliquot_data['AliquotDetail.tube_type'] = 'formaline';
					foreach(array('time_placed_at_4c','date_sample_received','temperature_in_box_celsius','sample_condition_at_reception') as $field_name) $tmp_default_aliquot_data['AliquotDetail.'.$field_name] = $existing_tissue_tubes[1]['AliquotDetail'][$field_name];
					break;
				default:
					break;
			}			
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $label_study.'-'.$label_pre_post.'-'.$label_patient_id.'-'.$label_prefix;
		}
		
		$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
