<?php

function loadTissue(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	// *1* Create Collection **
	
	$tissue_collection_labels_to_ids = array();
	
	$worksheet = 'Collection';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$excel_collection_value = $new_line_data['Collection'];
//TODO			
if($excel_collection_value == '01-1-008') break;	
			if(preg_match('/^([0-9]+)\-([0-9]+)-([0-9]+)$/', $excel_collection_value, $matches)) {
				$collection_id = getCollectionId($matches[1], $matches[3], 'T', $matches[2], $new_line_data['Date'], '', $new_line_data['Hospital site'], $new_line_data['Note'], $summary_title, $file_name, $worksheet, $line_counter);
				$tissue_collection_labels_to_collection_ids[$excel_collection_value] = array('collection_id' => $collection_id, 'sample_master_ids' => array());
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Collection Value Format Not Supported'][] = "See value [$excel_collection_value]! [file '$file_name' ($worksheet) - line: $line_counter]";
			}
		}
	}
	
	// *2* Create Tissue **
	
	$tissue_tube_labels_to_ids = array();
	
	$worksheet = 'Sample';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$tissue_tube_aliquot_label = $new_line_data['Sample Id'];
			if(strlen($tissue_tube_aliquot_label)) {
				if(!array_key_exists($tissue_tube_aliquot_label, $tissue_tube_labels_to_ids)) {
					if(preg_match('/^([0-9]+)\-([0-9]+)-([0-9]+)\-([0-9]+)$/', $tissue_tube_aliquot_label, $matches)) {
						$collection_key = $matches[1].'-'.$matches[2].'-'.$matches[3];
//TODO
if($collection_key == '01-1-008') break;						
						if(array_key_exists($collection_key, $tissue_collection_labels_to_collection_ids)) {
							$qcroc_collection_method = strtolower($new_line_data['Collection Method']);
							if($qcroc_collection_method != 'no biopsy') {
								$collection_id = $tissue_collection_labels_to_collection_ids[$collection_key]['collection_id'];
								$tissue_sample_key = $new_line_data['Collection Method'].$new_line_data['Tissue Site'].$new_line_data['Laterality'].$new_line_data['Histology'];
								if(!array_key_exists($tissue_sample_key, $tissue_collection_labels_to_collection_ids[$collection_key]['sample_master_ids'])) {
									//Create the sample tissue								
									if(!in_array($qcroc_collection_method, array('', 'biopsy', 'hepatectomy'))) {
										$import_summary[$summary_title]['@@WARNING@@']['Collection method unknown'][] = "See value [$qcroc_collection_method]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
										$qcroc_collection_method = '';
									}
									$tissue_source = strtolower($new_line_data['Tissue Site']);
									if(!in_array($tissue_source, array('', 'colon'))) {
										$import_summary[$summary_title]['@@WARNING@@']['Tissue Source unknown'][] = "See value [$tissue_source]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
										$tissue_source = '';
									}
									$tissue_laterality = strtolower($new_line_data['Laterality']);
									if(!in_array($tissue_laterality, array('', 'left', 'right', 'unknown', 'not applicable'))) {
										$import_summary[$summary_title]['@@WARNING@@']['Tissue Laterality unknown'][] = "See value [$tissue_laterality]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
										$tissue_laterality = '';
									}
									$qcroc_histology = strtolower($new_line_data['Histology']);
									if(!in_array($qcroc_histology, array('', 'tumor'))) {
										$import_summary[$summary_title]['@@WARNING@@']['Histology unknown'][] = "See value [$qcroc_histology]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
										$qcroc_histology = '';
									}
									$sample_data = array(
										'SampleMaster' => array(
											'collection_id' => $collection_id,
											'sample_control_id' => $controls['sample_aliquot_controls']['tissue']['sample_control_id'],
											'initial_specimen_sample_type' => 'tissue'),
										'SpecimenDetail' => array(),
										'SampleDetail' => array(
											'qcroc_collection_method' => $qcroc_collection_method,
											'tissue_source' => $tissue_source,
											'tissue_laterality' => $tissue_laterality,
											'qcroc_histology' => $qcroc_histology));
									$tissue_collection_labels_to_collection_ids[$collection_key]['sample_master_ids'][$tissue_sample_key] = createSample($sample_data, $controls['sample_aliquot_controls']['tissue']['detail_tablename']);
								}
								$sample_master_id = $tissue_collection_labels_to_collection_ids[$collection_key]['sample_master_ids'][$tissue_sample_key];
								//Set data for tissue tube creation
								$tissue_tube_labels_to_ids[$tissue_tube_aliquot_label] = array(
									'collection_id' => $collection_id,
									'sample_master_id' => $sample_master_id,
									'data' => array(
										'Biopsy >1 cm' => $new_line_data['Biopsy >1 cm'], 
										'Fragments' => $new_line_data['Fragments'], 
										'Carrot size Detail 1' => $new_line_data['Carrot size Detail 1'], 
										'Carrot size Detail 2' => $new_line_data['Carrot size Detail 2'], 
										'Carrot size Unit' => $new_line_data['Carrot size Unit'],
										'Date Received' => $new_line_data['Date Received'],
										'line' => $line_counter,
										'worksheet' => $worksheet),
									'tube_aliquot_master_id' => null,
									'bloc_aliquot_master_ids' => array(),
									'slide_aliquot_master_ids' => array()	
								);
							} else {
								$import_summary[$summary_title]['@@WARNING@@']['No Biopsy & Tissue Tube Sample ID'][] = "A note defined that 'No biopsy' has been done. The Tissue Tube [".$tissue_tube_aliquot_label."] won't be created. [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						} else {
							$import_summary[$summary_title]['@@ERROR@@']['No Collection'][] = "The collection of the Sample ID [".$new_line_data['Sample Id']."] was not defined into the Collection worksheet! No tissue tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['Wrong Sample Id Format'][] = "The format of the Sample ID [".$new_line_data['Sample Id']."] is not supported! No tissue tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@WARNING@@']['Duplicated Tissue Tube Id'][] = "The tissue tube [$tissue_tube_aliquot_label] is defined twice! Only one will be created! Please check data integrity! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			} else if(strlen($new_line_data['Collection'])) {
				$import_summary[$summary_title]['@@MESSAGE@@']['Empty Excel Sample Id'][] = "See line $line_counter! A collection ID was defined [".$new_line_data['Collection']."] but the Sample Id value is empty. No tissue tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";	
			}
		}
	}
	foreach ($tissue_collection_labels_to_collection_ids as $collection_key => $sample_master_ids) {
		if(empty($sample_master_ids)) {
			$import_summary[$summary_title]['@@WARNING@@']['No Collection Tissue Defined'][] = "No tissue has been created for created collection [$collection_key]! Please confirm and delete collection after migration (if required)! [file '$file_name' ($worksheet) - line: $line_counter]";
		}		
	}
	unset($tissue_collection_labels_to_collection_ids);
	
	// *3* Create Tissue **
	
	$worksheet = 'Tube';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$sample_tube_id = $new_line_data['Sample Tube Id'];
//TODO
if($sample_tube_id == '01-1-008-1') break;
			if(strlen($sample_tube_id)) {
				if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && is_null($tissue_tube_labels_to_ids[$sample_tube_id]['tube_aliquot_master_id'])) {			
					//1-Data from Sample Worksheet
					$prev_worksheet_line_data = $tissue_tube_labels_to_ids[$sample_tube_id]['data'];
					unset($tissue_tube_labels_to_ids[$sample_tube_id]['data']);
					$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
					$sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
					//1.a-qcroc_tissue_biopsy_big_than_1cm
					$qcroc_tissue_biopsy_big_than_1cm = '';
					switch(strtolower($prev_worksheet_line_data['Biopsy >1 cm'])) {
						case 'yes':
							$qcroc_tissue_biopsy_big_than_1cm = 'y';
							break;
						case 'no':
							$qcroc_tissue_biopsy_big_than_1cm = 'n';
							break;
						case '';
							break;
						default:
							$import_summary[$summary_title]['@@WARNING@@']['Biopsy >1 cm unknown'][] = "See value [".$prev_worksheet_line_data['Biopsy >1 cm']."]. Value won't be migrated! [file '$file_name' (".$prev_worksheet_line_data['worksheet'].") - line: ".$prev_worksheet_line_data['line']."]";
					}
					//1.b-qcroc_tissue_biopsy_fragments
					$qcroc_tissue_biopsy_fragments = '';
					if(preg_match('/^[0-9]+$/', $prev_worksheet_line_data['Fragments'])) {
						$qcroc_tissue_biopsy_fragments = $prev_worksheet_line_data['Fragments'];
					} else if(strlen($prev_worksheet_line_data['Fragments'])) {
						$import_summary[$summary_title]['@@WARNING@@']['Fragments format error'][] = "See value [".$prev_worksheet_line_data['Fragments']."]. Value won't be migrated! [file '$file_name' (".$prev_worksheet_line_data['worksheet'].") - line: ".$prev_worksheet_line_data['line']."]";
					}
					//1.c-qcroc_tissue_biopsy_carrot_size_cm
					$qcroc_tissue_biopsy_carrot_size_cm = '';
					if($prev_worksheet_line_data['Carrot size Detail 1'] == $prev_worksheet_line_data['Carrot size Detail 2']) {
						$qcroc_tissue_biopsy_carrot_size_cm = $prev_worksheet_line_data['Carrot size Detail 1'];
					} else {
						$qcroc_tissue_biopsy_carrot_size_cm = trim(implode(' ', array($prev_worksheet_line_data['Carrot size Detail 1'],$prev_worksheet_line_data['Carrot size Detail 2'])));
					}
					if(strlen($qcroc_tissue_biopsy_carrot_size_cm) && 	!in_array($prev_worksheet_line_data['Carrot size Unit'], array('','cm'))) {
						$import_summary[$summary_title]['@@WARNING@@']['Wrong Carrot size Unit'][] = "See value [".$prev_worksheet_line_data['Carrot size Unit']."]. Size will be migrated but system will consider unit as 'cm'! [file '$file_name' (".$prev_worksheet_line_data['worksheet'].") - line: ".$prev_worksheet_line_data['line']."]";
					}		
					//2-Data from curent worksheet
					//2.a-qcroc_storage_method & croc_storage_solution
					$qcroc_storage_method = '';
					$qcroc_storage_solution = '';
					switch(strtolower($new_line_data['Processing Agent'])) {
						case '':
							break;
						case 'snap frozen':
							$qcroc_storage_method = 'snap frozen';
							break;
						case 'formalin':
							$qcroc_storage_solution = 'formalin';
							break;
						case 'rnalater':
							$qcroc_storage_solution = 'RNAlater';
							break;
						default:
							$import_summary[$summary_title]['@@WARNING@@']['Processing Agent unknown'][] = "See value [".$new_line_data['Processing Agent']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
							
					}
					//2.b-qcroc_collected_processed_according_sop
					$qcroc_collected_processed_according_sop = '';
					switch(strtolower($new_line_data['Collection and processing according SOP?'])) {
						case 'yes':
							$qcroc_collected_processed_according_sop = 'y';
							break;
						case 'no':
							$qcroc_collected_processed_according_sop = 'n';
							break;
						case '';
							break;
						default:
							$import_summary[$summary_title]['@@WARNING@@']['Collection and processing according SOP unknown'][] = "See value [".$new_line_data['Collection and processing according SOP?']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
					$aliquot_data = array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $sample_master_id,
							'aliquot_control_id' => $controls['sample_aliquot_controls']['tissue']['aliquots']['tube']['aliquot_control_id'],
							'barcode' => getNextTmpBarcode(),
							'aliquot_label' => $sample_tube_id,
							'in_stock' => 'yes - available',
							'use_counter' => '0',
							'notes'=> $new_line_data['Collection and processing Detail']),
						'AliquotDetail' => array(
							'qcroc_storage_method' => $qcroc_storage_method,
							'qcroc_storage_solution' => $qcroc_storage_solution,
							'qcroc_tissue_biopsy_big_than_1cm' => $qcroc_tissue_biopsy_big_than_1cm,
							'qcroc_tissue_biopsy_fragments' => $qcroc_tissue_biopsy_fragments,
							'qcroc_tissue_biopsy_carrot_size_cm' => $qcroc_tissue_biopsy_carrot_size_cm,
							'qcroc_collected_processed_according_sop' => $qcroc_collected_processed_according_sop));
					$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
					customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
					$tissue_tube_labels_to_ids[$sample_tube_id]['tube_aliquot_master_id'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
					//Add shipping information
					if(strlen($new_line_data['Shipping conditions correct?'].$new_line_data['Shipping detail'])) {
						$qcroc_compliant_processing = '';
						switch(strtolower($new_line_data['Shipping conditions correct?'])) {
							case 'yes':
								$qcroc_compliant_processing = 'y';
								break;
							case 'no':
								$qcroc_compliant_processing = 'n';
								break;
							case '';
							break;
							default:
								$import_summary[$summary_title]['@@WARNING@@']['Shipping conditions correct unknown'][] = "See value [".$new_line_data['Shipping conditions correct?']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						$aliquot_use = array(
							'aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id'],
							'type' => 'shipped to LDI',
							'qcroc_compliant_processing' => $qcroc_compliant_processing,
							'use_details' => $new_line_data['Shipping detail']
						);
						customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
					}
					if(strlen($prev_worksheet_line_data['Date Received'])) {
						$reception_date = getDateAndAccuracy($prev_worksheet_line_data, 'Date Received', $summary_title, $file_name, $prev_worksheet_line_data['worksheet'], $prev_worksheet_line_data['line']);
						$reception_date['accuracy'] = str_replace('c', 'h', $reception_date['accuracy']);
						if($reception_date['date']) {
							$aliquot_use = array(
								'aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id'],
								'type' => 'reception at LDI',
								'use_datetime' => $reception_date['date'],
								'use_datetime_accuracy' => $reception_date['accuracy']);
							customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
						}
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Sample Tube ID [$sample_tube_id] was not defined into the Sample worksheet (or has been defined twice in )! No tissue tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}			
			}
		}
	}
	foreach($tissue_tube_labels_to_ids as $sample_tube_id => $tmp) {
		if(is_null($tmp['tube_aliquot_master_id'])) {
			$import_summary[$summary_title]['@@WARNING@@']['Missing Tissue Tube Definition'][] = "Sample Tube Id [$sample_tube_id] was defined in Sample Worksheet but this one has not been listed into Tube Worksheet! No tube will be created! Please confirm and delete collection and smaple after migration (if required)! [file '$file_name' ($worksheet) - line: $line_counter]";
			unset($tissue_tube_labels_to_ids[$sample_tube_id]);
		}
	}
	
	// *4* Create Block **
	
	$tube_sample_master_ids_status_to_udpate = array();
	
	$worksheet = 'Block';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$sample_block_id = $new_line_data['Block Id'];
