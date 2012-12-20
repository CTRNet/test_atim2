<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"treatment_control_id" => array("Event Type" => array("surgery" => 16, "chemotherapy" => 17, "radiotherapy" => 18, "hormonal therapy" => 19)),
	"start_date" => "Date of event (beginning) Date",
	"start_date_accuracy" => array("Date of event (beginning) Accuracy" => Config::$coeur_accuracy_def),
	"finish_date" => "Date of event (end) Date",
	"finish_date_accuracy" => array("Date of event (end) Accuracy" => Config::$coeur_accuracy_def)
);

$model = new Model(4, $pkey, array(), false, "participant_id", $pkey, 'treatment_masters', $fields);

$model->custom_data = array(
	"date_fields" => array(
		$fields["start_date"] => current(array_keys($fields["start_date_accuracy"])),
		$fields["finish_date"] => current(array_keys($fields["finish_date_accuracy"]))),
	'disease' => 'Other'
);

$model->post_read_function = 'txPostRead';
$model->post_write_function = 'txPostWrite';

$model->file_event_types = Config::$opc_file_event_types;
$model->event_types_to_import = array_keys($fields['treatment_control_id']['Event Type']);

Config::addModel($model, 'other_tx');

function txPostRead(Model $m){
	excelDateFix($m);
	$m->values['Event Type'] = strtolower($m->values['Event Type']);
	
	if($m->values['Event Type'] == 'chimiotherapy'){
		$m->values['Event Type'] = 'chemotherapy';
	}else if($m->values['Event Type'] == 'radiation'){
		$m->values['Event Type'] = 'radiotherapy';
	}

	if(!in_array($m->values['Event Type'], $m->file_event_types)){
		Config::$summary_msg[$m->custom_data['disease'].' - Treatment']['@@ERROR@@']['Unknown treatment type'][] = "Treatment type [".$m->values['Event Type']."] is not supported for ".$m->custom_data['disease']." disease. See line ". $m->line;
	}
	
	if(!in_array($m->values['Event Type'], array('chemotherapy','radiotherapy'))) {
		if(!empty($m->values['Date of event (end) Date']) && ($m->values['Date of event (beginning) Date'] != $m->values['Date of event (end) Date'])) {
			Config::$summary_msg[$m->custom_data['disease'].' - Treatment']['@@WARNING@@']['Start date & End date issue'][] = "Start date & End date are different for treatment ".$m->values['Event Type'].". See line ". $m->line;
		}
		$m->values['Date of event (end) Date'] = null;
		$m->values['Date of event (end) Accuracy'] = null;	
	}	
	
	if($m->values['Event Type'] != 'chemotherapy') {
		if(!(empty($m->values['Chemotherapy Precision Drug1']) && empty($m->values['Chemotherapy Precision Drug2']) && empty($m->values['Chemotherapy Precision Drug3']) && empty($m->values['Chemotherapy Precision Drug4']))) {	
			Config::$summary_msg[$m->custom_data['disease'].' - Treatment']['@@WARNING@@']['No drug to complete'][] = "No drug should be defined for ".$m->values['Event Type'].". See line [".$m->line."]";
		}
		$m->values['Chemotherapy Precision Drug1'] = '';
		$m->values['Chemotherapy Precision Drug2'] = '';
		$m->values['Chemotherapy Precision Drug3'] = '';
		$m->values['Chemotherapy Precision Drug4'] = '';
	}
		
	return in_array($m->values['Event Type'], $m->event_types_to_import);
}

function txPostWrite(Model $m){
	switch($m->values['Event Type']){
		case 'surgery':
		case 'surgery(other)':
		case 'surgery(ovarectomy)':
			insertIntoTrtDetail('txd_surgeries', $m->last_id, array());
			break;	
		case 'radiology':
		case 'radiotherapy':
		case 'hormonal therapy':
			insertIntoTrtDetail('qc_tf_tx_empty', $m->last_id, array());
			break;	
		case 'chemotherapy':
			insertIntoTrtDetail('txd_chemos', $m->last_id, array());
			for($i = 1; $i <= 4; $i ++){
				$current_drug = $m->values['Chemotherapy Precision Drug'.$i];
				if(!empty($current_drug)){
					$current_drug = trim($current_drug);
					if(!in_array($current_drug,  Config::$drugs)) {
						Config::$summary_msg[$m->custom_data['disease'].' - Treatment']['@@WARNING@@']['Drug Unknown'][] = " DRUG ['.$current_drug.'] UNKNOWN at line [".$m->line."]";
					} else {
						$query = "INSERT INTO txe_chemos(treatment_master_id, drug_id) VALUES (".$m->last_id.", (SELECT id FROM drugs WHERE generic_name='".$current_drug."'))";
						mysqli_query(Config::$db_connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
						if(Config::$insert_revs) {
							$query = "INSERT INTO txe_chemos_revs (id, treatment_master_id, drug_id,  version_created) SELECT id, treatment_master_id, drug_id,  NOW() FROM txe_chemos WHERE id = '".mysqli_insert_id(Config::$db_connection)."'";
							mysqli_query(Config::$db_connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
						}
					}
				}
			}
			break;
		default:
			die("Invalid event type in ".__FILE__." at line ".__LINE__);
	}
	
	if($m->custom_data['disease'] == 'EOC' && Config::$studied_participant_ids['eoc_diagnosis_master_id']) {
		$query = "UPDATE treatment_masters SET diagnosis_master_id = ".Config::$studied_participant_ids['eoc_diagnosis_master_id']." WHERE id = ".$m->last_id;
		mysqli_query(Config::$db_connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		if(Config::$insert_revs){
			$query = str_replace('treatment_masters','treatment_masters_revs',$query);
			mysqli_query(Config::$db_connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		}
	}
}

function insertIntoTrtDetail($table_name, $treatment_master_id, $fields) {
	$fields_strg = 'treatment_master_id'.(empty($fields)? '' : ','.implode(',', array_keys($fields)));
	$values_strg = $treatment_master_id.(empty($fields)? '' : ", '".implode("','",$fields)."'");
	$query = "INSERT INTO $table_name ($fields_strg) VALUES ($values_strg)";
	mysqli_query(Config::$db_connection, $query) or die("insertIntoTrtDetail [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	if(Config::$insert_revs){
		$query = "INSERT INTO ".$table_name."_revs ($fields_strg, version_created) VALUES ($values_strg, NOW())";
		mysqli_query(Config::$db_connection, $query) or die("insertIntoTrtDetail [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}
}
