<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"treatment_control_id" => array("Event Type" => array("surgery" => 16, "chemotherapy" => 17, "radiotherapy" => 18, "hormonal therapy" => 19)),
	"start_date" => "Date of event (beginning) Date",
	"start_date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"finish_date" => "Date of event (end) Date",
	"finish_date_accuracy" => array("Date of event (end) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => ""))
);

$model = new Model(4, $pkey, array(), false, "participant_id", $pkey, 'treatment_masters', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["start_date"]				=> 'Date of event (beginning) Accuracy',
	$fields["finish_date"]				=> 'Date of event (end) Accuracy'
));
$model->post_read_function = 'txPostRead';
$model->post_write_function = 'txPostWrite';

$model->file_event_types = Config::$opc_file_event_types;
$model->event_types_to_import = array_keys($fields['treatment_control_id']['Event Type']);

Config::addModel($model, 'qc_tf_tx_other');

function txPostRead(Model $m){
	excelDateFix($m);
	$m->values['Event Type'] = strtolower($m->values['Event Type']);
	
	if($m->values['Event Type'] == 'chimiotherapy'){
		$m->values['Event Type'] = 'chemotherapy';
	}

	if(!in_array($m->values['Event Type'], $m->file_event_types)){
		echo "WARNING, UNMATCHED EVENT TYPE [",$m->values['Event Type'],"] at line [".$m->line."]\n";
	}
	
	if(!in_array($m->values['Event Type'], array('chemotherapy','radiotherapy'))) {
		if(!empty($m->values['Date of event (end) Date']) && ($m->values['Date of event (beginning) Date'] != $m->values['Date of event (end) Date'])) {
			echo "WARNING, START DATE AND END DATE ARE DIFFERENT FOR [",$m->values['Event Type'],"] at line [".$m->line."]\n";
		}
		$m->values['Date of event (end) Date'] = null;
		$m->values['Date of event (end) Accuracy'] = null;	
	}	
	
	if($m->values['Event Type'] != 'chemotherapy') {
		if(!empty($m->values['Chemotherapy Precision Drug1'])) {
			echo "WARNING, NO DRUG TO COMPLETE FOR [",$m->values['Event Type'],"] at line [".$m->line."]\n";
		}
		$m->values['Chemotherapy Precision Drug1'] = '';
		$m->values['Chemotherapy Precision Drug2'] = '';
		$m->values['Chemotherapy Precision Drug3'] = '';
		$m->values['Chemotherapy Precision Drug4'] = '';
	}
		
	return in_array($m->values['Event Type'], $m->event_types_to_import);
}

function txPostWrite(Model $m){
	global $connection;
	
	switch($m->values['Event Type']){
		case 'surgery':
		case 'surgery(other)':
		case 'surgery(ovarectomy)':
			$query = "INSERT INTO txd_surgeries (treatment_master_id, deleted) VALUES "
				."(".$m->last_id.", 0)";
			mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			if(Config::$insert_revs){
				$query = "INSERT INTO txd_surgeries_revs (id, treatment_master_id,  version_created)  "
					."SELECT id, treatment_master_id,NOW() FROM txd_surgeries WHERE id='".mysqli_insert_id($connection)."'";
				mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
			
			break;
			
		case 'radiology':
		case 'radiotherapy':
		case 'hormonal therapy':
			$query = "INSERT INTO qc_tf_tx_empty (treatment_master_id, deleted) VALUES "
				."(".$m->last_id.", 0)";
			mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			if(Config::$insert_revs){
				$query = "INSERT INTO qc_tf_tx_empty_revs (id, treatment_master_id, version_created)  "
					."SELECT id, treatment_master_id,  NOW() FROM qc_tf_tx_empty WHERE id='".mysqli_insert_id($connection)."'";
				mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
			}
			break;
			
		case 'chemotherapy':
			$query = "INSERT INTO txd_chemos (treatment_master_id, deleted) VALUES "
				."(".$m->last_id.", 0)";
			mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			if(Config::$insert_revs){
				$query = "INSERT INTO txd_chemos_revs (id, treatment_master_id,  version_created)  "
				."SELECT id, treatment_master_id,  NOW() FROM txd_chemos WHERE id='".mysqli_insert_id($connection)."'";
				mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
			
			for($i = 1; $i <= 4; $i ++){
				$current_drug = $m->values['Chemotherapy Precision Drug'.$i];
				if(!empty($current_drug)){
					$current_drug = trim($current_drug);
					if(!in_array($current_drug,  Config::$drugs)) {
						echo '<br>WARNING, DRUG ['.$current_drug.'] UNKNOWN at line ['.$m->line."]\n";
					}
					
					$query = "INSERT INTO txe_chemos(treatment_master_id, drug_id, deleted) VALUES "
						."(".$m->last_id.", (SELECT id FROM drugs WHERE generic_name='".$current_drug."'), 0)";
					mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
					if(Config::$insert_revs){
						$query = "INSERT INTO txe_chemos_revs(id, treatment_master_id, drug_id,  version_created)  "
						."SELECT id, treatment_master_id, drug_id,  NOW() FROM txe_chemos WHERE id='".mysqli_insert_id($connection)."'";
						mysqli_query($connection, $query) or die("txPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					}
				}
			}
			
			break;
			
		default:
			die("Invalid event type in ".__FILE__." at line ".__LINE__);
	}
}

