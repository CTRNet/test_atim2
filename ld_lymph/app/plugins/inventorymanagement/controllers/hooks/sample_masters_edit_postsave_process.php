<?php

	if($is_specimen && $this->data['SampleMaster']['ld_lymph_specimen_number'] != $sample_data['SampleMaster']['ld_lymph_specimen_number']) {
		$ld_lymph_specimen_number = $this->data['SampleMaster']['ld_lymph_specimen_number'];
		$all_derivatives = $this->SampleMaster->find('all', array('conditions'=> array('SampleMaster.initial_specimen_sample_id' => $sample_master_id, "SampleMaster.id != $sample_master_id"), 'recursive' => '-1'));
		if(!empty($all_derivatives)) {
			$all_derivatives_to_update = array();
			foreach($all_derivatives as $samp_to_update) {
				$all_derivatives_to_update[] = array('SampleMaster' => array('id'=>$samp_to_update['SampleMaster']['id'], 'ld_lymph_specimen_number'=>$ld_lymph_specimen_number));	
			}
			$this->SampleMaster->data = array();
			$this->SampleMaster->id = null;
			if(!$this->SampleMaster->saveAll($all_derivatives_to_update, array('validate' => false))) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}