<?php
$pkey = "#FRSQ";

$child = array();

$master_fields = array(
	"diagnosis_control_id" => "#diagnosis_control_id",
	"participant_id" => "#participant_id",

//	"clinical_stage_summary" => "STADE (1-4)",
//
//	"path_tstage" => "T",
//	"path_nstage" => "N",
//	"path_mstage" => "M",
//
//
//	"chus_uncertain_dx" => "#chus_uncertain_dx",

	"notes" => "#notes"
);
$detail_fields = array(

//	"atcd" => "#atcd",
//	"atcd_description" => "ATCD Cancer de l'ovaire (oui/non)",
//
//	"left_breast_dx_nature" => "#left_breast_dx_nature",
//	"left_breast_tumour_grade" => array("GRADE OV G" => array(
//		""=>"",
//		"1"=>"1",
//		"2"=>"2",
//		"3"=>"3",
//		"1-2"=>"2",
//		"2-3"=>"3",
//		"1, 3"=>"3",
//		"LMP"=>"LMP",
//		"ND"=>"ND")),
//	"left_breast_serous" => array(utf8_decode("Morphologie Ov GAUCHE::Séreux") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_papillary" => array("Morphologie Ov GAUCHE::Papillaire" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_mucinous" => array("Morphologie Ov GAUCHE::Mucineux" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_endometrioid_endometriotic_endometriosis" => array(utf8_decode("Morphologie Ov GAUCHE::Endométrioide") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_squamous" => array("Morphologie Ov GAUCHE::Malpighien" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_Krukenberg" => array("Morphologie Ov GAUCHE::Krukenberg" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_mullerian" => array("Morphologie Ov GAUCHE::Mullerien" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_granulosa" => array("Morphologie Ov GAUCHE::Granulosa" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_squamous_dermoid" => array(utf8_decode("Morphologie Ov GAUCHE::Épidermoide") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_mature_teratoma" => array(utf8_decode("Morphologie Ov GAUCHE::Tératome Mature") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_immature_teratoma" => array(utf8_decode("Morphologie Ov GAUCHE::Tératome Immature") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_brenner" => array("Morphologie Ov GAUCHE::Brenner" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_neuroendocrine" => array("Morphologie Ov GAUCHE::Neuroendocrine" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_sarcoma" => array("Morphologie Ov GAUCHE::Sarcome" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_clear_cell" => array("Morphologie Ov GAUCHE::Clear Cell" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_small_cell" => array("Morphologie Ov GAUCHE::Small Cell" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_sex_cord" => array("Morphologie Ov GAUCHE::Sex cord" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_cells_in_cat_rings" => array("Morphologie Ov GAUCHE::Cellules en bague de chaton" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_struma_ovarii" => array("Morphologie Ov GAUCHE::Struma Ovarii" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_fibroma" => array("Morphologie Ov GAUCHE::Firbome" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_atrophic" => array("Morphologie Ov GAUCHE::Atrophique" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_fallopian_tube_lesion" => array(utf8_decode("Morphologie Ov GAUCHE::Lésion trompe") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_fibrothecoma" => array(utf8_decode("Morphologie Ov GAUCHE::Fibrothécale") => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_polycystic" => array("Morphologie Ov GAUCHE::Polykystique" => array(""=>""," "=>"","x"=>"y")),
//	"left_breast_inclusion_cyst" => array("Morphologie Ov GAUCHE::Kyste d'inclusion" => array(""=>""," "=>"","x"=>"y")),
//	
//	"right_breast_dx_nature" => "#right_breast_dx_nature",
//	"right_breast_tumour_grade" => array("GRADE OV D" => array(
//		""=>"",
//		"1"=>"1",
//		"2"=>"2",
//		"3"=>"3",
//		"1-2"=>"2",
//		"2-3"=>"3",
//		"1, 3"=>"3",
//		"LMP"=>"LMP",
//		"ND"=>"ND")),
//	"right_breast_serous" => array(utf8_decode("Morphologie Ov DROIT::Séreux") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_papillary" => array("Morphologie Ov DROIT::Papillaire" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_mucinous" => array("Morphologie Ov DROIT::Mucineux" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_endometrioid_endometriotic_endometriosis" => array(utf8_decode("Morphologie Ov DROIT::Endométrioide") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_squamous" => array("Morphologie Ov DROIT::Malpighien" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_Krukenberg" => array("Morphologie Ov DROIT::Krukenberg" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_mullerian" => array("Morphologie Ov DROIT::Mullerien" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_granulosa" => array("Morphologie Ov DROIT::Granulosa" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_squamous_dermoid" => array(utf8_decode("Morphologie Ov DROIT::Épidermoide/Dermoide") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_mature_teratoma" => array(utf8_decode("Morphologie Ov DROIT::Tératome Mature") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_immature_teratoma" => array(utf8_decode("Morphologie Ov DROIT::Tératome Immature") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_brenner" => array("Morphologie Ov DROIT::Brenner" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_neuroendocrine" => array("Morphologie Ov DROIT::Neuroendocrine" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_sarcoma" => array("Morphologie Ov DROIT::Sarcome" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_clear_cell" => array("Morphologie Ov DROIT::Clear Cell" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_small_cell" => array("Morphologie Ov DROIT::Small Cell" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_sex_cord" => array("Morphologie Ov DROIT::Sex cord" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_cells_in_cat_rings" => array("Morphologie Ov DROIT::Cellules en bagues de chaton" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_struma_ovarii" => array("Morphologie Ov DROIT::Struma Ovarii" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_fibroma" => array("Morphologie Ov DROIT::Fibrome" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_atrophic" => array("Morphologie Ov DROIT::Atrophique" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_fallopian_tube_lesion" => array(utf8_decode("Morphologie Ov DROIT::Lésion trompe") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_fibrothecoma" => array(utf8_decode("Morphologie Ov DROIT::Fibrothécale") => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_polycystic" => array("Morphologie Ov DROIT::Polykystique" => array(""=>""," "=>"","x"=>"y")),
//	"right_breast_inclusion_cyst" => array("Morphologie Ov DROIT::Kyste d'inclusion" => array(""=>""," "=>"","x"=>"y")),
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
	
	$m->values['notes'] = '';
	
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
		Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']['Participant & Many Rows'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has data recorded in many rows of the breast bank file! Please check import deeply! [Line: ".$m->line.']';
	}
	Config::$data_for_import_from_participant_id[$participant_id]['data_imported_from_br_file'] = true;
	
	// 2- CREATE CONSENT
	
	$consent_date = customGetFormatedDate($m->values[utf8_decode('Date (année-mois-jour)')]);
	if(empty($consent_date)) {
		die('ERR empty consent date line '.$m->line);
	}
	if(isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_date'])) {
		if($consent_date != Config::$data_for_import_from_participant_id[$participant_id]['consent_date']) {
			Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Participant & Many Consent Dates'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has different consent dates defined in many rows of the OV file! Only one consent will be created! [Line: ".$m->line.']';
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
	
	$date_of_birth = customGetFormatedDate($m->values[utf8_decode('Date Naissance')]);
	$date_of_birth_from_step2 = Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth_from_step2'];
	
	TODO comparer les dates entre elles avec la step2
	
	if($date_of_birth) {
		if(!empty($date_of_birth_from_step2) && ($date_of_birth_from_step2 != $date_of_birth)) {
			pr(Config::$data_for_import_from_participant_id[$participant_id]);
			die('ERR DATE 2');
		
		} else if(isset(Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth'])) {
			if($date_of_birth != Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth']) {
				Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@']['Participant & Birth Date #1'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ BR'])."] has different birth dates defined in many rows of the BR file! [Line: ".$m->line.']';
			}
			
		} else {
			$query = "UPDATE participants SET date_of_birth = '$date_of_birth', date_of_birth_accuracy = 'c'  WHERE id = ".$m->values['participant_id'].";";
			mysqli_query($connection, $query) or die("birth date update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$query = str_replace('participants','participants_revs', $query);
			mysqli_query($connection, $query) or die("birth date update  [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		Config::$data_for_import_from_participant_id[$participant_id]['date_of_birth'] = $date_of_birth;
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//TODO continue dev
	return false;
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 4- SET DX DATA & CONTROL DATA
	
	$ov_dx_data_exist = array();
	
	// field: 'STADE (1-4)'
	
	if(!empty($m->values['STADE (1-4)'])) {
		if(strtolower($m->values['STADE (1-4)']) == 'nd') {
			$m->values['STADE (1-4)'] = '';
			$m->values['notes'] .= "STADE (1-4) file value was 'ND'. // ";		
		
		} else if(preg_match('/^([1-3][a-c]{0,1}|4) {0,1}(.*)$/', strtolower($m->values['STADE (1-4)']), $matches)) {
			$m->values['STADE (1-4)'] = str_replace(array('1','2','3','4'), array('I', 'II', 'III','IV'), $matches[1]);
			if(!empty($matches[2])) {
				if(in_array($matches[2], array('a','b','c'))) {
					Config::$summary_msg['DIAGNOSTIC']['@@WARNNING@@']['STADE (1-4)'][] = "The value '".$matches[0]."' is not supported and will be recorded as [".$matches[1]."]! [Line: ".$m->line.']';
				}
				$m->values['notes'] .= "STADE (1-4) file value was '".$matches[0]."'. // ";		
			}
			$ov_dx_data_exist['stade'] = 'stade';
			
		} else if($m->values['STADE (1-4)'] == '(4)') {
			$m->values['STADE (1-4)'] = 'IV';
		} else {
			die('ERR 998839938383');
		}
	}
	
	// field: T N M
		
	if(strlen($m->values['T']) > 5) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['TNM values sizes #1'][] = "The 'T' value  [".$m->values['T']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['N']) > 5) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['TNM values sizes #1'][] = "The 'N' value  [".$m->values['N']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['M']) > 5) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['TNM values sizes #1'][] = "The 'M' value  [".$m->values['M']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(doesValueExist($m->values['T']) || doesValueExist($m->values['N']) || doesValueExist($m->values['M'])) $ov_dx_data_exist['TNM'] = 'TNM';
	
	// field: 'atcd'
	
	$m->values['atcd'] = '';
	$m->values["ATCD Cancer de l'ovaire (oui/non)"] = utf8_encode($m->values["ATCD Cancer de l'ovaire (oui/non)"]);
	if(!empty($m->values["ATCD Cancer de l'ovaire (oui/non)"])) {
		$m->values['atcd'] = preg_match('/non/i',$m->values["ATCD Cancer de l'ovaire (oui/non)"], $matches)? 'n': 'y';
		$m->values["ATCD Cancer de l'ovaire (oui/non)"] = preg_replace('/^oui$/i','',$m->values["ATCD Cancer de l'ovaire (oui/non)"] );
		$m->values["ATCD Cancer de l'ovaire (oui/non)"] = preg_replace('/^non$/i','',$m->values["ATCD Cancer de l'ovaire (oui/non)"] );
	}
	if(($m->values["atcd"] == 'y') || doesValueExist($m->values["ATCD Cancer de l'ovaire (oui/non)"])) $ov_dx_data_exist['ATCD'] = 'ATCD';
	
	// fields : 'Morphologie Ov %'
	
	foreach($m->values as $field => $value) {
		if(preg_match('/^(Morphologie Ov )(DROIT|GAUCHE)::/',$field,$matches)) {
			if(doesValueExist($value)) $ov_dx_data_exist['Morpho'] = 'Morpho';
			if(preg_match('/^(x )(.+)$/',$value,$matches)) {
				$m->values[$field] = 'x';		
				$m->values['notes'] .= str_replace('::',' - ', utf8_encode($field)).' : '.utf8_encode($matches[2]).' // ';
				Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']['Morphologie Ov #1'][] = "The field '$field' contains additional comments [".$matches[2]."] that will be added to diagnosis notes! [Line: ".$m->line.']';
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
						$primary_tumors['breast'] = $note;
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
		
//		if($uncertain_dx) Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']["Uncertain diagnostics"][] = "All diagnostic of the line will be defined as uncertain! [Line: ".$m->line.']';
		$m->values['chus_uncertain_dx'] = ($uncertain_dx? 'y':'');
		
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
	
	// a- Breast Diagnostic Clean Up
	
	$left_breast_dx_nature_data = getFinalBreastNatureData($all_dx_left_ov, 'GAUCHE', $m);
	$right_breast_dx_nature_data = getFinalBreastNatureData($all_dx_right_ov, 'DROIT', $m);

	$left_breast_dx_nature = $left_breast_dx_nature_data['nature'];
	$right_breast_dx_nature = $right_breast_dx_nature_data['nature'];

	$m->values['left_breast_dx_nature'] = $left_breast_dx_nature;
	$m->values['right_breast_dx_nature'] =  $right_breast_dx_nature;
	
	$breast_dx_nature_notes = $left_breast_dx_nature_data['notes'].((!empty($left_breast_dx_nature_data['notes']) && !empty($right_breast_dx_nature_data['notes']))? ' // ' : ''). $right_breast_dx_nature_data['notes'];
	if(!empty($breast_dx_nature_notes)) $m->values['notes'] .= $breast_dx_nature_notes.' // ';
				
	$breast_dx_from_natures = 'primary';
	if(in_array($left_breast_dx_nature, array('','normal')) && in_array($right_breast_dx_nature, array('','normal'))) {	
		$breast_dx_from_natures = 'normal';
	} else if($left_breast_dx_nature == 'metastatic' || $right_breast_dx_nature == 'metastatic') {
		if($left_breast_dx_nature == 'cancer' || $right_breast_dx_nature == 'cancer') {
			Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']["Breast tumor types conflict #1"][] = "The breast tumor type is defined both as 'metastatic' and 'primary' (using 'Diagnostiques OVAIRE' columns)! Migration process created primary breast! [Line: ".$m->line.']';
		} else {
			$breast_dx_from_natures = 'secondary';
			if($left_breast_dx_nature != 'metastatic' && $right_breast_dx_nature != 'metastatic') {
				Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']["Breast Diagnostic Definition From Natures #2"][] = "The breast natures (left and right) define breast tumor as both $left_breast_dx_nature and $right_breast_dx_nature: Will defined tumor as secondary! [Line: ".$m->line.']';
			}
		}
	}
	
	switch($breast_dx_from_natures) {
		case 'primary':		
			$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['breast']['diagnosis_control_id'];
			if(!array_key_exists('breast', $primary_tumors)) {
				Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']["Primary breast not defined In 'Site cancer primaire::Ovaire' column"][] = "... but defined into 'Diagnostiques OVAIRE' columns! [Line: ".$m->line.']';
			} else {
				unset($primary_tumors['breast']);
			}
			createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
			break;
		
		case 'secondary':
			if(array_key_exists('breast', $primary_tumors)) {
				$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['breast']['diagnosis_control_id'];
				Config::$summary_msg['DIAGNOSTIC']['@@ERROR@@']["Breast tumor types conflict #2"][] = "The breast tumor type is defined both as 'metastatic' (using 'Diagnostiques OVAIRE' columns) and 'primary' (using 'Sites cancer primaire' columns)! Migration process created primary breast! [Line: ".$m->line.']';
				unset($primary_tumors['breast']);
				createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
			
			} else {
				$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['secondary']['breast']['diagnosis_control_id'];
				
				$parent_id = null;
				$parent_ids = createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
				if(sizeof($parent_ids) == 1) {
					$m->values['parent_id'] = $parent_ids[0];
				} else {
					if(sizeof($parent_ids)) {
						Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']["Many primaries & breast secondary"][] = "The ovarian tumor has been defined as secondary (using 'Diagnostiques OVAIRE' columns) but more than one primary is defined (using 'Sites cancer primaire' columns)! Unable to define the primary of the ovarian secondary so created unknown primary diagnosis! [Line: ".$m->line.']';
						$parent_ids = createOtherPrimaries(array('primary diagnosis unknown' => ''), $uncertain_dx, $m);
						if(sizeof($parent_ids) != 1) die('ERRR 993899393');
						$m->values['parent_id'] = $parent_ids[0];
												
					} else {
						Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']["Unknonw Primary & breast secondary"][] = "The ovarian tumor has been defined as secondary (using 'Diagnostiques OVAIRE' columns) but no primary is defined (using 'Sites cancer primaire' columns)! Created unknown primary of the ovarian secondary! [Line: ".$m->line.']';
						$parent_ids = createOtherPrimaries(array('primary diagnosis unknown' => ''), $uncertain_dx, $m);
						if(sizeof($parent_ids) != 1) die('ERRR 993899393');
						$m->values['parent_id'] = $parent_ids[0];
					}
				}
			}
			break;
		
		case '':	
		case 'normal':
			if(array_key_exists('breast', $primary_tumors)) {
				$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['breast']['diagnosis_control_id'];
				Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']["Breast tumor undefined by 'Diagnostique OVAIRE' columns"][] = "The breast primary tumor is just defined in 'Site cancer primaire::Ovaire' column. Primary breast will be created (".(empty($ov_dx_data_exist)? 'with no breast dx data [Stade, TNM, Morpho, ATCD]' : 'includin existing breast dx data ['. implode(",", $ov_dx_data_exist).']').")! [Line: ".$m->line.']';
				unset($primary_tumors['breast']);
				createOtherPrimaries($primary_tumors, $uncertain_dx, $m);				

			} else {
				// No Breast tumor to create
				Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']['Patient with no Breast Diagnosis'][] = ".... [Line: ".$m->line.']';						
				if(!empty($ov_dx_data_exist)) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Breast Diagnostic Data & No Breast Dx'][] = "No Breast Diagnosis will be created but diagnosis data exists into the file and won't be recorded! Check ". implode(",", $ov_dx_data_exist)." values. [Line: ".$m->line.']';
				if(empty($primary_tumors)) {
					if($uncertain_dx) Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']['Uncertain fields & No tumor'][] = "The field 'Site cancer primaire::Incertain' is checked but no diagnostic will be created in the system! This information won't be recored! [Line: ".$m->line.']';
				} else {
					createOtherPrimaries($primary_tumors, $uncertain_dx, $m);
				}
				
				participantDataCompletion($m, $participant_id);
				
				return false;				
			}
			break;
			
		default:
			die('ERR 99849944 : ['.$breast_dx_from_natures.']');
	}
	
	// 6- NOTES CLEAN UP
	
	$m->values['notes'] = str_replace("'", "''", preg_replace('/(\/\/ )$/', '',$m->values['notes']));
	
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
	Config::$data_for_import_from_participant_id[$m->values['participant_id']]['ovca_diagnosis_ids'][] = array('diagnosis_master_id' => $m->last_id, 'FRSQ#' => str_replace(' ', '', utf8_encode($m->values['#FRSQ'])));
	
	participantDataCompletion($m, $m->values['participant_id'], $m->last_id, (isset($m->values['parent_id'])? $m->values['parent_id'] : null));
}

