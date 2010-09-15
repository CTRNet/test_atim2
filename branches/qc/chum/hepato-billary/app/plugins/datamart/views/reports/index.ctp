<?php
	$links = array("bottom" => array(
		//"add" => "/datamart/reports/add", //this is unachieved dev. See the controller for more details
		),
		"index" => array("detail" => "/datamart/reports/access/%%Report.id%%"));
	$header = array('title' => __('activity report index', NULL), 'description' => __('activity report index description', NULL));
	$structures->build($atim_structure, array('links' => $links, 'settings' => array('header' => $header)));
?>