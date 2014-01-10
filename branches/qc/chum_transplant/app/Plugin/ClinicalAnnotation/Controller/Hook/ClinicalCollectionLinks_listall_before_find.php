<?php 
	
	$joins[] = array('table' => 'chum_transplant_txd_transplants', 'alias' => 'TreatmentDetail', 'type' => 'LEFT', 'conditions' => array('Collection.treatment_master_id = TreatmentDetail.treatment_master_id'));
