<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => array("Event Type" => array("CT Scan" => 38, "CA125" => 37, "biopsy" => 39)),
	"event_date" => "Date of event (beginning) Date",
	"event_date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"event_type" => array("Event Type" => new ValueDomain('qc_tf_eoc_event_type', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"event_group" => "#event group"
);

$model = new Model(2, $pkey, array(), false, "participant_id", $pkey, 'event_masters', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["event_date"]				=> 'Date of event (beginning) Accuracy'
)); 
$model->post_read_function = 'edAfterRead';
$model->post_write_function = 'edPostWrite';

Config::addModel($model, 'qc_tf_ed_eocs');

function edAfterRead(Model $m){
	excelDateFix($m);
	$event_type = strtolower($m->values['Event Type']);
	if(!in_array($event_type, Config::$event_types)){
		echo "WARNING, UNMATCHED EVENT TYPE [",$m->values['Event Type'],"] line [".$m->line."]\n";
	}
	
	$m->values['event group'] = $event_type == 'ca125' ? 'lab' : 'clinical'; 
	return in_array($event_type, array('ca125', 'ct scan', 'biopsy'));
}

function edPostWrite(Model $m){
	global $connection;
	$event_type = strtolower($m->values['Event Type']);
	if($event_type == 'ca125'){
		$query = "INSERT INTO qc_tf_ed_ca125s (event_master_id, precision_u, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
			."(".$m->last_id.", '".$m->values['CA125  Precision (U)']."', NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
		mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		if(Config::$insert_revs){
			$query = "INSERT INTO qc_tf_ed_ca125s_revs (id, event_master_id, precision_u, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES"
				."SELECT id, event_master_id, precision_u, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM qc_tf_ed_ca125s WHERE id='".mysqli_insert_id($connection)."'";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		
	}else if($event_type == 'ct scan'){
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
		
	}else if($event_type == 'biopsy'){
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