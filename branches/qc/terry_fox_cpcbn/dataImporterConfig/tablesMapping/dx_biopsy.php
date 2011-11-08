<?php
$pkey = "Patient # in biobank";
$child = array(
	
);
$fields = array(
	"participant_id" => $pkey,
	'event_date'	=> 'Surgery/Biopsy Date of surgery/biopsy',
	'event_date_accuracy' => array('Surgery/Biopsy Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'event_control_id' => '@51', //biopsy
	'diagnosis_master_id' => '#dx_master_id'	
);

function postDxBiopsyRead(Model $m){
	global $connection;
	if($m->values['Surgery/Biopsy Type of surgery'] != 'biopsy'){
		return false;
	}
	excelDateFix($m);
	
	$query = "SELECT id FROM diagnosis_masters WHERE participant_id=".$m->parent_model->last_id." LIMIT 2";
	$result = mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = mysqli_fetch_all($result);
	if(count($row) == 1){
		$m->values['dx_master_id'] = $row[0][0];
	}else{
		$m->values['dx_master_id'] = null;
		if(count($row) > 1){
			printf("WARNING: More than one dx can be associated to the biopsy at line [%d]\n", $m->line);
		}
	}
	
	return true;
}

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'event_masters', $fields, 'qc_tf_ed_biopsy', 'event_master_id', array());
$model->custom_data = array(
	'date_fields' => array(
		$fields["event_date"]		=> key($fields["event_date_accuracy"])
	)
);

$model->post_read_function = 'postDxBiopsyRead';
Config::addModel($model, 'dx_biopsy');
