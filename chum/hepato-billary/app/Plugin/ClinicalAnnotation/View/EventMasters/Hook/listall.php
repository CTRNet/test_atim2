<?php

	if(isset($summary_event_button)) {
		foreach($summary_event_button as $new_button) $final_options['links']['bottom'][$new_button['title']] = array('link' => $new_button['link'], 'icon' => 'add');		
	}
	
	if($atim_menu_variables['EventMaster.event_group'] == 'scores' && isset($controls_for_subform_display) && !empty($controls_for_subform_display)) {
		$tmp_controls_for_subform_display = array('fong score' => null, 'child pugh score (classic)' => null);
		foreach($controls_for_subform_display as $new_control) $tmp_controls_for_subform_display[$new_control['EventControl']['event_type']] = $new_control;
		$controls_for_subform_display = $tmp_controls_for_subform_display;	
	}
	
?>