//======================================================================================================================
// ADDITIONAL FUNCTIONS
//======================================================================================================================

function doesValueExist($value) {
	return strlen(str_replace(' ','',$value))? true : false;
}

function getFinalBreastNatureData($all_dx_ov, $side, Model $m) {
	
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
		
		Config::$summary_msg['DIAGNOSTIC']['@@WARNING@@']["Many diagnostic types for 'OVAIRE $side'"][] = $notes_start.". The 'OVAIRE $side' will be defined as '$type'! [Line: ".$m->line.']';
	}
	
	$breast_dx_nature = empty($all_dx_ov)? '': key($all_dx_ov);
	$breast_dx_nature_note = empty($breast_dx_nature)? '': $all_dx_ov[$breast_dx_nature];
	
	return array('nature' => $breast_dx_nature, 'notes' => $breast_dx_nature_note);
}

function createOtherPrimaries($primary_tumors, $uncertain_dx, Model $m) {
	$diagnosis_master_ids = array();
	
	foreach($primary_tumors as $tumor_site => $notes) {
		$notes = str_replace("'", "''", $notes);
		
		if(!isset(Config::$diagnosis_controls['primary'][$tumor_site])) die('ERR 937993 3 '.$tumor_site);
		if($tumor_site == 'breast') Config::$summary_msg['DIAGNOSTIC']['@@MESSAGE@@']["Breast primary created"][] = "A Breast primary has been created during breast bank data importation (see 'Site cancer primaire::Sein' column)! [Line: ".$m->line.']';
		
		$master_fields = array(
			"diagnosis_control_id" => Config::$diagnosis_controls['primary'][$tumor_site]['diagnosis_control_id'],
			"participant_id" => $m->values['participant_id'],
			"chus_uncertain_dx" => ($uncertain_dx? "'y'" : "''"),
			"icd10_code" => (($tumor_site == 'primary diagnosis unknown')? "'D489'" : "''"),
			"notes" => "'$notes'"
		);
		$diagnosis_master_id = customInsertChusRecord($master_fields, 'diagnosis_masters');
		customInsertChusRecord(array('diagnosis_master_id' => $diagnosis_master_id), Config::$diagnosis_controls['primary'][$tumor_site]['detail_tablename'], true);
		
		$diagnosis_master_ids[] = $diagnosis_master_id;
	}
	
	return $diagnosis_master_ids;
}

