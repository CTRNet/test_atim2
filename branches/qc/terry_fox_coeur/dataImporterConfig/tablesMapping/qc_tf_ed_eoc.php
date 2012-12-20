<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => array("Event Type" => array("ct scan" => 38, "ca125" => 37, "biopsy" => 39)),
	"event_date" => "Date of event (beginning) Date",
	"event_date_accuracy" => array("Date of event (beginning) Accuracy" => Config::$coeur_accuracy_def)
);

$model = new Model(2, $pkey, array(), false, "participant_id", $pkey, 'event_masters', $fields);

$model->custom_data = array(
	"date_fields" => array(
		$fields["event_date"] => current(array_keys($fields["event_date_accuracy"]))),
	'disease' => 'EOC'
); 

$model->post_read_function = 'edAfterRead';
$model->post_write_function = 'edPostWrite';

$model->file_event_types = Config::$eoc_file_event_types;
$model->event_types_to_import = array_keys($fields['event_control_id']['Event Type']);

Config::addModel($model, 'eoc_ed');

function edAfterRead(Model $m){
	excelDateFix($m);
	$m->values['Event Type'] = strtolower($m->values['Event Type']);

	if($m->values['Event Type'] == 'chimiotherapy'){
		$m->values['Event Type'] = 'chemotherapy';
	}else if($m->values['Event Type'] == 'radiation'){
		$m->values['Event Type'] = 'radiotherapy';
	}
	
	if(!in_array($m->values['Event Type'], $m->file_event_types)){
		Config::$summary_msg[$m->custom_data['disease'].' - Event']['@@ERROR@@']['Unknown event type'][] = "Event type [".$m->values['Event Type']."] is not supported for ".$m->custom_data['disease']." disease. See line ". $m->line;
	}

	$m->values['event group'] = $m->values['Event Type'] == 'ca125' ? 'lab' : 'clinical'; 

	return in_array($m->values['Event Type'], $m->event_types_to_import);
}

function edPostWrite(Model $m){	
	if($m->values['Event Type'] == 'ca125') {
		if(!empty($m->values['CA125  Precision (U)'])) {
			if(!is_numeric($m->values['CA125  Precision (U)']) || ($m->values['CA125  Precision (U)'] < 0)) {
				Config::$summary_msg[$m->custom_data['disease'].' - Event']['@@ERROR@@']['CA125 Value'][] = "'CA125  Precision (U)' should be numeric > 0. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
				$m->values['CA125  Precision (U)'] = '';
			}
		}
		insertIntoEventDetail('qc_tf_ed_ca125s', $m->last_id, (strlen($m->values['CA125  Precision (U)'])? array('precision_u' => $m->values['CA125  Precision (U)']) : array()));	
	}else if($m->values['Event Type'] == 'ct scan'){
		$ct_scan_domain = Config::$value_domains['qc_tf_ct_scan_precision'];
		$ct_scan_value = $ct_scan_domain->isValidValue($m->values['CT Scan Precision']);
		if($ct_scan_value === null){
			Config::$summary_msg[$m->custom_data['disease'].' - Event']['@@ERROR@@']['Unmatched ct scan value'][] = "Unmatched ct scan value [".$m->values['CT Scan Precision']."]. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
			$m->values['CT Scan Precision'] = '';
		}
		insertIntoEventDetail('qc_tf_ed_ct_scans', $m->last_id, array('scan_precision' => $m->values['CT Scan Precision']));	
	}else if(($m->values['Event Type'] == 'biopsy') || ($m->values['Event Type'] == 'radiology')){
		insertIntoEventDetail('qc_tf_ed_no_details', $m->last_id, array());
	}else{
		die("Invalid event type in ".__FILE__." at line ".__LINE__);
	}
	
	if($m->custom_data['disease'] == 'EOC' && Config::$studied_participant_ids['eoc_diagnosis_master_id']) {
		$query = "UPDATE event_masters SET diagnosis_master_id = ".Config::$studied_participant_ids['eoc_diagnosis_master_id']." WHERE id = ".$m->last_id;
		mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		if(Config::$insert_revs){
			$query = str_replace('event_masters','event_masters_revs',$query);
			mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		}
	}
}

function insertIntoEventDetail($table_name, $event_master_id, $fields) {
	$fields_strg = 'event_master_id'.(empty($fields)? '' : ','.implode(',', array_keys($fields)));
	$values_strg = $event_master_id.(empty($fields)? '' : ", '".implode("','",$fields)."'");
	$query = "INSERT INTO $table_name ($fields_strg) VALUES ($values_strg)";
	mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	if(Config::$insert_revs){
		$query = "INSERT INTO ".$table_name."_revs ($fields_strg, version_created) VALUES ($values_strg, NOW())";
		mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}
}
