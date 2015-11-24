<?php

function getParticipantIdAndSite($participant_identifier, $procure_proc_site_participant_identifier) {
	global $import_summary;
	global $import_date;
	
	if(!preg_match('/^PS([0-9])P[0-9]{4}$/', $participant_identifier, $matches)) die('ERR 23 89279 387 '.$participant_identifier);
	$site_id = $matches[1];
	$query = "SELECT par.id, par.participant_identifier, par.procure_proc_site_participant_identifier
		FROM participants par
		WHERE par.deleted <> 1 AND (par.participant_identifier = '$participant_identifier' OR par.procure_proc_site_participant_identifier = '$procure_proc_site_participant_identifier')";
	$results = customQuery($query, __FILE__, __LINE__);
	if(!$results->num_rows) {
		$data = array(
			'participant_identifier' => $participant_identifier,
			'procure_proc_site_participant_identifier' => $procure_proc_site_participant_identifier,
			'last_modification' => $import_date
		);
		$participant_id = customInsert($data, 'participants', __FILE__, __LINE__);
		return array($participant_id, $site_id);
	} else if($results->num_rows > 1) {
		$import_summary['Patient Creation']['@@ERROR@@']["Patient Identifiers Error (more than one)"][] = "More than one patient matches the patient participant_identifier = '$participant_identifier' and/or the procure_proc_site_participant_identifier '$procure_proc_site_participant_identifier'. No file sample will be created. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
		return array(null, null);
	} else {
		$existing_participant_to_check = $results->fetch_assoc();
		if($existing_participant_to_check['participant_identifier'] != $participant_identifier) {
			$import_summary['Patient Creation']['@@ERROR@@']["Patient Identifiers Error"][] = "The patient with procure_proc_site_participant_identifier '".$existing_participant_to_check['procure_proc_site_participant_identifier']."' is already defined as linked to participant_identifier '".$existing_participant_to_check['participant_identifier']."' in ATiM but the value in excel was '$participant_identifier'. No file sample will be created. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";	
			return array(null, null);
		} 
		if($existing_participant_to_check['procure_proc_site_participant_identifier'] != $procure_proc_site_participant_identifier) {
			$import_summary['Patient Creation']['@@ERROR@@']["Patient Identifiers Error"][] = "The patient with participant_identifier '".$existing_participant_to_check['participant_identifier']."' is already defined as linked to procure_proc_site_participant_identifier '".$existing_participant_to_check['procure_proc_site_participant_identifier']."' in ATiM but the value in excel was '$procure_proc_site_participant_identifier'. No file sample will be created. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
			return array(null, null);
		}
		return array($existing_participant_to_check['id'], $site_id);
	}
}

