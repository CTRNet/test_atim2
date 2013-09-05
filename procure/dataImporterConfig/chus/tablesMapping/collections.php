<?php

function loadCollections() {
	Config::$participant_collections = array();
	Config::$next_sample_code = 0;
	
	// ******************* Load Visist 01 **********************************
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_collection_v01);
	$filename = substr(Config::$xls_file_path_collection_v01, (strrpos(Config::$xls_file_path_collection_v01,'/')+1));
		
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	//V1: Tissue
	if(!isset($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('F10 à F15')]])) die('ERR loadCollections 884894938383');
	loadTissue($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('F10 à F15')]]['cells'], $filename, 'F10 à F15');
	
	//V1: Blood
	if(!isset($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('F3 à F6')]])) die('ERR loadCollections 84444444383');
	loadBlood($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('F3 à F6')]]['cells'], $filename, 'F3 à F6', 'V01');

	//V1: Urine
	if(!isset($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('F7 à F9')]])) die('ERR loadCollections 84444444383');
	loadUrine($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('F7 à F9')]]['cells'], $filename, 'F7 à F9', 'V01');	
	
	// ******************* Load Suvi **********************************

	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_collection_suivi);
	$filename = substr(Config::$xls_file_path_collection_suivi, (strrpos(Config::$xls_file_path_collection_suivi,'/')+1));
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	for($id=2; $id < 8; $id++) {
		$visit = 'V0'.$id;
	
		// Vn: Blood
		$worksheet_name = $visit.utf8_decode(' - F3 à F6');
		if(!isset($tmp_xls_reader->sheets[$sheets_nbr[$worksheet_name]])) die('ERR loadCollections 84444444382 - '.$visit.' - '.$worksheet_name);
		loadBlood($tmp_xls_reader->sheets[$sheets_nbr[$worksheet_name]]['cells'], $filename, $worksheet_name, $visit);
	}

	// ******************* Display unused storage information **********************************
	
	displayUnusedStorageInformation();
	
}

//=========================================================================================================
// Inventroy load
//=========================================================================================================

function loadTissue(&$workSheetCells, $filename, $worksheetname) {	
	$summary_msg_title = 'Tissue V01 <br>  File: '.$filename;
	
	$headers = array();
	$line_counter = 0;

	$headers = array();
	$line_counter = 0;
	$duplicated_participant_check = array();
	
	foreach($workSheetCells as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Identification'];
			if(isset($duplicated_participant_check[$patient_identification]))  die("ERR 89499324 Duplicated participant [$patient_identification]. Check value is not a #REFERENCE. See worksheet [$worksheetname] line $line_counter & ".$duplicated_participant_check[$patient_identification]); 
			$duplicated_participant_check[$patient_identification] = $line_counter;
			if($new_line_data['Visite'] != 'V01') die("ERR 8949944 Tissue collection visit error(".$new_line_data['Visite']."). See worksheet [$worksheetname] line $line_counter");
			$tissue_notes = '';
			$procure_prostatectomy_type = '';
			if($new_line_data['Type de chirurgie']) {
				switch($new_line_data['Type de chirurgie']) {
					case 'laparoscopie':
						$procure_prostatectomy_type = 'laparascopy';
						break;
					case 'ouverte':
						$procure_prostatectomy_type = 'open surgery';
						break;
					default:
						$tissue_notes = $new_line_data['Type de chirurgie'];
						Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Type de chirurgie'][] = "A 'Type de chirurgie' [".$new_line_data['Type de chirurgie']."] has been defined and don't match expected values {laparoscopie, ouverte}. Added to tissu note. Please validate. See worksheet [$worksheetname] line $line_counter";
				}
			}
			if($new_line_data['Nombre de tranches prélevées pour PROCURE']) {	
				$collection_datetime = "''";
				$collection_datetime_accuracy = "''";
				$collection_date_data = getDateAndAccuracy($new_line_data['Date de la chirurgie'], "worksheet $worksheetname", 'Date de la chirurgie', $line_counter);
				if($collection_date_data) {
					$collection_datetime = $collection_date_data['date'];
					$collection_datetime_accuracy = str_replace('c','h',$collection_date_data['accuracy']);
				}
				if($collection_datetime == "''") Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Tissue collection without collection date'][] = "No surgery date has been set for patient $patient_identification.Tissue collection will be created with no collection date. See worksheet [$worksheetname] line $line_counter";
				if(!preg_match('/^[0-9]*$/', $new_line_data['Nombre de tranches prélevées pour PROCURE'])) die("ERR 894884949944 See worksheet [$worksheetname] line $line_counter");
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime] = array(
					'Collection' => array(
					'participant_id' => '',
					'procure_visit' => 'V01',
					'procure_patient_identity_verified' => '1',
					'collection_datetime' => $collection_datetime,
					'collection_datetime_accuracy' => $collection_datetime_accuracy,
					'collection_notes' => ''),
					'Specimens' => array(
						array(
							'***tmp_sample_type***' => 'tissue',
							'SampleMaster' => array('notes' => $tissue_notes),
							'SampleDetail' => array('procure_number_of_slides_collected_for_procure' => $new_line_data['Nombre de tranches prélevées pour PROCURE'], 'procure_prostatectomy_type' => $procure_prostatectomy_type),
							'SpecimenDetail' => array(),
							'Derivatives' => array(),
							'Aliquots' => array(),
							'QualityCtrl' => array()
						)
					)
				);
				$time_spent_collection_to_freezing_end_mn = str_replace('N/A', '', $new_line_data["Temps écoulé entre sortie de l'abdomen et congélation (min)"]);
				if(!preg_match('/^[0-9]*$/', $time_spent_collection_to_freezing_end_mn)) die("ERR 89884999499944 See worksheet [$worksheetname] line $line_counter");
				$new_aliquots = array();
				foreach(array('FRZ' => 10,'PAR' => 8) as $prefix => $slide_nbr_max) {
					for($slide_nbr=1;$slide_nbr<=$slide_nbr_max;$slide_nbr++) {					
						if($slide_nbr < 5 && !empty($new_line_data[$prefix.$slide_nbr.' (rangement)'])) die("ERR 832122112212112 See worksheet [$worksheetname] line $line_counter");
						$aliquot_label = "$patient_identification V01 -$prefix$slide_nbr";
						$procure_origin_of_slice = $new_line_data["$prefix$slide_nbr::".(($prefix == 'FRZ')? "Origine de la tranche" : "Origine du bloc")];
						$procure_origin_of_slice = str_replace(array('N/A') , array(''),$procure_origin_of_slice);
						$procure_origin_of_slice = preg_replace(array('/\ +$/', '/^\-$/') , array('',''), $procure_origin_of_slice);
						$procure_chus_origin_of_slice_precision = '';
						$procure_classification =  str_replace('NT','NC',$new_line_data["$prefix$slide_nbr::C, NC, ND"]);
						$procure_classification = str_replace(array('N/A') , array(''),$procure_classification);
						if($procure_classification == '-') $procure_classification = '';
						$procure_chus_classification_precision = '';
						$procure_dimensions = $new_line_data["$prefix$slide_nbr::".(($prefix == 'FRZ')? "Dimensions (mm x mm x mm)" : "Tranche congelée correspondante")];
						$procure_freezing_type = '';
						if(strlen($procure_origin_of_slice.$procure_classification.$procure_dimensions)) {
							if('PAR' == $prefix) die('ERR 889993 Column not empty : to review');
							if(preg_match('/^(LA|LP|RP|RA)(\ (Base|Apex|\((zone.*[0-9])\))){0,1}$/', $procure_origin_of_slice, $matches)) {
								$procure_origin_of_slice = $matches[1];
								if(isset($matches[4])) { 
									$procure_chus_origin_of_slice_precision = $matches[4];
								} else if(isset($matches[3])) { 
									$procure_chus_origin_of_slice_precision = $matches[3];
								}
							} else if(!in_array($procure_origin_of_slice, array('RP','RA','LP','LA', ''))) {	
								$procure_chus_origin_of_slice_precision = $procure_origin_of_slice;
								$procure_origin_of_slice = 'unclassifiable';
							}
							if(preg_match('/^((C|NC)(=>(C|NC)){0,1})(\ \(([0-9\-%<]+)\)){0,1}(\ {0,1}\-\ (OCT|ISO)){0,1}$/', $procure_classification, $matches)) {
								if(isset($matches[4]) && $matches[4]) {
									$procure_classification = $matches[4];
									$procure_chus_classification_precision = $matches[1];
								} else {
									$procure_classification = $matches[2];
								}
								if(isset($matches[6]) && $matches[6]) $procure_chus_classification_precision = empty($procure_chus_classification_precision)? $matches[6] : $procure_chus_classification_precision .' | '. $matches[6];
								if(isset($matches[8])) {
									switch($matches[8]) {
										case 'ISO':
											$procure_freezing_type = 'ISO';
											break;
										case 'OCT':
											$procure_freezing_type = 'ISO+OCT';
											break;
									}								
								}
							} else if(!in_array($procure_classification, array('C','NC','NC+C','ND',''))) {
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Block classification'][] = "Block classification '$procure_classification' is not supported. See worksheet [$worksheetname] line $line_counter";
								$procure_classification = '';
							}					
							$aliquot_storage_data = getStorageData($aliquot_label, 'tissue', $summary_msg_title, $worksheetname, $line_counter);
							if($aliquot_storage_data['sample_type_precision']) {
								if(!$procure_freezing_type) {
									$procure_freezing_type = $aliquot_storage_data['sample_type_precision'];
								} else if($procure_freezing_type != $aliquot_storage_data['sample_type_precision']) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Freezing Type mismatch'][] = "Freezing type ($procure_freezing_type) defined in worksheet [$worksheetname] for aliquot '$aliquot_label' is different than (".$aliquot_storage_data['sample_type_precision'].") defined in storage worksheet [".$aliquot_storage_data['tmp_work_sheet_name']."]. See worksheet [$worksheetname] line $line_counter";
								}
							}
							if($prefix == 'PAR' && $procure_freezing_type) {
								Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Freezing Type for PAR block'][] = "No freezing type should be defined for PAR block. See worksheet [$worksheetname] line $line_counter";
							}
							$new_aliquots[] = array(
								'***aliquot_type***' => 'block',
								'AliquotMaster' => array(
									'barcode' => "$aliquot_label",
									'in_stock' => 'yes - available',
									'storage_datetime' => $aliquot_storage_data['storage_datetime'],
									'storage_datetime_accuracy'	=> $aliquot_storage_data['storage_datetime_accuracy'],
									'storage_master_id' => $aliquot_storage_data['storage_master_id'],
									'storage_coord_x' => $aliquot_storage_data['x'],
									'storage_coord_y' => $aliquot_storage_data['y']),
								'AliquotDetail' => array(
									'block_type' => (($prefix == 'FRZ')? 'frozen' : 'paraffin'),
									'procure_freezing_type' => $procure_freezing_type,
									'procure_dimensions' => $procure_dimensions,
									'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn,
									'procure_classification' => $procure_classification,
									'procure_chus_classification_precision' => $procure_chus_classification_precision,
									'procure_origin_of_slice' => $procure_origin_of_slice,
									'procure_chus_origin_of_slice_precision' => $procure_chus_origin_of_slice_precision
								)
							);
						} else {
							validateNoStorageData($aliquot_label, 'tissue', $summary_msg_title, $worksheetname, $line_counter);						
						}
					}
				}
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime]['Specimens'][0]['Aliquots'] = $new_aliquots;
			} else {
				Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No tissue'][] = "No tissue slide has been collected for PROCURE for patient $patient_identification. No tissue collection will be created. See worksheet [$worksheetname] line $line_counter";
				$tmp_check = $new_line_data;
				unset($tmp_check['Identification']);
				unset($tmp_check['Visite']);
				unset($tmp_check['Date de la chirurgie']);
				unset($tmp_check['Type de chirurgie']);
				if('0N/A' != implode('', $tmp_check)) {
					die("ERR8389393838383. See worksheet [$worksheetname] line $line_counter");
				}
			}			
		}
	}
}
		
