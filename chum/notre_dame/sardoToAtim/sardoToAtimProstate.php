<?php
require_once 'sardoToAtim.php';

SardoToAtim::$columns = array(
	"Nom"								=> 1,
	"Prénom"							=> 2,
	"No de dossier"						=> 3,
	"No banque de tissus"				=> 4,
	"No patient SARDO"					=> 5,
	"Date du diagnostic"				=> 6,
	"No DX SARDO"						=> 7,
	"TNM T"								=> 8,
	"TNM N"								=> 9,
	"TNM M"								=> 10,
	"TNM clinique"						=> 11,
	"TNM pT"							=> 12,
	"TNM pN"							=> 13,
	"TNM pM"							=> 14,
	"TNM pathologique"					=> 15,
	"BIOP+ 1 Tx00"						=> 16,
	"BIOP+ 1 Tx00 - date"				=> 17,
	"BIOP+ 1 Tx00 - no patho"			=> 18,
	"BIOP+ 1 Tx00 - lieu"				=> 19,
	"CHIR 1 Tx00"						=> 20,
	"CHIR 1 Tx00 - date"				=> 21,
	"CHIR 1 Tx00 - no patho"			=> 22,
	"CHIR 1 Tx00 - lieu"				=> 23,
	"Séquence Tx00"						=> 24,
	"TX 1 Tx00"							=> 25,
	"TX 1 Tx00 - début"					=> 26,
	"TX 1 Tx00 - fin"					=> 27,
	"TX 2 Tx00"							=> 28,
	"TX 2 Tx00 - début"					=> 29,
	"TX 2 Tx00 - fin"					=> 30,
	"TX 3 Tx00"							=> 31,
	"TX 3 Tx00 - début"					=> 32,
	"TX 3 Tx00 - fin"					=> 33,
	"TX 4 Tx00"							=> 34,
	"TX 4 Tx00 - début"					=> 35,
	"TX 4 Tx00 - fin"					=> 36,
	"TX 5 Tx00"							=> 37,
	"TX 5 Tx00 - début"					=> 38,
	"TX 5 Tx00 - fin"					=> 39,
	"TX 6 Tx00"							=> 40,
	"TX 6 Tx00 - début"					=> 41,
	"TX 6 Tx00 - fin"					=> 42,
	"Toute CHIR Tx00 + patho"			=> 43,
	"Atypie cellulaire"					=> 44,
	"Atypie cellulaire - blocs"			=> 45,
	"Cancer"							=> 46,
	"Cancer - prop"						=> 47,
	"Cancer - blocs"					=> 48,
	"Ganglions régionaux"				=> 49,
	"Ganglions régionaux - prop"		=> 50,
	"Gleason - num"						=> 51,
	"Gleason"							=> 52,
	"Grade histologique sur 3"			=> 53,
	"Hyperplasie (BPH)"					=> 54,
	"Hyperplasie (BPH) - blocs"			=> 55,
	"Infiltration périneurale"			=> 56,
	"Invasion extra-capsulaire"			=> 57,
	"Invasion lymph. vasc."				=> 58,
	"Marges de résection"				=> 59,
	"Marges de résection - blocs"		=> 60,
	"Marges résection urètre"			=> 61,
	"Marges résection urètre - blocs"	=> 62,
	"PIN 1"								=> 63,
	"PIN 1 - blocs"						=> 64,
	"PIN 2 3"							=> 65,
	"PIN 2 3 - blocs"					=> 66,
	"Poids prostate - num"				=> 67,
	"Prostatite"						=> 68,
	"Prostatite - blocs"				=> 69,
	"Vés. séminales atteintes"			=> 70,
	"APS préCHIR Tx00 - date"			=> 71,
	"APS préCHIR Tx00"					=> 72,
	"Dernier APS - date"				=> 73,
	"Dernier APS"						=> 74,
	"Délai CHIR-dernier APS (M"			=> 75,
	"Délai CHIR-dernier APS (J"			=> 76,
	"Pr01 - date"						=> 77,
	"Pr01 - sites"						=> 78,
	"Délai DX-Pr01 (M)"					=> 79,
	"Délai DX-Pr01 (J)"					=> 80,
	"Pr02 - date"						=> 81,
	"Pr02 - sites"						=> 82,
	"Délai DX-Pr02 (M)"					=> 83,
	"Délai DX-Pr02 (J)"					=> 84,
	"Pr03 - date"						=> 85,
	"Pr03 - sites"						=> 86,
	"Délai DX-Pr03 (M)"					=> 87,
	"Délai DX-Pr03 (J)"					=> 88,
	"Date dernier contact"				=> 89,
	"Date du décès"						=> 90,
	"Survie (mois)"						=> 91,
	"Fanions"							=> 92,
	'Date de naissance'					=> 93,
);

