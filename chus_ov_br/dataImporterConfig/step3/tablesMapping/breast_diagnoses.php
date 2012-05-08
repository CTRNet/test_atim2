<?php
$pkey = "#FRSQ";

$child = array();

$master_fields = array(
	"diagnosis_control_id" => "#diagnosis_control_id",
	"participant_id" => "#participant_id",
	"dx_nature" => "#dx_nature",
	"path_tstage" => "#path_tstage",
	"path_nstage" => "#path_nstage",
	"path_mstage" => "#path_mstage",
	"notes" => "#notes"
);
$detail_fields = array(
	"atcd" => "#atcd",
	"atcd_description" => "ATCD Cancer sein (oui/non)",
	"laterality" => "#laterality",

	"infiltrative_sbr_grade" => array("INFILTRANT::Grade SBR" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"LMP"=>"LMP",
		"ND"=>"ND")),
	"intraductal_ng_grade_holland" => array("INTRACANALAIRE (IN SITU)::Grade NG (Holland)" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"LMP"=>"LMP",
		"ND"=>"ND")),
	"infiltrative_ductal"=>"#infiltrative_ductal",
	"infiltrative_mucinous"=>"#infiltrative_mucinous",
	"infiltrative_apocrine"=>"#infiltrative_apocrine",
	"infiltrative_tubular"=>"#infiltrative_tubular",
	"infiltrative_trabecular"=>"#infiltrative_trabecular",
	"infiltrative_alveolar"=>"#infiltrative_alveolar",
	"infiltrative_papillary"=>"#infiltrative_papillary",
	"infiltrative_micropapillary"=>"#infiltrative_micropapillary",
	"infiltrative_cribriform"=>"#infiltrative_cribriform",
	"infiltrative_lobular"=>"#infiltrative_lobular",
	"infiltrative_solid"=>"#infiltrative_solid",
	"infiltrative_medullary"=>"#infiltrative_medullary",
	"infiltrative_polyadenoid"=>"#infiltrative_polyadenoid",
	"infiltrative_neuroendocrine"=>"#infiltrative_neuroendocrine",
	"infiltrative_sarcomatoid"=>"#infiltrative_sarcomatoid",
	"infiltrative_ring_cell"=>"#infiltrative_ring_cell",
	"infiltrative_clear_cell"=>"#infiltrative_clear_cell",
	"infiltrative_giant_cells"=>"#infiltrative_giant_cells",
	"infiltrative_malpighian"=>"#infiltrative_malpighian",
	"infiltrative_epidermoid"=>"#infiltrative_epidermoid",
	"infiltrative_pleomorphic"=>"#infiltrative_pleomorphic",
	"infiltrative_basal_like"=>"#infiltrative_basal_like",
	
	"intraductal_papillary"=>"#intraductal_papillary",
	"intraductal_ductal"=>"#intraductal_ductal",
	"intraductal_lobular"=>"#intraductal_lobular",
	"intraductal_micropapillary"=>"#intraductal_micropapillary",
	"intraductal_cribriform"=>"#intraductal_cribriform",
	"intraductal_apocrine"=>"#intraductal_apocrine",
	"intraductal_comedocarcinoma"=>"#intraductal_comedocarcinoma",
	"intraductal_solid"=>"#intraductal_solid",
	"intraductal_intraductal_not_specified"=>"#intraductal_intraductal_not_specified",
	"intraductal_perc_of_infiltrating"=>"#intraductal_perc_of_infiltrating",
	
	"ganglion_axillary_surgery" => array(utf8_decode("GANGLIONS::Chirurgie aisselle") => array(""=>""," "=>"","oui"=>"y","x"=>"y")),
	"ganglion_sentinel_node" => array(utf8_decode("GANGLIONS::Ganglion Sentinelle") => array(""=>""," "=>"","oui"=>"y","x"=>"y")),
	"ganglion_total"=>"#ganglion_total",
	"ganglion_invaded"=>"#ganglion_invaded",

	"observation_necrosis"=>"#observation_necrosis",
	"observation_microcalcifications"=>"#observation_microcalcifications",
	"observation_angiolymphatic_invasion"=>"#observation_angiolymphatic_invasion",
	"observation_multiple_foci_tumor"=>"#observation_multiple_foci_tumor",
	"observation_microinvasion"=>"#observation_microinvasion",
	"observation_distant_metastasis"=>"#observation_distant_metastasis",
	"observation_atypical_fibrocystic_changes"=>"#observation_atypical_fibrocystic_changes",
	"observation_nipple_affected"=>"#observation_nipple_affected",
	"observation_epidermis_affected"=>"#observation_epidermis_affected"
);

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, NULL, NULL, 'diagnosis_masters', $master_fields, 'chus_dxd_breasts', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postBreastDiagnosesRead';
$model->post_write_function = 'postBreastDiagnosesWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['BreastDiagnosisMaster'] = $model;
	
