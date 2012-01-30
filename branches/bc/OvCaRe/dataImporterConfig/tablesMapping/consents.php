<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"consent_control_id" => "@2",
	"participant_id" => $pkey,
	"status_date" => "Date Consent Received",
	"consent_signed_date" => "Date Consent Received");
$detail_fields = array();

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'consent_masters', $master_fields, 'cd_nationals', 'consent_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postConsentRead';
$model->custom_data = array(
	"date_fields" => array(
		$master_fields["status_date"] => null,
		$master_fields["consent_signed_date"] => null
	) 
);

//adding this model to the config
Config::$models['ConsentMaster'] = $model;

function postConsentRead(Model $m){
	excelDateFix($m);
	$m->values['consent_status'] = "obtained";
	
	return true;
}
