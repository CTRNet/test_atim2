<?php

/* 
Eventum ID: 3214
By: Stephen Fung
Date: 2014-04-17
Displaying consent forms linked to the project
*/

$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'links' => array(
		'index' => array(
			'detail' => '/ClinicalAnnotation/ConsentMasters/detail/%%ConsentMaster.participant_id%%/%%ConsentMaster.id%%')),
	'settings'	=> array('pagination' => true, 'actions' => false),
	'override'=> array()
);

$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link);
}

$this->Structures->build($final_atim_structure, $final_options);

?>