function postBreastDiagnosesRead(Model $m){
	global $connection;
//TODO
//return false;	
	// 1- GET PARTICIANT ID & PARTICIPANT CHECK
	
	$frsq_nbr = str_replace(' ', '', utf8_encode($m->values['#FRSQ']));
	if(!isset(Config::$participant_id_from_br_nbr[$frsq_nbr])) {
		Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@']['BR Nbr error'][] = "The FRSQ# '".$m->values['#FRSQ']."' has beend assigned to a participant in step3 ('DIAGNOSTIQUE') but this number is not defined in step 1! No data will be imported! [line: ".$m->line.']';
		return false;
	}
	$participant_id = Config::$participant_id_from_br_nbr[$frsq_nbr];
	$m->values['participant_id'] = $participant_id;
	
	if(!isset(Config::$data_for_import_from_participant_id[$participant_id])) die('ERR 9983933');
	if(Config::$data_for_import_from_participant_id[$participant_id]['data_imported_from_br_file']) {
		Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']['Participant & Many Rows'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has data recorded in many rows in breast bank file! Please check import deeply! [Line: ".$m->line.']';
	}
	Config::$data_for_import_from_participant_id[$participant_id]['data_imported_from_br_file'] = true;
	
	// 2- CREATE CONSENT
	
	$consent_date = customGetFormatedDate($m->values[utf8_decode('Date (année-mois-jour)')], 'DIAGNOSTIC', $m->line);
	if(empty($consent_date)) die('ERR empty consent date line '.$m->line);
	if(isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_date'])) {
		if($consent_date != Config::$data_for_import_from_participant_id[$participant_id]['consent_date']) {
			Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Participant & Many Consent Dates'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has different consent dates defined in many rows in breast bank file ($consent_date != ".Config::$data_for_import_from_participant_id[$participant_id]['consent_date'].")! Only one consent will be created with consent_date = ".Config::$data_for_import_from_participant_id[$participant_id]['consent_date']."! [Line: ".$m->line.']';
		}
	} else {
		$master_fields = array(
			"consent_control_id" => "3",
			"participant_id" => $m->values['participant_id'],
			"consent_status" => "'obtained'",
			"status_date" => "'$consent_date'",
			"status_date_accuracy" => "'c'",
			"consent_signed_date" => "'$consent_date'",
			"consent_signed_date_accuracy" => "'c'");
		$consent_master_id = customInsertChusRecord($master_fields, 'consent_masters');
		customInsertChusRecord(array('consent_master_id' => $consent_master_id), 'cd_nationals', true);
		
		Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] = $consent_master_id;
		Config::$data_for_import_from_participant_id[$participant_id]['consent_date'] = $consent_date;
	}
	
	// 3- UPDATE PARTICIPANT BIRTH DATE

	$date_of_birth = customGetFormatedDate($m->values[utf8_decode('Date Naissance')], 'DIAGNOSTIC', $m->line);
	
	if(isset(Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth_from_file'])) {
		if($date_of_birth != Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth_from_file']) Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@']['Participant Birthdate conflict into file'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has different birth dates defined in many rows of the BR file ($date_of_birth != ". Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth_from_file']."! [Line: ".$m->line.']';
		
	} else {
		Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth_from_file'] = $date_of_birth;
		$date_of_birth_from_step2 = Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth_from_step2'];
		
		if((empty($date_of_birth) && empty($date_of_birth_from_step2)) || ($date_of_birth == $date_of_birth_from_step2)) {
			// Nothing to do
		} else {
			if(!empty($date_of_birth) && !empty($date_of_birth_from_step2)) {
				Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@']['Participant Birthdate conflict step2/3'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR']).(!empty(Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ OV'])? "-".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ OV']) : '')."] has different birth dates defined from step2 and step3 ($date_of_birth != $date_of_birth_from_step2! Check OV and BR files ! [Line: ".$m->line.']';
			} else if(!empty($date_of_birth)) {
				$query = "UPDATE participants SET date_of_birth = '$date_of_birth', date_of_birth_accuracy = 'c'  WHERE id = ".$m->values['participant_id'].";";
				mysqli_query($connection, $query) or die("birth date update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$query = str_replace('participants','participants_revs', $query);
				mysqli_query($connection, $query) or die("birth date update  [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
			}
		}	
	}
	
	// 4- SET DX DATA & CONTROL DATA
	
	$dx_notes = '';
	$br_dx_data_exist = array();
	
	// field: 'ATCD Cancer sein (oui/non)'
	
	$m->values['atcd'] = '';
	$m->values["ATCD Cancer sein (oui/non)"] = preg_replace(array('/^ /','/ $/','/^ND$/'), array('','',''), utf8_encode($m->values["ATCD Cancer sein (oui/non)"]));
	if(strlen($m->values["ATCD Cancer sein (oui/non)"])) {
		$m->values['atcd'] = preg_match('/(non)/i',$m->values["ATCD Cancer sein (oui/non)"], $matches)? 'n': 'y';
		$m->values["ATCD Cancer sein (oui/non)"] = preg_replace(array('/^oui$/i', '/^oui {0,1}(.*)$/i', '/^non$/i', '/^non {0,1}(.*)$/i', '/^\((.*)\)$/'), array('', '$1', '', '$1', '$1'),$m->values["ATCD Cancer sein (oui/non)"]);
	}
	if(($m->values["atcd"] == 'y') || !empty($m->values["ATCD Cancer sein (oui/non)"])) $br_dx_data_exist['ATCD'] = 'ATCD';
	
	// fields: 'SEINS::DROIT', 'SEINS::GAUCHE', 'SEINS::BILATÉRAL'
	
	$m->values['laterality'] = '';	
	if(!empty($m->values['SEINS::DROIT']) || !empty($m->values['SEINS::GAUCHE']) || !empty($m->values[utf8_decode('SEINS::BILATÉRAL')])) {
		if(!empty($m->values[utf8_decode('SEINS::BILATÉRAL')])) {
			if(preg_match('/^x {0,1}\((.*)\)$/', $m->values[utf8_decode('SEINS::BILATÉRAL')], $matches)) {
				$dx_notes .= (empty($dx_notes)? '' : ' || ').'Lateralité : '.utf8_encode($matches[1]);
			} else if($m->values[utf8_decode('SEINS::BILATÉRAL')] != 'x') {
				die('ERR dx laterality 99489299323 ['.$m->values[utf8_decode('SEINS::BILATÉRAL')].']');
			}
			$m->values['laterality'] = 'bilateral';	
			if(!empty($m->values['SEINS::GAUCHE'])) {
				Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Participant laterality conflict'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has a diagnosis laterality defined as bilateral and left! Only left laterality will be recorded. Please confirm. [Line: ".$m->line.']';
				$m->values['laterality'] = 'left';
			} else if(!empty($m->values['SEINS::DROIT'])) {
				$m->values['laterality'] = 'right';
				Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Participant laterality conflict'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has a diagnosis laterality defined as bilateral and right! Only right laterality will be recorded. Please confirm. [Line: ".$m->line.']';
			}
		} else if(!empty($m->values['SEINS::GAUCHE'])) {
			if(!empty($m->values['SEINS::DROIT']) || ($m->values['SEINS::GAUCHE'] != 'x')) die('ERR dx laterality 9948dssd9299323 Line '.$m->line);
			$m->values['laterality'] = 'left';	
		} else {
			if(!empty($m->values['SEINS::GAUCHE']) || ($m->values['SEINS::DROIT'] != 'x')) die('ERR dx laterality 9948dssd929sa9323 Line '.$m->line);
			$m->values['laterality'] = 'right';	
		}
		$br_dx_data_exist['Laterality'] = 'Laterality';
	}
	
	// fields: 'pTNM'
	
	foreach(array('STADE::pT' => 'path_tstage', 'STADE::N' => 'path_nstage', 'STADE::M' => 'path_mstage') as $file_field => $db_field) {
		$m->values[$db_field] = '';	
		$m->values[$file_field] = preg_replace(array('/^ND$/i'), array(''), $m->values[$file_field]);
		if(strlen($m->values[$file_field])) {
			if(strlen($m->values[$file_field]) > 5)	Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@']['pPTNM value'][] = "The value (".$m->values[$file_field].")of the field [$file_field] is too long! Please correct if requiered! [Line: ".$m->line.']';
			$m->values[$db_field] = utf8_encode($m->values[$file_field]);
			$br_dx_data_exist['pTNM'] = 'pTNM';	
		}
	}
	
	// fields: 'INFILTRANT'
	
	$infiltrant_fields = array(
		"INFILTRANT::Canalaire" => 'infiltrative_ductal',
		"INFILTRANT::Mucineux" => 'infiltrative_mucinous',
		"INFILTRANT::Apocrine" => 'infiltrative_apocrine',
		"INFILTRANT::Tubulaire" => 'infiltrative_tubular',
		"INFILTRANT::Trabéculaire" => 'infiltrative_trabecular',
		"INFILTRANT::Alvéolaire" => 'infiltrative_alveolar',
		"INFILTRANT::Papillaire" => 'infiltrative_papillary',
		"INFILTRANT::Micropapillaire" => 'infiltrative_micropapillary',
		"INFILTRANT::Cribriforme" => 'infiltrative_cribriform',
		"INFILTRANT::Lobulaire" => 'infiltrative_lobular',
		"INFILTRANT::Solide" => 'infiltrative_solid',
		"INFILTRANT::Médullaire" => 'infiltrative_medullary',
		"INFILTRANT::Polyadénoïde" => 'infiltrative_polyadenoid',
		"INFILTRANT::Neuroendocrinienne" => 'infiltrative_neuroendocrine',
		"INFILTRANT::Sarcomatoide" => 'infiltrative_sarcomatoid',
		"INFILTRANT::Cellules en bague" => 'infiltrative_ring_cell',
		"INFILTRANT::Cellules Claires" => 'infiltrative_clear_cell',
		"INFILTRANT::Cellules géantes" => 'infiltrative_giant_cells',
		"INFILTRANT::Malpighienne" => 'infiltrative_malpighian',
		"INFILTRANT::Épidermoide" => 'infiltrative_epidermoid',
		"INFILTRANT::Pléomorphe" => 'infiltrative_pleomorphic',
		"INFILTRANT::Basal-Like" => 'infiltrative_basal_like'
	);
	foreach($infiltrant_fields as $file_field => $db_field) {
		$file_field = utf8_decode($file_field);
		$m->values[$db_field] = '';	
		if(strlen($m->values[$file_field])) {
			if($m->values[$file_field] != 'x') {
				$file_field_initial = $m->values[$file_field];
				$m->values[$file_field] = preg_replace(array('/^x {0,1}\((.*)\)$/','/^\((.*)\)$/'), array('$1','$1'), $m->values[$file_field]);
				Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Infiltrative values'][] = "The value ($file_field_initial) of the field [$file_field] is different than 'x': Will defined value as 'yes' and add data (".$m->values[$file_field].") to notes! Please confirm! [Line: ".$m->line.']';
				$dx_notes .= (empty($dx_notes)? '' : ' || ').'Infiltrant - '.str_replace('INFILTRANT::','',utf8_encode($file_field)).' : '.utf8_encode($m->values[$file_field]);
			}	
			$m->values[$db_field] = 'y';	
			$br_dx_data_exist['Infiltrative'] = 'Infiltrative';	
		}
	}
	
	if(strlen($m->values["INFILTRANT::Grade SBR"])) $br_dx_data_exist['Infiltrative'] = 'Infiltrative';	
	
	// fields: 'INTRACANALAIRE'
	
	$intracanal_fields = array(
		"INTRACANALAIRE (IN SITU)::Papillaire" => 'intraductal_papillary',
		"INTRACANALAIRE (IN SITU)::Ductal" => 'intraductal_ductal',
		"INTRACANALAIRE (IN SITU)::Lobulaire" => 'intraductal_lobular',
		"INTRACANALAIRE (IN SITU)::Micropapillaire" => 'intraductal_micropapillary',
		"INTRACANALAIRE (IN SITU)::Cribriforme" => 'intraductal_cribriform',
		"INTRACANALAIRE (IN SITU)::Apocrine" => 'intraductal_apocrine',
		"INTRACANALAIRE (IN SITU)::Comédocarcinome" => 'intraductal_comedocarcinoma',
		"INTRACANALAIRE (IN SITU)::Solide" => 'intraductal_solid',
		"INTRACANALAIRE (IN SITU)::IntraCanalaire(Pas spécification)" => 'intraductal_intraductal_not_specified'
	);
	foreach($intracanal_fields as $file_field => $db_field) {
		$file_field = utf8_decode($file_field);
		$m->values[$db_field] = '';	
		if(strlen($m->values[$file_field])) {
			if($m->values[$file_field] != 'x') {
				$file_field_initial = $m->values[$file_field];
				$m->values[$file_field] = preg_replace(array('/^x {0,1}\((.*)\)$/','/^\((.*)\)$/'), array('$1','$1'), $m->values[$file_field]);
				Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Intraductal values'][] = "The value ($file_field_initial) of the field [$file_field] is different than 'x': Will defined value as 'yes' and add data (".$m->values[$file_field].") to notes! Please confirm! [Line: ".$m->line.']';
				$dx_notes .= (empty($dx_notes)? '' : ' || ').'Intracanalaire (in situ) -  '.str_replace('INTRACANALAIRE (IN SITU)::','',utf8_encode($file_field)).' : '.utf8_encode($m->values[$file_field]);
			}	
			$m->values[$db_field] = 'y';	
			$br_dx_data_exist['Intraductal'] = 'Intraductal';	
		}
	}
	
	if(strlen($m->values["INTRACANALAIRE (IN SITU)::Grade NG (Holland)"])) $br_dx_data_exist['Intraductal'] = 'Intraductal';	

	$file_field = "INTRACANALAIRE (IN SITU)::% de l'infiltrant";
	$db_field = 'intraductal_perc_of_infiltrating';
	$m->values[$file_field] = preg_replace(array('/^ND$/i'), array(''), $m->values[$file_field]);
	$m->values[$db_field] = '-9999';
	if(strlen($m->values[$file_field])) {
		if(!preg_match('/^(0|[1-9]|[1-9][0-9]|100)$/', $m->values[$file_field], $matches)) {
			Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']["'% de l'infiltrant' values"][] = "The value (".$m->values[$file_field].") of the field [$file_field] is not an integer 0 < < 101! Value will just added to notes or please correct! [Line: ".$m->line.']';
			$dx_notes .= (empty($dx_notes)? '' : ' || ')."Intracanalaire (in situ) - % de l'infiltrant : ".utf8_encode($m->values[$file_field]);		
		} else {
			$m->values[$db_field] = $m->values[$file_field];					
		}
		$br_dx_data_exist['Intraductal'] = 'Intraductal';		
	}
			
	// fields: 'GANGLIONS'	

	if(strlen($m->values["GANGLIONS::Chirurgie aisselle"])) $br_dx_data_exist['Ganglions'] = 'Ganglions';	
	if(strlen($m->values["GANGLIONS::Ganglion Sentinelle"])) $br_dx_data_exist['Ganglions'] = 'Ganglions';	

	foreach(array('GANGLIONS::Nb Total'=>'ganglion_total','GANGLIONS::Nb Envahis'=>'ganglion_invaded') as $file_field => $db_field) {
		$m->values[$db_field] = '-9999';
		if(strlen($m->values[$file_field]) && ($m->values[$file_field] != 'ND')) {
			if(!preg_match('/^([0-9]{1,6})$/', $m->values[$file_field], $matches)) {
				Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@'][$file_field][] = "The value (".$m->values[$file_field].") of the field [$file_field] is not an integer! Please correct! [Line: ".$m->line.']';
			} else {
				$m->values[$db_field] = $m->values[$file_field];		
			}
			$br_dx_data_exist['Ganglions'] = 'Ganglions';	
		}
  	}	

 	// fields: 'observation'
	
	$observation_fields = array(
		"OBSERVATIONS (Oui/Non)::Nécrose" => 'observation_necrosis',
		"OBSERVATIONS (Oui/Non)::Microcalcifications" => 'observation_microcalcifications',
		"OBSERVATIONS (Oui/Non)::Perméations angiolymphatiques" => 'observation_angiolymphatic_invasion',
		"OBSERVATIONS (Oui/Non)::Tumeur à multiples foyers" => 'observation_multiple_foci_tumor',
		"OBSERVATIONS (Oui/Non)::Microinvasion" => 'observation_microinvasion',
		"OBSERVATIONS (Oui/Non)::Métastases à distance" => 'observation_distant_metastasis',
		"OBSERVATIONS (Oui/Non)::Modifications fibrokystiques atypiques" => 'observation_atypical_fibrocystic_changes',
		"OBSERVATIONS (Oui/Non)::Atteinte du mamelon (Paget)" => 'observation_nipple_affected',
		"OBSERVATIONS (Oui/Non)::Atteinte de l'épiderme" => 'observation_epidermis_affected'	
	);
	foreach($observation_fields as $file_field => $db_field) {
		$file_field = utf8_decode($file_field);
		$m->values[$db_field] = '';	
		if(strlen($m->values[$file_field]) && ('ND' != $m->values[$file_field])) {
			if(in_array($m->values[$file_field], array('x','+','oui'))) {
				$m->values[$db_field] = 'y';
			} else if(in_array($m->values[$file_field], array('-','non'))) {
				$m->values[$db_field] = 'n';
			} else {
				$m->values[$db_field] = 'y';
				Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Observation values'][] = "The value (".$m->values[$file_field].") of the field [$file_field] is different than '-,oui,non,+,x': Will defined value as 'yes' and add data (".$m->values[$file_field].") to notes! Please confirm! [Line: ".$m->line.']';
				$dx_notes .= (empty($dx_notes)? '' : ' || '). 'Observations - '. str_replace('OBSERVATIONS (Oui/Non)::','', utf8_encode($file_field)).' : '.utf8_encode($m->values[$file_field]);
			}
			$br_dx_data_exist['Observations'] = 'Observations';	
		}
	}
	
	// 5- SET Breast DX ID, etc
	
	$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['breast']['diagnosis_control_id'];
	$m->values['dx_nature'] = '';
	$note_from_dx = '';
	$tmp_dx = preg_replace('/ $/', '', strtolower($m->values[utf8_decode('Dx sein Normal/Bénin/Cancer/Récidive/Risque élevé/Métastase/Reprise de marge')]));
	
	if(empty($tmp_dx)) {
		if(!empty($br_dx_data_exist)) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Breast Diagnostic Data & No Breast Dx'][] = "No Breast Diagnosis will be created but diagnosis data exists into the file and won't be recorded! Check [". implode(", ",$br_dx_data_exist)."] values. [Line: ".$m->line.']';
		return false;
	}
	
	if(in_array($participant_id, Config::$participant_id_linked_to_br_dx_in_step2)) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Breast Dx defined in step2'][] = "Breast Dx had already been created fot the participant '$frsq_nbr' during step2! Please control dat deeply! [Line: ".$m->line.']';
	
	switch(utf8_encode($tmp_dx)) {
		case "risque élevé":
			$note_from_dx = 'Dx Note: '.utf8_encode($tmp_dx);
		case "à venir 2012-03-01":
		case "à venir 2012-05-04":
			break;
				
		case "cancer (chimio préop)":
		case "cancer d":
		case "cancer g":
		case "cancer droit":
		case "cancer gauche":
		case "cancer, reprise":
		case "reprise de marge cancer":
		case "récidive de 1998":
		case "récidive":
		case "récivide":
		case "pas de cancer résiduel post chimio":
		case "reprise de marge - absence de cancer":
		case "reprise de marge - négative mais cancer en 2004-10":
		case "reprise de marge - négative mais cancer en 2004-12)":
		case "reprise de marge - cancer":
		case "récidive (1995)":
		case "récidive de br350":
		case "récidive #2 (1995, 2001)":
		case "bénin - tissus cancéreux retiré entièrement a la biopsie":
		case "cancer post chimio, réponse complète pas de maladie résiduelle":
		case "cancer post chimio":
		case "reprise marge":
		case "post chimio":
		case "récidive (g)":
		case "reprise de marge normal":
		case "reprise de marge normal":
		case "bénin (sans maladie résiduelle)":
			$note_from_dx = 'Dx Note: '.utf8_encode($tmp_dx);
		case "cancer":
			$m->values['dx_nature'] = 'cancer';
			break;
				
		case "normal":
			$m->values['dx_nature'] = 'normal';
			break;
				
		case "bénin":
			$m->values['dx_nature'] = 'benign';
			break;
				
		case "métastatique gg":
			$note_from_dx = 'Dx Note: '.utf8_encode($tmp_dx);
		case "métastatique":
			$master_fields = array(
				"diagnosis_control_id" => Config::$diagnosis_controls['primary']['primary diagnosis unknown']['diagnosis_control_id'],
				"participant_id" => $m->values['participant_id'],
				"icd10_code" => "'D489'"
			);
			$parent_diagnosis_master_id = customInsertChusRecord($master_fields, 'diagnosis_masters');
			customInsertChusRecord(array('diagnosis_master_id' => $parent_diagnosis_master_id), Config::$diagnosis_controls['primary']['primary diagnosis unknown']['detail_tablename'], true);
			
			$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['secondary']['breast']['diagnosis_control_id'];
			$m->values['dx_nature'] = 'metastatic';
			$m->values['parent_id'] = $parent_diagnosis_master_id;
			break;
			
		default:
			die('ERR 88990303 : ['.$tmp_dx.']');	
	}
	
	if(!empty($note_from_dx)) $dx_notes .= (empty($dx_notes)? '' : ' || ').$note_from_dx;
	
	if(!empty($m->values['Note'])) $dx_notes = utf8_encode($m->values['Note']).(empty($dx_notes)? '' : ' || '.$dx_notes);
	$m->values['notes'] = str_replace("'","''",$dx_notes);	
	
	return true;
}

