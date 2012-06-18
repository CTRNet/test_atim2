<?php
if($this->data['FamilyHistory']['sardo_diagnosis_id']){
	$dx_model = AppModel::getInstance('clinicalannotation', 'DiagnosisMaster', true);
	$dx = $dx_model->find('first', array('conditions' => array('DiagnosisMaster.qc_nd_sardo_id' => $this->data['FamilyHistory']['sardo_diagnosis_id'])));
	if($dx){
		$this->set('sardo_dx_link', '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$dx['DiagnosisMaster']['id']);
	}
}