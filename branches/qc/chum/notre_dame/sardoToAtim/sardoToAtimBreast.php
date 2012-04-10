<?php
require_once 'sardoToAtim.php';
SardoToAtim::$columns = array(
	1 => "No de dossier",
    "Nom",
    "Prénom",
    "No banque de tissus",
    "No patient SARDO",
    "RAMQ",
    "Sexe",
    "Race",
    "Date de naissance",
    "Age actuel",
    "Date du diagnostic",
    "Age au diagnostic",
    "Antécédents familiaux ce cancer",
    "Ménopause",
    "Gravida Para Aborta",
    "No DX SARDO",
    "Diagnostic",
    "Latéralité",
    "Code topographique",
    "Topographie",
    "Code morphologique",
    "Morphologie",
    "TNM clinique",
    "TNM pT",
    "TNM pN",
    "TNM pM",
    "TNM pathologique",
    "TNM G",
    "BIOP+ 1 Tx00 - date",
    "BIOP+ 1 Tx00",
    "CHIR 1 Tx00 - date",
    "CHIR 1 Tx00",
    "CHIR 1 Tx00 - no patho",
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
    "Taille tumeur (mm) - num",
    "CHIMIO néo-adjuvante Tx00",
    "CHIMIO adjuvante Tx00",
    "HORM néo-adjuvante Tx00",
    "HORM adjuvante Tx00",
    "RADIO néo-adjuvante Tx00",
    "RADIO adjuvante Tx00",
    "Pr00 - sites d'atteinte",//TODO: Import into ATiM power tapiss
    "Pr01 - date",
    "Pr01 - sites",
    "Délai DX-Pr01 (M)",
    "Délai DX-Pr01 (J)",
    "Pr02 - date",
    "Pr02 - sites",
    "Délai Pr01-Pr02 (M)",
    "Délai Pr01-Pr02 (J)",
    "Pr03 - date",
    "Pr03 - sites",
    "Délai Pr02-Pr03 (M)",
    "Délai Pr02-Pr03 (J)",
    "Date dernier contact",
    "Censure (0 = vivant, 1 = mort)",
    "Survie (mois)",
    "Date du décès",
    "Cause de décès"
);
SardoToAtim::$columns = array_flip(SardoToAtim::$columns);

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

if(count($argv) > 1){
	$xls_reader->read($argv[1]);
}else{
	// $xls_reader->read('/Volumes/data/sein_crchum.xls');
	$xls_reader->read('/Volumes/data/sein_chum.xls');
}
$cells = $xls_reader->sheets[0]['cells'];

SardoToAtim::basicChecks($cells);
reset($cells);
while($line = next($cells)){
	$line_number = key($cells);
	$icd10 = str_replace('.', '', $line[SardoToAtim::$columns['Code topographique']]);
	$morpho = str_replace('/', '', $line[SardoToAtim::$columns['Code morphologique']]);
	SardoToAtim::icd10Update($icd10, $line[SardoToAtim::$columns['Latéralité']]);
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
			'icd10_code'				=> $icd10,
			'morphology'				=> $morpho,
			'clinical_stage_summary'	=> $line[SardoToAtim::$columns['TNM clinique']],
			'path_tstage'				=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'				=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'				=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'		=> $line[SardoToAtim::$columns['TNM pathologique']]
		), 'detail' => array(
			'laterality'				=> $line[SardoToAtim::$columns['Latéralité']],
			'tnm_g'						=> $line[SardoToAtim::$columns['TNM G']]
		)
	);
	$dx_id = SardoToAtim::update(Models::DIAGNOSIS_MASTER, $dx_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_id')));
	
	if($line[SardoToAtim::$columns['Antécédents familiaux ce cancer']] == 'Oui'){
		$fam_hist_data = array(
			'participant_id'		=> $line['participant_id'],
			'sardo_diagnosis_id'	=> $line[SardoToAtim::$columns['No DX SARDO']],
			'qc_nd_sardo_type'		=> 'breast cancer'
		);
		SardoToAtim::update(Models::FAMILY_HISTORY, $fam_hist_data, $line_number, 'participant_id');
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
					'dx_date_accuracy'		=> $line[$date_key.'_accuracy']
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
				'gravida'					=> substr($line[SardoToAtim::$columns['Gravida Para Aborta']], 1, 2),
				'para'						=> substr($line[SardoToAtim::$columns['Gravida Para Aborta']], 5, 2),
				'qc_nd_aborta'				=> substr($line[SardoToAtim::$columns['Gravida Para Aborta']], 9, 2)
			)
		);
		SardoToAtim::update(Models::REPRODUCTIVE_HISTORY, $menopause, $line_number);
	}
}

SardoToAtim::endChecks();