<?php

/**
 * Script developed to migrate blood and urine collection content of the cusm.
 * 
 * @author Nicolas Luc
 */

//First Line of any main.php file
require_once 'system.php';
displayMigrationTitle('New PROCURE Cusm collection creation', array($excel_file_name));

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}

$procure_bank_id = 3;

global $participants_p_number_to_participant_id;
global $participant_id_to_collected_specimen_per_visit;

$participants_p_number_to_participant_id = array();
$participant_id_to_collected_specimen_per_visit = array();

$created_collection_counter = 0;
$created_sample_counter = 0;
$created_aliquot_counter = 0;

for($visit_id = 1; $visit_id < 11; $visit_id++) {
	if($visit_id < 10) $visit_id = '0'.$visit_id;
	
	//-----------------------------------------------------------------------------------------------------------------
	// BLOOD
	//-----------------------------------------------------------------------------------------------------------------
	
	$tmp_all_blood_config = array(
		array(
			'blood_type' => 'serum',
			'nbr_of_tube_field' => 'Tubes sérum',
			'suffix' => '',
			'in_stock' => '',
			'storage_datetime_field' => '',
			'derivatives' => array(
				array('sample_type' => 'serum', 'suffix' => 'SER', 'max_nbr_of_tube' => 5, 'storage_datetime_field' => 'Heure de congélation des aliquots de sérum'))),
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
			'suffix' => '',
			'in_stock' => '',
			'storage_datetime_field' => "",
			'derivatives' => array(
				array('sample_type' => 'plasma', 'suffix' => 'PLA', 'max_nbr_of_tube' => 7, 'storage_datetime_field' => 'Heure de congélation des aliquots de plasma'),
				array('sample_type' => 'buffy coat', 'suffix' => 'BFC', 'max_nbr_of_tube' => 3, 'storage_datetime_field' => 'Heure de congélation des aliquots de couche lymphocytaire')
			)
		)
	);
	
	$worksheet_name = "V$visit_id F3 à F6";
	$specimen_type = 'blood';
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, utf8_decode($worksheet_name), 1)) {
		$visit_nbr = "V$visit_id";
		
		$identification_excel_key = '';
		if(array_key_exists('Identification', $excel_line_data)) {
			$identification_excel_key = 'Identification';
		} else if(array_key_exists('Identificati0n', $excel_line_data)) {
			$identification_excel_key = 'Identificati0n';
		} else {
			pr($excel_line_data);
			die('ERR 37328238989 2 '.$worksheet_name);
		}
		
		$excel_line_summary = "Participant '".$excel_line_data[$identification_excel_key]." / $visit_nbr Blood Collection / Excel Worksheet '$worksheet_name' & line $line_number";
		if(!$excel_line_data[$identification_excel_key]) {
			recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "Empty Line. Nothing will be migrated. Please validate.", "See $excel_line_summary.");
		} else {
			$patient_identification = $excel_line_data[$identification_excel_key];
			list($participant_id, $existing_participant_blood_collections) = getATiMParticipantIdAndCollectionVisitSpecimens($excel_line_data[$identification_excel_key], $excel_line_summary, $specimen_type);			
			if(!$participant_id) {
				recordErrorAndMessage("Blood - $visit_nbr", '@@ERROR@@', "Unkown participant into ATiM. No collection will be migrated. Please validate.", "See $excel_line_summary.");
			} else {
				if(!strlen($excel_line_data['Visite']) || !strlen($excel_line_data['Date de prélèvement de sang'])) {
					recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "No blood collection defined into Excel for the patient (visit empty or collection date empty). Nothing will be migrated. Please validate.", "See $excel_line_summary.");
					if(array_key_exists($specimen_type, $existing_participant_blood_collections) && array_key_exists($visit_nbr, $existing_participant_blood_collections[$specimen_type])) die("ERR 25487987230923: $excel_line_summary");
				} else if($excel_line_data['Visite'] != $visit_nbr) {
					recordErrorAndMessage("Blood - $visit_nbr", '@@ERROR@@', "Worksheet visit different than visit field value. No collection will be migrated. Please validate.", $excel_line_data['Visite']." (line value) != $visit_nbr (worksheet). See $excel_line_summary.");
				} else {
					if(array_key_exists($specimen_type, $existing_participant_blood_collections) && array_key_exists($visit_nbr, $existing_participant_blood_collections[$specimen_type])) {
						//Collection still created
						recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "Collection still created into ATiM. No data will be created plus no data check will be done. Please validate.", "See $excel_line_summary.");
					} else {
						//Create blood collection
						list($collection_datetime, $collection_datetime_accuracy) 
							= validateAndGetDatetimeAndAccuracy(
								$excel_line_data['Date de prélèvement de sang'], 
								$excel_line_data['Heure'], 
								"Blood - $visit_nbr", 
								"'Date de prélèvement de sang' & 'Heure'", 
								"See $excel_line_summary.");
						$collection_data = array(
							'collections' => array(
								'collection_datetime' => $collection_datetime,
								'collection_datetime_accuracy' => $collection_datetime_accuracy,
								'collection_notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
								'participant_id' => $participant_id,
								'procure_visit' => $visit_nbr,
								'procure_collected_by_bank' => $procure_bank_id
							)
						);
						$collection_id = customInsertRecord($collection_data);
						$created_collection_counter++;
						// Create samples
						list($reception_datetime, $reception_datetime_accuracy) 
							= validateAndGetDatetimeAndAccuracy(
								$excel_line_data['Date de prélèvement de sang'], 
								$excel_line_data['Heure de réception du sang'], 
								"Blood - $visit_nbr", 
								"'Date de prélèvement de sang' & 'Heure de réception du sang'", 
								"See $excel_line_summary.");
						list($derivative_creation_datetime, $derivative_creation_datetime_accuracy) 
						 	= validateAndGetDatetimeAndAccuracy(
						 		$excel_line_data['Date de prélèvement de sang'], 
						 		'', 
						 		"Blood - $visit_nbr", "'Date de prélèvement de sang'", 
						 		"See $excel_line_summary.");
						$created_collection_aliquot = false;
						foreach($tmp_all_blood_config as $specimen_tubes_and_derivatives_config) {
							$nbr_of_tubes_received = $excel_line_data[$specimen_tubes_and_derivatives_config['nbr_of_tube_field']];
							if(empty($nbr_of_tubes_received)) {
								// No tube of the specimen has been received. Be sure no derivative and aliquot has been created
								$completed_fields = array();
								foreach($specimen_tubes_and_derivatives_config['derivatives'] as $derivative_config) {
									if(strlen($excel_line_data[$derivative_config['storage_datetime_field']])) $completed_fields[] = $derivative_config['storage_datetime_field'];
									for($tube_id = 1; $tube_id <= $derivative_config['max_nbr_of_tube']; $tube_id++) {
										if(strlen($excel_line_data[$derivative_config['suffix'].$tube_id.' (mL)'])) $completed_fields[] = $derivative_config['suffix'].$tube_id.' (mL)';
									}
								}
								if($specimen_tubes_and_derivatives_config['blood_type'] == 'serum' && $excel_line_data['Carte Whatman WHT1'] == 'oui') $completed_fields[] = 'Carte Whatman WHT1';
								if($specimen_tubes_and_derivatives_config['blood_type'] == 'paxgene') {
									foreach(array('RNA extrait Volume (uL)','Quantité totale de RNA (ug)','RNA1 (rangement)') as $rna_fields) if(strlen($excel_line_data[$rna_fields])) $completed_fields[] = $rna_fields;
								}
								if($completed_fields) {
									recordErrorAndMessage("Blood - $visit_nbr", '@@ERROR@@', "No specimen tubes but aliquot & derivative data defined into excel. Specimen and derivtive tubes won't be migrated. Please validate.", "See '".$specimen_tubes_and_derivatives_config['blood_type']."' for $excel_line_summary.");
								}
							} else {
								$tubes_msg = '';
								if(!preg_match('/^([0-9]+)$/', $nbr_of_tubes_received)) {
									recordErrorAndMessage("Blood - $visit_nbr", '@@ERROR@@', "Wrong number of tubes value. This number won't be added to note. Please validate.", "See value '$nbr_of_tubes_received' for '".$specimen_tubes_and_derivatives_config['blood_type']."' for $excel_line_summary.");
								} else {
									$tubes_msg = "$nbr_of_tubes_received tubes recevied. ";
								}
								//Create blood specimen
								$sample_data = array(
									'sample_masters' => array(
										'collection_id' => $collection_id,
										'sample_control_id' => $atim_controls['sample_controls']['blood']['id'],
										'initial_specimen_sample_id' => null,
										'initial_specimen_sample_type' => 'bood',
										'parent_id' => null,
										'parent_sample_type' => null,
										'sample_code' => 'tmp_'.($created_sample_counter),
										'notes' => "$tubes_msg Created by migration script on '$import_date'.",
										'procure_created_by_bank' => $procure_bank_id),
									'specimen_details' => array(
										'reception_datetime' => $reception_datetime,	
										'reception_datetime_accuracy' => $reception_datetime_accuracy
									),
									$atim_controls['sample_controls']['blood']['detail_tablename'] => array(
										'blood_type' => $specimen_tubes_and_derivatives_config['blood_type']
									)
								);
								$initial_specimen_sample_id = customInsertRecord($sample_data);
								$created_sample_counter++;
								if($specimen_tubes_and_derivatives_config['suffix']) {
									$storage_datetime = '';
									$storage_datetime_accuracy = '';
									if($specimen_tubes_and_derivatives_config['storage_datetime_field']) {
										list($storage_datetime, $storage_datetime_accuracy) 
											 = validateAndGetDatetimeAndAccuracy(
												$excel_line_data['Date de prélèvement de sang'], 
												$excel_line_data[$specimen_tubes_and_derivatives_config['storage_datetime_field']], 
												"Blood - $visit_nbr", 
												"'Date de prélèvement de sang' & '".$excel_line_data[$specimen_tubes_and_derivatives_config['storage_datetime_field']]."'", 
												"See $excel_line_summary.");
									}
									for($tube_id = 1; $tube_id <= $nbr_of_tubes_received; $tube_id++) {
										$aliquot_data = array(
											'aliquot_masters' => array(
												"barcode" => "$patient_identification $visit_nbr -".$specimen_tubes_and_derivatives_config['suffix'].$tube_id,
												"aliquot_control_id" => $atim_controls['aliquot_controls']['blood-tube']['id'],
												"collection_id" => $collection_id,
												"sample_master_id" => $initial_specimen_sample_id,
												'in_stock' => $specimen_tubes_and_derivatives_config['in_stock'],
												'storage_datetime' => $storage_datetime,
												'storage_datetime_accuracy' => $storage_datetime_accuracy,
												'notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
												'procure_created_by_bank' => $procure_bank_id),
											$atim_controls['aliquot_controls']['blood-tube']['detail_tablename'] => array()
										);
										customInsertRecord($aliquot_data);
										$created_aliquot_counter++;
										$created_collection_aliquot = true;
									}
								}							
								if($specimen_tubes_and_derivatives_config['blood_type'] == 'serum' && strlen($excel_line_data['Carte Whatman WHT1'])) {
									if(!in_array(strtolower($excel_line_data['Carte Whatman WHT1']), array('0ui', 'oui'))) {
										recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "No whatman paper created. Please validate.", "See $excel_line_summary.");
									} else {
										$aliquot_data = array(
											'aliquot_masters' => array(
												"barcode" => "$patient_identification $visit_nbr -WHT1",
												"aliquot_control_id" => $atim_controls['aliquot_controls']['blood-whatman paper']['id'],
												"collection_id" => $collection_id,
												"sample_master_id" => $initial_specimen_sample_id,
												'in_stock' => 'yes - available',
												'notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
												'procure_created_by_bank' => $procure_bank_id),
											$atim_controls['aliquot_controls']['blood-whatman paper']['detail_tablename'] => array()
										);
										customInsertRecord($aliquot_data);
										$created_aliquot_counter++;
										$created_collection_aliquot = true;
									}
								}
								if($specimen_tubes_and_derivatives_config['blood_type'] == 'paxgene' && strlen($excel_line_data['RNA extrait Volume (uL)'].$excel_line_data['Quantité totale de RNA (ug)'].$excel_line_data['RNA1 (rangement)'])) {
									recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "No RNA and DNA extraction will be created by this process. All information should be into Charle's files. Please validate.", "See $excel_line_summary.", '-1');
									//No RNA extraction will be created by this process.
									//All DNA extraction should be into the Charles .xls
								}								
								// Create plasma pbmc serum derivatives
								foreach($specimen_tubes_and_derivatives_config['derivatives'] as $derivative_config) {
									list($storage_datetime, $storage_datetime_accuracy)
										= validateAndGetDatetimeAndAccuracy(
											$excel_line_data['Date de prélèvement de sang'],
											$excel_line_data[$derivative_config['storage_datetime_field']],
											"Blood - $visit_nbr",
											"'Date de prélèvement de sang' & '".$excel_line_data[$derivative_config['storage_datetime_field']]."'",
											"See $excel_line_summary.");
									$sample_data = array(
										'sample_masters' => array(
											'collection_id' => $collection_id,
											'sample_control_id' => $atim_controls['sample_controls'][$derivative_config['sample_type']]['id'],
											'initial_specimen_sample_id' => $initial_specimen_sample_id,
											'initial_specimen_sample_type' => 'bood',
											'parent_id' => $initial_specimen_sample_id,
											'parent_sample_type' => 'bood',
											'sample_code' => 'tmp_'.($created_sample_counter),
											'notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
											'procure_created_by_bank' => $procure_bank_id),
										'derivative_details' => array(
											'creation_datetime' => $derivative_creation_datetime,
											'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy
										),
										$atim_controls['sample_controls'][$derivative_config['sample_type']]['detail_tablename'] => array()
									);
									$derivative_sample_id = customInsertRecord($sample_data);
									$created_sample_counter++;
									$derivative_tube_created = false;
									for($tube_id = 1; $tube_id <= $derivative_config['max_nbr_of_tube']; $tube_id++) {
										$initial_volume = $excel_line_data[$derivative_config['suffix'].$tube_id.' (mL)'];
										$storage = $excel_line_data[$derivative_config['suffix'].$tube_id.' (rangement)'];	//Just to create tube - No position set
										if(strlen($initial_volume) || strlen($storage)) {
											if(!strlen($initial_volume)) {
												recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "Blood derivative tubes created but no volume defined. Please validate.", "See $excel_line_summary.");
											} else if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $initial_volume)) {
												recordErrorAndMessage("Blood - $visit_nbr", '@@ERROR@@', "Wrong initial volume value. Value won't be migrated. Please validate.", "See '$initial_volume' for $excel_line_summary.");
												$initial_volume = '';
											}
											list($storage_datetime, $storage_datetime_accuracy)
												= validateAndGetDatetimeAndAccuracy(
														$excel_line_data['Date de prélèvement de sang'],
														$excel_line_data[$derivative_config['storage_datetime_field']],
														"Blood - $visit_nbr",
														"'Date de prélèvement de sang' & '".$excel_line_data[$derivative_config['storage_datetime_field']]."'",
														"See $excel_line_summary.");
											$aliquot_data = array(
												'aliquot_masters' => array(
													"barcode" => "$patient_identification $visit_nbr -".$derivative_config['suffix'].$tube_id,
													"aliquot_control_id" => $atim_controls['aliquot_controls'][$derivative_config['sample_type'].'-tube']['id'],
													"collection_id" => $collection_id,
													"sample_master_id" => $derivative_sample_id,
													'in_stock' => 'yes - available',
													'initial_volume' => $initial_volume,
													'current_volume' => $initial_volume,
													'storage_datetime' => $storage_datetime,
													'storage_datetime_accuracy' => $storage_datetime_accuracy,
													'notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
													'procure_created_by_bank' => $procure_bank_id),
												$atim_controls['aliquot_controls'][$derivative_config['sample_type'].'-tube']['detail_tablename'] => array()
											);
											customInsertRecord($aliquot_data);
											$created_aliquot_counter++;
											$derivative_tube_created = true;
											$created_collection_aliquot = true;
										}
									}
									$max_nbr_of_tube_plus_1 = $derivative_config['max_nbr_of_tube']+1;
									if(array_key_exists($derivative_config['suffix'].$max_nbr_of_tube_plus_1.' (mL)', $excel_line_data)) {
										$initial_volume = $excel_line_data[$derivative_config['suffix'].$max_nbr_of_tube_plus_1.' (mL)'];
										if(strlen($initial_volume)) {
											recordErrorAndMessage("Blood - $visit_nbr", '@@ERROR@@', "Tube ".$derivative_config['suffix'].$max_nbr_of_tube_plus_1." exists into Excel. Tube has not been imported by the system. Create tube manually after migration.", "See $excel_line_summary.");
										}
									}
									if(!$derivative_tube_created) {
										recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "Blood derivative sample created with no aliquot. Please validate.", "See $excel_line_summary.");
									}
								} // End derivative creation
							}
						}
						if(empty($created_collection_aliquot)) {
							recordErrorAndMessage("Blood - $visit_nbr", '@@WARNING@@', "Blood colelction created with no aliquot. Please validate.", "See $excel_line_summary.");
						}
						//Add visit to control array
						addVisitToCollectionVisitSpecimens($participant_id, $visit_nbr, $specimen_type);
					}
					
				}
			}	
		}
	}
	
	//-----------------------------------------------------------------------------------------------------------------
	// URINE
	//-----------------------------------------------------------------------------------------------------------------
	
	$worksheet_name = "V$visit_id F7 à F9";
	$specimen_type = 'urine';		
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, utf8_decode($worksheet_name), 1)) {
		$visit_nbr = "V$visit_id";
	
		$identification_excel_key = '';
		if(array_key_exists('Identification', $excel_line_data)) {
			$identification_excel_key = 'Identification';
		} else if(array_key_exists('Identificati0n', $excel_line_data)) {
			$identification_excel_key = 'Identificati0n';
		} else {
			pr($excel_line_data);
			die('ERR 37328238989 2 '.$worksheet_name);
		}
	
		$excel_line_summary = "Participant '".$excel_line_data[$identification_excel_key]." / $visit_nbr Urine Collection / Excel Worksheet '$worksheet_name' & line $line_number";
		if(!$excel_line_data[$identification_excel_key]) {
			recordErrorAndMessage("Urine - $visit_nbr", '@@WARNING@@', "Empty Line. Nothing will be migrated. Please validate.", "See $excel_line_summary.");
		} else {
			$patient_identification = $excel_line_data[$identification_excel_key];
			list($participant_id, $existing_participant_urine_collections) = getATiMParticipantIdAndCollectionVisitSpecimens($excel_line_data[$identification_excel_key], $excel_line_summary, $specimen_type);
			if(!$participant_id) {
				recordErrorAndMessage("Urine - $visit_nbr", '@@ERROR@@', "Unkown participant into ATiM. No collection will be migrated. Please validate.", "See $excel_line_summary.");
			} else {
				if(!strlen($excel_line_data['Visite']) || !strlen($excel_line_data['Date de prélèvement de urine'])) {
					recordErrorAndMessage("Urine - $visit_nbr", '@@WARNING@@', "No urine collection defined into Excel for the patient (visit empty or collection date empty). Nothing will be migrated. Please validate.", "See $excel_line_summary.");
					if(array_key_exists($specimen_type, $existing_participant_urine_collections) && array_key_exists($visit_nbr, $existing_participant_urine_collections[$specimen_type])) die("ERR 25487987230923: $excel_line_summary");
				} else if($excel_line_data['Visite'] != $visit_nbr) {
					recordErrorAndMessage("Urine - $visit_nbr", '@@ERROR@@', "Worksheet visit different than visit field value. No collection will be migrated. Please validate.", $excel_line_data['Visite']." (line value) != $visit_nbr (worksheet). See $excel_line_summary.");
				} else {
					if(array_key_exists($specimen_type, $existing_participant_urine_collections) && array_key_exists($visit_nbr, $existing_participant_urine_collections[$specimen_type])) {
						//Collection still created
						recordErrorAndMessage("Urine - $visit_nbr", '@@WARNING@@', "Collection still created into ATiM. No data will be created plus no data check will be done. Please validate.", "See $excel_line_summary.");
					} else {
						$created_collection_aliquot = false;
						//Create urine collection
						list($collection_datetime, $collection_datetime_accuracy)
							= validateAndGetDatetimeAndAccuracy(
								$excel_line_data['Date de prélèvement de urine'],
								$excel_line_data['Heure'],
								"Urine - $visit_nbr",
								"'Date de prélèvement de urine' & 'Heure'",
								"See $excel_line_summary.");
						$collection_data = array(
							'collections' => array(
								'collection_datetime' => $collection_datetime,
								'collection_datetime_accuracy' => $collection_datetime_accuracy,
								'collection_notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
								'participant_id' => $participant_id,
								'procure_visit' => $visit_nbr,
								'procure_collected_by_bank' => $procure_bank_id
							)
						);
						$collection_id = customInsertRecord($collection_data);
						$created_collection_counter++;
						// Create samples
						list($reception_datetime, $reception_datetime_accuracy)
							= validateAndGetDatetimeAndAccuracy(
								$excel_line_data['Date de prélèvement de urine'],
								$excel_line_data['Heure de réception de urine'],
								"Urine - $visit_nbr",
								"'Date de prélèvement de urine' & 'Heure de réception de urine'",
								"See $excel_line_summary.");
						list($derivative_creation_datetime, $derivative_creation_datetime_accuracy)
							= validateAndGetDatetimeAndAccuracy(
								$excel_line_data['Date de prélèvement de urine'],
								'',
								"Urine - $visit_nbr", "'Date de prélèvement de urine'",
								"See $excel_line_summary.");
						//Create urine specimen
						$collected_volume = $excel_line_data['Volume total'];
						if(strlen($collected_volume)) {
							if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $collected_volume)) {
								recordErrorAndMessage("Urine - $visit_nbr", '@@ERROR@@', "Wrong urine volume format. Volume won't be migrated. Please validate.", "See $excel_line_summary.");
								$collected_volume = '';
							}
						}
						$sample_data = array(
							'sample_masters' => array(
								'collection_id' => $collection_id,
								'sample_control_id' => $atim_controls['sample_controls']['urine']['id'],
								'initial_specimen_sample_id' => null,
								'initial_specimen_sample_type' => 'urine',
								'parent_id' => null,
								'parent_sample_type' => null,
								'sample_code' => 'tmp_'.($created_sample_counter),
								'notes' => "Created by migration script on '$import_date'.",
								'procure_created_by_bank' => $procure_bank_id),
							'specimen_details' => array(
								'reception_datetime' => $reception_datetime,
								'reception_datetime_accuracy' => $reception_datetime_accuracy
							),
							$atim_controls['sample_controls']['urine']['detail_tablename'] => array(
								'collected_volume' => $collected_volume,
								'collected_volume_unit' => 'ml'
							)
						);
						$initial_specimen_sample_id = customInsertRecord($sample_data);
						$created_sample_counter++;
						//Create centrifuged urine
						$sample_data = array(
							'sample_masters' => array(
								'collection_id' => $collection_id,
								'sample_control_id' => $atim_controls['sample_controls']['centrifuged urine']['id'],
								'initial_specimen_sample_id' => $initial_specimen_sample_id,
								'initial_specimen_sample_type' => 'urine',
								'parent_id' => $initial_specimen_sample_id,
								'parent_sample_type' => 'urine',
								'sample_code' => 'tmp_'.($created_sample_counter),
								'notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
								'procure_created_by_bank' => $procure_bank_id),
							'derivative_details' => array(
								'creation_datetime' => $derivative_creation_datetime,
								'creation_datetime_accuracy' => $derivative_creation_datetime_accuracy
							),
							$atim_controls['sample_controls']['centrifuged urine']['detail_tablename'] => array()
						);
						$derivative_sample_id = customInsertRecord($sample_data);
						$created_sample_counter++;
						//Create centrifuged urine aliquot			
						$derivative_tube_created = false;
						for($tube_id = 1; $tube_id <= 4; $tube_id++) {
							$initial_volume = $excel_line_data["URN$tube_id (mL)"];
							$storage = $excel_line_data["URN$tube_id (rangement)"];	//Just to create tube - No position set
							if(strlen($initial_volume) || strlen($storage)) {
								if(!strlen($initial_volume)) {
									recordErrorAndMessage("Urine - $visit_nbr", '@@WARNING@@', "Urine derivative tubes created but no volume defined. Please validate.", "See $excel_line_summary.");
								} else if(!preg_match('/^([0-9]+)([,\.][0-9]+){0,1}$/', $initial_volume)) {
									recordErrorAndMessage("Urine - $visit_nbr", '@@ERROR@@', "Wrong initial volume value. Value won't be migrated. Please validate.", "See '$initial_volume' for $excel_line_summary.");
									$initial_volume = '';
								}
								list($storage_datetime, $storage_datetime_accuracy)
									= validateAndGetDatetimeAndAccuracy(
										$excel_line_data['Date de prélèvement de urine'],
										$excel_line_data["Heure de congélation des aliquots"],
										"Urine - $visit_nbr",
										"'Date de prélèvement de urine' & 'Heure de congélation des aliquots'",
										"See $excel_line_summary.");
								$aliquot_data = array(
									'aliquot_masters' => array(
										"barcode" => "$patient_identification $visit_nbr -URN".$tube_id,
										"aliquot_control_id" => $atim_controls['aliquot_controls']['centrifuged urine-tube']['id'],
										"collection_id" => $collection_id,
										"sample_master_id" => $derivative_sample_id,
										'in_stock' => 'yes - available',
										'initial_volume' => $initial_volume,
										'current_volume' => $initial_volume,
										'storage_datetime' => $storage_datetime,
										'storage_datetime_accuracy' => $storage_datetime_accuracy,
										'notes' => "Created by migration script on '".substr ($import_date, 0, 10)."'.",
										'procure_created_by_bank' => $procure_bank_id),
									$atim_controls['aliquot_controls']['centrifuged urine-tube']['detail_tablename'] => array()
								);
								customInsertRecord($aliquot_data);					
								$created_aliquot_counter++;
								$derivative_tube_created = true;
								$created_collection_aliquot = true;
							}
						}
						if(array_key_exists("URN5 (mL)", $excel_line_data)) {
							$initial_volume = $excel_line_data["URN5 (mL)"];
							if(strlen($initial_volume)) {
								recordErrorAndMessage("Urine - $visit_nbr", '@@ERROR@@', "Tube URN5 exists into Excel. Tube has not been imported by the system. Create tube manually after migration.", "See $excel_line_summary.");
							}
						}
						if(!$derivative_tube_created) {
							recordErrorAndMessage("Urine - $visit_nbr", '@@WARNING@@', "Urine derivative sample created with no aliquot. Please validate.", "See $excel_line_summary.");
						}						
						if(empty($created_collection_aliquot)) {
							recordErrorAndMessage("Urine - $visit_nbr", '@@WARNING@@', "Urine colelction created with no aliquot. Please validate.", "See $excel_line_summary.");
						}
						//Add visit to control array
						addVisitToCollectionVisitSpecimens($participant_id, $visit_nbr, $specimen_type);
					}
						
				}
			}
		}
	}
}