function loadBlood($workSheetCells, $filename, $worksheetname, $visit) {
	$tmp_all_blood_config = array(
		array(
			'blood_type' => 'serum',
			'nbr_of_tube_field' => 'Tubes sérum',
			'suffix' => 'SRB',
			'in_stock' => 'no',
			'storage_datetime_fields' => array(),
			'derivatives' => array(
				array(
					'sample_type' => 'serum', 
					'suffix' => 'SER', 
					'max_nbr_of_tube' => 5, 
					'storage_datetime_fields' => array('date' => 'Date de congélation des aliquots de sérum', 'time' => 'Heure de congélation des aliquots de sérum')))),
		array(
			'blood_type' => 'paxgene',
			'nbr_of_tube_field' => 'Tube Paxgene',
			'suffix' => 'RNB',
			'in_stock' => 'yes - available',
			'storage_datetime_fields' => array('date' => 'Date de congélation du tube Paxgene', 'time' => 'Heure de congélation du tube Paxgene'),
			'derivatives' => array()),
		array(
			'blood_type' => 'k2-EDTA',
			'nbr_of_tube_field' => 'Tubes K2-EDTA',
			'suffix' => 'EDB',
			'in_stock' => 'no',
			'storage_datetime_fields' => array(),
			'derivatives' => array(
				array(
					'sample_type' => 'plasma', 
					'suffix' => 'PLA', 
					'max_nbr_of_tube' => 7, 
					'storage_datetime_fields' => array('date' => 'Date de congélation des aliquots de plasma', 'time' => 'Heure de congélation des aliquots de plasma')),
				array(
					'sample_type' => 'pbmc', 
					'suffix' => 'BFC', 
					'max_nbr_of_tube' => 3, 
					'storage_datetime_fields' => array('date' => 'Date de congélation des aliquots de BFC', 'time' => 'Heure de congélation des aliquots de couche lymphocytaire'))
			)
		)
	);
	
	$summary_msg_title = "Blood $visit <br>  File: $filename";
	
	$headers = array();
	$line_counter = 0;
	$duplicated_participant_check = array();
	foreach($workSheetCells as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Identification'];
			if(isset($duplicated_participant_check[$patient_identification]))  die("ERR 89499324 Duplicated participant [$patient_identification]. Check value is not a #REF. See worksheet [$worksheetname] line $line_counter & ".$duplicated_participant_check[$patient_identification]); 
			$duplicated_participant_check[$patient_identification] = $line_counter;
			if($new_line_data['Date de prélèvement du sang'] && !preg_match('/[a-zA-Z]/', $new_line_data['Date de prélèvement du sang'])) {
				if($new_line_data['Visite'] != $visit) die("ERR 89499788344 collection visit error. See worksheet [$worksheetname] line $line_counter");
				// Get collection date
				$tmp_collection_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement du sang'], $new_line_data['Heure'], $summary_msg_title, 'Date de prélèvement du sang', 'Heure', $line_counter);
				$collection_datetime = ($tmp_collection_date? $tmp_collection_date['datetime'] : "''");
				$collection_datetime_accuracy = ($tmp_collection_date? $tmp_collection_date['accuracy'] : "''");
				//Get reception date
				$tmp_reception_date = getDateTimeAndAccuracy($new_line_data['Date de réception du sang'], $new_line_data['Heure de réception du  sang'], $summary_msg_title, 'Date de réception du sang', 'Heure de réception du  sang', $line_counter);
				$reception_datetime = ($tmp_reception_date? $tmp_reception_date['datetime'] : "''");
				$reception_datetime_accuracy = ($tmp_reception_date? $tmp_reception_date['accuracy'] : "''");
				//Get derivativ creation date
				$tmp_derivative_creation_date = getDateTimeAndAccuracy($new_line_data['Date de réception du sang'], '', $summary_msg_title, 'Date de réception du sang', 'none', $line_counter);
				$derivative_creation_datetime = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['datetime'] : "''";
				$derivative_creation_datetime_accuracy = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['accuracy'] : "''";
				// Get BLOOD DNA (FROM PBMC)
				$tmp_pbmc_dna = null;
				if(strlen(str_replace('N/A', '', $new_line_data["DNA::Date d'extraction"].$new_line_data['DNA::Quantité totale (ug)'].$new_line_data["DNA::Volume (uL)"].$new_line_data["DNA::Concentration (ng/µl)"]))) {
					$extraction_date = str_replace('N/A', '', $new_line_data["DNA::Date d'extraction"]);
					$quantity_ug = str_replace('N/A', '', $new_line_data['DNA::Quantité totale (ug)']);
					$volume_ul = str_replace('N/A', '', $new_line_data["DNA::Volume (uL)"]);
					$concentration = str_replace('N/A', '', $new_line_data["DNA::Concentration (ng/µl)"]);
					if(!empty($quantity_ug) && (empty($volume_ul) || empty($concentration))) die("ERR 733s2e11239. See worksheet [$worksheetname] line $line_counter");
					$tmp_pbmc_dna_creation_date = getDateTimeAndAccuracy($extraction_date, '', $summary_msg_title, "DNA::Date d'extraction", 'none', $line_counter);
					$dna_creation_datetime = ($tmp_pbmc_dna_creation_date)? $tmp_pbmc_dna_creation_date['datetime'] : "''";
					$dna_creation_datetime_accuracy = ($tmp_pbmc_dna_creation_date)? $tmp_pbmc_dna_creation_date['accuracy'] : "''";
					if($volume_ul && !preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $volume_ul)) die("ERR 7111435639 : $volume_ul. See worksheet [$worksheetname] line $line_counter");
					if($concentration && !preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $concentration)) die("ERR 7111435639 : $concentration. See worksheet [$worksheetname] line $line_counter");	
					$aliquot_label = "$patient_identification $visit -DNA1";
					$aliquot_storage_data = getStorageData($aliquot_label, 'dna', $summary_msg_title, $worksheetname, $line_counter, $dna_creation_datetime, $dna_creation_datetime_accuracy);
					$tmp_pbmc_dna_aliquots = array('0' => array(
						'***aliquot_type***' => 'tube',
						'AliquotMaster' => array(
							'barcode' => $aliquot_label,
							'in_stock' =>'yes - available',
							'storage_datetime' => $aliquot_storage_data['storage_datetime'],
							'storage_datetime_accuracy'	=> $aliquot_storage_data['storage_datetime_accuracy'],
							'storage_master_id' => $aliquot_storage_data['storage_master_id'],
							'storage_coord_x' => $aliquot_storage_data['x'],
							'storage_coord_y' => $aliquot_storage_data['y'],
							'initial_volume' => $volume_ul,
							'current_volume' => $volume_ul),
						'AliquotDetail' => array(
							'concentration' => $concentration,
							'concentration_unit' => 'ng/ul'),
						'realiquoted_aliquots' => array()
					));
					if(isset(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]['dna'])) {
						foreach(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]['dna'] as $new_dna_aliquot_from_storage) {						
							$new_dna_aliquot = array(
								'***aliquot_type***' => 'tube',
								'AliquotMaster' => array(
									'barcode' => $new_dna_aliquot_from_storage['aliquot_label'],
									'in_stock' =>'yes - available',
									'storage_datetime' => $new_dna_aliquot_from_storage['storage_datetime'],
									'storage_datetime_accuracy'	=> $new_dna_aliquot_from_storage['storage_datetime_accuracy'],
									'storage_master_id' => $new_dna_aliquot_from_storage['storage_master_id'],
									'storage_coord_x' => $new_dna_aliquot_from_storage['x'],
									'storage_coord_y' => $new_dna_aliquot_from_storage['y']),
								'AliquotDetail' => array()
							);
							if($new_dna_aliquot_from_storage['sample_type_precision']) {
								if($new_dna_aliquot_from_storage['sample_type_precision'] == '50 ng/ul') {
									$new_dna_aliquot['AliquotDetail']['concentration'] =  '50';
									$new_dna_aliquot['AliquotDetail']['concentration_unit'] =  'ng/ul';
								} else {
									pr($new_dna_aliquot_from_storage);
									pr($tmp_pbmc_dna);
									die('dna 23 sample_type_precision');
								}
							}
							if($aliquot_storage_data['storage_datetime'] == $new_dna_aliquot_from_storage['storage_datetime'] && $aliquot_storage_data['storage_datetime_accuracy'] == $new_dna_aliquot_from_storage['storage_datetime_accuracy']) {
								$tmp_pbmc_dna_aliquots[] = $new_dna_aliquot;
								Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Additional DNA'][] = "Added aliquot '".$new_dna_aliquot_from_storage['aliquot_label']."' (without volume) to sample of '$aliquot_label'. See worksheet [$worksheetname] line $line_counter";							
							} else {
								$tmp_pbmc_dna_aliquots['0']['realiquoted_aliquots'][] = $new_dna_aliquot;
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Realiquoted DNA'][] = "Added aliquot '".$new_dna_aliquot_from_storage['aliquot_label']."' (without volume) as a realiquoted tube of '$aliquot_label'. See worksheet [$worksheetname] line $line_counter";							
							}
						}
						unset(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]['dna']);
						if(empty(Config::$additional_dna_miR_from_storage[$patient_identification][$visit])) unset(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]);
						if(empty(Config::$additional_dna_miR_from_storage[$patient_identification])) unset(Config::$additional_dna_miR_from_storage[$patient_identification]);
					}
					$tmp_pbmc_dna = array(
						'***tmp_sample_type***' => 'dna',
						'SampleMaster' => array(),
						'SampleDetail' => array(),
						'DerivativeDetail' => array('creation_datetime' => $dna_creation_datetime,	'creation_datetime_accuracy' => $dna_creation_datetime_accuracy),
						'Derivatives' => array(),
						'Aliquots' => $tmp_pbmc_dna_aliquots,
						'QualityCtrl' => array()
					);
				}
				if(strlen($new_line_data["DNA1 (rangement)"])) die("ERR 773883939. See worksheet [$worksheetname] line $line_counter");
				// Get RNA First
				$tmp_paxgene_rna = null;
				if(strlen(str_replace('N/A', '', $new_line_data["RNA::Date d'extraction"].$new_line_data["RNA::Volume (uL)"].$new_line_data["RNA::Concentration (ng/µl)"].$new_line_data["RNA::Quantité totale (ug)"].$new_line_data["RIN"]))) {					
					$extraction_date = str_replace('N/A', '', $new_line_data["RNA::Date d'extraction"]);
					$quantity_ug = str_replace('N/A', '', $new_line_data["RNA::Quantité totale (ug)"]);
					$volume_ul = str_replace('N/A', '', $new_line_data["RNA::Volume (uL)"]);
					$concentration = str_replace('N/A', '', $new_line_data["RNA::Concentration (ng/µl)"]);
					if(!empty($quantity_ug) && (empty($volume_ul) || empty($concentration))) die("ERR 8894994. See worksheet [$worksheetname] line $line_counter");
					$tmp_paxgene_rna_creation_date = getDateTimeAndAccuracy($extraction_date, '', $summary_msg_title, "RNA::Date d'extraction", 'none', $line_counter);
					$rna_creation_datetime = ($tmp_paxgene_rna_creation_date)? $tmp_paxgene_rna_creation_date['datetime'] : "''";
					$rna_creation_datetime_accuracy = ($tmp_paxgene_rna_creation_date)? $tmp_paxgene_rna_creation_date['accuracy'] : "''";
					if($volume_ul && !preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $volume_ul)) die("ERR 9933333329 : $volume_ul. See worksheet [$worksheetname] line $line_counter");
					if($concentration && !preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $concentration)) die("ERR 11039644471 : $concentration. See worksheet [$worksheetname] line $line_counter");
					$aliquot_label = "$patient_identification $visit -RNA1";
					$aliquot_storage_data = getStorageData($aliquot_label, 'rna', $summary_msg_title, $worksheetname, $line_counter, $rna_creation_datetime, $rna_creation_datetime_accuracy);
					$tmp_paxgene_rna_aliquots = array('0' => array(
						'***aliquot_type***' => 'tube',
						'AliquotMaster' => array(
							'barcode' => $aliquot_label,
							'in_stock' =>'yes - available',
							'storage_datetime' => $aliquot_storage_data['storage_datetime'],
							'storage_datetime_accuracy'	=> $aliquot_storage_data['storage_datetime_accuracy'],
							'storage_master_id' => $aliquot_storage_data['storage_master_id'],
							'storage_coord_x' => $aliquot_storage_data['x'],
							'storage_coord_y' => $aliquot_storage_data['y'],
							'initial_volume' => $volume_ul,
							'current_volume' => $volume_ul),
						'AliquotDetail' => array(
							'concentration' => $concentration,
							'concentration_unit' => 'ng/ul',
							'procure_chus_micro_rna' => 'n'),
						'realiquoted_aliquots' => array()
					));
					if(isset(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]['rna'])) {
						foreach(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]['rna'] as $new_rna_aliquot_from_storage) {	
							if(!$new_rna_aliquot_from_storage['sample_type_precision'] || $new_rna_aliquot_from_storage['sample_type_precision'] != 'miRNA') die('ERR838838383883');
							$new_rna_aliquot = array(
								'***aliquot_type***' => 'tube',
								'AliquotMaster' => array(
									'barcode' => $new_rna_aliquot_from_storage['aliquot_label'],
									'in_stock' =>'yes - available',
									'storage_datetime' => $new_rna_aliquot_from_storage['storage_datetime'],
									'storage_datetime_accuracy'	=> $new_rna_aliquot_from_storage['storage_datetime_accuracy'],
									'storage_master_id' => $new_rna_aliquot_from_storage['storage_master_id'],
									'storage_coord_x' => $new_rna_aliquot_from_storage['x'],
									'storage_coord_y' => $new_rna_aliquot_from_storage['y']),
								'AliquotDetail' => array('procure_chus_micro_rna' => 'y')
							);
							if($aliquot_storage_data['storage_datetime'] == $new_rna_aliquot_from_storage['storage_datetime'] && $aliquot_storage_data['storage_datetime_accuracy'] == $new_rna_aliquot_from_storage['storage_datetime_accuracy']) {
								$tmp_paxgene_rna_aliquots[] = $new_rna_aliquot;
								Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Additional micro RNA'][] = "Added aliquot '".$new_rna_aliquot_from_storage['aliquot_label']."' (micro RNA) to sample of '$aliquot_label'. See worksheet [$worksheetname] line $line_counter";							
							} else {
								$tmp_paxgene_rna_aliquots['0']['realiquoted_aliquots'][] = $new_rna_aliquot;
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Realiquoted micro RNA'][] = "Added aliquot '".$new_rna_aliquot_from_storage['aliquot_label']."' (micro RNA) as a realiquoted tube of '$aliquot_label'. See worksheet [$worksheetname] line $line_counter";							
							}
						}
						unset(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]['rna']);
						if(empty(Config::$additional_dna_miR_from_storage[$patient_identification][$visit])) unset(Config::$additional_dna_miR_from_storage[$patient_identification][$visit]);
						if(empty(Config::$additional_dna_miR_from_storage[$patient_identification])) unset(Config::$additional_dna_miR_from_storage[$patient_identification]);
					}
					$tmp_paxgene_rna = array(
							'***tmp_sample_type***' => 'rna',
							'SampleMaster' => array(),
							'SampleDetail' => array(),
							'DerivativeDetail' => array('creation_datetime' => $rna_creation_datetime,	'creation_datetime_accuracy' => $rna_creation_datetime_accuracy),
							'Derivatives' => array(),
							'Aliquots' => $tmp_paxgene_rna_aliquots,
							'QualityCtrl' => array()
					);
					if(str_replace(array('ND','N/A'), array('',''), $new_line_data["RIN"])) {
						if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $new_line_data["RIN"])) die("ERR 33191199115 : ".$new_line_data["RIN"].". See worksheet [$worksheetname] line $line_counter");
						$tmp_paxgene_rna['QualityCtrl'] = array(
							'type' => 'bioanalyzer',
							'unit' => 'RIN',
							'score' => $new_line_data["RIN"]
						);						
					}
				}
				if(strlen($new_line_data["Tube Paxgene deux heures à T pièce"].$new_line_data["RNA1 (rangement)"])) die("ERR 7331839. See worksheet [$worksheetname] line $line_counter");
				
				// ** 1 ** Create collection specimens **
				
				$new_collection_specimens = array();
				foreach($tmp_all_blood_config as $specimen_tubes_and_derivatives_config) {
					$nbr_of_tubes_received = str_replace('N/A', '', $new_line_data[$specimen_tubes_and_derivatives_config['nbr_of_tube_field']]);
					if(!preg_match('/^([0-9]*)$/', $nbr_of_tubes_received)) die("ERR 992839329329. See worksheet [$worksheetname] line $line_counter");
					$new_specimen_and_derivative_data = array(
						'***tmp_sample_type***' => 'blood',
						'SampleMaster' => array(),
						'SampleDetail' => array('blood_type' => $specimen_tubes_and_derivatives_config['blood_type']),
						'SpecimenDetail' => array('reception_datetime' => $reception_datetime,	'reception_datetime_accuracy' => $reception_datetime_accuracy),
						'Derivatives' => array(),
						'Aliquots' => array(),
						'QualityCtrl' => array()
					);
					$tmp_specimen_storage_date = array();
					if(!empty($specimen_tubes_and_derivatives_config['storage_datetime_fields'])) {
						$storage_date_field  = $specimen_tubes_and_derivatives_config['storage_datetime_fields']['date'];
						$storage_time_field  = $specimen_tubes_and_derivatives_config['storage_datetime_fields']['time'];
						$tmp_specimen_storage_date = getDateTimeAndAccuracy($new_line_data[$storage_date_field], $new_line_data[$storage_time_field], $summary_msg_title, $storage_date_field, $storage_time_field, $line_counter);
					}
					for($tube_id = 1; $tube_id <= $nbr_of_tubes_received; $tube_id++) {
						$new_specimen_and_derivative_data['Aliquots'][] = array(
							'***aliquot_type***' => 'tube',
							'AliquotMaster' => array(
								'barcode' => "$patient_identification $visit -".$specimen_tubes_and_derivatives_config['suffix'].$tube_id,
								'in_stock' => $specimen_tubes_and_derivatives_config['in_stock'],
								'storage_datetime' => ($tmp_specimen_storage_date? $tmp_specimen_storage_date['datetime'] : "''"),
								'storage_datetime_accuracy'	=> ($tmp_specimen_storage_date? $tmp_specimen_storage_date['accuracy'] : "''")),
							'AliquotDetail' => array()
						);
					}
					if($specimen_tubes_and_derivatives_config['blood_type'] == 'serum') {
						$aliquot_label = "$patient_identification $visit -WHT1";
						if(strlen($new_line_data['Carte Whatman WHT1']) && $new_line_data['Carte Whatman WHT1'] != 'non' && $new_line_data['Carte Whatman WHT1'] != '0') {
							if(!in_array($new_line_data['Carte Whatman WHT1'], array('oui','1'))) die("ERR 88392932923932. See worksheet [$worksheetname] line $line_counter");
							$aliquot_storage_data = getStorageData($aliquot_label, 'blood', $summary_msg_title, $worksheetname, $line_counter, $reception_datetime, $reception_datetime_accuracy);
							if($aliquot_storage_data['sample_type_precision'] && $aliquot_storage_data['sample_type_precision'] != 'whatman paper') die("ERR 1111111111132923932. See worksheet [$worksheetname] line $line_counter");
							if($aliquot_storage_data['storage_datetime']) {
								$tmp_box_label = utf8_decode('Boîte ').preg_replace('/^1$/', '1-2', $new_line_data["WHT1 (rangement)"]);
								if($new_line_data["WHT1 (rangement)"] && $tmp_box_label != $aliquot_storage_data['tmp_work_sheet_name']) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['WHT box mismatch'][] = "The Whatman Paper box [$tmp_box_label] defined in inventory file is different than this one [".$aliquot_storage_data['tmp_work_sheet_name']."] defined in storage file. See worksheet [$worksheetname] line $line_counter";
							}
							$new_specimen_and_derivative_data['Aliquots'][] = array(
								'***aliquot_type***' => 'whatman paper',
								'AliquotMaster' => array(
									'barcode' => $aliquot_label,
									'in_stock' => 'yes - available',
									'storage_datetime' => $aliquot_storage_data['storage_datetime'],
									'storage_datetime_accuracy'	=> $aliquot_storage_data['storage_datetime_accuracy'],
									'storage_master_id' => $aliquot_storage_data['storage_master_id'],
									'storage_coord_x' => $aliquot_storage_data['x'],
									'storage_coord_y' => $aliquot_storage_data['y']),
								'AliquotDetail' => array()
							);
						} else {
							validateNoStorageData($aliquot_label, 'blood', $summary_msg_title, $worksheetname, $line_counter);
						}		
					} else if($specimen_tubes_and_derivatives_config['blood_type'] == 'paxgene' && $tmp_paxgene_rna) {
						$new_specimen_and_derivative_data['Derivatives'][] = $tmp_paxgene_rna;
						foreach($new_specimen_and_derivative_data['Aliquots'] as &$new_aliquot) $new_aliquot['AliquotMaster']['in_stock'] = 'no';
						$tmp_paxgene_rna = null;
					}
					
					// ** 2 ** Create Derivatives : Plasma Serum PBMC **
					
					foreach($specimen_tubes_and_derivatives_config['derivatives'] as $derivative_config) {
						$tmp_derivative_aliquots = array();
						$storage_date_field  = $derivative_config['storage_datetime_fields']['date'];
						$storage_time_field  = $derivative_config['storage_datetime_fields']['time'];
						$tmp_storage_date = getDateTimeAndAccuracy($new_line_data[$storage_date_field], $new_line_data[$storage_time_field], $summary_msg_title, $storage_date_field, $storage_time_field, $line_counter);
						$storage_datetime = ($tmp_storage_date? $tmp_storage_date['datetime'] : "''");
						$storage_datetime_accuracy = ($tmp_storage_date? $tmp_storage_date['accuracy'] : "''");
						for($tube_id = 1; $tube_id <= $derivative_config['max_nbr_of_tube']; $tube_id++) {
							if($new_line_data[$derivative_config['suffix'].$tube_id.' (rangement)']) die("ERR 774774774. See worksheet [$worksheetname] line $line_counter");
							$aliquot_label = "$patient_identification $visit -".$derivative_config['suffix'].$tube_id;
							$initial_volume = $new_line_data[$derivative_config['suffix'].$tube_id.' (mL)'];
							if(strlen($initial_volume) && $initial_volume != 'N/A' && !preg_match('/^0([\.,][0]+){0,1}$/', $initial_volume)) {
								$aliquot_storage_data = getStorageData($aliquot_label, $derivative_config['sample_type'], $summary_msg_title, $worksheetname, $line_counter, $storage_datetime, $storage_datetime_accuracy);
								if($initial_volume == '?') {
									Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unknown volume'][] = "Volume of ".$derivative_config['sample_type']." tube '$aliquot_label' is unknown. See worksheet [$worksheetname] line $line_counter";
									$initial_volume = '';
								} else if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $initial_volume)) {
									die("ERR 783893939. See worksheet [$worksheetname] line $line_counter");
								}
								$tmp_derivative_aliquots[] =  array(
									'***aliquot_type***' => 'tube',
									'AliquotMaster' => array(
										'barcode' => $aliquot_label,
										'in_stock' =>'yes - available',
										'storage_datetime' => $storage_datetime,
										'storage_datetime_accuracy'	=> $storage_datetime_accuracy,
										'storage_master_id' => $aliquot_storage_data['storage_master_id'],
										'storage_coord_x' => $aliquot_storage_data['x'],
										'storage_coord_y' => $aliquot_storage_data['y'],
										'initial_volume' => $initial_volume,
										'current_volume' => $initial_volume),
									'AliquotDetail' => array()
								);
							} else {
								validateNoStorageData($aliquot_label, $derivative_config['sample_type'], $summary_msg_title, $worksheetname, $line_counter);					
							}
						}
						if(!empty($tmp_derivative_aliquots)) {
							$dna_extractions = array();
							if($derivative_config['sample_type'] == 'pbmc' && $tmp_pbmc_dna) {
								$dna_extractions = array($tmp_pbmc_dna);
								$tmp_pbmc_dna = null;
							}
							$new_specimen_and_derivative_data['Derivatives'][] =array(
								'***tmp_sample_type***' => $derivative_config['sample_type'],
								'SampleMaster' => array(),
								'SampleDetail' => array(),
								'DerivativeDetail' => array('creation_datetime' => $derivative_creation_datetime,	'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy),
								'Derivatives' => $dna_extractions,
								'Aliquots' => $tmp_derivative_aliquots,
								'QualityCtrl' => array()
							);
						} else {
							Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No '.$derivative_config['sample_type']][] = "No ".$derivative_config['sample_type']." has been created for patient $patient_identification. See worksheet [$worksheetname] line $line_counter";					
						}
					} // End pbmc, serum, plasma
					//Record new products
					if(empty($new_specimen_and_derivative_data['Derivatives']) && empty($new_specimen_and_derivative_data['Aliquots'])) {					
						Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No '.$specimen_tubes_and_derivatives_config['blood_type'].' derivative & aliquot'][] = "No ".$specimen_tubes_and_derivatives_config['blood_type']." blood derivative and aliquot have been created for patient $patient_identification. The blood specimen ".$specimen_tubes_and_derivatives_config['blood_type']." won't be created. See worksheet [$worksheetname] line $line_counter";
					} else {
						$new_collection_specimens[] = $new_specimen_and_derivative_data;
						if(!empty($specimen_tubes_and_derivatives_config['derivatives']) && empty($new_specimen_and_derivative_data['Derivatives'])) {
							Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No '.$specimen_tubes_and_derivatives_config['blood_type'].' derivative'][] = "Aliquots have been created for ".$specimen_tubes_and_derivatives_config['blood_type']." blood but no derivative has been created for patient $patient_identification. See worksheet [$worksheetname] line $line_counter";
						}						
					}
				}
				if(!empty($tmp_paxgene_rna))  die("ERR 99218292233. See worksheet [$worksheetname] line $line_counter");
				if(!empty($tmp_pbmc_dna))  die("ERR 9992292233. See worksheet [$worksheetname] line $line_counter");
				if(empty($new_collection_specimens)) die("ERR 990000333. See worksheet [$worksheetname] line $line_counter");
				// Add new collection to array
				if(isset(Config::$participant_collections[$patient_identification][$visit][$collection_datetime])) die("ERR 99000033444433. See worksheet [$worksheetname] line $line_counter");
				Config::$participant_collections[$patient_identification][$visit][$collection_datetime] = array(
					'Collection' => array(
					'participant_id' => '',
					'procure_visit' => $visit,
					'procure_patient_identity_verified' => '1',
					'collection_datetime' => $collection_datetime,
					'collection_datetime_accuracy' => $collection_datetime_accuracy),
					'Specimens' => $new_collection_specimens
				);			
			} else {
				$notes = strtolower(str_replace(array("\n"), array(''), $new_line_data['Date de prélèvement du sang']));
				if(strlen(str_replace(array(' '), array(''), $notes))) {
					if(!in_array($notes, array('refus', 'abandon', 'manqué', 'exclus', '?abandon'))) Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Add note to patient'][] = "No $visit blood collection has been created and a note [$visit.': '.$notes] has been added to participant. See worksheet [$worksheetname] line $line_counter";
					Config::$participant_notes[$patient_identification][] = $visit.' - sang : '.$notes;
				}
				if($visit == 'V01') Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No V01 blood'][] = "No V01 blood has been collected for PROCURE for patient $patient_identification. No blood collection will be created. See worksheet [$worksheetname] line $line_counter";
				$tmp_check = $new_line_data;
				unset($tmp_check['Identification']);
				unset($tmp_check['Visite']);
				unset($tmp_check['Date de prélèvement du sang']);
				$tmp_check = str_replace(array('non','0.00', '0'), array('','',''), implode('', $tmp_check));
				if($tmp_check) {pr($new_line_data);pr($new_line);
					die("ERR838333456. See worksheet [$worksheetname] line $line_counter = ".$new_line_data['Date de prélèvement du sang']);
				}
			}
		}
	}
}

