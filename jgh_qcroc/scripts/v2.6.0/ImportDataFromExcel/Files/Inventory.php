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
								$block_type = $new_line_data['Block Type'];
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
						$key = $new_line_data['Review by'].$new_line_data['Date'].md5($new_line_data['Comments']);
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
									'pathologist' => $new_line_data['Review by'],
									'notes'=> $new_line_data['Comments']),
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
								if(preg_match('/^[0-9\.]$', $new_line_data[$excel_field])) {
									$detail_data[$db_field] = $new_line_data[$excel_field];
								} else {
									$import_summary[$summary_title]['@@WARNING@@'][$excel_field.' unknown'][] = "See value [".$new_line_data[$excel_field]."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
								}
							}
						}
						foreach(array('can_be_microdisected' => 'Can sample be microdisected', 'microdissection_lines_marked' => 'Iines for microdissection_lines_marked') as $db_field => $excel_field) {
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
								'review_code' => $slide_revision_code),
							'AliquotReviewDetail' => $detail_data);
						$review_data['AliquotReviewMaster']['aliquot_review_master_id'] = customInsert($review_data['AliquotReviewMaster'], 'aliquot_review_masters', __FILE__, __LINE__, false);
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
				// 				case 'tissue':
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
				// 				$rack_storage_unique_key = 'rack'.$rack_label;
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

//TODO remove code below ==================================================================================================================================================================================
// ==================================================================================================================================================================================
// ==================================================================================================================================================================================
// ==================================================================================================================================================================================