SardoToAtim::$date_columns = array(
	'Date de naissance',
	'Date du diagnostic',
	'BIOP+ 1 Tx00 - date',
	'CHIR 1 Tx00 - date',
	'APS préCHIR Tx00 - date',
	'Dernier APS - date',
	'Pr01 - date',
	'Pr02 - date',
	'Pr03 - date',
	'Date dernier contact',
	'Date du décès'
);


SardoToAtim::$bank_identifier_ctrl_ids_column_name = 'No banque de tissus';
SardoToAtim::$hospital_identifier_ctrl_ids_column_name = 'No de dossier';

$xls_reader->read('/Volumes/data/2011-11-15 Export complet prostate sample.XLS');
// $xls_reader->read('/Volumes/data/2011-11-15 Export complet prostate.XLS');
// $xls_reader->read('/Volumes/data/2011-11-18 export prostate recherche.XLS');
$cells = $xls_reader->sheets[0]['cells'];

SardoToAtim::basicChecks($cells);

reset($cells);
while($line = next($cells)){
	$line_number = key($cells);
	$dx_data = array(
		'master' => array(
			'participant_id'		=> $line['participant_id'],
			'qc_nd_sardo_id'		=> $line[SardoToAtim::$columns['No DX SARDO']],
			'diagnosis_control_id'	=> 19,
			'primary_id'			=> null,
			'parent_id'				=> null,
			'dx_date'				=> $line[SardoToAtim::$columns['Date du diagnostic']],
			'dx_date_accuracy'		=> $line['Date du diagnostic_accuracy'],
			'clinical_tstage'		=> $line[SardoToAtim::$columns['TNM T']],
			'clinical_nstage'		=> $line[SardoToAtim::$columns['TNM N']],
			'clinical_mstage'		=> $line[SardoToAtim::$columns['TNM M']],
			'clinical_stage_summary'=> $line[SardoToAtim::$columns['TNM clinique']],
			'path_tstage'			=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'			=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'			=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'	=> $line[SardoToAtim::$columns['TNM pathologique']]
		), 'detail' => array(
		)
	);
	$dx_id = SardoToAtim::update(Models::DIAGNOSIS_MASTER, 'qc_nd_dxd_primary_sardo', $dx_data, $line_number, 'participant_id', array('master' => array('qc_nd_sardo_id')));
	
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
		SardoToAtim::update(Models::EVENT_MASTER, 'qc_nd_ed_biopsy', $biopsy, $line_number);
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
				'qc_nd_no_patho'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - no patho']],
				'qc_nd_location'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - lieu']],
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, 'txd_surgeries', $surgery, $line_number);
	}
	
	for($i = 1; $i <= 6; ++ $i){
		//TODO: Classer les traitements
		$key_name = sprintf('TX %d Tx00', $i);
		if($line[SardoToATim::$columns[$key_name]]){
			$tx = array(
				'master' => array(
					'start_date'			=> $line[SardoToAtim::$columns[$key_name.' - début']],
					'start_date_accuracy'	=> $line[SardoToAtim::$columns[$key_name.' - début_accuracy']],
					'finish_date'			=> $line[SardoToAtim::$columns[$key_name.' - fin']],
					'finish_date_accuracy'	=> $line[SardoToAtim::$columns[$key_name.' - fin_accuracy']]
				), 'detail' => array(
				
				)
			);
		}
		
	}
}

SardoToAtim::endChecks();