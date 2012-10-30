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
	"margins_gleason_score" => utf8_decode("Marges chirurgicales::Positives::Score de Gleason aux marges")
		


	/*		





extra_prostatic_extension	 ===>	"Extension extraprostatique::Absente
Extension extraprostatique::prostate::Focale (surface < 40x un champ/une seule Ant gaucheme)
Extension extraprostatique::prostate::Établie (cochez Ant gauche ou les zones)"
extra_prostatic_extension_precision	 ===>	"Extension extraprostatique::prostate::Focale (surface < 40x un champ/une seule Ant gaucheme)
Extension extraprostatique::prostate::Établie (cochez Ant gauche ou les zones)"
extra_prostatic_extension_right_anterior	 ===>	
extra_prostatic_extension_left_anterior	 ===>	
extra_prostatic_extension_right_posterior	 ===>	
extra_prostatic_extension_left_posterior	 ===>	
extra_prostatic_extension_apex	 ===>	
extra_prostatic_extension_base	 ===>	
extra_prostatic_extension_bladder_neck	 ===>	
extra_prostatic_extension_seminal_vesicles	 ===>	


pathologic_staging_version	 ===>	Définition pTNM (version)
pathologic_staging_pt	 ===>	Tumeur primaire::pT
pathologic_staging_pn_collected	 ===>	"Ganglions lymphatiques / Adénopathies régionales::non récoltés 
Ganglions lymphatiques / Adénopathies régionales::récoltés, nombre examinés"
pathologic_staging_pn	 ===>	Ganglions lymphatiques / Adénopathies régionales::résultat de l'examen (cochez)
pathologic_staging_pn_lymph_node_examined	 ===>	Ganglions lymphatiques / Adénopathies régionales::récoltés, nombre examinés
pathologic_staging_pn_lymph_node_involved	 ===>	Ganglions lymphatiques / Adénopathies régionales::Nombre atteints
pathologic_staging_pm	 ===>	Métastases à distance
		
		
	*/	

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
		"Nom du pathologiste",
		
		// Dimensions
		
		"Prostate::poids (g)", "Prostate::longueur (cm) Apex/Base", 
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
			
		// Margins
		
		"Marges chirurgicales::Ne peuvent être évaluées",
		"Marges chirurgicales::Négatives",
		"Marges chirurgicales::Positives::Focale (encre ≤ 3mm/une seule Ant gaucheme)",
		"Marges chirurgicales::Positives::Extensive (cochez Ant gauche ou les zones)",
		"Marges chirurgicales::Positives::Score de Gleason aux marges"
			
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
	
	$margin_not_assessed = $m->values[utf8_decode("Marges chirurgicales::Ne peuvent être évaluées")];
	$margin_negative = $m->values[utf8_decode("Marges chirurgicales::Négatives")];
	
	$margin_positive_focal = $m->values[utf8_decode("Marges chirurgicales::Positives::Focale (encre ≤ 3mm/une seule Ant gaucheme)")];
	$margin_positive_extensive = $m->values[utf8_decode("Marges chirurgicales::Positives::Extensive (cochez Ant gauche ou les zones)")];
	$margin_positive_gleason = $m->values[utf8_decode("Marges chirurgicales::Positives::Score de Gleason aux marges")];
	 
	
	

	// Margins
	
	
	
	<option value="cannot be assessed">Ne peuvent être évaluées</option>
	<option value="negative">Négatif</option>
	<option value="positive">Positif</option>
	
	<option value="focal">Focale:cancer touchant l'encre (=&lt;3mm) dans une lame seulement</option>
	<option value="extensive">Extensive</option>
	
	
	
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
	

	

	
	return true;
}

function postPathReportWrite(Model $m){

}