//======================================================================================================================
// COMPLETE PATIENT DATA FROM FILES
//======================================================================================================================

function participantDataCompletion(Model $m, $participant_id, $diagnosis_master_id = null, $parent_diagnosis_master_id = null) {
	addOvcaSecondary($m, $participant_id, $diagnosis_master_id, $parent_diagnosis_master_id);
	
	addSurgery($m, $participant_id, $diagnosis_master_id);
	
	addOtherTreatment('Radio::Pré op', 'radiation','pre', $m, $participant_id, $diagnosis_master_id);
	addOtherTreatment('Radio::Post op', 'radiation','post', $m, $participant_id, $diagnosis_master_id);
	
	addOtherTreatment('Chimio::Pré op', 'chemotherapy','pre', $m, $participant_id, $diagnosis_master_id);
	addOtherTreatment('Chimio::Post op', 'chemotherapy','post', $m, $participant_id, $diagnosis_master_id);	
	
	addEvent(array('CA125 au Dx'), 'lab', 'breast', 'CA125', $m, $participant_id, $diagnosis_master_id);
	addEvent(array('CTScan (+ ou -)'), 'clinical', 'all', 'ctscan', $m, $participant_id, $diagnosis_master_id);
	addEvent(array('Immuno (IHC)::ER','Immuno (IHC)::PR','Immuno (IHC)::P53','Immuno (IHC)::CA125'), 'lab', 'breast', 'immunohistochemistry', $m, $participant_id, $diagnosis_master_id);
}

