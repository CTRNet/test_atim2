<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"tx_control_id" => array("Event Type" => array("surgery" => 3, "surgery (ovarectomy)" => 3, "surgery (other)" => 3, "chimiotherapy" => 1, "radiology" => "", "radiotherapy" => 10, "hormonal therapy" => 11)),
	"start_date" => "Date of event (beginning) Date",
	"start_date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"finish_date" => "Date of event (end) Date",
	"finish_date_accuracy" => array("Date of event (end) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => ""))
);

$model = new Model(4, $pkey, array(), false, "participant_id", $pkey, 'tx_masters', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["start_date"]				=> 'Date of event (beginning) Accuracy',
	$fields["finish_date"]				=> 'Date of event (end) Accuracy'
));
$model->post_read_function = 'txPostRead';
$model->post_write_function = 'txPostWrite';

Config::addModel($model, 'qc_tf_tx_other');

function txPostRead(Model $m){
	excelDateFix($m);
	$event_type = strtolower($m->values['Event Type']);
	if(!in_array($event_type, Config::$event_types)){
		echo "WARNING, UNMATCHED EVENT TYPE [",$m->values['Event Type'],"] at line [".$m->line."]\n";
	}
	return in_array($event_type, array('surgery', 'surgery (other)', 'surgery (ovarectomy)', 'chimiotherapy', 'radiology', 'radiotherapy', 'hormonal therapy'));
}

function txPostWrite(Model $m){
	global $connection;
	$event_type = strtolower($m->values['Event Type']);
	switch($event_type){
		case 'surgery':
		case 'surgery (other)':
		case 'surgery (ovarectomy)':
			$surgery_domain = Config::$value_domains['qc_tf_surgery_type'];
			$pos = strpos($event_type, "(");
			$surgery_type = "";
			if($pos !== false){
				$surgery_type_tmp = substr($event_type, $pos + 1);
				$surgery_type_tmp = substr($surgery_type_tmp, 0, strlen($surgery_type_tmp) - 1);
				$surgery_type = $surgery_domain->isValidValue($surgery_type_tmp);
				if($surgery_type == null){
					echo "WARNING: Invalid surgery type [".$surgery_type_tmp."]\n";
					$surgery_type = $surgery_type_tmp;
				}
			}
			$query = "INSERT INTO txd_surgeries (tx_master_id, qc_tf_type, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
				."(".$m->last_id.", '".$surgery_type."', NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			if(Config::$insert_revs){
				$query = "INSERT INTO txd_surgeries_revs (id, tx_master_id, qc_tf_type, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES "
					."SELECT id, tx_master_id, qc_tf_type, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM txd_surgeries WHERE id='".mysqli_insert_id($connection)."'";
				mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
			
			break;
			
		case 'radiology':
		case 'radiotherapy':
		case 'hormonal therapy':
			$query = "INSERT INTO qc_tf_tx_empty (tx_master_id, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
				."(".$m->last_id.", NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			if(Config::$insert_revs){
				$query = "INSERT INTO qc_tf_tx_empty_revs (id, tx_master_id, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES "
					."SELECT id, tx_master_id, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM qc_tf_tx_empty WHERE id='".mysqli_insert_id($connection)."'";
				mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
			}
			break;
			
		case 'chimiotherapy':
			$query = "INSERT INTO txd_chemos (tx_master_id, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
				."(".$m->last_id.", NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
			mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			if(Config::$insert_revs){
				$query = "INSERT INTO txd_chemos_revs (id, tx_master_id, created, created_by, modified, modified_by, deleted, deleted_date, version_created) VALUES "
				."SELECT id, tx_master_id, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM qc_tf_tx_empty WHERE id='".mysqli_insert_id($connection)."'";
				mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
			
			$drug_value_domain = Config::$value_domains['qc_tf_eoc_event_drug'];
			for($i = 1; $i <= 4; $i ++){
				$current_drug = $m->values['Chimiotherapy Precision Drug'.$i];
				if(!empty($current_drug)){
					switch($current_drug){
						case 'Carboplatin';
							$current_drug = 'carboplatinum';
							break;
						case 'oxaliplatin':
							$current_drug = 'oxaliplatinum';
							break;
					}
					if($current_drug == 'Carboplatin'){
						$current_drug = 'carboplatinum';
					}
					$current_drug = $drug_value_domain->isValidValue($current_drug);
					if($current_drug === null){
						echo "WARNING: Invalid drug [",$m->values['Chimiotherapy Precision Drug'.$i],"]\n";
						$current_drug = $m->values['Chimiotherapy Precision Drug'.$i];
					}
					
					$query = "INSERT INTO txe_chemos(tx_master_id, drug_id, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
						."(".$m->last_id.", (SELECT id FROM drugs WHERE generic_name='".$current_drug."'), NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.", 0, NULL)";
					mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
					if(Config::$insert_revs){
						$query = "INSERT INTO txe_chemos_revs(id, tx_master_id, drug_id, created, created_by, modified, modified_by, deleted, deleted_date) VALUES "
						."SELECT id, tx_master_id, drug_id, created, created_by, modified, modified_by, deleted, deleted_date, NOW() FROM txe_chemos WHERE id='".mysqli_insert_id($connection)."'";
						mysqli_query($connection, $query) or die("edEocsPostWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					}
				}
			}
			
			break;
			
		default:
			die("Invalid event type in ".__FILE__." at line ".__LINE__);
	}
}