//TODO
if($sample_block_id == '01-1-008-1a') break;
			if(strlen($sample_block_id)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)([A-Za-z]+)$/', $sample_block_id, $matches)) {
					$sample_tube_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && !array_key_exists($sample_block_id, $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
						$sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
						//a-qcroc_storage_method & croc_storage_solution
						$qcroc_acceptance_status = strtolower($new_line_data['Acceptance Status']);
						if(!in_array($qcroc_acceptance_status, array('', 'block rejected','whole block accepted','partial block accepted'))) {
							$qcroc_acceptance_status = '';
							$import_summary[$summary_title]['@@WARNING@@']['Acceptance Status unknown'][] = "See value [".$new_line_data['Acceptance Status']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						//b-qcroc_macro_dissectable & qcroc_to_macro_dissect & qcroc_macrodissection_lines_on_slide
						$qcroc_macro_dissectable = '';
						$qcroc_to_macro_dissect = '';
						$qcroc_macrodissection_lines_on_slide = '';
						foreach(array('1' => 'Can it be macrodissected (pathologist)', '2' => 'Should it be macrodissected (technologist)', '3' => 'lines for macrodissection marked on slide') as $key => $excel_field) {
							$excel_value = strtolower($new_line_data[$excel_field]);
							$value = '';
							switch($excel_value) {
								case 'yes':
									$value = 'y';
									break;
								case 'no':
									$value = 'n';
									break;
								case '';
									break;
								default:
									$import_summary[$summary_title]['@@WARNING@@'][$excel_field.' unknown'][] = "See value [".$new_line_data[$excel_field]."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
							switch($key) {
								case '1':
									$qcroc_macro_dissectable = $value;
									break;
								case '2':
									$qcroc_to_macro_dissect = $value;
									break;
								case '3':
									$qcroc_macrodissection_lines_on_slide = $value;
									break;
							}							
						}
						//c-qcroc_acceptance_macrodissection_reason
						$qcroc_acceptance_macrodissection_reason = $new_line_data['Reasons'];
						//d-block_type
						$block_type = '';
						switch(strtolower($new_line_data['Block Type'])) {
							case 'frozen':
							case '';
								$block_type = strtolower($new_line_data['Block Type']);
								break;
							case 'oct':
								$block_type = 'OCT';
								break;
							default:
								$import_summary[$summary_title]['@@WARNING@@']['Block Type unknown'][] = "See value [".$new_line_data['Block Type']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
						}	
						$aliquot_data = array(
							'AliquotMaster' => array(
								'collection_id' => $collection_id,
								'sample_master_id' => $sample_master_id,
								'aliquot_control_id' => $controls['sample_aliquot_controls']['tissue']['aliquots']['block']['aliquot_control_id'],
								'barcode' => getNextTmpBarcode(),
								'aliquot_label' => $sample_block_id,
								'in_stock' => 'yes - available',
								'use_counter' => '0',
								'notes'=> $new_line_data['Comments on preparation\shipment']),
							'AliquotDetail' => array(
								'qcroc_acceptance_status' => $qcroc_acceptance_status,
								'qcroc_macro_dissectable' => $qcroc_macro_dissectable,
								'qcroc_to_macro_dissect' => $qcroc_to_macro_dissect,
								'qcroc_macrodissection_lines_on_slide' => $qcroc_macrodissection_lines_on_slide,
								'qcroc_acceptance_macrodissection_reason' => $qcroc_acceptance_macrodissection_reason,
								'block_type' => $block_type));
						$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
						customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
						$tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id] = array('id' => $aliquot_data['AliquotDetail']['aliquot_master_id'], 'slide_counter' => 0);
						//Create realiquoting relation
						$tube_aliquot_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['tube_aliquot_master_id'];
						$realiquoting_datetime = getDateAndAccuracy($new_line_data, 'Date of Block Creation', $summary_title, $file_name, $worksheet, $line_counter);
						$realiquoting_datetime['accuracy'] = str_replace('c', 'h', $realiquoting_datetime['accuracy']);
						$realiquoting_data = array(
							'parent_aliquot_master_id' => $tube_aliquot_master_id,	
							'child_aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id'],	
							'realiquoting_datetime' => $realiquoting_datetime['date'],	
							'realiquoting_datetime_accuracy' => $realiquoting_datetime['accuracy']);
						customInsert($realiquoting_data, 'realiquotings', __FILE__, __LINE__, true);	
						$tube_sample_master_ids_status_to_udpate[] = $tube_aliquot_master_id;
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Sample Tube ID [$sample_tube_id] for block [$sample_block_id] was not defined into the Sample worksheet or block was defined twice! No tissue block will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "Unable to extract Sample Tube ID  from block ID [$sample_block_id] based on block ID format! No block will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	if($tube_sample_master_ids_status_to_udpate) {
		$query = "UPDATE aliquot_masters SET in_stock = 'no' WHERE id IN (".implode(',',$tube_sample_master_ids_status_to_udpate).");";
		customQuery($query, __FILE__, __LINE__);
	}
	
	// *5* Create Slide **
	
	$worksheet = 'Slide';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$sample_slide_id = $new_line_data['Slide id'];
