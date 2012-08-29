<?php

	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['settings']['header'] = __('medications');
	unset($final_options['links']['bottom']['add precision']);
	$final_options['links']['bottom']['add medications'] = '/ClinicalAnnotation/TreatmentExtends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'];
	