<?php

function loadPathReportAndDiagnosis() {
	Config::$path_reports = array();
	Config::$diagnosis = array();
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_path_reports);
	$filename = substr(Config::$xls_file_path_path_reports, (strrpos(Config::$xls_file_path_path_reports,'/')+1));
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	foreach(array('Rapport Biopsies', 'Rapport-Biopsies v2011') as $work_sheet_name) {
		$summary_msg_title = 'Path Report : File: '.$filename.' / '.$work_sheet_name;
		if($work_sheet_name == 'Rapport Biopsies') {
			Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Fields not parsed'][] = "'Âge','# zones évaluées en biopsie','Date chirurgie','Disponibilité des tissus'";
		} else {
			Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Fields not parsed'][] = "'Âge','# zones évaluées en biopsie','Date chirurgie','Histologie Autres :','Volume tumoral total Atteinte légère (<30%)','Volume tumoral total Atteinte modérée (30-60%)','Volume tumoral total Atteinte extensive (>60%)','Disponibilité des tissus Oui','Disponibilité des tissus Non'";
		}
		if(!isset($tmp_xls_reader->sheets[$sheets_nbr[$work_sheet_name]])) die('ERR loadPathReport 3222222');
		$headers = array();
		$line_counter = 0;
		$is_2011_version = preg_match('/v2011$/', $work_sheet_name);
		foreach($tmp_xls_reader->sheets[$sheets_nbr[$work_sheet_name]]['cells'] as $line => $new_line) {
			$line_counter++;
			if($line_counter == 1) {
				$headers = $new_line;
			} else {
				$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
				$patient_identification = str_replace('S4P0067a','S4P0067', $new_line_data['Code Patient']);
				if(preg_match('/^S4P0/', $patient_identification)) $patient_identification = 'P'.$patient_identification;
				// Diagnosis
				$tmp_res = loadDiagnosis($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $is_2011_version);
				if($tmp_res) {
					if(isset(Config::$diagnosis[$patient_identification])) die('ERR 838372 876286 292 '.$patient_identification);
					Config::$diagnosis[$patient_identification] = $tmp_res;
				}
				// Path Report
				$tmp_res = loadPathReport($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $is_2011_version);
				if($tmp_res) {
					if(isset(Config::$path_reports[$patient_identification])) die('ERR 838372 876286 292 '.$patient_identification);
					Config::$path_reports[$patient_identification] = $tmp_res;
				}
			}
		}
	}
}

