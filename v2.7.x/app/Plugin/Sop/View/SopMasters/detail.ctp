<?php
$structure_links = array(
	'bottom' => array(
		'list' => '/Sop/SopMasters/listall/',
		'edit' => '/Sop/SopMasters/edit/%%SopMaster.id%%/',
		'delete' => '/Sop/SopMasters/delete/%%SopMaster.id%%/'
	)
);

$final_atim_structure = $atim_structure;
$final_options = array('links' => $structure_links);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if ($hook_link) {
	require($hook_link);
}

$this->Structures->build($final_atim_structure, $final_options);


?>