<?php 

	$joins[] = array('table' => 'qbcf_dx_breasts', 'alias' => 'DiagnosisDetail', 'type' => 'LEFT', 'conditions' => array('Collection.diagnosis_master_id = DiagnosisDetail.diagnosis_master_id'));