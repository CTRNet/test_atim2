<?php

	// STEP 2: Get tissue block for sampling, etc
	$qcroc_conditions = array(
			'AliquotMaster.collection_id' => $collection_id,
			'SampleControl.sample_type' => 'tissue',
			'AliquotControl.aliquot_type' => array('block'));
	$tissue_blocks_for_sampling_and_processing = $this->AliquotMaster->find('all', array('conditions' => $qcroc_conditions, 'recursive' => '0'));
	if(!empty($tissue_blocks_for_sampling_and_processing)) {
		$this->set('tissue_blocks_for_sampling_and_processing', $tissue_blocks_for_sampling_and_processing);
	
	} else {
		// STEP 1: Get tissue tube for OCT embedding or transfer
		$qcroc_conditions = array(
				'AliquotMaster.collection_id' => $collection_id,
				'SampleControl.sample_type' => 'tissue',
				'AliquotControl.aliquot_type' => array('tube'),
				'AliquotDetail.tube_type' => 'rnalater');
		$joins = array(array(
				'table' => 'qcroc_ad_tissue_tubes',
				'alias'	=> 'AliquotDetail',
				'type'	=> 'INNER',
				'conditions' => array('AliquotMaster.id = AliquotDetail.aliquot_master_id', 'AliquotMaster.deleted <> 1')
		));
		$tissue_tubes = $this->AliquotMaster->find('all', array('conditions' => $qcroc_conditions, 'joins' => $joins, 'recursive' => '0'));
		$this->set('tissue_tubes_for_embedding', $tissue_tubes);
		$this->set('tissue_tubes_for_transfering', $tissue_tubes);
	}
		
	