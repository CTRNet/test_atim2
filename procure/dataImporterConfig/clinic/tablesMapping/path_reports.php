<?php
$pkey = "Code du Patient";

$child = array();

$master_fields = array(
	"event_control_id" => "#event_control_id",
	"participant_id" => $pkey,
	
	"event_date" => "#event_date",
	"event_date_accuracy" => "#event_date_accuracy",
	"procure_form_identification" => "#procure_form_identification",
	"event_summary" => "Commentaires du pathologiste"
);

$detail_fields = array(
//	"path_number" => 
	"pathologist_name" => "Nom du pathologiste",
		
	// Dimensions	
		
	"prostate_weight_gr" => "Prostate::poids (g)",
	"prostate_length_cm" => "Prostate::longueur (cm) Apex/Base",
	"prostate_width_cm" => utf8_decode("Prostate::largeur (cm) latérale/latérale"),
	"prostate_thickness_cm" => utf8_decode("Prostate::épaisseur (cm) antéro-postérieur"),
	
	"right_seminal_vesicle_length_cm" => utf8_decode("Vésicule séminale droite::longueur (cm)"),
	"right_seminal_vesicle_width_cm" => utf8_decode("Vésicule séminale droite::largeur (cm)"),
	"right_seminal_vesicle_thickness_cm" => utf8_decode("Vésicule séminale droite::épaisseur (cm)"),
	
	"left_seminal_vesicle_length_cm" => utf8_decode("Vésicule séminale gauche::Longueur (cm)"),
	"left_seminal_vesicle_width_cm" => utf8_decode("Vésicule séminale gauche::Largeur (cm)"),
	"left_seminal_vesicle_thickness_cm" => utf8_decode("Vésicule séminale gauche::épaisseur (cm)"),
	
	// Histology
	
	"histology" => "#histology",
	"histology_other_precision" => "#histology_other_precision",
		
	// Tumor location

	"tumour_location_right_anterior" => array(utf8_decode("Localisation des foyers tumoraux::Antérieur Droit") => array(""=>""," "=>"","x"=>"1")),
	"tumour_location_left_anterior" => array(utf8_decode("Localisation des foyers tumoraux::Antérieur Gauche") => array(""=>""," "=>"","x"=>"1")),
	"tumour_location_right_posterior" => array(utf8_decode("Localisation des foyers tumoraux::Postérieur Droit") => array(""=>""," "=>"","x"=>"1")),
	"tumour_location_left_posterior" => array(utf8_decode("Localisation des foyers tumoraux::Postérieur Gauche") => array(""=>""," "=>"","x"=>"1")),
	"tumour_location_apex" => array("Localisation des foyers tumoraux::Apex" => array(""=>""," "=>"","x"=>"1")),
	"tumour_location_base" => array("Localisation des foyers tumoraux::Base" => array(""=>""," "=>"","x"=>"1")),
	"tumour_location_bladder_neck" => array(utf8_decode("Localisation des foyers tumoraux::Col vésical") => array(""=>""," "=>"","x"=>"1")),
		
	// Tumoral volume 

	"tumour_volume" => "#tumour_volume",
		
	// Histological grade	

	"histologic_grade_primary_pattern" => array(utf8_decode("Patron histologique::primaire (2 à 5)") => array(""=>"","2"=>"2","3"=>"3","4"=>"4","5"=>"5")),
	"histologic_grade_secondary_pattern" => array(utf8_decode("Patron histologique::secondaire (2 à 5)") => array(""=>"","2"=>"2","3"=>"3","4"=>"4","5"=>"5")),
	"histologic_grade_tertiary_pattern" => array(utf8_decode("Patron histologique::Tertiaire (aucun; 2 à 5)") => array(""=>"","aucun"=>"none","2"=>"2","3"=>"3","4"=>"4","5"=>"5")),
	"histologic_grade_gleason_score" => "Patron histologique::Score de Gleason",
		
	// Margins	
	
	"margins" => "#margins",
	"margins_focal_or_extensive" => "#margins_focal_or_extensive",
	"margins_extensive_anterior_left" => "#margins_extensive_anterior_left",
	"margins_extensive_anterior_right" => "#margins_extensive_anterior_right",
	"margins_extensive_posterior_left" => "#margins_extensive_posterior_left",
	"margins_extensive_posterior_right" => "#margins_extensive_posterior_right",
	"margins_extensive_apical_anterior_left" => "#margins_extensive_apical_anterior_left",
	"margins_extensive_apical_anterior_right" => "#margins_extensive_apical_anterior_right",
	"margins_extensive_apical_posterior_left" => "#margins_extensive_apical_posterior_left",
	"margins_extensive_apical_posterior_right" => "#margins_extensive_apical_posterior_right",
	"margins_extensive_bladder_neck" => "#margins_extensive_bladder_neck",
	"margins_extensive_base" => "#margins_extensive_base",
	"margins_gleason_score" => utf8_decode("Marges chirurgicales::Positives::Score de Gleason aux marges"),
		
	// Extra Prostatic Extension
			
	"extra_prostatic_extension" => "#extra_prostatic_extension",	
	"extra_prostatic_extension_precision" => "#extra_prostatic_extension_precision",
	"extra_prostatic_extension_right_anterior" => "#extra_prostatic_extension_right_anterior",
	"extra_prostatic_extension_left_anterior" => "#extra_prostatic_extension_left_anterior",
	"extra_prostatic_extension_right_posterior" => "#extra_prostatic_extension_right_posterior",
	"extra_prostatic_extension_left_posterior" => "#extra_prostatic_extension_left_posterior",
	"extra_prostatic_extension_apex" => "#extra_prostatic_extension_apex",
	"extra_prostatic_extension_base" => "#extra_prostatic_extension_base",
	"extra_prostatic_extension_bladder_neck" => "#extra_prostatic_extension_bladder_neck",
	"extra_prostatic_extension_seminal_vesicles" => "#extra_prostatic_extension_seminal_vesicles",
	
	// Pathologic Staging		

	"pathologic_staging_version" => utf8_decode("Définition pTNM (version)"),
	"pathologic_staging_pt" => array(utf8_decode("Tumeur primaire::pT") => new ValueDomain("procure_pathologic_staging_pt", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"pathologic_staging_pn_collected" => "#pathologic_staging_pn_collected",
	"pathologic_staging_pn" => array(utf8_decode("Ganglions lymphatiques / Adénopathies régionales::résultat de l'examen (cochez)") => new ValueDomain("procure_pathologic_staging_pn", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"pathologic_staging_pn_lymph_node_examined" => "#pathologic_staging_pn_lymph_node_examined",
	"pathologic_staging_pn_lymph_node_involved" => "#pathologic_staging_pn_lymph_node_involved",
	"pathologic_staging_pm" => array(utf8_decode("Métastases à distance") => new ValueDomain("procure_pathologic_staging_pm", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),

);

//see the Model class definition for more info
$model = new MasterDetailModel(1, $pkey, $child, false, "participant_id", $pkey, 'event_masters', $master_fields, 'procure_ed_lab_pathologies', 'event_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postPathReportRead';
$model->post_write_function = 'postPathReportWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['PathReport'] = $model;
	
function postPathReportRead(Model $m){
	$data_to_record = false;
	$path_report_excel_fields = array(
//		"Nom du pathologiste",
		
		// Dimensions
		
		"Prostate::poids (g)", 
		"Prostate::longueur (cm) Apex/Base", 
		"Prostate::largeur (cm) latérale/latérale",  
		"Prostate::épaisseur (cm) antéro-postérieur",
		"Vésicule séminale droite::longueur (cm)", 
		"Vésicule séminale droite::largeur (cm)", 
		"Vésicule séminale droite::épaisseur (cm)",
		"Vésicule séminale gauche::Longueur (cm)", 
		"Vésicule séminale gauche::Largeur (cm)", 
		"Vésicule séminale gauche::épaisseur (cm)",
			
		// Tumor location
		
		"Localisation des foyers tumoraux::Antérieur Droit", 
		"Localisation des foyers tumoraux::Antérieur Gauche", 
		"Localisation des foyers tumoraux::Postérieur Droit", 
		"Localisation des foyers tumoraux::Postérieur Gauche", 
		"Localisation des foyers tumoraux::Apex", 
		"Localisation des foyers tumoraux::Base", 
		"Localisation des foyers tumoraux::Col vésical",	
		
		// Histology
	
		"Histologie::Adénocarcinome",
		"Histologie::Carcinome",
		"Histologie::Autre",
			
		// Tumoral volume
	
		"Volume tumoral total::Atteinte légère (<30%)",
		"Volume tumoral total::Atteinte modérée (30-60%)",
		"Volume tumoral total::Atteinte extensive (>60%)",

		// Histological grade	

		"Patron histologique::primaire (2 à 5)",
		"Patron histologique::secondaire (2 à 5)",
		"Patron histologique::Tertiaire (aucun; 2 à 5)",
		"Patron histologique::Score de Gleason",
			
		// Margins
		
		"Marges chirurgicales::Ne peuvent être évaluées",
		"Marges chirurgicales::Négatives",
		"Marges chirurgicales::Positives::Focale",
		"Marges chirurgicales::Positives::Extensive",
		"Marges chirurgicales::Positives::Score de Gleason aux marges",
			
		// Extra Prostatic Extension	
			
		"Extension extraprostatique::Absente",
		"Extension extraprostatique::prostate::Focale",
		"Extension extraprostatique::prostate::Établie",
		"Extension extraprostatique::vésicules séminales::Unilatérale",
		"Extension extraprostatique::vésicules séminales::Bilatérale",
		
		// Pathologic Staging		

		"Tumeur primaire::pT",
		"Ganglions lymphatiques / Adénopathies régionales::non récoltés",
		"Ganglions lymphatiques / Adénopathies régionales::récoltés, nombre examinés",
		"Ganglions lymphatiques / Adénopathies régionales::résultat de l'examen (cochez)",
		"Ganglions lymphatiques / Adénopathies régionales::Nombre atteints",
		"Métastases à distance"
	);
	foreach($path_report_excel_fields as $field_to_test) {
		$field_to_test = utf8_decode($field_to_test);
		if(array_key_exists($field_to_test, $m->values) && strlen($m->values[$field_to_test])) { $data_to_record = true; }
	}
	if(!$data_to_record) {
		Config::$summary_msg['Patho Report']['@@MESSAGE@@']['No patho data recorded'][] = "For partient '".$m->values['Code du Patient']."'. See line: ".$m->line;
		return false;
	}
	
	$m->values['event_control_id'] = Config::$event_controls['procure pathology report']['event_control_id'];
	$m->values['procure_form_identification'] = $m->values['Code du Patient']. ' V01 -PST1';
	
	$m->values['Nom du pathologiste'] = utf8_encode($m->values['Nom du pathologiste']);
	$m->values['Commentaires du pathologiste'] = utf8_encode($m->values['Commentaires du pathologiste']);
	
	$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("Date de relevé des données (jj/mm/aaaa)")], 'Patho Report', "Date de relevé des données (jj/mm/aaaa)", $m->line);
	if($tmp_event_date) {
		$m->values['event_date'] = $tmp_event_date['date'];
		$m->values['event_date_accuracy'] = $tmp_event_date['accuracy'];
	} else {
		$m->values['event_date'] = "''";
		$m->values['event_date_accuracy'] = "''";
	}
	
	// Dimensions
	
	$float_field_to_validate = array(	
		"Prostate::poids (g)",
		"Prostate::longueur (cm) Apex/Base",
		"Prostate::largeur (cm) latérale/latérale",
		"Prostate::épaisseur (cm) antéro-postérieur",
		"Vésicule séminale droite::longueur (cm)",
		"Vésicule séminale droite::largeur (cm)",
		"Vésicule séminale droite::épaisseur (cm)",
		"Vésicule séminale gauche::Longueur (cm)",
		"Vésicule séminale gauche::Largeur (cm)",
		"Vésicule séminale gauche::épaisseur (cm)");
	foreach($float_field_to_validate as $field_to_test) {
		$val_to_test = $m->values[utf8_decode($field_to_test)];
		if(strlen($val_to_test) && $val_to_test != 'non') {
			if(!preg_match('/^([0-9]+)([\.\,][0-9]+){0,1}$/', $val_to_test)) {
				Config::$summary_msg['Patho Report']['@@ERROR@@']['Wrong float value'][] = "Value '$val_to_test' for field '".utf8_encode($field_to_test)."' is not a float. See line: ".$m->line;
				$m->values[utf8_decode($field_to_test)] = '';
			}		
		} else {
			$m->values[utf8_decode($field_to_test)] = '';
		}
	}
	
	// Histology
	
	$m->values["histology"] = "";
	$m->values["histology_other_precision"] = "";
	$adenocarcinoma = $m->values[utf8_decode("Histologie::Adénocarcinome")];
	$carcinoma = $m->values["Histologie::Carcinome"];
	$other = $m->values["Histologie::Autre"];
	$val_count = 0 + (strlen($adenocarcinoma)? 1 : 0) + (strlen($carcinoma)? 1 : 0) + (strlen($other)? 1 : 0);
	if($val_count == 1) {
		$tmp_arr = array(
			"Adénocarcinome acinaire ou du type usuel" => "acinar adenocarcinoma/usual type",
			"Adénocarcinome canalaire" => "prostatic ductal adenocarcinoma",
			"Adénocarcinome mucineux" => "mucinous adenocarcinoma",
			"Carcinome à cellules indépendantes" => "signet-ring cell carcinoma",
			"Carcinome adénosquameux" => "adenosquamous carcinoma",
			"Carcinome à petites cellules" => "small cell carcinoma",
			"Carcinome sarcomatoïde" => "sarcomatoid carcinoma");
		if(strlen($other)) {
			$m->values["histology"] = "other specify";
			$m->values["histology_other_precision"] = utf8_encode($other);
		} else if($adenocarcinoma == 'x') {
			$m->values["histology"] = "acinar adenocarcinoma/usual type";
		} else if(isset($tmp_arr[utf8_encode($adenocarcinoma.$carcinoma)])) {
			$m->values["histology"] = $tmp_arr[utf8_encode($adenocarcinoma.$carcinoma)];
		} else {
			Config::$summary_msg['Patho Report']['@@ERROR@@']['Histology: unknown value'][] = "Histology value '$adenocarcinoma$carcinoma' is not supported. See line: ".$m->line;
		}
	} else if($val_count) {
		Config::$summary_msg['Patho Report']['@@ERROR@@']['Histology: more than one column completed'][] = "Only one value can be enter for histology fields. See line: ".$m->line;
	}
	
	// Tumoral volume
	
	$m->values["tumour_volume"] = "";
	$low_val = strtolower($m->values[utf8_decode("Volume tumoral total::Atteinte légère (<30%)")]);
	$moderate_val = strtolower($m->values[utf8_decode("Volume tumoral total::Atteinte modérée (30-60%)")]);
	$high_val = strtolower($m->values[utf8_decode("Volume tumoral total::Atteinte extensive (>60%)")]);
	if($low_val.$moderate_val.$high_val == 'x') {
		if($low_val) {
			$m->values["tumour_volume"] = "low";
		} else if($moderate_val) {
			$m->values["tumour_volume"] = "moderate";
		} else {
			$m->values["tumour_volume"] = "high";
		}
	} else if(strlen($low_val.$moderate_val.$high_val)) {
		Config::$summary_msg['Patho Report']['@@ERROR@@']['Tumoral volume'][] = "Either two values are set or cell value different than 'x'. See line: ".$m->line;
	}

	// Margins
	
	$m->values["margins"] = "";
	$m->values["margins_focal_or_extensive"] = "";
	$m->values["margins_extensive_anterior_left"] = "";
	$m->values["margins_extensive_anterior_right"] = "";
	$m->values["margins_extensive_posterior_left"] = "";
	$m->values["margins_extensive_posterior_right"] = "";
	$m->values["margins_extensive_apical_anterior_left"] = "";
	$m->values["margins_extensive_apical_anterior_right"] = "";
	$m->values["margins_extensive_apical_posterior_left"] = "";
	$m->values["margins_extensive_apical_posterior_right"] = "";
	$m->values["margins_extensive_bladder_neck"] = "";
	$m->values["margins_extensive_base"] = "";	
	$margin_not_assessed = strtolower($m->values[utf8_decode("Marges chirurgicales::Ne peuvent être évaluées")]);
	$margin_negative = strtolower($m->values[utf8_decode("Marges chirurgicales::Négatives")]);
	$margin_positive_focal = strtolower($m->values[utf8_decode("Marges chirurgicales::Positives::Focale")]);
	$margin_positive_extensive = strtolower($m->values[utf8_decode("Marges chirurgicales::Positives::Extensive")]);
	$margin_positive_gleason = $m->values[utf8_decode("Marges chirurgicales::Positives::Score de Gleason aux marges")];
	if(strlen($margin_positive_focal.$margin_positive_extensive.$margin_positive_gleason)) {
		$m->values["margins"] = 'positive';
		if(strlen($margin_positive_focal) && strlen($margin_positive_extensive)) {
			Config::$summary_msg['Patho Report']['@@ERROR@@']['Postive margin conflict (1)'][] = "Margin defined as both focal and not extensive. See line: ".$m->line;
		} else if(strlen($margin_positive_focal)) {
			if($margin_positive_focal != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']['Focal margin value'][] = "Focal margin value '$margin_positive_focal' different than 'x'. See line: ".$m->line;
			$m->values["margins_focal_or_extensive"] = 'focal';
		} else if(strlen($margin_positive_extensive)) {
			$m->values["margins_focal_or_extensive"] = 'extensive';
			$extensions = explode('+', $margin_positive_extensive);
			foreach($extensions as $new_site) {
				switch(utf8_encode($new_site)) {
					case 'ant gauche':
						$m->values["margins_extensive_anterior_left"] = "1";
						break;
					case 'ant droit':
						$m->values["margins_extensive_anterior_right"] = "1";
						break;
					case 'post gauche':
						$m->values["margins_extensive_posterior_left"] = "1";
						break;
					case 'post droit':
						$m->values["margins_extensive_posterior_right"] = "1";
						break;
					case 'apex ant gauche':
						$m->values["margins_extensive_apical_anterior_left"] = "1";
						break;
					case 'apex ant droit':
						$m->values["margins_extensive_apical_anterior_right"] = "1";
						break;
					case 'apex post gauche':
						$m->values["margins_extensive_apical_posterior_left"] = "1";
						break;
					case 'apex post droit':
						$m->values["margins_extensive_apical_posterior_right"] = "1";
						break;
					case 'col vésical':
						$m->values["margins_extensive_bladder_neck"] = "1";
						break;
					case 'base':
						$m->values["margins_extensive_base"] = "1";	
						break;
					default:
						Config::$summary_msg['Patho Report']['@@ERROR@@']['Extensive margin value'][] = "Positive extensive margin '$new_site' is not supported. See line: ".$m->line;
				}
			}
		}
		if(strlen($margin_negative.$margin_not_assessed)) Config::$summary_msg['Patho Report']['@@ERROR@@']['Postive margin conflict (2)'][] = "Margin defined as both positive and negtaive or not be assessed. See line: ".$m->line;
	} else if(strlen($margin_negative)) {
		if($margin_negative != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']['Negative margin value'][] = "Negative margin value '$margin_negative' different than 'x'. See line: ".$m->line;
		if(strlen($margin_not_assessed)) Config::$summary_msg['Patho Report']['@@ERROR@@']['Negative margin conflict'][] = "Margin defined as both negative and not be assessed. See line: ".$m->line;
		$m->values["margins"] = 'negative';		
	} else if(strlen($margin_not_assessed)) {
		if($margin_not_assessed != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']['Not assessable margin value'][] = "Not assessable margin value '$margin_not_assessed' different than 'x'. See line: ".$m->line;
		$m->values["margins"] = 'cannot be assessed';
	}
	$m->values["Marges chirurgicales::Positives::Score de Gleason aux marges"] = utf8_encode($m->values["Marges chirurgicales::Positives::Score de Gleason aux marges"]);
	
	// Histological grade
	
	$m->values["Patron histologique::Score de Gleason"] = utf8_encode($m->values["Patron histologique::Score de Gleason"]);
	
	// Extra Prostatic Extension

	$m->values["extra_prostatic_extension"] = "";
	$m->values["extra_prostatic_extension_precision"] = "";
	$m->values["extra_prostatic_extension_right_anterior"] = "";
	$m->values["extra_prostatic_extension_left_anterior"] = "";
	$m->values["extra_prostatic_extension_right_posterior"] = "";
	$m->values["extra_prostatic_extension_left_posterior"] = "";
	$m->values["extra_prostatic_extension_apex"] = "";
	$m->values["extra_prostatic_extension_base"] = "";
	$m->values["extra_prostatic_extension_bladder_neck"] = "";
	$m->values["extra_prostatic_extension_seminal_vesicles"] = "";
	$extra_prostatic_ext_absent = strtolower($m->values[utf8_decode("Extension extraprostatique::Absente")]);
	$extra_prostatic_ext_focal = strtolower($m->values[utf8_decode("Extension extraprostatique::prostate::Focale")]);
	$extra_prostatic_ext_established = strtolower($m->values[utf8_decode("Extension extraprostatique::prostate::Établie")]);
	$extra_prostatic_ext_seminal_vesic_1 = strtolower($m->values[utf8_decode("Extension extraprostatique::vésicules séminales::Unilatérale")]);
	$extra_prostatic_ext_seminal_vesic_2 = strtolower($m->values[utf8_decode("Extension extraprostatique::vésicules séminales::Bilatérale")]);
	if(strlen($extra_prostatic_ext_focal.$extra_prostatic_ext_established.$extra_prostatic_ext_seminal_vesic_1.$extra_prostatic_ext_seminal_vesic_2)) {
		$m->values["extra_prostatic_extension"] = "present";
		if(strlen($extra_prostatic_ext_absent)) Config::$summary_msg['Patho Report']['@@ERROR@@']['Extra prostatic extension conflict (1)'][] = "Extra prostatic extension defined as both absent and present. See line: ".$m->line;
		if(strlen($extra_prostatic_ext_focal)) {
			if(strlen($extra_prostatic_ext_established)) {
				Config::$summary_msg['Patho Report']['@@ERROR@@']['Extra prostatic extension conflict (2)'][] = "Extra prostatic extension defined as both established and focal. See line: ".$m->line;
			} else {
				$m->values["extra_prostatic_extension_precision"] = "focal";
			}
		} else if(strlen($extra_prostatic_ext_established)) {
			$m->values["extra_prostatic_extension_precision"] = "established";
		}
		//Localisation
		$localisations = explode('+', ($extra_prostatic_ext_focal.'+'.$extra_prostatic_ext_established));
		foreach($localisations as $new_site) {
			switch(utf8_encode($new_site)) {
				case '':
				case 'x':
					break;
				case 'ant droit':
					$m->values["extra_prostatic_extension_right_anterior"] = "1";
					break;
				case 'ant gauche':
					$m->values["extra_prostatic_extension_left_anterior"] = "1";
					break;
				case 'post droit':
					$m->values["extra_prostatic_extension_right_posterior"] = "1";
					break;
				case 'post gauche':
					$m->values["extra_prostatic_extension_left_posterior"] = "1";
					break;
				case 'apex':
					$m->values["extra_prostatic_extension_apex"] = "1";
					break;
				case 'base':
					$m->values["extra_prostatic_extension_base"] = "1";
					break;
				case 'col vésical':
					$m->values["extra_prostatic_extension_bladder_neck"] = "1";
					break;
				default:
					Config::$summary_msg['Patho Report']['@@ERROR@@']['Extra prostatic extension value'][] = "Extra prostatic extension value '$new_site' is not supported. See line: ".$m->line;
			}
		}
		if(strlen($extra_prostatic_ext_seminal_vesic_1) && strlen($extra_prostatic_ext_seminal_vesic_2)) {
			
		} else if(strlen($extra_prostatic_ext_seminal_vesic_1)) {
			$m->values["extra_prostatic_extension_seminal_vesicles"] = "unilateral";
			if($extra_prostatic_ext_seminal_vesic_1 != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']['Extra prostatic extension (seminal vesicles) value'][] = "Extra prostatic extension (seminal vesicles) value '$extra_prostatic_ext_seminal_vesic_1' is not supported. See line: ".$m->line;
		} else if(strlen($extra_prostatic_ext_seminal_vesic_2)) {
			$m->values["extra_prostatic_extension_seminal_vesicles"] = "bilateral";
			if($extra_prostatic_ext_seminal_vesic_2 != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']['Extra prostatic extension (seminal vesicles) value'][] = "Extra prostatic extension (seminal vesicles) value '$extra_prostatic_ext_seminal_vesic_2' is not supported. See line: ".$m->line;
		}
	} else if(strlen($extra_prostatic_ext_absent)) {
		if($extra_prostatic_ext_absent != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']['Extra prostatic extension absent value'][] = "Extra prostatic extension absent value '$extra_prostatic_ext_absent' different than 'x'. See line: ".$m->line;
		$m->values["extra_prostatic_extension"] = "absent";
	}
	
	// Pathologic Staging
	
	$m->values["Définition pTNM (version)"] = utf8_encode($m->values[utf8_decode("Définition pTNM (version)")]);
	$m->values["pathologic_staging_pn_collected"] = "";
	$m->values["pathologic_staging_pn_lymph_node_examined"] = "";
	$m->values["pathologic_staging_pn_lymph_node_involved"] = "";
	$pn_no_collected = strtolower($m->values[utf8_decode("Ganglions lymphatiques / Adénopathies régionales::non récoltés")]);
	$pn_examined = $m->values[utf8_decode("Ganglions lymphatiques / Adénopathies régionales::récoltés, nombre examinés")];
	$pn_involved = $m->values[utf8_decode("Ganglions lymphatiques / Adénopathies régionales::Nombre atteints")];
	if(strlen($pn_no_collected) && strlen($pn_examined.$pn_involved)) {
		Config::$summary_msg['Patho Report']['@@ERROR@@']['pTNM : Lymph node collection conflict'][] = "Lymph nodes have been defined both as not collected and collected. See line: ".$m->line;
	} else if(strlen($pn_no_collected)) {
		$m->values["pathologic_staging_pn_collected"] = "n";
		if($pn_no_collected != 'x') Config::$summary_msg['Patho Report']['@@WARNING@@']["pTNM : Lymph node 'not collected' value"][] = "The value '$pn_no_collected' for field 'Lymph node 'not collected' is different than 'x'. See line: ".$m->line;
	} else if(strlen($pn_examined.$pn_involved)) {
		$m->values["pathologic_staging_pn_collected"] = "y";
		if(!preg_match('/^[0-9]+$/', ($pn_examined.$pn_involved))) {
			Config::$summary_msg['Patho Report']['@@ERROR@@']['pTNM : Lymph nodes nbr'][] = "Either lymph nodes examined values '$pn_examined' or lymph nodes involved values '$pn_involved' is not numerical. See line: ".$m->line;
		} else {
			$m->values["pathologic_staging_pn_lymph_node_examined"] = $pn_examined;
			$m->values["pathologic_staging_pn_lymph_node_involved"] = $pn_involved;
		}	
	}
	
	return true;
}

function postPathReportWrite(Model $m){

}
