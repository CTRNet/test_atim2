<?php
require_once 'sardoToAtim.php';
SardoToAtim::$columns = array(
	"No de dossier"						=> 1,
    "Nom"								=> 2,
    "Prénom"							=> 3,
    "No banque de tissus"				=> 4,
    "No patient SARDO"					=> 5,
    "RAMQ"								=> 6,
    "Sexe"								=> 7,
    "Race"								=> 8,
    "Date de naissance"					=> 9,
    "Age actuel"						=> 10,
    "Date du diagnostic"				=> 11,
    "Age au diagnostic"					=> 12,
    "Antécédents familiaux ce cancer"	=> 13,
    "Ménopause"							=> 14,
    "Gravida Para Aborta"				=> 15,
    "No DX SARDO"						=> 16,
    "Diagnostic"						=> 17,
    "Latéralité"						=> 18,
    "Code topographique"				=> 19,
    "Topographie"						=> 20,
    "Code morphologique"				=> 21,
    "Morphologie"						=> 22,
    "TNM clinique"						=> 23,
    "TNM pT"							=> 24,
    "TNM pN"							=> 25,
    "TNM pM"							=> 26,
    "TNM pathologique"					=> 27,
    "TNM G"								=> 28,
    "BIOP+ 1 Tx00 - date"				=> 29,
    "BIOP+ 1 Tx00"						=> 30,
    "CHIR 1 Tx00 - date"				=> 31,
    "CHIR 1 Tx00"						=> 32,
    "CHIR 1 Tx00 - no patho"			=> 33,
    "Atteinte multicentrique"			=> 34,
    "Atteinte multifocale"				=> 35,
    "Ganglions régionaux"				=> 36,
    "Ganglions régionaux - prop"		=> 37,
    "Ganglions régionaux - sent"		=> 38,
    "Grade de Nottingham"				=> 39,
    "Grade histologique sur 3"			=> 40,
    "Grade nucléaire"					=> 41,
    "HER2NEU"							=> 42,
    "HER2NEU FISH"						=> 43,
    "HER2NEU Herceptest"				=> 44,
    "HER2NEU TAB 250"					=> 45,
    "Index mitotique"					=> 46,
    "Marges de résection"				=> 47,
    "Récepteurs oestrogènes"			=> 48,
    "Récepteurs progestatifs"			=> 49,
    "Récepteurs hormonaux"				=> 50,
    "Taille tumeur (mm)"				=> 51,
    "Taille tumeur (mm) - num"			=> 52,
    "CHIMIO néo-adjuvante Tx00"			=> 53,
    "CHIMIO adjuvante Tx00"				=> 54,
    "HORM néo-adjuvante Tx00"			=> 55,
    "HORM adjuvante Tx00"				=> 56,
    "RADIO néo-adjuvante Tx00"			=> 57,
    "RADIO adjuvante Tx00"				=> 58,
    "Pr00 - sites d'atteinte"			=> 59,
    "Pr01 - date"						=> 60,
    "Pr01 - sites"						=> 61,
    "Délai DX-Pr01 (M)"					=> 62,
    "Délai DX-Pr01 (J)"					=> 63,
    "Pr02 - date"						=> 64,
    "Pr02 - sites"						=> 65,
    "Délai Pr01-Pr02 (M)"				=> 66,
    "Délai Pr01-Pr02 (J)"				=> 67,
    "Pr03 - date"						=> 68,
    "Pr03 - sites"						=> 69,
    "Délai Pr02-Pr03 (M)"				=> 70,
    "Délai Pr02-Pr03 (J)"				=> 71,
    "Date dernier contact"				=> 72,
    "Censure (0 = vivant, 1 = mort)"	=> 73,
    "Survie (mois)"						=> 74,
    "Date du décès"						=> 75,
    "Cause de décès"					=> 76
);

SardoToAtim::$date_columns = array(
	'Date de naissance',
	'Date du diagnostic',
	'BIOP+ 1 Tx00 - date',
	'CHIR 1 Tx00 - date',
	'Pr01 - date',
	'Pr02 - date',
	'Pr03 - date',
	'Date dernier contact',
	'Date du décès'
);

$patho_fields = array(
	"Atteinte multicentrique",
    "Atteinte multifocale",
    "Ganglions régionaux",
    "Ganglions régionaux - prop",
    "Ganglions régionaux - sent",
    "Grade de Nottingham",
    "Grade histologique sur 3",
    "Grade nucléaire",
    "HER2NEU",
    "HER2NEU FISH",
    "HER2NEU Herceptest",
    "HER2NEU TAB 250",
    "Index mitotique",
    "Marges de résection",
    "Récepteurs oestrogènes",
    "Récepteurs progestatifs",
    "Récepteurs hormonaux",
    "Taille tumeur (mm)",
    "Taille tumeur (mm) - num"
);


SardoToAtim::$bank_identifier_ctrl_ids_column_name = 'No banque de tissus';
SardoToAtim::$hospital_identifier_ctrl_ids_column_name = 'No de dossier';

