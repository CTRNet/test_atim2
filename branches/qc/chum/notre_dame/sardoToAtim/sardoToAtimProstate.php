<?php
require_once 'sardoToAtim.php';

SardoToAtim::$columns = array(
	1 => "Nom",
	"Prénom",
	"Date de naissance",
	"No de dossier",
	"No banque de tissus",
	"No patient SARDO",
	"Date du diagnostic",
	"Code topographique",
	"Code morphologique",
	"No DX SARDO",
	"TNM T",
	"TNM N",
	"TNM M",
	"TNM clinique",
	"TNM pT",
	"TNM pN",
	"TNM pM",
	"TNM pathologique",
	"BIOP+ 1 Tx00",
	"BIOP+ 1 Tx00 - date",
	"BIOP+ 1 Tx00 - no patho",
	"BIOP+ 1 Tx00 - lieu",
	"CHIR 1 Tx00",
	"CHIR 1 Tx00 - date",
	"CHIR 1 Tx00 - no patho",
	"CHIR 1 Tx00 - lieu",
	"Séquence Tx00",
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
	"Toute CHIR Tx00 + patho",
	"Atypie cellulaire",
	"Atypie cellulaire - blocs",
	"Cancer",
	"Cancer - prop",
	"Cancer - blocs",
	"Ganglions régionaux",
	"Ganglions régionaux - prop",
	"Gleason - num",
	"Gleason",
	"Grade histologique sur 3",
	"Hyperplasie (BPH)",
	"Hyperplasie (BPH) - blocs",
	"Infiltration périneurale",
	"Invasion extra-capsulaire",
	"Invasion lymph. vasc.",
	"Marges de résection",
	"Marges de résection - blocs",
	"Marges résection urètre",
	"Marges résection urètre - blocs",
	"PIN 1",
	"PIN 1 - blocs",
	"PIN 2 3",
	"PIN 2 3 - blocs",
	"Poids prostate - num",
	"Prostatite",
	"Prostatite - blocs",
	"Vés. Séminales atteintes",
	"APS préCHIR Tx00 - date",
	"APS préCHIR Tx00",
	"Dernier APS - date",
	"Dernier APS",
	"Délai CHIR-dernier APS (M",
	"Délai CHIR-dernier APS (J",
	"Pr01 - date",
	"Pr01 - sites",
	"Délai DX-Pr01 (M)",
	"Délai DX-Pr01 (J)",
	"Pr02 - date",
	"Pr02 - sites",
	"Délai DX-Pr02 (M)",
	"Délai DX-Pr02 (J)",
	"Pr03 - date",
	"Pr03 - sites",
	"Délai DX-Pr03 (M)",
	"Délai DX-Pr03 (J)",
	"Date dernier contact",
	"Date du décès",
	"Survie (mois)",
	"Fanions"
);
SardoToAtim::$columns = array_flip(SardoToAtim::$columns);

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
	"Hémicolectomie"								=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
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
	"Etude PCS III BRAS 3" 							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 1),
	"Dissection des ganglions pelviens" 			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Résection transurétrale du col vésical"		=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Orchiectomie"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Cure d'hernie inguinale"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Orchiectomie"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Flutamide"										=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Cyproterone"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Cure d'hernie inguinale"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Néphrectomie"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Orchiectomie radicale"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Radiothérapie (RT) SAI"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 14),
	"Prostatectomie"								=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Etude Abbott C94-011 pré-op 8 mois"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 20),
	"Traitements palliatifs SAI"					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Radiothérapie interstitielle de la prostate"	=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 9),
	"Gosereline"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Mitomycine"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"BCG"											=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Dissection des ganglions régionaux de la prostate"	=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Busereline"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Nilutamide"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Etude CUOG P 0401"								=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 10),
	"Radiothérapie de la région pelvienne"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 11),
	"Résection segmentaire du rectum"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Dissection ganglionnaire"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Etude Abbott M00-244"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 12),
	"Etude G-0029 BRAS 2"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 13),
	"CP-751871"										=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 45),
	"Tamoxifene"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Chirurgie du poumon"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Radiothérapie pancrénienne"					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 15),
	"Docetaxel ou placebo"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 38),
	"Etude Abbott C94-011 pré-op 3 mois"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 16),
	"Radiothérapie de l'amygdale"					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 17),
	"Etude RTOG 9813 BRAS 2"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 18),
	"Radiothérapie externe du petit bassin (true pelvis)"=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 19),
	"Orchiectomie unilatérale"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Ondansétron"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Dissection des ganglions inguinaux"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Etude Abbott M01-366"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 21),
	"Dissection des ganglions obturateurs"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Rituximab"										=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Doxorubicine"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 39),
	"Résection antérieure"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Iléostomie"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Triméthoprime"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 6),
	"Protocole 5-FU + Leucovorin"					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 22),
	"Etude RTOG 9601 (RT +/- Casodex)"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 23),
	"Néphrectomie partielle/subtotale"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Chirurgie du côlon"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Chimiothérapie SAI"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 24),
	"Prostatectomie totale"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Radiothérapie abdomino-pelvienne"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 25),
	"Vinorelbine"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 40),
	"Gemcitabine"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 41),
	"Etude RTOG 0534 BRAS 2"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 26),
	"Docetaxel"										=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 42),
	"Protocole FOLFOX"								=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 27),
	"Etude TAX 3503 BRAS 1"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 28),
	"Néphrectomie + résection en bloc"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Cystectomie radicale"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Etude NCIC PR.7 BRAS 1 (déprivation androgénique intermittente)" => array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 29),
	"Radiothérapie de la parotide" 					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 30),
	"Testostérone" 									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Orchiectomie bilatérale"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Dissection des ganglions iliaques"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Protocole CHB Lupron + Euflex"					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 31),
	"Protocole CHB Lupron + Casodex"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 32),
	"Protocole CHB Zoladex + Casodex"				=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 33),
	"Degarelix"										=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Capecitabine"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Triptoreline"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Sunitinib"										=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 5),
	"Carboplatine"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 43),
	"Paclitaxel"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 44),
	"Splénectomie"									=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Destruction de tumeur de la vessie"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Dissection des ganglions régionaux de la tête et du cou"=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Protocole Cisplatin + radiothérapie"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 34),
	"Radiothérapie de la tête et du cou"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2),
	"Etude RTOG 0534 BRAS 1"						=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 2, 'protocol' => 35),
	"Protocole mFOLFOX 6"							=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 36),
	"Destruction de tumeur de la vessie"			=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 4),
	"Protocole Taxol/Carboplatin"					=> array('type' => Models::TREATMENT_MASTER, 'ctrl_id' => 1, 'protocol' => 37)
);