function loadPathReport($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $is_2011_version = false) {
	// EVENT MASTER
	
	$event_masters = array();
	
	$tmp_event_date = getDateAndAccuracy($new_line_data['Date rapport pathologie'], $summary_msg_title, "Date rapport pathologie", $line_counter);
	if($tmp_event_date) {
		$event_masters['event_date'] = $tmp_event_date['date'];
		$event_masters['event_date_accuracy'] = $tmp_event_date['accuracy'];
	}
	if($new_line_data['Notes']) $event_masters['event_summary'] = str_replace("'", "''", $new_line_data['Notes']);
	$event_masters['procure_form_identification'] = $patient_identification.' V01 -PST1';
	
	// EVENT DETAIL
	
	$event_details = array();
	if($new_line_data['# rapport']) $event_details['path_number'] = $new_line_data['# rapport'];
	if($new_line_data['Pathologiste']) $event_details['pathologist_name'] = str_replace("'", "''", $new_line_data['Pathologiste']);
	
	// Dimensions
	$tmp_arr = array(
		"prostate_weight_gr" => "Dimensions prostate Poids (g)",
		"prostate_length_cm" => "Dimensions prostate Longueur (cm)",
		"prostate_width_cm" => "Dimensions prostate largeur (cm)",
		"prostate_thickness_cm" => "Dimensions prostate hauteur (cm)",
		"right_seminal_vesicle_length_cm" => "Dimensions vésicules séminales Droite Longueur (cm)",
		"right_seminal_vesicle_width_cm" => "Dimensions vésicules séminales Droite Largeur (cm)",
		"right_seminal_vesicle_thickness_cm" => "Dimensions vésicules séminales Droite Hauteur (cm)",
		"left_seminal_vesicle_length_cm" => "Dimensions vésicules séminales  Gauche Longueur (cm)",
		"left_seminal_vesicle_width_cm" => "Dimensions vésicules séminales  Gauche Largeur (cm)",
		"left_seminal_vesicle_thickness_cm" => "Dimensions vésicules séminales  Gauche Hauteur (cm)");
	foreach($tmp_arr as $db_field => $file_field) {
		if(strlen($new_line_data[$file_field]) && !in_array($new_line_data[$file_field], array('ND', 'N/A', 'nd', '-'))) {
			if(preg_match('/^([0-9]+)([\.\,][0-9]+){0,1}\ {0,1}(.*)$/', $new_line_data[$file_field], $matches)) {
				$event_details[$db_field] =  $matches[1].(empty($matches[2])? '' : str_replace(',','.',$matches[2]));
				if(!empty($matches[3]))	Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Prostate and vesicle dimensions: Filed contains more than value'][] = "Value '".$new_line_data[$file_field]."' for field '$file_field' contains additional info that won't be imported. See line: $line_counter";
			} else {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong float value for prostate and vesicle dimensions'][] = "Value '".$new_line_data[$file_field]."' for field '$file_field' is not a float. See line: $line_counter";
			}
		}
	}
	
	// Histology
	$tmp_arr = array_merge(
		($is_2011_version? array("Histologie Adénocarcinome acinaire ou de type usuel"  => "acinar adenocarcinoma/usual type"):array("Histologie Adénocarcinome acinaire ou de type usuel / bien différencié" => "acinar adenocarcinoma/usual type", "Histologie Adénocarcinome acinaire ou de type usuel / peu différencié" => "acinar adenocarcinoma/usual type")),
		array("Histologie Adénocarcinome canalaire" => "prostatic ductal adenocarcinoma",
			"Histologie Adénocarcinome mucineux" => "mucinous adenocarcinoma",
			"Histologie Carcinome à cellules indépendantes" => "signet-ring cell carcinoma",
			"Histologie Carcinome adénosquameux" => "adenosquamous carcinoma",
			"Histologie Carcinome à petites cellules" => "small cell carcinoma",
			"Histologie Carcinome sarcomatoïde" => "sarcomatoid carcinoma"));
	$histo_precisions = array();
	$histo_vals = array();
	foreach($tmp_arr as $file_field => $db_value) {
		if(strlen($new_line_data[$file_field]) && $new_line_data[$file_field] != 'N/A') {
			$histo_vals[] = $db_value;
			if(!in_array($new_line_data[$file_field], array('X','x', '1'))) {
				if(preg_match('/^[xX1]\ \((.+)\)$/', $new_line_data[$file_field], $matches)) {
					$histo_precisions[] = $matches[1];
					Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Histological value + precision'][] = "Extracted precision '".$matches[1]."' from value '".$new_line_data[$file_field]."' assigned to field '$file_field'. See line: $line_counter";
				} else {
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Wrong histological value'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is different than [X or 1]. Value will be considered as positive and added to precision. See line: $line_counter";
					$histo_precisions[] = $new_line_data[$file_field];
				}
			}
			if(preg_match('/^Histologie\ Adénocarcinome\ acinaire\ ou\ de\ type\ usuel\ \/\ (peu|bien)\ différencié$/', $file_field, $matches)) $histo_precisions[] = $matches[1].' différencié';
		}
	}
	if(sizeof($histo_vals) == 1) {
		$event_details["histology"] = $histo_vals[0];
		$event_details["histology_other_precision"] = implode(' | ', $histo_precisions);
	} else if(sizeof($histo_vals) > 1) {
		Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['More than one histological value'][] = "See values '".implode(' + ', $histo_vals)."'. No histological value will be imported. See line: $line_counter";
	}
	if(isset($new_line_data['Histologie Autres :']) && $new_line_data['Histologie Autres :']) die('ERR 38832682762');
	
	// Tumor location			
	$tmp_arr = array("Localisation de la tumeur Ant droit" => "tumour_location_right_anterior",
		"Localisation de la tumeur Ant gauche" => "tumour_location_left_anterior",
		"Localisation de la tumeur Post droit" => "tumour_location_right_posterior",
		"Localisation de la tumeur Post gauche" => "tumour_location_left_posterior",
		"Localisation de la tumeur Apex" => "tumour_location_apex",
		"Localisation de la tumeur Base" => "tumour_location_base",
		"Localisation de la tumeur Col vésical" => "tumour_location_bladder_neck");
	foreach($tmp_arr as $file_field => $db_field) {
		if(strlen($new_line_data[$file_field]) && !in_array($new_line_data[$file_field], array('N/A','ND'))) {
			if(in_array($new_line_data[$file_field], array('1','x','X'))) {
				$event_details[$db_field] = '1';
			} else {
				if(preg_match('/^[xX]/', $new_line_data[$file_field])) {
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Wrong tumor location value'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is different than [X or 1]. Check box will be selected but additional information won't be imported. See line: $line_counter";
				} else {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong tumor location value'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is different than [X or 1]. No data will be imported. See line: $line_counter";
				}
			}
		}
	}
	
	// Grade
	$tmp_arr = array(
		"Grade primaire" => "histologic_grade_primary_pattern",
		"Grade secondaire" => "histologic_grade_secondary_pattern",
		"Grade tertiaire" => "histologic_grade_tertiary_pattern",
		"Score Gleason" => "histologic_grade_gleason_score");
	foreach($tmp_arr as $file_field => $db_field) {
		if($new_line_data[$file_field] && !in_array($new_line_data[$file_field], array('N/A','ND'))) {
			if(!preg_match('/^[0-9]+$/', $new_line_data[$file_field]) || ($db_field != "histologic_grade_gleason_score" && !in_array($new_line_data[$file_field], array('2','3','4','5')))) {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong Grade value'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is not supported. No data will be imported. See line: $line_counter";
			} else {
				$event_details[$db_field] = $new_line_data[$file_field];
			}
		}
	}
	
	// Margins
	$tmp_margins_event_details = array();
	if(array_key_exists('Marges Type', $new_line_data)) {
		 switch($new_line_data['Marges Type']) {
		 	case 'Unifocale':
		 	case 'Multifocale':
		 	case 'unifocale':
		 	case 'multifocale':
		 		$tmp_margins_event_details['margins_focal_or_extensive'] = 'focal';
		 		Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Complex Margin Type value'][] = "Value '".$new_line_data['Marges Type']."' assigned to field 'Marges Type' contains more information than 'focal'. Additional information wont' be imported. See line: $line_counter";
		 		break;
		 	case 'base droite':
		 		Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unknown Margin Type value'][] = "Value '".$new_line_data['Marges Type']."' assigned to field 'Marges Type' is not suppported. Data wont' be imported. See line: $line_counter";
		 		break;
		 	case 'ND':
		 	case 'N/A':
		 	case '':
		 		break;
		 	default:
		 		die('ERR 32872 763298732982 '.$new_line_data['Marges Type']);
	 	}
	} else {
		$tmp_margin_types = array();
		foreach(array('Marges Type Focale' => 'focal','Marges Type Extensive' => 'extensive') as $file_field => $res) {
			$new_line_data[$file_field] = str_replace(array(' ','ND'), array('',''), $new_line_data[$file_field]);
			if(strlen($new_line_data[$file_field])) {
				if($new_line_data[$file_field] != '1') die('ERR 2399836333 '.$file_field.' = ['.$new_line_data[$file_field].']');
				$tmp_margin_types[] = $res;
			}
		}
		if(sizeof($tmp_margin_types) > 1) die('ERR 7637263828632');
		if($tmp_margin_types) $tmp_margins_event_details['margins_focal_or_extensive'] = $tmp_margin_types[0];
	}
	$tmp_arr = array(
		"margins_extensive_anterior_left" => "Marges Ant gauche",
		"margins_extensive_anterior_right" => "Marges Ant droit",
		"margins_extensive_posterior_left" => "Marges Post gauche",
		"margins_extensive_posterior_right" => "Marges Post droit",
		"margins_extensive_bladder_neck" => "Marges Col vésical");
	foreach($tmp_arr as $db_field => $file_field) {
		if($new_line_data[$file_field] && !in_array($new_line_data[$file_field], array('N/A','ND'))) {
			if(!in_array($new_line_data[$file_field], array('1','x','X'))) {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong Magin value'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is not supported. Field won't be checked. See line: $line_counter";
			} else {
				$tmp_margins_event_details[$db_field] = '1';
			}
		}
	}
	if($new_line_data['Marges Apex'] && !in_array($new_line_data['Marges Apex'], array('N/A','ND'))) {
		if(!in_array($new_line_data['Marges Apex'], array('1','x','X'))) {
			Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong Apex Magin value'][] = "Value '".$new_line_data['Marges Apex']."' assigned to field 'Marges Apex' is not supported. Field won't be checked. See line: $line_counter";
		} else {
			if(array_key_exists('Marges Localisation Apex', $new_line_data)) {
				switch($new_line_data['Marges Localisation Apex']) {
					case 'Ant. + Post.':
					case 'G+D':
						$tmp_margins_event_details["margins_extensive_apical_anterior_left"] = '1';
						$tmp_margins_event_details["margins_extensive_apical_anterior_right"] = '1';
						$tmp_margins_event_details["margins_extensive_apical_posterior_left"] = '1';
						$tmp_margins_event_details["margins_extensive_apical_posterior_right"] = '1';
						break;
					case 'LA + RA':
						$tmp_margins_event_details["margins_extensive_apical_anterior_left"] = '1';
						$tmp_margins_event_details["margins_extensive_apical_anterior_right"] = '1';
						break;
					case 'Post':
					case 'Post.':
						$tmp_margins_event_details["margins_extensive_apical_posterior_left"] = '1';
						$tmp_margins_event_details["margins_extensive_apical_posterior_right"] = '1';
						break;
					case 'RP':
						$tmp_margins_event_details["margins_extensive_apical_posterior_right"] = '1';
						break;
					case 'LP':
						$tmp_margins_event_details["margins_extensive_apical_posterior_left"] = '1';
						break;
					case 'LA':
						$tmp_margins_event_details["margins_extensive_apical_anterior_left"] = '1';
						break;
					case 'D':
						$tmp_margins_event_details["margins_extensive_apical_posterior_right"] = '1';
						$tmp_margins_event_details["margins_extensive_apical_anterior_right"] = '1';
						break;
					case 'ND':
						break;
					default:
						die('Err 632632732723');
				}
			} else {
				$tmp_margins_event_details["margins_extensive_apical_anterior_left"] = '1';
				$tmp_margins_event_details["margins_extensive_apical_anterior_right"] = '1';
				$tmp_margins_event_details["margins_extensive_apical_posterior_left"] = '1';
				$tmp_margins_event_details["margins_extensive_apical_posterior_right"] = '1';
			}
			
		}
	} else if(array_key_exists('Marges Localisation Apex', $new_line_data) && strlen($new_line_data['Marges Localisation Apex'])) die('ERR 23 687326 27392 7332');
	if(array_key_exists('Marges Score Gleason aux marges', $new_line_data)) {
		if($new_line_data['Marges Score Gleason aux marges'] && $new_line_data['Marges Score Gleason aux marges'] != 'ND') {
			if(!preg_match('/^[0-9]+\+[0-9]+=[0-9]+$/', $new_line_data['Marges Score Gleason aux marges'])) die('ERR 236 7676623798732 '.$new_line_data['Marges Score Gleason aux marges']);
			$tmp_margins_event_details['margins_gleason_score'] = $new_line_data['Marges Score Gleason aux marges'];
		}
	}
	if(array_key_exists('Marges Résultat', $new_line_data)) {
		switch($new_line_data['Marges Résultat']) {
			case 'Positive':
			case 'positive':
			case 'Positives':
			case 'positives':
				$event_details['margins'] = 'positive';
				break;
			case 'Négatives':
			case 'négatives':
			case 'nég. (pos.< 0,1cm)':
				$event_details['margins'] = 'negative';
				break;
			case 'ne peuvent être évaluées':
			case 'ne peut être évaluées':
				$event_details['margins'] = 'cannot be assessed';
				break;
			case 'N/A':
			case '':
				break;
			default:
				die('ERR 327368273687 32 '.$new_line_data['Marges Résultat']);
		}
	} else {
		$tmp_margins = array();
		foreach(array('Marges Résultat Positives' => 'positive','Marges Résultat Négatives' => 'negative','Marges Résultat N/A' => 'cannot be assessed') as $file_field => $res) {
			if(strlen($new_line_data[$file_field])) {
				if($new_line_data[$file_field] != '1') die('ERR 2376 87263872 23');
				$tmp_margins[] = $res;
			}
		}
		if(sizeof($tmp_margins) > 1) die('ERR 7637263828632');
		if($tmp_margins) $event_details['margins'] = $tmp_margins[0];
	}
	if(isset($event_details['margins']) && $event_details['margins'] == 'positive') {
		if(empty($tmp_margins_event_details)) {
			Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No margin precision'][] = "Margin has been defined as positive but no precisions/sites has been defined. See line: $line_counter";
		}
		$event_details = array_merge($event_details, $tmp_margins_event_details);
	} else {
		if(!empty($tmp_margins_event_details)) Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Margin mismatch'][] = "Margin has been defined as negative but marging precisions/sites has been defined. See line: $line_counter";
	}
		
	// Extra prostatic extension
	if(array_key_exists('Invasion extracapsulaire Résultat', $new_line_data)) {
		switch($new_line_data['Invasion extracapsulaire Résultat']) {
			case 'Absente':
			case 'Négative':
			case 'absente':
			case 'négative':
				$event_details['extra_prostatic_extension'] = 'absent';
				break;
			case 'Présente':
			case 'présente':
				$event_details['extra_prostatic_extension'] = 'present';
				break;
			case 'ND':
			case 'N/A':	
			case '':	
				break;
			default:
				die('ERR 328 782739827 23 '.$new_line_data['Invasion extracapsulaire Résultat']);
		}
		switch($new_line_data['Extension extraprostatique Type']) {
			case 'Focale':
			case 'focale':
				$event_details['extra_prostatic_extension_precision'] = 'focal';
				break;
			case 'Établie':
			case 'établie':
				$event_details['extra_prostatic_extension_precision'] = 'established';
				break;
			case 'ND':
			case 'N/A':	
			case '':	
				break;
			default:
				die('ERR 328 782739827 23 '.$new_line_data['Extension extraprostatique Type']);
		}
		if(isset($event_details['extra_prostatic_extension_precision']) && (!isset($event_details['extra_prostatic_extension']) || $event_details['extra_prostatic_extension'] != 'present')) die('ERR 32 876238 7289923 ');
		$tmp_extra_prostatic_extension = array();
		$tmp_arr = array(
			"Localisation de l'extension extraprostatique Ant droit" => "extra_prostatic_extension_right_anterior",
			"Localisation de l'extension extraprostatique Ant gauche" => "extra_prostatic_extension_left_anterior",
			"Localisation de l'extension extraprostatique Post droit" => "extra_prostatic_extension_right_posterior",
			"Localisation de l'extension extraprostatique Post gauche" => "extra_prostatic_extension_left_posterior"
		);
		foreach($tmp_arr as $file_field => $db_field) {
			if(in_array($new_line_data[$file_field], array('X','x', '1'))) {
				$tmp_extra_prostatic_extension[$db_field] = '1';
			} else if(!in_array($new_line_data[$file_field], array('NA','ND', 'N/D', '', 'N/A'))){
				Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Wrong extra prostatic extension'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is different than [X or 1]. Value won't be imported. See line: $line_counter";
			}		
		}
		switch(strtolower($new_line_data["Vésicules séminales"])) {
			case 'absente':
			case 'non prélevées':
			case 'absente (non-prélevées)':
				$event_details['extra_prostatic_extension_seminal_vesicles'] = 'absent';
				break;
				
			case 'présente':
				$event_details['extra_prostatic_extension_seminal_vesicles'] = 'bilateral';
				Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Seminal vesicles Extension set to bilateral'][] = "... value 'present' is not supported in DB. See line: $line_counter";
				break;
			case 'nd (sans les vs)':
			case 'nd':
			case 'n/a':
			case '':
				break;
			default:
				die('ERR 37373783838');
		}
		if($tmp_extra_prostatic_extension && (!isset($event_details['extra_prostatic_extension']) || $event_details['extra_prostatic_extension'] != 'present')) die('ERR 3332222134 '.$line_counter);
		$event_details = array_merge($event_details, $tmp_extra_prostatic_extension);
	} else {
		$tmp_arr = array(
			'Extension extraprostatique Absente', 
			'Extension extraprostatique Présente', 
			'Extension extraprostatique Type Focale', 
			'Extension extraprostatique Type Établie');
		foreach($tmp_arr as $file_field) {
			$new_line_data[$file_field] = str_replace('ND', '', $new_line_data[$file_field]);
			if($new_line_data[$file_field] && $new_line_data[$file_field] != '1') die('ERR  2376 2876327 '.$file_field.' = '.$new_line_data[$file_field]);
		}
		if($new_line_data['Extension extraprostatique Absente'] && $new_line_data['Extension extraprostatique Présente']) die('ERR 236287367432');
		if($new_line_data['Extension extraprostatique Absente']) $event_details['extra_prostatic_extension'] = 'absent';
		if($new_line_data['Extension extraprostatique Présente']) $event_details['extra_prostatic_extension'] = 'present';
		if($new_line_data['Extension extraprostatique Type Focale'] && $new_line_data['Extension extraprostatique Type Établie']) die('ERR 8488449');
		if($new_line_data['Extension extraprostatique Type Focale']) {
			if(!isset($event_details['extra_prostatic_extension']) || $event_details['extra_prostatic_extension'] != 'present') die('ERR 388327273231');
			$event_details['extra_prostatic_extension_precision'] = 'focal';
		}
		if($new_line_data['Extension extraprostatique Type Établie']) {
			if(!isset($event_details['extra_prostatic_extension']) || $event_details['extra_prostatic_extension'] != 'present') die('ERR 388327273232');
			$event_details['extra_prostatic_extension_precision'] = 'established';
		}
		$tmp_extra_prostatic_extension = array();
		$tmp_arr = array(
			"Localisation de l'extension extraprostatique Ant droit" => "extra_prostatic_extension_right_anterior",
			"Localisation de l'extension extraprostatique Ant gauche" => "extra_prostatic_extension_left_anterior",
			"Localisation de l'extension extraprostatique Post droit" => "extra_prostatic_extension_right_posterior",
			"Localisation de l'extension extraprostatique Post gauche" => "extra_prostatic_extension_left_posterior",
			"Localisation de l'extension extraprostatique Apex" => "extra_prostatic_extension_apex",
			"Localisation de l'extension extraprostatique Base" => "extra_prostatic_extension_base",
			"Localisation de l'extension extraprostatique Col vésical" => "extra_prostatic_extension_bladder_neck",
			"Vésicules séminales Absente" => "extra_prostatic_extension_seminal_vesicles",
			"Vésicules séminales Présente" => "extra_prostatic_extension_seminal_vesicles"	
		);
		foreach($tmp_arr as $file_field => $db_field) {
			if($db_field != "extra_prostatic_extension_seminal_vesicles") {
				if($new_line_data[$file_field] && $new_line_data[$file_field] != '1') die('ERR  2376 287632wwe '.$new_line_data[$file_field] );
				if($new_line_data[$file_field]) $tmp_extra_prostatic_extension[$db_field] = '1';
			} else {
				if($new_line_data[$file_field]) {
					if(isset($tmp_extra_prostatic_extension[$db_field])) die('ERR 32883232832');
					if($file_field == "Vésicules séminales Absente") {
						$event_details[$db_field] = 'absent';
					} else {
						$event_details[$db_field] = 'bilateral';
						Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Seminal vesicles Extension set to bilateral'][] = "...present value is supported in DB. See line: $line_counter";
					}
				}
			}
		}
		if($tmp_extra_prostatic_extension && (!isset($event_details['extra_prostatic_extension']) || $event_details['extra_prostatic_extension'] != 'present')) die('ERR 388327273233 '.$line_counter);
		$event_details = array_merge($event_details, $tmp_extra_prostatic_extension);
	}
	
	//Staging
	if(strlen($new_line_data['Version Stade Pathologique']) && !in_array($new_line_data['Version Stade Pathologique'], array('ND', 'N/A', 'nd', '-'))) {
		$event_details['pathologic_staging_version'] = $new_line_data['Version Stade Pathologique'];	
	}
	if(strlen($new_line_data['pT']) && !in_array($new_line_data['pT'], array('ND', 'N/A', 'nd', '-'))) {
		if(in_array($new_line_data['pT'], array("pTx","pT2","pT2a","pT2b","pT2c","pT2+","pT3a","pT3b","pT4"))) {
			$event_details['pathologic_staging_pt'] = $new_line_data['pT'];
		} else {
			Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patho Staging pT'][] = "Value '".$new_line_data['pT']."' is not supported in DB. See line: $line_counter";	
		}
	}
	if(strlen($new_line_data['pN']) && !in_array($new_line_data['pN'], array('ND', 'N/A', 'nd', '-'))) {
		if(in_array($new_line_data['pN'], array("pNx","pn0","pN0",'pN1'))) {
			$event_details['pathologic_staging_pn'] = str_replace('pN0', 'pn0', $new_line_data['pN']);
		} else {
			Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patho Staging pN'][] = "Value '".$new_line_data['pN']."' is not supported in DB. See line: $line_counter";
		}
	}
	if(strlen($new_line_data['pM']) && !in_array($new_line_data['pM'], array('ND', 'N/A', 'nd', '-'))) {
		if(in_array($new_line_data['pM'], array("pMx","pM0","pm1","pM1","pM1a","pM1b","pM1c"))) {
			$event_details['pathologic_staging_pM'] = str_replace('pM1', 'pm1', $new_line_data['pM']);
		} else {
			Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patho Staging pM'][] = "Value '".$new_line_data['pM']."' is not supported in DB. See line: $line_counter";
		}
	}
	if(array_key_exists('Ganglions récoltés', $new_line_data)) {
		if(!in_array($new_line_data['Ganglions récoltés'], array('ND', 'N/A', 'nd', '-', ''))) {
			switch($new_line_data['Ganglions récoltés']) {
				case 'Non':
				case 'non':
					$event_details['pathologic_staging_pn_collected'] = 'n';
					break;
				case 'Oui (retrouvé sur la pièce)':
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Node colletion'][] = "Value '".$new_line_data['Ganglions récoltés']."' assigned to field 'Ganglions récoltés' is different than [oui]. Check box will be selected but additional information won't be imported. See line: $line_counter";
				case 'Oui':
				case 'oui':
					$event_details['pathologic_staging_pn_collected'] = 'y';
					break;
				default:
					die('ERR 23768723642');
			}
		}
	} else {
		
		$res = array();
		if($new_line_data['Ganglions récoltés Oui']) {
			if($new_line_data['Ganglions récoltés Oui'] != '1') die('ERR 37286382739832');
			$res[] = 'y';
		}
		if($new_line_data['Ganglions récoltés Non']) {
			if($new_line_data['Ganglions récoltés Non'] != '1') die('ERR 37286382739832');
			$res[] = 'n';
		}
		if($res) {
			if(sizeof($res) > 1) die('ERR 273683276328732');
			$event_details['pathologic_staging_pn_collected'] = $res[0];
		}
	}
	foreach(array('Nb ganglions examinés' => 'pathologic_staging_pn_lymph_node_examined', 'Nb ganglions atteints' => 'pathologic_staging_pn_lymph_node_involved') as $file_field => $db_field) {
		if(strlen($new_line_data[$file_field]) && !in_array($new_line_data[$file_field], array('ND', 'N/A', 'nd', '-', ''))) {
			if(preg_match('/^[0-9]+$/', $new_line_data[$file_field])) {
				$event_details[$db_field] = $new_line_data[$file_field];
			} else {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patho Lymph Node'][] = "$file_field Value '".$new_line_data[$file_field]."' is not a integer. See line: $line_counter";
			}
		}
	}
	
	if(!empty($event_details)) {
		return array('EventMaster' => $event_masters, 'EventDetail' => $event_details);
	} else {
		$notes = '';
		if(isset($event_masters['event_summary']))  $notes = " Folloqing note won't be imported : [".$event_masters['event_summary']."].";
		Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No Path Report Created'][] = "No path report created for patient $patient_identification.$notes See line: $line_counter";
		return array();
	}
}