function loadPlasma(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	global $created_collections_and_specimens;
	
	//==============================================================================================
	//FRSQ-Innovant Order
	//==============================================================================================
	
	$study = 'FRSQ-Innovant';
	$study_summary_id = customInsert(array('title' => $study), 'study_summaries', 'No File', '-1');
	$order_id = customInsert(array('order_number' => $study, 'default_study_summary_id' => $study_summary_id, 'processing_status' => 'completed'), 'orders', 'No File', '-1');
	$shipment_id = customInsert(array('shipment_code' => $study, 'order_id' => $order_id), 'shipments', 'No File', '-1');
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
	//LoadConsentAndQuestionnaireData
	$headers = array();
	$worksheet = "Plasma";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
//TODO		
if(!in_array($line_counter, array('1','2','3','146','145','359', '938'))) continue;		
		//$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['patient BB']) {
				$participant_identifier = $new_line_data['patient BB'];
				list($participant_id, $site_id) = getParticipantIdAndSite($participant_identifier, $new_line_data['patient Attri']);
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
									$procure_proc_site_participant_identifier_from_barcode = ltrim($matches[3], "0");
									if($new_line_data['patient Attri'] != $procure_proc_site_participant_identifier_from_barcode) {
										$import_summary['Inventory - Plasma']['@@ERWARNINGROR@@']["Wrong 'patient Attri' of the barcode"][] = "The 'patient Attri' written into the tube barcode ($procure_proc_site_participant_identifier_from_barcode) does not match this one defined into the excel file (".$new_line_data['patient Attri']."). Please validate. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
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
												'procure_created_by_bank' => $site_id),
											'SpecimenDetail' => array(),
											'SampleDetail' => array());
										$created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'] = createSample($sample_data_to_record, $sample_aliquot_controls['blood']['detail_tablename']);
									}
									$blood_sample_master_id = $created_collections_and_specimens[$participant_identifier]['collections'][$visit]['specimens']['blood'] ;
									//Plasma
									$plasma_sample_system_identifier = "$participant_identifier $visit";
									if(!isset($plasma_already_created[$plasma_sample_system_identifier])) {
										$sample_data_to_record = array(
											'SampleMaster' => array(
												'collection_id' => $collection_id,
												'sample_control_id' =>$sample_aliquot_controls['plasma']['sample_control_id'],
												'initial_specimen_sample_type' => 'blood',
												'initial_specimen_sample_id' => $blood_sample_master_id,
												'parent_sample_type' => 'blood',
												'parent_id' => $blood_sample_master_id,
												'procure_created_by_bank' => $site_id),
											'DerivativeDetail' => array(),
											'SampleDetail' => array());
										$plasma_already_created[$plasma_sample_system_identifier] = array('sample_master_id' => createSample($sample_data_to_record, $sample_aliquot_controls['plasma']['detail_tablename']), 'aliquots' => array());
									}
									$plasma_sample_master_id = $plasma_already_created[$plasma_sample_system_identifier]['sample_master_id'];
									//Tube received from bank
									$source_tube_aliquot_barcode = "$participant_identifier $visit -$source_tube_suffix";
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
									$import_summary['Inventory - Plasma']['@@ERROR@@']["Wrong created plasma tube format"][] = "The system is not able to extract information from the barcode of a plasma tube created : '$realiquoted_plasma_tube_barcode'. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
								}
							}
						}
					} else {
						$import_summary['Inventory - Plasma']['@@MESSAGE@@']["No plasma created"][] = "No plasma defined as received and processed. No plasma will be created for Patient '$participant_identifier'. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
					}
				}
			} else if($new_line_data['plasma 1.1']) {
				die('ERR 23 8762387 236');
			}
		}
	}	
}



















































































function loadInventory(&$XlsReader, $files_path, $file_name, $psp_nbr_to_frozen_blocks_data, $psp_nbr_to_paraffin_blocks_data, &$psp_nbr_to_participant_id_and_patho, &$created_prostatectomy, $prostatectomy_data_from_patho) {}

function loadUrine($participant_id, $participant_identifier, $file_name, $worksheet, $line_counter, $new_line_data) {}


















function loadTissue($participant_id, $participant_identifier, &$psp_nbr_to_frozen_blocks_data, &$psp_nbr_to_paraffin_blocks_data, &$patho_nbr_from_participant_file, $file_name, $worksheet, $line_counter, $new_line_data, &$created_prostatectomy, &$prostatectomy_data_from_patho) {}

// function loadRNA(&$XlsReader, $files_path, $file_name) {
// 	global $import_summary;
// 	global $controls;
// 	global $patients_to_import;
	
