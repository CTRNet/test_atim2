<?php
$pkey = "#FRSQ";

$child = array();

$master_fields = array(
	"diagnosis_control_id" => "#diagnosis_control_id",
	"participant_id" => "#participant_id",
//	"primary_id" => "#primary_id",
//	"parent_id" => "#parent_id",
//	"age_at_dx" => "Age au Dx",

	"path_stage_summary" => "STADE (1-4)",
	"path_tstage" => "T",
	"path_nstage" => "N",
	"path_mstage" => "M",

	"notes" => "#notes"
);
$detail_fields = array(

	"atcd" => "#atcd",
	"atcd_description" => "ATCD Cancer de l'ovaire (oui/non)",

	"left_ovary_dx_nature" => "#left_ovary_dx_nature",
	"left_ovary_tumour_grade" => array("GRADE OV G" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"1-2"=>"2",
		"2-3"=>"3",
		"1, 3"=>"3",
		"LMP"=>"LMP",
		"ND"=>"ND")),
	"left_ovary_serous" => array(utf8_decode("Morphologie Ov GAUCHE::Séreux") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_papillary" => array("Morphologie Ov GAUCHE::Papillaire" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_mucinous" => array("Morphologie Ov GAUCHE::Mucineux" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_endometrioid_endometriotic_endometriosis" => array(utf8_decode("Morphologie Ov GAUCHE::Endométrioide/endométriotique/endométriosique") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_squamous" => array("Morphologie Ov GAUCHE::Malpighien" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_Krukenberg" => array("Morphologie Ov GAUCHE::Krukenberg" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_mullerian" => array("Morphologie Ov GAUCHE::Mullerien" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_granulosa" => array("Morphologie Ov GAUCHE::Granulosa" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_squamous_dermoid" => array(utf8_decode("Morphologie Ov GAUCHE::Épidermoide") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_mature_teratoma" => array(utf8_decode("Morphologie Ov GAUCHE::Tératome Mature") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_immature_teratoma" => array(utf8_decode("Morphologie Ov GAUCHE::Tératome Immature") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_brenner" => array("Morphologie Ov GAUCHE::Brenner" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_neuroendocrine" => array("Morphologie Ov GAUCHE::Neuroendocrine" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_sarcoma" => array("Morphologie Ov GAUCHE::Sarcome" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_clear_cell" => array("Morphologie Ov GAUCHE::Clear Cell" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_small_cell" => array("Morphologie Ov GAUCHE::Small Cell" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_sex_cord" => array("Morphologie Ov GAUCHE::Sex cord" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_cells_in_cat_rings" => array("Morphologie Ov GAUCHE::Cellules en bague de chaton" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_struma_ovarii" => array("Morphologie Ov GAUCHE::Struma Ovarii" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_fibroma" => array("Morphologie Ov GAUCHE::Firbome" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_atrophic" => array("Morphologie Ov GAUCHE::Atrophique" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_fallopian_tube_lesion" => array(utf8_decode("Morphologie Ov GAUCHE::Lésion trompe") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_fibrothecoma" => array(utf8_decode("Morphologie Ov GAUCHE::Fibrothécale") => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_polycystic" => array("Morphologie Ov GAUCHE::Polykystique" => array(""=>""," "=>"","x"=>"y")),
	"left_ovary_inclusion_cyst" => array("Morphologie Ov GAUCHE::Kyste d'inclusion" => array(""=>""," "=>"","x"=>"y")),
	
	"right_ovary_dx_nature" => "#right_ovary_dx_nature",
	"right_ovary_tumour_grade" => array("GRADE OV D" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"1-2"=>"2",
		"2-3"=>"3",
		"1, 3"=>"3",
		"LMP"=>"LMP",
		"ND"=>"ND")),
	"right_ovary_serous" => array(utf8_decode("Morphologie Ov DROIT::Séreux") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_papillary" => array("Morphologie Ov DROIT::Papillaire" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_mucinous" => array("Morphologie Ov DROIT::Mucineux" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_endometrioid_endometriotic_endometriosis" => array(utf8_decode("Morphologie Ov DROIT::Endométrioide/endométriotique/endométriosique") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_squamous" => array("Morphologie Ov DROIT::Malpighien" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_Krukenberg" => array("Morphologie Ov DROIT::Krukenberg" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_mullerian" => array("Morphologie Ov DROIT::Mullerien" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_granulosa" => array("Morphologie Ov DROIT::Granulosa" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_squamous_dermoid" => array(utf8_decode("Morphologie Ov DROIT::Épidermoide/Dermoide") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_mature_teratoma" => array(utf8_decode("Morphologie Ov DROIT::Tératome Mature") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_immature_teratoma" => array(utf8_decode("Morphologie Ov DROIT::Tératome Immature") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_brenner" => array("Morphologie Ov DROIT::Brenner" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_neuroendocrine" => array("Morphologie Ov DROIT::Neuroendocrine" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_sarcoma" => array("Morphologie Ov DROIT::Sarcome" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_clear_cell" => array("Morphologie Ov DROIT::Clear Cell" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_small_cell" => array("Morphologie Ov DROIT::Small Cell" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_sex_cord" => array("Morphologie Ov DROIT::Sex cord" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_cells_in_cat_rings" => array("Morphologie Ov DROIT::Cellules en bagues de chaton" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_struma_ovarii" => array("Morphologie Ov DROIT::Struma Ovarii" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_fibroma" => array("Morphologie Ov DROIT::Fibrome" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_atrophic" => array("Morphologie Ov DROIT::Atrophique" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_fallopian_tube_lesion" => array(utf8_decode("Morphologie Ov DROIT::Lésion trompe") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_fibrothecoma" => array(utf8_decode("Morphologie Ov DROIT::Fibrothécale") => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_polycystic" => array("Morphologie Ov DROIT::Polykystique" => array(""=>""," "=>"","x"=>"y")),
	"right_ovary_inclusion_cyst" => array("Morphologie Ov DROIT::Kyste d'inclusion" => array(""=>""," "=>"","x"=>"y")),

	"uncertain_dx" => "#uncertain_dx"
);

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, NULL, NULL, 'diagnosis_masters', $master_fields, 'chus_dxd_ovaries', 'diagnosis_master_id', $detail_fields);

//$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'treatment_masters', $master_fields, 'txd_surgeries', 'treatment_master_id', $detail_fields);
//$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postOvaryDiagnosesRead';
$model->post_write_function = 'postOvaryDiagnosesWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['OvaryDiagnosisMaster'] = $model;
	
function postOvaryDiagnosesRead(Model $m){
	global $connection;
	
	$m->values['notes'] = '';
	
	// 1- GET PARTICIANT ID & PARTICIPANT CHECK
	
	$frsq_nbr = str_replace(' ', '', utf8_encode($m->values['#FRSQ']));
	$paticipant_id = isset(Config::$participant_id_from_frsq_nbr[$frsq_nbr])? Config::$participant_id_from_frsq_nbr[$frsq_nbr] : null;
	if(!$paticipant_id)  {
		$frsq_nbrs = preg_replace(array('/(\({0,1}voir)/i','/(\))/','/(\()/','/([A-Z]+)([0-9]+),([0-9]+)/'), array('-', '','-','$1$2-$1$3'), $frsq_nbr);
		$frsq_nbrs = explode('-',$frsq_nbrs);
		if(sizeof($frsq_nbrs) != 2) die('ERR 989388393 : Unable to match FRSQ#' .$m->values['#FRSQ']);
		
		$part_id_0 = isset(Config::$participant_id_from_frsq_nbr[$frsq_nbrs[0]])? Config::$participant_id_from_frsq_nbr[$frsq_nbrs[0]] : null;
		$part_id_1 = isset(Config::$participant_id_from_frsq_nbr[$frsq_nbrs[1]])? Config::$participant_id_from_frsq_nbr[$frsq_nbrs[1]] : null;
		
		if($part_id_0) {
			if($part_id_0 == $part_id_1) {
				$paticipant_id = $part_id_0;
			} else if(!$part_id_1) {
				$paticipant_id = $part_id_0;
				Config::$summary_msg['@@WARNING@@']['Participant With Many Ids #1'][] = "The FRSQ# '".$frsq_nbrs[1]."' has not beend recorded by Step1! Will assigned data to the other FRSQ# '".$frsq_nbrs[0]."'! [line: ".$m->line.']';
			} else {
				Config::$summary_msg['@@ERROR@@']['Participant With Many Ids #2'][] = "The FRSQ#(s) '".$frsq_nbrs[0]."' & '".$frsq_nbrs[1]."' has beend assigned to the same participant in step2 but match 2 different participants in step 1! [line: ".$m->line.']';
				return false;
			}
		} else {
			if($part_id_1) {
				$paticipant_id = $part_id_1;
				Config::$summary_msg['@@WARNING@@']['Participant With Many Ids #1'][] = "The FRSQ# '".$frsq_nbrs[0]."' has not beend recorded by Step1! [Will assigned data to the other FRSQ# '".$frsq_nbrs[1]."'! line: ".$m->line.']';
			} else {
				Config::$summary_msg['@@ERROR@@']['Participant With Many Ids #3'][] = "The FRSQ#(s) '".$frsq_nbrs[0]."' & '".$frsq_nbrs[1]."' has beend assigned to the same participant in step2 but match no participant in step 1! [line: ".$m->line.']';
				return false;
			}
		}
	} 
	$m->values['participant_id'] = $paticipant_id;
	
	if(!isset(Config::$data_for_import_from_participant_id[$paticipant_id])) die('ERR 9983933');
	if(Config::$data_for_import_from_participant_id[$paticipant_id]['data_imported_from_ov_file']) {
		Config::$summary_msg['@@MESSAGE@@']['Participant & Many Rows #1'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$paticipant_id]['#FRSQ OV'])."] has data recorded in many rows of the ovary bank file! Please check import deeply! [Line: ".$m->line.']';
	}
	Config::$data_for_import_from_participant_id[$paticipant_id]['data_imported_from_ov_file'] = true;
	
		// 2- CREATE CONSENT
	
	$consent_date = customGetFormatedDate($m->values[utf8_decode('Date (année-mois-jour)')]);
	if(empty($consent_date)) {
		die('ERR empty consent date line '.$m->line);
	}
	if(isset(Config::$data_for_import_from_participant_id[$paticipant_id]['consent_date'])) {
		if($consent_date != Config::$data_for_import_from_participant_id[$paticipant_id]['consent_date']) {
			Config::$summary_msg['@@WARNING@@']['Participant & Many Consent Dates'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$paticipant_id]['#FRSQ OV'])."] has different consent dates defined in many rows of the OV file! Only one consent will be created! [Line: ".$m->line.']';
		}
	} else {
		$master_fields = array(
			"consent_control_id" => "2",
			"participant_id" => $m->values['participant_id'],
			"consent_status" => "'obtained'",
			"status_date" => "'$consent_date'",
			"consent_signed_date" => "'$consent_date'");
		$consent_master_id = customInsertChusRecord($master_fields, 'consent_masters');
		customInsertChusRecord(array('consent_master_id' => $consent_master_id), 'cd_nationals', true);
		
		Config::$data_for_import_from_participant_id[$paticipant_id]['consent_date'] = $consent_date;
	}
	
	// 3- UPDATE PARTICIPANT BIRTH DATE
	
	$date_of_birth = customGetFormatedDate($m->values[utf8_decode('Date Naissance JJ-MM-AAAA')]);
	if($date_of_birth) {
		if(isset(Config::$data_for_import_from_participant_id[$paticipant_id]['date_of_birth'])) {
			if($date_of_birth != Config::$data_for_import_from_participant_id[$paticipant_id]['date_of_birth']) {
				Config::$summary_msg['@@WARNING@@']['Participant & Birth Date #1'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$paticipant_id]['#FRSQ OV'])."] has different birth dates defined in many rows of the OV file! [Line: ".$m->line.']';
			}
		} else {
			$query = "UPDATE participants SET date_of_birth = '$date_of_birth' WHERE id = ".$m->values['participant_id'].";";
			mysqli_query($connection, $query) or die("birth date update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$query = str_replace('participants','participants_revs', $query);
			mysqli_query($connection, $query) or die("birth date update  [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		Config::$data_for_import_from_participant_id[$paticipant_id]['date_of_birth'] = $date_of_birth;
	}

	// 4- SET DX DATA & CONTROL DATA
	
	$ov_dx_data_exist = false;
	
	// field: 'STADE (1-4)'
	
	if(strlen($m->values['STADE (1-4)']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'STADE (1-4)' [".$m->values['STADE (1-4)']."] value is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['T']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'T' value  [".$m->values['T']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['N']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'N' value  [".$m->values['N']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['M']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'M' value  [".$m->values['M']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(doesValueExist($m->values['STADE (1-4)']) || doesValueExist($m->values['T']) || doesValueExist($m->values['N']) || doesValueExist($m->values['M'])) $ov_dx_data_exist = true;
	
	// field: 'atcd'
	
	$m->values['atcd'] = '';
	$m->values["ATCD Cancer de l'ovaire (oui/non)"] = utf8_encode($m->values["ATCD Cancer de l'ovaire (oui/non)"]);
	if(!empty($m->values["ATCD Cancer de l'ovaire (oui/non)"])) {
		$m->values['atcd'] = preg_match('/non/i',$m->values["ATCD Cancer de l'ovaire (oui/non)"], $matches)? 'n': 'y';
		$m->values["ATCD Cancer de l'ovaire (oui/non)"] = preg_replace('/^oui$/i','',$m->values["ATCD Cancer de l'ovaire (oui/non)"] );
		$m->values["ATCD Cancer de l'ovaire (oui/non)"] = preg_replace('/^non$/i','',$m->values["ATCD Cancer de l'ovaire (oui/non)"] );
	}
	if(($m->values["atcd"] == 'y') || doesValueExist($m->values["ATCD Cancer de l'ovaire (oui/non)"])) $ov_dx_data_exist = true;
	
	// fields : 'Morphologie Ov %'
	
	foreach($m->values as $field => $value) {
		if(doesValueExist($value)) $ov_dx_data_exist = true;
		if(preg_match('/^(Morphologie Ov )(DROIT|GAUCHE)::/',$field,$matches)) {
			if(preg_match('/^(x )(.+)$/',$value,$matches)) {
				$m->values[$field] = 'x';		
				$m->values['notes'] .= str_replace('::',' - ', utf8_encode($field)).' : '.utf8_encode($matches[2]).' // ';
				Config::$summary_msg['@@MESSAGE@@']['Morphologie Ov #1'][] = "The field '$field' contains additional comments [".$matches[2]."] that will be added to diagnosis notes! [Line: ".$m->line.']';
			}
		}
	}
	
	// 4- CONTROL DX DATA & SET DX ID, etc
	
	$uncertain_dx = false;
	$primary_tumors = array();
	$all_dx_left_ov = array();
	$all_dx_right_ov = array();
	
	// GET VALUES
	
	foreach($m->values as $field => $value) {
		
		// a- Site Cancer Primaire
		
		if(preg_match('/^(Site cancer primaire::)(.+)$/',$field,$matches)) {	
			$site_tmp = $matches[2];
			if(doesValueExist($value)) {
				$note = preg_match('/^(x {0,1})(.*)$/',$value,$matches)? $matches[2] : $value;
				if(!empty($note)) $note = utf8_encode(str_replace('::',' - ', $field).' : '.$note);
				switch(utf8_encode($site_tmp)) {
					case 'Ovaire':
						$primary_tumors['ovary'] = $note;
						break;	
					case 'Trompe':
						$primary_tumors['fallopian tube'] = $note;
						break;	
					case 'Épiploon':
						$primary_tumors['omentum'] = $note;
						break;	
					case 'Endomètre':
						$primary_tumors['endometrial'] = $note;
						break;	
					case 'Utérus':
						$primary_tumors['uterus'] = $note;
						break;		
					case 'Péritoine':
						$primary_tumors['peritoneum'] = $note;
						break;		
					case 'Colon':
						$primary_tumors['colon'] = $note;
						break;		
					case 'Sein':
						$primary_tumors['breast'] = $note;
						break;		
					case 'Estomac':
						$primary_tumors['stomach'] = $note;
						break;		
					case 'Lymphome Non-Hodgkin':
						$primary_tumors['non hodgkin lymphoma'] = $note;
						break;		
					case 'Lymphome Hodgkin':
						$primary_tumors['hodgkin lymphoma'] = $note;
						break;		
					case 'Rectum':
						$primary_tumors['rectum'] = $note;
						break;		
					case 'Appendice':
						$primary_tumors['appendix'] = $note;
						break;		
					case 'Pancréas':
						$primary_tumors['pancreas'] = $note;
						break;		
					case 'Mélanome':
						$primary_tumors['melanoma'] = $note;
						break;		
					case 'Uretère':
						$primary_tumors['ureter'] = $note;
						break;		
					case 'Rein':
						$primary_tumors['kidney'] = $note;
						break;		
					case 'Incertain':
						$uncertain_dx = true;
						if(!empty($note)) die('ERR 89038300983.2 : ['.$note.']');
						break;	
					default :
						die('ERR 89038300983');
				
				}
			}
		}
		
//		if($uncertain_dx) Config::$summary_msg['@@MESSAGE@@']["Uncertain diagnostics"][] = "All diagnostic of the line will be defined as uncertain! [Line: ".$m->line.']';
		$m->values['uncertain_dx'] = ($uncertain_dx? 'y':'');
		
		// b- Diagnostic Ovaire
		
		if(preg_match('/^Diagnostique OVAIRE (GAUCHE|DROIT)::(.+)$/',$field,$matches)) {
			$tumour_laterality_tmp = $matches[1];
			$tumour_type_tmp = str_replace(array('Normal', 'Bénin', 'Borderline', 'Cancer', 'Métastatique'), array('normal', 'benign', 'borderline', 'cancer', 'metastatic'), utf8_encode($matches[2]));
			if(!in_array($tumour_type_tmp,  array('normal', 'benign', 'borderline', 'cancer', 'metastatic'))) die('ERR 887478444');
			
			if(doesValueExist($value)) {
				$note = preg_match('/^(x {0,1})(.*)$/',$value,$matches)? $matches[2] : $value;
				if(!empty($note)) $note = utf8_encode(str_replace('::',' - ', $field).' : '.$note);
				if($tumour_laterality_tmp == 'GAUCHE') {
					$all_dx_left_ov[$tumour_type_tmp] = $note;
				} else {
					$all_dx_right_ov[$tumour_type_tmp] = $note;
				}
			}
		}
	}
	
	// ANALYZE VALUES
	
	// a- Ovary Diagnostic Clean Up
	
	$left_ovary_dx_nature_data = getFinalOvaryNatureData($all_dx_left_ov, 'GAUCHE', $m);
	$right_ovary_dx_nature_data = getFinalOvaryNatureData($all_dx_right_ov, 'DROIT', $m);
	
	$left_ovary_dx_nature = $left_ovary_dx_nature_data['nature'];
	$m->values['left_ovary_dx_nature'] = $left_ovary_dx_nature;
	$right_ovary_dx_nature = $right_ovary_dx_nature_data['nature'];
	$m->values['right_ovary_dx_nature'] = $right_ovary_dx_nature;
	
	$ovary_dx_nature_notes = $left_ovary_dx_nature_data['notes'].((!empty($left_ovary_dx_nature_data['notes']) && !empty($right_ovary_dx_nature_data['notes']))? ' // ' : ''). $right_ovary_dx_nature_data['notes'];
	if(!empty($ovary_dx_nature_notes)) $m->values['notes'] .= $ovary_dx_nature_notes.' // ';
				
	$ovary_dx_from_natures = 'primary';
	if(in_array($left_ovary_dx_nature, array('','normal')) && in_array($right_ovary_dx_nature, array('','normal'))) {	
		$ovary_dx_from_natures = 'normal';
	} else if($left_ovary_dx_nature == 'metastatic' || $right_ovary_dx_nature == 'metastatic') {
		if($left_ovary_dx_nature == 'cancer' || $right_ovary_dx_nature == 'cancer') {
			Config::$summary_msg['@@WARNING@@']["Ovary tumor types conflict #1"][] = "The ovary tumor type is defined both as 'metastatic' and 'primary' (using 'Diagnostiques OVAIRE' columns)! Migration process created primary ovary! [Line: ".$m->line.']';
		} else {
			$ovary_dx_from_natures = 'secondary';
			if($left_ovary_dx_nature != 'metastatic' && $right_ovary_dx_nature != 'metastatic') {
				Config::$summary_msg['@@WARNING@@']["Ovary Diagnostic Definition From Natures #2"][] = "The ovary natures (left and right) define ovary tumor as both $left_ovary_dx_nature and $right_ovary_dx_nature: Will defined tumor as secondary! [Line: ".$m->line.']';
			}
		}
	}
	
	switch($ovary_dx_from_natures) {
		case 'primary':		
			$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['ovary']['diagnosis_control_id'];
			if(!array_key_exists('ovary', $primary_tumors)) {
				Config::$summary_msg['@@MESSAGE@@']["Primary ovary not defined In 'Site cancer primaire::Ovaire' column"][] = "... but defined into 'Diagnostiques OVAIRE' columns! [Line: ".$m->line.']';
			} else {
				unset($primary_tumors['ovary']);
			}
			createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
			break;
		
		case 'secondary':
			if(array_key_exists('ovary', $primary_tumors)) {
				$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['ovary']['diagnosis_control_id'];
				Config::$summary_msg['@@ERROR@@']["Ovary tumor types conflict #2"][] = "The ovary tumor type is defined both as 'metastatic' (using 'Diagnostiques OVAIRE' columns) and 'primary' (using 'Sites cancer primaire' columns)! Migration process created primary ovary! [Line: ".$m->line.']';
				unset($primary_tumors['ovary']);
				createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
			
			} else {
				$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['secondary']['ovary']['diagnosis_control_id'];
				
				$parent_id = null;
				$parent_ids = createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
				if(sizeof($parent_ids) == 1) {
					$m->values['parent_id'] = $parent_ids[0];
					$m->values['primary_id'] = $parent_ids[0];
				} else {
					if(sizeof($parent_ids)) {
						Config::$summary_msg['@@WARNING@@']["Many primaries & ovary secondary"][] = "The ovarian tumor has been defined as secondary (using 'Diagnostiques OVAIRE' columns) but more than one primary is defined (using 'Sites cancer primaire' columns)! Unable to define the primary of the ovarian secondary so created unknown primary diagnosis! [Line: ".$m->line.']';
						$parent_ids = createOtherPrimaries(array('primary diagnosis unknown' => ''), $uncertain_dx, $m);
						if(sizeof($parent_ids) != 1) die('ERRR 993899393');
						$m->values['parent_id'] = $parent_ids[0];
						$m->values['primary_id'] = $parent_ids[0];
												
					} else {
						Config::$summary_msg['@@MESSAGE@@']["Unknonw Primary & ovary secondary"][] = "The ovarian tumor has been defined as secondary (using 'Diagnostiques OVAIRE' columns) but no primary is defined (using 'Sites cancer primaire' columns)! Created unknown primary of the ovarian secondary! [Line: ".$m->line.']';
						$parent_ids = createOtherPrimaries(array('primary diagnosis unknown' => ''), $uncertain_dx, $m);
						if(sizeof($parent_ids) != 1) die('ERRR 993899393');
						$m->values['parent_id'] = $parent_ids[0];
						$m->values['primary_id'] = $parent_ids[0];
					}
				}
			}
			break;
		
		case '':	
		case 'normal':
			if($ov_dx_data_exist) Config::$summary_msg['@@WARNING@@']['Diagnostic Data exist for normal ovary'][] = "Ovary defined as normal but diagnosis data exists and won't be recorded! Check stade, TNM, ATCD and morpho values. [Line: ".$m->line.']';
			if(empty($primary_tumors)) {
				if($uncertain_dx) Config::$summary_msg['@@WARNING@@']['Uncertain fields & No tumor'][] = "The field 'Site cancer primaire::Incertain' is checked but no diagnostic will be created in the system! This information won't be recored! [Line: ".$m->line.']';
			} else {
				createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
			}
			return false;

		default:
			die('ERR 99849944 : ['.$ovary_dx_from_natures.']');
	}

////TODO definir le diag lié a la collection
	
	// 6- NOTES CLEAN UP
	
	$m->values['notes'] = str_replace("'", "''", preg_replace('/(\/\/ )$/', '',$m->values['notes']));
	
	return true;
}

function postOvaryDiagnosesWrite(Model $m){

}

function postDiagnosisWrite(Model $m){

}

//======================================================================================================================
// ADDITIONAL FUNCTIONS
//======================================================================================================================

function doesValueExist($value) {
	return strlen(str_replace(' ','',$value))? true : false;
}

function getFinalOvaryNatureData($all_dx_ov, $side, Model $m) {
	
	if(sizeof($all_dx_ov) > 1) {
		$type = '';
		if(array_key_exists('metastatic', $all_dx_ov)) {
			$type = 'metastatic';
		} else if(array_key_exists('cancer', $all_dx_ov)) {
			$type = 'cancer';			
		} else if(array_key_exists('borderline', $all_dx_ov)) {
			$type = 'borderline';			
		} else if(array_key_exists('benign', $all_dx_ov)) {
			$type = 'benign';			
		} else if(!array_key_exists('normal', $all_dx_ov)) {
			die('ERR 89038300983.8893');
		}
		
		$notes_start = "Diagnostique OVAIRE $side : Defined as '$type' ";
		$notes_end = empty($all_dx_ov[$type])? '' : $all_dx_ov[$type].' ';
		unset($all_dx_ov[$type]);
		foreach($all_dx_ov as $sec_type => $sec_notes) {
			$notes_start .= "& '$sec_type' ";
			$notes_end .= empty($sec_notes)? '' :(empty($notes_end)? '' : '// ').$sec_notes.' ';
		}

		$all_dx_ov = array($type => $notes_start.(empty($notes_end)? '' : '// '. $notes_end));
		
		Config::$summary_msg['@@WARNING@@']["Many diagnostic types for 'OVAIRE $side'"][] = $notes_start.". The 'OVAIRE $side' will be defined as '$type'! [Line: ".$m->line.']';
	}
	
	$ovary_dx_nature = empty($all_dx_ov)? '': key($all_dx_ov);
	$ovary_dx_nature_note = empty($ovary_dx_nature)? '': $all_dx_ov[$ovary_dx_nature];
	
	return array('nature' => $ovary_dx_nature, 'notes' => $ovary_dx_nature_note);
}

function createOtherPrimaries($primary_tumors, $uncertain_dx, Model $m) {
	$diagnosis_master_ids = array();
	
	foreach($primary_tumors as $tumor_site => $notes) {
		$notes = str_replace("'", "''", $notes);
		
		if(!isset(Config::$diagnosis_controls['primary'][$tumor_site])) die('ERR 937993 3 '.$tumor_site);
		if($tumor_site == 'breast') Config::$summary_msg['@@MESSAGE@@']["Breast primary created"][] = "A Breast primary has been created during ovary bank data importation (see 'Site cancer primaire::Sein' column)! [Line: ".$m->line.']';
		
		$master_fields = array(
			"diagnosis_control_id" => Config::$diagnosis_controls['primary'][$tumor_site]['diagnosis_control_id'],
			"participant_id" => $m->values['participant_id'],
			"notes" => "'$notes'"
		);
		if($tumor_site == 'primary diagnosis unknown') $detail_fields["icd10_code"] = "'D489'";
		$diagnosis_master_id = customInsertChusRecord($master_fields, 'diagnosis_masters');
		$detail_fields = array("diagnosis_master_id" => $diagnosis_master_id);	
		if($tumor_site != 'primary diagnosis unknown' ) $detail_fields["uncertain_dx"] = ($uncertain_dx? "'y'" : "''");
		customInsertChusRecord(array('diagnosis_master_id' => $diagnosis_master_id), Config::$diagnosis_controls['primary'][$tumor_site]['detail_tablename'], true);
		
		$diagnosis_master_ids[] = $diagnosis_master_id;
	}
	
	return $diagnosis_master_ids;
}
