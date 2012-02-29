<?php
$pkey = "#FRSQ";

$child = array();

$master_fields = array(
	"diagnosis_control_id" => "#diagnosis_control_id",
	"participant_id" => "#participant_id",
//	"primary_id" => "#primary_id",
//	"parent_id" => "#parent_id",
	"age_at_dx" => "Age au Dx",

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
	"left_ovary_serous" => array("Morphologie Ov GAUCHE::Séreux" => array(""=>"","x"=>"y")),
	"left_ovary_papillary" => array("Morphologie Ov GAUCHE::Papillaire" => array(""=>"","x"=>"y")),
	"left_ovary_mucinous" => array("Morphologie Ov GAUCHE::Mucineux" => array(""=>"","x"=>"y")),
	"left_ovary_endometrioid_endometriotic_endometriosis" => array("Morphologie Ov GAUCHE::Endométrioide/endométriotique/endométriosique" => array(""=>"","x"=>"y")),
	"left_ovary_squamous" => array("Morphologie Ov GAUCHE::Malpighien" => array(""=>"","x"=>"y")),
	"left_ovary_Krukenberg" => array("Morphologie Ov GAUCHE::Krukenberg" => array(""=>"","x"=>"y")),
	"left_ovary_mullerian" => array("Morphologie Ov GAUCHE::Mullerien" => array(""=>"","x"=>"y")),
	"left_ovary_granulosa" => array("Morphologie Ov GAUCHE::Granulosa" => array(""=>"","x"=>"y")),
	"left_ovary_squamous_dermoid" => array("Morphologie Ov GAUCHE::Épidermoide" => array(""=>"","x"=>"y")),
	"left_ovary_mature_teratoma" => array("Morphologie Ov GAUCHE::Tératome Mature" => array(""=>"","x"=>"y")),
	"left_ovary_immature_teratoma" => array("Morphologie Ov GAUCHE::Tératome Immature" => array(""=>"","x"=>"y")),
	"left_ovary_brenner" => array("Morphologie Ov GAUCHE::Brenner" => array(""=>"","x"=>"y")),
	"left_ovary_neuroendocrine" => array("Morphologie Ov GAUCHE::Neuroendocrine" => array(""=>"","x"=>"y")),
	"left_ovary_sarcoma" => array("Morphologie Ov GAUCHE::Sarcome" => array(""=>"","x"=>"y")),
	"left_ovary_clear_cell" => array("Morphologie Ov GAUCHE::Clear Cell" => array(""=>"","x"=>"y")),
	"left_ovary_small_cell" => array("Morphologie Ov GAUCHE::Small Cell" => array(""=>"","x"=>"y")),
	"left_ovary_sex_cord" => array("Morphologie Ov GAUCHE::Sex cord" => array(""=>"","x"=>"y")),
	"left_ovary_cells_in_cat_rings" => array("Morphologie Ov GAUCHE::Cellules en bague de chaton" => array(""=>"","x"=>"y")),
	"left_ovary_struma_ovarii" => array("Morphologie Ov GAUCHE::Struma Ovarii" => array(""=>"","x"=>"y")),
	"left_ovary_fibroma" => array("Morphologie Ov GAUCHE::Firbome" => array(""=>"","x"=>"y")),
	"left_ovary_atrophic" => array("Morphologie Ov GAUCHE::Atrophique" => array(""=>"","x"=>"y")),
	"left_ovary_fallopian_tube_lesion" => array("Morphologie Ov GAUCHE::Lésion trompe" => array(""=>"","x"=>"y")),
	"left_ovary_fibrothecoma" => array("Morphologie Ov GAUCHE::Fibrothécale" => array(""=>"","x"=>"y")),
	"left_ovary_polycystic" => array("Morphologie Ov GAUCHE::Polykystique" => array(""=>"","x"=>"y")),
	"left_ovary_inclusion_cyst" => array("Morphologie Ov GAUCHE::Kyste d'inclusion" => array(""=>"","x"=>"y")),
	
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
	"right_ovary_serous" => array("Morphologie Ov DROIT::Séreux" => array(""=>"","x"=>"y")),
	"right_ovary_papillary" => array("Morphologie Ov DROIT::Papillaire" => array(""=>"","x"=>"y")),
	"right_ovary_mucinous" => array("Morphologie Ov DROIT::Mucineux" => array(""=>"","x"=>"y")),
	"right_ovary_endometrioid_endometriotic_endometriosis" => array("Morphologie Ov DROIT::Endométrioide/endométriotique/endométriosique" => array(""=>"","x"=>"y")),
	"right_ovary_squamous" => array("Morphologie Ov DROIT::Malpighien" => array(""=>"","x"=>"y")),
	"right_ovary_Krukenberg" => array("Morphologie Ov DROIT::Krukenberg" => array(""=>"","x"=>"y")),
	"right_ovary_mullerian" => array("Morphologie Ov DROIT::Mullerien" => array(""=>"","x"=>"y")),
	"right_ovary_granulosa" => array("Morphologie Ov DROIT::Granulosa" => array(""=>"","x"=>"y")),
	"right_ovary_squamous_dermoid" => array("Morphologie Ov DROIT::Épidermoide/Dermoide" => array(""=>"","x"=>"y")),
	"right_ovary_mature_teratoma" => array("Morphologie Ov DROIT::Tératome Mature" => array(""=>"","x"=>"y")),
	"right_ovary_immature_teratoma" => array("Morphologie Ov DROIT::Tératome Immature" => array(""=>"","x"=>"y")),
	"right_ovary_brenner" => array("Morphologie Ov DROIT::Brenner" => array(""=>"","x"=>"y")),
	"right_ovary_neuroendocrine" => array("Morphologie Ov DROIT::Neuroendocrine" => array(""=>"","x"=>"y")),
	"right_ovary_sarcoma" => array("Morphologie Ov DROIT::Sarcome" => array(""=>"","x"=>"y")),
	"right_ovary_clear_cell" => array("Morphologie Ov DROIT::Clear Cell" => array(""=>"","x"=>"y")),
	"right_ovary_small_cell" => array("Morphologie Ov DROIT::Small Cell" => array(""=>"","x"=>"y")),
	"right_ovary_sex_cord" => array("Morphologie Ov DROIT::Sex cord" => array(""=>"","x"=>"y")),
	"right_ovary_cells_in_cat_rings" => array("Morphologie Ov DROIT::Cellules en bagues de chaton" => array(""=>"","x"=>"y")),
	"right_ovary_struma_ovarii" => array("Morphologie Ov DROIT::Struma Ovarii" => array(""=>"","x"=>"y")),
	"right_ovary_fibroma" => array("Morphologie Ov DROIT::Fibrome" => array(""=>"","x"=>"y")),
	"right_ovary_atrophic" => array("Morphologie Ov DROIT::Atrophique" => array(""=>"","x"=>"y")),
	"right_ovary_fallopian_tube_lesion" => array("Morphologie Ov DROIT::Lésion trompe" => array(""=>"","x"=>"y")),
	"right_ovary_fibrothecoma" => array("Morphologie Ov DROIT::Fibrothécale" => array(""=>"","x"=>"y")),
	"right_ovary_polycystic" => array("Morphologie Ov DROIT::Polykystique" => array(""=>"","x"=>"y")),
	"right_ovary_inclusion_cyst" => array("Morphologie Ov DROIT::Kyste d'inclusion" => array(""=>"","x"=>"y")),

	"path_stage_summary" => "STADE (1-4)",
	"path_tstage" => "T",
	"path_nstage" => "N",
	"path_mstage" => "M",
);

