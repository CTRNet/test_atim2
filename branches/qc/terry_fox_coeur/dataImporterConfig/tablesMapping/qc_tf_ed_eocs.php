<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => array("Event Type" => array("ct scan" => 38, "ca125" => 37, "biopsy" => 39)),
	"disease_site" => "@EOC",
	"event_group" => "#event group",
	"event_type" => array("Event Type" => array("ct scan" => 'ct scan', "ca125" => 'ca125', "biopsy" => 'biopsy')),
	"event_date" => "Date of event (beginning) Date",
	"event_date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => ""))
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

	if(!in_array($m->values['Event Type'], $m->file_event_types)){
		echo "WARNING, UNMATCHED EVENT TYPE [",$m->values['Event Type'],"] at line [".$m->line."]\n";
	}

	if($m->values['Event Type'] != 'chimiotherapy') {
		if(!empty($m->values['Date of event (end) Date'])) {
			echo "WARNING, NO END DATE TO COMPLETE FOR [",$m->values['Event Type'],"] at line [".$m->line."]\n";
		}
		$m->values['Date of event (end) Date'] = '';
		$m->values['Date of event (end) Accuracy'] = '';
		
		if(!empty($m->values['Chimiotherapy Precision Drug1'])) {
			echo "WARNING, NO DRUG TO COMPLETE FOR [",$m->values['Event Type'],"] at line [".$m->line."]\n";
		}
		$m->values['Chimiotherapy Precision Drug1'] = '';
		$m->values['Chimiotherapy Precision Drug2'] = '';
		$m->values['Chimiotherapy Precision Drug3'] = '';
		$m->values['Chimiotherapy Precision Drug4'] = '';
	}
	
	$m->values['event group'] = $m->values['Event Type'] == 'ca125' ? 'lab' : 'clinical'; 

	return in_array($m->values['Event Type'], $m->event_types_to_import);
}

function edPostWrite(Model $m){
	global $connection;
	
	if($m->values['Event Type'] == 'ca125'){
		if(!empty($m->values['CA125  Precision (U)']) && !is_numeric($m->values['CA125  Precision (U)'])) {
			echo "ERROR: 'CA125  Precision (U)' should be numeric [",$m->file,"] at line [", $m->line,"]\n";
		}
		
		$query = "INSERT INTO qc_tf_ed_ca125s (event_master_id, precision_u, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
			."(".$m->last_id.", '".$m->values['CA125  Precision (U)']."', NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
		mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_ca125s_revs (id, event_master_id, precision_u, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES"
				."SELECT id, event_master_id, precision_u, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM qc_tf_ed_ca125s WHERE id='".mysqli_insert_id($connection)."'";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		
	}else if($m->values['Event Type'] == 'ct scan'){
		$ct_scan_domain = Config::$value_domains['qc_tf_ct_scan_precision'];
		$ct_scan_value = $ct_scan_domain->isValidValue($m->values['CT Scan Precision']);
		if($ct_scan_value === null){
			echo "WARNING: Unmatched ct scan value [",$m->values['CT Scan Precision'],"] at line [".$m->line."]\n";
			$ct_scan_value = $m->values['CT Scan Precision'];
		}
		$query = "INSERT INTO qc_tf_ed_ct_scans (event_master_id, scan_precision, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
			."(".$m->last_id.", '".$ct_scan_value."', NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
		mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_ct_scans_revs (id, event_master_id, scan_precision, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES "
				." SELECT id, event_master_id, scan_precision, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM qc_tf_ed_ct_scans WHERE id='".mysqli_insert_id($connection)."'";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		
	}else if(($m->values['Event Type'] == 'biopsy') || ($m->values['Event Type'] == 'radiology')){
		$query = "INSERT INTO qc_tf_ed_no_details (event_master_id, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
			."(".$m->last_id.", NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
		mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_no_details_revs (id, event_master_id, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES "
				."SELECT id, event_master_id, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM qc_tf_ed_no_details WHERE id='".mysqli_insert_id($connection)."'";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
	}else{
		die("Invalid event type in ".__FILE__." at line ".__LINE__);
	}
}