// 	// Control
// 	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
// 	$storage_control = $controls['storage_controls'];
// 	//Load Worksheet Names
// 	$XlsReader->read($files_path.$file_name);
// 	$sheets_nbr = array();
// 	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
// 	//LoadConsentAndQuestionnaireData
// 	$headers = array();
// 	for($visit_id=1;$visit_id<7;$visit_id++) {
// 		$worksheet = "V0".$visit_id;	
// 		$paxgene_blood_tubes = array();	
// 		$query = "SELECT par.participant_identifier, am.collection_id, am.sample_master_id, am.barcode, am.id AS aliquot_master_id, am.storage_master_id, stm.selection_label
// 			FROM participants par
// 			INNER JOIN collections col ON col.participant_id = par.id
// 			INNER JOIN aliquot_masters am ON am.collection_id = col.id
// 			LEFT JOIN storage_masters stm ON stm.id = am.storage_master_id
// 			WHERE am.deleted <> 1 AND am.barcode LIKE '%-RNB%' AND col.procure_visit = '$worksheet' AND am.aliquot_control_id = ".$sample_aliquot_controls['blood']['aliquots']['tube']['aliquot_control_id'].";";
// 		$results = customQuery($query, __FILE__, __LINE__);
// 		while($row = $results->fetch_assoc()){
// 			$participant_identifier = $row['participant_identifier'];
// 			if(array_key_exists($participant_identifier, $paxgene_blood_tubes)) $import_summary['Inventory - RNA']['@@WARNING@@']["More than one paxgene tube exist"][] = "Only one will be used for RNA extraction. See patient '$participant_identifier'.";
// 			$paxgene_blood_tubes[$participant_identifier] = $row;
// 		}
// 		$procure_chuq_extraction_number = '';
// 		$aliquot_master_ids_to_remove = array('-1');
// 		foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
// 			//$line_counter++;
// 			if($line_counter == 4) {
// 				$headers = $new_line;
// 			} else if($line_counter > 4){
// 				$new_line_data = formatNewLineData($headers, $new_line);
// 				$participant_identifier = $new_line_data['# échantillon'];
// 				if(strlen($participant_identifier)) {
// 					if(preg_match('/^PS[0-9]P/', $participant_identifier)) {
// 						if(!empty($patients_to_import) && !in_array( $participant_identifier, $patients_to_import)) continue;
// 						if(array_key_exists($participant_identifier, $paxgene_blood_tubes)) {
// 							if($new_line_data['# extraction'] || $new_line_data["Date             d'extraction"] || $new_line_data['RNA-1 volume (ul)']) {
// 								//Parse excel data
// 								if(strlen($new_line_data['# extraction'])) $procure_chuq_extraction_number = $new_line_data['# extraction'];
// 								$extraction_date = getDateAndAccuracy($new_line_data, "Date             d'extraction", 'Inventory - RNA', $file_name, $line_counter);
// 								$extraction_date['accuracy'] = str_replace('c','h',$extraction_date['accuracy']);
// 								$notes = $new_line_data["Note d'incident         durant extration"];
// 								$procure_chuq_dnase_duration_mn = '';
// 								if($new_line_data["Délai DNAse"]) {
// 									if(preg_match('/^([0-9]+)\ min\.\ DNAse$/', $new_line_data["Délai DNAse"], $matches)) {
// 										$procure_chuq_dnase_duration_mn = $matches[1];
// 									} else if(preg_match('/^([0-9]+[|.,][0-9]+)\ min\.\ DNAse$/', $new_line_data["Délai DNAse"], $matches)) {
// 										$procure_chuq_dnase_duration_mn = str_replace(',','.',$matches[1]);
// 									} else if(preg_match('/^([0-9]+)\ minutes$/', $new_line_data["Délai DNAse"], $matches)) {
// 										$procure_chuq_dnase_duration_mn = str_replace(',','.',$matches[1]);
// 									} else {
// 										$import_summary['Inventory - RNA']['@@WARNING@@']["Wrong 'Délai DNAse' format"][] = "See value '".$new_line_data["Délai DNAse"]."' for patient '$participant_identifier'. No value imported. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
// 									}
// 								}
// 								$procure_chuq_extraction_method = '';
// 								if($new_line_data['extract. Manuelle'] == 1 && $new_line_data['Qiacube kit miRNA'] == 1) {
// 									$import_summary['Inventory - RNA']['@@WARNING@@']["Extraction method conflict"][] = "Extraction method defined both as manual and kit. No method will be set. See patient '$participant_identifier'. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
// 								} else if($new_line_data['extract. Manuelle'] == 1) {
// 									$procure_chuq_extraction_method = 'manual extraction';
// 								} else if($new_line_data['Qiacube kit miRNA'] == 1) {
// 									$procure_chuq_extraction_method = 'qiacube kit miRNA';
// 								}
// 								$created_by = '';
// 								switch($new_line_data['extrait par CHUQ']) {
// 									case 'CM':
// 									case 'VB':
// 									case  '':
// 										$created_by = $new_line_data['extrait par CHUQ'];
// 										break;
// 									case  'tech. Patho':
// 										$created_by = 'tech. patho';
// 										break;
// 									case '-CM':
// 									case 'MO-CM':
// 									case 'CM (BC)':
// 									case 'CM (BC)':
// 									case 'VB et CM':
// 									case 'VB/CM':
// 									case 'CM et VB':
// 										$created_by = 'CM';
// 										$import_summary['Inventory - RNA']['@@WARNING@@']["Changed lab staff who extracted RNA to 'CM'"][$worksheet.$new_line_data['extrait par CHUQ']] = "Value '".$new_line_data['extrait par CHUQ']."' changed to 'CM'. See file <b>$file_name</b> (<b>$worksheet</b>)]";
// 										break;
// 									default:
// 										$import_summary['Inventory - RNA']['@@ERROR@@']["Unknown lab staff who extracted RNA"][] = "Lab staff '".$new_line_data['extrait par CHUQ']."' is not supported. Value won't be migrated. See patient '$participant_identifier'. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
// 								}
// 								//Create RNA Sample
// 								$sample_data = array(
// 									'SampleMaster' => array(
// 										'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
// 										'sample_control_id' => $sample_aliquot_controls['rna']['sample_control_id'],
// 										'initial_specimen_sample_type' => 'blood',
// 										'initial_specimen_sample_id' => $paxgene_blood_tubes[$participant_identifier]['sample_master_id'],
// 										'parent_sample_type' => 'blood',
// 										'parent_id' => $paxgene_blood_tubes[$participant_identifier]['sample_master_id'],
// 										'notes' => $notes),
// 									'DerivativeDetail' => array(
// 										'creation_datetime' => $extraction_date['date'],
// 										'creation_datetime_accuracy' => $extraction_date['accuracy'],
// 										'creation_by' =>$created_by),
// 									'SampleDetail' => array(
// 										'procure_chuq_extraction_number' => $procure_chuq_extraction_number,
// 										'procure_chuq_dnase_duration_mn' => $procure_chuq_dnase_duration_mn,
// 										'procure_chuq_extraction_method' => $procure_chuq_extraction_method));
// 								$derivative_sample_master_id = createSample($sample_data, $sample_aliquot_controls['rna']['detail_tablename']);
// 								//Create aliquot to sample link		
// 								$source_aliquot_barcode = $paxgene_blood_tubes[$participant_identifier]['barcode'];
// 								$source_aliquot_master_id = $paxgene_blood_tubes[$participant_identifier]['aliquot_master_id'];
// 								customInsert(array('sample_master_id' => $derivative_sample_master_id, 'aliquot_master_id' => $source_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
// 								//Update paxgen tube storage data
// 								$aliquot_master_ids_to_remove[] = $source_aliquot_master_id;
// 								if($paxgene_blood_tubes[$participant_identifier]['storage_master_id']) {
// 									$import_summary['Inventory - RNA']['@@WARNING@@']["Removed Paxgene Tube from Storage"][] = "Paxgen tube '$source_aliquot_barcode' was defined as used for RNA extraction. Migration process removed storage information (Tube was defined as stored into ".$paxgene_blood_tubes[$participant_identifier]['selection_label']."). See patient '$participant_identifier'. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
// 								}
// 								//Create aliquots
// 								$aliquot_master_ids = array();
// 								//... RNA1
// 								$initial_volume = getDecimal($new_line_data, 'RNA-1 volume (ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 								$concentration_bioanalyzer = getDecimal($new_line_data, 'Concentration (ng/ul) par Bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 								$concentration_unit_bioanalyzer = strlen($concentration_bioanalyzer)? 'ng/ul' : '';
// 								//current volume = initial volume: so current quantity on initial volume						
// 								$procure_total_quantity_ug = (strlen($initial_volume) && strlen($concentration_bioanalyzer))? ($initial_volume*$concentration_bioanalyzer/1000): '';
// 								$concentration_nanodrop = getDecimal($new_line_data, 'Nanodrop (ng/ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 								$concentration_unit_nanodrop = strlen($concentration_nanodrop)? 'ng/ul' : '';
// 								//current volume = initial volume: so current quantity on initial volume						
// 								$procure_total_quantity_ug_nanodrop = (strlen($initial_volume) && strlen($concentration_nanodrop))? ($initial_volume*$concentration_nanodrop/1000): '';
// 								if(strlen($new_line_data['bte rangement RNA-1']) || $initial_volume) {
// 									$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement RNA-1'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
// 									$storage_coordinates = getPosition($participant_identifier, $new_line_data['Position RNA-1 dans boîte de rangement'], $new_line_data['bte rangement RNA-1'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
// 									$aliquot_data = array(
// 										'AliquotMaster' => array(
// 											'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
// 											'sample_master_id' => $derivative_sample_master_id,
// 											'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
// 											'barcode' => "$participant_identifier $worksheet -RNA1",
// 											'in_stock' => 'yes - available',
// 											'initial_volume' => $initial_volume,
// 											'current_volume' => $initial_volume,									
// 											'use_counter' => '0',
// 											'storage_datetime' => $extraction_date['date'],
// 											'storage_datetime_accuracy' => $extraction_date['accuracy'],
// 											'storage_master_id' => $storage_master_id,
// 											'storage_coord_x' => $storage_coordinates['x'],
// 											'storage_coord_y' => $storage_coordinates['y']),
// 										'AliquotDetail' => array(
// 											'concentration' => $concentration_bioanalyzer,
// 											'concentration_unit' => $concentration_unit_bioanalyzer,
// 											'procure_total_quantity_ug' => $procure_total_quantity_ug,
// 											'procure_concentration_nanodrop' => $concentration_nanodrop,
// 											'procure_concentration_unit_nanodrop' => $concentration_unit_nanodrop,
// 											'procure_total_quantity_ug_nanodrop' => $procure_total_quantity_ug_nanodrop
// 										));
// 									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
// 									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
// 									$aliquot_master_ids['RNA-1'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
// 								}
// 								//Mir
// 								if($new_line_data['MiR'] == '1' || strlen($new_line_data['Boîte de rangement Mir'])) {
// 									$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['Boîte de rangement Mir'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
// 									$storage_coordinates = getPosition($participant_identifier, $new_line_data['Position Mir dans boîte de rangement'], $new_line_data['Boîte de rangement Mir'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
// 									$aliquot_data = array(
// 										'AliquotMaster' => array(
// 											'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
// 											'sample_master_id' => $derivative_sample_master_id,
// 											'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],			
// 											'barcode' => "$participant_identifier $worksheet -miRNA",
// 											'in_stock' => 'yes - available',
// 											'initial_volume' => null,
// 											'current_volume' => null,
// 											'use_counter' => '0',
// 											'storage_datetime' => $extraction_date['date'],
// 											'storage_datetime_accuracy' => $extraction_date['accuracy'],
// 											'storage_master_id' => $storage_master_id,
// 											'storage_coord_x' => $storage_coordinates['x'],
// 											'storage_coord_y' => $storage_coordinates['y']),
// 										'AliquotDetail' => array(
// 											'procure_chuq_micro_rna' => '1'));
// 									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
// 									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
// 									$aliquot_master_ids['RNA-micro'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
// 								}
// 								for($id=2;$id<4;$id++) {
// 									$initial_volume = getDecimal($new_line_data, 'RNA-'.$id.' volume (ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($initial_volume) {
// 										$aliquot_data = array(
// 											'AliquotMaster' => array(
// 												'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
// 												'sample_master_id' => $derivative_sample_master_id,
// 												'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
// 												'barcode' => "$participant_identifier $worksheet -RNA".$id,
// 												'in_stock' => 'no',
// 												'initial_volume' => $initial_volume,
// 												'current_volume' => $initial_volume,
// 												'use_counter' => '0'),
// 											'AliquotDetail' => array());
// 										$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
// 										customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
// 										$aliquot_master_ids['RNA-'.$id] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
// 									}
// 								}
// 								if(empty($aliquot_master_ids)) {
// 									$import_summary['Inventory - RNA']['@@WARNING@@']["No tube of RNA defined"][] = "RNA sample has been created but no tube volume is set. No aliquot has been created .See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 								}
// 								//Bioanalyzer
// 								$qc_code_counter = 0;
// 								if($new_line_data['Analysé par bioanalyser'] || strlen($new_line_data["Date d'analyse"])) {
// 									$scores = array();
// 									$score = getDecimal($new_line_data, 'Valeur RIN', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($score) $scores['RIN'] = $score;
// 									$score = getDecimal($new_line_data, 'Ratio 28S/18S Bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($score) $scores['28/18'] = $score;
// 									if(empty($scores)) {
// 										$import_summary['Inventory - RNA']['@@WARNING@@']["Bioanalyzer test with no scrore"][] = "Please confirm .See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 										$scores[''] = '';
// 									}
// 									$qc_date = getDateAndAccuracy($new_line_data, "Date d'analyse", 'Inventory - RNA', $file_name, $line_counter);
// 									$qc_date['accuracy'] = str_replace('c','h',$qc_date['accuracy']);
// 									$tested_aliquot_master_id = null;
// 									if($new_line_data['Aliquot utilisé pour bioanalyser']) {
// 										if(array_key_exists($new_line_data['Aliquot utilisé pour bioanalyser'], $aliquot_master_ids)) {
// 											$tested_aliquot_master_id = $aliquot_master_ids[$new_line_data['Aliquot utilisé pour bioanalyser']];
// 										} else {
// 											$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer: Unable to define tested aliquot"][] = "The system is unable to link bioanalyzer test to the specific aliquot defined as  '".$new_line_data['Aliquot utilisé pour bioanalyser']."'. This one has not been created into the system. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 										}
// 									}
// 									$new_line_data['Volume pris pour analyse  bioanalyser'] = str_replace(' ul', '', $new_line_data['Volume pris pour analyse  bioanalyser']);
// 									$used_volume = getDecimal($new_line_data, 'Volume pris pour analyse  bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if(is_null($tested_aliquot_master_id) && strlen($used_volume)) {
// 										$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer: Used volume but no tested aliquot"][] = "A '<b>Volume pris pour analyse  bioanalyser</b>' is defined but no tested aliquot (field '<b>Aliquot utilisé pour bioanalyser</b>') is defined. No used volume will be migrated. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 										$used_volume = '';
// 									}
// 									foreach($scores as $unit => $score) {
// 										$qc_code_counter++;
// 										$qc_data = array(
// 											'qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter,
// 											'sample_master_id' => $derivative_sample_master_id,
// 											'aliquot_master_id' => $tested_aliquot_master_id,
// 											'used_volume' => $used_volume,
// 											'type' => 'bioanalyzer',
// 											'procure_analysis_by' => $new_line_data["Centre d'analyse"],
// 											'date' => $qc_date['date'],
// 											'date_accuracy' => $qc_date['accuracy'],
// 											'score' => $score,
// 											'unit' => $unit,
// 											'procure_chuq_visual_quality' => $new_line_data["Qualité visuelle Bioanalyser"],
// 											'notes' => strlen($new_line_data['Chip comment'])? 'Chip note: '.$new_line_data['Chip comment'] : '');
// 										customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
// 										$used_volume = ''; //In case there are 2 scores no used wolume will be defined for the second one
// 									}
// 								} else if(strlen($new_line_data['Valeur RIN'].$new_line_data['Ratio 28S/18S Bioanalyser'])) {
// 									$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer was defined as not executed but results exist"][] = "No bioanalyzer test will be migrated. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 								}
// 								//Nanodrop
// 								if(strlen($new_line_data["Nanodrop date analyse"])) {
// 									$scores = array();
// 									$score = getDecimal($new_line_data, 'Nanodrop A260', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($score) $scores['260'] = $score;
// 									$score = getDecimal($new_line_data, 'Nanodrop A280', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($score) $scores['280'] = $score;
// 									$score = getDecimal($new_line_data, 'Nanodrop 260/280', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($score) $scores['260/280'] = $score;
// 									$score = getDecimal($new_line_data, 'Nanodrop 260/230', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									if($score) $scores['260/230'] = $score;
// 									if(empty($scores)) {
// 										$import_summary['Inventory - RNA']['@@WARNING@@']["Nanodrop test with no scrore"][] = "Please confirm .See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 										$scores[''] = '';
// 									}
// 									$qc_date = getDateAndAccuracy($new_line_data, "Nanodrop date analyse", 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
// 									$qc_date['accuracy'] = str_replace('c','h',$qc_date['accuracy']);
// 									//Note: Volume pris pour analyse nanodrop: Not imported because no linked aliquot
// 									foreach($scores as $unit => $score) {
// 										$qc_code_counter++;
// 										$qc_data = array(
// 											'qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter,
// 											'sample_master_id' => $derivative_sample_master_id,
// 											'type' => 'nanodrop',
// 											'procure_analysis_by' => $new_line_data["Nanodrop centre analyse"],
// 											'date' => $qc_date['date'],
// 											'date_accuracy' => $qc_date['accuracy'],
// 											'score' => $score,
// 											'unit' => $unit);
// 										customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
// 									}
// 								} else if(strlen($new_line_data['Nanodrop A260'].$new_line_data['Nanodrop A280'].$new_line_data['Nanodrop 260/280'].$new_line_data['Nanodrop 260/230'])) {
// 									$import_summary['Inventory - RNA']['@@ERROR@@']["Nanodrop test was defined as not executed but results exist (see field Nanodrop date analyse)"][] = "No test will be migrated. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>), line : <b>$line_counter</b>]";
// 								}							
// 								unset($paxgene_blood_tubes[$participant_identifier]);
// 							} else if(strlen($new_line_data["Date d'analyse"]) || strlen($new_line_data['extrait par CHUQ']) || $new_line_data['bte rangement RNA-1']) {
// 								$import_summary['Inventory - RNA']['@@ERROR@@']["No RNA extraction but RNA data exists"][] = "RNA has not been defined as extracted but some RNA data has been set. See $participant_identifier. No RNA will be created. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>";
// 							}
// 						} else {
// 							if($new_line_data['# extraction'] || $new_line_data["Date             d'extraction"] || $new_line_data['RNA-1 volume (ul)']) {
// 								$import_summary['Inventory - RNA']['@@ERROR@@']["No paxgene tube"][] = "RNA has been defined for patient $participant_identifier but no paxgene tube was previously created into the system. No RNA will be created. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>";
// 							} else {
// 								$import_summary['Inventory - RNA']['@@MESSAGE@@']["No paxgene tube"][] = "No paxgene tube was previously created into the system. Please validate no RNA data exists into the file. No RNA has been created. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>";	
// 							}
// 						}
// 					}
// 				}
// 			}
// 		}
// 		//Update paxgen tube storage data
// 		$query = "UPDATE aliquot_masters SET in_stock = 'no', storage_master_id = null, storage_coord_x = null, storage_coord_y = null WHERE id IN ('".implode("','", $aliquot_master_ids_to_remove)."');";
// 		customQuery($query, __FILE__, __LINE__);
// 	}
//