//$detail_fields = array(
////	"stage" => array("Stage" => array(
////		""=>"",
//..
////		"x"=>"y")),
////	"substage" => array("Substage" => array(

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'diagnosis_masters', $master_fields, 'chus_dxd_ovaries', 'diagnosis_master_id', $detail_fields);

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
		Config::$summary_msg['@@MESSAGE@@']['Participant & Many Rows #1'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$paticipant_id]['#FRSQ OV'])."] has data recorded in many rows of the OV file! Please check import more in deep! [Line: ".$m->line.']';
	}
	Config::$data_for_import_from_participant_id[$paticipant_id]['data_imported_from_ov_file'] = true;
	
		// 2- CREATE CONSENT
	
	$consent_date = customGetFormatedDate($m->values[utf8_decode('Date (année-mois-jour)')]);
	if(empty($consent_date)) {
		die('ERR empty consent date line '.$m->line);
	}
	if(isset(Config::$data_for_import_from_participant_id[$paticipant_id]['consent_date'])) {
		if($consent_date != Config::$data_for_import_from_participant_id[$paticipant_id]['consent_date']) {
			Config::$summary_msg['@@WARNING@@']['Participant & Consent Date #1'][] = "The patient with FRSQ#(s) [".implode(",", Config::$data_for_import_from_participant_id[$paticipant_id]['#FRSQ OV'])."] has different consent dates defined in many rows of the OV file! Only one consent will be created! [Line: ".$m->line.']';
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

	// 4- CONTROL DX DATA & SET DX ID, etc
		
	$m->values['diagnosis_control_id'] = Config::$diagnosis_controls['primary']['ovary']['diagnosis_control_id'];
//	$m->values['primary_id'] = "@NULL";
//	$m->values['parent_id'] = NULL;
	
	$nature = array();
	if(!empty($m->values['Diagnostique OVAIRE GAUCHE::Normal'])) {
		$nature[] = 'normal';
		if($m->values['Diagnostique OVAIRE GAUCHE::Normal'] != 'x') $m->values['notes'] .= 'Diagnostique OVAIRE GAUCHE note: '.str_replace('x ','', $m->values['Diagnostique OVAIRE GAUCHE::Normal']).'.';
	}
	if(!empty($m->values['Diagnostique OVAIRE GAUCHE::Bénin'])) {
		$nature[] = 'benign';
		if($m->values['Diagnostique OVAIRE GAUCHE::Bénin'] != 'x') $m->values['notes'] .= 'Diagnostique OVAIRE GAUCHE note: '.str_replace('x ','', $m->values['Diagnostique OVAIRE GAUCHE::Bénin']).'.';
	}
	if(!empty($m->values['Diagnostique OVAIRE GAUCHE::Borderline'])) {
		$nature[] = 'borderline';
		if($m->values['Diagnostique OVAIRE GAUCHE::Borderline'] != 'x') $m->values['notes'] .= 'Diagnostique OVAIRE GAUCHE note: '.str_replace('x ','', $m->values['Diagnostique OVAIRE GAUCHE::Borderline']).'.';
	}
	if(!empty($m->values['Diagnostique OVAIRE GAUCHE::Cancer'])) {
		$nature[] = 'cancer';
		if($m->values['Diagnostique OVAIRE GAUCHE::Cancer'] != 'x') $m->values['notes'] .= 'Diagnostique OVAIRE GAUCHE note: '.str_replace('x ','', $m->values['Diagnostique OVAIRE GAUCHE::Cancer']).'.';
	}
	if(!empty($m->values['Diagnostique OVAIRE GAUCHE::Métastatique'])) {
		$nature[] = 'metastatic';
		if($m->values['Diagnostique OVAIRE GAUCHE::Métastatique'] != 'x') $m->values['notes'] .= 'Diagnostique OVAIRE GAUCHE note: '.str_replace('x ','', $m->values['Diagnostique OVAIRE GAUCHE::Métastatique']).'.';
	}
	//TODO
	$m->values['left_ovary_dx_nature'] = '';
//	if(sizeof($nature) > 1) die('ERR 99849');
//	if(sizeof($nature)) {
//		
//		
//		
//	}


//TODO definir le diag lié a la collection
//TODO que faire si deux diag ovaire

//Dx	
//	
//Diagnostique OVAIRE GAUCHE::Normal	
//Diagnostique OVAIRE GAUCHE::Bénin	
//Diagnostique OVAIRE GAUCHE::Borderline	
//Diagnostique OVAIRE GAUCHE::Cancer	
//Diagnostique OVAIRE GAUCHE::Métastatique
//	
//	
//Site cancer primaire::Ovaire	
//Site cancer primaire::Trompe	
//Site cancer primaire::Épiploon	
//Site cancer primaire::Endomètre	
//Site cancer primaire::Utérus	
//Site cancer primaire::Péritoine	
//Site cancer primaire::Colon	
//Site cancer primaire::Sein	
//Site cancer primaire::Estomac	
//Site cancer primaire::Lymphome Non-Hodgkin	
//Site cancer primaire::Lymphome Hodgkin	
//Site cancer primaire::Rectum	
//Site cancer primaire::Appendice	
//Site cancer primaire::Pancréas	
//Site cancer primaire::Mélanome	
//Site cancer primaire::Uretère	
//Site cancer primaire::Rein	
//Site cancer primaire::Incertain
	
	
	
	
	
	// 5- SET & CONTROL DX Data
	
	if(strlen($m->values['STADE (1-4)']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'STADE (1-4)' [".$m->values['STADE (1-4)']."] value is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['T']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'T' [".$m->values['T']."] value is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['N']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'N' [".$m->values['N']."] value is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
	if(strlen($m->values['M']) > 5) Config::$summary_msg['@@WARNING@@']['TNM values sizes #1'][] = "The 'M' [".$m->values['M']."] value is too long! Only the first 5 charcters will be imported! [Line: ".$m->line.']';
			
	if(!preg_match('/^[0-9]*$/', $m->values['Age au Dx'], $matches)) {
		Config::$summary_msg['@@WARNING@@']['Age au DX #1'][] = "The 'Age au Dx' [".$m->values['Age au Dx']."] is not a integer value! [Line: ".$m->line.']';
		$m->values['Age au Dx'] = '';
	}
	
	$m->values['atcd'] = '';
	$m->values["ATCD Cancer de l'ovaire (oui/non)"] = utf8_encode("ATCD Cancer de l'ovaire (oui/non)");
	if(!empty($m->values["ATCD Cancer de l'ovaire (oui/non)"])) {
		$m->values['atcd'] = preg_match('/non/i',$m->values["ATCD Cancer de l'ovaire (oui/non)"], $matches)? 'n': 'y';
	}
	
	return true;
}

function postOvaryDiagnosesWrite(Model $m){
//	Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'] = null;
//	Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'] = null;	
//	
//	$m->values['notes'] = '';
//	
//	// Substage
//	$m->values['Substage'] = strtoupper($m->values['Substage']);
//	
//	// Manage WHO Codes
//	
//	if(!empty($m->values['Clinical WHO Code'])) {
//		$tmp_who_code = $m->values['Clinical WHO Code'];
//		$m->values['Clinical WHO Code'] = '';
//		
//		preg_match_all('/([0-9]{4}\/[0-9])/', $tmp_who_code, $matches);
//		if(!empty($matches[0])) {
//			$m->values['Clinical WHO Code'] = str_replace('/','',$matches[0][0]);
//			unset($matches[0][0]);
//			if(!empty($matches[0])) {
//				Config::$summary_msg['@@MESSAGE@@']['WHO code #1'][] = 'Many values are defined into cell ['.$tmp_who_code.']. Only first one will be recorded into WHO field, the other one will be added to notes. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
//				$m->values['notes'] = 'Additional WHO codes : '.implode(", ", $matches[0]);	
//			}
//			$tmp_who_code = str_replace(array(' ',',',CHR(10),CHR(13)), array('','','',''), preg_replace('/([0-9]{4}\/[0-9])/', '', $tmp_who_code));
//			if(!empty($tmp_who_code)) {
//				Config::$summary_msg['@@WARNING@@']['WHO code #1'][] = 'Both WHO code and text were defined into the source file. Add value ['.$tmp_who_code.'] as WHO comment. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
//				$m->values['notes'] .= ' Additional WHO code comments : '.$tmp_who_code;	
//			}
//			if(!array_key_exists($m->values['Clinical WHO Code'], Config::$dx_who_codes)) {
//				Config::$summary_msg['@@ERROR@@']['WHO code #1'][] = 'WHO code value ['.$m->values['Clinical WHO Code'].'] not supported into ATiM. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
//				$m->values['notes'] .= ' WHO code not supported : '.$m->values['Clinical WHO Code'];					
//				$m->values['Clinical WHO Code'] = '';
//			}			
//			
//		} else {
//			if(in_array($tmp_who_code, array('NA','Normal','N/A'))) {
//				Config::$summary_msg['@@MESSAGE@@']['WHO code #2'][] = 'NA or Normal are not migrated. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
//			
//			} else {
//				Config::$summary_msg['@@WARNING@@']['WHO code #2'][] = 'File values does not match the expected format ['.$tmp_who_code.']. Value will be added to the notes. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
//				$m->values['notes'] = 'Wrong WHO codes migrated from source file: '.$tmp_who_code;
//			}
//		}
//	}
//	
//	// Check data are recorded
//	
//	if(empty($m->values['morphology']) &&
//	empty($m->values['notes']) &&
//	empty($m->values['stage']) &&
//	empty($m->values['substage']) &&
//	empty($m->values['Clinical Diagnosis']) &&
//	empty($m->values['Clinical History']) &&
//	empty($m->values['Review Diagnosis']) &&
//	empty($m->values['Review Comment']) &&
//	empty($m->values['Review Grade'])) {
//		Config::$summary_msg['@@WARNING@@']['OVCARE Primary Diagnosis #1'][] = 'Created an empty Primary Diagnosis. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
//	}
//	
//	// Primary vs Secondary
//	
//	preg_match('/(metastasis|metastatic)/', strtolower($m->values['Review Diagnosis']), $matches);
//	if($matches) {
//		
//		// SECONDARY-OVCARE
//		
//		global $connection;
//		
//		//1- Unknown Primary: master
//		
//		$created = array(
//			"created"		=> "NOW()", 
//			"created_by"	=> Config::$db_created_id, 
//			"modified"		=> "NOW()",
//			"modified_by"	=> Config::$db_created_id
//		);
//		
//		$insert_arr = array(
//			"icd10_code" 			=> "'D489'", 
//			"participant_id"		=> Config::$record_ids_from_voa[Config::$current_voa_nbr]['participant_id'], 
//			"diagnosis_control_id"	=> "15"
//		);
//		$main_insert_arr = array_merge($insert_arr, $created);
//		$query = "INSERT INTO diagnosis_masters (".implode(", ", array_keys($main_insert_arr)).") VALUES (".implode(", ", array_values($main_insert_arr)).")";
//		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$unknown_primary_id = mysqli_insert_id($connection);
//		$query = "UPDATE diagnosis_masters SET primary_id = $unknown_primary_id WHERE id = $unknown_primary_id;";
//		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$rev_insert_arr = array_merge($insert_arr, array('id' => "$unknown_primary_id", 'primary_id' => "$unknown_primary_id", 'version_created' => "NOW()"));
//		$query = "INSERT INTO diagnosis_masters_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
//		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		
//		//2- Unknown Primary: detail
//		
//		$insert_arr = array(
//			"diagnosis_master_id"	=> "$unknown_primary_id"
//		);
//		$query = "INSERT INTO dxd_primaries (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
//		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$detail_id = mysqli_insert_id($connection);
//		$rev_insert_arr = array_merge($insert_arr, array('id' => "$detail_id", 'version_created' => "NOW()"));
//		$query = "INSERT INTO dxd_primaries_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
//		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		
//		Config::$summary_msg['@@MESSAGE@@']['Unknown primary #1'][] = "A review defined ovcare diagnosis as secondary (see 'Review Diagnosis'): created an unknown primary. [VOA#: ".Config::$current_voa_nbr.' / line: '.$m->line.']';
//		
//		//2- Set data for scondary
//		
//		$m->values['diagnosis_control_id'] = "22";
//		
//		Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'] = $unknown_primary_id;
//	
//	} else {
//		
//		// PRIMARY-OVCARE
//		
//		$m->values['diagnosis_control_id'] = "20";
//	}
//	
//	return true;
}

function postDiagnosisWrite(Model $m){
//	global $connection;
//	
//	$ovcare_diagnosis_id = $m->last_id;
//	Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'] = $ovcare_diagnosis_id;
//	Config::$record_ids_from_voa[Config::$current_voa_nbr]['collection_diagnosis_id'] = $ovcare_diagnosis_id;
//	
//	$update_strg = "";
//	if(empty(Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'])) {
//		// OVCARE Diagnosis is a primary
//		Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'] = $ovcare_diagnosis_id;	
//	} else {
//		// OVCARE Diagnosis is a secondary
//		$update_strg .= 'parent_id = '.Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'].', ';
//	}
//	
//	$update_strg .= "primary_id = ".Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'];
//	
//	$query = "UPDATE diagnosis_masters SET $update_strg WHERE id = $ovcare_diagnosis_id;";
//	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	$query = "UPDATE diagnosis_masters_revs SET $update_strg WHERE id = $ovcare_diagnosis_id;";
//	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}

//======================================================================================================================
// ADDITIONAL FUNCTIONS
//======================================================================================================================



