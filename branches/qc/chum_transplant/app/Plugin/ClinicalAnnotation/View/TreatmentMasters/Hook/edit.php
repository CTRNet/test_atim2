<?php 
	
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['links']['bottom'] = array('cancel'=>'/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']);
	$final_options['extras'] = '<input type="hidden" name="data[TreatmentMaster][diagnosis_master_id]" value=""/>';
	