function loadUrine($workSheetCells, $filename, $worksheetname, $visit) {
	$summary_msg_title = "Urine $visit <br>  File: $filename";

	$tmp_all_urine_config = array(
		array(
			'sample_category' => 'specimen',
			'sample_type' => 'urine',
			'aliquot_type' => 'cup',
			'max_nbr_of_tube' => 1,
			'excel_suffix' => 'UNC',
			'suffix' => 'URI'),
		array(
			'sample_category' => 'derivative',
			'sample_type' => 'centrifuged urine',
			'aliquot_type' => 'tube',
			'max_nbr_of_tube' => 3,
			'excel_suffix' => 'URN',
			'suffix' => 'URN'),
		array(
			'sample_category' => 'derivative',
			'sample_type' => 'concentrated urine',
			'aliquot_type' => 'tube',
			'max_nbr_of_tube' => 2,
			'excel_suffix' => 'URC',
			'suffix' => 'URC')
	);
	
	$headers = array();
	$line_counter = 0;
	$duplicated_participant_check = array();
	foreach($workSheetCells as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Identification'];
			if(isset($duplicated_participant_check[$patient_identification]))  die("ERR 89499324 Duplicated participant [$patient_identification]. Check value is not a #REF. See worksheet [$worksheetname] line $line_counter & ".$duplicated_participant_check[$patient_identification]);
			$duplicated_participant_check[$patient_identification] = $line_counter;
			if($new_line_data['Date de prélèvement de urine'] && !preg_match('/[a-zA-Z]/', $new_line_data['Date de prélèvement de urine']) && $new_line_data['Date de prélèvement de urine'] != 'N/A') {
				if($new_line_data['Visite'] != $visit) die("ERR 774888398393 collection visit error. See worksheet [$worksheetname] line $line_counter");
				// Get collection date
				$tmp_collection_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de urine'], $new_line_data['Heure'], $summary_msg_title, 'Date de prélèvement de urine', 'Heure', $line_counter);
				$collection_datetime = ($tmp_collection_date? $tmp_collection_date['datetime'] : "''");
				$collection_datetime_accuracy = ($tmp_collection_date? $tmp_collection_date['accuracy'] : "''");
				//Get reception date
				$tmp_reception_date = getDateTimeAndAccuracy($new_line_data['Date de réception de urine'], $new_line_data['Heure de réception de urine'], $summary_msg_title, 'Date de réception de urine', 'Heure de réception de urine', $line_counter);
				$reception_datetime = ($tmp_reception_date? $tmp_reception_date['datetime'] : "''");
				$reception_datetime_accuracy = ($tmp_reception_date? $tmp_reception_date['accuracy'] : "''");
				//Get derivativ creation date
				$tmp_derivative_creation_date = getDateTimeAndAccuracy($new_line_data['Date de réception de urine'], '', $summary_msg_title, 'Date de réception de urine', 'none', $line_counter);
				$derivative_creation_datetime = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['datetime'] : "''";
				$derivative_creation_datetime_accuracy = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['accuracy'] : "''";
				//Get storage date
				$tmp_storage_date = getDateTimeAndAccuracy($new_line_data['Date de congélation des aliquots de urine'], $new_line_data['Heure de congélation des aliquots de urine'], $summary_msg_title, 'Date de congélation des aliquots de urine', 'Heure de congélation des aliquots de urine', $line_counter);
				$storage_datetime = ($tmp_storage_date? $tmp_storage_date['datetime'] : "''");
				$storage_datetime_accuracy = ($tmp_storage_date? $tmp_storage_date['accuracy'] : "''");
				for($tube_id = 1; $tube_id <= 4; $tube_id++) if($new_line_data['URN'.$tube_id.' (rangement)']) die("ERR 7733334774. See worksheet [$worksheetname] line $line_counter");
				// ** 1 ** Create Urine
				$new_urine_and_derivatives = array(
					'***tmp_sample_type***' => 'urine',
					'SampleMaster' => array(),
					'SampleDetail' => array(),
					'SpecimenDetail' => array('reception_datetime' => $reception_datetime,	'reception_datetime_accuracy' => $reception_datetime_accuracy),
					'Derivatives' => array(),
					'Aliquots' => array(),
					'QualityCtrl' => array()
				);
				// ** 2 ** Aliquots & Derivatives
				foreach($tmp_all_urine_config as $new_urine_sample_config) {
					$tmp_aliquots = array();
					for($tube_id = 1; $tube_id <= $new_urine_sample_config['max_nbr_of_tube']; $tube_id++) {
						$aliquot_label = "$patient_identification $visit -".$new_urine_sample_config['suffix'].$tube_id;
						$initial_volume = $new_line_data[$new_urine_sample_config['excel_suffix'].$tube_id.' (mL)'];
						if(strpos($initial_volume, 'x')) {
							Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Volume format'][] = "The following '".$new_urine_sample_config['sample_type']."' volume format '$initial_volume' is not supported. Aliquots should be created manually. See worksheet [$worksheetname] line $line_counter";
						} else if(strlen($initial_volume) && $initial_volume != 'N/A' && !preg_match('/^0([\.,][0]+){0,1}$/', $initial_volume)) {
							$aliquot_storage_data = getStorageData($aliquot_label, $new_urine_sample_config['sample_type'], $summary_msg_title, $worksheetname, $line_counter, $storage_datetime, $storage_datetime_accuracy);
							if($initial_volume == '?') {
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unknown volume'][] = "Volume of ".$new_urine_sample_config['sample_type']." tube '$aliquot_label' is unknown. See worksheet [$worksheetname] line $line_counter";
								$initial_volume = '';
							} else if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $initial_volume)) {
								die("ERR 0987612334. See worksheet [$worksheetname] line $line_counter");
							}
							$tmp_aliquots[] =  array(
								'***aliquot_type***' => $new_urine_sample_config['aliquot_type'],
								'AliquotMaster' => array(
									'barcode' => $aliquot_label,
									'in_stock' =>'yes - available',
									'storage_datetime' => $storage_datetime,
									'storage_datetime_accuracy'	=> $storage_datetime_accuracy,
									'storage_master_id' => $aliquot_storage_data['storage_master_id'],
									'storage_coord_x' => $aliquot_storage_data['x'],
									'storage_coord_y' => $aliquot_storage_data['y'],
									'initial_volume' => $initial_volume,
									'current_volume' => $initial_volume),
								'AliquotDetail' => array()
							);
						} else {
							validateNoStorageData($aliquot_label, $new_urine_sample_config['sample_type'], $summary_msg_title, $worksheetname, $line_counter);
						}
					}
					if($tmp_aliquots) { 
						if($new_urine_sample_config['sample_category'] == 'specimen') {
							$new_urine_and_derivatives['Aliquots'] = $tmp_aliquots;
						} else {
							$new_urine_and_derivatives['Derivatives'][] = array(
								'***tmp_sample_type***' => $new_urine_sample_config['sample_type'],
								'SampleMaster' => array(),
								'SampleDetail' => array(),
								'DerivativeDetail' => array('creation_datetime' => $derivative_creation_datetime, 'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy),
								'Derivatives' => array(),
								'Aliquots' => $tmp_aliquots,
								'QualityCtrl' => array()	
							);
						}
					}
				}
				// ** 2 ** Urine
				if(empty($new_urine_and_derivatives['Aliquots']) && empty($new_urine_and_derivatives['Derivatives'])) die("ERR 3222 1 1 1. See worksheet [$worksheetname] line $line_counter");

				// ** 3 ** Collection
				if(isset(Config::$participant_collections[$patient_identification][$visit][$collection_datetime])) {
					Config::$participant_collections[$patient_identification][$visit][$collection_datetime]['Specimens'][] = $new_urine_and_derivatives;
					Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Merged specimens into same collection'][] = "Added urine to an existing collection. See patient '$patient_identification' and collection date '$collection_datetime'. See worksheet [$worksheetname] line $line_counter";
				} else {
					Config::$participant_collections[$patient_identification][$visit][$collection_datetime] = array(
						'Collection' => array(
						'participant_id' => '',
						'procure_visit' => $visit,
						'procure_patient_identity_verified' => '1',
						'collection_datetime' => $collection_datetime,
						'collection_datetime_accuracy' => $collection_datetime_accuracy),
						'Specimens' => array($new_urine_and_derivatives)
					);
				}
			} else {
				$notes = strtolower(str_replace(array("\n", 'N/A'), array('', ''), $new_line_data['Date de prélèvement de urine']));
				if(strlen(str_replace(array(' '), array(''), $notes))) {
					if(!in_array($notes, array('refus', 'abandon', 'manqué', 'exclus', '?abandon'))) Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Add note to patient'][] = "No $visit blood collection has been created and a note [$visit.': '.$notes] has been added to participant. See worksheet [$worksheetname] line $line_counter";
					Config::$participant_notes[$patient_identification][] = $visit.' - urine : '.$notes;
				}
				if($visit == 'V01') Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No V01 blood'][] = "No V01 blood has been collected for PROCURE for patient $patient_identification. No blood collection will be created. See worksheet [$worksheetname] line $line_counter";
				$tmp_check = $new_line_data;
				unset($tmp_check['Identification']);
				unset($tmp_check['Visite']);
				unset($tmp_check['Date de prélèvement de urine']);
				$tmp_check = str_replace(array('N/A','0'), array('',''), implode('', $tmp_check));
				if($tmp_check) die("ERR8381133456. See worksheet [$worksheetname] line $line_counter = ".$new_line_data['Date de prélèvement de urine']);
			}
		}
	}
}