//TODO
if($sample_slide_id == '01-1-008-1a-l1') break;
			if(strlen($sample_slide_id)) {
				if(preg_match('/^(([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+)\-(.+)$/', $sample_slide_id, $matches)) {
					$sample_tube_id = $matches[2];
					$sample_block_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && array_key_exists($sample_block_id, $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						if(!array_key_exists($sample_slide_id, $tissue_tube_labels_to_ids[$sample_tube_id]['slide_aliquot_master_ids'])) {
							$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
							$sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
							$tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id]['slide_counter'] += 1;
							$slide_counter = $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id]['slide_counter'];
							$aliquot_data = array(
								'AliquotMaster' => array(
									'collection_id' => $collection_id,
									'sample_master_id' => $sample_master_id,
									'aliquot_control_id' => $controls['sample_aliquot_controls']['tissue']['aliquots']['slide']['aliquot_control_id'],
									'barcode' => getNextTmpBarcode(),
									'aliquot_label' => $sample_block_id.'-'.$slide_counter,
									'in_stock' => 'yes - available',
									'use_counter' => '0',
									'notes'=> $new_line_data['Comment on slide']),
								'AliquotDetail' => array(
									'qcroc_level' => $new_line_data['level']));
							$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
							customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['slide']['detail_tablename'], __FILE__, __LINE__, true);
							$tissue_tube_labels_to_ids[$sample_tube_id]['slide_aliquot_master_ids'][$sample_slide_id] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							//Create realiquoting relation
							$block_aliquot_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id]['id'];
							$realiquoting_data = array(
								'parent_aliquot_master_id' => $block_aliquot_master_id,
								'child_aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id']);
							customInsert($realiquoting_data, 'realiquotings', __FILE__, __LINE__, true);
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Sample Block ID [$sample_block_id] for slide [$sample_slide_id] was not defined into the Block worksheet! No tissue slide will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "Unable to extract Sample Tube and block ID from slide ID [$sample_slide_id] based on slide ID format! No slide will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}

	// *6* Slide Review **
	
	$tmp_patho_review_ids = array();
	
	$worksheet = 'Slide HQC';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$slide_revision_code = $new_line_data['HQC id'];