function postBreastDiagnosesWrite(Model $m){
	global $connection;
	
	if(isset($m->values['parent_id'])) {
		$query = "UPDATE diagnosis_masters SET parent_id = ".$m->values['parent_id']." WHERE id = ".$m->last_id.";";
		mysqli_query($connection, $query) or die("Diag Parent id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$query = str_replace('diagnosis_masters', 'diagnosis_masters_revs', $query);
		mysqli_query($connection, $query) or die("Diag Parent id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
	}
	
	if(!isset(Config::$data_for_import_from_participant_id[$m->values['participant_id']])) die ('ERR 9988939383');
	Config::$data_for_import_from_participant_id[$m->values['participant_id']]['br_diagnosis_ids'][str_replace(' ', '', utf8_encode($m->values['#FRSQ']))][] = $m->last_id;

	participantDataCompletion($m, $m->values['participant_id'], $m->last_id);
}

//======================================================================================================================
// COMPLETE PATIENT DATA FROM FILES
//======================================================================================================================

function participantDataCompletion(Model $m, $participant_id, $diagnosis_master_id = null, $parent_diagnosis_master_id = null) {
	addSurgery($m, $participant_id, $diagnosis_master_id);
	addImmuno($m, $participant_id, $diagnosis_master_id);
	addCa153($m, $participant_id, $diagnosis_master_id);
	addHormono($m, $participant_id, $diagnosis_master_id);
	
	addPrePostTreatment('Radio::Pré op', 'radiation','pre', $m, $participant_id, $diagnosis_master_id);
	addPrePostTreatment('Radio::Post op', 'radiation','post', $m, $participant_id, $diagnosis_master_id);
	addPrePostTreatment('Chimio::Pré op', 'chemotherapy','pre', $m, $participant_id, $diagnosis_master_id);
	addPrePostTreatment('Chimio::Post op', 'chemotherapy','post', $m, $participant_id, $diagnosis_master_id);	
}

function addSurgery(Model $m, $participant_id, $diagnosis_master_id = null) {
	$surgery_data = array('master' => array(), 'detail' => array());
	$notes = '';
	
	$m->values['Date chirurgie'] = str_replace(array('Inconnue','ND'), array('',''), $m->values['Date chirurgie']);
	if(!empty($m->values['Date chirurgie'])) {
		if(preg_match('/^([0-9]{5})$/',$m->values['Date chirurgie'],$matches)) {
			$surgery_data['master']['start_date'] =  customGetFormatedDate($m->values['Date chirurgie'], 'Diagnostique', $m->line);
			$surgery_data['master']['start_date_accuracy'] = "c";
		} else {
			Config::$summary_msg['SURGERY']['@@WARNING@@']['Date format'][] = "Surgery date [".$m->values['Date chirurgie']."] can not be recorded as date! Will be added to note! [Line: ".$m->line.']';
			$notes = 'Date : ' . $m->values['Date chirurgie'];
		}
	}
	
	$m->values['#Rapport Pathologie'] = str_replace(array('Inconnue','ND'), array('',''), $m->values['#Rapport Pathologie']);
	if(!empty($m->values['#Rapport Pathologie'])) {
		$surgery_data['detail']['patho_report_number'] = $m->values['#Rapport Pathologie'];
	}	
	
	$m->values['TAILLE (mm)'] = str_replace(array('ND'), array(''), $m->values['TAILLE (mm)']);
	if(!empty($m->values['TAILLE (mm)'])) {
		if(preg_match('/^([0-9]{1,8}|[0-9]{1,7}\.[0-9])$/',$m->values['TAILLE (mm)'],$matches)) {
			$surgery_data['detail']['size_mm'] =  $m->values['TAILLE (mm)'];
		} else {
			Config::$summary_msg['SURGERY']['@@WARNING@@']['Taille format'][] = "Surgery size [".$m->values['TAILLE (mm)']."] can not be recorded as size! Will be added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' || ').'Taille (mm) : ' . $m->values['TAILLE (mm)'];
		}
	}	
	
	$other_fields = array('breast_reduction' => 'CHIRURGIE::Réduct. Mammaire',
		'prophylaxis' => 'CHIRURGIE::Prophylaxie',
		'partial_mastectomy' => 'CHIRURGIE::Mastect. Partielle',
		'total_mastectomy' => 'CHIRURGIE::Mastect. Totale',
		'partial_mastectomy_revision' => 'CHIRURGIE::Mastect. Partielle RÉVISION',  
		'axillary_dissection' => 'CHIRURGIE::Évidemment axillaire',
		'biopsy' => 'CHIRURGIE::Biopsie'
	);
	foreach($other_fields as $db_field => $file_field) {
		$file_field = utf8_decode($file_field);
		if(!empty($m->values[$file_field])) {
			if($m->values[$file_field] == 'x') {
				$surgery_data['detail'][$db_field] = 'y';
			} else {
				Config::$summary_msg['SURGERY']['@@ERROR@@']['Surgery precision'][] = "Surgery '$file_field' value [".$m->values[$file_field]."] is different than 'x'! Data won't be recorded! [Line: ".$m->line.']';	
			}
		}
	}
	
	if(!empty($notes)) $surgery_data['master']['notes'] = $notes;
	
	if(!empty($surgery_data['master']) || !empty($surgery_data['detail'])) {
		$surgery_data['detail']['laterality'] = $m->values['laterality'];
		
		foreach($surgery_data['master'] as $key => $value) $surgery_data['master'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		foreach($surgery_data['detail'] as $key => $value) $surgery_data['detail'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		
		$surgery_data['master']['participant_id'] = $participant_id;
		$surgery_data['master']['treatment_control_id'] = Config::$treatment_controls['surgery']['breast']['treatment_control_id'];

		if($diagnosis_master_id) $surgery_data['master']['diagnosis_master_id'] = $diagnosis_master_id;
		
		$treatment_master_id = customInsertChusRecord($surgery_data['master'], 'treatment_masters');
		$surgery_data['detail']['treatment_master_id'] = $treatment_master_id;
		customInsertChusRecord($surgery_data['detail'], Config::$treatment_controls['surgery']['breast']['detail_tablename'], true);		
	}
}	

function addImmuno(Model $m, $participant_id, $diagnosis_master_id = null) {
	$event_data = array('master' => array(), 'detail' => array());
	$notes = '';
	
	$fields_set = array('ER_result' => 'IHC::ER',
		'PR_result' => 'IHC::PR',
		'Her2_Neu_result' => 'IHC::Her2/Neu',
		'EGFR_result' => 'IHC::EGFR'
	);
	foreach($fields_set as $db_field => $file_field) {
		$file_field = utf8_decode($file_field);
		$value = preg_replace('/^ND$/','',$m->values[$file_field]);
		if(!empty($value)) {
			switch($value) {
				case '+':
					$event_data['detail'][$db_field] = 'positive';
					break;
				case '-':
					$event_data['detail'][$db_field] = 'negative';
					break;
				default:
				Config::$summary_msg['IMMUNO']['@@WARNING@@']['Immuno data'][] = "Immuno '$file_field' value [$value] is different than '-' or '+'! Data will be added to note!! [Line: ".$m->line.']';	
				$notes .= (empty($notes)? '' : ' || ').$file_field.' : ' . $value;
			}
		}
	}
	
	if(!empty($notes)) $event_data['master']['event_summary'] = $notes;
	
	if(!empty($event_data['master']) || !empty($event_data['detail'])) {
		foreach($event_data['master'] as $key => $value) $event_data['master'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		foreach($event_data['detail'] as $key => $value) $event_data['detail'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		
		$event_data['master']['participant_id'] = $participant_id;
		$event_data['master']['event_control_id'] = Config::$event_controls['lab']['breast']['immunohistochemistry']['event_control_id'];

		if($diagnosis_master_id) $event_data['master']['diagnosis_master_id'] = $diagnosis_master_id;
		
		$event_master_id = customInsertChusRecord($event_data['master'], 'event_masters');
		$event_data['detail']['event_master_id'] = $event_master_id;
		customInsertChusRecord($event_data['detail'], Config::$event_controls['lab']['breast']['immunohistochemistry']['detail_tablename'], true);		
	}
}

function addCa153(Model $m, $participant_id, $diagnosis_master_id = null) {
	$event_data = array('master' => array(), 'detail' => array());
	$notes = '';
	
	$value = preg_replace('/^ND$/','',$m->values['CA15,3 au Dx']);
	if(!empty($value)) {	
		if(preg_match('/^([0-9]{1,8}|[0-9]{1,7}\.[0-9])$/',$value,$matches)) {
			$event_data['detail']['value'] =  $value;
		
		} else if(preg_match('/^([0-9]{1,8}|[0-9]{1,7}\,[0-9]) {0,1}\((20|19)([0-9]{2})\)$/',$value,$matches)) {
			$event_data['detail']['value'] =  str_replace(',','.',$matches[1]);
			$event_data['master']['event_date'] = $matches[2].$matches[3].'-01-01';
			$event_data['master']['event_date_accuracy'] = 'm';
			
		} else if(preg_match('/^([0-9]{1,8}|[0-9]{1,7}\,[0-9]) {0,1}\((20|19)([0-9]{2}-[01][0-9])\)$/',$value,$matches)) {
			$event_data['detail']['value'] =  str_replace(',','.',$matches[1]);
			$event_data['master']['event_date'] = $matches[2].$matches[3].'-01';
			$event_data['master']['event_date_accuracy'] = 'd';		

		} else if(preg_match('/^\(post op ([0-9]{1,8}|[0-9]{1,7}\,[0-9]) : (20|19)([0-9]{2}-[01][0-9])\)$/',$value,$matches)) {
			$event_data['detail']['value'] =  str_replace(',','.',$matches[1]);
			$event_data['master']['event_date'] = $matches[2].$matches[3].'-01';
			$event_data['master']['event_date_accuracy'] = 'd';						
			$event_data['master']['event_summary'] = 'Post op.';
			
		} else if(preg_match('/^\(post op (20|19)([0-9]{2}-[01][0-9]) : ([0-9]{1,8}|[0-9]{1,7}\,[0-9])\)$/',$value,$matches)) {
			$event_data['detail']['value'] =  str_replace(',','.',$matches[3]);
			$event_data['master']['event_date'] = $matches[1].$matches[2].'-01';
			$event_data['master']['event_date_accuracy'] = 'd';						
			$event_data['master']['event_summary'] = 'Post op.';
						
		} else if(preg_match('/^\(post op (20|19)([0-9]{2}) : ([0-9]{1,8}|[0-9]{1,7}\,[0-9])\)$/',$value,$matches)) {
			$event_data['detail']['value'] =  str_replace(',','.',$matches[3]);
			$event_data['master']['event_date'] = $matches[1].$matches[2].'-01-01';
			$event_data['master']['event_date_accuracy'] = 'm';						
			$event_data['master']['event_summary'] = 'Post op.';				
		
		} else if($value == '15,4 (post-op, 2006)') {	
			$event_data['detail']['value'] = '15.4';
			$event_data['master']['event_date'] = '2006-01-01';
			$event_data['master']['event_date_accuracy'] = 'm';						
			$event_data['master']['event_summary'] = 'Post op.';	
						
		} else {	
			Config::$summary_msg['CA15,3']['@@WARNING@@']['Ca15,3 format'][] = "Ca15,3 = '$value' can not be recorded as is! Will be added to note! [Line: ".$m->line.']';
			$event_data['master']['event_summary'] = preg_replace('/^\((.*)\)$/','$1',$value);
		}
	}

	if(!empty($event_data['master']) || !empty($event_data['detail'])) {
		foreach($event_data['master'] as $key => $value) $event_data['master'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		foreach($event_data['detail'] as $key => $value) $event_data['detail'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		
		$event_data['master']['participant_id'] = $participant_id;
		$event_data['master']['event_control_id'] = Config::$event_controls['lab']['breast']['CA15.3']['event_control_id'];

		if($diagnosis_master_id) $event_data['master']['diagnosis_master_id'] = $diagnosis_master_id;
		
		$event_master_id = customInsertChusRecord($event_data['master'], 'event_masters');
		$event_data['detail']['event_master_id'] = $event_master_id;
		customInsertChusRecord($event_data['detail'], Config::$event_controls['lab']['breast']['CA15.3']['detail_tablename'], true);		
	}
}

function addHormono(Model $m, $participant_id, $diagnosis_master_id = null) {
	$trt_data = array('master' => array(), 'detail' => array());
	
	$value = preg_replace(array('/^ND$/', '/^a venir$/' , '/^non$/'), array('','',''),$m->values[utf8_decode('Hormonothérapie Post op  (oui/non)')]);
	if(!empty($value)) {
		$value = preg_replace(array('/^oui$/', '/^oui {0,1}\((.*)\)$/'), array('','$1'), $value);
		$trt_data['master']['notes'] = $value;
		$trt_data['detail']['pre_post_surgery'] = 'post';
	}

	if(!empty($trt_data['master']) || !empty($trt_data['detail'])) {
		foreach($trt_data['master'] as $key => $value) $trt_data['master'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		foreach($trt_data['detail'] as $key => $value) $trt_data['detail'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		
		$trt_data['master']['participant_id'] = $participant_id;
		$trt_data['master']['treatment_control_id'] = Config::$treatment_controls['hormonotherapy']['breast']['treatment_control_id'];

		if($diagnosis_master_id) $trt_data['master']['diagnosis_master_id'] = $diagnosis_master_id;
		
		$treatment_master_id = customInsertChusRecord($trt_data['master'], 'treatment_masters');
		$trt_data['detail']['treatment_master_id'] = $treatment_master_id;
		customInsertChusRecord($trt_data['detail'], Config::$treatment_controls['hormonotherapy']['breast']['detail_tablename'], true);		
	}
}

function addPrePostTreatment($file_field, $treatment_type, $pre_post, Model $m, $participant_id, $diagnosis_master_id = null) {
	global $connection;
	
	$trt_control = Config::$treatment_controls[$treatment_type]['breast'];
	
	$trt_data = array('master' => array(), 'detail' => array());
	
	$value = preg_replace(array('/^ {0,1}/', '/ {0,1}$/', '/^Oui(.*)$/', '/^ND$/', '/^non$/', '/^Non$/','/^a venir$/'), array('', '', 'oui$1', '','','',''),$m->values[utf8_decode($file_field)]);
	if(!empty($value)) {
		if(in_array($value, array('x','n'))) {
			Config::$summary_msg[strtoupper($file_field)]['@@ERROR@@']['Unknown value'][] = "Value = '$value' for field '$file_field' is not supported! No data will be imported! [Line: ".$m->line.']';
			return;
		}
		
		if(!in_array($pre_post, array('pre','post'))) die('ERR 99849984');
		$trt_data['detail']['pre_post_surgery'] = $pre_post;
		
		$start_date = null;
		$finish_date = null;
		$note = '';
		
		if($value != 'oui') {
			if(preg_match('/^(19|20)([0-9]{2})$/',$value,$matches)) {
				//2006
				$start_date = $matches[1].$matches[2];
			} else if(preg_match('/^oui {0,1}\((19|20)([0-9]{2})\)$/',$value,$matches)) {
				//oui (2003)
				$start_date = $matches[1].$matches[2];
			} else if(preg_match('/^oui {0,1}(19|20)([0-9]{2})$/',$value,$matches)) {
				//oui 2003
				$start_date = $matches[1].$matches[2];
			} else if(preg_match('/^oui \((19|20)([0-9]{2})(\-) {0,1}(19|20)([0-9]{2})\)$/',$value,$matches)) {
				//oui (2003-2004)
				//oui (1991- 2003)
				$start_date = $matches[1].$matches[2];
				$finish_date = $matches[4].$matches[5];
			} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([9][0-9])\)$/',$value,$matches)) {
				//oui (1993-94)
				$start_date = $matches[1].$matches[2];
				$finish_date = $matches[1].$matches[3];
			} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([01][0-9])\)$/',$value,$matches)) {
				//oui (2005-01)
				$start_date = $matches[1].$matches[2].'-'.$matches[3];	
			} else if(preg_match('/^oui \((19|20)([0-9]{2})(\-[01][0-9]){0,1}(\-[0-3][0-9]){0,1} au (19|20)([0-9]{2})(\-[01][0-9]){0,1}(\-[0-3][0-9]){0,1}\)$/',$value,$matches)) {
				//oui (2003-03-25 au 2007-11-15)
				$start_date = $matches[1].$matches[2].$matches[3].$matches[4];	
				$finish_date = $matches[5].$matches[6].(isset($matches[7])?$matches[7]:'').(isset($matches[8])?$matches[8]:'');	

			} else if($value == "oui(2003-05 au 09) 50 Gy en 5 sem. 25 fractions"){
				$start_date = '2003-05';
				$finish_date = '2003-09';
				$note = '50 Gy en 5 sem. 25 fractions';
			} else if($value == "oui FEC-D (6 cycles 2011-04 au 2011-08)"){
				$start_date = '2011-04';
				$finish_date = '2011-08';
				$note = 'FEC-D (6 cycles)';
			} else if($value == "oui (2004) 8 cycles: 4AC, 4 taxol"){
				$start_date = '2004';
				$finish_date = '';
				$note = '8 cycles: 4AC, 4 taxol';
			} else if($value == utf8_decode("oui (Néo sein droit en 2004)")) {
				$start_date = '2004';
				$finish_date = '';
				$note = 'Néo sein droit';
			
			} else if(preg_match('/^refus$/i',$value,$matches)) {
				$query = "select id, notes from participants where id = $participant_id;";
				$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
				$row = $results->fetch_assoc();
				if(empty($row)) die('ERR7748484774');
				$new_note = (empty($row['notes'])? '' : ' // ').$file_field . ' : Refus';			
				$query = "UPDATE participants SET notes = CONCAT(IFNULL(notes, ''), '$new_note') WHERE id = $participant_id;";				
				mysqli_query($connection, $query) or die("participant  notes update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$query = str_replace('participants','participants_revs', $query);
				mysqli_query($connection, $query) or die("participant  notes update  [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
				
				return;
				
			} else {
				$note = preg_replace(array('/^oui {0,1}/', '/^\((.*)\)$/'), array('', '$1'),$value);
			}
		}
	}
		
	if(!empty($start_date)) {
		$date_tmp = getDateAndAccuracy($start_date);
		$start_date = $date_tmp['date'];
		$trt_data['master']['start_date'] = $date_tmp['date'];
		$trt_data['master']['start_date_accuracy'] = $date_tmp['accuracy'];
	}
	if(!empty($finish_date)) {		
		$date_tmp = getDateAndAccuracy($finish_date);
		$finish_date = $date_tmp['date'];		
		$trt_data['master']['finish_date'] = $date_tmp['date'];
		$trt_data['master']['finish_date_accuracy'] = $date_tmp['accuracy'];
	}	
	if(!empty($start_date) && !empty($finish_date) && (str_replace('-','',$start_date) > str_replace('-','',$finish_date))) {
		Config::$summary_msg[strtoupper($file_field)]['@@ERROR@@']['Date error'][$trt_data] = "Dates definition error (from $start_date to $finish_date)! [Line: ".$m->line.']';		
	}
	if(!empty($note)) $trt_data['master']['notes'] = $note;

	if(!empty($trt_data['master']) || !empty($trt_data['detail'])) {
		foreach($trt_data['master'] as $key => $value) $trt_data['master'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		foreach($trt_data['detail'] as $key => $value) $trt_data['detail'][$key] = utf8_encode("'".str_replace("'","''",$value)."'");
		
		$trt_data['master']['participant_id'] = $participant_id;
		$trt_data['master']['treatment_control_id'] = $trt_control['treatment_control_id'];
		
		if($diagnosis_master_id) $trt_data['master']['diagnosis_master_id'] = $diagnosis_master_id;
		
		$treatment_master_id = customInsertChusRecord($trt_data['master'], 'treatment_masters');
		$trt_data['detail']['treatment_master_id'] = $treatment_master_id;
		customInsertChusRecord($trt_data['detail'], $trt_control['detail_tablename'], true);		
	}
}
