<?php
	
	$default_data = array();
	$chus_default_collection_study_summary_id = array();
	foreach($this->data as $new_data_set){
		$tmp_parent_aliquot_master_id = $new_data_set['parent']['AliquotMaster']['id'];
		//Set default aliquot label
		if(preg_match('/^(.*)\-([0-9]{2})$/', $new_data_set['parent']['AliquotMaster']['aliquot_label'], $matches)) {
			$aliquot_label_prefix = $matches[1];
			$last_suffix = $this->AliquotMaster->find('first', array('conditions' => array("AliquotMaster.aliquot_label REGEXP '^".str_replace('-', '\-', $aliquot_label_prefix)."\-[0-9]{2}'"), 'fields' => array("SUBSTRING(AliquotMaster.aliquot_label, -2) AS last_id"), 'order' => array('AliquotMaster.aliquot_label DESC'), 'recursive' => '-1'));
			$next_suffix = empty($last_suffix)? '1' : ((int)$last_suffix[0]['last_id'] + 1);
			$default_data[$tmp_parent_aliquot_master_id]['AliquotMaster.aliquot_label'] = $aliquot_label_prefix.'-'.sprintf("%02d", $next_suffix);
		}
		//Set default study
		if(strlen($new_data_set['parent']['Collection']['chus_default_collection_study_summary_id']) && $new_data_set['parent']['Collection']['chus_default_collection_study_summary_id']  == $new_data_set['parent']['AliquotMaster']['study_summary_id']) {
			$chus_default_collection_study_summary_id = $new_data_set['parent']['Collection']['chus_default_collection_study_summary_id'];
			if(!isset($tmp_study_data_for_display_from_id[$chus_default_collection_study_summary_id])) $tmp_study_data_for_display_from_id[$chus_default_collection_study_summary_id] = $this->StudySummary->getStudyDataAndCodeForDisplay(array('StudySummary' => array('id' => $chus_default_collection_study_summary_id)));
			$default_data[$tmp_parent_aliquot_master_id]['FunctionManagement.autocomplete_aliquot_master_study_summary_id'] = $tmp_study_data_for_display_from_id[$chus_default_collection_study_summary_id];
			$default_data[$tmp_parent_aliquot_master_id]['AliquotMaster.in_stock'] = 'yes - not available';
			$default_data[$tmp_parent_aliquot_master_id]['AliquotMaster.in_stock_detail'] = 'reserved for study';
		}
	}
	$this->set('default_data', $default_data);
	
?>
