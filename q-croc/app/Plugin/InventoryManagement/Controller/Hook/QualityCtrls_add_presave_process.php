<?php

	if(empty($errors) && !empty($qc_data_to_save)){
		$record_counter = 0;
		foreach($this->request->data as $qcroc_data_unit){
			$record_counter++;
			$qcroc_sample_data = $qcroc_data_unit['ViewSample'];
			unset($qcroc_data_unit['ViewSample']);	
			foreach($qcroc_data_unit as $quality_control){			
				if($qcroc_sample_data['sample_type'] == 'dna') {
					if($quality_control['QualityCtrl']['type'] != 'picogreen gel') $errors['type']['quality control type and sample type mismatch'][] = $record_counter;
					if(!empty($quality_control['QualityCtrl']['unit'])) $errors['unit']['quality control score unit and sample type mismatch'][] = $record_counter;
				} else {
					if($quality_control['QualityCtrl']['type'] != 'bioanalyzer') $errors['type']['quality control type and sample type mismatch'][] = $record_counter;
					if($quality_control['QualityCtrl']['unit'] != 'rin') $errors['unit']['quality control score unit and sample type mismatch'][] = $record_counter;
				}
			}
		}
	}
	