function addOvcaSecondary(Model $m, $participant_id, $ovca_diagnosis_master_id, $ovca_parent_diagnosis_master_id) {
	$ctrl_type_match = array(
		'peritoneum' => 'Péritoine',
		'omentum' => 'Épiploon',
		'fornix' => 'Cul de Sac',
		'colon' => 'Colon',
		'small intestine' => 'Grêle',
		'ganglion' => 'Ganglions',
		'stomach' => 'Estomac',
		'brain' => 'Cerveau',
		'bone' => 'Osseuse',
		'rectum' => 'Rectum',
		'lung' => 'Poumon',
		'liver' => 'Foie',
		'fallopian tube' => 'Trompe',
		'uterus' => 'Utérus');
		
	$secondaries_to_create = array();
	foreach($m->values as $field => $value) {
		$value = utf8_encode($value);
		if(preg_match('/^Site Métastase de OVCA::(.*)$/', utf8_encode($field), $matches)) {
			$value_tmp = str_replace(' ', '', $value);
			if(!empty($value_tmp)) {
				$control_type = str_replace(array_values($ctrl_type_match), array_keys($ctrl_type_match), $matches[1]);
				$note = '';
				if($value != 'x') {
					if(preg_match('/^x (.*)$/', $value, $matches)) {
						$note = $matches[1];
					} else {
						$note = $value;
					}				
				}
				$secondaries_to_create[$control_type] = $note;
			}
		}
	}
	
	if(empty($secondaries_to_create)) return;
	
	if(empty($ovca_diagnosis_master_id)) {
		Config::$summary_msg['OVCA METASTASES']['@@ERROR@@']["No OVCA primary & OVCA secondary to create"][] = "'OVCA Métastases' have been defined into file but the migration process did not created a primary OVCA: This OVCA secondary won't be created! [Line: ".$m->line.']';
		return;	
	}
	if(!empty($ovca_parent_diagnosis_master_id)) {
		Config::$summary_msg['OVCA METASTASES']['@@ERROR@@']["OVCA defined as secondary & OVCA secondary to create"][] = "'OVCA Métastases' have been defined into file but the migration process already defined the created OVCA as secondary: Unable to add a secondary to a secondary! [Line: ".$m->line.']';
		return;		
	}
	
	foreach($secondaries_to_create as $control_type => $notes) {
		if(!isset(Config::$diagnosis_controls['secondary'][$control_type])) die('ERR 7789993 '.$control_type);
		$master_fields = array(
			"diagnosis_control_id" => Config::$diagnosis_controls['secondary'][$control_type]['diagnosis_control_id'],
			"participant_id" => $m->values['participant_id'],
			"primary_id" => $ovca_diagnosis_master_id,
			"parent_id" => $ovca_diagnosis_master_id,
			"notes" => "'".str_replace("'", "''", $notes)."'"
		);
		$diagnosis_master_id = customInsertChusRecord($master_fields, 'diagnosis_masters');
		customInsertChusRecord(array('diagnosis_master_id' => $diagnosis_master_id), Config::$diagnosis_controls['secondary'][$control_type]['detail_tablename'], true);
	}
}

