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
			if($new_line_data['Date de la visite'] != 'V01') die("ERR 8949944 Tissue collection visit error. See worksheet [$worksheetname] line $line_counter");
			if($new_line_data['Type de chirurgie']) Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Type de chirurgie'][] = "A 'Type de chirurgie' [".$new_line_data['Type de chirurgie']."] has been defined and won't be imported. Please validate. See worksheet [$worksheetname] line $line_counter";
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
							'SampleMaster' => array(),
							'SampleDetail' => array('procure_number_of_slides_collected_for_procure' => $new_line_data['Nombre de tranches prélevées pour PROCURE']),
							'SpecimenDetail' => array(),
							'Derivatives' => array(),
							'Aliquots' => array()
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
						$procure_dimensions = $new_line_data["$prefix$slide_nbr::".(($prefix == 'FRZ')? "Dimensions (cm x cm x cm)" : "Tranche congelée correspondante")];
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
									'procure_chus_origin_of_slice_precision' => $procure_chus_origin_of_slice_precision)
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
				unset($tmp_check['Date de la visite']);
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
			'storage_datetime_field' => '',
			'derivatives' => array(
				array('sample_type' => 'serum', 'suffix' => 'SER', 'max_nbr_of_tube' => 5, 'storage_datetime_field' => 'Heure de congélation des aliquots de sérum'))),
		array(
			'blood_type' => 'paxgene',
			'nbr_of_tube_field' => 'Tube Paxgene',
			'suffix' => 'RNB',
			'in_stock' => 'yes - available',
			'storage_datetime_field' => "Heure de congélation du tube Paxgene",
			'derivatives' => array()),
		array(
			'blood_type' => 'k2-EDTA',
			'nbr_of_tube_field' => 'Tubes K2-EDTA',
			'suffix' => 'EDB',
			'in_stock' => 'no',
			'storage_datetime_field' => "",
			'derivatives' => array(
				array('sample_type' => 'plasma', 'suffix' => 'PLA', 'max_nbr_of_tube' => 7, 'storage_datetime_field' => 'Heure de congélation des aliquots de plasma'),
				array('sample_type' => 'pbmc', 'suffix' => 'BFC', 'max_nbr_of_tube' => 3, 'storage_datetime_field' => 'Heure de congélation des aliquots de couche lymphocytaire')
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
			if($new_line_data['Date de prélèvement de sang'] && !preg_match('/[a-zA-Z]/', $new_line_data['Date de prélèvement de sang'])) {
				if($new_line_data['Visite'] != $visit) die("ERR 89499788344 collection visit error. See worksheet [$worksheetname] line $line_counter");
				// Get collection date
				$tmp_collection_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de sang'], $new_line_data['Heure'], $summary_msg_title, 'Date de prélèvement de sang', 'Heure', $line_counter);
				$collection_datetime = ($tmp_collection_date? $tmp_collection_date['datetime'] : "''");
				$collection_datetime_accuracy = ($tmp_collection_date? $tmp_collection_date['accuracy'] : "''");
				//Get reception date
				$real_xls_reception_date_field  = 'Date de prélèvement de sang';
				$real_xls_reception_date = $new_line_data['Date de prélèvement de sang'];
				$real_xls_reception_heure = $new_line_data['Heure de réception du  sang'];	
				getRealDateAndTime($real_xls_reception_date, $real_xls_reception_heure, $real_xls_reception_date_field, 'Heure de réception du  sang', $summary_msg_title, $worksheetname, $line_counter);
				$tmp_reception_date = getDateTimeAndAccuracy($real_xls_reception_date, $real_xls_reception_heure, $summary_msg_title, $real_xls_reception_date_field, 'Heure de réception du  sang', $line_counter);
				$reception_datetime = ($tmp_reception_date? $tmp_reception_date['datetime'] : "''");
				$reception_datetime_accuracy = ($tmp_reception_date? $tmp_reception_date['accuracy'] : "''");
				//Get derivativ creation date
				$tmp_derivative_creation_date = getDateTimeAndAccuracy($real_xls_reception_date, '', $summary_msg_title, $real_xls_reception_date_field, 'none', $line_counter);
				$derivative_creation_datetime = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['datetime'] : "''";
				$derivative_creation_datetime_accuracy = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['accuracy'] : "''";

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
						'Aliquots' => array(),
						'Derivatives' => array()
					);
					$tmp_specimen_storage_date = array();
					if(!empty($specimen_tubes_and_derivatives_config['storage_datetime_field'])) {
						$real_xls_storage_date_field  = $real_xls_reception_date_field;
						$real_xls_storage_date = $real_xls_reception_date;
						$real_xls_storage_heure = $new_line_data[$specimen_tubes_and_derivatives_config['storage_datetime_field']];
						getRealDateAndTime($real_xls_storage_date, $real_xls_storage_heure, $real_xls_storage_date_field, $specimen_tubes_and_derivatives_config['storage_datetime_field'], $summary_msg_title, $worksheetname, $line_counter);
						$tmp_specimen_storage_date = getDateTimeAndAccuracy($real_xls_storage_date, $real_xls_storage_heure, $summary_msg_title, $real_xls_storage_date_field, $specimen_tubes_and_derivatives_config['storage_datetime_field'], $line_counter);
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
						if(strlen($new_line_data['Carte Whatman WHT1']) && $new_line_data['Carte Whatman WHT1'] != 'non') {
							if(!in_array($new_line_data['Carte Whatman WHT1'], array('oui','1'))) die("ERR 88392932923932. See worksheet [$worksheetname] line $line_counter");
							$aliquot_storage_data = getStorageData($aliquot_label, 'blood', $summary_msg_title, $worksheetname, $line_counter, $reception_datetime, $reception_datetime_accuracy);
							if($aliquot_storage_data['sample_type_precision'] && $aliquot_storage_data['sample_type_precision'] != 'whatman paper') die("ERR 1111111111132923932. See worksheet [$worksheetname] line $line_counter");
							if($aliquot_storage_data['storage_datetime']) {
								$tmp_box_label = utf8_decode('Boîte ').preg_replace('/^1$/', '1-2', $new_line_data["Boîte d'entreposage"]);
								if($new_line_data["Boîte d'entreposage"] && $tmp_box_label != $aliquot_storage_data['tmp_work_sheet_name']) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['WHT box mismatch'][] = "The Whatman Paper box [$tmp_box_label] defined in inventory file is different than this one [".$aliquot_storage_data['tmp_work_sheet_name']."] defined in storage file. See worksheet [$worksheetname] line $line_counter";
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
					}
					
					// ** 2 ** Create Derivatives : Plasma Serum PBMC **
					
					foreach($specimen_tubes_and_derivatives_config['derivatives'] as $derivative_config) {
						$tmp_derivative_aliquots = array();
						$real_xls_storage_date_field  = $real_xls_reception_date_field;
						$real_xls_storage_date = $real_xls_reception_date;
						$real_xls_storage_heure = $new_line_data[$derivative_config['storage_datetime_field']];
						getRealDateAndTime($real_xls_storage_date, $real_xls_storage_heure, $real_xls_storage_date_field, $derivative_config['storage_datetime_field'], $summary_msg_title, $worksheetname, $line_counter);
						$tmp_storage_date = getDateTimeAndAccuracy($real_xls_storage_date, $real_xls_storage_heure, $summary_msg_title, $real_xls_storage_date_field, $derivative_config['storage_datetime_field'], $line_counter);
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
							$new_specimen_and_derivative_data['Derivatives'][] =array(
								'***tmp_sample_type***' => $derivative_config['sample_type'],
								'SampleMaster' => array(),
								'SampleDetail' => array(),
								'DerivativeDetail' => array('creation_datetime' => $derivative_creation_datetime,	'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy),
								'Derivatives' => array(),
								'Aliquots' => $tmp_derivative_aliquots
							);
						} else {
							Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No '.$derivative_config['sample_type']][] = "No ".$derivative_config['sample_type']." has been created for patient $patient_identification. See worksheet [$worksheetname] line $line_counter";					
						}
					} // End pbmc, serum, plasma
					if(strlen($new_line_data["DNA::Date d'extraction"].$new_line_data['Quantité totale de DNA (ug)'].$new_line_data["DNA::Volume (uL)"])) {
//TODO manage DNA
pr('TODO manage DNA');
//DNA is extracted from PBMC usually the third one
exit;
					}
					if(/*$specimen_tubes_and_derivatives_config['blood_type'] == 'paxgene' && */strlen($new_line_data["RNA::Date d'extraction"].$new_line_data['Quantité totale de RNA (ug)'].$new_line_data["RNA::Volume (uL)"])) {
//TODO manage RNA	
pr('TODO manage RNA');
//RNA is extracted from Paxgene.
//If RNA exists, paxgene tube status is set to 'no'
exit;
					}
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
				$notes = strtolower(str_replace(array("\n"), array(''), $new_line_data['Date de prélèvement de sang']));
				if(strlen(str_replace(array(' '), array(''), $notes))) {
					if(!in_array($notes, array('refus', 'abandon', 'manqué', 'exclus', '?abandon'))) Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Add note to patient'][] = "No $visit blood collection has been created and a note [$visit.': '.$notes] has been added to participant. See worksheet [$worksheetname] line $line_counter";
					Config::$participant_notes[$patient_identification][] = $visit.': '.$notes;
				}
				if($visit == 'V01') Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No V01 blood'][] = "No V01 blood has been collected for PROCURE for patient $patient_identification. No blood collection will be created. See worksheet [$worksheetname] line $line_counter";
				$tmp_check = $new_line_data;
				unset($tmp_check['Identification']);
				unset($tmp_check['Visite']);
				unset($tmp_check['Date de prélèvement de sang']);
				if(implode('', $tmp_check)) {pr($new_line_data);pr($new_line);
					die("ERR838333456. See worksheet [$worksheetname] line $line_counter = ".$new_line_data['Date de prélèvement de sang']);
				}
			}
		}
	}
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

function getRealDateAndTime(&$real_date, &$real_time, &$real_date_field, $time_field, $summary_msg_title, $worksheetname, $line_counter) {
	if(strlen($real_time) && !preg_match('/^0\.[0-9]+$/', $real_time)) {
		if(strtolower($real_time) == 'n/a') {
			$real_time = '';
		} else if(preg_match('/^\ *([0-9]{1,2}\:[0-9]{2})\ *$/', $real_time, $matches)){
			$real_time = $matches[1];
			if(strlen($real_time) == 4) $real_time = '0'.$real_time;
		} else {
			if(preg_match('/^[0-9]+\ (jours|heures)\ \((([0-9]{4}\-[0-9]{2}\-[0-9]{2})\ ([0-9]{1,2}\:[0-9]{2}))\)$/', $real_time, $matches)) {
				$real_date_field  = $time_field;
				$real_date = $matches[3];
				$real_time = $matches[4];
				if(strlen($real_time) == 4) $real_time = '0'.$real_time;
			} else {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Unable to extract date & time'][] = "Unable to extract date & time information from [$real_time] for field '$time_field'. See worksheet [$worksheetname] line $line_counter";
				$real_date = '';
				$real_time = '';
			}
		}
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
				case 'rna':
				case 'dna':
					break;
				case 'blood':
				case 'plasma':
				case 'serum':
				case 'pbmc':
					$specimen_type = 'Blood';
					break;
				case 'urine':
				case 'centrifuged urine':
					break;
				default:
					die('ERR 84884848484848');
			}
			if($specimen_type) {
				$visit = '';
//TODO to review to match exact sample abbreviation			
//TODO complete list
				if(preg_match('/^(PS[0-9]P[0-9]{3,5})\ (V0[0-9])\ \-((FRZ|PAR|SER|PLA|BFC|EDB|RNB|SRB|WHT)[0-9]{0,2})$/', $aliquot_label, $matches)) {
					$visit = $matches[2];
				} else {
					die('ERR 9993993939 '.$aliquot_label);
				}
				$file_name = ($visit == 'V01')? $v1_file_name : $follow_up_file_name;
				$summary_msg_title = "$specimen_type $visit <br>  File: $file_name";
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Stored aliquot not found'][] = "The aliquot [$aliquot_label] was defined as stored in storage worksheet [".$storage_data[0]['tmp_work_sheet_name']."] cell [".$storage_data[0]['x']."-".$storage_data[0]['y']."] but no matching aliquot has been found in invetory files (V01 and follwoup).";
			}
		}
	}
}
	
