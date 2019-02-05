<?php
	$structure_links = array(
		"top" => "/Datamart/Browser/edit/".$index_id,
		"bottom" => array(
			"cancel" => "/Datamart/Browser/index/"	
	));
	$this->Structures->build($atim_structure, array('type' => 'edit', 'links' => $structure_links));
?>