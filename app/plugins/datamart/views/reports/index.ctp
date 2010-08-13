<?php
$links = array("bottom" => array(
	//"add" => "/datamart/reports/add", //this is unachieved dev. See the controller for more details
	),
	"index" => array("detail" => "/datamart/reports/access/%%Report.id%%"));
$structures->build($atim_structure, array("links" => $links));
?>