function loadBloodAndUrine() {	
	die('ERR 88888');
	// Blood and urine
	
	$summary_msg_title = '';
	for($visit_id = 1; $visit_id < 9; $visit_id++) {
		$visit = 'V0'.$visit_id;
		$blood_worksheet = utf8_decode("$visit F3 à F6");
		$urine_worksheet = utf8_decode("$visit F7 à F9");
		
		// Load data from : V0x F3 à F6 == Blood
		
		if(array_key_exists($blood_worksheet, $sheets_nbr))  {

		}
		
		// Load data from : V0x F7 à F9 == Urine
		
		if(array_key_exists($urine_worksheet, $sheets_nbr))  {
			$summary_msg_title = 'Urine '.$visit;
			$headers = array();
			$line_counter = 0;
			foreach($tmp_xls_reader->sheets[$sheets_nbr[$urine_worksheet]]['cells'] as $line => $new_line) {
				$line_counter++;
				if($line_counter == 1) {
					$headers = $new_line;
				} else {
					$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
					$patient_identification = $new_line_data['Identification'];
					if(!empty($new_line_data['Date de prélèvement de urine']) || !empty($new_line_data['Volume total'])) {
						if($new_line_data['Visite'] != $visit) die('ERR 8773899221');
						// Get datetimes
						$tmp_collection_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de urine'], $new_line_data['Heure'], $summary_msg_title, 'Date de prélèvement de urine', 'Heure', $line_counter);
						$collection_datetime = ($tmp_collection_date? $tmp_collection_date['datetime'] : "''");
						$collection_datetime_accuracy = ($tmp_collection_date? $tmp_collection_date['accuracy'] : "''");
											
						$tmp_reception_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de urine'], $new_line_data['Heure de réception de urine'], $summary_msg_title, 'Date de prélèvement de urine', 'Heure de réception de urine', $line_counter);
						$reception_datetime = ($tmp_reception_date? $tmp_reception_date['datetime'] : "''");
						$reception_datetime_accuracy = ($tmp_reception_date? $tmp_reception_date['accuracy'] : "''");
						
						$tmp_derivative_creation_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de urine'], '', $summary_msg_title, 'Date de prélèvement de urine', 'none', $line_counter);
						$derivative_creation_datetime = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['datetime'] : "''";
						$derivative_creation_datetime_accuracy = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['accuracy'] : "''";
						
						$tmp_storage_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de urine'], $new_line_data['Heure de congélation des aliquots'], $summary_msg_title, 'Date de prélèvement de urine', 'Heure de congélation des aliquots', $line_counter);
						$storage_datetime = ($tmp_storage_date? $tmp_storage_date['datetime'] : "''");
						$storage_datetime_accuracy = ($tmp_storage_date? $tmp_storage_date['accuracy'] : "''");
						
						$tmp_urine_details = array();
						$collected_colume = $new_line_data['Volume total'];
						if(strlen($collected_colume)) {
							if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $collected_colume)) die('ERR32232339 '.$line_counter.'/'.'URN'.$tube_id.' '.$collected_colume);
							$tmp_urine_details = array('collected_volume' => $collected_colume, 'collected_volume_unit' => 'ml');
						}
						
						$tmp_derivative_aliquots = array();
						for($tube_id = 1; $tube_id <= 4; $tube_id++) {
							$initial_volume = $new_line_data['URN'.$tube_id.' (mL)'];
							$storage = $new_line_data['URN'.$tube_id.' (rangement)'];
							if(strlen($initial_volume) || strlen($storage)) {
								if(!strlen($initial_volume)) {
									Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Storage with no volume'][] = "No tube volume has been defined but a storage '$storage' has been defined. Tube has been created. See '".'URN'.$tube_id."' at line $line_counter";
								} else if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $initial_volume)) {
									die('ERR 783893939 '.$urine_worksheet.'/'.$line_counter.'/'.'URN'.$tube_id.' initial_volume=['.$initial_volume.']');
								}
								if(!strlen($storage)) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No storage defined'][] = "No tube storage has been defined but volume has been assigned to a tube. Tube has been created. See '".'URN'.$tube_id."' at line $line_counter";
								$tmp_storage_master_data = getStorageData($storage, 'URN', $visit, $summary_msg_title, 'URN'.$tube_id.' (rangement)', $line_counter);
								$tmp_derivative_aliquots[] =  array(
									'***aliquot_type***' => 'tube',
									'AliquotMaster' => array(
										'barcode' => "$patient_identification $visit -URN".$tube_id,
										'in_stock' => 'yes - available',
										'storage_datetime' => $storage_datetime,
										'storage_datetime_accuracy'	=> $storage_datetime_accuracy,
										'storage_master_id' => $tmp_storage_master_data['storage_master_id'],
										'storage_coord_x' => $tmp_storage_master_data['pos_x_into_storage'],
										'storage_coord_y' => $tmp_storage_master_data['pos_y_into_storage'],
										'initial_volume' => $initial_volume,
										'current_volume' => $initial_volume),
									'AliquotDetail' => array()
								);
							}
						}
						
						if(empty($tmp_derivative_aliquots)) die('ERR 78829299292 '.$line_counter);
						$new_urine_and_aliquot_data = array(
								'***tmp_sample_type***' => 'urine',
								'SampleMaster' => array(),
								'SampleDetail' => $tmp_urine_details,
								'SpecimenDetail' => array('reception_datetime' => $reception_datetime,	'reception_datetime_accuracy' => $reception_datetime_accuracy),
								'Aliquots' => array(),
								'Derivatives' => array(array(
									'***tmp_sample_type***' => 'centrifuged urine',
									'SampleMaster' => array(),
									'SampleDetail' => array(),
									'DerivativeDetail' => array('creation_datetime' => $derivative_creation_datetime, 'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy),
									'Aliquots' => $tmp_derivative_aliquots,
									'Derivatives' => array()))
						);
						
						// Add new urine to array
						if(isset(Config::$participant_collections[$patient_identification][$visit][$collection_datetime])) {
							Config::$participant_collections[$patient_identification][$visit][$collection_datetime]['Specimens'][] = $new_urine_and_aliquot_data;
							Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Merged specimens into same collection'][] = "Added urine to an existing collection. See patient '$patient_identification' and collection date '$collection_datetime'. See line: $line_counter";
						} else {
							Config::$participant_collections[$patient_identification][$visit][$collection_datetime] = array(
								'Collection' => array(
										'participant_id' => '',
										'procure_visit' => $visit,
										'procure_patient_identity_verified' => '1',
										'collection_datetime' => $collection_datetime,
										'collection_datetime_accuracy' => $collection_datetime_accuracy),
								'Specimens' => array($new_urine_and_aliquot_data)
							);
						}
					} else {
						Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['No urine data'][] = "No urine collection will be created for patient $patient_identification. See line: $line_counter";
					}
				} // End new excel line
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
	}
}

function createAliquot($collection_id, $sample_master_id, $sample_type, $aliquots) {
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
	}
}

function getNextSampleCode() {
	Config::$next_sample_code++;
	return Config::$next_sample_code;
}

