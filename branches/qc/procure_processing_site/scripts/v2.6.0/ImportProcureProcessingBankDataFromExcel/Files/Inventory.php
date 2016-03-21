<?php

function getParticipantIdAndSite($participant_identifier, $procure_participant_attribution_number, $file_name, $worksheet, $line_counter) {
	global $import_summary;
	global $import_date;
	global $participant_identifiers_check;
	global $patients_to_import;
	
	if(!preg_match('/^PS([0-9])P[0-9]{4}$/', $participant_identifier, $matches)) {
		$import_summary['Patient Creation']['@@ERROR@@']["Wrong Patient Identifiers Format"][] = "The format of the participant_identifier '$participant_identifier' is wrong. No patient will be created. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
		return array(null, null);
	}
	if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) {
		return array(null, null);
	}	
	//Get Site From participant_identifier
	$site_id = $matches[1];
	//Get Participant Id
	if(isset($participant_identifiers_check['participant_identifier_to_id'][$participant_identifier]) && isset($participant_identifiers_check['procure_participant_attribution_number_to_id'][$procure_participant_attribution_number])) {
		if($participant_identifiers_check['participant_identifier_to_id'][$participant_identifier] == $participant_identifiers_check['procure_participant_attribution_number_to_id'][$procure_participant_attribution_number]) {
			//Existing Patient
			return array($participant_identifiers_check['participant_identifier_to_id'][$participant_identifier], $site_id);
		} else {
			//Linked to 2 differents patients
			$import_summary['Patient Creation']['@@ERROR@@']["A Patient Identifiers Seams To Be Linked To 2 Different Attribution # in Excel Files"][] = "Check Attribution # linked to patient participant_identifier = '$participant_identifier' in all excel file. No sample of the line will be created. Please check data integrity. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
		}
	} else if(!isset($participant_identifiers_check['participant_identifier_to_id'][$participant_identifier])
	&& !isset($participant_identifiers_check['procure_participant_attribution_number_to_id'][$procure_participant_attribution_number])) {
		//New Patient
		$data = array(
			'participant_identifier' => $participant_identifier,
			'procure_participant_attribution_number' => $procure_participant_attribution_number,
			'last_modification' => $import_date,
			'procure_last_modification_by_bank' => 'p'
		);
		$participant_id = customInsert($data, 'participants', __FILE__, __LINE__);
		$participant_identifiers_check['participant_identifier_to_id'][$participant_identifier] = $participant_id;
		$participant_identifiers_check['procure_participant_attribution_number_to_id'][$procure_participant_attribution_number] = $participant_id;
		return array($participant_id, $site_id);	
	} else if(isset($participant_identifiers_check['participant_identifier_to_id'][$participant_identifier])) { 
		$import_summary['Patient Creation']['@@ERROR@@']["The Patient Identifiers Is Already Linked To Another procure_participant_attribution_number"][] = "The patient participant_identifier = '$participant_identifier' is already linked to a procure_participant_attribution_number different than '$procure_participant_attribution_number'. No new patient will be created then no sample. Please check data integrity. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
		return array(null, null);
	} else {
		$import_summary['Patient Creation']['@@ERROR@@']["The Attribution # Is Already Linked To Another Patient Identifiers"][] = "The patient Attribution # = '$procure_participant_attribution_number' is already linked to a participant_identifier different than '$participant_identifier'. No new patient will be created then no sample. Please check data integrity. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
		return array(null, null);
	}
}

