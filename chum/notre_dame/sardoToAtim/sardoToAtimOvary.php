<?php
require_once 'sardoToAtim.php';

SardoToAtim::$columns = array(
	'Nom'								=> 1,
	'Prénom'							=> 2,
	'No de dossier'						=> 3,
	'No banque de tissus'				=> 4,
	'No patient SARDO'					=> 5,
	'Date de naissance'					=> 6,
	'Age actuel'						=> 7,
	'Date du diagnostic'				=> 8,
	'Age au diagnostic'					=> 9,
	'No DX SARDO'						=> 10,
	'Topographie'						=> 11,
	'Latéralité'						=> 12,
	'Morphologie'						=> 13,
	'Ménopause'							=> 14,
	'Année ménopause'					=> 15,
	'TNM G'								=> 16,
	'TNM pT'							=> 17,
	'TNM pN'							=> 18,
	'TNM pM'							=> 19,
	'TNM pathologique'					=> 20,
	'FIGO'								=> 21,
	'BIOP+ 1 Tx00'						=> 22,
	'BIOP+ 1 Tx00 - date'				=> 23,
	'CYTO+ 1 Tx00'						=> 24,
	'CYTO+ 1 Tx00 - date'				=> 25,
	'CHIR 1 Tx00'						=> 26,
	'CHIR 1 Tx00 - date'				=> 27,
	'CHIMIO 1 Tx00'						=> 28,
	'CHIMIO 1 Tx00 - début'				=> 29,
	'CHIMIO préCHIR Tx00'				=> 30,
	'CHIM préCHIR Tx00 - date'			=> 31,
	'Toute HORM Tx00'					=> 32,
	'CA-125 péri-DX - date'				=> 33,
	'CA-125 péri-DX'					=> 34,
	'CA-125 préCHIR Tx00 - dat'			=> 35,
	'CA-125 préCHIR Tx00'				=> 36,
	'Dernier CA-125 - date'				=> 37,
	'Dernier CA-125'					=> 38,
	'Ovaire droit - blocs'				=> 39,
	'Ovaire gauche - blocs'				=> 40,
	'Maladie résiduelle'				=> 41,
	'Pr01 - date'						=> 42,
	'Délai DX-Pr01 (M)'					=> 43,
	'Délai DX-Pr01 (J)'					=> 44,
	'Pr01 - sites'						=> 45,
	'Date dernier contact'				=> 46,
	'Date du décès'						=> 47,
	'Cause de décès'					=> 48,
	'Censure (0 = vivant, 1 = mort)'	=> 49,
	'Survie (mois)' 					=> 50
);

SardoToAtim::$date_columns = array(
	'Date de naissance',
	'Date du diagnostic',
	'BIOP+ 1 Tx00 - date',
	'CYTO+ 1 Tx00 - date',
	'CHIR 1 Tx00 - date',
	'CHIMIO 1 Tx00 - début',
	'CHIM préCHIR Tx00 - date',
	'CA-125 péri-DX - date',
	'CA-125 préCHIR Tx00 - dat',
	'Dernier CA-125 - date',
	'Pr01 - date',
	'Date dernier contact',
	'Date du décès'
);

SardoToAtim::$bank_identifier_ctrl_ids_column_name = 'No banque de tissus';
SardoToAtim::$hospital_identifier_ctrl_ids_column_name = 'No de dossier';

// $xls_reader->read('/Volumes/data/2011-11-15 Export ovaire complet.XLS');
// $xls_reader->read('/Volumes/data/2011-12-01 Export SARDO-recherche ovaire.XLS');
$xls_reader->read('/Volumes/data/2011-11-15 Export ovaire complet sample.XLS');
$cells = $xls_reader->sheets[0]['cells'];

