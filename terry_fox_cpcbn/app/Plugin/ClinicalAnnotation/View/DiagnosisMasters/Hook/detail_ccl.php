<?php 
	
	if(isset($disease_free_start_trt_id)) {
		$final_options_survival_event['settings']['header'] = __('disease free survival start event');
		$final_options_survival_event['settings']['actions'] = false;
		if($disease_free_start_trt_id != '-1') $final_options_survival_event['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$disease_free_start_trt_id.'/noActions:/filterModel:DiagnosisMaster/filterId:'.$atim_menu_variables['DiagnosisMaster.id']);
		$this->Structures->build(array(), $final_options_survival_event);
	}
