<?php
	
	$default_aliquot_labels = array();
	$study_data_for_display = array();
	foreach($this->data as $new_data_set){
		if(preg_match('/^(.*)\-([0-9]{2})$/', $new_data_set['parent']['AliquotMaster']['aliquot_label'], $matches)) {
			$aliquot_label_prefix = $matches[1];
			$last_suffix = $this->AliquotMaster->find('first', array('conditions' => array("AliquotMaster.aliquot_label REGEXP '^".str_replace('-', '\-', $aliquot_label_prefix)."\-[0-9]{2}'"), 'fields' => array("SUBSTRING(AliquotMaster.aliquot_label, -2) AS last_id"), 'order' => array('AliquotMaster.aliquot_label DESC'), 'recursive' => '-1'));
			$next_suffix = empty($last_suffix)? '1' : ((int)$last_suffix[0]['last_id'] + 1);
			$default_aliquot_labels[$new_data_set['parent']['AliquotMaster']['id']] = $aliquot_label_prefix.'-'.sprintf("%02d", $next_suffix);
		}
	}
	$this->set('default_aliquot_labels', $default_aliquot_labels);
	
?>