function loadPlasma(&$XlsReader, $files_path, $file_name, $study_summary_id) {
	global $import_summary;
	global $controls;
	global $created_collections_and_specimens;
	
	//==============================================================================================
	//FRSQ-Innovant Order
	//==============================================================================================
	
	$study = 'FRSQ-Innovant - Plasma';
	$order_id = customInsert(array('order_number' => $study, 'default_study_summary_id' => $study_summary_id, 'processing_status' => 'completed'), 'orders', 'No File', '-1');
	$shipment_id = customInsert(array('shipment_code' =>$study, 'order_id' => $order_id), 'shipments', 'No File', '-1');
	$order_items_template = array('aliquot_master_id' => null, 'order_id' => $order_id, 'shipment_id' => $shipment_id, 'status' => 'shipped');
	
	//==============================================================================================
	//Plasma
	//==============================================================================================
	
	$plasma_already_created = array();
	
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	$storage_control = $controls['storage_controls'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//Load Data
	$headers = array();
	$worksheet = "Plasma";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['patient BB']) {
				$participant_identifier = $new_line_data['patient BB'];
				list($participant_id, $site_id) = getParticipantIdAndSite($participant_identifier, $new_line_data['patient Attri'],$file_name, $worksheet, $line_counter);
				if($participant_id) {
					if(!isset($created_collections_and_specimens[$participant_identifier])) $created_collections_and_specimens[$participant_identifier] = array('participant_id' => $participant_id, 'collections' => array());
					if($new_line_data['Volume plasma 1.1 (ul)'] || $new_line_data['Volume plasma 1.2 (ul)'] || $new_line_data['Volume plasma 1.3 (ul)']) {
						foreach(array('1','2','3') as $tube_nbr) {
							$realiquoted_plasma_tube_barcode = $new_line_data['plasma 1.'.$tube_nbr];
							$realiquoted_plasma_tube_volume = getInteger($new_line_data, 'Volume plasma 1.'.$tube_nbr.' (ul)', 'Inventory - Plasma', $file_name, $line_counter);
							if($realiquoted_plasma_tube_volume) {
								if(preg_match('/^(PLA[0-9])\.'.$tube_nbr.'(V[0-9]{2})\-([0-9]{4})$/', $realiquoted_plasma_tube_barcode, $matches)) {
									$source_tube_suffix = $matches[1];
									$visit = $matches[2];
									$procure_participant_attribution_number_from_barcode = ltrim($matches[3], "0");
									if($new_line_data['patient Attri'] != $procure_participant_attribution_number_from_barcode) {
										$import_summary['Inventory - Plasma']['@@WARNING@@']["Wrong 'patient Attri' of the barcode"][] = "The 'patient Attri' written into the tube barcode ($procure_participant_attribution_number_from_barcode) does not match this one defined into the excel file (".$new_line_data['patient Attri']."). Please validate. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
									}
									//Collection
									if(!isset($created_collections_and_specimens[$participant_identifier]['collections'][$visit])) {
										$collection_data = array(
											'participant_id' => $participant_id,
											'procure_visit' => $visit,
											'procure_collected_by_bank' => $site_id);
										$created_collections_and_specimens[$participant_identifier]['collections'][$visit] = array('id' => customInsert($collection_data, 'collections', __FILE__, __LINE__), 'specimens' => array());
									}
									$collection_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['id'];
									//Blood
									if(!isset($created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'])) {
										$sample_data_to_record = array(
											'SampleMaster' => array(
												'collection_id' => $collection_id,
												'sample_control_id' =>$sample_aliquot_controls['blood']['sample_control_id'],
												'initial_specimen_sample_type' => 'blood',
												'procure_created_by_bank' => 's'),
											'SpecimenDetail' => array(),
											'SampleDetail' => array());
										$created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'] = createSample($sample_data_to_record, $sample_aliquot_controls['blood']['detail_tablename']);
									}
									$blood_sample_master_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'] ;
									//Plasma
									$plasma_sample_system_identifier = "$participant_identifier $visit -$source_tube_suffix";
									if(!isset($plasma_already_created[$plasma_sample_system_identifier])) {
										$sample_data_to_record = array(
											'SampleMaster' => array(
												'collection_id' => $collection_id,
												'sample_control_id' =>$sample_aliquot_controls['plasma']['sample_control_id'],
												'initial_specimen_sample_type' => 'blood',
												'initial_specimen_sample_id' => $blood_sample_master_id,
												'parent_sample_type' => 'blood',
												'parent_id' => $blood_sample_master_id,
												'sample_code' => "$source_tube_suffix ($participant_identifier $visit)",
												'procure_created_by_bank' => $site_id),
											'DerivativeDetail' => array(),
											'SampleDetail' => array());
										$plasma_already_created[$plasma_sample_system_identifier] = array('sample_master_id' => createSample($sample_data_to_record, $sample_aliquot_controls['plasma']['detail_tablename']), 'aliquots' => array());
									}
									$plasma_sample_master_id = $plasma_already_created[$plasma_sample_system_identifier]['sample_master_id'];
									//Tube received from bank
									$source_tube_aliquot_barcode = $plasma_sample_system_identifier;
									if(!isset($plasma_already_created[$plasma_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode])) {
										$aliquot_data =  array(
											'AliquotMaster' => array(
												'collection_id' => $collection_id,
												'sample_master_id' => $plasma_sample_master_id,
												'aliquot_control_id' => $sample_aliquot_controls['plasma']['aliquots']['tube']['aliquot_control_id'],
												'barcode' => $source_tube_aliquot_barcode,
												'in_stock' => 'no',
												'use_counter' => '0',
												'procure_created_by_bank' => $site_id),
											'AliquotDetail' => array());
										$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
										$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
										customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['plasma']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
										$plasma_already_created[$plasma_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode] = $aliquot_master_id;
										//Aliquot Use
										$aliquot_internal_use_data = array(
											'aliquot_master_id' => $aliquot_master_id,
											'type' => 'received from bank',
											'use_code' => 'PS'.$site_id,
											'procure_created_by_bank' => 'p');
										customInsert($aliquot_internal_use_data, 'aliquot_internal_uses', __FILE__, __LINE__);
									}
									$source_aliquot_master_id = $plasma_already_created[$plasma_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode];
									//New tube created
									if(!isset($plasma_already_created[$plasma_sample_system_identifier]['aliquots'][$realiquoted_plasma_tube_barcode])) {
										$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data["plasma 1.$tube_nbr box"], 'plasma', 'Inventory - Plasma', $file_name, $worksheet, $line_counter);
										$storage_coordinates = getPosition($participant_identifier, $new_line_data["plasma 1.$tube_nbr position"], $new_line_data["plasma 1.$tube_nbr box"], 'plasma', 'Inventory - Plasma', $file_name, $worksheet, $line_counter);
										$aliquot_data = array(
											'AliquotMaster' => array(
												'collection_id' => $collection_id,
												'sample_master_id' => $plasma_sample_master_id,
												'aliquot_control_id' => $sample_aliquot_controls['plasma']['aliquots']['tube']['aliquot_control_id'],
												'barcode' => $realiquoted_plasma_tube_barcode,
												'in_stock' => (($tube_nbr == 1)? 'no': 'yes - available'),
												'in_stock_detail' => (($tube_nbr == 1)? 'shipped': ''),
												'initial_volume' => ($realiquoted_plasma_tube_volume/1000),
												'current_volume' => ($realiquoted_plasma_tube_volume/1000),
												'use_counter' => '0',
												'storage_master_id' => (($tube_nbr == 1)? null : $storage_master_id),
												'storage_coord_x' => (($tube_nbr == 1)? null : $storage_coordinates['x']),
												'storage_coord_y' => (($tube_nbr == 1)? null : $storage_coordinates['y']),
												'procure_created_by_bank' => 'p'),
											'AliquotDetail' => array());
										$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
										$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
										customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['plasma']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
										$plasma_already_created[$plasma_sample_system_identifier]['aliquots'][$realiquoted_plasma_tube_barcode] = $aliquot_master_id;	
										//Realiquoting
										customInsert(array('parent_aliquot_master_id' => $source_aliquot_master_id, 'child_aliquot_master_id' => $aliquot_master_id), 'realiquotings', __FILE__, __LINE__);
										//Orders
										if($tube_nbr == 1) customInsert(array_merge($order_items_template, array('aliquot_master_id' => $aliquot_master_id)), 'order_items', __FILE__, __LINE__);
									} else {
										$import_summary['Inventory - Plasma']['@@ERROR@@']["Duplicated created plasma tube"][] = "The barcode '$realiquoted_plasma_tube_barcode' is defined twice into the excel file. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
									}
								} else {
									$import_summary['Inventory - Plasma']['@@ERROR@@']["Wrong created plasma tube format"][] = "The system is not able to extract information from the barcode of a plasma tube created : '$realiquoted_plasma_tube_barcode'. No aliquot will be created. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
								}
							}
						}
					} else {
						$import_summary['Inventory - Plasma']['@@MESSAGE@@']["No plasma created"][] = "No plasma defined as received and processed. No plasma will be created for Patient '$participant_identifier'. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					}
				}
			} else if($new_line_data['plasma 1.1']) {
				$import_summary['System Error']['@@ERROR@@']["99999991"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}	
}

function loadUrine(&$XlsReader, $files_path, $file_name, $study_summary_id) {
	global $import_summary;
	global $controls;
	global $created_collections_and_specimens;

	//==============================================================================================
	//FRSQ-Innovant Order
	//==============================================================================================

	$study = 'FRSQ-Innovant - Urine';
	$order_id = customInsert(array('order_number' => $study, 'default_study_summary_id' => $study_summary_id, 'processing_status' => 'completed'), 'orders', 'No File', '-1');
	$shipment_id = customInsert(array('shipment_code' => $study, 'order_id' => $order_id), 'shipments', 'No File', '-1');
	$order_items_template = array('aliquot_master_id' => null, 'order_id' => $order_id, 'shipment_id' => $shipment_id, 'status' => 'shipped');

	//==============================================================================================
	//Urine
	//==============================================================================================

	$centrifuged_urine_already_created = array();

	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	$storage_control = $controls['storage_controls'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//Load Data
	$box_label = '';
	$box_row = 0;
	$headers = array();
	$worksheet = "Urine";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			if(strlen($new_line_data['Box'])) {
				$box_label = $new_line_data['Box'];
				$box_row = 1;
			} else if($box_row) {
				$box_row++;
			}
			if($new_line_data['Patient']) {
				$participant_identifier = $new_line_data['Patient'];
				list($participant_id, $site_id) = getParticipantIdAndSite($participant_identifier, $new_line_data['# attribution'],$file_name, $worksheet, $line_counter);
				if($participant_id) {
					if(!isset($created_collections_and_specimens[$participant_identifier])) $created_collections_and_specimens[$participant_identifier] = array('participant_id' => $participant_id, 'collections' => array());
					//Tube received when date set
					$creation_date = getDateAndAccuracy($new_line_data, 'Date', 'Inventory - Urine', $file_name, $line_counter);
					$creation_date['accuracy'] = str_replace('c', 'h', $creation_date['accuracy']);
					if($creation_date['date']) {
						if(!$new_line_data['Québec'] && !$new_line_data['# aliquots au CUSM']) {
							//At least one data should be set
							$import_summary['System Error']['@@ERROR@@']["99593922"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						} else if(empty($new_line_data['Identification des aliquots'])) {
							$import_summary['System Error']['@@ERROR@@']["99999992"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						} else {
							if(preg_match('/^(URN[0-9])\.1(V01)\-([0-9]{4})$/', $new_line_data['Identification des aliquots'], $matches)) {
								$source_tube_suffix = $matches[1];
								$visit = $matches[2];
								$procure_participant_attribution_number_from_barcode = ltrim($matches[3], "0");
								$created_tube_barcode_format = "$source_tube_suffix.%%id%%V01-".$matches[3];
								if($new_line_data['# attribution'] != $procure_participant_attribution_number_from_barcode) {
									$import_summary['Inventory - Urine']['@@WARNING@@']["Wrong '# attribution' of the barcode"][] = "The '# attribution' written into the tube barcode ($procure_participant_attribution_number_from_barcode) does not match this one defined into the excel file (".$new_line_data['# attribution']."). Please validate. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
								}
								//Collection
								if(!isset($created_collections_and_specimens[$participant_identifier]['collections'][$visit])) {
									$collection_data = array(
										'participant_id' => $participant_id,
										'procure_visit' => $visit,
										'procure_collected_by_bank' => $site_id);
									$created_collections_and_specimens[$participant_identifier]['collections'][$visit] = array('id' => customInsert($collection_data, 'collections', __FILE__, __LINE__), 'specimens' => array());
								}
								$collection_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['id'];
								//Urine
								if(!isset($created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['urine'])) {
									$sample_data_to_record = array(
										'SampleMaster' => array(
											'collection_id' => $collection_id,
											'sample_control_id' =>$sample_aliquot_controls['urine']['sample_control_id'],
											'initial_specimen_sample_type' => 'urine',
											'procure_created_by_bank' => 's'),
										'SpecimenDetail' => array(),
										'SampleDetail' => array());
									$created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['urine'] = createSample($sample_data_to_record, $sample_aliquot_controls['urine']['detail_tablename']);
								}
								$urine_sample_master_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['urine'] ;
								//Centrifuged urine
								$centrifuged_urine_sample_system_identifier = "$participant_identifier $visit -$source_tube_suffix";
								if(!isset($centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier])) {
									$sample_data_to_record = array(
										'SampleMaster' => array(
											'collection_id' => $collection_id,
											'sample_control_id' =>$sample_aliquot_controls['centrifuged urine']['sample_control_id'],
											'initial_specimen_sample_type' => 'urine',
											'initial_specimen_sample_id' => $urine_sample_master_id,
											'parent_sample_type' => 'urine',
											'parent_id' => $urine_sample_master_id,
											'sample_code' => "$source_tube_suffix ($participant_identifier $visit)",
											'procure_created_by_bank' => $site_id),
										'DerivativeDetail' => array(),
										'SampleDetail' => array());
									$centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier] = array('sample_master_id' => createSample($sample_data_to_record, $sample_aliquot_controls['centrifuged urine']['detail_tablename']), 'aliquots' => array());
								}
								$centrifuged_urine_sample_master_id = $centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier]['sample_master_id'];
								//Tube received from bank
								$source_tube_aliquot_barcode = $centrifuged_urine_sample_system_identifier;
								if(!isset($centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode])) {
									$aliquot_data =  array(
										'AliquotMaster' => array(
											'collection_id' => $collection_id,
											'sample_master_id' => $centrifuged_urine_sample_master_id,
											'aliquot_control_id' => $sample_aliquot_controls['centrifuged urine']['aliquots']['tube']['aliquot_control_id'],
											'barcode' => $source_tube_aliquot_barcode,
											'in_stock' => 'no',
											'use_counter' => '0',
											'procure_created_by_bank' => $site_id),
										'AliquotDetail' => array());
									$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['centrifuged urine']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									$centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode] = $aliquot_master_id;
									//Aliquot Use
									$aliquot_internal_use_data = array(
											'aliquot_master_id' => $aliquot_master_id,
											'type' => 'received from bank',
											'use_code' => 'PS'.$site_id,
											'procure_created_by_bank' => 'p');
									customInsert($aliquot_internal_use_data, 'aliquot_internal_uses', __FILE__, __LINE__);
								}
								$source_aliquot_master_id = $centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode];
								//New tubes created
								$last_aliquot_volume = getInteger($new_line_data, 'Volume du dernier aliquot (ul)', 'Inventory - Urine', $file_name, $line_counter);
								$shipped_tube = false;
								if($new_line_data['Québec']) {
									$shipped_tube = true;
									if($new_line_data['Québec'] != $procure_participant_attribution_number_from_barcode) {
										$import_summary['Inventory - Urine']['@@WARNING@@']["Wrong 'Québec' value"][] = "The 'Québec' value '".$new_line_data['Québec']."' is different than the procure_participant_attribution_number_from_barcode '$procure_participant_attribution_number_from_barcode'. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
									}
								}
								$stored_tube_nbr = getInteger($new_line_data, '# aliquots au CUSM', 'Inventory - Urine', $file_name, $line_counter);
								$tubes_nbr_to_create = ($shipped_tube? 1 : 0) + ($stored_tube_nbr? $stored_tube_nbr : 0);
								$box_column = 0;
								for($tube_id = 1; $tube_id <= $tubes_nbr_to_create; $tube_id++) {
									if(!$shipped_tube) $box_column++;
									$realiquoted_centrifuged_urine_tube_barcode = str_replace('%%id%%', $tube_id, $created_tube_barcode_format);
									if(!isset($centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier]['aliquots'][$realiquoted_centrifuged_urine_tube_barcode])) {
										$storage_master_id = null;
										$storage_coordinates = array('x'=>null, 'y'=>null);
										if(!$shipped_tube) {
											$storage_master_id = getStorageMasterId($participant_identifier, $box_label, 'centrifuged urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
											if(!$storage_master_id) {
												$import_summary['Inventory - Urine']['@@WARNING@@']["No storage"][] = "No storage si defined for the urine tube of the patient '$participant_identifier'. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
											} else if($box_row > 10) {
												$import_summary['Inventory - Urine']['@@ERROR@@']['Wrong storage row'][] = "The system is trying to store aliquot '$realiquoted_centrifuged_urine_tube_barcode' in row $box_row of the box '$box_label'. No position will be set. Please check. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
												$storage_master_id = null;
											} else if($box_column > 10) {
												$import_summary['Inventory - Urine']['@@WARNING@@']['Wrong storage column'][] = "The system is trying to store aliquot '$realiquoted_centrifuged_urine_tube_barcode' in column $box_column of the box '$box_label'. No position will be set. Please check. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
												$storage_master_id = null;
											} else {
												$storage_coordinates['x'] = ($box_row-1)*10 + $box_column;
											}
										}
										$aliquot_data = array(
											'AliquotMaster' => array(
												'collection_id' => $collection_id,
												'sample_master_id' => $centrifuged_urine_sample_master_id,
												'aliquot_control_id' => $sample_aliquot_controls['centrifuged urine']['aliquots']['tube']['aliquot_control_id'],
												'barcode' => $realiquoted_centrifuged_urine_tube_barcode,
												'in_stock' => ($shipped_tube? 'no': 'yes - available'),
												'in_stock_detail' => ($shipped_tube? 'shipped': ''),
												'initial_volume' => (($tube_id == $tubes_nbr_to_create)? ($last_aliquot_volume/1000) : 1),
												'current_volume' => (($tube_id == $tubes_nbr_to_create)? ($last_aliquot_volume/1000) : 1),
												'use_counter' => '0',
												'storage_master_id' => $storage_master_id,
												'storage_coord_x' => $storage_coordinates['x'],
												'storage_coord_y' => $storage_coordinates['y'],
												'procure_created_by_bank' => 'p'),
											'AliquotDetail' => array());
										$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
										$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
										customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['centrifuged urine']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
										$centrifuged_urine_already_created[$centrifuged_urine_sample_system_identifier]['aliquots'][$realiquoted_centrifuged_urine_tube_barcode] = $aliquot_master_id;
										//Realiquoting
										customInsert(array('parent_aliquot_master_id' => $source_aliquot_master_id, 'child_aliquot_master_id' => $aliquot_master_id, 'realiquoting_datetime' => $creation_date['date'], 'realiquoting_datetime_accuracy' => $creation_date['accuracy']), 'realiquotings', __FILE__, __LINE__);
										//Orders
										if($shipped_tube) customInsert(array_merge($order_items_template, array('aliquot_master_id' => $aliquot_master_id)), 'order_items', __FILE__, __LINE__);
										$shipped_tube = false;
									} else {
										$import_summary['Inventory - Urine']['@@ERROR@@']["Duplicated created centrifuged urine tube"][] = "The barcode '$realiquoted_centrifuged_urine_tube_barcode' is defined twice into the excel file. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
									}								
								}
							} else {
								$import_summary['Inventory - Urine']['@@ERROR@@']["Wrong created urine tube format"][] = "The system is not able to extract information from the barcode of a created urine tube : '".$new_line_data['Identification des aliquots']."'. No urine tube will be created. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							}
						}
					} else {
						if(strlen($new_line_data['Date'])) {
							$import_summary['Inventory - Urine']['@@WARNING@@']["No urine created but a date value is set"][] = "No urine defined as recieved and processed (based on Date field empty) but date field seams to not be empty. No urine will be created for Patient '$participant_identifier'. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						} else {
							$import_summary['Inventory - Urine']['@@MESSAGE@@']["No urine created"][] = "No urine defined as recieved and processed (based on Date field empty). No urine will be created for Patient '$participant_identifier'. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
					}
				}
			} else if($new_line_data['Québec'] || $new_line_data['# aliquots au CUSM']) {
				$import_summary['System Error']['@@ERROR@@']["99999993"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}
}

function loadDnaMismatch(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	
	//Load Worksheet Names
	
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	$mismath_dnas = array();
	
	$headers = array();
	$worksheet = "Data";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['Nouvelle identification (x = aliquot)']) {
				$dna_sample_label = str_replace(' ', '', $new_line_data['Nouvelle identification (x = aliquot)']);
				if(preg_match('/^DNA([0-9x\+]{1,3})\.x(V[0-9]{2})\-([0-9]{4})$/', $dna_sample_label, $matches_dna_label)) {
					$mismath_dnas[$dna_sample_label] = false;
				} else {
					$import_summary['Inventory - DNA Mismatch']['@@WARNING@@']["Wrong 'Nouvelle identification (x = aliquot)' format"][] = "The 'Nouvelle identification (x = aliquot)' value '".$new_line_data['Nouvelle identification (x = aliquot)']."' is not supported. Aliquot won't be flagged as sent to 'Mismatch'. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				}
			} else {
				$import_summary['System Error']['@@ERROR@@']["933339977"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}
	
	$headers = array();
	$worksheet = "Aliquots + Emplacement";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 2) {
			$headers = $new_line;
		} else if($line_counter > 2){
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['Identif.']) {
				$dna_sample_label = str_replace(' ', '', $new_line_data['Identif.']);
				if(preg_match('/^DNA([0-9x\+]{1,3})\.x(V[0-9]{2})\-([0-9]{4})$/', $dna_sample_label, $matches_dna_label)) {
					if(!array_key_exists($dna_sample_label, $mismath_dnas)) {
						$import_summary['Inventory - DNA Mismatch']['@@ERROR@@']["Label defined in 'Identif.' but not defined in 'Nouvelle identification (x = aliquot)'"][] = "See '$dna_sample_label'. Aliquot won't be flagged as sent to 'Mismatch'. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					} else {
						$mismath_dnas[$dna_sample_label] = true;
					}
				} else {
					$import_summary['Inventory - DNA Mismatch']['@@WARNING@@']["Wrong 'Identif.' format"][] = "The 'Identif.' value '".$new_line_data['Identif.']."' is not supported. Double check won't be done. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				}
			} else {
				$import_summary['System Error']['@@ERROR@@']["933339978"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}
	
	foreach($mismath_dnas as $dna_sample_label => $flag) {
		if(!$flag) {
			$import_summary['Inventory - DNA Mismatch']['@@ERROR@@']["Label defined in 'Nouvelle identification (x = aliquot)' but not defined in 'Identif.'"][] = "See '$dna_sample_label'. Double check failed. [file <b>$file_name</b>]";
		}
		$mismath_dnas[$dna_sample_label] = false;
	}
	
	return $mismath_dnas;
}


function loadDna(&$XlsReader, $files_path, $file_name, $study_summary_ids, $dna_mismatches) {
	global $import_summary;
	global $controls;
	global $created_collections_and_specimens;

	//==============================================================================================
	//FRSQ-Innovant Order
	//==============================================================================================

	$study = 'FRSQ-Innovant - Dna';
	$order_id = customInsert(array('order_number' => $study, 'default_study_summary_id' => $study_summary_ids['FRSQ-Innovant'] , 'processing_status' => 'completed'), 'orders', 'No File', '-1');
	$shipment_id = customInsert(array('shipment_code' =>$study, 'order_id' => $order_id), 'shipments', 'No File', '-1');
	$frsq_innovant_order_items_template = array('aliquot_master_id' => null, 'order_id' => $order_id, 'shipment_id' => $shipment_id, 'status' => 'shipped');

	//==============================================================================================
	//Mismatch Order
	//==============================================================================================

	$study = 'Mismatch - Dna';
	$order_id = customInsert(array('order_number' => $study, 'default_study_summary_id' => $study_summary_ids['Mismatch'] , 'processing_status' => 'completed'), 'orders', 'No File', '-1');
	$shipment_id = customInsert(array('shipment_code' =>$study, 'order_id' => $order_id), 'shipments', 'No File', '-1');
	$mismatch_order_items_template = array('aliquot_master_id' => null, 'order_id' => $order_id, 'shipment_id' => $shipment_id, 'status' => 'shipped');

	//==============================================================================================
	//DNA
	//==============================================================================================
	
	$dna_samples_created = array();

	// Control
	
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	$storage_control = $controls['storage_controls'];
	
	//Load Worksheet Names
	
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	//Load Data Qc
	
	$dna_samples_data_from_excel = array();
	
	$headers = array();
	$worksheet = "Data";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){		
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['Nouvelle identification (x = aliquot)']) {
				$dna_sample_label = str_replace(' ', '', $new_line_data['Nouvelle identification (x = aliquot)']);
				if(preg_match('/^DNA([0-9x\+]{1,3})\.x(V[0-9]{2})\-([0-9]{4})$/', $dna_sample_label, $matches_dna_label)) {
					$visit = $matches_dna_label[2];
					$procure_participant_attribution_number = ltrim($matches_dna_label[3], "0");
					if(!preg_match('/^(PS[1-4])[\ ]*(P[0-9]{4})[\ ]*(V[0-9]{2})[\ ]*DNA$/', $new_line_data['Identification'], $matches_identification)) {
						$import_summary['System Error']['@@ERROR@@']["99999993"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					} else {
						$participant_identifier = $matches_identification[1].$matches_identification[2];
						//Check data integrity
						if($visit != $matches_identification[3]) {
							$import_summary['System Error']['@@ERROR@@']["934455993"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
						if($procure_participant_attribution_number != $new_line_data['# attribution']) {
							$import_summary['Inventory - DNA']['@@ERROR@@']['# attribution Does Not Match (1)'][] = "See $procure_participant_attribution_number (defined from $dna_sample_label) != ".$new_line_data['# attribution'].". Please correct data. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
						if(!isset($dna_samples_data_from_excel[$dna_sample_label])) {
							$dna_samples_data_from_excel[$dna_sample_label] = array(
								'participant_identifier' => $participant_identifier,
								'procure_participant_attribution_number' => $procure_participant_attribution_number,
								'visit' => $visit,
								'extraction_date' => null,
								'extraction_date_accuracy' => null,
								'quality_controls' => array(),
								'aliquots' => array(),
								'aliquot_loaded_once' => false
							);
						} else {
							$import_summary['Inventory - DNA']['@@WARNING@@']["DNA quality controls defined twice"][] = "Two lines of quality controls exist for the same sample DNA [$dna_sample_label]. All QC will be created. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							if($participant_identifier != $dna_samples_data_from_excel[$dna_sample_label]['participant_identifier']) {
								$import_summary['Inventory - DNA']['@@ERROR@@']['Participant Identifier Does Not Match (1)'][] = "See $participant_identifier != ".$dna_samples_data_from_excel[$dna_sample_label]['participant_identifier']." and attribution number $procure_participant_attribution_number. Please correct data. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							}
							if($visit != $dna_samples_data_from_excel[$dna_sample_label]['visit']) $import_summary['System Error']['@@ERROR@@']["414333"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							if($procure_participant_attribution_number != $dna_samples_data_from_excel[$dna_sample_label]['procure_participant_attribution_number']) $import_summary['System Error']['@@ERROR@@']["444433"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
						//Load quality control
						$qc_test = array(
							'Nanodrop A260' => array('type' => 'nanodrop', 'unit' => '260', 'procure_concentration_unit'	=> ''),
							'Nanodrop A280' => array('type' => 'nanodrop', 'unit' => '280', 'procure_concentration_unit'	=> ''),
							'Nanodrop 260/280' => array('type' => 'nanodrop', 'unit' => '260/280', 'procure_concentration_unit'	=> ''),
							'Nanodrop 260/230' => array('type' => 'nanodrop', 'unit' => '260/230', 'procure_concentration_unit'	=> ''),
							'Nanodrop ng/ul' => array('type' => 'nanodrop', 'unit' => '', 'procure_concentration_unit'	=> 'ng/ul'),
							'Picogreen (ng/ul)' => array('type' => 'picogreen', 'unit' => '', 'procure_concentration_unit'	=> 'ng/ul'));
						foreach($qc_test as $excel_field => $test_data) {
							$qc_value = getDecimal($new_line_data, $excel_field, 'Inventory - DNA', "$file_name ($worksheet)", $line_counter);
							if(strlen($qc_value)) {
								$qc_data = array(
									'type' => $test_data['type'],
									'score' => ($test_data['unit']? $qc_value : ''),
									'unit' => $test_data['unit'],
									'procure_concentration' =>  ($test_data['procure_concentration_unit']? $qc_value : ''),
									'procure_concentration_unit' => $test_data['procure_concentration_unit']);
								$dna_samples_data_from_excel[$dna_sample_label]['quality_controls'][] = $qc_data;
							}
						}
					}
				} else {
					$import_summary['Inventory - DNA']['@@WARNING@@']["Wrong 'Nouvelle identification (x = aliquot)' format"][] = "The 'Nouvelle identification (x = aliquot)' value '".$new_line_data['Nouvelle identification (x = aliquot)']."' is not supported. No sample and quality control data will be created. Please validate. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				}
			} else {
				$import_summary['System Error']['@@ERROR@@']["933339912"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}	
	
	//Load Tube Volume and Position
	$headers = array();
	$worksheet = "Aliquots + Emplacement";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 2) {
			$headers = $new_line;
		} else if($line_counter > 2){	
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['Identif.']) {
				$dna_sample_label = str_replace(' ', '', $new_line_data['Identif.']);
				if(preg_match('/^DNA([0-9x\+]{1,3})\.x(V[0-9]{2})\-([0-9]{4})$/', $dna_sample_label, $matches_dna_label)) {
					$visit = $matches_dna_label[2];
					$procure_participant_attribution_number = ltrim($matches_dna_label[3], "0");
					if(!preg_match('/^(PS[1-4])[\ ]*(P[0-9]{4})[\ ]*(V[0-9]{2})[\ ]*BFC(.*)$/', ($new_line_data['Patient'].$new_line_data['Visite + BFC']), $matches_identification)) {
						$import_summary['System Error']['@@ERROR@@']["9332133393"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					} else {
						$participant_identifier = $matches_identification[1].$matches_identification[2];
						//Check data integrity
						if($visit != $matches_identification[3]) {
							$import_summary['System Error']['@@ERROR@@']["9344259943"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
						if($procure_participant_attribution_number != $new_line_data['# attribution']) {
							$import_summary['System Error']['@@ERROR@@']["48847333"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
						$creation_date = getDateAndAccuracy($new_line_data, 'Date purif.', 'Inventory - DNA', "$file_name (<b>$worksheet</b>)", $line_counter);
						$creation_date['accuracy'] = str_replace('c', 'h', $creation_date['accuracy']);
						if($new_line_data['Date purif. Prec.'] == 'y') $creation_date['accuracy'] = 'm';
						if(!isset($dna_samples_data_from_excel[$dna_sample_label])) {					
							$dna_samples_data_from_excel[$dna_sample_label] = array(
								'participant_identifier' => $participant_identifier,
								'procure_participant_attribution_number' => $procure_participant_attribution_number,
								'visit' => $visit,
								'extraction_date' => $creation_date['date'],
								'extraction_date_accuracy' => $creation_date['accuracy'],
								'quality_controls' => array(),
								'aliquots' => array(),
								'aliquot_loaded_once' => true);
						} else {
							if($participant_identifier != $dna_samples_data_from_excel[$dna_sample_label]['participant_identifier']) {
								$import_summary['Inventory - DNA']['@@ERROR@@']['Participant Identifier Does Not Match (2)'][] = "See $participant_identifier != ".$dna_samples_data_from_excel[$dna_sample_label]['participant_identifier']." and attribution number $procure_participant_attribution_number. Please check data in the same worksheet or between the 2 worksheets and correct data. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";	
							}
							if($visit != $dna_samples_data_from_excel[$dna_sample_label]['visit']) $import_summary['System Error']['@@ERROR@@']["414333"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							if($procure_participant_attribution_number != $dna_samples_data_from_excel[$dna_sample_label]['procure_participant_attribution_number']) $import_summary['System Error']['@@ERROR@@']["444433"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							if($dna_samples_data_from_excel[$dna_sample_label]['aliquot_loaded_once']) $import_summary['Inventory - DNA']['@@WARNING@@']["DNA storage position defined twice"][] = "Two lines of tubes positions exist for the same sample DNA [$dna_sample_label]. Please check and validate data migration. <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
							$dna_samples_data_from_excel[$dna_sample_label]['aliquot_loaded_once'] = true;
							if(!$dna_samples_data_from_excel[$dna_sample_label]['extraction_date']) {
								$dna_samples_data_from_excel[$dna_sample_label]['extraction_date'] = $creation_date['date'];
								$dna_samples_data_from_excel[$dna_sample_label]['extraction_date_accuracy'] = $creation_date['accuracy'];
							}
						}
						//Load tube
						if($dna_samples_data_from_excel[$dna_sample_label]['extraction_date'] == $creation_date['date'] && $dna_samples_data_from_excel[$dna_sample_label]['extraction_date_accuracy'] == $creation_date['accuracy']) {
							for($tub_id = 2; $tub_id < 6; $tub_id++) {
								$dna_tube_barcode = str_replace('.xV', ".".$tub_id."V", $dna_sample_label);
								$volume = getDecimal($new_line_data, "x.$tub_id ul", 'Inventory - DNA', "$file_name ($worksheet)", $line_counter);
								if(strlen($volume)) $volume = round($volume, 1);
								$box_label = $new_line_data["x.$tub_id pos"];
								if(strlen($volume) || strlen($box_label)) {
									if(!array_key_exists($dna_tube_barcode, $dna_samples_data_from_excel[$dna_sample_label]['aliquots'])) {
										$dna_samples_data_from_excel[$dna_sample_label]['aliquots'][$dna_tube_barcode] = array($volume, $box_label);
									} else {
										$import_summary['System Error']['@@ERROR@@']["418893333"][] = "$dna_tube_barcode [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
									}
								}
							}
						} else {
							$import_summary['Inventory - DNA']['@@ERROR@@']["DNA storage positions and tubes defined twice but not the same date of extraction"][] = "Two lines of tubes positions exist for the same sample DNA [$dna_sample_label] but the date of extraction are not the same. Tube of the second line won't be created. <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						}
					}
				} else {
					$import_summary['Inventory - DNA']['@@WARNING@@']["Wrong 'Identif.' format"][] = "The 'Identif.' value '".$new_line_data['Identif.']."' is not supported. No sample and tube data will be created. Please validate. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				}
			} else {
				$import_summary['System Error']['@@ERROR@@']["93534534912"][] = "[file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}
	
	$qc_code_counter = 0;
	foreach($dna_samples_data_from_excel as $dna_sample_label => $dna_sample_data) {
		$participant_identifier = $dna_sample_data['participant_identifier'];
		$procure_participant_attribution_number = $dna_sample_data['procure_participant_attribution_number'];
		$visit = $dna_sample_data['visit'];
		list($participant_id, $site_id) = getParticipantIdAndSite($participant_identifier, $procure_participant_attribution_number,'DNA', 'all', '-1');
		if($participant_id) {
			if(!isset($created_collections_and_specimens[$participant_identifier])) $created_collections_and_specimens[$participant_identifier] = array('participant_id' => $participant_id, 'collections' => array());
			if(preg_match('/^DNA([0-9x\+]{1,3})\.x(V[0-9]{2})\-([0-9]{4})$/', $dna_sample_label, $matches)) {
				$bfc_source_tube_suffix = $matches[1];
				//Collection
				if(!isset($created_collections_and_specimens[$participant_identifier]['collections'][$visit])) {
					$collection_data = array(
						'participant_id' => $participant_id,
						'procure_visit' => $visit,
						'procure_collected_by_bank' => $site_id);
					$created_collections_and_specimens[$participant_identifier]['collections'][$visit] = array('id' => customInsert($collection_data, 'collections', __FILE__, __LINE__), 'specimens' => array());
				}
				$collection_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['id'];
				//Blood
				if(!isset($created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'])) {
					$sample_data_to_record = array(
						'SampleMaster' => array(
							'collection_id' => $collection_id,
							'sample_control_id' =>$sample_aliquot_controls['blood']['sample_control_id'],
							'initial_specimen_sample_type' => 'blood',
							'procure_created_by_bank' => 's'),
						'SpecimenDetail' => array(),
						'SampleDetail' => array());
					$created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'] = createSample($sample_data_to_record, $sample_aliquot_controls['blood']['detail_tablename']);
				}
				$blood_sample_master_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'] ;
				//Buffy coat
				$pbmc_sample_system_identifier = "$participant_identifier $visit -BFC$bfc_source_tube_suffix";
				if(!isset($pbmc_already_created[$pbmc_sample_system_identifier])) {
					$sample_data_to_record = array(
						'SampleMaster' => array(
							'collection_id' => $collection_id,
							'sample_control_id' =>$sample_aliquot_controls['pbmc']['sample_control_id'],
							'initial_specimen_sample_type' => 'blood',
							'initial_specimen_sample_id' => $blood_sample_master_id,
							'parent_sample_type' => 'blood',
							'parent_id' => $blood_sample_master_id,
							'sample_code' => "BFC$bfc_source_tube_suffix ($participant_identifier $visit)",
							'procure_created_by_bank' => $site_id),
						'DerivativeDetail' => array(),
						'SampleDetail' => array());
					$pbmc_already_created[$pbmc_sample_system_identifier] = array('sample_master_id' => createSample($sample_data_to_record, $sample_aliquot_controls['pbmc']['detail_tablename']), 'aliquots' => array());
				}
				$pbmc_sample_master_id = $pbmc_already_created[$pbmc_sample_system_identifier]['sample_master_id'];
				//Tube received from bank
				$source_tube_aliquot_barcode = $pbmc_sample_system_identifier;
				if(!preg_match('/^[0-9]$/', $bfc_source_tube_suffix)) {
					$import_summary['Inventory - DNA']['@@WARNING@@']["The BFC tube suffix does not match -BFC[0-9]"][] = "The suffix of the BFC tube used is flagged as 'BFC$bfc_source_tube_suffix'. Please validate. [file <b>DNA</b> (<b>all</b>), line : <b>-1</b>]";
				}
				if(!isset($pbmc_already_created[$pbmc_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode])) {
					$aliquot_data =  array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $pbmc_sample_master_id,
							'aliquot_control_id' => $sample_aliquot_controls['pbmc']['aliquots']['tube']['aliquot_control_id'],
							'barcode' => $source_tube_aliquot_barcode,
							'in_stock' => 'no',
							'use_counter' => '0',
							'procure_created_by_bank' => $site_id),
						'AliquotDetail' => array());
					$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
					$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
					customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['pbmc']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
					$pbmc_already_created[$pbmc_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode] = $aliquot_master_id;
					//Aliquot Use
					$aliquot_internal_use_data = array(
						'aliquot_master_id' => $aliquot_master_id,
						'type' => 'received from bank',
						'use_code' => 'PS'.$site_id,
						'procure_created_by_bank' => 'p');
					customInsert($aliquot_internal_use_data, 'aliquot_internal_uses', __FILE__, __LINE__);
				}
				$source_aliquot_master_id = $pbmc_already_created[$pbmc_sample_system_identifier]['aliquots'][$source_tube_aliquot_barcode];
				//DNA sample creation
				$sample_data_to_record = array(
					'SampleMaster' => array(
						'collection_id' => $collection_id,
						'sample_control_id' =>$sample_aliquot_controls['dna']['sample_control_id'],
						'initial_specimen_sample_type' => 'blood',
						'initial_specimen_sample_id' => $blood_sample_master_id,
						'parent_sample_type' => 'pbmc',
						'parent_id' => $pbmc_sample_master_id,
						'procure_created_by_bank' => 'p'),
					'DerivativeDetail' => array(
						'creation_datetime' => $dna_sample_data['extraction_date'],
						'creation_datetime_accuracy' => $dna_sample_data['extraction_date_accuracy']),
					'SampleDetail' => array());
				$dna_sample_master_id = createSample($sample_data_to_record, $sample_aliquot_controls['dna']['detail_tablename']);
				//DNA source aliquot
				customInsert(array('sample_master_id' => $dna_sample_master_id, 'aliquot_master_id' => $source_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__);
				//Quality Control
				$quality_control_created = false;
				foreach($dna_sample_data['quality_controls'] as $test_data) {
					$qc_code_counter++;
					$qc_data = array(
						'qc_code' => 'tmp-'.$qc_code_counter,
						'sample_master_id' => $dna_sample_master_id,
						'type' => $test_data['type'],
						'score' => $test_data['score'],
						'unit' => $test_data['unit'],
						'procure_concentration' =>  $test_data['procure_concentration'],
						'procure_concentration_unit' => $test_data['procure_concentration_unit'],
						'procure_created_by_bank' => 'p');
					customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__);
					$quality_control_created = true;
				}
				if(!$quality_control_created)  $import_summary['Inventory - DNA']['@@WARNING@@']["No Quality Control Created"][] = "No quality control has been created for the dna sample with label '$dna_sample_label'.Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				//DNA tubes
				$dna_tube_created = false;
				foreach($dna_sample_data['aliquots'] as $dna_tube_barcode => $tube_data) {
					list($volume, $box_label) = $tube_data;
					$storage_master_id = null;
					$storage_coordinates = array('x' => null, 'y' => null);
					if(preg_match('/^([0-9]+\-[A-Z]\-[0-9]+)\-([A-Z0-9]+)$/',$box_label, $matches)) {
						$storage_master_id = getStorageMasterId($participant_identifier, $matches[1], 'dna', 'Inventory - DNA', $file_name, $worksheet, $line_counter);
						$storage_coordinates = getPosition($participant_identifier, $matches[2], $matches[1], 'dna', 'Inventory - DNA', $file_name, $worksheet, $line_counter);
					} else if($box_label) {
						$import_summary['Inventory - DNA']['@@ERROR@@']["Wrong Storage Information"][] = "See DNA sample tube '$dna_tube_barcode': '$box_label'. No position will be set. [file <b>$file_name</b> (<b>Aliquots + Emplacement</b>), line : <b>-1</b>]";
					}
					$aliquot_data = array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $dna_sample_master_id,
							'aliquot_control_id' => $sample_aliquot_controls['dna']['aliquots']['tube']['aliquot_control_id'],
							'barcode' => $dna_tube_barcode,
							'in_stock' => 'yes - available',
							'in_stock_detail' => '',
							'initial_volume' => $volume,
							'current_volume' => $volume,
							'use_counter' => '0',
							'storage_master_id' => $storage_master_id,
							'storage_coord_x' => $storage_coordinates['x'],
							'storage_coord_y' => $storage_coordinates['y'],
							'procure_created_by_bank' => 'p'),
						'AliquotDetail' => array());
					$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
					$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
					customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['dna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
					if(!$box_label) $import_summary['Inventory - DNA']['@@WARNING@@']["Tube volume defined but no position"][] = "See DNA sample '$dna_sample_label' tube '$dna_tube_barcode'. Tube has been created created. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					if(!$volume) $import_summary['Inventory - DNA']['@@WARNING@@']["Tube volume not defined but position"][] = "See DNA sample '$dna_sample_label' tube '$dna_tube_barcode'. Tube has been created created. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					$dna_tube_created = true;
				}
				if(!$dna_tube_created) $import_summary['Inventory - DNA']['@@WARNING@@']["No Stored Tube DNA Created"][] = "No dna tube stored has been created for the dna sample with label '$dna_sample_label' but the shipped tube has been created. Please confirm. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				//DNA shipped tube
				$dna_tube_barcode = str_replace('.xV', ".1V", $dna_sample_label);
				$aliquot_data = array(
					'AliquotMaster' => array(
						'collection_id' => $collection_id,
						'sample_master_id' => $dna_sample_master_id,
						'aliquot_control_id' => $sample_aliquot_controls['dna']['aliquots']['tube']['aliquot_control_id'],
						'barcode' => $dna_tube_barcode,
						'in_stock' => 'no',
						'in_stock_detail' => 'shipped',
						'use_counter' => '0',
						'procure_created_by_bank' => 'p'),
					'AliquotDetail' => array());
				$aliquot_master_id = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__);
				$aliquot_data['AliquotDetail']['aliquot_master_id'] = $aliquot_master_id;
				customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['dna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
				//Orders
				if(array_key_exists($dna_sample_label, $dna_mismatches)) {
					customInsert(array_merge($mismatch_order_items_template, array('aliquot_master_id' => $aliquot_master_id)), 'order_items', __FILE__, __LINE__);
					if($dna_mismatches[$dna_sample_label]) $import_summary['System Error']['@@ERROR@@']['83838383'][] = "$dna_sample_label [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					$dna_mismatches[$dna_sample_label] = true;
				} else {
					customInsert(array_merge($frsq_innovant_order_items_template, array('aliquot_master_id' => $aliquot_master_id)), 'order_items', __FILE__, __LINE__);
				}
			} else {
				$import_summary['System Error']['@@ERROR@@']["93322334912"][] = "$dna_sample_label [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			}
		}
	}
}

//=================================================================================================================================
// Inventory Functions
//=================================================================================================================================

function createSample($sample_data, $detail_tablename) {
	global $sample_code;

	if(!isset($sample_data['SampleMaster']['sample_code'])) $sample_data['SampleMaster']['sample_code'] = 'tmp##'.($sample_code++);
	//Master
	$sample_master_id = customInsert($sample_data['SampleMaster'], 'sample_masters', __FILE__, __LINE__, false);
	//Specimen/Derivative
	if(array_key_exists('SpecimenDetail', $sample_data)) {
		$sample_data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
		customInsert($sample_data['SpecimenDetail'], 'specimen_details', __FILE__, __LINE__, true);
	} else {
		$sample_data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
		customInsert($sample_data['DerivativeDetail'], 'derivative_details', __FILE__, __LINE__, true);
	}
	//Detail
	$sample_data['SampleDetail']['sample_master_id'] = $sample_master_id;
	customInsert($sample_data['SampleDetail'], $detail_tablename, __FILE__, __LINE__, true);
	
	return$sample_master_id;
}

function getBoxStorageUniqueKey($excel_storage_label, $sample_type) {	
	if(!$excel_storage_label) {
		die('ERR 283ee234342.1');
	} else {
		switch($sample_type) {
			case 'plasma':
				return 'Plasma.'.$excel_storage_label;
			case 'centrifuged urine':
				return 'Urine.'.$excel_storage_label;
			case 'dna':
				if(!preg_match('/^[0-9]+\-[A-Z]\-[0-9]+$/',$excel_storage_label)) die('ERR2323263287623 '."[$excel_storage_label]");
				return 'Dna.'.$excel_storage_label;
			default:
				die('ERR 283ee234342.2');
		}
	}
}

function getStorageMasterId($participant_identifier, $excel_storage_label, $sample_type, $data_type, $file_name, $worksheet, $line_counter) {
	global $controls;
	global $storage_master_ids;
	global $sample_storage_types;
	global $last_storage_code;
	global $import_summary;
	
	if(empty($excel_storage_label)) {
		return null;
	} else {
		$box_storage_unique_key = getBoxStorageUniqueKey($excel_storage_label, $sample_type);
		if(array_key_exists($box_storage_unique_key, $storage_master_ids)) {
			return $storage_master_ids[$box_storage_unique_key]['storage_master_id'];
		} else {
			//Storage to create
			$rack_label = null;
			$box_label = null;
			$box_position_x = null;
			if(!array_key_exists($sample_type, $sample_storage_types)) die('ERR 232 87 6287632.1');
			switch($sample_type) {
				case 'plasma':
				case 'centrifuged urine':
					$box_label = $box_storage_unique_key;
					break;
				case 'dna':
					if(!preg_match('/^([0-9]+\-[A-Z])\-(([1-9])|(1[0-9])|(20))$/',$excel_storage_label, $matches)) {
						$import_summary['System Error']['@@ERROR@@']["99939912"][] = "$excel_storage_label [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
						return null;
					}
					$rack_label = str_replace('-','', $matches[1]);
					$box_label = 'Dna.'.str_replace('-','',$excel_storage_label);
					$box_position_x = $matches[2];
					break;
				default:
					die('ERR 283728 7628762');
			}
			if(!$box_label) die('ERR 232 87 6287632.2');
			//create rack
			$parent_storage_master_id = null;
			if($rack_label) {
				$rack_storage_unique_key = 'rack'.$rack_label;
				if(array_key_exists($rack_storage_unique_key, $storage_master_ids)) {
					$parent_storage_master_id = $storage_master_ids[$rack_storage_unique_key]['storage_master_id'];
				} else {
					$storage_controls_data = $controls['storage_controls']['rack20 (5X4)'];
					$last_storage_code++;
					$storage_data = array(
						'StorageMaster' => array(
							"code" => 'tmp'.$last_storage_code,
							"short_label" => $rack_label,
							"selection_label" => $rack_label,
							"storage_control_id" => $storage_controls_data['storage_control_id'],
							"parent_id" => null),
						'StorageDetail' => array());
					$storage_data['StorageDetail']['storage_master_id'] = customInsert($storage_data['StorageMaster'], 'storage_masters', __FILE__, __LINE__, false);
					customInsert($storage_data['StorageDetail'],$storage_controls_data['detail_tablename'], __FILE__, __LINE__, true);
					$parent_storage_master_id = $storage_data['StorageDetail']['storage_master_id'];
					$storage_master_ids[$rack_storage_unique_key] = array('storage_master_id' => $parent_storage_master_id, 'storage_type' => 'rack20 (5X4)');
				}
			}
			//create box
			$storage_type = $sample_storage_types[$sample_type];
			if(!array_key_exists($storage_type, $controls['storage_controls'])) die('ERR2327627623');
			$storage_controls_data = $controls['storage_controls'][$storage_type];
			$last_storage_code++;
			$storage_data = array(
				'StorageMaster' => array(
					"code" => 'tmp'.$last_storage_code,
					"short_label" => $box_label,
					"selection_label" => ($rack_label? $rack_label.'-' : '').$box_label,
					"storage_control_id" => $storage_controls_data['storage_control_id'],
					"parent_id" => $parent_storage_master_id,
					"parent_storage_coord_x" => $box_position_x),
				'StorageDetail' => array());
			$storage_data['StorageDetail']['storage_master_id'] = customInsert($storage_data['StorageMaster'], 'storage_masters', __FILE__, __LINE__, false);
			customInsert($storage_data['StorageDetail'],$storage_controls_data['detail_tablename'], __FILE__, __LINE__, true);
			$storage_master_ids[$box_storage_unique_key] = array('storage_master_id' => $storage_data['StorageDetail']['storage_master_id'], 'storage_type' => $storage_type);
			return $storage_data['StorageDetail']['storage_master_id'];
		}
	}
}

function getPosition($participant_identifier, $excel_postions, $excel_storage_label, $sample_type, $data_type, $file_name, $worksheet, $line_counter) {
	global $storage_master_ids;
	global $controls;
	global $import_summary;
	$excel_postions = $excel_postions;
	$positions = array('x'=>null, 'y'=>null);
	if(empty($excel_postions)) {
		//Nothing to do
	} else if(empty($excel_storage_label)) {
		$import_summary[$data_type]['@@ERROR@@']["Storage position but no box label defined"][] = "No position will be set. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
	} else {
		$box_storage_unique_key = getBoxStorageUniqueKey($excel_storage_label, $sample_type);
		if(!array_key_exists($box_storage_unique_key, $storage_master_ids))  die('ERR 2387 628763287.2');
		$storage_type = $storage_master_ids[$box_storage_unique_key]['storage_type'];
		switch($storage_type) {
			case 'box100':
				if(preg_match('/^(([1-9])|([1-9][0-9])|(100))$/', $excel_postions)) $positions['x'] = $excel_postions;
				break;
			case 'box100 1A-10J':
				if(preg_match('/^([A-J])(([1-9])|(10))$/', $excel_postions, $matches)) {
					$positions['x'] = $matches[2];
					$positions['y'] = $matches[1];
				} else {
					$import_summary['System Error']['@@ERROR@@']["39939912"][] = "$excel_postions [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
				}
				break;
			default:
				die('ERR327632767326 '.$storage_type);	
		}
		if(is_null($positions['x'])) $import_summary[$data_type]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box ($storage_type) is wrong. No position will be set. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
	}
	return $positions;
}

?>