recordErrorAndMessage("Collection Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_collection_counter collections");
recordErrorAndMessage("Collection Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_sample_counter  samples");
recordErrorAndMessage("Collection Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_aliquot_counter aliquots");

$final_queries = array(
	"UPDATE sample_masters SET initial_specimen_sample_id = id WHERE parent_id IS NULL;",
	"UPDATE sample_masters SET sample_code = id WHERE sample_code LIKE 'tmp_%';",
	"UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE 'tmp__%';",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($final_queries as $new_query) customQuery($new_query);

insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function getATiMParticipantIdAndCollectionVisitSpecimens($participant_number, $excel_line_summary, $specimen_type) {
	global $participants_p_number_to_participant_id;
	global $participant_id_to_collected_specimen_per_visit;
	
	if(!isset($participants_p_number_to_participant_id[$participant_number])) {
		
		// Get pariticpant_id
		
		$query = "SELECT id FROM participants WHERE participant_identifier = '$participant_number' AND deleted <> 1;";
		$atim_participant_data = getSelectQueryResult($query);
		if(!$atim_participant_data) {
			return array(null, array());
		} else if(sizeof($atim_participant_data) > 1) {
			die("ERR 83838733774 [$participant_number] / $excel_line_summary");
		} else {
			$participants_p_number_to_participant_id[$participant_number] = $atim_participant_data[0]['id'];
		}
		
		// Get ATiM collection data
		
		$query = "SELECT DISTINCT Collection.procure_visit, SampleControl.sample_type
			FROM Collections Collection
			INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id
			INNER JOIN sample_controls SampleControl ON SampleControl.id = SampleMaster.sample_control_id
			WHERE participant_id = ".$participants_p_number_to_participant_id[$participant_number]."
			AND SampleControl.sample_category = 'specimen'
			AND SampleMaster.deleted <> 1";
		$participant_id_to_collected_specimen_per_visit[$participants_p_number_to_participant_id[$participant_number]] = array();
		foreach(getSelectQueryResult($query) as $new_collection) {
			$participant_id_to_collected_specimen_per_visit[$participants_p_number_to_participant_id[$participant_number]][$new_collection['sample_type']][$new_collection['procure_visit']] = 'ATiM';
		}
	}
	
	return array(
		$participants_p_number_to_participant_id[$participant_number],
		$participant_id_to_collected_specimen_per_visit[$participants_p_number_to_participant_id[$participant_number]]
	);
}

function addVisitToCollectionVisitSpecimens($participant_id, $visit, $specimen_type) {
	global $participant_id_to_collected_specimen_per_visit;
	if(!isset($participant_id_to_collected_specimen_per_visit[$participant_id])) die('ERR 237 6287623 ');
	$participant_id_to_collected_specimen_per_visit[$participant_id][$specimen_type][$visit] = 'Excel';
}

?>
		