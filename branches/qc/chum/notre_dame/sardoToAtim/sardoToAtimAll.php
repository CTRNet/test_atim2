<?php
require_once 'sardoToAtim.php';
SardoToAtim::$columns = array(
	1 => "Nom",
	"Prénom",
	"No de dossier",
	"RAMQ",
	"Sexe",
	"No banque de tissus",
	"No patient SARDO",
	"Date de naissance",
	"Age actuel",//ignore
	"Race",
	"Fanions",//ignore
	"Diagnostic",
	"Latéralité",
	"Date du diagnostic",
	"Age au diagnostic",
	"Antécédents familiaux de cancer",
	"Antécédents familiaux ce cancer",
	"Code topographique",
	"Topographie",//ignore (on a le code dans "Code topographie")
	"Code morphologique",
	"Morphologie",//ignore (on a le code dans)
	"No DX SARDO",
	"Ménopause",
	"Année ménopause",
	"Gravida Para Aborta",
	"TNM T",
	"TNM N",
	"TNM M",
	"TNM clinique",
	"TNM pT",
	"TNM pN",
	"TNM pM",
	"TNM pathologique",
	"TNM G",
	"FIGO",
	"Pr00 - sites d'atteinte",
	"BIOP+ 1 Tx00",
	"BIOP+ 1 Tx00 - date",
	"BIOP+ 1 Tx00 - no patho",
	"BIOP+ 1 Tx00 - lieu",
	"CYTO+ 1 Tx00",
	"CYTO+ 1 Tx00 - date",
	"CYTO+ 1 Tx00 - no patho",
	"CYTO+ 1 Tx00 - lieu",
	"CHIR 1 Tx00",
	"CHIR 1 Tx00 - date",
	"CHIR 1 Tx00 - no patho",
	"CHIR 1 Tx00 - lieu",
	"CHIMIO néo-adjuvante Tx00",
	"CHIMIO adjuvante Tx00",
	"HORM néo-adjuvante Tx00",
	"HORM adjuvante Tx00",
	"RADIO néo-adjuvante Tx00",
	"RADIO adjuvante Tx00",
	"Séquence Tx00",//ignore
	"TX 1 Tx00",
	"TX 1 Tx00 - début",
	"TX 1 Tx00 - fin",
	"TX 2 Tx00",
	"TX 2 Tx00 - début",
	"TX 2 Tx00 - fin",
	"TX 3 Tx00",
	"TX 3 Tx00 - début",
	"TX 3 Tx00 - fin",
	"TX 4 Tx00",
	"TX 4 Tx00 - début",
	"TX 4 Tx00 - fin",
	"TX 5 Tx00",
	"TX 5 Tx00 - début",
	"TX 5 Tx00 - fin",
	"TX 6 Tx00",
	"TX 6 Tx00 - début",
	"TX 6 Tx00 - fin",
	"Toute CHIR Tx00 + patho",//TODO: doublon de CHIR 1 Tx00 et CHIR 1 Tx00 - no patho
	"Atteinte multicentrique",
	"Atteinte multifocale",
	"Atypie cellulaire",
	"Atypie cellulaire - blocs",
	"Cancer",
	"Cancer - prop",
	"Cancer - blocs",
	"Ganglions régionaux",
	"Ganglions régionaux - prop",
	"Gleason - num",
	"Gleason",
	"Grade de Nottingham",
	"Grade histologique sur 3",
	"Grade nucléaire",
	"HER2NEU",
	"HER2NEU FISH",
	"HER2NEU Herceptest",
	"HER2NEU TAB 250",
	"Hyperplasie (BPH)",
	"Hyperplasie (BPH) - blocs",
	"Index mitotique",
	"Infiltration périneurale",
	"Invasion extra-capsulaire",
	"Invasion lymph. vasc.",
	"Maladie résiduelle",
	"Marges de résection",
	"Marges de résection - blocs",
	"Marges résection urètre",
	"Marges résection urètre - blocs",
	"Ovaire droit - blocs",
	"Ovaire gauche - blocs",
	"PIN 1",
	"PIN 1 - blocs",
	"PIN 2 3",
	"PIN 2 3 - blocs",
	"Poids prostate - num",
	"Prostatite",
	"Prostatite - blocs",
	"Récepteurs oestrogènes",
	"Récepteurs progestatifs",
	"Récepteurs hormonaux",
	"Taille tumeur (mm)",
	"Taille tumeur (mm) - num",
	"Vés. séminales atteintes",
	"Dernier APS - date",
	"Dernier APS",
	"APS préCHIR Tx00 - date",
	"APS préCHIR Tx00",
	"Délai CHIR-dernier APS (M",//ignore
	"Délai CHIR-dernier APS (J",//ignore
	"CA-125 péri-DX - date",
	"CA-125 péri-DX",
	"Dernier CA-125 - date",
	"Dernier CA-125",
	"CA-125 préCHIR Tx00 - dat",
	"CA-125 préCHIR Tx00",
	"Pr01 - date",
	"Pr01 - sites",
	"Délai DX-Pr01 (M)",//ignore
	"Délai DX-Pr01 (J)",//ignore
	"Pr02 - date",
	"Pr02 - sites",
	"Délai DX-Pr02 (M)",//ignore
	"Délai DX-Pr02 (J)",//ignore
	"Pr03 - date",
	"Pr03 - sites",
	"Délai DX-Pr03 (M)",//ignore
	"Délai DX-Pr03 (J)",//ignore
	"Date dernier contact",
	"Date du décès",
	"Cause de décès",
	"Censure (0 = vivant, 1 = mort)",//ignore
	"Survie (mois)"//ignore
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
		'Date du décès',
		'CYTO+ 1 Tx00 - date',
		'CA-125 péri-DX - date',
		'CA-125 préCHIR Tx00 - dat',
		'Dernier CA-125 - date',
		'APS préCHIR Tx00 - date',
		'Dernier APS - date',
		'TX 1 Tx00 - début',
		'TX 1 Tx00 - fin',
		'TX 2 Tx00 - début',
		'TX 2 Tx00 - fin',
		'TX 3 Tx00 - début',
		'TX 3 Tx00 - fin',
		'TX 4 Tx00 - début',
		'TX 4 Tx00 - fin',
		'TX 5 Tx00 - début',
		'TX 5 Tx00 - fin',
		'TX 6 Tx00 - début',
		'TX 6 Tx00 - fin'
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

$tx_detail_precision = array(
		4	=> 'qc_nd_precision',
		5	=> 'type',
		6	=> 'type'
);

SardoToAtim::$bank_identifier_ctrl_ids_column_name = 'No banque de tissus';
SardoToAtim::$hospital_identifier_ctrl_ids_column_name = 'No de dossier';

if(count($argv) > 1){
	$xls_reader->read($argv[1]);
}else{
	$xls_reader->read('/Volumes/data/sample.xls');
// 	$xls_reader->read('/Volumes/data/2012-04-13 Sommaire Banque de tumeurs CR-CHUM.XLS');
// 	$xls_reader->read('/Volumes/data/2012-04-19 Sommaire banque de tumeurs CHUM.xls');
}
$cells = $xls_reader->sheets[0]['cells'];
SardoToAtim::basicChecks($cells);
reset($cells);
$participant_validation_only = false;//CONFIG VAR
$last_bank_num = null;
$last_id_num = null;
$cols_width = count($cells[1]);
while($line = next($cells)){
	$line_number = key($cells);
	
	//path empty fields
	for($i = 1; $i <= $cols_width; ++$i){
		if(!isset($line[$i])){
			$line[$i] = "";
		}
	}
	
	if($line[SardoToAtim::$columns['No banque de tissus']]){
		$last_bank_num = $line[SardoToAtim::$columns['No banque de tissus']];
	}else if($last_id_num == $line[SardoToAtim::$columns['No de dossier']]){
		$line[SardoToAtim::$columns['No banque de tissus']] = $last_bank_num;
	}else{
		printf("ERROR: Participant without a bank number at line [".$line_number."]\n");
		SardoToAtim::$commit = false;
	}
	
	if(!SardoToAtim::initLine($line, $line_number)){
		if(!$participant_validation_only){
			die('Participant validation failed');
		}
	}
	$last_id_num = $line[SardoToATim::$columns['No de dossier']];
	
	if($participant_validation_only){
		unset($line);
		continue;
	}
	$treatments = array();//for surgeries, chemos, hormonos, radios, TODO
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
			'clinical_tstage'			=> $line[SardoToAtim::$columns['TNM T']],
			'clinical_nstage'			=> $line[SardoToAtim::$columns['TNM N']],
			'clinical_mstage'			=> $line[SardoToAtim::$columns['TNM M']],
			'clinical_stage_summary'	=> $line[SardoToAtim::$columns['TNM clinique']],
			'path_tstage'				=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'				=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'				=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'		=> $line[SardoToAtim::$columns['TNM pathologique']]
		), 'detail' => array(
			'laterality'				=> $line[SardoToAtim::$columns['Latéralité']],
			'tnm_g'						=> $line[SardoToAtim::$columns['TNM G']],
			'figo'						=> $line[SardoToAtim::$columns['FIGO']]
		)
	);
	$dx_id = SardoToAtim::update(Models::DIAGNOSIS_MASTER, $dx_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_id')));
	
	
	if($line[SardoToAtim::$columns['Antécédents familiaux ce cancer']] == 'Oui'){
		$fam_hist_data = array(
			'participant_id'		=> $line['participant_id'],
			'qc_nd_sardo_diagnosis_id'	=> $line[SardoToAtim::$columns['No DX SARDO']],
			'primary_icd10_code'	=> $icd10
		);
		SardoToAtim::update(Models::FAMILY_HISTORY, $fam_hist_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_diagnosis_id', 'primary_icd10_code')));
	}
	if($line[SardoToAtim::$columns['Antécédents familiaux de cancer']] == 'Oui'){
		$fam_hist_data = array(
			'participant_id'		=> $line['participant_id'],
			'qc_nd_sardo_diagnosis_id'	=> $line[SardoToAtim::$columns['No DX SARDO']],
			'primary_icd10_code'	=> 'C809'
		);
		SardoToAtim::update(Models::FAMILY_HISTORY, $fam_hist_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_diagnosis_id', 'primary_icd10_code')));
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
				'type'					=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00']],
				'no_patho'				=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00 - no patho']],
				'location'				=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00 - lieu']],
			)
		);
		SardoToAtim::update(Models::EVENT_MASTER, $biopsy, $line_number);
		
		
		
		if($line[SardoToAtim::$columns['CHIR 1 Tx00']]){
			$surgery_conf = SardoToAtim::getSurgeryConfig($line[SardoToAtim::$columns['CHIR 1 Tx00']]);
			$tx_ctrl_id = null;
			switch($surgery_conf['site']){
				case 'Ovaire':
					$tx_ctrl_id = 7;
					break;
				case 'Prostate':
					$tx_ctrl_id = 8;
					break;
				case 'Sein':
					$tx_ctrl_id = 9;
					break;
				default:
					$tx_ctrl_id = 4;
			}
			$surgery = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'treatment_control_id'	=> $tx_ctrl_id,
					'start_date'			=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - date']],
					'start_date_accuracy'	=> $line['CHIR 1 Tx00 - date_accuracy'],
					'diagnosis_master_id'	=> $dx_id,
					'facility'				=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - lieu']],
				), 'detail' => array(
					'qc_nd_precision'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00']],
					'path_num'				=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - no patho']],
					'qc_nd_residual_disease'=> $line[SardoToAtim::$columns['Maladie résiduelle']],
					'qc_nd_laterality'		=> $surgery_conf['laterality'],
					'qc_nd_type'			=> $surgery_conf['m_type'],
					'qc_nd_method'			=> $surgery_conf['method']
				)
			);
			SardoToAtim::update(Models::TREATMENT_MASTER, $surgery, $line_number, 'participant_id', array('master' => array('diagnosis_master_id'), 'detail' => array('qc_nd_precision')));
			
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
					'diagnosis_master_id'	=> $dx_id,
					'tx_intent'				=> 'neoadjuvant'
				), 'detail' => array(
					'qc_nd_type'			=> $line[SardoToAtim::$columns['CHIMIO néo-adjuvante Tx00']]
				)
			);
		
			SardoToAtim::update(Models::TREATMENT_MASTER, $chemo, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id', 'tx_intent')));
		}
		
		if($line[SardoToAtim::$columns['CHIMIO adjuvante Tx00']]){
			$chemo = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'treatment_control_id'	=> 1,
					'diagnosis_master_id'	=> $dx_id,
					'tx_intent'				=> 'adjuvant'
				), 'detail' => array(
					'qc_nd_type'			=> $line[SardoToAtim::$columns['CHIMIO adjuvante Tx00']]
				)
			);
		
			SardoToAtim::update(Models::TREATMENT_MASTER, $chemo, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id', 'tx_intent')));
		}
		
		
		if($line[SardoToAtim::$columns['HORM néo-adjuvante Tx00']]){
			$types = explode(',', $line[SardoToAtim::$columns['HORM adjuvante Tx00']]);
			foreach($types as $type){
				$hormono = array(
					'master' => array(
						'participant_id'		=> $line['participant_id'],
						'treatment_control_id'	=> 5,
						'diagnosis_master_id'	=> $dx_id,
						'tx_intent'				=> 'neoadjuvant'
					), 'detail' => array(
						'type'				=> trim($type)
					)
				);
		
				SardoToAtim::update(Models::TREATMENT_MASTER, $hormono, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id', 'tx_intent')));
			}
		}
		
		if($line[SardoToAtim::$columns['HORM adjuvante Tx00']]){
			$types = explode(',', $line[SardoToAtim::$columns['HORM adjuvante Tx00']]);
			foreach($types as $type){
				$hormono = array(
					'master' => array(
						'participant_id'		=> $line['participant_id'],
						'treatment_control_id'	=> 5,
						'diagnosis_master_id'	=> $dx_id,
						'tx_intent'				=> 'adjuvant'
					), 'detail' => array(
						'type'				=> trim($type)
					)
				);
		
				SardoToAtim::update(Models::TREATMENT_MASTER, $hormono, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id', 'tx_intent')));
			}
		}
		
		if($line[SardoToAtim::$columns['RADIO néo-adjuvante Tx00']]){
			$radio = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'treatment_control_id'	=> 2,
					'diagnosis_master_id'	=> $dx_id,
					'tx_intent'				=> 'neoadjuvant'
				), 'detail' => array(
					'qc_nd_type'			=> $line[SardoToAtim::$columns['RADIO néo-adjuvante Tx00']]
				)
			);
		
			SardoToAtim::update(Models::TREATMENT_MASTER, $radio, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id', 'tx_intent')));
		}
		
		if($line[SardoToAtim::$columns['RADIO adjuvante Tx00']]){
			$radio = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'treatment_control_id'	=> 2,
					'diagnosis_master_id'	=> $dx_id,
					'tx_intent'				=> 'adjuvant'
				), 'detail' => array(
					'qc_nd_type'			=> $line[SardoToAtim::$columns['RADIO adjuvante Tx00']],
				)
			);
		
			SardoToAtim::update(Models::TREATMENT_MASTER, $radio, $line_number, 'participant_id', array('master' => array('treatment_control_id', 'diagnosis_master_id', 'tx_intent')));
		}
		
		foreach(range(1, 3) as $progression_count){
			$site_key = sprintf('Pr%02d - sites', $progression_count);
			if($line[SardoToAtim::$columns[$site_key]]){
				$key = sprintf('Pr%02d', $progression_count);
				$date_key = $key.' - date';
				foreach(explode(',', $line[SardoToAtim::$columns[$site_key]]) as $site){
					$site = trim($site);
					if($site){
						$progression = array(
							'master' => array(
								'participant_id'		=> $line['participant_id'],
								'diagnosis_control_id'	=> 17,
								'parent_id'				=> $dx_id,
								'dx_date'				=> $line[SardoToAtim::$columns[$date_key]],
								'dx_date_accuracy'		=> $line[$date_key.'_accuracy'],
								'primary_id'			=> $dx_id,
							), 'detail' => array(
								'qc_nd_site'			=> $line[SardoToAtim::$columns[$site_key]],
								'qc_nd_initial'			=> 'n'
							)
						);
						SardoToAtim::update(Models::DIAGNOSIS_MASTER, $progression, $line_number, 'participant_id', array('master' => array('participant_id', 'diagnosis_control_id', 'parent_id'), 'detail' => array('qc_nd_initial', 'qc_nd_site')));
					}
				}
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
					'qc_nd_aborta'				=> substr($line[SardoToAtim::$columns['Gravida Para Aborta']], 9, 2),
					'qc_nd_year_menopause'	=> $line[SardoToAtim::$columns['Année ménopause']] == 9999 ? null : $line[SardoToAtim::$columns['Année ménopause']],
				)
			);
			SardoToAtim::update(Models::REPRODUCTIVE_HISTORY, $menopause, $line_number);
		}
		
		
	}
	
	if($line[SardoToAtim::$columns['CYTO+ 1 Tx00']]){
		$cytology = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 29,
				'diagnosis_master_id'	=> $dx_id,
				'event_date'			=> $line[SardoToAtim::$columns['CYTO+ 1 Tx00 - date']],
				'event_date_accuracy'	=> $line['CYTO+ 1 Tx00 - date_accuracy']
			), 'detail' => array(
				'type'			=> $line[SardoToAtim::$columns['CYTO+ 1 Tx00']],
				'no_patho'		=> $line[SardoToAtim::$columns['CYTO+ 1 Tx00 - no patho']],
				'site'			=> $line[SardoToAtim::$columns['CYTO+ 1 Tx00 - lieu']]
			)
		);
	
		SardoToAtim::update(Models::EVENT_MASTER, $cytology, $line_number);
	}
	
	$ca125_peri_dx = null;
	$ca125_pre_chir = null;
	if($line[SardoToATim::$columns['CA-125 péri-DX - date']]){
		$ca125_peri_dx = $line[SardoToATim::$columns['CA-125 péri-DX - date']];
		$ca125 = array(
				'master' => array(
						'participant_id'		=> $line['participant_id'],
						'event_control_id'		=> 30,
						'diagnosis_master_id'	=> $dx_id,
						'event_date'			=> $line[SardoToAtim::$columns['CA-125 péri-DX - date']],
						'event_date_accuracy'	=> $line['CA-125 péri-DX - date_accuracy']
				), 'detail' => array(
						'value'					=> SardoToAtim::toNumber($line[SardoToAtim::$columns['CA-125 péri-DX']])
				)
		);
	
		SardoToAtim::update(Models::EVENT_MASTER, $ca125, $line_number);
	}
	if($line[SardoToATim::$columns['CA-125 préCHIR Tx00 - dat']] && $line[SardoToATim::$columns['CA-125 préCHIR Tx00 - dat']] != $ca125_peri_dx){
		$ca125_pre_chir = $line[SardoToATim::$columns['CA-125 préCHIR Tx00 - dat']];
		$ca125 = array(
				'master' => array(
						'participant_id'		=> $line['participant_id'],
						'event_control_id'		=> 30,
						'diagnosis_master_id'	=> $dx_id,
						'event_date'			=> $line[SardoToAtim::$columns['CA-125 préCHIR Tx00 - dat']],
						'event_date_accuracy'	=> $line['CA-125 préCHIR Tx00 - dat_accuracy']
				), 'detail' => array(
						'value'					=> SardoToAtim::toNumber($line[SardoToAtim::$columns['CA-125 préCHIR Tx00']])
				)
		);
	
		SardoToAtim::update(Models::EVENT_MASTER, $ca125, $line_number);
	}
	if($line[SardoToATim::$columns['Dernier CA-125 - date']] && !in_array($line[SardoToATim::$columns['Dernier CA-125 - date']], array($ca125_peri_dx, $ca125_pre_chir))){
		$ca125 = array(
				'master' => array(
						'participant_id'		=> $line['participant_id'],
						'event_control_id'		=> 30,
						'diagnosis_master_id'	=> $dx_id,
						'event_date'			=> $line[SardoToAtim::$columns['Dernier CA-125 - date']],
						'event_date_accuracy'	=> $line['Dernier CA-125 - date_accuracy']
				), 'detail' => array(
						'value'					=> SardoToAtim::toNumber($line[SardoToAtim::$columns['Dernier CA-125']])
				)
		);
	
		SardoToAtim::update(Models::EVENT_MASTER, $ca125, $line_number);
	}
	
	for($i = 1; $i <= 6; ++ $i){
		$key_name = sprintf('TX %d Tx00', $i);
		if($line[SardoToATim::$columns[$key_name]]){
			if($line[SardoToATim::$columns[$key_name]] == $line[SardoToATim::$columns['CHIR 1 Tx00']] && $line[SardoToATim::$columns[$key_name.' - début']] == $line[SardoToATim::$columns['CHIR 1 Tx00 - date']]){
				//this is the surgery, skip
				continue;
			}
			//TODO: skip other redundant fields
			$tx = array(
				'name'	=> $line[SardoToATim::$columns[$key_name]],
				'participant_id'		=> $line['participant_id'],
				'date_start'			=> $line[SardoToATim::$columns[$key_name.' - début']],
				'date_start_accuracy'	=> $line[$key_name.' - début_accuracy'],
				'date_end'				=> $line[SardoToATim::$columns[$key_name.' - fin']],
				'date_end_accuracy'		=> $line[$key_name.' - fin_accuracy'],
				'diagnosis_master_id'	=> $dx_id
			);
			SardoToAtim::manageTx($tx, null, $line_number);
		}
	}
	
	
	
	if($line[SardoToATim::$columns['Toute CHIR Tx00 + patho']]){
		$patho = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 33,
				'event_summary'			=> $line[SardoToAtim::$columns['Toute CHIR Tx00 + patho']],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'atypie_cellulaire'				=> $line[SardoToAtim::$columns['Atypie cellulaire']],
				'atypie_cellulaire_blocs'		=> $line[SardoToAtim::$columns['Atypie cellulaire - blocs']],
				'cancer'						=> $line[SardoToAtim::$columns['Cancer']],
				'cancer_prop'					=> $line[SardoToAtim::$columns['Cancer - prop']],
				'cancer_blocs'					=> $line[SardoToAtim::$columns['Cancer - blocs']],
				'ganglions_regionaux'			=> $line[SardoToAtim::$columns['Ganglions régionaux']],
				'ganglions_regionaux_prop'		=> $line[SardoToAtim::$columns['Ganglions régionaux - prop']],
				'gleason_num'					=> $line[SardoToAtim::$columns['Gleason - num']],
				'gleason'						=> $line[SardoToAtim::$columns['Gleason']],
				'grade_histologique_sur_3'		=> $line[SardoToAtim::$columns['Grade histologique sur 3']],
				'hyperplasie_bph'				=> $line[SardoToAtim::$columns['Hyperplasie (BPH)']],
				'hyperplasie_bph_blocs'			=> $line[SardoToAtim::$columns['Hyperplasie (BPH) - blocs']],
				'infiltration_peineurale'		=> $line[SardoToAtim::$columns['Infiltration périneurale']],
				'invasion_extra_capsulaire'		=> $line[SardoToAtim::$columns['Invasion extra-capsulaire']],
				'invasion_lymph_vasc'			=> $line[SardoToAtim::$columns['Invasion lymph. vasc.']],
				'marges_de_resection'			=> $line[SardoToAtim::$columns['Marges de résection']],
				'marges_de_resection_blocs'		=> $line[SardoToAtim::$columns['Marges de résection - blocs']],
				'marges_resection_uretre'		=> $line[SardoToAtim::$columns['Marges résection urètre']],
				'marges_resection_uretre_blocs'	=> $line[SardoToAtim::$columns['Marges résection urètre - blocs']],
				'pin_1'							=> $line[SardoToAtim::$columns['PIN 1']],
				'pin_1_blocs'					=> $line[SardoToAtim::$columns['PIN 1 - blocs']],
				'pin_2_3'						=> $line[SardoToAtim::$columns['PIN 2 3']],
				'pin_2_3_blocs'					=> $line[SardoToAtim::$columns['PIN 2 3 - blocs']],
				'poids_prostate_num'			=> $line[SardoToAtim::$columns['Poids prostate - num']],
				'prostatite'					=> $line[SardoToAtim::$columns['Prostatite']],
				'prostatite_blocs'				=> $line[SardoToAtim::$columns['Prostatite - blocs']],
				'ves_seminales_atteintes'		=> $line[SardoToAtim::$columns['Vés. séminales atteintes']],
			)
		);
		SardoToAtim::update(Models::EVENT_MASTER, $patho, $line_number);
	}
	
	if($line[SardoToATim::$columns['APS préCHIR Tx00 - date']]){
		$event = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 34,
				'event_date'			=> $line[SardoToATim::$columns['APS préCHIR Tx00 - date']],
				'event_date_accuracy'	=> $line['APS préCHIR Tx00 - date_accuracy'],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'value'					=> str_replace(',', '.', $line[SardoToATim::$columns['APS préCHIR Tx00']])
			)
		);
		SardoToAtim::update(Models::EVENT_MASTER, $event, $line_number);
	}
	if($line[SardoToATim::$columns['Dernier APS - date']]){
		$event = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 34,
				'event_date'			=> $line[SardoToATim::$columns['Dernier APS - date']],
				'event_date_accuracy'	=> $line['Dernier APS - date_accuracy'],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'value'					=> str_replace(',', '.', $line[SardoToATim::$columns['Dernier APS']])
			)
		);
		SardoToAtim::update(Models::EVENT_MASTER, $event, $line_number);
	}
	
	foreach(explode(',', $line[SardoToATim::$columns["Pr00 - sites d'atteinte"]]) as $site){
		$site = trim($site);
		if($site){
			$progression = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'diagnosis_control_id'	=> 17,
					'parent_id'				=> $dx_id,
					'primary_id'			=> $dx_id
				), 'detail' => array(
					'qc_nd_site'			=> $site,
					'qc_nd_initial'			=> 'y'
				)
			);
			SardoToAtim::update(Models::DIAGNOSIS_MASTER, $progression, $line_number, 'participant_id', array('master' => array('parent_id', 'diagnosis_control_id'), 'detail' => array('qc_nd_initial', 'qc_nd_site')));
		}
	}
	
	if($line[SardoToATim::$columns['Ovaire droit - blocs']] || $line[SardoToATim::$columns['Ovaire gauche - blocs']]){
		$event = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 36,
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'ovary_right'			=> $line[SardoToATim::$columns['Ovaire droit - blocs']],
 				'ovary_left'			=> $line[SardoToATim::$columns['Ovaire gauche - blocs']]
			)
		);
		SardoToAtim::update(Models::EVENT_MASTER, $event, $line_number);
	}
	
	unset($line);
}
if($participant_validation_only){
	SardoToAtim::$commit = false;
}
SardoToAtim::endChecks();

