<?php 
	
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['links']['bottom'] = array('cancel'=>'/ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventControl.event_group'].'/'.$atim_menu_variables['Participant.id']);
	$final_options['extras'] = '<input type="hidden" name="data[EventMaster][diagnosis_master_id]" value=""/>';
	