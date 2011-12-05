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

$xls_reader->read('/Volumes/data/2011-11-15 Export ovaire complet.XLS');
// $xls_reader->read('/Volumes/data/2011-12-01 Export SARDO-recherche ovaire.XLS');
// $xls_reader->read('/Volumes/data/2011-11-15 Export ovaire complet sample.XLS');
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
		), 'dates'
	);
	SardoToAtim::update('diagnosis_masters', 'qc_nd_dxd_primary_sardo', 'qc_nd_sardo_id', $dx_data, 'participant_id');
	
// 	$reprod_hist = array('master' => array(
// 		'participant_id' => $line['participant_id'],
		
// 	));

	if($line[SardoToAtim::$columns['BIOP+ 1 Tx00 - date']]){
		$biopsy = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'event_control_id'		=> 27,
				'event_date'			=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00 - date']]
			), 'detail' => array(
				
				'precision'				=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00']]
			)
		);
		//TODO: how can we update? no pkey
		//SardoToAtim::update('event_masters', 'qc_nd_ed_biopsy', null, $biopsy, 'participant_id');
	}
	
	if($line[SardoToAtim::$columns['CHIR 1 Tx00']]){
		$surgery = array(
			'master' => array(
				'participant_id'		=> $line['participant_id'],
				'treatment_control_id'	=> 1,
				'start_date'			=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - date']]
			), 'detail' => array(
				'qc_nd_precision'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00']]
			)
		);
		
		//TODO: how can we update? no pkey
		//SardoToAtim::update('treatment_masters', 'txd_surgeries', null, $surgery, 'participant_id');
	}
}















SardoToAtim::endChecks();

