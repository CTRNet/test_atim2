<?php

function loadCollections() {
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	Config::$participant_collections = array();
	Config::$next_sample_code = 0;
	
	// Load data from : Données clinico-pathologiques
	
	if(!array_key_exists(utf8_decode('Données clinico-pathologiques'), $sheets_nbr)) die("ERROR: Worksheet Tissus Disponible is missing!\n");
	
	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('Données clinico-pathologiques')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Code du Patient'];
			if(isset(Config::$participant_collections[$patient_identification])) die('ERR 890300239 Patient collections already set for patient '.$patient_identification);
			if(!strlen($new_line_data['Date de la chirurgie'])) {
				if(strlen($new_line_data['Chirurgien']) || strlen($new_line_data['Prostate::poids (g)'])) {
					Config::$summary_msg['Tissue V01 Patho']['@@WARNING@@']['No date but surgery data'][] = "Suregry data with no surgery date for partient '$patient_identification'. No tissue collection will be created. See line: $line_counter";
				}
			} else {
				$collection_datetime = "''";
				$collection_datetime_accuracy = "''";
				$collection_date_data = getDateAndAccuracy($new_line_data['Date de la chirurgie'], 'Tissue V01 Patho', 'Date de la chirurgie', $line_counter);
				if($collection_date_data) {
					$collection_datetime = $collection_date_data['date'];
					$collection_datetime_accuracy = str_replace('c','h',$collection_date_data['accuracy']);
				}
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime] = array(
					'Collection' => array(
						'participant_id' => '',
						'procure_visit' => 'V01',
						'procure_patient_identity_verified' => '1',
						'collection_datetime' => $collection_datetime,
						'collection_datetime_accuracy' => $collection_datetime_accuracy,
						'collection_notes' => $new_line_data['Commentaires du pathologiste']),
					'Specimens' => array(
						array(
							'***tmp_sample_type***' => 'tissue',
							'SampleMaster' => array(),
							'SampleDetail' => array('procure_surgeon_name' => $new_line_data['Chirurgien']),
							'SpecimenDetail' => array('reception_datetime' => $collection_datetime,	'reception_datetime_accuracy' => $collection_datetime_accuracy),
							'Derivatives' => array(),
							'Aliquots' => array()
						)
					)
				);
			}
		}
	}
	
	// Load data from : V01 F10 à F15
	
	if(!array_key_exists(utf8_decode('V01 F10 à F15'), $sheets_nbr)) die("ERROR: V01 F10 à F15!\n");
	
	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('V01 F10 à F15')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Identification'];
			if($new_line_data['Date de la visite'] != 'V01') die('ERR 8949944 Tissue collection visit error '.$patient_identification);
			if(strlen($new_line_data['Date de la chirurgie'])) {
				if(!isset(Config::$participant_collections[$patient_identification]['V01'])) die('ERR 89922228344 Patient not defined in patho data '.$patient_identification);
				$collection_datetime = "''";
				$collection_datetime_accuracy = "''";
				$collection_date_data = getDateAndAccuracy($new_line_data['Date de la chirurgie'], 'Tissue V01', 'Date de la visite', $line_counter);
				if($collection_date_data) {
					$collection_datetime = $collection_date_data['date'];
					$collection_datetime_accuracy = str_replace('c','h',$collection_date_data['accuracy']);
				}
				$tmp_keys = array_keys(Config::$participant_collections[$patient_identification]['V01']);
				$collection_datetime_from_previous_worksheet = $tmp_keys[0];
				if($collection_datetime_from_previous_worksheet != $collection_datetime) Config::$summary_msg['Tissue V01']['@@WARNING@@']['Tissue collection date conflict'][] = "Tissue collection date conflict between the 2 worksheets {'Données clinico-pathologiques' = $collection_datetime_from_previous_worksheet} & {'V01 F10 à F15' = $collection_datetime}. Migration will used $collection_datetime_from_previous_worksheet as tissue collection datetime. See patient '$patient_identification' line: $line_counter";
				$collection_datetime = $collection_datetime_from_previous_worksheet;
				$procure_number_of_slides_collected_for_procure = $new_line_data['Nombre de tranches prélevées pour PROCURE'];
				$time_spent_collection_to_freezing_end_mn = $new_line_data["Temps écoulé entre sortie de l'abdomen et congélation (min)"];
				if(!preg_match('/^([0-9]*)$/', $procure_number_of_slides_collected_for_procure)) {
					Config::$summary_msg['Tissue V01']['@@WARNING@@']['Nbr of collected slides'][] = "Number of slides collected for procure is not an integer. See patient '$patient_identification' line: $line_counter";
					$procure_number_of_slides_collected_for_procure = '';
				}
				if(!preg_match('/^([0-9]*)$/', $time_spent_collection_to_freezing_end_mn)) {
					Config::$summary_msg['Tissue V01']['@@WARNING@@']['Time spent : collection to freezing'][] = "Spent time from collection to freezing is not an integer. See patient '$patient_identification' line: $line_counter";
					$time_spent_collection_to_freezing_end_mn = '';
				}
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime]['Specimens'][0]['SampleDetail']['procure_number_of_slides_collected_for_procure'] = $procure_number_of_slides_collected_for_procure;
				$new_aliquots = array();
				foreach(array('FRZ','PAR') as $prefix) {
					for($slide_nbr=1;$slide_nbr<9;$slide_nbr++) {
						$procure_origin_of_slice = $new_line_data["$prefix$slide_nbr::".(($prefix == 'FRZ')? "Origine de la tranche" : "Origine du bloc")];
						$procure_classification =  str_replace('NT','NC',$new_line_data["$prefix$slide_nbr::C, NC, ND"]);
						$procure_dimensions = $new_line_data["$prefix$slide_nbr::".(($prefix == 'FRZ')? "Dimensions (cm x cm x cm)" : "Tranche congelée correspondante")];
						if(strlen($procure_origin_of_slice.$procure_classification.$procure_dimensions)) {
							if(!in_array($procure_origin_of_slice, array('RP','RA','LP','LA', ''))) {
								Config::$summary_msg['Tissue V01']['@@WARNING@@']['Origin of slice'][] = "Origin of slice '$procure_origin_of_slice' is not supported. See patient '$patient_identification' line: $line_counter";
								$procure_origin_of_slice = '';
							}
							if(!in_array($procure_classification, array('C','NC','NC+C','ND',''))) {
								Config::$summary_msg['Tissue V01']['@@WARNING@@']['Block classification'][] = "Block classification '$procure_classification' is not supported. See patient '$patient_identification' line: $line_counter";
								$procure_classification = '';
							}									
							$new_aliquots[] = array(
								'***aliquot_type***' => 'block',
								'AliquotMaster' => array(
									'barcode' => "$patient_identification V01 -$prefix$slide_nbr",
									'in_stock' => 'yes - available',
									'storage_datetime' => "''",
									'storage_datetime_accuracy'	=> "''"),
								'AliquotDetail' => array(
									'procure_dimensions' => $procure_dimensions, 
									'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn,
									'procure_classification' => $procure_classification,
									'procure_origin_of_slice' => $procure_origin_of_slice
								)
							);
						}
					}
				}
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime]['Specimens'][0]['Aliquots'] = $new_aliquots;
			} else {
				Config::$summary_msg['Tissue V01']['@@MESSAGE@@']['No date'][] = "No suregry date for patient $patient_identification. No tissue collection will be created. See line: $line_counter";
				unset(Config::$participant_collections[$patient_identification]);
			}
		}
	}
	
	// Blood and urine
	
	$warning_summary_msg_title = '';
	for($visit_id = 1; $visit_id < 9; $visit_id++) {
		$visit = 'V0'.$visit_id;
		$blood_worksheet = utf8_decode("$visit F3 à F6");
		$urine_worksheet = utf8_decode("$visit F7 à F9");
		
		// Load data from : V0x F3 à F6 == Blood
		
		if(array_key_exists($blood_worksheet, $sheets_nbr))  {
			$tmp_all_blood_config = array(
				array(
					'blood_type' => 'serum',
					'nbr_of_tube_field' => 'Tubes sérum',
					'suffix' => 'SRB',
					'in_stock' => 'no',
					'storage_datetime_field' => '',
					'derivatives' => array(array('sample_type' => 'serum', 'suffix' => 'SER', 'max_nbr_of_tube' => 5, 'storage_datetime_field' => 'Heure de congélation des aliquots de sérum'))),
				array(
					'blood_type' => 'paxgene',
					'nbr_of_tube_field' => 'Tube Paxgene',
					'suffix' => 'RNB',
					'in_stock' => 'no',
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
			$warning_summary_msg_title = 'Blood '.$visit;
			$headers = array();
			$line_counter = 0;
			foreach($tmp_xls_reader->sheets[$sheets_nbr[$blood_worksheet]]['cells'] as $line => $new_line) {
				$line_counter++;
				if($line_counter == 1) {
					$headers = $new_line;
				} else {
					$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
					$patient_identification = $new_line_data['Identification'];
					if(!empty($new_line_data['Date de prélèvement de sang'])) {
						if($new_line_data['Visite'] != $visit) die('ERR 88399819291221');
						// Get datetimes
						$tmp_collection_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de sang'], $new_line_data['Heure'], $warning_summary_msg_title, 'Date de prélèvement de sang', 'Heure', $line_counter);
						$collection_datetime = ($tmp_collection_date? $tmp_collection_date['datetime'] : "''");
						$collection_datetime_accuracy = ($tmp_collection_date? $tmp_collection_date['accuracy'] : "''");
						
						$tmp_reception_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de sang'], $new_line_data['Heure de réception du  sang'], $warning_summary_msg_title, 'Date de prélèvement de sang', 'Heure de réception du  sang', $line_counter);
						$reception_datetime = ($tmp_reception_date? $tmp_reception_date['datetime'] : "''");
						$reception_datetime_accuracy = ($tmp_reception_date? $tmp_reception_date['accuracy'] : "''");
						
						$tmp_derivative_creation_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de sang'], '', $warning_summary_msg_title, 'Date de prélèvement de sang', 'none', $line_counter);
						$derivative_creation_datetime = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['datetime'] : "''";
						$derivative_creation_datetime_accuracy = ($tmp_derivative_creation_date)? $tmp_derivative_creation_date['accuracy'] : "''";
						
						//Create collection specimens
						$new_collection_specimens = array();
						foreach($tmp_all_blood_config as $specimen_tubes_and_derivatives_config) {
							$nbr_of_tubes_received = $new_line_data[$specimen_tubes_and_derivatives_config['nbr_of_tube_field']];
							if(empty($nbr_of_tubes_received)) {
								// No tube of the specimen has been received. Be sure no derivative and aliquot has been created
								$completed_fields = array();
								foreach($specimen_tubes_and_derivatives_config['derivatives'] as $derivative_config) {
									if(strlen($new_line_data[$derivative_config['storage_datetime_field']])) $completed_fields[] = $derivative_config['storage_datetime_field'];
									for($tube_id = 1; $tube_id <= $derivative_config['max_nbr_of_tube']; $tube_id++) {
										if(strlen($new_line_data[$derivative_config['suffix'].$tube_id.' (mL)'])) $completed_fields[] = $derivative_config['suffix'].$tube_id.' (mL)';
										if(strlen($new_line_data[$derivative_config['suffix'].$tube_id.' (rangement)'])) $completed_fields[] = $derivative_config['suffix'].$tube_id.' (rangement)';
									}
								}
								if($specimen_tubes_and_derivatives_config['blood_type'] == 'serum' && $new_line_data['Carte Whatman WHT1'] == 'oui') $completed_fields[] = 'Carte Whatman WHT1';
								if($completed_fields) Config::$summary_msg[$warning_summary_msg_title]['@@WARNING@@']['No specimen tubes but linked data'][] = "No '".$specimen_tubes_and_derivatives_config['blood_type']."' tube has been defined but at least one linked field has been completed. See fields [".implode('|',$completed_fields)."] at line $line_counter";	
							} else {
								if(!preg_match('/^([0-9]+)$/', $nbr_of_tubes_received)) die('ERR 992839329329 '.$line_counter);
								$new_specimen_and_derivative_data = array(
										'***tmp_sample_type***' => 'blood',
										'SampleMaster' => array(),
										'SampleDetail' => array('blood_type' => $specimen_tubes_and_derivatives_config['blood_type']),
										'SpecimenDetail' => array('reception_datetime' => $reception_datetime,	'reception_datetime_accuracy' => $reception_datetime_accuracy),
										'Aliquots' => array(),
										'Derivatives' => array()
								);
								$tmp_specimen_storage_date = empty($specimen_tubes_and_derivatives_config['storage_datetime_field'])? array() : getDateTimeAndAccuracy($new_line_data['Date de prélèvement de sang'], $new_line_data[$specimen_tubes_and_derivatives_config['storage_datetime_field']], $warning_summary_msg_title, 'Date de prélèvement de sang', $specimen_tubes_and_derivatives_config['storage_datetime_field'], $line_counter);
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
								if($specimen_tubes_and_derivatives_config['blood_type'] == 'serum' && strlen($new_line_data['Carte Whatman WHT1'])) {
										if($new_line_data['Carte Whatman WHT1'] != 'oui') die('ERR 88392932923932 '.$new_line_data['Carte Whatman WHT1']);
										$tmp_storage_master_data = getStorageData($new_line_data["Boîte d'entreposage"], 'WHT', $visit, $warning_summary_msg_title, "Boîte d'entreposage", $line_counter);								
										$new_specimen_and_derivative_data['Aliquots'][] = array(
											'***aliquot_type***' => 'whatman paper',
											'AliquotMaster' => array(
												'barcode' => "$patient_identification $visit -WHT1",
												'in_stock' => 'yes - available',
												'storage_datetime' => "''",
												'storage_datetime_accuracy'	=> "''",
												'storage_master_id' => $tmp_storage_master_data['storage_master_id'],
												'storage_coord_x' => $tmp_storage_master_data['pos_x_into_storage'],
												'storage_coord_y' => $tmp_storage_master_data['pos_y_into_storage']),
											'AliquotDetail' => array()
										);
								}
								// Create derivatives
								foreach($specimen_tubes_and_derivatives_config['derivatives'] as $derivative_config) {
									$tmp_derivatvie_aliquots = array();
									$tmp_storage_date = getDateTimeAndAccuracy($new_line_data['Date de prélèvement de sang'], $new_line_data[$derivative_config['storage_datetime_field']], $warning_summary_msg_title, 'Date de prélèvement de sang', $derivative_config['storage_datetime_field'], $line_counter);
									$storage_datetime = ($tmp_storage_date? $tmp_storage_date['datetime'] : "''");
									$storage_datetime_accuracy = ($tmp_storage_date? $tmp_storage_date['accuracy'] : "''");
									for($tube_id = 1; $tube_id <= $derivative_config['max_nbr_of_tube']; $tube_id++) {
										$initial_volume = $new_line_data[$derivative_config['suffix'].$tube_id.' (mL)'];
										$storage = $new_line_data[$derivative_config['suffix'].$tube_id.' (rangement)'];
										if(strlen($initial_volume)) {
											if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $initial_volume)) die('ERR 783893939 '.$line_counter.'/'.$derivative_config['suffix'].$tube_id.' '.$initial_volume);
											if(!strlen($storage)) Config::$summary_msg[$warning_summary_msg_title]['@@WARNING@@']['No storage defined'][] = "No tube storage has been defined but volume has been assigned to a tube. See '".$derivative_config['suffix'].$tube_id."' at line $line_counter";
											$tmp_storage_master_data = getStorageData($storage, $derivative_config['suffix'], $visit, $warning_summary_msg_title, $derivative_config['suffix'].$tube_id.' (rangement)', $line_counter);
											$tmp_derivatvie_aliquots[] =  array(
												'***aliquot_type***' => 'tube',
												'AliquotMaster' => array(
													'barcode' => "$patient_identification $visit -".$derivative_config['suffix'].$tube_id,
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
										} else if(strlen($storage)) {
											Config::$summary_msg[$warning_summary_msg_title]['@@ERROR@@']['Storage with no volume'][] = "No tube volume has been defined but a storage '$storage' has been defined. See '".$derivative_config['suffix'].$tube_id."' at line $line_counter";
										}
									}
									if(!empty($tmp_derivatvie_aliquots)) {
										$new_specimen_and_derivative_data['Derivatives'][] =array(
											'***tmp_sample_type***' => $derivative_config['sample_type'],
											'SampleMaster' => array(),
											'SampleDetail' => array(),
											'DerivativeDetail' => array('creation_datetime' => $derivative_creation_datetime,	'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy),
											'Derivatives' => array(),
											'Aliquots' => $tmp_derivatvie_aliquots
										);
									}
								} // End derivative creation
								if(!empty($specimen_tubes_and_derivatives_config['derivatives']) && empty($new_specimen_and_derivative_data['Derivatives'])) { 
									Config::$summary_msg[$warning_summary_msg_title]['@@ERROR@@']['Missing '.$specimen_tubes_and_derivatives_config['blood_type']][] = "No ".$specimen_tubes_and_derivatives_config['blood_type']." tube volume has been created but blood tube has been defined. See line $line_counter";
								}
								$new_collection_specimens[] = $new_specimen_and_derivative_data;
							}
						}
						if(empty($new_collection_specimens)) die('ERR 990000333' .$line_counter);
						// Add new collection to array
						if(isset(Config::$participant_collections[$patient_identification][$visit][$collection_datetime])) die('TODO : Same blood collection on multi row '.$line_counter);
						Config::$participant_collections[$patient_identification][$visit][$collection_datetime] = array(
							'Collection' => array(
									'participant_id' => '',
									'procure_visit' => $visit,
									'procure_patient_identity_verified' => '1',
									'collection_datetime' => $collection_datetime,
									'collection_datetime_accuracy' => $collection_datetime_accuracy),
							'Specimens' => $new_collection_specimens
						);
					} else if(strlen(str_replace(' ', '', ($new_line_data['Tubes sérum'].$new_line_data['Tubes K2-EDTA'].$new_line_data['Tube Paxgene'].$new_line_data['Tube Paxgene'])))) {
						// No date of collection but at least one speciemn blood tube is defined as received
						pr($new_line_data);
						die('ERR 8899003 '.$line_counter);
					} else {
						Config::$summary_msg[$warning_summary_msg_title]['@@MESSAGE@@']['No blood data'][] = "No blood collection will be created for patient $patient_identification. See line: $line_counter";
					}
					// Check no DNA or RNA data	
					if(!empty($new_line_data['DNA extrait Volume (uL)'])) die("ERR8949393939932 See line: $line_counter");
					if(!empty($new_line_data['Tube Paxgene deux heures à T pièce'])) die("ERR8949393939933 See line: $line_counter");
					if(!empty($new_line_data['RNA extrait Volume (uL)'])) die("ERR8949393939931 See line: $line_counter");
				} // End new excel line
			}
		}
		
		// Load data from : V0x F7 à F9 == Urine
		
		if(array_key_exists($urine_worksheet, $sheets_nbr))  {
			//TODO
		}
	}
	

	pr(Config::$summary_msg);
	
	pr(Config::$participant_collections['PS3P0080']);
	exit;
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

function getStorageData($storage, $sample_suffix, $visit, $warning_summary_msg_title, $field, $line_counter) {
	$res = array('storage_master_id' => '', 'pos_x_into_storage' => '', 'pos_y_into_storage' => '');
	if(!empty($storage)) {
		$storage_key = '';
		switch($sample_suffix) {
			case 'WHT':
				if(!preg_match('/^([0-9]+)$/', $storage)) die('WHT storage ['.$storage.']');
				$storage_key = "box[$sample_suffix $storage](-)";
				break;
				
			case 'SER':
			case 'PLA':
			case 'BFC':
				// storage 2-3-4-1-1-53 freez 2 tablette 3 rack 4 position(1-1) boite VO2 plasma ou serum to 4-4 boite dont tube a position 53
				$tmp_storages = explode('-',$storage);
				if(sizeof($tmp_storages) != 6) { 
					Config::$summary_msg[$warning_summary_msg_title]['@@ERROR@@']['Wrong storage defintion'][] = "Too many values (separated by '-') in storage data. See value '$storage' of field '$field' at line $line_counter";
					return $res;
				}
				if(!preg_match('/^([1234])$/', $tmp_storages[3])) {
					Config::$summary_msg[$warning_summary_msg_title]['@@ERROR@@']['Wrong rack position'][] = "Column ".$tmp_storages[3]." for rack 16 does not exists. See value '$storage' of field '$field' at line $line_counter";
					$tmp_storages[3] = '';
				}
				if(!preg_match('/^([1234])$/', $tmp_storages[4])) {
					Config::$summary_msg[$warning_summary_msg_title]['@@ERROR@@']['Wrong rack position'][] = "Row ".$tmp_storages[4]." for rack 16 does not exists. See value '$storage' of field '$field' at line $line_counter";
					$tmp_storages[4] = '';
				}	
				if(!preg_match('/^([1-9]|[1-9][0-9]|100)$/', $tmp_storages[5]))	{
					Config::$summary_msg[$warning_summary_msg_title]['@@ERROR@@']['Wrong box100 position'][] = "Position ".$tmp_storages[5]." for box100 does not exists. See value '$storage' of field '$field' at line $line_counter";
					$tmp_storages[5] = '';
				}	
				$storage_key = "freezer[".$tmp_storages[0]."](-)|shelf[".$tmp_storages[1]."](-)|rack16[".$tmp_storages[2]."](-)|box100[$sample_suffix $visit](".$tmp_storages[3]."-".$tmp_storages[4].")";
				$res['pos_x_into_storage'] = $tmp_storages[5];
				break;
			default:
				die("ERR 88493939 $storage, $sample_suffix, $visit");
		}
		if(!isset(Config::$storage_id_from_keys[$storage_key])) Config::$storage_id_from_keys[$storage_key] = (sizeof(Config::$storage_id_from_keys) + 1);
		$res['storage_master_id'] = Config::$storage_id_from_keys[$storage_key];
	}
	return $res;
	
// 	$storage_key = $aliquot_description.$storage_control_type.$selection_label;
// 	if(isset($storage_list[$storage_key])) return $storage_list[$storage_key];

	//$storage_control_id = Config::$storage_list[$storage_control_type]['id'];
// 	$master_fields = array(
// 			"code" => "'$next_id'",
// 			"storage_control_id"	=> Config::$storage_controls[$storage_control_type]['storage_control_id'],
// 			"short_label"			=> "'".$selection_label."'",
// 			"selection_label"		=> "'".$selection_label."'",
// 			"lft"		=> "''",
// 			"rght"		=> "''",
// 			"notes" => "'$aliquot_description'"
// 	);
// 	$storage_master_id = customInsertChusRecord($master_fields, 'storage_masters');
// 	customInsertChusRecord(array("storage_master_id" => $storage_master_id), Config::$storage_controls[$storage_control_type]['detail_tablename'], true);

// 	$storage_list[$storage_key] = $storage_master_id;

// 	return $storage_master_id;
}

//=========================================================================================================
// Collections Creation
//=========================================================================================================

function createCollection($collections_to_create) {
	global $next_sample_code;

	foreach($collections_to_create as $new_collection) {
		// treatment_master_id
		$tmp_date = $new_collection['collection']['chus_collection_date'];
		if(!empty($tmp_date) && isset(Config::$breast_surgery_id_from_participant_id[$new_collection['link']['participant_id']][$tmp_date])) {
			if(sizeof(Config::$breast_surgery_id_from_participant_id[$new_collection['link']['participant_id']][$tmp_date]) == 1) {
				$new_collection['link']['treatment_master_id'] = Config::$breast_surgery_id_from_participant_id[$new_collection['link']['participant_id']][$tmp_date][0];
			} else {
				Config::$summary_msg['COLLECTION']['@@WARNING@@']['2 surgeries same date'][] = "See participant_id = ".$new_collection['link']['participant_id'];
			}
		}


		// Create colleciton
		if(!isset($new_collection['collection'])) die('ERR 889940404023');
		if(!isset($new_collection['link'])) die('ERR 889940404023.3');
		$collection_id = customInsertChusRecord(array_merge($new_collection['collection'], $new_collection['link'], array('bank_id' => '1', 'collection_property' => "'participant collection'")), 'collections', false, true);

		if(!isset($new_collection['inventory'])) die('ERR 889940404023.1');
		foreach($new_collection['inventory'] as $specimen_type => $specimen_products_list) {
			foreach($specimen_products_list as $new_specimen_products) {
				$additional_data = array(
						'sample_code' => "'$next_sample_code'",
						'sample_control_id' => Config::$sample_aliquot_controls[$specimen_type]['sample_control_id'],
						'collection_id' => $collection_id,
						'initial_specimen_sample_type' => "'$specimen_type'");
				$sample_master_id = customInsertChusRecord(array_merge($new_specimen_products['sample_masters'], $additional_data), 'sample_masters', false, true);
				customInsertChusRecord(array_merge($new_specimen_products['sample_details'], array('sample_master_id' => $sample_master_id)), Config::$sample_aliquot_controls[$specimen_type]['detail_tablename'], true, true);
				customInsertChusRecord(array_merge($new_specimen_products['specimen_details'], array('sample_master_id' => $sample_master_id)), 'specimen_details', true, true);
				$next_sample_code++;

				// Create Derivative
				createDerivative($collection_id, $sample_master_id, $specimen_type, $sample_master_id, $specimen_type, $new_specimen_products['derivatives']);
					
				// Create Aliquot
				createAliquot($collection_id, $sample_master_id, $specimen_type, $new_specimen_products['aliquots']);
			}
		}
	}
}

function createDerivative($collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id, $parent_sample_type, $derivatives_data) {
	global $next_sample_code;

	foreach($derivatives_data as $derivative_type => $derivatives_list) {
		foreach($derivatives_list as $new_derivative) {
			$additional_data = array(
					'sample_code' => "'$next_sample_code'",
					'sample_control_id' => Config::$sample_aliquot_controls[$derivative_type]['sample_control_id'],
					'collection_id' => $collection_id,
					'initial_specimen_sample_id' => $initial_specimen_sample_id,
					'initial_specimen_sample_type' => "'$initial_specimen_sample_type'",
					'parent_id' => $parent_sample_master_id,
					'parent_sample_type' => "'$parent_sample_type'");
			$sample_master_id = customInsertChusRecord(array_merge($new_derivative['sample_masters'], $additional_data), 'sample_masters', false, true);
			customInsertChusRecord(array_merge($new_derivative['sample_details'], array('sample_master_id' => $sample_master_id)), Config::$sample_aliquot_controls[$derivative_type]['detail_tablename'], true, true);
			customInsertChusRecord(array_merge($new_derivative['derivative_details'], array('sample_master_id' => $sample_master_id)), 'derivative_details', true, true);
			$next_sample_code++;

			// Create Derivative
			createDerivative($collection_id,$initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $derivative_type, $new_derivative['derivatives']);

			// Create Aliquot
			createAliquot($collection_id, $sample_master_id, $derivative_type, $new_derivative['aliquots']);
		}
	}
}

function createAliquot($collection_id, $sample_master_id, $sample_type, $aliquots) {
	global $next_aliquot_code;

	foreach($aliquots as $new_aliquot) {
		$additional_data = array(
				'collection_id' => $collection_id,
				'aliquot_control_id' => Config::$sample_aliquot_controls[$sample_type]['aliquots']['tube']['aliquot_control_id'],
				'sample_master_id' => $sample_master_id,
				'barcode' => $next_aliquot_code);
		$aliquot_master_id = customInsertChusRecord(array_merge($new_aliquot['aliquot_masters'], $additional_data), 'aliquot_masters', false, true);
		customInsertChusRecord(array_merge($new_aliquot['aliquot_details'], array('aliquot_master_id' => $aliquot_master_id)), Config::$sample_aliquot_controls[$sample_type]['aliquots']['tube']['detail_tablename'], true, true);
		$next_aliquot_code++;

		createInternalUse($aliquot_master_id, $new_aliquot['aliquot_internal_uses']);
		createAliquotShipment($aliquot_master_id, $new_aliquot['shippings'], Config::$sample_aliquot_controls[$sample_type]['sample_control_id'], Config::$sample_aliquot_controls[$sample_type]['aliquots']['tube']['aliquot_control_id']);
	}
}