$tx_detail_precision = array(
	4	=> 'qc_nd_precision',
	5	=> 'type'
);


SardoToAtim::$bank_identifier_ctrl_ids_column_name = 'No banque de tissus';
SardoToAtim::$hospital_identifier_ctrl_ids_column_name = 'No de dossier';

// $xls_reader->read('/Volumes/data/new/2012-01-17 Prostate SARDO recherche.XLS');
$xls_reader->read('/Volumes/data/new/2012-01-12 Prostate CHUM.XLS');
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
			'icd10_code'				=> str_replace('.', '', $line[SardoToAtim::$columns['Code topographique']]),
			'morphology'				=> str_replace('/', '', $line[SardoToAtim::$columns['Code morphologique']]),
			'clinical_tstage'			=> $line[SardoToAtim::$columns['TNM T']],
			'clinical_nstage'			=> $line[SardoToAtim::$columns['TNM N']],
			'clinical_mstage'			=> $line[SardoToAtim::$columns['TNM M']],
			'clinical_stage_summary'	=> $line[SardoToAtim::$columns['TNM clinique']],
			'path_tstage'				=> $line[SardoToAtim::$columns['TNM pT']],
			'path_nstage'				=> $line[SardoToAtim::$columns['TNM pN']],
			'path_mstage'				=> $line[SardoToAtim::$columns['TNM pM']],
			'path_stage_summary'		=> $line[SardoToAtim::$columns['TNM pathologique']]
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
				if($tx_map['ctrl_id'] == 32){
					//observation
					$event['detail']['end_date'] = $line[SardoToAtim::$columns[$key_name.' - fin']];
					$event['detail']['end_date_accuracy'] = $line[SardoToAtim::$columns[$key_name.' - fin_accuracy']];
				}else if($line[SardoToAtim::$columns[$key_name.' - fin']] && $line[SardoToAtim::$columns[$key_name.' - fin']] != $line[SardoToAtim::$columns[$key_name.' - début']]){
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
				'ves_seminales_atteintes'		=> $line[SardoToAtim::$columns['Vés. Séminales atteintes']],
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