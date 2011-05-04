<?php
	$structure_links = array(
		"top" => "/datamart/browser/edit/".$index_id,
		"bottom" => array(
			"cancel" => "/datamart/browser/index/"	
	));
	$structures->build($atim_structure, array('type' => 'edit', 'links' => $structure_links));
?>