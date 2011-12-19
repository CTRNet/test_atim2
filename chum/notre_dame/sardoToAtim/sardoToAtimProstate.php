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
	'Date du décès',
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

$tx_mapping = array(
	"Biopsie excisionnelle d'un ganglion"	 		=> array('type' => Models::EVENT_MASTER, 'ctrl_id' => 28),
	"Hémicolectomie droite"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Laparotomie"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Néphrectomie radicale"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Néphro-urétérectomie"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Pancréatectomie corporéo-caudale"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Polypectomie du rectum"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Prostatectomie radicale"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Résection transurétrale de la prostate (TURP)"	=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Résection transurétrale de la vessie"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Bicalutamide"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Hormonothérapie SAI"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Leuprolide"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Radiothérapie du cerveau"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 2),
	"Radiothérapie du thorax/poumon"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 3),
	"Implant d'iode 125"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 4),
	"Radiothérapie pelvienne externe"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 5),
	"Protocole 5-FU perfusion + RT pré-opératoire"	=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 6),
	"Protocole R-CHOP"								=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 7),
	"Protocole Taxol + Cisplatin + 5-FU"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 8),
	"Observation"									=> array('type' => Models::EVENT_MASTER, 'ctrl_id' => 32),
	"Etude PCS III BRAS 3" 							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 1)
);

$tx_detail_precision = array(
	4	=> 'qc_nd_precision',
	5	=> 'type'
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
				'type'					=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00']],
				'no_patho'				=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00 - no patho']],
				'location'				=> $line[SardoToAtim::$columns['BIOP+ 1 Tx00 - lieu']],
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
				'qc_nd_no_patho'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - no patho']],
				'qc_nd_location'		=> $line[SardoToAtim::$columns['CHIR 1 Tx00 - lieu']],
			)
		);
	
		SardoToAtim::update(Models::TREATMENT_MASTER, $surgery, $line_number);
	}
	
	for($i = 1; $i <= 6; ++ $i){
		$key_name = sprintf('TX %d Tx00', $i);
		if($line[SardoToATim::$columns[$key_name]]){
			if(!array_key_exists($line[SardoToATim::$columns[$key_name]], $tx_mapping)){
				sardoToAtim::$commit = false;
				printf("ERROR: Unknown treatment [%s] for participant at line [%d].\n", $line[SardoToATim::$columns[$key_name]], key($cells));
				continue;
			}
			$tx_map = $tx_mapping[$line[SardoToATim::$columns[$key_name]]];
			if($tx_map['type'] == Models::EVENT_MASTER){
				$event = array(
					'master' => array(
						'participant_id'		=> $line['participant_id'],
						'event_control_id'		=> $tx_map['ctrl_id'],
						'event_date'			=> $line[SardoToAtim::$columns[$key_name.' - début']],
						'event_date_accuracy'	=> $line[$key_name.' - début_accuracy'],
						'diagnosis_master_id'	=> $dx_id
					), 'detail' => array(
						'type'					=> $line[SardoToATim::$columns[$key_name]]
					)
				);
				if($line[SardoToAtim::$columns[$key_name.' - fin']]){
					printf("WARNING: DB Event has no end date for event [%s] for participant at line [%d].\n", $line[SardoToATim::$columns[$key_name]], key($cells));
				}
				SardoToAtim::update(Models::EVENT_MASTER, $event, $line_number);
				
			}else if($tx_map['type'] == Models::TREATMENT_MASTER){
				$tx = array(
					'master' => array(
						'participant_id'		=> $line['participant_id'],
						'treatment_control_id'	=> $tx_map['ctrl_id'],
						'start_date'			=> $line[SardoToAtim::$columns[$key_name.' - début']],
						'start_date_accuracy'	=> $line[$key_name.' - début_accuracy'],
						'finish_date'			=> $line[SardoToAtim::$columns[$key_name.' - fin']],
						'finish_date_accuracy'	=> $line[$key_name.' - fin_accuracy'],
						'diagnosis_master_id'	=> $dx_id
					), 'detail' => array(
						
					)
				);
				if(array_key_exists($tx_map['ctrl_id'], $tx_detail_precision)){
					$tx['detail'][$tx_detail_precision[$tx_map['ctrl_id']]] = $line[SardoToATim::$columns[$key_name]];
				}else if(array_key_exists('protocol', $tx_map)){
					$tx['master']['protocol_master_id'] = $tx_map['protocol'];
				}else{
					SardoToAtim::$commit = false;
					printf('ERROR: Treatment [%s] without protocol or type at line [%d]', $line[SardoToATim::$columns[$key_name]], key($cells));
				}
				SardoToAtim::update(Models::TREATMENT_MASTER, $tx, $line_number);
				
			}else{
				sardoToAtim::$commit = false;
				printf("ERROR: Unhandled treatment [%s] for participant at line [%d].\n", $line[SardoToATim::$columns[$key_name]], key($cells));
				continue;
			}
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
				'value'					=> $line[SardoToATim::$columns['APS préCHIR Tx00']]
			)
		);
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
				'value'					=> $line[SardoToATim::$columns['Dernier APS']]
			)
		);
	}
	
	for($i = 1; $i < 4; ++ $i){
		//Pr 01, 02 & 03
		$key = sprintf('Pr%02d', $i);
		$date_key = $key.' - date';
		if($line[SardoToATim::$columns[$date_key]]){
			$dx = array(
				'master' => array(
					'participant_id'		=> $line['participant_id'],
					'diagnosis_control_id'	=> 20,
					'dx_date'				=> $line[SardoToATim::$columns[$date_key]],
					'dx_date_accuracy'		=> $line[$date_key.'_accuracy'],
					'primary_id'			=> $dx_id,
					'parent_id'				=> $dx_id,
				), 'detail' => array(
					'value'					=> $line[SardoToATim::$columns[$key.' - sites']],
				)
			);
		}
		
	}
}

SardoToAtim::endChecks();