function addEvent($fields, $event_group, $disease_site, $event_type, Model $m, $participant_id, $diagnosis_master_id = null) {
	$empty_data = true;
 	foreach($fields as $field) {
		if(!array_key_exists(utf8_decode($field), $m->values)) die('ERR 43311111');
		if(strlen($m->values[$field])) $empty_data = false;
	}
	if($empty_data) return;
	
	if(!isset(Config::$event_controls[$event_group][$disease_site][$event_type])) die('ERR 88998379');
	$event_control_id = Config::$event_controls[$event_group][$disease_site][$event_type]['event_control_id'];
	$detail_tablename = Config::$event_controls[$event_group][$disease_site][$event_type]['detail_tablename'];
	
	$all_events_data = array(
		'record_1' => array('date' => null, 'master' => array(), 'detail' => array(), 'note' => ''),
		'record_2' => array('date' => null, 'master' => array(), 'detail' => array(), 'note' => ''));
	
	switch($event_type) {
		
		case 'CA125':
			
			$value_tmp = utf8_encode($m->values[$fields[0]]);
		
			if($value_tmp == 'ND') {
				Config::$summary_msg['CA125']['@@MESSAGE@@']['CA125 value = ND'][] = "CA125 was defined as 'ND'! No event will be created and information won't be recorded! [Line: ".$m->line.']';		
				return;
			
			} else if(preg_match('/^[0-9]+([\.,][0-9]+)?$/',$value_tmp,$matches)) {
				//361,5
				$all_events_data['record_1']['detail']['value'] =  "'".str_replace(',', '.', $value_tmp)."'";
				$all_events_data['record_1']['detail']['at_diagnostic'] =  "'y'";
				unset($all_events_data['record_2']);
						
			} else if(preg_match('/^([0-9]+)([\.,][0-9]+)? \((19|20)([0-9]{2})\-([01][0-9])(\-[0-3][0-9]){0,1}\)(.*)$/',$value_tmp,$matches)) {
				$all_events_data['record_1']['detail']['value'] =  "'".str_replace(',', '.', $matches[1].(empty($matches[2])?'': $matches[2]))."'";
				$all_events_data['record_1']['date'] = $matches[3].$matches[4].'-'.$matches[5].(empty($matches[6])? '' : $matches[6]);
				
				if(empty($matches[7])) {
					$all_events_data['record_1']['detail']['at_diagnostic'] =  "'y'";
					unset($all_events_data['record_2']);
					
				} else {
					if(preg_match('/^, ([0-9]+)([\.,][0-9]+)? \((19|20)([0-9]{2})\-([01][0-9])(\-[0-3][0-9]){0,1}\)$/',$matches[7],$matches)) {
						$all_events_data['record_2']['detail']['value'] =  "'".str_replace(',', '.', $matches[1].(empty($matches[2])?'': $matches[2]))."'";
						$all_events_data['record_2']['date'] = $matches[3].$matches[4].'-'.$matches[5].(empty($matches[6])? '' : $matches[6]);
						
						Config::$summary_msg['CA125']['@@WARNING@@']['Two CA125 values'][] = "CA125 was defined twice [$value_tmp]: unable to define which one is the CA125 at diagnosis! [Line: ".$m->line.']';		

					} else {
						Config::$summary_msg['CA125']['@@ERROR@@']['CA125 value unsupported'][] = "The CA125 value [$value_tmp] is not supported by the migration process! Record won't be created. Please reformate data! [Line: ".$m->line.']';		
						return;
					}
				} 							
			} else if(preg_match('/^([0-9]+)([\.,][0-9]+)? \((19|20)([0-9]{2})\-([01][0-9])(\-[0-3][0-9]){0,1} = ([0-9]+)([\.,][0-9]+)?\)$/',$value_tmp,$matches)) {
				//2858 (2008-08-04 = 36)
				//448 (2004-05 = 26)
				$all_events_data['record_1']['detail']['value'] =  "'".str_replace(',', '.', $matches[1].(empty($matches[2])?'': $matches[2]))."'";
				$all_events_data['record_1']['detail']['at_diagnostic'] =  "'y'";
				
				$all_events_data['record_2']['detail']['value']=  "'".str_replace(',', '.', $matches[7].(isset($matches[8])?$matches[8] : ''))."'";
				$all_events_data['record_2']['date'] = $matches[3].$matches[4].'-'.$matches[5].(empty($matches[6])? '' : $matches[6]);
				
				Config::$summary_msg['CA125']['@@MESSAGE@@']['Defined CA125 at diagnosis #1'][] = "CA125 was defined twice [$value_tmp]: defined the first one as CA125 at diagnosis! [Line: ".$m->line.']';		
				
			} else if(preg_match('/^([0-9]+)([\.,][0-9]+)? \(([0-9]+)([\.,][0-9]+)? le (19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])\)$/',$value_tmp,$matches)){
				//903,5 (141,5 le 2010-04-10)
				
				$all_events_data['record_1']['detail']['value'] =  "'".str_replace(',', '.', $matches[1].(empty($matches[2])?'': $matches[2]))."'";
				$all_events_data['record_1']['detail']['at_diagnostic'] =  "'y'";
				
				$all_events_data['record_2']['detail']['value']=  "'".str_replace(',', '.', $matches[3].(empty($matches[4])?'': $matches[4]))."'";
				$all_events_data['record_2']['date'] = $matches[5].$matches[6].'-'.$matches[7].'-'.$matches[8];
				
				Config::$summary_msg['CA125']['@@MESSAGE@@']['Defined CA125 at diagnosis #2'][] = "CA125 was defined twice [$value_tmp]: defined the first one as CA125 at diagnosis! [Line: ".$m->line.']';		
					
			} else {
				Config::$summary_msg['CA125']['@@ERROR@@']['CA125 value unsupported'][] = "The CA125 value [$value_tmp] is not supported by the migration process! Record won't be created. Please reformate data! [Line: ".$m->line.']';		
				return;
			}		
					
			break;
			
			
		case 'ctscan':
			
			$value_tmp = utf8_encode($m->values[$fields[0]]);
			if($value_tmp == 'ND') {
				Config::$summary_msg['CTSCan']['@@MESSAGE@@']['CTSCan value = ND'][] = "CTSCan was defined as 'ND'! No event will be created and information won't be recorded! [Line: ".$m->line.']';		
				return;
				
			} else if(in_array($value_tmp, array('Positif','positif'))) { 
				$all_events_data['record_1']['detail']['result'] =  "'positive'";
				unset($all_events_data['record_2']);
				
			} else if(in_array($value_tmp, array('Négatif','Negatif'))) { 
				$all_events_data['record_1']['detail']['result'] =  "'negative'";
				unset($all_events_data['record_2']);
				
			} else {
				Config::$summary_msg['CTSCan']['@@ERROR@@']['CTSCan value unsupported'][] = "The CTSCan value [$value_tmp] is not supported by the migration process! Record won't be created. Please reformate data! [Line: ".$m->line.']';		
				return;
			}
			
			break;
			
		case 'immunohistochemistry':
			
			$immuno_note = '';
			foreach($fields as $field) {
		 		if(strlen($m->values[$field])) {
		 			if(!preg_match('/^Immuno \(IHC\)::(.*)$/',$field,$matches)) die('ERR 433de33311111');
		 			$db_field = $matches[1].'_result';
		 		
		 			$db_value = '';
		 			switch($m->values[$field]) {
		 				case 'focalement +':
		 					$all_events_data['record_1']['detail'][$db_field] = "'positive'";
		 					$immuno_note .= (empty($immuno_note)? '': ' // ').$matches[1].': focalement +.';
		 					break;
		 				case '+':
		 					$all_events_data['record_1']['detail'][$db_field] = "'positive'";
		 					break;
		 				case '-':
		 					$all_events_data['record_1']['detail'][$db_field] = "'negative'";
		 					break;
		 				case 'ND':
		 					$immuno_note .= (empty($immuno_note)? '': ' // ').$matches[1].': ND.';
		 					break;
		 				default:
		 					die('ERR 888388383');		 				
		 			}				
		 		}
			}
			
	 		$all_events_data['record_1']['note'] = "$immuno_note";
	 		unset($all_events_data['record_2']);			
			
			if(empty($all_events_data['record_1']['detail'])) { die('Empty immunohistochemistry: probably all ND'); pr($m->values); }
			break;
			
		default:
			die('38929922');
	}
		
	// RECORD EVENT
	
	foreach($all_events_data as $new_record_data) {
		$master_fields = array(
			'participant_id' => $participant_id,
			'event_control_id' =>  $event_control_id,
			'event_summary' => "'".str_replace("'","''",$new_record_data['note'])."'"
		);
		if(!empty($new_record_data['date'])) {
			$date_tmp = getDateAndAccuracy($new_record_data['date']);
			$master_fields['event_date'] = "'".$date_tmp['date']."'";
			$master_fields['event_date_accuracy'] = "'".$date_tmp['accuracy']."'";
		}	
		if($diagnosis_master_id) $master_fields['diagnosis_master_id'] = $diagnosis_master_id;
		$event_master_id = customInsertChusRecord( array_merge($master_fields,$new_record_data['master']), 'event_masters');	
		customInsertChusRecord(array_merge(array('event_master_id' => $event_master_id), $new_record_data['detail']), $detail_tablename, true);
	
	}
}

