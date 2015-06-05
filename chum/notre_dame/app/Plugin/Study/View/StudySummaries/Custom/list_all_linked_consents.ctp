<?php

$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'links' => array(
		'index' => array(
			'detail' => '/ClinicalAnnotation/ConsentMasters/listall/%%ConsentMaster.participant_id%%')),
	'settings'	=> array('pagination' => true, 'actions' => false),
	'override'=> array()
);
$this->Structures->build($final_atim_structure, $final_options);

?>
