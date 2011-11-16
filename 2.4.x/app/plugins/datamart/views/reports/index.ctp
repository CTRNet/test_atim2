<?php
	$links = array(
		"bottom" => array(),
		"index" => array("report" => array('link' => "/datamart/reports/manageReport/%%Report.id%%", 'icon' => 'detail')));
	$header = array();
	$structures->build($atim_structure, array('links' => $links, 'settings' => array('header' => $header)));
?>