<?php 
	
	if(isset($disease_free_start_trt_id)) {
		$final_options_survival_event['settings']['header'] = __('disease free survival start event');
		$final_options_survival_event['settings']['actions'] = false;
		if($disease_free_start_trt_id != '-1') {
			$final_options_survival_event['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$disease_free_start_trt_id.'/noActions:/filterModel:DiagnosisMaster/filterId:'.$atim_menu_variables['DiagnosisMaster.id']);
			$final_options['links']['bottom']['disease free survival start event'] = 'ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$disease_free_start_trt_id;
		}
		$this->Structures->build(array(), $final_options_survival_event);
	}
	
	if(isset($disease_free_end_bcr_id)) {
		$final_options_survival_bcr['settings']['header'] = __('first biochemical recurrence');
		$final_options_survival_bcr['settings']['actions'] = false;
		if($disease_free_end_bcr_id != '-1') {
			$final_options_survival_bcr['extras'] = $this->Structures->ajaxIndex('/ClinicalAnnotation/DiagnosisMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$disease_free_end_bcr_id.'/noActions:/filterModel:DiagnosisMaster/filterId:'.$atim_menu_variables['DiagnosisMaster.id']);
			$final_options['links']['bottom']['first biochemical recurrence'] = '/ClinicalAnnotation/DiagnosisMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$disease_free_end_bcr_id;
		}
		$this->Structures->build(array(), $final_options_survival_bcr);
	}
