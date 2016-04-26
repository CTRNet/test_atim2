<?php

if($csv_creation > 1) {
	//Export for review: reformat DisplayData.label
	foreach($data['children'] as &$tmp_children) {
		$AliquotControlModel = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
		$tissue_core_control = $AliquotControlModel->find('first', array('conditions' => array('AliquotControl.databrowser_label' => 'tissue|core')));
		if($tmp_children['DisplayData']['type'] == 'AliquotMaster' && $tmp_children['AliquotMaster']['aliquot_control_id'] == $tissue_core_control['AliquotControl']['id'] && $tmp_children['sample_master_dup']['qc_tf_is_tma_sample_control'] == 'n') {
			if(preg_match('/^([TNUB])(\ \-\ P#\ ([0-9]+)){0,1}/', $tmp_children['DisplayData']['label'], $matches)) {
				$atim_participant_nbr = isset($matches[3])? $matches[3] : '?';
				$aliquot_label_being_nature = $matches[1];
				$aliquot_tfri_nbr = $tmp_children['AliquotMaster']['barcode'];
				switch($csv_creation) {
					case '2':
						// for review (participant_identifier+aliquot_label) :: ATiM Participant # + Aliquot TFRI Label (Nature)
						$tmp_children['DisplayData']['label'] = $atim_participant_nbr."_".$aliquot_label_being_nature;
						break;
					case '3':
						// for review (participant_identifier+aliquot_label+aliquot_barcode) :: ATiM Participant # + Aliquot TFRI Label (Nature) + Aliquot TFRI# 
						$tmp_children['DisplayData']['label'] = $atim_participant_nbr."_".$aliquot_label_being_nature."_".$aliquot_tfri_nbr;
						break;
					case '4':
						// for review (aliquot_label+aliquot_barcode) :: Aliquot TFRI Label (Nature) + Aliquot TFRI# 
						$tmp_children['DisplayData']['label'] = $aliquot_label_being_nature."_".$aliquot_tfri_nbr;
						break;
					default:
				}
			}
		}
	}
}
		