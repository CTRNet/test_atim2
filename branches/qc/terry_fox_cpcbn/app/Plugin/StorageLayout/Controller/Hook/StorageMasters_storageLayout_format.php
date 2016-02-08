<?php

if($csv_creation == '2') {
	//Export for review: reformat DisplayData.label
	foreach($data['children'] as &$tmp_children) {
		$AliquotControlModel = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
		$tissue_core_control = $AliquotControlModel->find('first', array('conditions' => array('AliquotControl.databrowser_label' => 'tissue|core')));
		if($tmp_children['DisplayData']['type'] == 'AliquotMaster' && $tmp_children['AliquotMaster']['aliquot_control_id'] == $tissue_core_control['AliquotControl']['id'] && $tmp_children['sample_master_dup']['qc_tf_is_tma_sample_control'] == 'n') {
			$new_label = $tmp_children['DisplayData']['label'];
			if(preg_match('/^([TNUB])(\ \-\ P#\ ([0-9]+)){0,1}/', $new_label, $matches)) {
				$new_label = (isset($matches[3])? $matches[3] : '?')."_".$matches[1];
			}
			$tmp_children['DisplayData']['label'] = $new_label;
		}
	}
}