function addOtherTreatment($field, $treatment_type, $pre_post_surgery, Model $m, $participant_id, $diagnosis_master_id = null) {
	if(!array_key_exists(utf8_decode($field), $m->values)) die('ERR 32 32 32 32');
	$trt_data = $m->values[utf8_decode($field)];
	
	if(!isset(Config::$treatment_controls[$treatment_type]['breast'])) die('ERR 88994849');
	$treatment_control_id = Config::$treatment_controls[$treatment_type]['breast']['treatment_control_id'];
	$detail_tablename = Config::$treatment_controls[$treatment_type]['breast']['detail_tablename'];
	
	$trt_data = utf8_encode($m->values[utf8_decode($field)]);
	if(empty($trt_data) || ($trt_data == 'non')) {
		return;
	} else if($trt_data == 'ND') {
		Config::$summary_msg[strtoupper($treatment_type)]['@@WARNING@@']['treatment value = ND'][] = "Treatment was defined as 'ND'! No treatment will be created and information won't be recorded! [Line: ".$m->line.']';		
		return;
	}	
	
	$start_date = null;
	$finish_date = null;
	$notes = '';
	
	if($trt_data != 'oui') {
		if(!preg_match('/(19|20)([0-9]{2})/',$trt_data,$matches)) {
			$notes = $trt_data;
		
		} else if(preg_match('/^(19|20)([0-9]{2})$/',$trt_data,$matches)) {
			//2001
			$start_date = $matches[1].$matches[2];
			//$notes = $trt_data;
		
		} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([01][0-9])\)$/',$trt_data,$matches)) {
			//oui (2005-01)
			$start_date = $matches[1].$matches[2].'-'.$matches[3];
			if($matches[1].$matches[2] < $matches[1].$matches[3]) Config::$summary_msg[strtoupper($treatment_type)]['@@WARNING@@']['Confirm date defintion'][] = "From '$trt_data', the migration process defined start date = '$start_date' and no finsih_date (and not start_date = '".$matches[1].$matches[2]."' and finsih_date = '".$matches[1].$matches[3]."'! Please confirm! [Line: ".$m->line.']';		
			
		} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([9][0-9])\)$/',$trt_data,$matches)) {
			//oui (1991-96)
			$start_date = $matches[1].$matches[2];
			$finish_date = $matches[1].$matches[3];
			
		} else if(preg_match('/^ {0,1}oui {0,1}\((19|20)([0-9]{2})\-([01][0-9]) au (19|20)([0-9]{2})\-([01][0-9]) {0,1}\) {0,1}(.*)$/',$trt_data,$matches)) {
			//oui (2004-11 au 2005-01) 3x carbotaxol
			//oui (2001-11 au 2005-11)
			//  oui (2001-01 au 2002-11)
			$start_date = $matches[1].$matches[2].'-'.$matches[3];
			$finish_date = $matches[4].$matches[5].'-'.$matches[6];
			if(isset($matches[7])) $notes = $matches[7];
			
		} else if(preg_match('/^oui \((19|20)([0-9]{2})(\-| a | à )(19|20)([0-9]{2})\) {0,1}(.*)$/',$trt_data,$matches)) {
			//oui (2003-2004)
			//oui (2002-2003) 3cycles
			//oui (2003 a 2006) Carbotaxol
			//oui (2003 à 2009)
			$start_date = $matches[1].$matches[2];
			$finish_date = $matches[4].$matches[5];
			if(isset($matches[6])) $notes = $matches[6];
			
		} else if(preg_match('/^ {0,1}oui {0,1}\((19|20)([0-9]{2})\) {0,1}(.*)$/',$trt_data,$matches)) {
			//oui (2003)
			//oui(2007)
			//oui (2002) 3x carbotaxol
			// oui (2001)
			$start_date = $matches[1].$matches[2];	
			if(isset($matches[3])) $notes = $matches[3];	
			
		} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])\)$/',$trt_data,$matches)) {
			//oui (2007-05-09)
			$start_date = $matches[1].$matches[2].'-'.$matches[3].'-'.$matches[4];
			
		} else if(preg_match('/^oui {0,1}\((19|20)([0-9]{2})\-([01][0-9]) au ([01][0-9])\) {0,1}(.*)$/',$trt_data,$matches)) {
			//oui (2009-10 au 12)
			//oui (2002-08 au 09) 2x carbotaxol
			$start_date = $matches[1].$matches[2].'-'.$matches[3];
			$finish_date = $matches[1].$matches[2].'-'.$matches[4];
			if(isset($matches[5])) $notes = $matches[5];	
			
		} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9]) au (19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])\){0,1}$/',$trt_data,$matches)) {
			//oui (2004-03-11 au 2007-10-11)
			$start_date = $matches[1].$matches[2].'-'.$matches[3].'-'.$matches[4];
			$finish_date = $matches[5].$matches[6].'-'.$matches[7].'-'.$matches[8];
			
		} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9]) au (19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])\) {0,1}(.*)$/',$trt_data,$matches)) {
			//oui (2010-05-21 au 2010-06-10) 4cycles carbotaxol
			$start_date = $matches[1].$matches[2].'-'.$matches[3].'-'.$matches[4];
			$finish_date = $matches[5].$matches[6].'-'.$matches[7].'-'.$matches[8];
			if(isset($matches[9])) $notes = $matches[9];	
			
		} else if(preg_match('/^oui \((19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9]) au (19|20)([0-9]{2})\-([01][0-9])\) {0,1}(.*)$/',$trt_data,$matches)) {
			//oui (2003-06-16 au 2003-08) 3 cycles carbotaxol
			$start_date = $matches[1].$matches[2].'-'.$matches[3].'-'.$matches[4];
			$finish_date = $matches[5].$matches[6].'-'.$matches[7];
			if(isset($matches[8])) $notes = $matches[8];	
			
		} else if(preg_match('/^[^0-9]*(19[0-9]{2}|20[0-9]{2})[^0-9]*$/',$trt_data,$matches)) { 
			$start_date = $matches[1];
			$tmp = str_replace(array($start_date, 'oui', ' '), array('','',''), $trt_data);
			if(!empty($tmp)) $notes = $trt_data;
				
		} else {				
			$notes = "Unable to extract date from '$trt_data'!";
			Config::$summary_msg[strtoupper($treatment_type)]['@@WARNING@@']['Unable to extract start date from notes'][] = "Unable to extract date from '$trt_data'! [Line: ".$m->line.']';		
		}
	}
 
		$example_for_control = array(
			'oui 1987',
			'Jul-2007',
			'oui(2009-09 au 12)',
			'oui (2010-05-21 au 2010-06-10) 4cycles carbotaxol',
			'oui (Hodgkin 2008)',
		
			'oui(2003-07 au 2008-06)',
			'oui (2003-08-28 au 2007-04-29',
			'oui (2003-06-16 au 2003-08) 3 cycles carbotaxol',
			'oui (1991-96)',
			'2001',
			'oui (2003-05 au 2003-08 ) 3x carbotaxol',
			'oui (2004-03-11 au 2007-10-11)',
			' oui (2001)',
			'oui (2002-08 au 09) 2x carbotaxol',
			'oui (carbotaxol 4 cycles)',
			'oui (2007-05-09)',
			'oui (2005-01)',
			'oui (2004-11 au 2005-01) 3x carbotaxol',
			'oui (2001-11 au 2005-11)',
			' oui (2001-01 au 2002-11)',
			'oui (2009-10 au 12)',
			'oui (2003-2004)',
			'oui (2002-2003) 3cycles',
			'oui (2003 a 2006) Carbotaxol',
			'oui (2003 à 2009)',
			'oui (2003)',
			'oui(2007)',
			'oui (2002) 3x carbotaxol'
		);
		if(in_array($trt_data, $example_for_control)) Config::$summary_msg['TREATMENT']['@@MESSAGE@@']['Date management to confirm'][$trt_data] = "[$trt_data] ====> from <b>$start_date</b> to <b>$finish_date</b> // note : <b>$notes</b> [Line: ".$m->line.']';		
	
	// Record Trt
	$notes = str_replace('oui','', $notes);
	$notes_tmp = str_replace(' ','', $notes);
	if(!strlen($notes_tmp)) $notes = '';
	
	$master_fields = array(
		'participant_id' => $participant_id,
		'treatment_control_id' =>  $treatment_control_id,
		'notes' => "'".str_replace("'","''",$notes)."'"
	);
	if(!empty($start_date)) {
		$date_tmp = getDateAndAccuracy($start_date);
		$start_date = $date_tmp['date'];
		$master_fields['start_date'] = "'".$date_tmp['date']."'";
		$master_fields['start_date_accuracy'] = "'".$date_tmp['accuracy']."'";
	}
	if(!empty($finish_date)) {		
		$date_tmp = getDateAndAccuracy($finish_date);
		$finish_date = $date_tmp['date'];		
		$master_fields['finish_date'] = "'".$date_tmp['date']."'";
		$master_fields['finish_date_accuracy'] = "'".$date_tmp['accuracy']."'";
	}
	if($diagnosis_master_id) $master_fields['diagnosis_master_id'] = $diagnosis_master_id;
	
	$treatment_master_id = customInsertChusRecord($master_fields, 'treatment_masters');
	
	$detail_fields = array(
		'treatment_master_id' => $treatment_master_id,
		'pre_post_surgery' => "'".$pre_post_surgery."'"
	);			
	customInsertChusRecord($detail_fields, $detail_tablename, true);
	
	if(!empty($start_date) && !empty($finish_date) && (str_replace('-','',$start_date) > str_replace('-','',$finish_date))) {
		Config::$summary_msg[strtoupper($treatment_type)]['@@ERROR@@']['Date error'][$trt_data] = "Dates definition error (from $start_date to $finish_date)! [Line: ".$m->line.']';		
	}

}