function loadDiagnosis($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $is_2011_version) {
	// EVENT MASTER
	
	$event_masters = array();
	
// 	$tmp_event_date = getDateAndAccuracy($new_line_data['Date rapport pathologie'], $summary_msg_title, "Date rapport pathologie", $line_counter);
// 	if($tmp_event_date) {
// 		$event_masters['event_date'] = $tmp_event_date['date'];
// 		$event_masters['event_date_accuracy'] = $tmp_event_date['accuracy'];
// 	}
// 	if($new_line_data['Notes']) $event_masters['event_summary'] = str_replace("'", "''", $new_line_data['Notes']);
 	$event_masters['procure_form_identification'] = $patient_identification.' V01 -FBP1';
	
	// EVENT DETAIL
	
	$event_details = array();
	
	//PSA
	if(strlen($new_line_data['PSA au diagnostic (ug/L)']) && !in_array($new_line_data['PSA au diagnostic (ug/L)'], array('ND', 'N/A', 'nd', '-'))) {
		if(preg_match('/^([0-9]+)([\.\,][0-9]+){0,1}$/', $new_line_data['PSA au diagnostic (ug/L)'], $matches)) {
			$event_details['aps_pre_surgery_total_ng_ml'] =  $matches[1].(empty($matches[2])? '' : str_replace(',','.',$matches[2]));
		} else {
			Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong float value for PSA'][] = "Value '".$new_line_data['PSA au diagnostic (ug/L)']."' for field ''PSA au diagnostic (ug/L)'' is not a float. See line: $line_counter";
		}
	}
	
	//Cores Study
	foreach(array('Nb.biopsies prélevées' => 'collected_cores_nbr', 'Nb.carottes atteintes' => 'nbr_of_cores_with_cancer') AS $file_field => $db_field) {
		if(strlen($new_line_data[$file_field]) && !in_array($new_line_data[$file_field], array('ND', 'N/A', 'nd', '-', ''))) {
			if(preg_match('/^[0-9]+$/', $new_line_data[$file_field])) {
				$event_details[$db_field] = $new_line_data[$file_field];
			} else {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong int value for core study'][] = "Value '".$new_line_data[$file_field]."' for field '$db_field' is not a integer. See line: $line_counter";
			}
		}
	}
	
	//Biopsy
	$max_highest_gleason_score_percentage = null;
	$biopsy_score = array();
	for($b_id = 1; $b_id < 11; $b_id++) {
		//Biopsie % affecté
		$file_field = "Biopsie$b_id % affecté";
		if(strlen($new_line_data[$file_field]) && !in_array($new_line_data[$file_field], array('ND', 'N/A', 'nd', '-', ''))) {
			if(preg_match('/^[~]{0,1}([0-9]+)([\.\,][0-9]+){0,1}$/', $new_line_data[$file_field], $matches)) {
				$gleason_score_percentage = $matches[1].(empty($matches[2])? '' : str_replace(',','.',$matches[2]));
				if(!$max_highest_gleason_score_percentage || $max_highest_gleason_score_percentage < $gleason_score_percentage) $max_highest_gleason_score_percentage = $gleason_score_percentage;
			} else if(preg_match('/^([0-9]+)\ {0,1}(et|-)\ {0,1}([0-9]+)$/', $new_line_data[$file_field], $matches)) {
				$gleason_score_percentage = ($matches[1] > $matches[3])? $matches[1] : $matches[3];			
				if(!$max_highest_gleason_score_percentage || $max_highest_gleason_score_percentage < $gleason_score_percentage) $max_highest_gleason_score_percentage = $gleason_score_percentage;
			} else {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong float value for Biopsie % affecté'][] = "Value '".$new_line_data[$file_field]."' for field '$file_field' is not a float. Value won't be considered. See line: $line_counter";
			}
		}
		//Biopsie1 score
		$file_field = "Biopsie$b_id score";
		if(strlen($new_line_data[$file_field]) && !in_array($new_line_data[$file_field], array('ND', 'N/A', 'nd', '-', ''))) {
			$new_line_data[$file_field] = str_replace("\n", ' ', $new_line_data[$file_field]);
			$tmp_biopsy_scores = array();
			if(preg_match('/^([1-5])\+([1-5])=([6-9]|10)$/', $new_line_data[$file_field], $matches)) {
				$tmp_biopsy_scores[0]['histologic_grade_primary_pattern'] = $matches[1];
				$tmp_biopsy_scores[0]['histologic_grade_secondary_pattern'] = $matches[2];
				$tmp_biopsy_scores[0]['histologic_grade_gleason_total'] = $matches[3];
				$tmp_biopsy_scores[0]['highest_gleason_score_observed'] = $matches[3];
			} else if(preg_match('/^[\ ]{0,1}([1-5])\+([1-5])=([6-9]|10)\ (et|\/){0,1}[\ ]{0,5}([1-5])\+([1-5])=([6-9]|10)$/', $new_line_data[$file_field], $matches)) {
				$tmp_biopsy_scores[0]['histologic_grade_primary_pattern'] = $matches[1];
				$tmp_biopsy_scores[0]['histologic_grade_secondary_pattern'] = $matches[2];
				$tmp_biopsy_scores[0]['histologic_grade_gleason_total'] = $matches[3];
				$tmp_biopsy_scores[0]['highest_gleason_score_observed'] = $matches[3];
				$tmp_biopsy_scores[1]['histologic_grade_primary_pattern'] = $matches[5];
				$tmp_biopsy_scores[1]['histologic_grade_secondary_pattern'] = $matches[6];
				$tmp_biopsy_scores[1]['histologic_grade_gleason_total'] = $matches[7];
				$tmp_biopsy_scores[1]['highest_gleason_score_observed'] = $matches[7];			
			} else {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong format value for Biopsie score'][] = "Value '".$new_line_data[$file_field]."' for field '$file_field' is not a like [1-5]+[1-5]=[6-9]|10. Value won't be considered. See line: $line_counter";
			}
			foreach($tmp_biopsy_scores as $tmp_biopsy_score) {
				if(empty($biopsy_score) || $biopsy_score['histologic_grade_gleason_total'] < $tmp_biopsy_score['histologic_grade_gleason_total']) {
					$biopsy_score['histologic_grade_primary_pattern'] = $tmp_biopsy_score['histologic_grade_primary_pattern'];
					$biopsy_score['histologic_grade_secondary_pattern'] = $tmp_biopsy_score['histologic_grade_secondary_pattern'];
					$biopsy_score['histologic_grade_gleason_total'] = $tmp_biopsy_score['histologic_grade_gleason_total'];
					$biopsy_score['highest_gleason_score_observed'] = $tmp_biopsy_score['highest_gleason_score_observed'];
				}
			}
		}
	}
	if($max_highest_gleason_score_percentage) $event_details['highest_gleason_score_percentage'] = $max_highest_gleason_score_percentage;
	if($biopsy_score) $event_details = array_merge($event_details, $biopsy_score);

	if(!empty($event_details)) {
		return array('EventMaster' => $event_masters, 'EventDetail' => $event_details);
	} else {
		Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No Diagnosis Information Form'][] = "No Diagnosis Information Form created for patient $patient_identification. See line: $line_counter";
		return array();
	}

}

