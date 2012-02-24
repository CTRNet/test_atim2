<?php
require_once 'sardoToAtim.php';

SardoToAtim::$columns = array(
	1 => 'Nom',
	'Prénom',
	'No de dossier',
	'No banque de tissus',
	'No patient SARDO',
	'Date de naissance',
	'Age actuel',
	'Date du diagnostic',
	'Age au diagnostic',
	'No DX SARDO',
	'Code topographique',
	'Topographie',
	'Latéralité',
	'Code morphologique',
	'Morphologie',
	'Ménopause',
	'Année ménopause',
	'TNM G',
	'TNM pT',
	'TNM pN',
	'TNM pM',
	'TNM pathologique',
	'FIGO',
	'BIOP+ 1 Tx00',
	'BIOP+ 1 Tx00 - date',
	'CYTO+ 1 Tx00',
	'CYTO+ 1 Tx00 - date',
	'CHIR 1 Tx00',
	'CHIR 1 Tx00 - date',
	'CHIR 1 Tx00 - no patho',
	'CHIMIO 1 Tx00',
	'CHIMIO 1 Tx00 - début',
	'CHIMIO préCHIR Tx00',
	'CHIM préCHIR Tx00 - date',
	'Toute HORM Tx00',
	'CA-125 péri-DX - date',
	'CA-125 péri-DX',
	'CA-125 préCHIR Tx00 - dat',
	'CA-125 préCHIR Tx00',
	'Dernier CA-125 - date',
	'Dernier CA-125',
	'Ovaire droit - blocs',
	'Ovaire gauche - blocs',
	'Maladie résiduelle',
	'Pr01 - date',
	'Délai DX-Pr01 (M)',
	'Délai DX-Pr01 (J)',
	'Pr01 - sites',
	'Date dernier contact',
	'Date du décès',
	'Cause de décès',
	'Censure (0 = vivant, 1 = mort)',
	'Survie (mois)'
);

SardoToAtim::$columns = array_flip(SardoToAtim::$columns);

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

$xls_reader->read('/Volumes/data/ovaire_crchum.xls');
// $xls_reader->read('/Volumes/data/ovaire_chum.xls');
$cells = $xls_reader->sheets[0]['cells'];

$stmt = SardoToAtim::$connection->prepare("SELECT * FROM participants WHERE id=?");
SardoToAtim::basicChecks($cells);
reset($cells);
while($line = next($cells)){
	$line_number = key($cells);
	$icd10 = str_replace('.', '', $line[SardoToAtim::$columns['Code topographique']]);
	$morpho = str_replace('/', '', $line[SardoToAtim::$columns['Code morphologique']]);
	$dx_data = array(
		'master' => array(
			'participant_id'			=> $line['participant_id'],
			'qc_nd_sardo_id'			=> $line[SardoToAtim::$columns['No DX SARDO']],
			'diagnosis_control_id'		=> 19,
			'parent_id'					=> null,
			'dx_date'					=> $line[SardoToAtim::$columns['Date du diagnostic']],
			'dx_date_accuracy'			=> $line['Date du diagnostic_accuracy'],
			'icd10_code'				=> isset(SardoToAtim::$icd10_ca_equiv[$icd10]) ? SardoToAtim::$icd10_ca_equiv[$icd10] : $icd10,
			'morphology'				=> isset(SardoToAtim::$icdo3_morpho_equiv[$morpho]) ? SardoToAtim::$icdo3_morpho_equiv[$morpho] : $morpho,
			'path_tstage'				=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'				=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'				=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'		=> $line[SardoToAtim::$columns['TNM pathologique']],
			'survival_time_months'		=> $line[SardoToAtim::$columns['Survie (mois)']]
		), 'detail' => array(
			'laterality'				=> $line[SardoToAtim::$columns['Latéralité']],
			'tnm_g'						=> $line[SardoToAtim::$columns['TNM G']],
			'figo'						=> $line[SardoToAtim::$columns['FIGO']]
		)
	);
	$dx_id = SardoToAtim::update(Models::DIAGNOSIS_MASTER, $dx_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_id')));
	
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
				'qc_nd_precision'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00']],
				'qc_nd_residual_disease'=> $line[SardoToAtim::$columns['Maladie résiduelle']],
			)
		);
		
		SardoToAtim::update(Models::TREATMENT_MASTER, $surgery, $line_number);
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
		
		SardoToAtim::update(Models::TREATMENT_MASTER, $chemo, $line_number);
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
				'qc_nd_sites'			=> $line[SardoToAtim::$columns['Pr01 - sites']]
			)
		);
		
		SardoToAtim::update(Models::DIAGNOSIS_MASTER, $progression, $line_number);
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
	
		SardoToAtim::update(Models::EVENT_MASTER, $cytology, $line_number);
	}
	
	$converted_menopause = sardoToAtim::convertMenopause($line[SardoToAtim::$columns['Ménopause']]);
	if($converted_menopause['status']){
		$menopause = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'menopause_status'		=> $converted_menopause['status'],
				'qc_nd_year_menopause'	=> $line[SardoToAtim::$columns['Année ménopause']] == 9999 ? null : $line[SardoToAtim::$columns['Année ménopause']],
				'qc_nd_cause'			=> $converted_menopause['cause']
			)
		);
		SardoToAtim::update(Models::REPRODUCTIVE_HISTORY, $menopause, $line_number);
	}
	
	if($line[SardoToATim::$columns['Toute HORM Tx00']]){
		$pattern = "/[\w]+ \([\d]{2}\/[\d]{2}\/[\d]{4} - [\d]{2}\/[\d]{2}\/[\d]{4}\)/";
		$matches = array();
		preg_match_all($pattern, $line[SardoToATim::$columns['Toute HORM Tx00']], $matches);
		foreach($matches[0] as $match){
			//contient le type, suivi de la date from - to entre parenthèses
			$value = substr($match, 0, -26);
			$date_from = SardoToAtim::formatWithAccuracy(preg_replace('/([\w]{2})\/([\w]{2})\/([\w]{4})/', '$3-$2-$1', substr($match, -24, 10)));
			$date_to = preg_replace('/([\w]{2})\/([\w]{2})\/([\w]{4})/', '$3-$2-$1', substr($match, -11, 10));
			if($date_to == '0000-00-00'){
				$date_to = array('val' => null, 'accuracy' => '');
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
			SardoToAtim::update(Models::TREATMENT_MASTER, $hormono, $line_number);
		}
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
}



SardoToAtim::endChecks();

