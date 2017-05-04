<?php 

	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	foreach($this->request->data as &$unit){
		$sample_types = array();
		foreach($unit['SampleMaster'] as $new_sample) $sample_types[__($new_sample['initial_specimen_sample_type'])] = '';
		ksort($sample_types);
		$unit['Generated']['procure_generated_sample_types'] = implode(', ', array_keys($sample_types));
	}
	