function customArrayCombineAndUtf8Encode($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

function getStorageData($aliquot_label, $sample_type, $summary_msg_title, $worksheetname, $line_counter, $storage_datetime_from_inv = null, $storage_datetime_accuracy_from_inv = null) {
	if(!isset(Config::$storage_data_from_sample_type_and_label[$sample_type])) die('ERR 883 883 88 '.$sample_type);
	$res = array(
		'aliquot_label' => '',
		'sample_type' => '',
		'sample_type_precision' => '',
		'storage_datetime' => '',
		'storage_datetime_accuracy' => '',
		'storage_master_id' => '',
		'x' => '',
		'y' => '',
		'tmp_work_sheet_name' => '',
		'tmp_cell_value' => '');
	if(isset(Config::$storage_data_from_sample_type_and_label[$sample_type][$aliquot_label])) {
		$res = Config::$storage_data_from_sample_type_and_label[$sample_type][$aliquot_label][0];
		//Don't display message if Config::$storage_data_from_sample_type_and_label['tissue'][$aliquot_label] contains more than 1 record.
		//Error message already set
		if($storage_datetime_from_inv && $storage_datetime_from_inv != "''" && $res['storage_datetime'] != "''") {
			if(in_array($storage_datetime_accuracy_from_inv, array('y','m','d'))) die("TODO 47848484 See worksheet [$worksheetname] line $line_counter");
			if(in_array($res['storage_datetime_accuracy'], array('y','m','d'))) die("TODO 47848484.2 See worksheet [$worksheetname] line $line_counter");
			if($res['storage_datetime'] != (substr($storage_datetime_from_inv, 0, strpos($storage_datetime_from_inv, ' ')))) {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Storage date mismatch'][] = "Date of storage is set to ".$res['storage_datetime']." in storage excel file (see worksheet ".$res['tmp_work_sheet_name'].") and set to ".substr($storage_datetime_from_inv, 0, strpos($storage_datetime_from_inv, ' '))." in inv excel file for aliquot '$aliquot_label'. See worksheet [$worksheetname] line $line_counter";
			}
		}
		unset(Config::$storage_data_from_sample_type_and_label[$sample_type][$aliquot_label]);
	} else {
		Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No storage data'][] = "Unable to find storage information from storage excel sheets for aliquot '$aliquot_label'. See worksheet [$worksheetname] line $line_counter";
	}
	return $res;
}

function validateNoStorageData($aliquot_label, $sample_type, $summary_msg_title, $worksheetname, $line_counter) {
	if(isset(Config::$storage_data_from_sample_type_and_label[$sample_type][$aliquot_label])) {
		$res = Config::$storage_data_from_sample_type_and_label[$sample_type][$aliquot_label][0];		
		Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Storage info for an aliquot not defined in stock'][] = "A storage information exists in storage excel sheets [worksheet ".$res['tmp_work_sheet_name']." cell(".$res['x']."-".$res['y'].")] for an aliquot '$aliquot_label' that is not in stock or does not exist. See worksheet [$worksheetname] line $line_counter";
		unset(Config::$storage_data_from_sample_type_and_label[$sample_type][$aliquot_label]);
	}
}

function displayUnusedStorageInformation() {
	$v1_file_name = substr(Config::$xls_file_path_collection_v01, (strrpos(Config::$xls_file_path_collection_v01,'/')+1));
	$follow_up_file_name = substr(Config::$xls_file_path_collection_suivi, (strrpos(Config::$xls_file_path_collection_suivi,'/')+1));
	foreach(Config::$storage_data_from_sample_type_and_label as $sample_type => $tmp_aliquots_set) {
		foreach($tmp_aliquots_set as $aliquot_label => $storage_data) {
			$specimen_type = '';
			switch($sample_type) {
				case 'tissue':
					$specimen_type = 'Tissue';
					break;
				case 'blood':
				case 'plasma':
				case 'serum':
				case 'pbmc':
					$specimen_type = 'Blood';
					break;				
				case 'urine':
				case 'centrifuged urine':
				case 'concentrated urine':
					$specimen_type = 'Urine';
					break;	
				case 'rna':
					$specimen_type = 'ARN';
					break;	
				case 'dna':
					$specimen_type = 'ADN';
					break;	
				default:
					die('ERR 84884848484848');
			}
			if($specimen_type) {
				$patient_identification = '';
				$visit = '';
				$sample_label_suffix = '';
				if(preg_match('/^(PS[0-9]P[0-9]{3,5})\ (V0[0-9])\ \-([a-zA-Z]{3}[0-9]{0,2})$/', $aliquot_label, $matches)) {
					$patient_identification = $matches[1];
					$visit = $matches[2];
					$sample_label_suffix = $matches[3];
				} else {
					die('ERR 9993993939 '.$aliquot_label);
				}
				$file_name = ($visit == 'V01')? $v1_file_name : $follow_up_file_name;
				$summary_msg_title = "$specimen_type $visit <br>  File: $file_name";
				if(in_array($sample_label_suffix, array('miR', 'DNA2', 'DNA3'))) {
					die('ERR88993893939');
				} else {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Stored aliquot not found'][] = "The aliquot [$aliquot_label] was defined as stored in storage worksheet [".$storage_data[0]['tmp_work_sheet_name']."] cell [".$storage_data[0]['x']."-".$storage_data[0]['y']."] but no matching aliquot has been found in invetory files (V01 and follwoup).";
				}
			}
		}
	}
	
	$summary_msg_title = 'Storage data <br>  Files: '.
			substr(Config::$xls_file_path_storage_whatman_paper, (strrpos(Config::$xls_file_path_storage_whatman_paper,'/')+1)).
			' & '.
			substr(Config::$xls_file_path_storage_all, (strrpos(Config::$xls_file_path_storage_all,'/')+1));
	foreach(Config::$additional_dna_miR_from_storage as $tmp1) {
		foreach($tmp1 as $tmp2) {
			foreach($tmp2 as $tmp3) {
				foreach($tmp3 as $unrecored_aliquot) {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Stored aliquot not found'][] = "The aliquot [".$unrecored_aliquot['aliquot_label']."] was defined as stored in storage worksheet [".$unrecored_aliquot['tmp_work_sheet_name']."] cell [".$unrecored_aliquot['x']."-".$unrecored_aliquot['y']."] but no matching dna/rna found in invetory files (V01 and follwoup).";
				}
			}
		}
	}
}

//=========================================================================================================
// Collection Record
//=========================================================================================================

function recordParticipantCollection($patient_identification, $participant_id) {
	if(isset(Config::$participant_collections[$patient_identification])) {
		foreach(Config::$participant_collections[$patient_identification] as $visit_key => $new_visit_collections) {
			foreach($new_visit_collections as $date_key => $new_collection) {
				$new_collection['Collection']['participant_id'] = $participant_id;
				recordCollection($new_collection);
			}
		}
		unset(Config::$participant_collections[$patient_identification]);
	}
}

function recordCollection($collection_to_create) {
	$collection_id = customInsertRecord($collection_to_create['Collection'], 'collections');
	foreach($collection_to_create['Specimens'] as $new_specimen_products) {
		$specimen_type = $new_specimen_products['***tmp_sample_type***'];
		if(!isset(Config::$sample_aliquot_controls[$specimen_type])){
			pr($new_specimen_products);
			pr(Config::$sample_aliquot_controls);
			die('ERR 773883393932');
		}
		// To control sample and aliquot types imported
		Config::$sample_aliquot_controls[$specimen_type]['used'] = '1';	
		$additional_data = array(
			'sample_code' =>  getNextSampleCode(),
			'sample_control_id' => Config::$sample_aliquot_controls[$specimen_type]['sample_control_id'],
			'collection_id' => $collection_id,
			'initial_specimen_sample_type' => $specimen_type);
		$sample_master_id = customInsertRecord(array_merge($new_specimen_products['SampleMaster'], $additional_data), 'sample_masters');
		customInsertRecord(array_merge($new_specimen_products['SampleDetail'], array('sample_master_id' => $sample_master_id)), Config::$sample_aliquot_controls[$specimen_type]['detail_tablename'], true);
		customInsertRecord(array_merge($new_specimen_products['SpecimenDetail'], array('sample_master_id' => $sample_master_id)), 'specimen_details', true);

		// Create Derivative
		recordDerivative($collection_id, $sample_master_id, $specimen_type, $sample_master_id, $specimen_type, $new_specimen_products['Derivatives']);
			
		// Create Aliquot
		createAliquot($collection_id, $sample_master_id, $specimen_type, $new_specimen_products['Aliquots']);
		
		if($new_specimen_products['QualityCtrl']) {
			die('ERR TODO99399393');
		}
	}
}

function recordDerivative($collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id, $parent_sample_type, $derivatives_data) {
	foreach($derivatives_data as $new_derivative) {
		$derivative_type = $new_derivative['***tmp_sample_type***'];
		if(!isset(Config::$sample_aliquot_controls[$derivative_type])){
			pr($new_derivative);
			pr(Config::$sample_aliquot_controls);
			die('ERR 773883393931');
		}		
		// To control sample and aliquot types imported
		Config::$sample_aliquot_controls[$derivative_type]['used'] = '1';				
		$additional_data = array(
				'sample_code' => getNextSampleCode(),
				'sample_control_id' => Config::$sample_aliquot_controls[$derivative_type]['sample_control_id'],
				'collection_id' => $collection_id,
				'initial_specimen_sample_id' => $initial_specimen_sample_id,
				'initial_specimen_sample_type' => $initial_specimen_sample_type,
				'parent_id' => $parent_sample_master_id,
				'parent_sample_type' => $parent_sample_type);
		$sample_master_id = customInsertRecord(array_merge($new_derivative['SampleMaster'], $additional_data), 'sample_masters', false);
		customInsertRecord(array_merge($new_derivative['SampleDetail'], array('sample_master_id' => $sample_master_id)), Config::$sample_aliquot_controls[$derivative_type]['detail_tablename'], true);
		customInsertRecord(array_merge($new_derivative['DerivativeDetail'], array('sample_master_id' => $sample_master_id)), 'derivative_details', true);

		// Create Derivative
		recordDerivative($collection_id,$initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $derivative_type, $new_derivative['Derivatives']);

		// Create Aliquot
		createAliquot($collection_id, $sample_master_id, $derivative_type, $new_derivative['Aliquots']);
		
		// Record QC
		if($new_derivative['QualityCtrl']) {
			customInsertRecord(array_merge($new_derivative['QualityCtrl'], array('sample_master_id' => $sample_master_id)), 'quality_ctrls', false);
		}
	}
}

function createAliquot($collection_id, $sample_master_id, $sample_type, $aliquots, $parent_aliquot_master_id = null) {
	foreach($aliquots as $new_aliquot) {
		$aliquot_type = $new_aliquot['***aliquot_type***'];
		if(!isset(Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type])){
			pr($sample_type.'-'.$aliquot_type.'?');
			pr($new_aliquot);
			pr(Config::$sample_aliquot_controls);
			die('ERR 7738833939344');
		}
		// To control sample and aliquot types imported
		Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['used'] = '1';		
		$additional_data = array(
				'collection_id' => $collection_id,
				'aliquot_control_id' => Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['aliquot_control_id'],
				'sample_master_id' => $sample_master_id);
		$aliquot_master_id = customInsertRecord(array_merge($new_aliquot['AliquotMaster'], $additional_data), 'aliquot_masters', false);
		customInsertRecord(array_merge($new_aliquot['AliquotDetail'], array('aliquot_master_id' => $aliquot_master_id)), Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['detail_tablename'], true);
		if($parent_aliquot_master_id) {
			// Create raliquoting data
			$realiquoting_data = array(
				'parent_aliquot_master_id' => $parent_aliquot_master_id, 
				'child_aliquot_master_id' => $aliquot_master_id, 
				'realiquoting_datetime' => $new_aliquot['AliquotMaster']['storage_datetime'],
				'realiquoting_datetime_accuracy' => $new_aliquot['AliquotMaster']['storage_datetime_accuracy']
			);
			customInsertRecord($realiquoting_data, 'realiquotings', false);
		}
		if(isset($new_aliquot['realiquoted_aliquots']) && !empty($new_aliquot['realiquoted_aliquots'])) {
			createAliquot($collection_id, $sample_master_id, $sample_type, $new_aliquot['realiquoted_aliquots'], $aliquot_master_id);
			$query = "UPDATE aliquot_masters SET use_counter = '".count($new_aliquot['realiquoted_aliquots'])."' WHERE id = $aliquot_master_id;";
			mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
			mysqli_query(Config::$db_connection, str_replace('aliquot_masters','aliquot_masters_revs',$query)) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));	
		}
	}
}

function getNextSampleCode() {
	Config::$next_sample_code++;
	return Config::$next_sample_code;
}

