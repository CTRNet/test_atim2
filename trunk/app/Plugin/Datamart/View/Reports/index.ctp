<?php
	$links = array(
		"bottom" => array(),
		"index" => array("report" => array('link' => "/Datamart/reports/manageReport/%%Report.id%%", 'icon' => 'detail')));
	$header = array();
	$this->Structures->build($atim_structure, array('links' => $links, 'settings' => array('header' => $header)));
?>