<?php
	$links = array("bottom" => array(
		//"add" => "/datamart/reports/add", //this is unachieved dev. See the controller for more details
		),
		"index" => array("report" => "/datamart/reports/manageReport/%%Report.id%%"));
	$header = array();
	$structures->build($atim_structure, array('links' => $links, 'settings' => array('header' => $header)));
?>