function addSurgery(Model $m, $participant_id, $diagnosis_master_id = null) {
	$record_surgery = false;
	
	$start_date = null;
	$start_date_comment = '';
	if(preg_match('/^[0-9]{5}$/',$m->values['Date Chirurgie AAAA-MM-JJ'],$matches)) {
		$start_date = customGetFormatedDate($m->values['Date Chirurgie AAAA-MM-JJ'], false);
		$record_surgery = true;
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])( {0,1})(.*)/',$m->values['Date Chirurgie AAAA-MM-JJ'],$matches)) {
		$start_date = $matches[1].$matches[2].'-'.$matches[3].'-'.$matches[4];
		$start_date_comment = $matches[6];
		Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Date + Comment'][] = "Surgery date [".$m->values['Date Chirurgie AAAA-MM-JJ']."] has been recorded as surgery date = '$start_date' and note = '$start_date_comment'! [Line: ".$m->line.']';	
		$record_surgery = true;
	} else {
		if(!empty($m->values['Date Chirurgie AAAA-MM-JJ'])) {
			$start_date_comment = $m->values['Date Chirurgie AAAA-MM-JJ'];
			if($m->values['Date Chirurgie AAAA-MM-JJ'] != 'ND') Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Uncertain date'][] = "Surgery date [".$m->values['Date Chirurgie AAAA-MM-JJ']."] can not be recorded as date! Will be added to note! [Line: ".$m->line.']';
		}
		$start_date = null;
		$record_surgery = true;
	}
	$notes = empty($start_date_comment)? '': 'Date Chirurgie note: '.$start_date_comment;
	
	$type_HAT_HVAL_HVT = "''";
	$field = 'CHIRURGIE::HAT/HVAL/HVT';
	if(!empty($m->values[$field])) {
		if($m->values[$field] == 'x') {
			$type_HAT_HVAL_HVT = "'y'";
		} else {
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Surgery detail'][] = "Field '$field' value [".$m->values[$field]."] not supported: added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		}
		$record_surgery = true;
	}
	$type_SOG = "''";
	$field = 'CHIRURGIE::SOG';
	if(!empty($m->values[$field])) {
		if($m->values[$field] == 'x') {
			$type_SOG= "'y'";
		} else {
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Surgery detail'][] = "Field '$field' value [".$m->values[$field]."] not supported: added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		}
		$record_surgery = true;
	}
	$type_SOD = "''";
	$field = 'CHIRURGIE::SOD';
	if(!empty($m->values[$field])) {
		if($m->values[$field] == 'x') {
			$type_SOD= "'y'";
		} else {
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Surgery detail'][] = "Field '$field' value [".$m->values[$field]."] not supported: added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		}
		$record_surgery = true;
	}
	$type_SOB = "''";
	$field = 'CHIRURGIE::SOB';
	if(!empty($m->values[$field])) {
		if($m->values[$field] == 'x') {
			$type_SOB= "'y'";
		} else {
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Surgery detail'][] = "Field '$field' value [".$m->values[$field]."] not supported: added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		}
		$record_surgery = true;
	}
	$type_omentectomy = "''";
	$field = utf8_decode('CHIRURGIE::Épiploectomie');
	if(!empty($m->values[$field])) {
		if($m->values[$field] == 'x') {
			$type_omentectomy= "'y'";
		} else {
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Surgery detail'][] = "Field 'CHIRURGIE::Épiploectomie' value [".$m->values[$field]."] not supported: added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		}
		$record_surgery = true;
	}
	$type_ganglions = "''";
	$field = 'CHIRURGIE::Ganglions';
	if(!empty($m->values[$field])) {
		if($m->values[$field] == 'x') {
			$type_ganglions= "'y'";
		} else {
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Surgery detail'][] = "Field '$field' value [".$m->values[$field]."] not supported: added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		}
		$record_surgery = true;
	}
	
	$cytoreduction = '';
	if(!empty($m->values['Cytoreduction'])) {
		$cytoreduction = str_replace(array(' ','Aucune','aucune','microscopique','Microscopique'),array('','none','none','microscpic','microscpic'),$m->values['Cytoreduction']);
		if(!in_array($cytoreduction, Config::$cytoreduction_values)) {
			$cytoreduction = '';
			Config::$summary_msg['SURGERY']['@@MESSAGE@@']['Cytoreduction'][] = "Unsupported Cytoreduction value [".$m->values['Cytoreduction']."] : added to note! [Line: ".$m->line.']';
			$notes .= (empty($notes)? '' : ' // ').'Cytoreduction note: '.$m->values['Cytoreduction'];
		}
		$record_surgery = true;
	}
	
	$patho_report_number = $m->values['#Rapport Pathologie'];
	if(strlen($patho_report_number) > 50) Config::$summary_msg['SURGERY']['@@WARNING@@']['Rapport Pathologie'][] = "Rapport Pathologie value [".$m->values['#Rapport Pathologie']."] is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($patho_report_number)) $record_surgery = true;
	
	$ovg_size_cm = null;
	$field = 'Taille (cm) OV G';
	if(preg_match('/^([0-9]+[\.,]{0,1}[0-9]*)$/',$m->values[$field],$matches)) {
		$ovg_size_cm = "'".str_replace(',','.',$m->values[$field])."'";
		$record_surgery = true;
	} else if(!empty($m->values[$field])) {
		if($m->values[$field] != 'ND') Config::$summary_msg['SURGERY']['@@MESSAGE@@'][$field][] = "Unsupported value [".$m->values[$field]."] : added to note! [Line: ".$m->line.']';
		$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		$record_surgery = true;
	}	
	
	$ovd_size_cm = null;
	$field = 'Taille (cm) OV D';
	if(preg_match('/^([0-9]+[\.,]{0,1}[0-9]*)$/',$m->values[$field],$matches)) {
		$ovd_size_cm = "'".str_replace(',','.',$m->values[$field])."'";
		$record_surgery = true;
	} else if(!empty($m->values[$field])) {
		if($m->values[$field] != 'ND') Config::$summary_msg['SURGERY']['@@MESSAGE@@'][$field][] = "Unsupported value [".$m->values[$field]."] : added to note! [Line: ".$m->line.']';
		$notes .= (empty($notes)? '' : ' // ').$field.' note: '.$m->values[$field];
		$record_surgery = true;
	}		
	
	// RECORD SURGERY
	
	if($record_surgery) {
		$master_fields = array(
			'participant_id' => $participant_id,
			'treatment_control_id' =>  Config::$treatment_controls['surgery']['breast']['treatment_control_id'],
			'notes' => "'".utf8_encode(str_replace("'","''",$notes))."'"
		);
		if(!empty($start_date)) {
			$master_fields['start_date'] = "'".$start_date."'";
			$master_fields['start_date_accuracy'] = "'c'";
		}
		if($diagnosis_master_id) $master_fields['diagnosis_master_id'] = $diagnosis_master_id;
		
		$treatment_master_id = customInsertChusRecord($master_fields, 'treatment_masters');
		
		$detail_fields = array(
			'treatment_master_id' => $treatment_master_id,
		
			'cytoreduction' => "'".$cytoreduction."'",
			'patho_report_number' => "'".utf8_encode($patho_report_number)."'",
		
			'type_HAT_HVAL_HVT' => $type_HAT_HVAL_HVT,
			'type_SOG' => $type_SOG,	
			'type_SOD' => $type_SOD,
			'type_SOB' => $type_SOB,
			'type_omentectomy' => $type_omentectomy,
			'type_ganglions' => $type_ganglions
		);	
		if(!empty($ovg_size_cm)) $detail_fields['ovg_size_cm'] = $ovg_size_cm;
		if(!empty($ovd_size_cm)) $detail_fields['ovd_size_cm'] = $ovd_size_cm;
		
		customInsertChusRecord($detail_fields, Config::$treatment_controls['surgery']['breast']['detail_tablename'], true);
	}
}	
