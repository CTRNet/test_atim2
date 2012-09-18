<?php 

	$joins[] = array('table' => 'qcroc_txd_liver_biopsies', 'alias' => 'TreatmentDetail', 'type' => 'LEFT', 'conditions' => array('TreatmentDetail.treatment_master_id = treatment_masters_dup.id'));