// $xls_reader->read('/Volumes/data/2011-11-15 Export complet sein.XLS');
// $xls_reader->read('/Volumes/data/2011-11-15 Export complet sein sample.XLS');
$xls_reader->read('/Volumes/data/2011-11-18 export sein recherche.XLS');
$cells = $xls_reader->sheets[0]['cells'];

SardoToAtim::basicChecks($cells);
reset($cells);
while($line = next($cells)){
	$line_number = key($cells);
	$dx_data = array(
		'master' => array(
			'participant_id'			=> $line['participant_id'],
			'qc_nd_sardo_id'			=> $line[SardoToAtim::$columns['No DX SARDO']],
			'diagnosis_control_id'		=> 19,
			'primary_id'				=> null,
			'parent_id'					=> null,
			'dx_date'					=> $line[SardoToAtim::$columns['Date du diagnostic']],
			'dx_date_accuracy'			=> $line['Date du diagnostic_accuracy'],
			'dx_nature'					=> $line[SardoToAtim::$columns['Diagnostic']],
			'icd10_code'				=> str_replace('.', '', $line[SardoToAtim::$columns['Code topographique']]),
			'qc_nd_sardo_morpho_code'	=> $line[SardoToAtim::$columns['Code morphologique']],
			'clinical_stage_summary'	=> $line[SardoToAtim::$columns['TNM clinique']],
			'path_tstage'				=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'				=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'				=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'		=> $line[SardoToAtim::$columns['TNM pathologique']],
			'survival_time_months'		=> $line[SardoToAtim::$columns['Survie (mois)']],
			'qc_nd_sardo_family_history'=> $line[SardoToAtim::$columns['Antécédents familiaux ce cancer']],
		), 'detail' => array(
			'laterality'				=> $line[SardoToAtim::$columns['Latéralité']],
			'tnm_g'						=> $line[SardoToAtim::$columns['TNM G']]
		)
	);
	$dx_id = SardoToAtim::update(Models::DIAGNOSIS_MASTER, $dx_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_id')));
	$morpho_value = $line[SardoToAtim::$columns['Code morphologique']].' - '.$line[SardoToAtim::$columns['Morphologie']];
	if(array_key_exists($line[SardoToAtim::$columns['Code morphologique']], SardoToAtim::$morpho_codes)){
		if(SardoToAtim::$morpho_codes[$line[SardoToAtim::$columns['Code morphologique']]] != $morpho_value){
			SardoToAtim::$commit = false;
			printf("ERROR: Different definitions found for morpho code [%s] [%s] [%s]\n", $line[SardoToAtim::$columns['Code morphologique']], SardoToAtim::$morpho_codes[$line[SardoToAtim::$columns['Code morphologique']]], $morpho_value);
		}
	}else{
		SardoToAtim::$morpho_codes[$line[SardoToAtim::$columns['Code morphologique']]] = $morpho_value; 
	}
	
	if($line[SardoToAtim::$columns['BIOP+ 1 Tx00 - date']]){
		$biopsy = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 28,
				'event_date'			=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00 - date']],
				'event_date_accuracy'	=> $line['BIOP+ 1 Tx00 - date_accuracy'],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'type'					=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00']]
			)
		);
		SardoToAtim::update(Models::EVENT_MASTER, $biopsy, $line_number);
	}
	
	if($line[SardoToAtim::$columns['CHIR 1 Tx00']]){
		$surgery = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 4,
				'start_date'			=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - date']],
				'start_date_accuracy'	=> $line['CHIR 1 Tx00 - date_accuracy'],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'qc_nd_precision'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00']]
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $surgery, $line_number);
	}
	
	$insert_patho = false;
	foreach($patho_fields as $patho_field){
		if(!empty($line[SardoToAtim::$columns[$patho_field]])){
			$insert_patho = true;
			break;
		}
	}
	if($insert_patho){
		$patho = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 31,
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'atteinte_multicentrique'		=> $line[SardoToAtim::$columns['Atteinte multicentrique']],
				'atteinte_multifocale'			=> $line[SardoToAtim::$columns['Atteinte multifocale']],
				'ganglions_regionaux'			=> $line[SardoToAtim::$columns['Ganglions régionaux']],
				'ganglions_regionaux_prop'		=> $line[SardoToAtim::$columns['Ganglions régionaux - prop']],
				'ganglions_regionaux_sent'		=> $line[SardoToAtim::$columns['Ganglions régionaux - sent']],
				'grade_nottingham'				=> $line[SardoToAtim::$columns['Grade de Nottingham']],
				'grade_histologique_sur_3'		=> $line[SardoToAtim::$columns['Grade histologique sur 3']],
				'grade_nucleaire'				=> $line[SardoToAtim::$columns['Grade nucléaire']],
				'her2neu'						=> $line[SardoToAtim::$columns['HER2NEU']],
				'her2neu_fish'					=> $line[SardoToAtim::$columns['HER2NEU FISH']],
				'her2neu_herceptest'			=> $line[SardoToAtim::$columns['HER2NEU Herceptest']],
				'her2neu_tab_250'				=> $line[SardoToAtim::$columns['HER2NEU TAB 250']],
				'index_miotique'				=> $line[SardoToAtim::$columns['Index mitotique']],
				'marges_resection'				=> $line[SardoToAtim::$columns['Marges de résection']],
				'recepteur_oestrogene'			=> $line[SardoToAtim::$columns['Récepteurs oestrogènes']],
				'recepteur_progestatifs'		=> $line[SardoToAtim::$columns['Récepteurs progestatifs']],
				'recepteur_hormonaux'			=> $line[SardoToAtim::$columns['Récepteurs hormonaux']],
				'taille_tumeur_mm'				=> $line[SardoToAtim::$columns['Taille tumeur (mm)']],
				'taile_tummeur_mm_num'			=> $line[SardoToAtim::$columns['Taille tumeur (mm) - num']]
			)
		);
		
		SardoToAtim::update(Models::EVENT_MASTER, $patho, $line_number, 'participant_id', array('master' => array('event_control_id', 'diagnosis_master_id')));
	}
	
	if($line[SardoToAtim::$columns['CHIMIO néo-adjuvante Tx00']]){
		$chemo = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 1,
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'qc_nd_type'			=> $line[SardoToAtim::$columns['CHIMIO néo-adjuvante Tx00']],
				'qc_nd_is_neoadjuvant'	=> 'y',
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $chemo, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id'), 'detail' => array('qc_nd_is_neoadjuvant')));
	}
	
	if($line[SardoToAtim::$columns['CHIMIO adjuvante Tx00']]){
		$chemo = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 1,
				'diagnosis_master_id'	=> $dx_id
		), 'detail' => array(
				'qc_nd_type'			=> $line[SardoToAtim::$columns['CHIMIO adjuvante Tx00']],
				'qc_nd_is_neoadjuvant'	=> 'n',
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $chemo, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id'), 'detail' => array('qc_nd_is_neoadjuvant')));
	}

	if($line[SardoToAtim::$columns['HORM néo-adjuvante Tx00']]){
		$hormono = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 5,
				'diagnosis_master_id'	=> $dx_id
		), 'detail' => array(
				'type'			=> $line[SardoToAtim::$columns['HORM adjuvante Tx00']],
				'is_neoadjuvant'	=> 'y',
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $hormono, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id'), 'detail' => array('is_neoadjuvant')));
	}

	if($line[SardoToAtim::$columns['HORM adjuvante Tx00']]){
		$hormono = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 5,
				'diagnosis_master_id'	=> $dx_id
		), 'detail' => array(
				'type'			=> $line[SardoToAtim::$columns['HORM adjuvante Tx00']],
				'is_neoadjuvant'	=> 'n',
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $hormono, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id'), 'detail' => array('is_neoadjuvant')));
	}

	if($line[SardoToAtim::$columns['RADIO néo-adjuvante Tx00']]){
		$radio = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 2,
				'diagnosis_master_id'	=> $dx_id
		), 'detail' => array(
				'qc_nd_type'			=> $line[SardoToAtim::$columns['RADIO néo-adjuvante Tx00']],
				'qc_nd_is_neoadjuvant'	=> 'y',
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $radio, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id'), 'detail' => array('qc_nd_is_neoadjuvant')));
	}
	
	if($line[SardoToAtim::$columns['RADIO adjuvante Tx00']]){
		$radio = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 2,
				'diagnosis_master_id'	=> $dx_id
		), 'detail' => array(
				'qc_nd_type'			=> $line[SardoToAtim::$columns['RADIO adjuvante Tx00']],
				'qc_nd_is_neoadjuvant'	=> 'n',
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $radio, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id'), 'detail' => array('qc_nd_is_neoadjuvant')));
	}
	
	foreach(range(1, 3) as $progression_count){
		$site_key = sprintf('Pr%02d - sites', $progression_count);
		if($line[SardoToAtim::$columns[$site_key]]){
			$date_key = sprintf('Pr%02d - date', $progression_count);
			$progression = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'diagnosis_control_id'	=> 17,
					'parent_id'				=> $dx_id,
					'dx_date'				=> $line[SardoToAtim::$columns[$date_key]],
					'dx_date_accuracy'		=> $line[$date_ket.'_accuracy']
				), 'detail' => array(
					'qc_nd_sites'			=> $line[SardoToAtim::$columns[$site_key]]
				)
			);
			SardoToAtim::update(Models::DIAGNOSIS_MASTER, $progression, $line_number);
		}
	}
	
	$converted_menopause = sardoToAtim::convertMenopause($line[SardoToAtim::$columns['Ménopause']]);
	if($converted_menopause['status']){
		$menopause = array(
			'master' => array(
				'participant_id'			=> $line['participant_id'],
				'menopause_status'			=> $converted_menopause['status'],
				'qc_nd_cause'				=> $converted_menopause['cause'],
				'qc_nd_gravida_para_aborta' => $converted_menopause['Gravida Para Aborta']
			)
		);
		SardoToAtim::update(Models::REPRODUCTIVE_HISTORY, null, $menopause, $line_number);
	}
}

SardoToAtim::endChecks();