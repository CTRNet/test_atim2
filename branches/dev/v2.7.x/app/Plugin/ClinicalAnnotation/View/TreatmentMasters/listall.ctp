<?php
$structure_links = array(
	'index' => array(
		'detail' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $atim_menu_variables['Participant.id'] . '/%%TreatmentMaster.id%%/'
	),
	'bottom' => array(
		'add' => $add_links
	)
);

$structure_override = array();

$final_options = array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override);
$final_atim_structure = $atim_structure;

$hook_link = $this->Structures->hook();
if ($hook_link) {
	require($hook_link);
}

if (!isset($controls_for_subform_display)) {
	// Subform display
	$this->Structures->build($atim_structure, $final_options);

} else {
	// Main form display
	if (empty($controls_for_subform_display)) {
		// No active control for this treatment type => Display empty list
		$final_options['settings']['pagination'] = false;
		$this->Structures->build($atim_structure, $final_options);

	} else {
		$counter = 0;
		foreach ($controls_for_subform_display as $new_control) {
			$counter++;
			$final_atim_structure = array();
			$final_options['type'] = 'detail';
			$final_options['settings']['header'] = $new_control['TreatmentControl']['tx_header'];
			$final_options['settings']['actions'] = $counter == sizeof($controls_for_subform_display);
			$final_options['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listall/' . $atim_menu_variables['Participant.id'] . '/' . $new_control['TreatmentControl']['id']);

			$hook_link = $this->Structures->hook('subform');
			if ($hook_link) {
				require($hook_link);
			}

			$this->Structures->build($final_atim_structure, $final_options);
		}
	}
}
	