<?php
// The goal here is to
// -create your configured model where the following items are defined
// --your pkey
// --childs of this model (if any)
// --association between some db field and some xls fields 
// 
// -optionally you can 
// --set some post read/write functions
// --attach custom data to your model (that could be usefull for post read/write function)

$pkey = "NS";
$child = array();
$fields = array(
	"participant_id" => $pkey,
	"consent_status" => array("CT" => array(
		"O" => "obtained",
		"*DCD" => "obtained",
		"DCD" => "obtained",
		"*O" => "obtained",
		"N" => "denied",
		"O*" => "obtained",
		"O                       O" => "obtained")));

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, true, $pkey, 'consent_masters', $fields, 'cd_nationals', 'consent_master_id', array());
		
//we can then attach post read/write functions
$model->custom_data = array();

//adding this model to the config
Config::$models['ConsentMaster'] = $model;


