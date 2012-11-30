<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => array("Event Type" => array("ct scan" => 38, "ca125" => 37, "biopsy" => 39)),
//	"disease_site" => "@EOC",
//	"event_group" => "#event group",
//	"event_type" => array("Event Type" => array("ct scan" => 'ct scan', "ca125" => 'ca125', "biopsy" => 'biopsy')),
	"event_date" => "Date of event (beginning) Date",
	"event_date_accuracy" => array("Date of event (beginning) Accuracy" => Config::$coeur_accuracy_def)
);

$model = new Model(2, $pkey, array(), false, "participant_id", $pkey, 'event_masters', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["event_date"]				=> 'Date of event (beginning) Accuracy'
)); 
$model->post_read_function = 'edAfterRead';
$model->post_write_function = 'edPostWrite';

$model->file_event_types = Config::$eoc_file_event_types;
$model->event_types_to_import = array_keys($fields['event_control_id']['Event Type']);

Config::addModel($model, 'qc_tf_ed_eocs');

function edAfterRead(Model $m){
	excelDateFix($m);
	$m->values['Event Type'] = strtolower($m->values['Event Type']);

	if($m->values['Event Type'] == 'chimiotherapy'){
		$m->values['Event Type'] = 'chemotherapy';
	}else if($m->values['Event Type'] == 'radiation'){
		$m->values['Event Type'] = 'radiotherapy';
	}
	
	if(!in_array($m->values['Event Type'], $m->file_event_types)){
		echo "WARNING, UNMATCHED EVENT TYPE [",$m->values['Event Type'],"] at line [".$m->line."]\n";
	}

	$m->values['event group'] = $m->values['Event Type'] == 'ca125' ? 'lab' : 'clinical'; 

	return in_array($m->values['Event Type'], $m->event_types_to_import);
}

function edPostWrite(Model $m){	
	if($m->values['Event Type'] == 'ca125'){
		if(!empty($m->values['CA125  Precision (U)']) && !is_numeric($m->values['CA125  Precision (U)'])) {
			echo "ERROR: 'CA125  Precision (U)' should be numeric [",$m->file,"] at line [", $m->line,"]\n";
		}
		
		$query = "INSERT INTO qc_tf_ed_ca125s (event_master_id, precision_u) VALUES "
			."(".$m->last_id.", '".$m->values['CA125  Precision (U)']."')";
		mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_ca125s_revs (event_master_id, precision_u, version_created) "
				."SELECT event_master_id, precision_u, NOW() FROM qc_tf_ed_ca125s WHERE event_master_id='".$m->last_id."'";
			mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		}
		
	}else if($m->values['Event Type'] == 'ct scan'){
		$ct_scan_domain = Config::$value_domains['qc_tf_ct_scan_precision'];
		$ct_scan_value = $ct_scan_domain->isValidValue($m->values['CT Scan Precision']);
		if($ct_scan_value === null){
			echo "WARNING: Unmatched ct scan value [",$m->values['CT Scan Precision'],"] at line [".$m->line."]\n";
			$ct_scan_value = $m->values['CT Scan Precision'];
		}
		$query = "INSERT INTO qc_tf_ed_ct_scans (event_master_id, scan_precision) VALUES "
			."(".$m->last_id.", '".$ct_scan_value."')";
		mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_ct_scans_revs (event_master_id, scan_precision, version_created)  "
				." SELECT event_master_id, scan_precision, NOW() FROM qc_tf_ed_ct_scans WHERE event_master_id='".$m->last_id."'";
			mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		}
		
	}else if(($m->values['Event Type'] == 'biopsy') || ($m->values['Event Type'] == 'radiology')){
		$query = "INSERT INTO qc_tf_ed_no_details (event_master_id) VALUES "
			."(".$m->last_id.")";
		mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_no_details_revs (event_master_id, version_created)  "
				."SELECT event_master_id, NOW() FROM qc_tf_ed_no_details WHERE event_master_id='".$m->last_id."'";
			mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		}
	}else{
		die("Invalid event type in ".__FILE__." at line ".__LINE__);
	}
}