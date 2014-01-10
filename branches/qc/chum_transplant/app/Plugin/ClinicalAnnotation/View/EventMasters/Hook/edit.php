<?php 
	
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['links']['bottom'] = array('cancel'=>'/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id']);
	$final_options['extras'] = '<input type="hidden" name="data[EventMaster][diagnosis_master_id]" value=""/>';
	