function recordParticipantPathReport($patient_identification, $participant_id) {
	if(isset(Config::$path_reports[$patient_identification])) {
		$event_control_data = Config::$event_controls['procure pathology report'];
		$event_master_id = customInsertRecord(array_merge(Config::$path_reports[$patient_identification]['EventMaster'], array('participant_id' => $participant_id, 'event_control_id' => $event_control_data['event_control_id'])), 'event_masters', false);
		customInsertRecord(array_merge(Config::$path_reports[$patient_identification]['EventDetail'], array('event_master_id' => $event_master_id)), $event_control_data['detail_tablename'], true);
		unset(Config::$path_reports[$patient_identification]);
	}
}

function recordParticipantDiagnosisForm($patient_identification, $participant_id) {
	if(isset(Config::$diagnosis[$patient_identification])) {
		$event_control_data = Config::$event_controls['procure diagnostic information worksheet'];
		$event_master_id = customInsertRecord(array_merge(Config::$diagnosis[$patient_identification]['EventMaster'], array('participant_id' => $participant_id, 'event_control_id' => $event_control_data['event_control_id'])), 'event_masters', false);
		customInsertRecord(array_merge(Config::$diagnosis[$patient_identification]['EventDetail'], array('event_master_id' => $event_master_id)), $event_control_data['detail_tablename'], true);
		unset(Config::$diagnosis[$patient_identification]);
	}
}