function loadTissue2($participant_id, $participant_identifier, &$psp_nbr_to_frozen_blocks_data, &$psp_nbr_to_paraffin_blocks_data, &$patho_nbr, $file_name, $worksheet, $line_counter, $new_line_data) {
	global $import_summary;
	global $controls;
	
	//*** PROSTATECTOMY + COLLECTION **
	
	$treatment_controls = $controls['TreatmentControl']['procure follow-up worksheet - treatment'];
	$prostatectomy_data = array();
	if($new_line_data['chirurgie fait'] == '1') {
		//Set prostatectomy data
		$date_of_prostatectomy = getDateAndAccuracy($new_line_data, 'date chirurgie', 'Inventory - Tissue', $file_name, $line_counter);
		$prostatectomy_data = array(
			'TreatmentMaster' => array(
				'participant_id' => $participant_id,
				'procure_form_identification' => "$participant_identifier  Vx -FSPx",
				'treatment_control_id' => $treatment_controls['treatment_control_id'],
				'start_date' => $date_of_prostatectomy['date'],
				'start_date_accuracy' => $date_of_prostatectomy['accuracy']),
			'TreatmentDetail' => array(
				'treatment_type' => 'prostatectomy'));
	} else {
		$comments = array();
		foreach(array('chirurgie fait', 'Tissus prélevé congelé') as $field) {
			if(!(preg_match('/^((0)|(non))$/', $new_line_data[$field]) || !strlen($new_line_data[$field]))) $comments[] = $new_line_data[$field];
		}
		if($comments) {
			$import_summary['Inventory - Tissue']['@@WARNING@@']['No prostatectomy but a surgery (or collection) comment has been added'][] = "See patient '$participant_identifier' with note(s) [".implode(' & ', $comments)."]. This note won't be migrated and has to be recorded manually by the user if required. [fields 'chirurgie fait' & 'Tissus prélevé congelé' - file '$file_name' :: $worksheet - line: $line_counter]";
		}		
	}
	$collection_id = null;
	$collection_data = null;
	if($prostatectomy_data) {
		if(in_array($new_line_data['Tissus prélevé congelé'], array('1', '1 retour patho')) ){
			//Create collection + add retour patho if required
			$date_of_collection = getDateTimeAndAccuracy($new_line_data, 'date chirurgie', "hre de prélèvement tissus (sortie de l'abdomen)", 'Inventory - Tissue', $file_name, $line_counter);
			$collection_data = array(
				'participant_id' => $participant_id,
				'collection_datetime' => $date_of_collection['datetime'],
				'collection_datetime_accuracy' => $date_of_collection['accuracy'],
				'collection_property' => 'participant collection',
				'collection_notes' => ($new_line_data['Tissus prélevé congelé'] == '1 retour patho')? '1 retour patho' : '',
				'procure_visit' => 'V01');				
			$collection_id = customInsert($collection_data, 'collections', __FILE__, __LINE__);	
		} else if(!preg_match('/^((0)|(non))$/', $new_line_data['Tissus prélevé congelé']) || !strlen($new_line_data['Tissus prélevé congelé'])) {
			$prostatectomy_data['TreatmentMaster']['notes'] = "Pas de tissu collecté (".$new_line_data['Tissus prélevé congelé'].').';
		}
		//Create prostatectomy
		$prostatectomy_data['TreatmentDetail']['treatment_master_id'] = customInsert($prostatectomy_data['TreatmentMaster'], 'treatment_masters', __FILE__, __LINE__, false);
		customInsert($prostatectomy_data['TreatmentDetail'], $treatment_controls['detail_tablename'], __FILE__, __LINE__, true);	
	}
	
	//*** TISSUE SAMPLE **
	
	$patient_frozen_block_data = array();
	if(array_key_exists($participant_identifier, $psp_nbr_to_frozen_blocks_data['blocks'])) {
		$patient_frozen_block_data = $psp_nbr_to_frozen_blocks_data['blocks'][$participant_identifier];
		unset($psp_nbr_to_frozen_blocks_data['blocks'][$participant_identifier]);
	}	
	
	$patient_paraffin_block_data = array();
	if(array_key_exists($participant_identifier, $psp_nbr_to_paraffin_blocks_data['blocks'])) {
		$patient_paraffin_block_data = $psp_nbr_to_paraffin_blocks_data['blocks'][$participant_identifier];
		unset($psp_nbr_to_paraffin_blocks_data['blocks'][$participant_identifier]);
	}
	
	if($collection_id) {
		$tissue_sample_controls = $controls['sample_aliquot_controls']['tissue'];
		//Set $procure_reference_to_biopsy_report
		$procure_reference_to_biopsy_report = str_replace('x','', $new_line_data['guidé par le rapport de biopsie']);
		switch($procure_reference_to_biopsy_report) {
			case '1':
			case 'oui':
				$procure_reference_to_biopsy_report = 'y';
				break;
			case 'non':
				$procure_reference_to_biopsy_report = 'n';
				break;
			case '':
				break;
			default:
				$import_summary['Inventory - Tissue']['@@WARNING@@']["Wrong 'guidé par le rapport de biopsie' value format"][] = "See patient '$participant_identifier' value [$procure_reference_to_biopsy_report]. This value won't be migrated. [field 'guidé par le rapport de biopsie' - file '$file_name' :: $worksheet - line: $line_counter]";
				$procure_reference_to_biopsy_report = '';
		}		
		//Create sample
		$sample_data = array(
			'SampleMaster' => array(
				'collection_id' => $collection_id,
				'sample_control_id' => $tissue_sample_controls['sample_control_id'],
				'initial_specimen_sample_type' => 'tissue',
				'notes' => str_replace(array('x','Aucune'),array('',''),$new_line_data['particularité tissus macroscopie'])),
			'SpecimenDetail' => array(
				'reception_datetime' => null,
				'reception_datetime_accuracy' => null),
			'SampleDetail' => array(
				'procure_tissue_identification' => $participant_identifier.' V01 PST1',
				'procure_prostatectomy_resection_time' => getTime($new_line_data, 'hre de résection laparoscopie', 'Inventory - Tissue', $file_name, $line_counter),
				'procure_report_number' => $patho_nbr,
				'prostate_fixation_time' => getTime($new_line_data, 'hre de fixation prostate', 'Inventory - Tissue', $file_name, $line_counter),
				'procure_lymph_nodes_fixation_time' => getTime($new_line_data, 'hre de fixation ganglions', 'Inventory - Tissue', $file_name, $line_counter),
				'procure_chuq_collected_prostate_slice_weight_gr' => getDecimal($new_line_data, 'poids de la tranche prélevé (gramme)', 'Pathology Report', "$file_name ($worksheet)", $line_counter),
				'procure_reference_to_biopsy_report' => $procure_reference_to_biopsy_report));
		$sample_master_id = createSample($sample_data, $tissue_sample_controls['detail_tablename']);
		
		$block_created = false;
		
		//*** FROZEN TISSUE BLOCKS **
		//Create block based on tissue size excel file
		
		//DateTime
		$storage_date = $prostatectomy_data['TreatmentMaster']['start_date'];
		if($storage_date && $new_line_data['Tissus congelé overnight'] == '1') {
			$date = new DateTime($storage_date);
			$date->add(new DateInterval('P1D'));
			$storage_date = $date->format('Y-m-d');
		}
		$storage_date_accuracy = $prostatectomy_data['TreatmentMaster']['start_date_accuracy'];
		$storage_time = getTime($new_line_data, 'hre de congélation tissus', 'Inventory - Tissue', $file_name, $line_counter);
		if($storage_time) {
			$storage_date .= ' '.$storage_time;
			if($storage_date_accuracy != 'c') die('ERR 8738728732');
		} else {
			$storage_date .= ' 00:00';
			$storage_date_accuracy = str_replace('c', 'h', $storage_date_accuracy);
		}
		//$duplicated_label_check = array();
		foreach($patient_frozen_block_data as $new_block) {
			//Note: All values of $new_block from file 'tissue size' already checked in previous function loadFrozenBlock()
			$block_created = true;
			$in_stock = 'yes - available';
			$aliquot_use = array();
			$notes = '';
			//Aliquot Internal Use Defintion: Check 'Date de coupe' comment
			switch($new_block['Date de coupe']) {
				case '':
					break;
				case 'envoi le 20 fév. 2012 au CUSM pour mapping et test extrac. ARN':
					$in_stock = 'yes - not available';
					$aliquot_use = array(
						'use_code' => 'Au CUSM pour Mapping + Extraction ARN', 
						'type' => 'on loan', 
						'use_details' => $new_block['Date de coupe'],
						'use_datetime' => '2012-02-20', 
						'use_datetime_accuracy' => 'h', 
						'used_by' => $new_block['Coupe réalisée par']);
					break;
				case 'retour des blocs congelé à la patho pour diagnostic':
					$in_stock = 'no';
					$aliquot_use = array(
						'use_code' => 'En Patho pour Diagnostic',
						'type' => 'on loan',
						'use_details' => $new_block['Date de coupe'],
						'use_datetime' => '',
						'use_datetime_accuracy' => '',
						'used_by' => $new_block['Coupe réalisée par']);
					break;
				case 'tissu redonné à la patho':
					$in_stock = 'no';
					$aliquot_use = array(
						'use_code' => 'Retour Patho',
						'type' => 'other',
						'use_details' => $new_block['Date de coupe'],
						'use_datetime' => '',
						'use_datetime_accuracy' => '',
						'used_by' => $new_block['Coupe réalisée par']);
					break;
				case 'un peu de calcifications':
					$notes = 'Un peu de calcifications';
					break;
				default:
					if(preg_match('/^2008\-10\-.+\/\/.+$/', $new_block['Date de coupe'])) {
						$use_datetime =array('date' => '2008-10-01 00:00', 'accuracy' =>'d');
					} else if('Hiver-Printemps 2007' == $new_block['Date de coupe']) {
						$use_datetime =array('date' => '2007-03-01 00:00', 'accuracy' =>'m');
					} else {
						$use_datetime = getDateAndAccuracy($new_block, 'Date de coupe', 'Inventory - Tissue', $psp_nbr_to_frozen_blocks_data['file_name'], $new_block['excel_line']);
						$use_datetime['accuracy'] = str_replace('c', 'h', $use_datetime['accuracy']);
					}
					if($use_datetime['date']) {
						$aliquot_use = array(
							'use_code' => 'Coupe',
							'type' => 'slide creation',
							'use_datetime' => $use_datetime['date'],
							'use_datetime_accuracy' => $use_datetime['accuracy'],
							'used_by' => $new_block['Coupe réalisée par']);
					} else {
						$import_summary['Inventory - Tissue']['@@ERROR@@']["Unable to extract 'Aliquot Use' information from 'Date de coupe'"][] = "Value '".$new_block['Date de coupe']."' is not supported and won't be migrated. See patient '$participant_identifier'. [file '".$psp_nbr_to_frozen_blocks_data['file_name']."', line '".$new_block['excel_line']."']";
					}
			}
			$use_counter = empty($aliquot_use)? ' 0' : '1';
			//time_spent_collection_to_freezing_end_mn
			$time_spent_collection_to_freezing_end_mn = null;
			if($storage_date &&  $collection_data['collection_datetime'] && ($collection_data['collection_datetime_accuracy'].$storage_date_accuracy) == 'cc') {				
				$col_date_ob = new DateTime($collection_data['collection_datetime']);
				$str_date_ob = new DateTime($storage_date);
				$interval = $col_date_ob->diff($str_date_ob);
				if(!$interval->invert) {
					$time_spent_collection_to_freezing_end_mn = $interval->d*24*60 + $interval->h*60 + $interval->i;
				}
			}
			//Storage data
			$storage_master_id = getStorageMasterId($participant_identifier, $new_block['boîte'], 'tissue', 'Inventory - Tissue', $psp_nbr_to_frozen_blocks_data['file_name'], '', $new_block['excel_line']);
			$storage_coordinates = getPosition($participant_identifier, $new_block['division'], $new_block['boîte'], 'tissue', 'Inventory - Tissue', $psp_nbr_to_frozen_blocks_data['file_name'], '', $new_block['excel_line']);
			if($in_stock == 'no' && $storage_master_id) {
				$import_summary['Inventory - Tissue']['@@WARNING@@']["Aliquot 'In Stock' value set to 'No'"][] = "Aliquot 'In Stock' value set to 'No' based on 'Date de coupe' value '".$new_block['Date de coupe']."' so storage information (".$new_block['boîte'].'/'.$new_block['division'].") won't be imported. See patient '$participant_identifier'. [file '".$psp_nbr_to_frozen_blocks_data['file_name']."', line '".$new_block['excel_line']."' &&  file '".$psp_nbr_to_frozen_blocks_data['file_name']."', line '".$new_block['excel_line']."']";
				$storage_master_id = null;
				$storage_coordinates = array('x'=>null, 'y'=>null);;
			}
			//Create aliquot	
			$aliquot_data = array(
				'AliquotMaster' => array(
					'collection_id' => $collection_id,
					'sample_master_id' => $sample_master_id,
					'aliquot_control_id' => $tissue_sample_controls['aliquots']['block']['aliquot_control_id'],
					'barcode' => "$participant_identifier V01 -".$new_block['label'],
					'in_stock' => $in_stock,
					'initial_volume' => null,
					'current_volume' => null,
					'use_counter' => $use_counter,
					'storage_datetime' => $storage_date,
					'storage_datetime_accuracy' => $storage_date_accuracy,
					'storage_master_id' => $storage_master_id,
					'storage_coord_x' => $storage_coordinates['x'],
					'storage_coord_y' => $storage_coordinates['y'],
					'notes' => $notes),
				'AliquotDetail' => array(
					'block_type' => 'frozen',
					'procure_freezing_type' => $new_block['i=iso  O=OCT'],
					'procure_origin_of_slice' => $new_block['quadrants'],
					'procure_dimensions' => $new_block['blocs (cm2)'],
					'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn));
			$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
			customInsert($aliquot_data['AliquotDetail'], $tissue_sample_controls['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
			//Aliquot Internal Use Record
			if(!empty($aliquot_use)) {
				$aliquot_use['aliquot_master_id'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
				customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
			}
		}
		
		//*** PARAFFIN TISSUE BLOCKS **
		//Create block based on patho block excel file
				
		//$duplicated_label_check = array();
		foreach($patient_paraffin_block_data as $new_blocks_set) {
			$patho_nbr_from_paraffin_block = $new_blocks_set['# patho'];
			if(empty($patho_nbr_from_paraffin_block)) {
				$import_summary['Inventory - Tissue']['@@ERROR@@']['No Patho Number for paraffin block'][] = "The pathology number is not defined into the paraffin block file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. No block will be created. See patient '$participant_identifier'. ['".$psp_nbr_to_paraffin_blocks_data['file_name']."', line '".$new_blocks_set['excel_line']."']";
			} else {
				if(empty($patho_nbr)) {
					$patho_nbr = $patho_nbr_from_paraffin_block;
					$import_summary['Inventory - Tissue']['@@MESSAGE@@']['Used Patho Number of paraffin block'][] = "The pathology number ($patho_nbr_from_paraffin_block) is just set into the paraffin block file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. Will use this one for both sample and pathology report data. See patient '$participant_identifier'. ['".$psp_nbr_to_paraffin_blocks_data['file_name']."', line '".$new_blocks_set['excel_line']."']";	
					$query = "UPDATE ".$tissue_sample_controls['detail_tablename']." SET procure_report_number = '".str_replace("'", "''", $patho_nbr)."' WHERE sample_master_id = $sample_master_id;";
					customQuery($query, __FILE__, __LINE__);
				} else if($patho_nbr != $patho_nbr_from_paraffin_block){
					$import_summary['Inventory - Tissue']['@@ERROR@@']['Patho Numbers conflict'][] = "The pathology number ($patho_nbr) previously defined into patient excel file does not match the number ($patho_nbr_from_paraffin_block) defined into the paraffin block file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. Please confrim. See patient '$participant_identifier'. ['".$psp_nbr_to_paraffin_blocks_data['file_name']."', line '".$new_blocks_set['excel_line']."']";
				}
				foreach(array('bloc tumoral 1', 'bloc tumoral 2', 'bloc normal 1', 'bloc normal 2') as $block_key) {
					if($new_blocks_set[$block_key]) {
						$block_created = true;
						//Create aliquot
						$aliquot_data = array(
							'AliquotMaster' => array(
								'collection_id' => $collection_id,
								'sample_master_id' => $sample_master_id,
								'aliquot_control_id' => $tissue_sample_controls['aliquots']['block']['aliquot_control_id'],
								'barcode' => "$patho_nbr_from_paraffin_block-".$new_blocks_set[$block_key],
								'in_stock' => 'yes - available'),
							'AliquotDetail' => array(
								'block_type' => 'paraffin',
								'procure_classification' => preg_match('/^bloc normal/', $block_key)? 'NC' : 'C'));
						$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
						customInsert($aliquot_data['AliquotDetail'], $tissue_sample_controls['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
					}
				}
			}
		}
		
		//*** BLOCK CREATION CHECK **
		
		if(!$block_created) {
			$import_summary['Inventory - Tissue']['@@WARNING@@']["No Block defined for a patient tissue collection"][] = "See patient '$participant_identifier'. A tissue sample has been created but no block is defined into file '".$psp_nbr_to_frozen_blocks_data['file_name']."' or file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. No aliquot will be created.";
		}
	} else {
		if(!empty($patient_frozen_block_data)) {
			$import_summary['Inventory - Tissue']['@@ERROR@@']["No collection created but tissue blocks defined in tissue size file"][] = "See patient '$participant_identifier'. No tissue collection has been created but blocks are defined into tissue size file. No aliquot,sample and collection will be created. [file '".$psp_nbr_to_frozen_blocks_data['file_name']."']";
		}
		if(!empty($patient_paraffin_block_data)) {
			$import_summary['Inventory - Tissue']['@@ERROR@@']["No collection created but tissue blocks defined in path block file"][] = "See patient '$participant_identifier'. No tissue collection has been created but blocks are defined into patho block file. No aliquot,sample and collection will be created. [file '".$psp_nbr_to_paraffin_blocks_data['file_name']."']";
		}
	}
}

function loadRNA(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	$storage_control = $controls['storage_controls'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadConsentAndQuestionnaireData
	$headers = array();
	for($id=1;$id<10;$id++) {
//TODO
if(!in_array($id, array(1))) continue;
		$worksheet = "V0".$id;
		$paxgene_blood_tubes = array();	
		$query = "SELECT par.participant_identifier, am.collection_id, am.sample_master_id, am.barcode, am.id AS aliquot_master_id, am.storage_master_id, stm.selection_label
			FROM participants par
			INNER JOIN collections col ON col.participant_id = par.id
			INNER JOIN aliquot_masters am ON am.collection_id = col.id
			LEFT JOIN storage_masters stm ON stm.id = am.storage_master_id
			WHERE am.deleted <> 1 AND am.barcode LIKE '%-RNB%' AND col.procure_visit = '$worksheet' AND am.aliquot_control_id = ".$sample_aliquot_controls['blood']['aliquots']['tube']['aliquot_control_id'].";";
		$results = customQuery($query, __FILE__, __LINE__);
		while($row = $results->fetch_assoc()){
			$participant_identifier = $row['participant_identifier'];
			if(array_key_exists($participant_identifier, $paxgene_blood_tubes)) $import_summary['Inventory - RNA']['@@WARNING@@']["More than one paxgene tube exist"][] = "Only one will be used for RNA extraction. See patient '$participant_identifier'.";
			$paxgene_blood_tubes[$participant_identifier] = $row;
		}
		$procure_chuq_extraction_number = '';
		$aliquot_master_ids_to_remove = array('-1');
		foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
			//$line_counter++;
			if($line_counter == 2) {
				$headers = $new_line;
			} else if($line_counter > 3){
				$new_line_data = formatNewLineData($headers, $new_line);
				$participant_identifier = $new_line_data['# échantillon'];
				if(strlen($participant_identifier)) {
					if(preg_match('/^PS[0-9]P/', $participant_identifier)) {
						if(array_key_exists($participant_identifier, $paxgene_blood_tubes)) {
							//Parse excel data
							if(strlen($new_line_data['# extraction'])) $procure_chuq_extraction_number = $new_line_data['# extraction'];
							$extraction_date = getDateAndAccuracy($new_line_data, "Date             d'extraction", 'Inventory - RNA', $file_name, $line_counter);
							$extraction_date['accuracy'] = str_replace('c','h',$extraction_date['accuracy']);
							$notes = $new_line_data["Note d'incident         durant extration"];
							$procure_chuq_dnase_duration_mn = '';
							if($new_line_data["Délai DNAse"]) {
								if(preg_match('/^([0-9]+)\ min\.\ DNAse$/', $new_line_data["Délai DNAse"], $matches)) {
									$procure_chuq_dnase_duration_mn = $matches[1];
								} else {
									$import_summary['Inventory - RNA']['@@WARNING@@']["Wrong 'Délai DNAse' format"][] = "See value '".$new_line_data["Délai DNAse"]."' for patient '$participant_identifier'. No value imported. [file '$file_name' :: $worksheet - line: $line_counter]";
								}
							}
							$procure_chuq_extraction_method = '';
							if($new_line_data['extract. Manuelle'] == 1 && $new_line_data['Qiacube kit miRNA'] == 1) {
								$import_summary['Inventory - RNA']['@@WARNING@@']["Extraction method conflict"][] = "Extraction method defined both as manual and kit. No method will be set. See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
							} else if($new_line_data['extract. Manuelle'] == 1) {
								$procure_chuq_extraction_method = 'manual extraction';
							} else if($new_line_data['Qiacube kit miRNA'] == 1) {
								$procure_chuq_extraction_method = 'qiacube kit miRNA';
							}
							$created_by = '';
							switch($new_line_data['extrait par CHUQ']) {
								case 'CM':
								case 'MO':
								case 'VB':
								case  '':
									$created_by = $new_line_data['extrait par CHUQ'];
									break;
								case 'MO-CM':
								case 'CM (BC)':
								case 'CM (BC)':
								case 'VB et CM':
								case 'VB/CM':
									$created_by = 'CM';
									$import_summary['Inventory - RNA']['@@WARNING@@']["Changed lab staff who extracted RNA to 'CM'"][] = "Value '".$new_line_data['extrait par CHUQ']."' changed to 'CM'. See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
									break;
								default:
									$import_summary['Inventory - RNA']['@@ERROR@@']["Unknown lab staff who extracted RNA"][] = "Lab staff '".$new_line_data['extrait par CHUQ']."' is not supported. Value won't be migrated. See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
							}
							//Create RNA Sample
							$sample_data = array(
								'SampleMaster' => array(
									'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
									'sample_control_id' => $sample_aliquot_controls['rna']['sample_control_id'],
									'initial_specimen_sample_type' => 'blood',
									'initial_specimen_sample_id' => $paxgene_blood_tubes[$participant_identifier]['sample_master_id'],
									'parent_sample_type' => 'blood',
									'parent_id' => $paxgene_blood_tubes[$participant_identifier]['sample_master_id'],
									'notes' => $notes),
								'DerivativeDetail' => array(
									'creation_datetime' => $extraction_date['date'],
									'creation_datetime_accuracy' => $extraction_date['accuracy'],
									'creation_by' =>$created_by),
								'SampleDetail' => array(
									'procure_chuq_extraction_number' => $procure_chuq_extraction_number,
									'procure_chuq_dnase_duration_mn' => $procure_chuq_dnase_duration_mn,
									'procure_chuq_extraction_method' => $procure_chuq_extraction_method));
							$derivative_sample_master_id = createSample($sample_data, $sample_aliquot_controls['rna']['detail_tablename']);
							//Create aliquot to sample link		
							$source_aliquot_barcode = $paxgene_blood_tubes[$participant_identifier]['barcode'];
							$source_aliquot_master_id = $paxgene_blood_tubes[$participant_identifier]['aliquot_master_id'];
							customInsert(array('sample_master_id' => $derivative_sample_master_id, 'aliquot_master_id' => $source_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
							//Update paxgen tube storage data
							$aliquot_master_ids_to_remove[] = $source_aliquot_master_id;
							if($paxgene_blood_tubes[$participant_identifier]['storage_master_id']) {
								$import_summary['Inventory - RNA']['@@WARNING@@']["Removed Paxgene Tube from Storage"][] = "Paxgen tube '$source_aliquot_barcode' was defined as used for RNA extraction. Migration process removed storage information (Tube was defined as stored into ".$paxgene_blood_tubes[$participant_identifier]['selection_label']."). See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
							}
							//Create aliquots
							$aliquot_master_ids = array();
							//... RNA1
							$initial_volume = getDecimal($new_line_data, 'RNA-1 volume (ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
							$concentration_bioanalyzer = getDecimal($new_line_data, 'Concentration (ng/ul) par Bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
							$concentration_unit_bioanalyzer = strlen($concentration_bioanalyzer)? 'ng/ul' : '';
							$procure_total_quantity_ug = (strlen($initial_volume) && strlen($concentration_bioanalyzer))? ($initial_volume*$concentration_bioanalyzer/1000): '';
							$concentration_nanodrop = getDecimal($new_line_data, 'Nanodrop (ng/ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
							$concentration_unit_nanodrop = strlen($concentration_nanodrop)? 'ng/ul' : '';
							$procure_total_quantity_ug_nanodrop = (strlen($initial_volume) && strlen($concentration_nanodrop))? ($initial_volume*$concentration_nanodrop/1000): '';
							if(strlen($new_line_data['bte rangement RNA-1']) || $initial_volume) {
								$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement RNA-1'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$storage_coordinates = getPosition($participant_identifier, $new_line_data['Position RNA-1 dans boîte de rangement'], $new_line_data['bte rangement RNA-1'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$aliquot_data = array(
									'AliquotMaster' => array(
										'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
										'sample_master_id' => $derivative_sample_master_id,
										'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
										'barcode' => "$participant_identifier $worksheet -RNA1",
										'in_stock' => 'yes - available',
										'initial_volume' => $initial_volume,
										'current_volume' => $initial_volume,
//TODO: Check use counter and volume updated after migration and newVersionSetup() execution											
										'use_counter' => '0',
										'storage_datetime' => $extraction_date['date'],
										'storage_datetime_accuracy' => $extraction_date['accuracy'],
										'storage_master_id' => $storage_master_id,
										'storage_coord_x' => $storage_coordinates['x'],
										'storage_coord_y' => $storage_coordinates['y']),
									'AliquotDetail' => array(
										'concentration' => $concentration_bioanalyzer,
										'concentration_unit' => $concentration_unit_bioanalyzer,
										'procure_total_quantity_ug' => $procure_total_quantity_ug,
										'procure_concentration_nanodrop' => $concentration_nanodrop,
										'procure_concentration_unit_nanodrop' => $concentration_unit_nanodrop,
										'procure_total_quantity_ug_nanodrop' => $procure_total_quantity_ug_nanodrop
									));
								$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
								customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
								$aliquot_master_ids['RNA-1'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							}
							//Mir
							if($new_line_data['MiR'] == '1' || strlen($new_line_data['Boîte de rangement Mir'])) {
								$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['Boîte de rangement Mir'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$storage_coordinates = getPosition($participant_identifier, $new_line_data['Position Mir dans boîte de rangement'], $new_line_data['Boîte de rangement Mir'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$aliquot_data = array(
									'AliquotMaster' => array(
										'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
										'sample_master_id' => $derivative_sample_master_id,
										'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
//TODO: Confirm label										
										'barcode' => "$participant_identifier $worksheet -miRNA",
										'in_stock' => 'yes - available',
										'initial_volume' => null,
										'current_volume' => null,
										'use_counter' => '0',
										'storage_datetime' => $extraction_date['date'],
										'storage_datetime_accuracy' => $extraction_date['accuracy'],
										'storage_master_id' => $storage_master_id,
										'storage_coord_x' => $storage_coordinates['x'],
										'storage_coord_y' => $storage_coordinates['y']),
									'AliquotDetail' => array(
										'procure_chuq_micro_rna' => '1'));
								$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
								customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
								$aliquot_master_ids['RNA-micro'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							}
							for($id=2;$id<4;$id++) {
								$initial_volume = getDecimal($new_line_data, 'RNA-'.$id.' volume (ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($initial_volume) {
									$aliquot_data = array(
										'AliquotMaster' => array(
											'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
											'sample_master_id' => $derivative_sample_master_id,
											'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
											'barcode' => "$participant_identifier $worksheet -RNA".$id,
											'in_stock' => 'no',
											'initial_volume' => $initial_volume,
											'current_volume' => $initial_volume,
											'use_counter' => '0'),
										'AliquotDetail' => array());
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									$aliquot_master_ids['RNA-'.$id] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
								}
							}
							if(empty($aliquot_master_ids)) {
								$import_summary['Inventory - RNA']['@@WARNING@@']["No tube of RNA defined"][] = "RNA sample has been created but no tube volume is set. No aliquot has been created .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
							}
							//Bioanalyzer
							$qc_code_counter = 0;
							if($new_line_data['Analysé par bioanalyser'] || strlen($new_line_data["Date d'analyse"])) {
								$scores = array();
								$score = getDecimal($new_line_data, 'Valeur RIN', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['RIN'] = $score;
								$score = getDecimal($new_line_data, 'Ratio 28S/18S Bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['28/18'] = $score;
								if(empty($scores)) {
									$import_summary['Inventory - RNA']['@@WARNING@@']["Bioanalyzer test with no scrore"][] = "Please confirm .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									$scores[''] = '';
								}
								$qc_date = getDateAndAccuracy($new_line_data, "Date d'analyse", 'Inventory - RNA', $file_name, $line_counter);
								$qc_date['accuracy'] = str_replace('c','h',$qc_date['accuracy']);
								$tested_aliquot_master_id = null;
								if($new_line_data['Aliquot utilisé pour bioanalyser']) {
									if(array_key_exists($new_line_data['Aliquot utilisé pour bioanalyser'], $aliquot_master_ids)) {
										$tested_aliquot_master_id = $aliquot_master_ids[$new_line_data['Aliquot utilisé pour bioanalyser']];
									} else {
										$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer: Unable to define tested aliquot"][] = "The system is unable to link bioanalyzer test to the specific aliquot defined as  '".$new_line_data['Aliquot utilisé pour bioanalyser']."'. This one has not been created into the system. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									}
								}
								$new_line_data['Volume pris pour analyse  bioanalyser'] = str_replace(' ul', '', $new_line_data['Volume pris pour analyse  bioanalyser']);
								$used_volume = getDecimal($new_line_data, 'Volume pris pour analyse  bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if(is_null($tested_aliquot_master_id) && strlen($used_volume)) {
									$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer: Used volume but no tested aliquot"][] = "A 'Volume pris pour analyse  bioanalyser' is defined but no tested aliquot is defined. No volume will be migrated. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									$used_volume = '';
								}
								foreach($scores as $unit => $score) {
									$qc_code_counter++;
									$qc_data = array(
										'qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter,
										'sample_master_id' => $derivative_sample_master_id,
										'aliquot_master_id' => $tested_aliquot_master_id,
										'used_volume' => $used_volume,
										'type' => 'bioanalyzer',
										'procure_analysis_by' => $new_line_data["Centre d'analyse"],
										'date' => $qc_date['date'],
										'date_accuracy' => $qc_date['accuracy'],
										'score' => $score,
										'unit' => $unit,
										'procure_chuq_visual_quality' => $new_line_data["Qualité visuelle Bioanalyser"],
										'notes' => strlen($new_line_data['Chip comment'])? 'Chip note: '.$new_line_data['Chip comment'] : '');
									customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
									$used_volume = ''; //In case there are 2 scores no used wolume will be defined for the second one
								}
							} else if(strlen($new_line_data['Valeur RIN'].$new_line_data['Ratio 28S/18S Bioanalyser'])) {
								$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer was defined as not executed but results exist"][] = "No bioanalyzer test will be migrated. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
							}
							//Nanodrop
							if(strlen($new_line_data["Nanodrop date analyse"])) {
								$scores = array();
								$score = getDecimal($new_line_data, 'Nanodrop A260', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['260'] = $score;
								$score = getDecimal($new_line_data, 'Nanodrop A280', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['280'] = $score;
								$score = getDecimal($new_line_data, 'Nanodrop 260/280', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['260/280'] = $score;
								$score = getDecimal($new_line_data, 'Nanodrop 260/230', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['260/230'] = $score;
								if(empty($scores)) {
									$import_summary['Inventory - RNA']['@@WARNING@@']["Nanodrop test with no scrore"][] = "Please confirm .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									$scores[''] = '';
								}
								$qc_date = getDateAndAccuracy($new_line_data, "Nanodrop date analyse", 'Inventory - RNA', $file_name, $line_counter);
								$qc_date['accuracy'] = str_replace('c','h',$qc_date['accuracy']);
								//Note: Volume pris pour analyse nanodrop: Not imported because no linked aliquot
								foreach($scores as $unit => $score) {
									$qc_code_counter++;
									$qc_data = array(
										'qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter,
										'sample_master_id' => $derivative_sample_master_id,
										'type' => 'nanodrop',
										'procure_analysis_by' => $new_line_data["Nanodrop centre analyse"],
										'date' => $qc_date['date'],
										'date_accuracy' => $qc_date['accuracy'],
										'score' => $score,
										'unit' => $unit);
									customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
								}
							} else if(strlen($new_line_data['Nanodrop A260'].$new_line_data['Nanodrop A280'].$new_line_data['Nanodrop 260/280'].$new_line_data['Nanodrop 260/230'])) {
								$import_summary['Inventory - RNA']['@@ERROR@@']["Nanodrop test was defined as not executed but results exist"][] = "No test will be migrated. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
							}							
							unset($paxgene_blood_tubes[$participant_identifier]);
						} else {
							$import_summary['Inventory - RNA']['@@ERROR@@']["No paxgene tube"][] = "RNA has been defined for patient $participant_identifier but no paxgene tube was previously created into the system. No RNA will be created. [file '$file_name' :: $worksheet - line: $line_counter";
						}
					}
				}
			}
		}
		//Update paxgen tube storage data
		$query = "UPDATE aliquot_masters SET in_stock = 'no', storage_master_id = null, storage_coord_x = null, storage_coord_y = null WHERE id IN ('".implode("','", $aliquot_master_ids_to_remove)."');";
		customQuery($query, __FILE__, __LINE__);
	}
}







?>