$stmt = SardoToAtim::$connection->prepare("SELECT * FROM participants WHERE id=?");
SardoToAtim::basicChecks($cells);
unset($cells[1]);
foreach($cells as $line){
	$dx_data = array(
		'master' => array(
			'participant_id'		=> $line['participant_id'],
			'qc_nd_sardo_id'		=> $line[SardoToAtim::$columns['No DX SARDO']],
			'diagnosis_control_id'	=> 19,
			'primary_id'			=> null,
			'parent_id'				=> null,
			'dx_date'				=> $line[SardoToAtim::$columns['Date du diagnostic']],
			'dx_date_accuracy'		=> $line['Date du diagnostic_accuracy'],
			'topography'			=> $line[SardoToAtim::$columns['Topographie']],
			'morphology'			=> $line[SardoToAtim::$columns['Morphologie']],
			'path_tstage'			=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'			=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'			=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'	=> $line[SardoToAtim::$columns['TNM pathologique']]
		), 'detail' => array(
			'laterality'			=> $line[SardoToAtim::$columns['Latéralité']],
			'tnm_g'					=> $line[SardoToAtim::$columns['TNM G']],
			'figo'					=> $line[SardoToAtim::$columns['FIGO']]
		)
	);
	$dx_id = SardoToAtim::update(Models::DIAGNOSIS_MASTER, 'qc_nd_dxd_primary_sardo', $dx_data, 'participant_id', array('qc_nd_sardo_id'));
	
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
		SardoToAtim::update(Models::EVENT_MASTER, 'qc_nd_ed_biopsy', $biopsy);
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
				'qc_nd_precision'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00']],
				'qc_nd_residual_disease'=> $line[SardoToAtim::$columns['Maladie résiduelle']],
			)
		);
		
		SardoToAtim::update(Models::TREATMENT_MASTER, 'txd_surgeries', $surgery);
	}
	
	if($line[SardoToAtim::$columns['CHIMIO 1 Tx00']]){
		$chemo = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 1,
				'start_date'			=> $line[SardoToAtim::$columns['CHIMIO 1 Tx00 - début']],
				'start_date_accuracy'	=> $line['CHIMIO 1 Tx00 - début_accuracy'],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'qc_nd_type'			=> $line[SardoToAtim::$columns['CHIMIO 1 Tx00']], 
				'qc_nd_pre_chir'		=> 'n'
			)
		);
		
		SardoToAtim::update(Models::TREATMENT_MASTER, 'txd_chemos', $chemo);
	}
	
	if($line[SardoToAtim::$columns['Pr01 - date']]){
		$progression = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'diagnosis_control_id'	=> 17,
				'parent_id'				=> $dx_id,
				'dx_date'				=> $line[SardoToAtim::$columns['Pr01 - date']],
				'dx_date_accuracy'		=> $line['Pr01 - date_accuracy']
			), 'detail' => array(
				'qc_nd_delay'			=> $line[SardoToAtim::$columns['Délai DX-Pr01 (J)']], 
				'qc_nd_sites'			=> $line[SardoToAtim::$columns['Pr01 - sites']]
			)
		);
		
		SardoToAtim::update(Models::DIAGNOSIS_MASTER, 'dxd_progressions', $progression);
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
			)
		);
	
		SardoToAtim::update(Models::EVENT_MASTER, 'qc_nd_ed_cytology', $cytology);
	}
	
	if($line[SardoToAtim::$columns['Ménopause']] && !in_array($line[SardoToAtim::$columns['Ménopause']], array('N/S', '', 'non ménopausée'))){
		$menopause = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'menopause_status'		=> $line[SardoToAtim::$columns['Ménopause']],
				'qc_nd_year_menopause'	=> $line[SardoToAtim::$columns['Année ménopause']] == 9999 ? null : $line[SardoToAtim::$columns['Année ménopause']]
			)
		);
		SardoToAtim::update(Models::REPRODUCTIVE_HISTORY, null, $menopause);
	}
	
	if($line[SardoToATim::$columns['Toute HORM Tx00']]){
		//contient le type, suivi de la date from - to entre parenthèses
		$value = substr($line[SardoToATim::$columns['Toute HORM Tx00']], 0, -26);
		$date_from = SardoToAtim::formatWithAccuracy(preg_replace('/([\w]{2})\/([\w]{2})\/([\w]{4})/', '$3-$2-$1', substr($line[SardoToATim::$columns['Toute HORM Tx00']], -24, 10)));
		$date_to = preg_replace('/([\w]{2})\/([\w]{2})\/([\w]{4})/', '$3-$2-$1', substr($line[SardoToATim::$columns['Toute HORM Tx00']], -11, 10));
		if($date_to == '0000-00-00'){
			$date_to['val'] = null;
			$date_to['accuracy'] = '';
		}else{
			$date_to = SardoToAtim::formatWithAccuracy($date_to);
		}
		
		$hormono = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 5,
				'start_date'			=> $date_from['val'],
				'start_date_accuracy'	=> $date_from['accuracy'],
				'finish_date'			=> $date_to['val'],
				'finish_date_accuracy'	=> $date_to['accuracy'],
				'diagnosis_master_id'	=> $dx_id
			), 'detail' => array(
				'type'					=> $value
			)
		);
		
		SardoToAtim::update(Models::TREATMENT_MASTER, 'qc_nd_txd_hormonotherapies', $hormono);
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
				'type'					=> $line[SardoToAtim::$columns['CA-125 péri-DX']]
			)
		);
		
		SardoToAtim::update(Models::EVENT_MASTER, 'qc_nd_ed_ca125', $ca125);
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
				'type'					=> $line[SardoToAtim::$columns['CA-125 préCHIR Tx00']]
			)
		);
		
		SardoToAtim::update(Models::EVENT_MASTER, 'qc_nd_ed_ca125', $ca125);
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
				'type'					=> $line[SardoToAtim::$columns['Dernier CA-125']]
			)
		);
		
		SardoToAtim::update(Models::EVENT_MASTER, 'qc_nd_ed_ca125', $ca125);
	}
}



SardoToAtim::endChecks();

