<?php
	$links = array(
		"bottom" => array(),
		"index" => array("report" => array('link' => "/Datamart/Reports/manageReport/%%Report.id%%", 'icon' => 'detail')));
	$header = array();
	$this->Structures->build($atim_structure, array('links' => $links, 'settings' => array('header' => $header, 'no_sanitization' => array('Report' => array('title', 'description')))));
?>