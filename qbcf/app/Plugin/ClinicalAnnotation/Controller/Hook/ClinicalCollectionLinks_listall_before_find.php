<?php 

	$joins[] = array(
		'table' => 'qbcf_tx_breast_diagnostic_events', 
		'alias' => 'TreatmentDetail', 
		'type' => 'LEFT', 
		'conditions' => array('treatment_masters_dup.id = TreatmentDetail.treatment_master_id'));
	