//=================================================================================================================================
// Inventory Functions
//=================================================================================================================================

function createSample($sample_data, $detail_tablename) {
	global $sample_code;

	$sample_data['SampleMaster']['sample_code'] = 'tmp'.($sample_code++);
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
				return 'plasma-'.$excel_storage_label;
			
			
// 			case 'tissue':
// 				return 'tissue-'.$excel_storage_label;
// 			case 'serum':
// 			case 'plasma':
// 			case 'pbmc':
// 			case 'concentrated urine':
// 			case 'rna':
// 				return 'blood_and_urinec-'.$excel_storage_label;
// 			case 'whatman':
// 				return 'whatman-'.$excel_storage_label;
// 			case 'urine':
// 				return 'urine-'.$excel_storage_label;
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
			if(!array_key_exists($sample_type, $sample_storage_types)) die('ERR 232 87 6287632.1');
			switch($sample_type) {
				case 'plasma':
					$box_label = $box_storage_unique_key;
					break;
// 				case 'tissue':
// 				case 'serum':
// 				case 'pbmc':
// 				case 'concentrated urine':
// 				case 'rna':
// 					if(preg_match('/^(R[0-9]+)[\-]{0,1}(B[0-9]+)$/',$excel_storage_label, $matches)) {
// 						$rack_label = $matches[1];
// 						$box_label = $matches[1].$matches[2];
// 					} else {
// 						$import_summary[$data_type]['@@ERROR@@']["Unable to extract both rack and box labels"][] = "Unable to extract the rack and box labels for $sample_type box with value '$excel_storage_label'. Box label will be set to '$excel_storage_label' and no rack will be created. See patient $participant_identifier. [file <b>$file_name</b> (<b>$worksheet</b>) - line: <b>$line_counter</b>]";
// 						$box_label = $excel_storage_label;
// 					}
// 					break;
// 				case 'whatman':
// 				case 'urine':
// 					$box_label = $excel_storage_label;
// 					break;
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
					$storage_controls_data = $controls['storage_controls']['rack16'];
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
					$storage_master_ids[$rack_storage_unique_key] = array('storage_master_id' => $parent_storage_master_id, 'storage_type' => 'rack16');
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
					"parent_id" => $parent_storage_master_id),
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
			case 'box27 1A-9C':
				if(preg_match('/^([A-C])([1-9])$/', $excel_postions, $matches)) {
					$positions['x'] = $matches[2];
					$positions['y'] = $matches[1];
				}
				break;
			case 'box81':
				if(preg_match('/^(([1-9])|([1-7][0-9])|(8[0-1]))$/', $excel_postions)) $positions['x'] = $excel_postions;
				break;
			case 'box49 1A-7G':
				if(preg_match('/^([A-G])([1-7])$/', $excel_postions, $matches)) {
					$positions['x'] = $matches[2];
					$positions['y'] = $matches[1];
				}
				break;
			case 'box49':
				//Urine case
				if(preg_match('/^(([1-9])|([1-4][1-9]))$/', $excel_postions, $matches)) {
					$positions['x'] = $excel_postions;
				} else if(preg_match('/^([A-G])([1-7])$/', $excel_postions, $matches)) {
					$incr_val = str_replace(array('A','B','C','D','E','F','G'),array('0','7','14','21','28','35','42'),$matches[1]);
					$positions['x'] = $matches[2]+$incr_val;
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