//TODO
if($slide_revision_code == '01-1-008-1a-l1-HQC1') break;
			if(strlen($slide_revision_code)) {
				if(preg_match('/^(([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+\-.+)\-(.+)$/', $slide_revision_code, $matches)) {		
					$sample_tube_id = $matches[2];
					$sample_slide_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && array_key_exists($sample_slide_id, $tissue_tube_labels_to_ids[$sample_tube_id]['slide_aliquot_master_ids'])) {
						$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
						$sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
						//Create specimen review
						$key = $sample_master_id.$new_line_data['Review by'].$new_line_data['Date'];
						if(!array_key_exists($key, $tmp_patho_review_ids)) {
							//Create speciemn review
							$review_date = 
							$review_date = getDateAndAccuracy($new_line_data, 'Date', $summary_title, $file_name, $worksheet, $line_counter);
							$review_date['accuracy'] = str_replace('c', 'h', $review_date['accuracy']);
							$review_data = array(
								'SpecimenReviewMaster' => array(
									'collection_id' => $collection_id,
									'sample_master_id' => $sample_master_id,
									'specimen_review_control_id' => $controls['specimen_review_controls']['tissue']['specimen_review_control_id'],
									'review_code' => $sample_tube_id.' '.$review_date['date'],
									'review_date' => $review_date['date'],
									'review_date_accuracy' => $review_date['accuracy'],
									'pathologist' => $new_line_data['Review by']),
								'SpecimenReviewDetail' => array());
							$review_data['SpecimenReviewDetail']['specimen_review_master_id'] = customInsert($review_data['SpecimenReviewMaster'], 'specimen_review_masters', __FILE__, __LINE__, false);
							customInsert($review_data['SpecimenReviewDetail'], $controls['specimen_review_controls']['tissue']['detail_tablename'], __FILE__, __LINE__, true);
							$tmp_patho_review_ids[$key] = $review_data['SpecimenReviewDetail']['specimen_review_master_id'];
						}
						$specimen_review_master_id = $tmp_patho_review_ids[$key];
						//Create aliquot review
						$detail_data = array();
						$fields_info = array(
							'sample_pct_tumor' => 'sample% tumor',
							'sample_pct_normal' => 'sample% normal',
							'sample_pct_necrosis' => 'sample%necrosis',
							'sample_pct_fibrosis' => 'sample%fibrosis',
							'tumor_pct_tumor_cells' => 'tumor%tumor cells',
							'tumor_pct_necrosis' => 'tumor% necrosis',
							'tumor_pct_benign_cell_non_neoplastic' => 'tumor% benign cell  non-neoplastic (fibrosis)',
							'tumor_pct_stroma' => 'tumor% stroma');
						foreach($fields_info as $db_field => $excel_field) {
							if(strlen($new_line_data[$excel_field])) {
								$detail_data[$db_field] = getDecimal($new_line_data, $excel_field, $summary_title, $file_name, $worksheet, $line_counter);
							}
						}
						foreach(array('can_be_microdisected' => 'Can sample be microdisected', 'microdissection_lines_marked' => 'Iines for microdissection marked') as $db_field => $excel_field) {
							$excel_value = strtolower($new_line_data[$excel_field]);
							switch($excel_value) {
								case 'yes':
									$detail_data[$db_field] = 'y';
									break;
								case 'no':
									$detail_data[$db_field] = 'n';
									break;
								case '';
									break;
								default:
									$import_summary[$summary_title]['@@WARNING@@'][$excel_field.' unknown'][] = "See value [".$new_line_data[$excel_field]."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						}
						$review_data = array(
							'AliquotReviewMaster' => array(
								'aliquot_master_id' => $tissue_tube_labels_to_ids[$sample_tube_id]['slide_aliquot_master_ids'][$sample_slide_id],
								'specimen_review_master_id' => $specimen_review_master_id,
								'aliquot_review_control_id' => $controls['aliquot_review_controls']['tissue slide']['aliquot_review_control_id'],
								'review_code' => $slide_revision_code,
								'qcroc_notes' => $new_line_data['Comments']),
							'AliquotReviewDetail' => $detail_data);
						$review_data['AliquotReviewDetail']['aliquot_review_master_id'] = customInsert($review_data['AliquotReviewMaster'], 'aliquot_review_masters', __FILE__, __LINE__, false);
						customInsert($review_data['AliquotReviewDetail'], $controls['aliquot_review_controls']['tissue slide']['detail_tablename'], __FILE__, __LINE__, true);
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Sample Slide ID [$sample_slide_id] for tissue tube [$sample_tube_id] was not defined into the Slide worksheet! No slide revision will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "Unable to extract Sample Tube and slide ID from slide revision code [$slide_revision_code] based on ID format! No slide revision will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	unset($tmp_patho_review_ids);
	
	// *7* Macro Dissection **	
	
//TODO Macro Dissection
	
	$chil_aliquot_master_ids = array('-1');
	$worksheet = 'Macrodissected Block';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$block_id = $new_line_data['Initial Block Id'];
//TODO
if($block_id == '01-1-008-1a') break;
			if(strlen($block_id)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+$/', $block_id, $matches)) {
					$sample_tube_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && array_key_exists($block_id, $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
						$tissue_sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
						$block_aliquot_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$block_id]['id'];
						$macrodissected = false;
						$macrodissection_date = getDateAndAccuracy($new_line_data, 'Date of cutting', $summary_title, $file_name, $worksheet, $line_counter);
						$macrodissection_date['accuracy'] = str_replace('c', 'h', $macrodissection_date['accuracy']);
						if($macrodissection_date['date'] || strtolower($new_line_data['Macrodissection']) == 'yes') {
							if(strtolower($new_line_data['Macrodissection']) == 'no') {
								$import_summary[$summary_title]['@@WARNING@@']['Macrodissection data conflict'][] = "Block [$block_id] was defined as not macrodissected but a date of cutting exist! A macrodissection has been created! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
							$aliquot_use = array(
								'aliquot_master_id' => $block_aliquot_master_id,
								'type' => 'macrodissection',
								'use_datetime' => $macrodissection_date['date'],
								'use_datetime_accuracy' => $macrodissection_date['accuracy'],
								'use_details' => $new_line_data['Sample Cutting Comments']
							);
							customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
							$macrodissected = true;
							$query = "UPDATE aliquot_masters SET in_stock = 'no' WHERE id = $block_aliquot_master_id;";
							customQuery($query, __FILE__, __LINE__);
						} else if(strlen($new_line_data['Sample Cutting Comments'])) {
							$import_summary[$summary_title]['@@WARNING@@']['No Macrodissection but a Sample Cutting Comments exists'][] = "See Block [$block_id]! Comment [".$new_line_data['Sample Cutting Comments']."] won't be recorded! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						if(strlen($new_line_data['Macrodissected Block Id'])) {
							if($macrodissected) {
								$in_stock = 'yes - available';
								if(strtolower($new_line_data['LeftOver Available']) == 'no') {
									$in_stock = 'no';
								}
								$aliquot_data = array(
									'AliquotMaster' => array(
										'collection_id' => $collection_id,
										'sample_master_id' => $tissue_sample_master_id,
										'aliquot_control_id' => $controls['sample_aliquot_controls']['tissue']['aliquots']['block']['aliquot_control_id'],
										'barcode' => getNextTmpBarcode(),
										'aliquot_label' => $new_line_data['Macrodissected Block Id'],
										'in_stock' => $in_stock,
										'use_counter' => '0'),
									'AliquotDetail' => array(
										'qcroc_left_over' => '1'));
								$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
								customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
								//Create realiquoting relation
								$realiquoting_data = array(
									'parent_aliquot_master_id' => $block_aliquot_master_id,
									'child_aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id'],
									'realiquoting_datetime' => $macrodissection_date['date'],
									'realiquoting_datetime_accuracy' => $macrodissection_date['accuracy']);
								customInsert($realiquoting_data, 'realiquotings', __FILE__, __LINE__, true);
								$chil_aliquot_master_ids[] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							} else {
								$import_summary[$summary_title]['@@ERROR@@']['Macrodissected Block Id with no macrodissection infomration'][] = "A left over block ID is defined [".$new_line_data['Macrodissected Block Id']."] but no macrodissection has been defined. Left over won't be created. [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						} else if(strtolower($new_line_data['LeftOver Available']) == 'yes') {
							$import_summary[$summary_title]['@@WARNING@@']['LeftOver Block defined as available but no ID defined'][] = "A left over block is defined as available for block [$block_id] but no left over block id exists. No left over block will be created. [file '$file_name' ($worksheet) - line: $line_counter]";
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Block ID [$block_id] for tissue tube [$sample_tube_id] was not defined into the block worksheet! No Macrodiseection data will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong Block Id'][] = "Unable to extract Sample Tube and Block Id from value [$block_id] based on ID format! No Macrodiseection data will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	$query = "UPDATE ".$controls['sample_aliquot_controls']['tissue']['aliquots']['block']['detail_tablename']." AS ParentDetail, realiquotings Realiquotting, ".$controls['sample_aliquot_controls']['tissue']['aliquots']['block']['detail_tablename']." AS ChildDetail
		SET ChildDetail.block_type = ParentDetail.block_type
		WHERE Realiquotting.parent_aliquot_master_id = ParentDetail.aliquot_master_id
		AND ChildDetail.aliquot_master_id = Realiquotting.child_aliquot_master_id
		AND ChildDetail.aliquot_master_id IN (".implode(',',$chil_aliquot_master_ids).");";
	customQuery($query, __FILE__, __LINE__);

	// *8* RNA **
	
//TODO 	$rna_volumes = array();	
// 	$worksheet = 'RNA Tube Aliquot';
	
	$tmp_rna_sample_master_ids =  array();
	$tmp_rna_aliquot_master_ids =  array();
	
	$worksheet = 'RNA tube';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$block_id = $new_line_data['Block'];
//TODO
if($block_id == '01-1-008-1a') break;
			if(strlen($block_id)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+$/', $block_id, $matches)) {
					$sample_tube_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && array_key_exists($block_id, $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						if(strlen($new_line_data['RNA Tube Id'])) {
							if(strlen($new_line_data['Date of isolation'])) {
								$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
								$tissue_sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
								$block_aliquot_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$block_id]['id'];
								$sample_key = $block_aliquot_master_id.$new_line_data['Date of isolation'].$new_line_data['Kit used'].$new_line_data['SOP followed'].$new_line_data['Lot Number'];
								//RNA Sample
								//Extraction date
								$extraction_date = getDateAndAccuracy($new_line_data, 'Date of isolation', $summary_title, $file_name, $worksheet, $line_counter);
								$extraction_date['accuracy'] = str_replace('c', 'h', $extraction_date['accuracy']);
								if(!array_key_exists($sample_key, $tmp_rna_sample_master_ids)) {
									//Kit
									$kit = strtolower($new_line_data['Kit used']);
									switch($kit) {
										case '':
										case 'allprep dna/rna':
										case 'allprep universal':
										case 'qiaamp dna mini':
										case 'rneasy plus mini kit':
										case 'trizol (for rna)':
										case 'universal':
											break;
										case 'allprepuniversal':
											$kit = 'allprep universal';
											break;
										default:
											$import_summary[$summary_title]['@@WARNING@@']['Kit used unknown'][] = "See value [".$new_line_data['Kit used']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
											$kit = '';
									}
									//SOP
									$sop = str_replace('N/AV', '', strtolower($new_line_data['SOP followed']));
									if(!in_array($sop, array('sop-tr-008', ''))){
										$import_summary[$summary_title]['@@WARNING@@']['SOP followed unknown'][] = "See value [".$new_line_data['SOP followed']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
										$sop = '';
									}
									//Create RNA Sample
									$sample_data = array(
										'SampleMaster' => array(
											'collection_id' => $collection_id,
											'sample_control_id' => $sample_aliquot_controls['rna']['sample_control_id'],
											'initial_specimen_sample_type' => 'tissue',
											'initial_specimen_sample_id' => $tissue_sample_master_id,
											'parent_sample_type' => 'tissue',
											'parent_id' => $tissue_sample_master_id,
											'notes' => $new_line_data['Comments on isolation']),
										'DerivativeDetail' => array(
											'creation_datetime' => $extraction_date['date'],
											'creation_datetime_accuracy' => $extraction_date['accuracy']),
										'SampleDetail' => array(
											'qcroc_sop' => $sop,
											'qcroc_kit' => $kit,
											'qcroc_lot_number' => $new_line_data['Lot Number']));
									$rna_sample_master_id = createSample($sample_data, $sample_aliquot_controls['rna']['detail_tablename']);
									$tmp_rna_sample_master_ids[$sample_key] = $rna_sample_master_id;
									//Create aliquot to sample link
									customInsert(array('sample_master_id' => $rna_sample_master_id, 'aliquot_master_id' => $block_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
								} else if(strlen($new_line_data['Comments on isolation'])) {
									$query = "UPDATE sample_masters SET notes = CONCAT('".str_replace("'","''",$new_line_data['Comments on isolation'])."', ' ',notes) WHERE id = ".$tmp_rna_sample_master_ids[$sample_key].";";
									customQuery($query, __FILE__, __LINE__);
								}
								$rna_sample_master_id = $tmp_rna_sample_master_ids[$sample_key];
								//Aliquot
								if(!array_key_exists($new_line_data['RNA Tube Id'], $tmp_rna_aliquot_master_ids)) {								
									$initial_volume = getDecimal($new_line_data, 'RNA Total Volume (µL) - T', $summary_title, $file_name, $worksheet, $line_counter);
									$concentration = getDecimal($new_line_data, 'RNA Conc (ng/ul)', $summary_title, $file_name, $worksheet, $line_counter);
									$yield = getDecimal($new_line_data, 'RNA yield (µg)', $summary_title, $file_name, $worksheet, $line_counter);
									$aliquot_data = array(
										'AliquotMaster' => array(
											'collection_id' => $collection_id,
											'sample_master_id' => $rna_sample_master_id,
											'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
											'aliquot_label' => $new_line_data['RNA Tube Id'],
											'barcode' => getNextTmpBarcode(),
											'in_stock' => 'yes - available',
											'initial_volume' => $initial_volume,
											'current_volume' => $initial_volume,
											//TODO: Check use counter and volume updated after migration and newVersionSetup() execution
											'use_counter' => '0',
											'storage_datetime' => $extraction_date['date'],
											'storage_datetime_accuracy' => $extraction_date['accuracy']),
										'AliquotDetail' => array(
											'concentration' => $concentration,
											'concentration_unit' => 'ng/ul',
											'qcroc_yield_ug' => $yield
										));
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									$tmp_rna_aliquot_master_ids[$new_line_data['RNA Tube Id']] = array($rna_sample_master_id , $aliquot_data['AliquotDetail']['aliquot_master_id']);
									//Quality Control
									$qc_data = array();
									$qc_date = getDateAndAccuracy($new_line_data, 'NANO DROP date', $summary_title, $file_name, $worksheet, $line_counter);
									$score_260_280 = getDecimal($new_line_data, '260 / 280', $summary_title, $file_name, $worksheet, $line_counter);
									if(strlen($score_260_280)) {
										$qc_data[] = array($rna_sample_master_id, $aliquot_data['AliquotDetail']['aliquot_master_id'], 'nano drop', $qc_date, $score_260_280, '260/280', $concentration, 'ng/ul', $yield, '', '');
									}
									$score_260_230 = getDecimal($new_line_data, '260 / 230', $summary_title, $file_name, $worksheet, $line_counter);
									if(strlen($score_260_230)) {
										$qc_data[] = array($rna_sample_master_id, $aliquot_data['AliquotDetail']['aliquot_master_id'], 'nano drop', $qc_date, $score_260_230, '260/230', $concentration, 'ng/ul', $yield, '', '');
									}
									createQC($qc_data);
								} else {
									$import_summary[$summary_title]['@@ERROR@@']['RNA tube defined twice'][] = "See RNA tube [".$new_line_data['RNA Tube Id']."]. No 2nd RNA and tube will be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
								}
							} else {
								$import_summary[$summary_title]['@@ERROR@@']['No RNA isolation Date'][] = "See RNA tube [".$new_line_data['RNA Tube Id']."]. No RNA and tube will be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Block ID [$block_id] for tissue tube [$sample_tube_id] was not defined into the block worksheet! No RNA extraction will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong Block Id'][] = "Unable to extract Sample Tube and Block Id from value [$block_id] based on ID format! No RNA extraction will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	unset($tmp_rna_sample_master_ids);
	
	$worksheet = 'RNA Tube QC';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$aliquot_label = $new_line_data['RNA Tube Id'];
if($aliquot_label == '01-1-008-1a-R1') break;	
			if(strlen($aliquot_label)) {
				if(array_key_exists($aliquot_label, $tmp_rna_aliquot_master_ids)) {
					list($sample_master_id, $aliquot_master_id) = $tmp_rna_aliquot_master_ids[$aliquot_label];
					//Barcode
					if(strlen($new_line_data['Aliquot barcode'])) {
						$query = "UPDATE aliquot_masters SET barcode = '".$new_line_data['Aliquot barcode']."' WHERE id = $aliquot_master_id;"; 
						customQuery($query, __FILE__, __LINE__);
					}
					//QC
					$qc_data = array();
					$qc_date = getDateAndAccuracy($new_line_data, 'Date processed', $summary_title, $file_name, $worksheet, $line_counter);
					$score_RIN = getDecimal($new_line_data, 'RIN', $summary_title, $file_name, $worksheet, $line_counter);
					$qcroc_concentration = getDecimal($new_line_data, '[RNA] (ng/ul)', $summary_title, $file_name, $worksheet, $line_counter);
					if(strlen($score_RIN)) {
						$scores['bioanalyzer'] = array($score_RIN,'RIN',$qcroc_concentration, ($qcroc_concentration? 'ng/ul' : ''), );
						$qc_data[] = array($sample_master_id, $aliquot_master_id, 'bioanalyzer', $qc_date, $score_RIN, 'RIN', $qcroc_concentration, ($qcroc_concentration? 'ng/ul' : ''), '', ((strtolower($new_line_data['RNA individual run picture']) == 'yes')? 'y' : ''), '');
					} else if(strlen($qcroc_concentration)) {
						$import_summary[$summary_title]['@@WARNING@@']['Concentration with no RIN'][] = "See label [$aliquot_label]. Values won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
					if(strtolower($new_line_data['RNA gel picture']) == 'yes') $qc_data[] = array($sample_master_id, $aliquot_master_id, 'agarose gel', $qc_date, '', '', '', '', '', 'y', '');
					createQc($qc_data);
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Unknown Aliquot'][] = "The label [$aliquot_label] was not defined into RNA tube worksheet. Values won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	unset($tmp_rna_aliquot_master_ids);
	
	// *9* DNA **
	
	//TODO 	
	// 	$worksheet = 'DNA Tube Aliquot';
	// 	$summary_title = "Tissue : $worksheet";
	
	$tmp_dna_sample_master_ids =  array();
	$tmp_dna_aliquot_master_ids =  array();
	
	$worksheet = 'DNA tube';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$block_id = $new_line_data['Block'];
//TODO
if($block_id == '01-1-008-1a') break;
			if(strlen($block_id)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+$/', $block_id, $matches)) {
					$sample_tube_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_tube_labels_to_ids) && array_key_exists($block_id, $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						if(strlen($new_line_data['DNA Tube Id'])) {
							if(strlen($new_line_data['IsolationDate'])) {
								$collection_id = $tissue_tube_labels_to_ids[$sample_tube_id]['collection_id'];
								$tissue_sample_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['sample_master_id'];
								$block_aliquot_master_id = $tissue_tube_labels_to_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$block_id]['id'];
								$sample_key = $block_aliquot_master_id.$new_line_data['IsolationDate'].$new_line_data['Kit'];
								//DNA Sample
								//Extraction date
								$extraction_date = getDateAndAccuracy($new_line_data, 'IsolationDate', $summary_title, $file_name, $worksheet, $line_counter);
								$extraction_date['accuracy'] = str_replace('c', 'h', $extraction_date['accuracy']);
								if(!array_key_exists($sample_key, $tmp_dna_sample_master_ids)) {
									//Kit
									$kit = strtolower($new_line_data['Kit']);
									switch($kit) {
										case '':
										case 'allprep dna/rna':
										case 'allprep universal':
										case 'qiaamp dna mini':
										case 'qiaamp mini kit':
										case 'rneasy plus mini kit':
										case 'trizol (for dna)':
										case 'universal':
											break;
										case 'allprepuniversal':
											$kit = 'allprep universal';
											break;
										case 'allprepdna/dna':
											$kit = 'allprep dna/dna';
											break;
										default:
											$import_summary[$summary_title]['@@WARNING@@']['Kit used unknown'][] = "See value [".$new_line_data['Kit']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
											$kit = '';
									}
									//Create DNA Sample
									$sample_data = array(
										'SampleMaster' => array(
											'collection_id' => $collection_id,
											'sample_control_id' => $sample_aliquot_controls['dna']['sample_control_id'],
											'initial_specimen_sample_type' => 'tissue',
											'initial_specimen_sample_id' => $tissue_sample_master_id,
											'parent_sample_type' => 'tissue',
											'parent_id' => $tissue_sample_master_id,
											'notes' => $new_line_data['Comment on isolation']),
										'DerivativeDetail' => array(
											'creation_datetime' => $extraction_date['date'],
											'creation_datetime_accuracy' => $extraction_date['accuracy']),
										'SampleDetail' => array(
											'qcroc_kit' => $kit));
									$dna_sample_master_id = createSample($sample_data, $sample_aliquot_controls['dna']['detail_tablename']);
									$tmp_dna_sample_master_ids[$sample_key] = $dna_sample_master_id;
									//Create aliquot to sample link
									customInsert(array('sample_master_id' => $dna_sample_master_id, 'aliquot_master_id' => $block_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
								} else if(strlen($new_line_data['Comment on isolation'])) {
									$query = "UPDATE sample_masters SET notes = CONCAT('".str_replace("'","''",$new_line_data['Comment on isolation'])."', ' ',notes) WHERE id = ".$tmp_dna_sample_master_ids[$sample_key].";";
									customQuery($query, __FILE__, __LINE__);
								}
								$dna_sample_master_id = $tmp_dna_sample_master_ids[$sample_key];
								//Aliquot
								if(!array_key_exists($new_line_data['DNA Tube Id'], $tmp_dna_aliquot_master_ids)) {
									$initial_volume = getDecimal($new_line_data, 'DNA Volume (µL) - T: Transferred', $summary_title, $file_name, $worksheet, $line_counter);
									$concentration = getDecimal($new_line_data, 'DNA Conc (ng/µL)', $summary_title, $file_name, $worksheet, $line_counter);
									$yield = getDecimal($new_line_data, 'Nanodrop DNA yield (µg)', $summary_title, $file_name, $worksheet, $line_counter);
									$aliquot_data = array(
										'AliquotMaster' => array(
											'collection_id' => $collection_id,
											'sample_master_id' => $dna_sample_master_id,
											'aliquot_control_id' => $sample_aliquot_controls['dna']['aliquots']['tube']['aliquot_control_id'],
											'aliquot_label' => $new_line_data['DNA Tube Id'],
											'barcode' => getNextTmpBarcode(),
											'in_stock' => 'yes - available',
											'initial_volume' => $initial_volume,
											'current_volume' => $initial_volume,
											//TODO: Check use counter and volume updated after migration and newVersionSetup() execution
											'use_counter' => '0',
											'storage_datetime' => $extraction_date['date'],
											'storage_datetime_accuracy' => $extraction_date['accuracy']),
										'AliquotDetail' => array(
											'concentration' => $concentration,	//TODO use Nanodrop: Confirm.
											'concentration_unit' => 'ng/ul',
											'qcroc_yield_ug' => $yield));		//TODO use Nanodrop: Confirm.
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['dna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									$tmp_dna_aliquot_master_ids[$new_line_data['DNA Tube Id']] = array($dna_sample_master_id , $aliquot_data['AliquotDetail']['aliquot_master_id']);
									//Quality Control
									$qc_data = array();
									$qc_date = getDateAndAccuracy($new_line_data, 'NANO DROP date', $summary_title, $file_name, $worksheet, $line_counter);
									$score_260_280 = getDecimal($new_line_data, '260 / 280', $summary_title, $file_name, $worksheet, $line_counter);
									if(strlen($score_260_280)) {
										$qc_data[] = array($dna_sample_master_id, $aliquot_data['AliquotDetail']['aliquot_master_id'], 'nano drop', $qc_date, $score_260_280, '260/280', $concentration, 'ng/ul', $yield, '', '');
									}
									$score_260_230 = getDecimal($new_line_data, '260 / 230', $summary_title, $file_name, $worksheet, $line_counter);
									if(strlen($score_260_230)) {
										$qc_data[] = array($dna_sample_master_id, $aliquot_data['AliquotDetail']['aliquot_master_id'], 'nano drop', $qc_date, $score_260_230, '260/230', $concentration, 'ng/ul', $yield, '', '');
									}
									$qc_date = getDateAndAccuracy($new_line_data, 'PICOGREEN Date', $summary_title, $file_name, $worksheet, $line_counter);
//TODO pourquoi la date du PICOGREEN  du tube 01-1-001-2a-D1 est le 5 dans ATiM et pas le 4								
									$concentration = getDecimal($new_line_data, 'PICOGREEN DNA Conc.  (ng/µl)', $summary_title, $file_name, $worksheet, $line_counter);
									$yield = getDecimal($new_line_data, 'Picogreen DNA yield (µg)', $summary_title, $file_name, $worksheet, $line_counter);
									if(strlen($qc_date['date'].$concentration.$yield)) {
										$qc_data[] = array($dna_sample_master_id, $aliquot_data['AliquotDetail']['aliquot_master_id'], 'picogreen', $qc_date, '', '', $concentration, 'ng/ul', $yield, '', '');	
									}
									createQC($qc_data);									
								} else {
									$import_summary[$summary_title]['@@ERROR@@']['DNA tube defined twice'][] = "See DNA tube [".$new_line_data['DNA Tube Id']."]. No 2nd DNA and tube will be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
								}
							} else {
								$import_summary[$summary_title]['@@ERROR@@']['No DNA isolation Date'][] = "See DNA tube [".$new_line_data['DNA Tube Id']."]. No DNA and tube will be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['No Sample'][] = "The Block ID [$block_id] for tissue tube [$sample_tube_id] was not defined into the block worksheet! No DNA extraction will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong Block Id'][] = "Unable to extract Sample Tube and Block Id from value [$block_id] based on ID format! No DNA extraction will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	unset($tmp_dna_sample_master_ids);
	
	$worksheet = 'DNA QC';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$aliquot_label = $new_line_data['DNA Tube Id'];
if($aliquot_label == '01-1-008-1a-D1') break;			
			if(strlen($aliquot_label)) {
				if(array_key_exists($aliquot_label, $tmp_dna_aliquot_master_ids)) {
					list($sample_master_id, $aliquot_master_id) = $tmp_dna_aliquot_master_ids[$aliquot_label];
					//Barcode
					if(strlen($new_line_data['Aliquot barcode'])) {
						$query = "UPDATE aliquot_masters SET barcode = '".$new_line_data['Aliquot barcode']."' WHERE id = $aliquot_master_id;";
						customQuery($query, __FILE__, __LINE__);
					}
					//QC
					$qc_data = array();
					$qc_date = getDateAndAccuracy($new_line_data, 'Date processed', $summary_title, $file_name, $worksheet, $line_counter);
					if(strtolower($new_line_data['DNA Quality (Gel)']) == 'yes' || $qc_date['date']) {	//TODO confirm
						$conclusion = strtolower($new_line_data['DNA QA']);
						switch($conclusion) {
							case 'ok':
							case 'below limit of detection':
								break;
							case 'unknown':
							case 'ND':
								$conclusion = '';
								break;
							default :
								$conclusion = '';
								$import_summary[$summary_title]['@@WARNING@@']['Unknown DNA QA value'][] = "See value [".$new_line_data['DNA QA']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						$qc_data = array(array($sample_master_id, $aliquot_master_id, 'agarose gel', $qc_date, '', '', '', '', '', '', $conclusion));
						createQC($qc_data);
					} else if(!in_array($new_line_data['DNA QA'], array('ND','Below limit of detection','OK'))){
						$import_summary[$summary_title]['@@WARNING@@']['DNA QA with no date'][] = "Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Unknown Aliquot'][] = "The label [$aliquot_label] was not defined into DNA tube worksheet. Values won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

function loadBlood(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;

	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];

	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

	$blood_collection_labels_to_ids = array();

	//*** UHL ***

	$worksheet = 'UHL';
	$summary_title = "Blood : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 2) {
			$headers = $new_line;
		} else if($line_counter > 2){
			// *1* Create Collection **
			$new_line_data = formatNewLineData($headers, $new_line);
			$collection_id = getCollectionId($new_line_data['study'], $new_line_data['Patient Id'], 'B', $new_line_data['Visit Id'], $new_line_data['CollectionDate'], $new_line_data['CollectionTime'], $new_line_data['Site'], '', $summary_title, $file_name, $worksheet, $line_counter);
			$collection_key = $new_line_data['study'].'/'.$new_line_data['Patient Id'].'/'.$new_line_data['Visit Id'].'/'.$new_line_data['CollectionDate'].'/'.$new_line_data['CollectionTime'].'/'.$new_line_data['Site'];
			$blood_collection_labels_to_ids[$collection_key]['collection_id'] = $collection_id;
			// *2* Create Blood **
			$blood_type = '';
			$derivative_type = null;
			switch($new_line_data['Type']){
				case 'EDTA':
					$derivative_type = 'plasma';
				case 'Buffy Coat':
					$blood_type = 'EDTA';
					if(!$derivative_type) $derivative_type = 'pbmc';
					break;
				case 'CTAD':
					$blood_type = 'CTAD';
					$derivative_type = 'plasma';
					break;
				default:
				$import_summary[$summary_title]['@@ERROR@@']['Blood type not supported'][] = "See value [".$new_line_data['Type']."]! [file '$file_name' ($worksheet) - line: $line_counter]";	
			}
			if($blood_type) {
				$blood_key = 'Blood:'.$blood_type;
				if(!array_key_exists($blood_key, $blood_collection_labels_to_ids[$collection_key])) {
					$sample_data = array(
						'SampleMaster' => array(
							'collection_id' => $collection_id,
							'sample_control_id' => $controls['sample_aliquot_controls']['blood']['sample_control_id'],
							'initial_specimen_sample_type' => 'blood'),
						'SpecimenDetail' => array(),
						'SampleDetail' => array('blood_type' => $blood_type));
					$blood_collection_labels_to_ids[$collection_key][$blood_key] = createSample($sample_data, $controls['sample_aliquot_controls']['blood']['detail_tablename']);
				}
				$blood_sample_master_id = $blood_collection_labels_to_ids[$collection_key][$blood_key];
				// *3* Create plasma/buffy coat **
				$derivative_key = $blood_key.'/'.$derivative_type.':'.$new_line_data['ProcessingDate'].'+'.$new_line_data['ProcessingTime'];
				if(!array_key_exists($derivative_key, $blood_collection_labels_to_ids[$collection_key])) {
					$date_of_derivative_creation = getDateTimeAndAccuracy($new_line_data, 'ProcessingDate', 'ProcessingTime', $summary_title, $file_name, $worksheet, $line_counter);
					$sample_data = array(
						'SampleMaster' => array(
							'collection_id' => $collection_id,
							'sample_control_id' => $controls['sample_aliquot_controls'][$derivative_type]['sample_control_id'],
							'initial_specimen_sample_type' => 'blood',
							'initial_specimen_sample_id' => $blood_sample_master_id,
							'parent_sample_type' => 'blood',
							'parent_id' => $blood_sample_master_id),
						'DerivativeDetail' => array(
							'creation_datetime' => $date_of_derivative_creation['datetime'],
							'creation_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
						'SampleDetail' => array());
					$blood_collection_labels_to_ids[$collection_key][$derivative_key] = createSample($sample_data, $controls['sample_aliquot_controls'][$derivative_type]['detail_tablename']);
				}
				$derivative_sample_master_id = $blood_collection_labels_to_ids[$collection_key][$derivative_key];
				// *4* Derivative Aliquot **
				if(strlen($new_line_data['Aliquot Id (value)'])) {
					$barcode = '';
					if(empty($new_line_data['BarCode']))  {
						$import_summary[$summary_title]['@@WARNING@@']['Blood Barcode Is Missing'][] = "See line $line_counter! [file '$file_name' ($worksheet) - line: $line_counter]";	
						$barcode = getNextTmpBarcode(); 
					} else {
						$barcode = $new_line_data['BarCode'];
					}
					$storage_date = getDateTimeAndAccuracy($new_line_data, 'StorageDate', "StorageTime", $summary_title, $file_name, $worksheet, $line_counter);
					$initial_volume = getDecimal($new_line_data, 'Volume', $summary_title, $file_name, $worksheet, $line_counter);
					if(strtolower($new_line_data['VolumeUnit']) != 'ul'){
						$import_summary[$summary_title]['@@ERROR@@']['Blood volume unit not supported'][] = "See value [".$new_line_data['VolumeUnit']."]! [file '$file_name' ($worksheet) - line: $line_counter]";
						$initial_volume = '';
					} else {
						$initial_volume = $initial_volume/1000;
					}
					$hemolysis_signs = '';
					switch($new_line_data['SampleColor']) {
						case 'Red';
							$hemolysis_signs = 'y';
							break;
						case 'Yellow';
							$hemolysis_signs = 'n';
							break;
						default:
							$import_summary[$summary_title]['@@WARNING@@']['Blood Sample Color Not Supported'][] = "See value [".$new_line_data['SampleColor']."]! [file '$file_name' ($worksheet) - line: $line_counter]";	
					}			
					$storage_master_id = getStorageMasterId($new_line_data['Box'], 'blood', $summary_title, $file_name, $worksheet, $line_counter);
					$storage_coordinates = getPosition($new_line_data['Box'], $new_line_data['BoxLocation'], 'blood', $summary_title, $file_name, $worksheet, $line_counter);
					$aliquot_data = array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $derivative_sample_master_id,
							'aliquot_control_id' => $controls['sample_aliquot_controls'][$derivative_type]['aliquots']['tube']['aliquot_control_id'],
							'barcode' => $barcode,
							'aliquot_label' => $new_line_data['Aliquot Id (value)'],
							'in_stock' => 'yes - available',
							'initial_volume' => $initial_volume,
							'current_volume' => $initial_volume,
							'use_counter' => '0',
							'storage_datetime' => $storage_date['datetime'],
							'storage_datetime_accuracy' => $storage_date['accuracy'],
							'storage_master_id' => $storage_master_id,
							'storage_coord_x' => $storage_coordinates['x'],
							'storage_coord_y' => $storage_coordinates['y'],
							'notes'=> $new_line_data['Comments']),
						'AliquotDetail' => array(
							'hemolysis_signs' => $hemolysis_signs));
					$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
					customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls'][$derivative_type]['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Empty Aliquot ID'][] = "See blood aliquotat line $line_counter. No ID then no aliquot will be created. [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
}

function getCollectionId($study_id, $patient_qcroc_id, $collection_type, $collection_visit, $excel_collection_date, $excel_collection_time, $collection_site, $notes, $summary_title, $file_name, $worksheet, $line_counter){
	global $import_summary;
	global $import_date;
	global $controls;
	global $patient_qcroc_ids_to_part_and_col_ids;
	
	$study_id = str_replace("'", "", $study_id);
	if(!preg_match('/^0[1-3]*$/',$study_id)) die('ERR323672673262733.1=d'.$study_id);
	$misc_identifier_control_name = "QCROC-$study_id";
	if(preg_match('/^0*([1-9][0-9]*)$/', $patient_qcroc_id, $matches)) {
		$patient_qcroc_id = $matches[1];
	} else {
		die('ERR323672673262733.2=d'.$patient_qcroc_id);
	}
	if(!in_array($collection_type, array('T','B'))) die('ERR323672673262733.3='.$collection_type);
	if(preg_match('/^0*([1-9][0-9]*)$/', $collection_visit, $matches)) {
		$collection_visit = $matches[1];
	} else {
		die('ERR323672673262733.4=d'.$collection_visit);
	}
	
	//Participant Management
	
	if(!array_key_exists($patient_qcroc_id, $patient_qcroc_ids_to_part_and_col_ids)) {
		//Create Participant
		$data = array('participant_identifier' => (sizeof($patient_qcroc_ids_to_part_and_col_ids) + 1), 'last_modification' => $import_date);
		$atim_participant_id  = customInsert($data, 'participants', __FILE__, __LINE__);
		$patient_qcroc_ids_to_part_and_col_ids[$patient_qcroc_id] = array('participant_id' => $atim_participant_id, 'collections' => array());
		//Create MiscIdentifier
		$data = array(
			'misc_identifier_control_id' => $controls['MiscIdentifierControl'][$misc_identifier_control_name]['id'],
			'participant_id' => $atim_participant_id,
			'flag_unique' => $controls['MiscIdentifierControl'][$misc_identifier_control_name]['flag_unique'],
			'identifier_value' => $patient_qcroc_id);
		customInsert($data, 'misc_identifiers', __FILE__, __LINE__, false);
	} 
	$atim_participant_id = $patient_qcroc_ids_to_part_and_col_ids[$patient_qcroc_id]['participant_id'];
	
	//Collection Management
	if(!$excel_collection_time) {
		$collection_date = getDateAndAccuracy(array('Date' => $excel_collection_date), 'Date', $summary_title, $file_name, $worksheet, $line_counter);
		$collection_date['accuracy'] = str_replace('c', 'h', $collection_date['accuracy']);
	} else {
		$collection_date = getDateTimeAndAccuracy(array('Date' => $excel_collection_date, 'Time' => $excel_collection_time), 'Date', 'Time', $summary_title, $file_name, $worksheet, $line_counter);
	}
	$collection_key = "$study_id/$collection_type/$collection_visit/".(array_key_exists('date', $collection_date)? $collection_date['date']: $collection_date['datetime'])."//".$collection_date['accuracy']."/$collection_site";
	if(!array_key_exists($collection_key, $patient_qcroc_ids_to_part_and_col_ids[$patient_qcroc_id]['collections'])) {
		switch($collection_site) {
			case 'JGH':
			case 'UHL':
			case '':
				break;
			default;
			$import_summary[$summary_title]['@@WARNING@@']['Collection Site Unknown'][] = "See value [$collection_site]! No collection site will be set! [file '$file_name' ($worksheet) - line: $line_counter]";
			$collection_site = '';
		}
		$collection_data = array(
			'participant_id' => $atim_participant_id,
			'collection_datetime' => (array_key_exists('date', $collection_date)? $collection_date['date']: $collection_date['datetime']),
			'collection_datetime_accuracy' => $collection_date['accuracy'],
			'collection_property' => 'participant collection',
			'collection_site' => $collection_site,
			'qcroc_collection_visit' => $collection_visit,
			'qcroc_misc_identifier_control_id' => $controls['MiscIdentifierControl'][$misc_identifier_control_name]['id'],
			'qcroc_collection_type' => $collection_type,
			'collection_notes' => $notes);
		$patient_qcroc_ids_to_part_and_col_ids[$patient_qcroc_id]['collections'][$collection_key] = customInsert($collection_data, 'collections', __FILE__, __LINE__); 
	} else if(strlen($notes)) {
		$notes = str_replace("'", "''", $notes);
		$query = "UPDATE collections SET notes = CONCAT('$notes', ' ', notes) WHERE id = ".$patient_qcroc_ids_to_part_and_col_ids[$patient_qcroc_id]['collections'][$collection_key].";";
		customQuery($query, __FILE__, __LINE__);
	}
	
	return $patient_qcroc_ids_to_part_and_col_ids[$patient_qcroc_id]['collections'][$collection_key];
}

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

function createQC($qc_data) {
	global $qc_code_counter;
	foreach($qc_data as $new_qc) {
		$qc_code_counter++;
		list($sample_master_id, $aliquot_master_id, $type, $qc_date, $score, $unit, $concentration, $qcroc_concentration_unit, $yield, $picture, $conclusion) = $new_qc;
		$qc_data = array(
			'qc_code' => $qc_code_counter,
			'sample_master_id' => $sample_master_id,
			'aliquot_master_id' => $aliquot_master_id,
			'used_volume' => '',
			'type' => $type,
			'date' => $qc_date['date'],
			'date_accuracy' => $qc_date['accuracy'],
			'score' => $score,
			'unit' => $unit,
			'qcroc_concentration' => $concentration,
			'qcroc_concentration_unit' => $qcroc_concentration_unit,
			'qcroc_yield_ug' => $yield,
			'qcroc_picture' => $picture,
			'conclusion' => $conclusion,
			'notes' => '');
		customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
	}
}

function getNextTmpBarcode() {
	global $tmp_barcode;
	$tmp_barcode++;
	return 'SYS#'.$tmp_barcode;
}

function getBoxStorageUniqueKey($excel_storage_label, $sample_type) {
	if(!$excel_storage_label) {
		die('ERR 283ee234342.1');
	} else {
		switch($sample_type) {
			case 'tissue':
				return 'tissue-'.$excel_storage_label;
			case 'blood':
				return 'blood-'.$excel_storage_label;
			default:
				die('ERR 283ee234342.2');
		}
	}
}

function getStorageMasterId($excel_storage_label, $sample_type, $summary_title, $file_name, $worksheet, $line_counter) {
	global $controls;
	global $storage_master_ids;
	global $last_storage_code;
	global $import_summary;

	$excel_storage_label = $excel_storage_label;
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
			$storage_type = null;
			switch($sample_type) {
				//TODORemove? 				case 'tissue':
				// 				case 'serum':
				// 				case 'plasma':
				// 				case 'pbmc':
				// 				case 'concentrated urine':
				// 				case 'rna':
				// 					if(preg_match('/^(R[0-9]+)(B[0-9]+)$/',$excel_storage_label, $matches)) {
				// 						$rack_label = $matches[1];
				// 						$box_label = $matches[2];
				// 					} else {
				// 						$import_summary[$summary_title]['@@ERROR@@']["Unable to extract both rack and box labels"][] = "Unable to extract the rack and box labels for $sample_type box with value '$excel_storage_label'. Box label will be set to '$excel_storage_label' and no rack will be created. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter]";
				// 						$box_label = $excel_storage_label;
				// 					}
				// 					break;
				case 'blood':
					$box_label = $excel_storage_label;
					$storage_type = 'box100';
					break;
				default:
					die('ERR 283728 7628762');
			}
			if(!$box_label) die('ERR 232 87 6287632.2');
			//create rack
			$parent_storage_master_id = null;
			if($rack_label) {
				die('TODO...36273828832');
				//TODO Remove? 				$rack_storage_unique_key = 'rack'.$rack_label;
				// 				if(array_key_exists($rack_storage_unique_key, $storage_master_ids)) {
				// 					$parent_storage_master_id = $storage_master_ids[$rack_storage_unique_key]['storage_master_id'];
				// 				} else {
				// 					$storage_controls_data = $controls['storage_controls']['rack16'];
				// 					$last_storage_code++;
				// 					$storage_data = array(
				// 						'StorageMaster' => array(
				// 							"code" => 'tmp'.$last_storage_code,
				// 							"short_label" => $rack_label,
				// 							"selection_label" => $rack_label,
				// 							"storage_control_id" => $storage_controls_data['storage_control_id'],
				// 							"parent_id" => null),
				// 						'StorageDetail' => array());
				// 					$storage_data['StorageDetail']['storage_master_id'] = customInsert($storage_data['StorageMaster'], 'storage_masters', __FILE__, __LINE__, false);
				// 					customInsert($storage_data['StorageDetail'],$storage_controls_data['detail_tablename'], __FILE__, __LINE__, true);
				// 					$parent_storage_master_id = $storage_data['StorageDetail']['storage_master_id'];
				// 					$storage_master_ids[$rack_storage_unique_key] = array('storage_master_id' => $parent_storage_master_id, 'storage_type' => 'rack16');
				// 				}
			}
			//create box
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

function getPosition($excel_storage_label, $excel_postions, $sample_type, $summary_title, $file_name, $worksheet, $line_counter) {
	global $storage_master_ids;
	global $controls;
	global $import_summary;
	$excel_postions = $excel_postions;
	$positions = array('x'=>null, 'y'=>null);
	if(empty($excel_postions)) {
		//Nothing to do
	} else if(empty($excel_storage_label)) {
		$import_summary[$summary_title]['@@ERROR@@']["Storage position but no box label defined"][] = "No position will be set. [file '$file_name' :: $worksheet - line: $line_counter]";
	} else {
		$box_storage_unique_key = getBoxStorageUniqueKey($excel_storage_label, $sample_type);
		if(!array_key_exists($box_storage_unique_key, $storage_master_ids))  die('ERR 2387 628763287.2');
		$storage_type = $storage_master_ids[$box_storage_unique_key]['storage_type'];
		switch($storage_type) {
			case 'box27 1A-9C':
				if(preg_match('/^([A-C])([1-9])$/', $excel_postions, $matches)) {
					$positions['x'] = $matches[2];
					$positions['y'] = $matches[1];
				}
				break;
			case 'box100':
				if(preg_match('/^(([1-9])|([1-9][0-9])|(100))$/', $excel_postions)) $positions['x'] = $excel_postions;
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
			default:
				die('ERR327632767326 '.$storage_type);
		}
		if(is_null($positions['x'])) $import_summary[$summary_title]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box ($storage_type) is wrong. No position will be set. [file '$file_name' :: $worksheet - line: $line_counter]";
	}
	return $positions;
}

?>