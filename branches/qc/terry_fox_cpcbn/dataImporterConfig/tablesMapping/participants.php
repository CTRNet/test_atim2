<?php  

$pkey = "Patient # in biobank";
$child = array(
 	'dx_primary',
	'dx_other_primary'
);
$fields = array(
	"participant_identifier" 					=> "@tmp_id",
	
	"qc_tf_bank_id" 							=> "#qc_tf_bank_id",
	"qc_tf_bank_participant_identifier" 		=> 'Patient # in biobank',
		
	"date_of_birth" 							=> "Date of Birth Date",
	"date_of_birth_accuracy" 					=> array("Date of Birth Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	
	"vital_status" 								=> array("Death status" => array("alive" => "alive", "dead" => "deceased", "unknown" => "unknown", "" => "unknown", "deceased" => "deceased")),
	'qc_tf_death_from_prostate_cancer' 			=> array('Death from prostate cancer' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	"date_of_death" 							=> "Registered Date of Death Date",
	"date_of_death_accuracy" 					=> array("Registered Date of Death Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_suspected_date_of_death" 			=> "Suspected Date of Death Date",
	"qc_tf_suspected_date_of_death_accuracy"	=> array("Suspected Date of Death Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
		
	"qc_tf_last_contact" 						=> "Date of last contact Date",
	"qc_tf_last_contact_accuracy" 				=> array("Date of last contact Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
		
	"qc_tf_family_history" 						=> array("Family History (prostatite/cancer)" => new ValueDomain("qc_tf_fam_hist_prostate_cancer", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

$model = new Model(0, $pkey, $child, true, NULL, NULL, 'participants', $fields);
$model->custom_data = array(
		"date_fields" => array(
				$fields["date_of_birth"]					=> current(array_keys($fields["date_of_birth_accuracy"])),
				$fields["date_of_death"]					=> current(array_keys($fields["date_of_death_accuracy"])),
				$fields["qc_tf_suspected_date_of_death"]	=> current(array_keys($fields["qc_tf_suspected_date_of_death_accuracy"])),
				$fields["qc_tf_last_contact"]				=> current(array_keys($fields["qc_tf_last_contact_accuracy"]))
		)
);

$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'postParticipantWrite';

Config::addModel($model, 'participants');

function postParticipantRead(Model $m){
	excelDateFix($m);

	if(array_key_exists($m->values['Bank'], Config::$banks)) {
		$m->values['qc_tf_bank_id'] = Config::$banks[$m->values['Bank']];
		$patient_unique_key = $m->values['qc_tf_bank_id'].'-'.$m->values['Patient # in biobank'];
		if(in_array($patient_unique_key, Config::$existing_patient_unique_keys)) {
			Config::$summary_msg['patient']['@@ERROR@@']['Duplicated participant'][] = "Participant [".$m->values['Patient # in biobank']."] of bank [".$m->values['Bank']."] already exists [line: ".$m->line."].";
			return false;
		}
	} else {
		Config::$summary_msg['patient']['@@ERROR@@']['Bank unknown'][] = "Bank [".$m->values['Bank']."] is unknown [line: ".$m->line."].";
		return false;
	}
	
	return true;
}

function postParticipantWrite(Model $m){
	global $connection;

	$query = "UPDATE participants SET participant_identifier=id WHERE id=".$m->last_id.";";
	mysqli_query($connection, $query) or die("postParticipantWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
}


