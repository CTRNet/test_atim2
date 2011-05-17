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
	"participant_identifier" => "NS", 
	"date_of_birth" => "DN",
	"vital_status" => array("CT" => 
		array(
			"O" => "alive",
			"*DCD" => "deceased",
			"DCD" => "deceased",
			"*O" => "alive",
			"N" => "",
			"O*" => "alive",
			"O                       O" => "alive")));

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, true, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postTemplateRead';
$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"] => null
	) 
);

//adding this model to the config
Config::$models['Participant'] = $model;

function postTemplateRead(Model $m){
	excelDateFix($m);
	echo "<pre>";
	print_r($m);
}
