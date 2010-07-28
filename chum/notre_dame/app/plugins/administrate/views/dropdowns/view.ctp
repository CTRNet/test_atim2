<?php
$structures->build($administrate_dropdowns, array("type" => "detail", "data" => $control_data, 'settings' => array('actions' => false)));

$links = array("bottom" => array(
	"add" => "/administrate/dropdowns/add/".$control_id."/"));
$structures->build($administrate_dropdown_values, array("type" => "index", "data" => $this->data, "links" => $links, "settings" => array("pagination" => false)));