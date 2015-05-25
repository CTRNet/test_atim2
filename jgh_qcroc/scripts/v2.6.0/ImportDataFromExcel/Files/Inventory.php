<?php

function loadTissue(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	
//TODO
$limit_data = false;
$limit_pattern = '/^[0-9]+\-[0-9]+\-0((0[1-9])|(1[0-5]))/';
$limit_pattern = '/^[0-9]+\-[0-9]+\-00[1-1]/';
	
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	// *1* Create Collection **
	
	$tissue_collection_and_sample_ids = array();
	
	$worksheet = 'Collection';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$tissue_collection_label = $new_line_data['Collection'];
if($limit_data && !preg_match($limit_pattern, $tissue_collection_label)) continue;	
			if(preg_match('/^([0-9]+)\-([0-9]+)-([0-9]+)$/', $tissue_collection_label, $matches)) {
				$collection_id = getCollectionId($matches[1], $matches[3], 'T', $matches[2], $new_line_data['Date'], '', $new_line_data['Hospital site'], $new_line_data['Note'], $summary_title, $file_name, $worksheet, $line_counter);
				$tissue_collection_and_sample_ids[$tissue_collection_label] = array('collection_id' => $collection_id, 'sample_master_id' => null, 'created_aliquots' => false);
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Collection Value Format Not Supported'][] = "See value [$tissue_collection_label]! The collection won't be created! [file '$file_name' ($worksheet) - line: $line_counter]";
			}
		}
	}
	
	// *2* Create Tissue **
	
	$worksheet = 'Sample';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$tissue_collection_label = $new_line_data['Collection'];
if($limit_data && !preg_match($limit_pattern, $tissue_collection_label)) continue;	
			if(strlen($tissue_collection_label)) {
				if(array_key_exists($tissue_collection_label, $tissue_collection_and_sample_ids)) {
					$qcroc_collection_method = strtolower($new_line_data['Collection Method']);
					if($qcroc_collection_method != 'no biopsy') {
						if(is_null($tissue_collection_and_sample_ids[$tissue_collection_label]['sample_master_id'])) {
							$collection_id = $tissue_collection_and_sample_ids[$tissue_collection_label]['collection_id'];
							//Create the sample tissue								
							if(!in_array($qcroc_collection_method, array('', 'biopsy', 'hepatectomy'))) {
								$import_summary[$summary_title]['@@WARNING@@']['Tissue Collection method unknown'][] = "See value [$qcroc_collection_method]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
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
								$import_summary[$summary_title]['@@WARNING@@']['Tissue Histology unknown'][] = "See value [$qcroc_histology]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
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
							$tissue_collection_and_sample_ids[$tissue_collection_label]['sample_master_id'] = createSample($sample_data, $controls['sample_aliquot_controls']['tissue']['detail_tablename']);
						} else {
							//Tissue Sample defined twice: Error
							die('ERR 336376376363 '.$tissue_collection_label);
						}
					} else {
						$import_summary[$summary_title]['@@WARNING@@']['No Biopsy'][] = "A note defines that 'No biopsy' has been done for collection [$tissue_collection_label]. The Tissue won't be created. Please confirm and delete collection after migration (if required)! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Collection Of A Tissue Sample Was Not Defined Into Collection Worksheet'][] = "The collection [$tissue_collection_label] of a tissue was not defined into the Collection worksheet! No tissue will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	foreach ($tissue_collection_and_sample_ids as $tissue_collection_label => $ids) {
		if(!$ids['sample_master_id']) {
			$import_summary[$summary_title]['@@WARNING@@']['No Tissue Sample Defined For A Collection'][] = "No tissue has been created for collection [$tissue_collection_label] previously created base on Collection Worksheet! Please confirm and delete collection after migration (if required)! [file '$file_name' ($worksheet) - line: $line_counter]";
		}		
	}
			
	// *3* Create Tissue Tube **
	
	$tissue_collections_ids = array();
	
	$worksheet = 'Tube';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$sample_tube_id = $new_line_data['Sample Tube Id'];
if($limit_data && !preg_match($limit_pattern, $sample_tube_id)) continue;	
			if(strlen($sample_tube_id)) {
				if(preg_match('/^([0-9]+)\-([0-9]+)\-([0-9]+)\-([0-9]+)$/', $sample_tube_id, $matches)) {
					$tissue_collection_label = $matches[1].'-'.$matches[2].'-'.$matches[3];
					if(!array_key_exists($tissue_collection_label, $tissue_collection_and_sample_ids)) {
						$import_summary[$summary_title]['@@ERROR@@']['Collection Of A Tissue Tube Was Not Defined Into Collection Worksheet'][] = "The collection [$tissue_collection_label] of the tissue tube [$sample_tube_id] was not defined into the Collection worksheet! No tissue tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					} else if(!$tissue_collection_and_sample_ids[$tissue_collection_label]['sample_master_id']) {
						$import_summary[$summary_title]['@@ERROR@@']['No Tissue Sample Created Bur Tissue Tube Defined'][] = "No tissue sample has been created for tissue tube [$sample_tube_id]! Please verify that the sample has been correctly defined in sample worksheets! [file '$file_name' ($worksheet) - line: $line_counter]";
					} else {
						$collection_id = $tissue_collection_and_sample_ids[$tissue_collection_label]['collection_id'];
						$sample_master_id = $tissue_collection_and_sample_ids[$tissue_collection_label]['sample_master_id'];
						if(!array_key_exists($sample_tube_id, $tissue_collections_ids)) {
							//1.a-qcroc_tissue_biopsy_big_than_1cm
							$qcroc_tissue_biopsy_big_than_1cm = '';
							switch(strtolower($new_line_data['Biopsy >1 cm'])) {
								case 'yes':
									$qcroc_tissue_biopsy_big_than_1cm = 'y';
									break;
								case 'no':
									$qcroc_tissue_biopsy_big_than_1cm = 'n';
									break;
								case '';
									break;
								default:
									$import_summary[$summary_title]['@@WARNING@@']['Biopsy >1 cm unknown'][] = "See value [".$new_line_data['Biopsy >1 cm']."]. Value won't be migrated! [file '$file_name' (".$worksheet.") - line: ".$line_counter."]";
							}
							//1.b-qcroc_tissue_biopsy_fragments
							$qcroc_tissue_biopsy_fragments = '';
							if(preg_match('/^[0-9]+$/', $new_line_data['Fragments'])) {
								$qcroc_tissue_biopsy_fragments = $new_line_data['Fragments'];
							} else if(strlen($new_line_data['Fragments'])) {
								$import_summary[$summary_title]['@@WARNING@@']['Fragments format error'][] = "See value [".$new_line_data['Fragments']."]. Value won't be migrated! [file '$file_name' (".$worksheet.") - line: ".$line_counter."]";
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
//									'qcroc_tissue_biopsy_carrot_size_cm' => $qcroc_tissue_biopsy_carrot_size_cm,
									'qcroc_collected_processed_according_sop' => $qcroc_collected_processed_according_sop));
							$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
							customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
							$tissue_collections_ids[$sample_tube_id] = array(
								'collection_id' => $collection_id,
								'sample_master_id' => $sample_master_id,
								'tube_aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id'],
								'bloc_aliquot_master_ids' => array(),
								'slide_aliquot_master_ids' => array(),
								'left_over_bloc_aliquot_master_ids' => array());
							$tissue_collection_and_sample_ids[$tissue_collection_label]['created_aliquots'] = true;
						} else {
							$import_summary[$summary_title]['@@ERROR@@']['Tissue tube defined twice'][] = "Tissue tube label [$sample_tube_id] is defined twice! Only one will be created! Please verify and correct data if required! [file '$file_name' ($worksheet) - line: $line_counter]";	
						}						
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Sample Tube Id Format Not Supported'][] = "See value [$sample_tube_id]! No tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	foreach($tissue_collection_and_sample_ids as $tissue_collection_label => $tmp) {
		if(!$tmp['created_aliquots']) {
			$import_summary[$summary_title]['@@WARNING@@']['No Tissue Tube Defined'][] = "No tissue was defined for created collection [$tissue_collection_label]! Please confirm and delete collection and sample after migration (if required)! [file '$file_name' ($worksheet)]";
		}
	}
	unset($tissue_collection_and_sample_ids);	
	
	$worksheet = 'Tube Event';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$sample_tube_id = $new_line_data['Sample Tube Id'];
if($limit_data && !preg_match($limit_pattern, $sample_tube_id)) continue;	
			if(strlen($new_line_data['Shipping conditions correct?'].$new_line_data['Detail'].$new_line_data['Date'])) {
				if(array_key_exists($sample_tube_id, $tissue_collections_ids) && $tissue_collections_ids[$sample_tube_id]['tube_aliquot_master_id']) {
					switch($new_line_data['Event Type']) {
						case 'Shipped to Central Biobank';
						case 'Reception at Central Biobank';
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
							$event_date = getDateAndAccuracy($new_line_data, 'Date', $summary_title, $file_name, $worksheet, $line_counter);
							$event_date['accuracy'] = str_replace('c', 'h', $event_date['accuracy']);
							$aliquot_use = array(
								'aliquot_master_id' => $tissue_collections_ids[$sample_tube_id]['tube_aliquot_master_id'],
								'type' => ($new_line_data['Event Type'] == 'Shipped to Central Biobank')? 'shipped to LDI' : 'reception at LDI',
								'qcroc_compliant_processing' => $qcroc_compliant_processing,
								'use_details' => $new_line_data['Detail'],
								'use_datetime' => $event_date['date'],
								'use_datetime_accuracy' => $event_date['accuracy']
							);
							customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
							break;
						case '':
							break;
						default:
							die('ERR23328272387 '.$new_line_data['Event Type']);
					}
				}
			}
		}
	}

	// *4* Create Block **
	
	$tube_aliquot_master_ids_to_udpate_status = array();
	
	$worksheet = 'Block';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$sample_block_id = $new_line_data['Block Id'];
if($limit_data && !preg_match($limit_pattern, $sample_block_id)) continue;
			if(strlen($sample_block_id)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)([A-Za-z]+)$/', $sample_block_id, $matches)) {
					$sample_tube_id = $matches[1];
					if(!array_key_exists($sample_tube_id, $tissue_collections_ids)) {
						$import_summary[$summary_title]['@@ERROR@@']['Tissue Tube Not Found'][] = "The Sample Tube ID [$sample_tube_id] used for block [$sample_block_id] was not defined into the Sample worksheet ! No tissue block will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					} else if(array_key_exists($sample_block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						$import_summary[$summary_title]['@@ERROR@@']['Tissue Block Defined twice'][] = "The block [$sample_block_id] was defined twice! No second tissue block will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					} else {
						$collection_id = $tissue_collections_ids[$sample_tube_id]['collection_id'];
						$sample_master_id = $tissue_collections_ids[$sample_tube_id]['sample_master_id'];
						//a-qcroc_storage_method & croc_storage_solution
						$qcroc_acceptance_status = strtolower($new_line_data['Acceptance Status']);
						if(!in_array($qcroc_acceptance_status, array('', 'block rejected','whole block accepted','partial block accepted'))) {
							$qcroc_acceptance_status = '';
							$import_summary[$summary_title]['@@WARNING@@']['Acceptance Status unknown'][] = "See value [".$new_line_data['Acceptance Status']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						//b-qcroc_acceptance_reason
						$qcroc_acceptance_reason = $new_line_data['Reasons'];
						//c-block_type
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
								'notes'=> $new_line_data['Notes']),
							'AliquotDetail' => array(
								'qcroc_acceptance_status' => $qcroc_acceptance_status,
								'qcroc_acceptance_reason' => $qcroc_acceptance_reason,
								'block_type' => $block_type));
						$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
						customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
						$tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id] = array('id' => $aliquot_data['AliquotDetail']['aliquot_master_id'], 'slide_counter' => 0);
						//Create realiquoting relation
						$tube_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['tube_aliquot_master_id'];
						$realiquoting_datetime = getDateAndAccuracy($new_line_data, 'Date (Realiquoting)', $summary_title, $file_name, $worksheet, $line_counter);
						$realiquoting_datetime['accuracy'] = str_replace('c', 'h', $realiquoting_datetime['accuracy']);
						$realiquoting_data = array(
							'parent_aliquot_master_id' => $tube_aliquot_master_id,	
							'child_aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id'],	
							'realiquoting_datetime' => $realiquoting_datetime['date'],	
							'realiquoting_datetime_accuracy' => $realiquoting_datetime['accuracy']);
						customInsert($realiquoting_data, 'realiquotings', __FILE__, __LINE__, false);	
						$tube_aliquot_master_ids_to_udpate_status[] = $tube_aliquot_master_id;
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong Block Id Format'][] = "Unable to extract Sample Tube ID from block ID [$sample_block_id] based on block ID format! No block will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	if($tube_aliquot_master_ids_to_udpate_status) {
		$import_summary[$summary_title]['@@MESSAGE@@']["In Stock Status of tubes used to create block set to 'no'"][] = "Please confirm";	
		$query = "UPDATE aliquot_masters SET in_stock = 'no' WHERE id IN (".implode(',',$tube_aliquot_master_ids_to_udpate_status).");";
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
if($limit_data && !preg_match($limit_pattern, $sample_slide_id)) continue;
			if(strlen($sample_slide_id)) {
				if(preg_match('/^(([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+)\-(.+)$/', $sample_slide_id, $matches)) {
					$sample_tube_id = $matches[2];
					$sample_block_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_collections_ids) && array_key_exists($sample_block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						if(!array_key_exists($sample_slide_id, $tissue_collections_ids[$sample_tube_id]['slide_aliquot_master_ids'])) {
							$collection_id = $tissue_collections_ids[$sample_tube_id]['collection_id'];
							$sample_master_id = $tissue_collections_ids[$sample_tube_id]['sample_master_id'];
							$tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id]['slide_counter'] += 1;
							$slide_counter = $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id]['slide_counter'];
							$aliquot_data = array(
								'AliquotMaster' => array(
									'collection_id' => $collection_id,
									'sample_master_id' => $sample_master_id,
									'aliquot_control_id' => $controls['sample_aliquot_controls']['tissue']['aliquots']['slide']['aliquot_control_id'],
									'barcode' => getNextTmpBarcode(),
//TODO a confirmer avec Vincent - On utilise pas le 'Slide id' du fichier excel pour le aliquot label								
									'aliquot_label' => $sample_block_id.'-'.$slide_counter,
									'in_stock' => 'yes - available',
									'use_counter' => '0',
									'notes'=> $new_line_data['Comment on slide']),
								'AliquotDetail' => array(
									'qcroc_level' => $new_line_data['level']));
							$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
							customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['tissue']['aliquots']['slide']['detail_tablename'], __FILE__, __LINE__, true);
							$tissue_collections_ids[$sample_tube_id]['slide_aliquot_master_ids'][$sample_slide_id] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							//Create realiquoting relation
							$block_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$sample_block_id]['id'];
							$realiquoting_data = array(
								'parent_aliquot_master_id' => $block_aliquot_master_id,
								'child_aliquot_master_id' => $aliquot_data['AliquotDetail']['aliquot_master_id']);
							customInsert($realiquoting_data, 'realiquotings', __FILE__, __LINE__, false);
						} else {
							$import_summary[$summary_title]['@@ERROR@@']['Slide Defined Twice'][] = "The slide [$sample_slide_id] has been defined twice! No second tissue slide will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['Block of Slide Not Defined'][] = "The Sample Block ID [$sample_block_id] for slide [$sample_slide_id] was not defined into the Block worksheet! No tissue slide will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong Slide Id Format'][] = "Unable to extract Sample Tube and block ID from slide ID [$sample_slide_id] based on slide ID format! No slide will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
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
if($limit_data && !preg_match($limit_pattern, $slide_revision_code)) continue;
			if(strlen($slide_revision_code)) {
				if(preg_match('/^(([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+\-.+)\-(HQC1)$/', $slide_revision_code, $matches)) {		
					$sample_tube_id = $matches[2];
					$sample_slide_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_collections_ids) && array_key_exists($sample_slide_id, $tissue_collections_ids[$sample_tube_id]['slide_aliquot_master_ids'])) {
						$collection_id = $tissue_collections_ids[$sample_tube_id]['collection_id'];
						$sample_master_id = $tissue_collections_ids[$sample_tube_id]['sample_master_id'];
						//Create specimen review
						$key = $sample_master_id.$new_line_data['Review by'].$new_line_data['Date'];
						if(!array_key_exists($key, $tmp_patho_review_ids)) {
							//Create speciemn review
							$review_date = getDateAndAccuracy($new_line_data, 'Date', $summary_title, $file_name, $worksheet, $line_counter);
							$review_date['accuracy'] = str_replace('c', 'h', $review_date['accuracy']);
							$review_data = array(
								'SpecimenReviewMaster' => array(
									'collection_id' => $collection_id,
									'sample_master_id' => $sample_master_id,
									'specimen_review_control_id' => $controls['specimen_review_controls']['tissue']['specimen_review_control_id'],
									'review_code' => $matches[3],
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
						foreach(array('should_be_macrodissected' => 'Should it be macrodissected (pathologist)', 'microdissection_lines' => 'Lines for microdissection') as $db_field => $excel_field) {
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
								'aliquot_master_id' => $tissue_collections_ids[$sample_tube_id]['slide_aliquot_master_ids'][$sample_slide_id],
								'specimen_review_master_id' => $specimen_review_master_id,
								'aliquot_review_control_id' => $controls['aliquot_review_controls']['tissue slide']['aliquot_review_control_id'],
								'qcroc_notes' => $new_line_data['Comments']),
							'AliquotReviewDetail' => $detail_data);
						$review_data['AliquotReviewDetail']['aliquot_review_master_id'] = customInsert($review_data['AliquotReviewMaster'], 'aliquot_review_masters', __FILE__, __LINE__, false);
						customInsert($review_data['AliquotReviewDetail'], $controls['aliquot_review_controls']['tissue slide']['detail_tablename'], __FILE__, __LINE__, true);
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['Revised Slide Undefined'][] = "The Sample Slide ID [$sample_slide_id] for tissue tube [$sample_tube_id] was not defined into the Slide worksheet! No slide revision will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong HQC Id'][] = "Unable to extract Sample Tube and slide ID from the HQC Id [$slide_revision_code] based on ID format! No slide revision will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	unset($tmp_patho_review_ids);
	
	// *7* Macro Dissection **
	
	$worksheet = 'Block (left over)';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	$left_overs = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['Initial Block Id']) {
				$block_id = $new_line_data['Initial Block Id'];
if($limit_data && !preg_match($limit_pattern, $block_id)) continue;			
				if($new_line_data['Block Type'] != 'Left Over') die('ERR 23 76287 68732 623 '.$line_counter);
				if(!preg_match("/^$block_id/", $new_line_data['LeftOver Id'])) die ('ERR 237 623876 32876 '.$line_counter);
				if(array_key_exists($block_id, $left_overs)) die('ERR 23 763287 6237 62'.$line_counter);
				$left_overs[$block_id] = $new_line_data['LeftOver Id'];
			} else if($new_line_data['LeftOver Id']) {
				die('ERR234234');
			}
		}
	}
	
	$chil_aliquot_master_ids = array('-1');
	$worksheet = 'Block Event';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$block_id = $new_line_data['Initial Block Id'];
if($limit_data && !preg_match($limit_pattern, $block_id)) continue;
			if(strlen($block_id)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z]+$/', $block_id, $matches)) {
					$sample_tube_id = $matches[1];
					if(array_key_exists($sample_tube_id, $tissue_collections_ids) && array_key_exists($block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
						$collection_id = $tissue_collections_ids[$sample_tube_id]['collection_id'];
						$tissue_sample_master_id = $tissue_collections_ids[$sample_tube_id]['sample_master_id'];
						$block_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$block_id]['id'];
						if($new_line_data['Event Name'] != 'Macrodissection') die('ERR 23 762387 63287 32');
						$macrodissection_date = getDateAndAccuracy($new_line_data, 'Date', $summary_title, $file_name, $worksheet, $line_counter);
						$macrodissection_date['accuracy'] = str_replace('c', 'h', $macrodissection_date['accuracy']);
						$aliquot_use = array(
							'aliquot_master_id' => $block_aliquot_master_id,
							'type' => 'macrodissection',
							'use_datetime' => $macrodissection_date['date'],
							'use_datetime_accuracy' => $macrodissection_date['accuracy'],
							'use_details' => $new_line_data['Comments']
						);
						customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
						if(array_key_exists($block_id, $left_overs)) {
							$aliquot_data = array(
								'AliquotMaster' => array(
									'collection_id' => $collection_id,
									'sample_master_id' => $tissue_sample_master_id,
									'aliquot_control_id' => $controls['sample_aliquot_controls']['tissue']['aliquots']['block']['aliquot_control_id'],
									'barcode' => getNextTmpBarcode(),
									'aliquot_label' => $left_overs[$block_id],
									'in_stock' => 'yes - available',
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
							customInsert($realiquoting_data, 'realiquotings', __FILE__, __LINE__, false);
							//Record id
							$tissue_collections_ids[$sample_tube_id]['left_over_bloc_aliquot_master_ids'][$left_overs[$block_id]]= array('id' => $aliquot_data['AliquotDetail']['aliquot_master_id']);
							$chil_aliquot_master_ids[] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							unset($left_overs[$block_id]);
						} else {
							$import_summary[$summary_title]['@@WARNING@@']['Macrodissected Block But No Left Over'][] = "The Block ID [$block_id] was defined as Macrodissected but no left over block is defined and will be created! Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['Macrodissected Block Undefined'][] = "The Block ID [$block_id] for tissue tube [$sample_tube_id] was not defined into the block worksheet! No Macrodissection data will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong Block Id'][] = "Unable to extract Sample Tube and Block Id from value [$block_id] based on ID format! No Macrodissection data will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
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
	
	foreach($left_overs as $block_id => $lef_over) {
		$import_summary["Tissue : Block (left over)"]['@@ERROR@@']['Unrecorded Left Over Block'][] = "The left over block [$lef_over] has not been created because the Block Id [$block_id] was not defined as macrodissected in Block Event Worksheet. Please confirm and correct if required! ";	
	}
	unset($left_overs);
	
	// *8* RNA **
	
	//Load Tubes Data
	$tmp_rna_tubes = array();
	$worksheet = 'RNA tube';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$rna_tube_label = $new_line_data['RNA Tube'];
if($limit_data && !preg_match($limit_pattern, $rna_tube_label)) continue;
			if(strlen($rna_tube_label)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+[A-Za-z]-.+)-.+/', $rna_tube_label, $matches)) {
					$rna_sample_label = $matches[1];
					if(!array_key_exists($rna_sample_label, $tmp_rna_tubes)) $tmp_rna_tubes[$rna_sample_label] = array();
					if(!array_key_exists($rna_tube_label, $tmp_rna_tubes[$rna_sample_label])) {
						$tmp_rna_tubes[$rna_sample_label][$rna_tube_label] = array(
							'label' => $rna_tube_label,
							'barcode' => $new_line_data['barcode'],
							'volume' => getDecimal($new_line_data, 'Volume', $summary_title, $file_name, $worksheet, $line_counter),
							'quality_controls' => array()
						);
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['RNA tube defined twice'][] = "See RNA tube [$rna_tube_label]. No 2nd RNA tube will be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong RNA tube label Format'][] = "Unable to extract RNA Sample Label from value [$rna_tube_label] based on Label format! No RNA tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	$worksheet = 'RNA Tube QC';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$rna_tube_label = $new_line_data['RNA tube'];
if($limit_data && !preg_match($limit_pattern, $rna_tube_label)) continue;
			if(strlen($rna_tube_label)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+[A-Za-z]-.+)-.+/', $rna_tube_label, $matches)) {
					$rna_sample_label = $matches[1];
					if(array_key_exists($rna_sample_label, $tmp_rna_tubes) && array_key_exists($rna_tube_label, $tmp_rna_tubes[$rna_sample_label])) {
						$qc_date = getDateAndAccuracy($new_line_data, 'Date processed', $summary_title, $file_name, $worksheet, $line_counter);
						$qc_type = '';
						switch(strtolower($new_line_data['QC type'])) {
							case 'nanodrop':
							case 'agarose gel':
							case 'bioanalyser':
								$qc_type = str_replace('bioanalyser', 'bioanalyzer', strtolower($new_line_data['QC type']));
								break;
							case 'rin':
								$qc_type = 'bioanalyzer';
								if($new_line_data['Score Type']) die('ERR 23 762387 6287');
								$new_line_data['Score Type'] = 'RIN';
								break;
							default:
								$import_summary[$summary_title]['@@ERROR@@']['Wrong QC type'][] = "See type [".$new_line_data['QC type']."]. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						$score_unit = '';
						switch(str_replace(' ', '', $new_line_data['Score Type'])) {
							case '260/280':
							case '260/230':
							case 'RIN':
							case '':
								$score_unit = str_replace(' ', '', $new_line_data['Score Type']);
								break;
							default:
								$import_summary[$summary_title]['@@ERROR@@']['Wrong Score type'][] = "See type [".$new_line_data['Score Type']."]. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
						}						
						if(!in_array($new_line_data['RNA Conc Unit'], array('ng/ul', ''))) die('ERR 23 7237 622.1');
						if(!in_array($new_line_data['Picture'], array('yes', 'Yes', ''))) die('ERR 23 7237 622.2');
						$qc_data = array(
							'sample_master_id' => null,
							'aliquot_master_id' => null,
							'used_volume' => '',
							'type' => $qc_type,
							'date' => $qc_date['date'],
							'date_accuracy' => $qc_date['accuracy'],
							'score' => getDecimal($new_line_data, 'Scrore', $summary_title, $file_name, $worksheet, $line_counter),
							'unit' => $score_unit,
							'qcroc_concentration' => getDecimal($new_line_data, 'RNA Conc', $summary_title, $file_name, $worksheet, $line_counter),
							'qcroc_concentration_unit' => $new_line_data['RNA Conc Unit'],
							'qcroc_extraction_yield_ug' => getDecimal($new_line_data, 'RNA yield (µg)', $summary_title, $file_name, $worksheet, $line_counter),
							'qcroc_picture' => empty($new_line_data['Picture'])? '' : 'y',
							'conclusion' => '',
							'notes' => $new_line_data['Note']);
						if('bioanalyzer' == $qc_type) {
							if(!array_key_exists($qc_type.$qc_date['date'], $tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls'])) {
								$tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls'][$qc_type.$qc_date['date']] = $qc_data;
							} else {
								$qc_data_already_recorded = $tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls'][$qc_type.$qc_date['date']];
								foreach(array('score', 'unit', 'qcroc_concentration', 'qcroc_concentration_unit', 'qcroc_extraction_yield_ug','qcroc_picture','notes') as $field) {
									if(strlen($qc_data[$field])) {
										if(strlen($qc_data_already_recorded[$field])) { pr($new_line_data); die('ERR 23 98 876298 32798 7232'); }
										$tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls'][$qc_type.$qc_date['date']][$field] = $qc_data[$field];
									}
								}
							}							
						} else {
							$tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls'][] = $qc_data;
						}
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['RNA tube undefined'][] = "The tested RNA tube [$rna_tube_label] was not defined into RNA Tube worksheet. The quality contrl won't be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong RNA tube label Format'][] = "Unable to extract RNA Sample Label from value [$rna_tube_label] based on Label format! The quality contrl won't be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	$import_summary[$summary_title]['@@MESSAGE@@']["In Stock Status of tested tubes (used for QC) set to 'no'"][] = "Please confirm";
	// Create Sample, tube and QC
	$block_aliquot_master_ids_to_udpate_status = array();
	$tmp_rna_sample_labels_to_check_dup = array();
	$worksheet = 'RNA';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$rna_sample_label = $new_line_data['RNA Extraction'];
if($limit_data && !preg_match($limit_pattern, $rna_sample_label)) continue;
			if(strlen($rna_sample_label)) {
				if(preg_match('/^(([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z])-.+$/', $rna_sample_label, $matches)) {
					$block_id = $matches[1];
					$sample_tube_id = $matches[2];
					if(!in_array($rna_sample_label, $tmp_rna_sample_labels_to_check_dup)) {
						$tmp_rna_sample_labels_to_check_dup[$rna_sample_label] = $rna_sample_label;
						//Get ids
						$collection_id = null;
						$tissue_sample_master_id = null;
						$block_aliquot_master_id = null;
						if(array_key_exists($sample_tube_id, $tissue_collections_ids)) {
							$collection_id = $tissue_collections_ids[$sample_tube_id]['collection_id'];
							$tissue_sample_master_id = $tissue_collections_ids[$sample_tube_id]['sample_master_id'];
							if(array_key_exists($block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
								$block_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$block_id]['id'];
							} else if(array_key_exists($block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
								$block_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['left_over_bloc_aliquot_master_ids'][$block_id]['id'];
								$import_summary[$summary_title]['@@WARNING@@']['RNA extracted from left over block'][] = "The RNA solution [$rna_sample_label] has been extracted from The left over block [$block_id]. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						}
						if($block_aliquot_master_id) {
							//Extraction date
							$extraction_date = getDateAndAccuracy($new_line_data, 'Date of isolation', $summary_title, $file_name, $worksheet, $line_counter);
							$extraction_date['accuracy'] = str_replace('c', 'h', $extraction_date['accuracy']);
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
							$sop = str_replace('n/av', '', strtolower($new_line_data['SOP followed']));
							if(!in_array($sop, array('sop-tr-008', ''))){
								$import_summary[$summary_title]['@@WARNING@@']['SOP followed unknown'][] = "See value [".$new_line_data['SOP followed']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
								$sop = '';
							}
							//Elution volum
							$elution_volume = getDecimal($new_line_data, 'Elution Volume', $summary_title, $file_name, $worksheet, $line_counter);
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
							//Create aliquot to sample link
							customInsert(array('sample_master_id' => $rna_sample_master_id, 'aliquot_master_id' => $block_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
							$block_aliquot_master_ids_to_udpate_status[] = $block_aliquot_master_id;
							//Create tube
							if(array_key_exists($rna_sample_label, $tmp_rna_tubes)) {
								$total_recorded_volume = 0;
								foreach($tmp_rna_tubes[$rna_sample_label] as $rna_tube_label => $rna_tub_data) {
									$not_used_for_quality_controls = empty($tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls']);
									$initial_volume = $not_used_for_quality_controls? (strlen($rna_tub_data['volume'])? $rna_tub_data['volume'] : $elution_volume) : $rna_tub_data['volume'];
									if($not_used_for_quality_controls) $total_recorded_volume += (empty($initial_volume)? 0 : $initial_volume);
									$aliquot_data = array(
										'AliquotMaster' => array(
											'collection_id' => $collection_id,
											'sample_master_id' => $rna_sample_master_id,
											'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
											'aliquot_label' => $rna_tub_data['label'],
											'barcode' => empty($rna_tub_data['barcode'])? getNextTmpBarcode() : $rna_tub_data['barcode'],
											'in_stock' => ($not_used_for_quality_controls? 'yes - available' : 'no'),
											'initial_volume' => $initial_volume,
											'current_volume' => $initial_volume,
											'use_counter' => '0',
											'storage_datetime' => $extraction_date['date'],
											'storage_datetime_accuracy' => $extraction_date['accuracy']),
										'AliquotDetail' => array());
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									//Create QC
									if(!$not_used_for_quality_controls) {
										foreach($tmp_rna_tubes[$rna_sample_label][$rna_tube_label]['quality_controls'] as $qc_data) {
											if($qc_data['qcroc_concentration']) {
												if($qc_data['qcroc_concentration_unit'] != 'ng/ul') die('ERR 23 7237 622 773883');
												if($elution_volume) {
													$calculated_qcroc_extraction_yield_ug = $elution_volume*$qc_data['qcroc_concentration']/1000;
													if($qc_data['qcroc_extraction_yield_ug']) {
														$calculated_qcroc_extraction_yield_ug = round($calculated_qcroc_extraction_yield_ug, (preg_match('/\./', $qc_data['qcroc_extraction_yield_ug'])? strlen(substr($qc_data['qcroc_extraction_yield_ug'], (strpos($qc_data['qcroc_extraction_yield_ug'], '.')+1))) : 0));
														if($calculated_qcroc_extraction_yield_ug != $qc_data['qcroc_extraction_yield_ug']) {
															$import_summary["Tissue : RNA Tube QC"]['@@WARNING@@']['Calculated RNA Exctraction Yield Different Than Yield Set'][] = "Migration process calculated the yield for RNA [".$rna_tub_data['label']."] and is different than the yield set into excel: $calculated_qcroc_extraction_yield_ug (calc.) != ".$qc_data['qcroc_extraction_yield_ug']." (excel). Please confirm.";
														}														
													} else {
														//Calculate
														$qc_data['qcroc_extraction_yield_ug'] = $calculated_qcroc_extraction_yield_ug;
														$import_summary["Tissue : RNA Tube QC"]['@@MESSAGE@@']['RNA Exctraction Yield Calculated By The Process'][] = "Migration process calculated the yield of RNA [".$rna_tub_data['label']."] based on ".$qc_data['type']." test because this one was not set into excel: Set to $calculated_qcroc_extraction_yield_ug. Please confirm.";
													}
												}
											}
											$qc_data['sample_master_id'] = $rna_sample_master_id;
											$qc_data['aliquot_master_id'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
											customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);											
										}
										if(!preg_match('/-tQC$/', $rna_tub_data['label'])) $import_summary[$summary_title]['@@WARNING@@']['Tested Aliquot Different than %-tQC'][] = "See RNA tupe [".$rna_tub_data['label']."]! In stock value will be set to no, please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
									}								
									unset($tmp_rna_tubes[$rna_sample_label][$rna_tube_label]);
								}
								if(strlen($elution_volume) && $total_recorded_volume != $elution_volume) {
									$import_summary[$summary_title]['@@ERROR@@']['Elution Volume Does Not Match Sum Of Tubes Volume'][] = "The elution volume of rna [$rna_sample_label] was set to [$elution_volume] in excel but the volume total of the created tubes equals to [$total_recorded_volume]. Please confirm and correct if required! [file '$file_name' ($worksheet) - line: $line_counter]";
								}
								unset($tmp_rna_tubes[$rna_sample_label]);
							}
						} else {
							$import_summary[$summary_title]['@@ERROR@@']['Block Not Defined'][] = "The Sample Block ID [$block_id] used to create RNA [$rna_sample_label] was not defined into the Block (or left over block) worksheet! No RNA will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
					} else {
						//Rna id defined twice
						die('ERR2398723987298732');
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong RNA Id Format'][] = "Unable to extract Sample Tube and Block Id from value [$rna_sample_label] based on ID format! No RNA extraction will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	if($block_aliquot_master_ids_to_udpate_status) {
		$import_summary[$summary_title]['@@MESSAGE@@']["In Stock Status of blocks used for DNA extraction set to 'no'"][] = "Please confirm";	
		$query = "UPDATE aliquot_masters SET in_stock = 'no' WHERE id IN (".implode(',',$block_aliquot_master_ids_to_udpate_status).");";
		customQuery($query, __FILE__, __LINE__);
	}
	//Test all aliquot used
	foreach ($tmp_rna_tubes as $rna_sample_label => $aliquots) {
		foreach($aliquots as $rna_tube) {
			$import_summary["Tissue : RNA tube"]['@@ERROR@@']['No RNA created for RNA tube'][] = "A RNA tube [".$rna_tube['label']."] has been defined but no matching rna sample was defined into RNA worksheet! The RNA tube (and the related quality controls) won't be created!";
		}
	}
	unset($tmp_rna_tubes);
	unset($tmp_rna_sample_labels_to_check_dup);
	
	// *9* DNA **
	
	//Load Tubes Data
	$tmp_dna_tubes = array();
	$worksheet = 'DNA tube';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$dna_tube_label = $new_line_data['DNA tube Id'];
if($limit_data && !preg_match($limit_pattern, $dna_tube_label)) continue;
			if(strlen($dna_tube_label)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+[A-Za-z]-.+)-.+/', $dna_tube_label, $matches)) {
					$dna_sample_label = $matches[1];
					if(!array_key_exists($dna_sample_label, $tmp_dna_tubes)) $tmp_dna_tubes[$dna_sample_label] = array();
					if(!array_key_exists($dna_tube_label, $tmp_dna_tubes[$dna_sample_label])) {
						$tmp_dna_tubes[$dna_sample_label][$dna_tube_label] = array(
								'label' => $dna_tube_label,
								'barcode' => $new_line_data['Barcode'],
								'volume' => getDecimal($new_line_data, 'Volume', $summary_title, $file_name, $worksheet, $line_counter),
								'quality_controls' => array()
						);
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['DNA tube defined twice'][] = "See DNA tube [$dna_tube_label]. No 2nd DNA tube will be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong DNA tube label Format'][] = "Unable to extract DNA Sample Label from value [$dna_tube_label] based on Label format! No DNA tube will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	$worksheet = 'DNA QC';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$dna_tube_label = $new_line_data['DNA tube'];
if($limit_data && !preg_match($limit_pattern, $dna_tube_label)) continue;
			if(strlen($dna_tube_label)) {
				if(preg_match('/^([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+[A-Za-z]-.+)-.+/', $dna_tube_label, $matches)) {
					$dna_sample_label = $matches[1];
					if(array_key_exists($dna_sample_label, $tmp_dna_tubes) && array_key_exists($dna_tube_label, $tmp_dna_tubes[$dna_sample_label])) {
						$qc_date = getDateAndAccuracy($new_line_data, 'Date', $summary_title, $file_name, $worksheet, $line_counter);
						$qc_type = '';
						switch(strtolower($new_line_data['QC Type'])) {
							case 'nanodrop':
							case 'agarose gel':
							case 'picogreen':
								$qc_type = strtolower($new_line_data['QC Type']);
								break;
							default:
								$import_summary[$summary_title]['@@ERROR@@']['Wrong QC Type'][] = "See type [".$new_line_data['QC Type']."]. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						$score_unit = '';
						switch(str_replace(' ', '', $new_line_data['Score Type'])) {
							case '260/280':
							case '260/230':
							case '':
								$score_unit = str_replace(' ', '', $new_line_data['Score Type']);
								break;
							default:
								$import_summary[$summary_title]['@@ERROR@@']['Wrong Score type'][] = "See type [".$new_line_data['Score Type']."]. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
						if(!in_array($new_line_data['DNA Conc Unit'], array( 'ng/ul', ''))) die('ERR 23 7237 622.32 ['.$new_line_data['DNA Conc Unit'].']');
						if(!in_array($new_line_data['Picture'], array('yes', 'Yes', 'No', 'no', ''))) die('ERR 23 7237 622.44');
						$qc_data = array(
							'sample_master_id' => null,
							'aliquot_master_id' => null,
							'used_volume' => '',
							'type' => $qc_type,
							'date' => $qc_date['date'],
							'date_accuracy' => $qc_date['accuracy'],
							'score' => getDecimal($new_line_data, 'Score', $summary_title, $file_name, $worksheet, $line_counter),
							'unit' => $score_unit,
							'qcroc_concentration' => getDecimal($new_line_data, 'DNA Conc', $summary_title, $file_name, $worksheet, $line_counter),
							'qcroc_concentration_unit' => $new_line_data['DNA Conc Unit'],
							'qcroc_extraction_yield_ug' => getDecimal($new_line_data, 'DNA yield (µg)', $summary_title, $file_name, $worksheet, $line_counter),
							'qcroc_picture' => str_replace(array('yes', 'Yes', 'No', 'no'), array('1', '1', '0', '0'), $new_line_data['Picture']),
							'conclusion' => '',
							'notes' => $new_line_data['Note']);
						$tmp_dna_tubes[$dna_sample_label][$dna_tube_label]['quality_controls'][] = $qc_data;
					} else {
						$import_summary[$summary_title]['@@ERROR@@']['DNA tube undefined'][] = "The tested DNA tube [$dna_tube_label] was not defined into DNA Tube worksheet. The quality contrl won't be created. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong DNA tube label Format'][] = "Unable to extract DNA Sample Label from value [$dna_tube_label] based on Label format! The quality contrl won't be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	$import_summary[$summary_title]['@@MESSAGE@@']["In Stock Status of tested tubes (used for QC) set to 'no'"][] = "Please confirm";
	// Create Sample, tube and QC
	$block_aliquot_master_ids_to_udpate_status = array();
	$tmp_dna_sample_labels_to_check_dup = array();
	$worksheet = 'DNA';
	$summary_title = "Tissue : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$dna_sample_label = $new_line_data['DNA Isolation  Id'];
if($limit_data && !preg_match($limit_pattern, $dna_sample_label)) continue;
			if(strlen($dna_sample_label)) {
				if(preg_match('/^(([0-9]+\-[0-9]+\-[0-9]+\-[0-9]+)[A-Za-z])-.+$/', $dna_sample_label, $matches)) {
					$block_id = $matches[1];
					$sample_tube_id = $matches[2];
					if(!in_array($dna_sample_label, $tmp_dna_sample_labels_to_check_dup)) {
						$tmp_dna_sample_labels_to_check_dup[$dna_sample_label] = $dna_sample_label;
						//Get ids
						$collection_id = null;
						$tissue_sample_master_id = null;
						$block_aliquot_master_id = null;
						if(array_key_exists($sample_tube_id, $tissue_collections_ids)) {
							$collection_id = $tissue_collections_ids[$sample_tube_id]['collection_id'];
							$tissue_sample_master_id = $tissue_collections_ids[$sample_tube_id]['sample_master_id'];
							if(array_key_exists($block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
								$block_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'][$block_id]['id'];
							} else if(array_key_exists($block_id, $tissue_collections_ids[$sample_tube_id]['bloc_aliquot_master_ids'])) {
								$block_aliquot_master_id = $tissue_collections_ids[$sample_tube_id]['left_over_bloc_aliquot_master_ids'][$block_id]['id'];
								$import_summary[$summary_title]['@@WARNING@@']['DNA extracted from left over block'][] = "The DNA solution [$dna_sample_label] has been extracted from The left over block [$block_id]. Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						}
						if($block_aliquot_master_id) {
							//Extraction date
							$extraction_date = getDateAndAccuracy($new_line_data, 'IsolationDate', $summary_title, $file_name, $worksheet, $line_counter);
							$extraction_date['accuracy'] = str_replace('c', 'h', $extraction_date['accuracy']);
							//Kit
							$kit = strtolower($new_line_data['Kit']);
							switch($kit) {
								case 'allprepdna/rna':
									$kit = 'allprep dna/rna';
									break;
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
								default:
									$import_summary[$summary_title]['@@WARNING@@']['Kit used unknown'][] = "See value [".$new_line_data['Kit']."]. Value won't be migrated! [file '$file_name' ($worksheet) - line: $line_counter]";
									$kit = '';
							}
							//Elution volum
							$elution_volume = getDecimal($new_line_data, 'Elution  Volume (µL)', $summary_title, $file_name, $worksheet, $line_counter);
							//Create DNA Sample
							$sample_data = array(
									'SampleMaster' => array(
											'collection_id' => $collection_id,
											'sample_control_id' => $sample_aliquot_controls['dna']['sample_control_id'],
											'initial_specimen_sample_type' => 'tissue',
											'initial_specimen_sample_id' => $tissue_sample_master_id,
											'parent_sample_type' => 'tissue',
											'parent_id' => $tissue_sample_master_id,
											'notes' => $new_line_data['Note']),
									'DerivativeDetail' => array(
											'creation_datetime' => $extraction_date['date'],
											'creation_datetime_accuracy' => $extraction_date['accuracy']),
									'SampleDetail' => array(
											'qcroc_kit' => $kit,
											'qcroc_lot_number' => $new_line_data['Lot Number']));
	
							$dna_sample_master_id = createSample($sample_data, $sample_aliquot_controls['dna']['detail_tablename']);
							//Create aliquot to sample link
							customInsert(array('sample_master_id' => $dna_sample_master_id, 'aliquot_master_id' => $block_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
							$block_aliquot_master_ids_to_udpate_status[] = $block_aliquot_master_id;
							//Create tube
							if(array_key_exists($dna_sample_label, $tmp_dna_tubes)) {
								$total_recorded_volume = 0;
								foreach($tmp_dna_tubes[$dna_sample_label] as $dna_tube_label => $dna_tub_data) {
									$not_used_for_quality_controls = empty($tmp_dna_tubes[$dna_sample_label][$dna_tube_label]['quality_controls']);
									$initial_volume = $not_used_for_quality_controls? (strlen($dna_tub_data['volume'])? $dna_tub_data['volume'] : $elution_volume) : $dna_tub_data['volume'];
									if($not_used_for_quality_controls) $total_recorded_volume += (empty($initial_volume)? 0 : $initial_volume);
									$aliquot_data = array(
											'AliquotMaster' => array(
													'collection_id' => $collection_id,
													'sample_master_id' => $dna_sample_master_id,
													'aliquot_control_id' => $sample_aliquot_controls['dna']['aliquots']['tube']['aliquot_control_id'],
													'aliquot_label' => $dna_tub_data['label'],
													'barcode' => empty($dna_tub_data['barcode'])? getNextTmpBarcode() : $dna_tub_data['barcode'],
													'in_stock' => ($not_used_for_quality_controls? 'yes - available' : 'no'),
													'initial_volume' => $initial_volume,
													'current_volume' => $initial_volume,
													'use_counter' => '0',
													'storage_datetime' => $extraction_date['date'],
													'storage_datetime_accuracy' => $extraction_date['accuracy']),
											'AliquotDetail' => array());
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['dna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									//Create QC
									if(!$not_used_for_quality_controls) {
										foreach($tmp_dna_tubes[$dna_sample_label][$dna_tube_label]['quality_controls'] as $qc_data) {
											if($qc_data['qcroc_concentration']) {
												if($qc_data['qcroc_concentration_unit'] != 'ng/ul') die('ERR 23 7237 622 773883');
												if($elution_volume) {
													$calculated_qcroc_extraction_yield_ug = $elution_volume*$qc_data['qcroc_concentration']/1000;
													if($qc_data['qcroc_extraction_yield_ug']) {
														$calculated_qcroc_extraction_yield_ug = round($calculated_qcroc_extraction_yield_ug, (preg_match('/\./', $qc_data['qcroc_extraction_yield_ug'])? strlen(substr($qc_data['qcroc_extraction_yield_ug'], (strpos($qc_data['qcroc_extraction_yield_ug'], '.')+1))) : 0));
														if($calculated_qcroc_extraction_yield_ug != $qc_data['qcroc_extraction_yield_ug']) {
															$import_summary["Tissue : DNA Tube QC"]['@@WARNING@@']['Calculated DNA Exctraction Yield Different Than Yield Set'][] = "Migration process calculated the yield for DNA [".$dna_tub_data['label']."] and is different than the yield set into excel: $calculated_qcroc_extraction_yield_ug (calc.) != ".$qc_data['qcroc_extraction_yield_ug']." (excel). Please confirm.";
														}
													} else {
														//Calculate
														$qc_data['qcroc_extraction_yield_ug'] = $calculated_qcroc_extraction_yield_ug;
														$import_summary["Tissue : DNA Tube QC"]['@@MESSAGE@@']['DNA Exctraction Yield Calculated By The Process'][] = "Migration process calculated the yield of DNA [".$dna_tub_data['label']."] based on ".$qc_data['type']." test because this one was not set into excel: Set to $calculated_qcroc_extraction_yield_ug. Please confirm.";
													}
												}
											}
											$qc_data['sample_master_id'] = $dna_sample_master_id;
											$qc_data['aliquot_master_id'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
											customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
										}
										if(!preg_match('/-tQC$/', $dna_tub_data['label'])) $import_summary[$summary_title]['@@WARNING@@']['Tested Aliquot Different than %-tQC'][] = "See DNA tupe [".$dna_tub_data['label']."]! In stock value will be set to no, please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
									}
									unset($tmp_dna_tubes[$dna_sample_label][$dna_tube_label]);
								}
								if(strlen($elution_volume) && $total_recorded_volume != $elution_volume) {
									$import_summary[$summary_title]['@@ERROR@@']['Elution Volume Does Not Match Sum Of Tubes Volume'][] = "The elution volume of dna [$dna_sample_label] was set to [$elution_volume] in excel but the volume total of the created tubes equals to [$total_recorded_volume]. Please confirm and correct if required! [file '$file_name' ($worksheet) - line: $line_counter]";
								}
								unset($tmp_dna_tubes[$dna_sample_label]);
							}
						} else {
							$import_summary[$summary_title]['@@ERROR@@']['Block Not Defined'][] = "The Sample Block ID [$block_id] used to create DNA [$dna_sample_label] was not defined into the Block (or left over block) worksheet! No DNA will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
						}
					} else {
						//Rna id defined twice
						die('ERR2398723987298732');
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Wrong DNA Id Format'][] = "Unable to extract Sample Tube and Block Id from value [$dna_sample_label] based on ID format! No DNA extraction will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			}
		}
	}
	if($block_aliquot_master_ids_to_udpate_status) {
		$import_summary[$summary_title]['@@MESSAGE@@']["In Stock Status of blocks used for DNA extraction set to 'no'"][] = "Please confirm";
		$query = "UPDATE aliquot_masters SET in_stock = 'no' WHERE id IN (".implode(',',$block_aliquot_master_ids_to_udpate_status).");";
		customQuery($query, __FILE__, __LINE__);
	}
	//Test all aliquot used
	foreach ($tmp_dna_tubes as $dna_sample_label => $aliquots) {
		foreach($aliquots as $dna_tube) {
			$import_summary["Tissue : DNA tube"]['@@ERROR@@']['No DNA created for DNA tube'][] = "A DNA tube [".$dna_tube['label']."] has been defined but no matching dna sample was defined into DNA worksheet! The DNA tube (and the related quality controls) won't be created!";
		}
	}
	unset($tmp_dna_tubes);
	unset($tmp_dna_sample_labels_to_check_dup);	
	
	// *10* Final Control **
	
	$query = "
		SELECT am.aliquot_label
		FROM aliquot_masters am
		INNER JOIN aliquot_internal_uses aiu ON aiu.aliquot_master_id = am.id
		WHERE aiu.type = 'macrodissection' AND aiu.deleted <> 1 AND am.deleted <> 1 AND am.in_stock != 'no';";
	$summary_title = "Tissue : Block Event";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$import_summary[$summary_title]['@@WARNING@@']['Macrodissected Block Available'][] = "The block [".$row['aliquot_label']."] was defined as marcodissected but is still available into ATiM because no RNA or DNA has been created from this one! Please confirm and correct if required!";
	}
	
	$query = "SELECT aliquot_label FROM aliquot_masters WHERE aliquot_label LIKE '%tQC' AND in_stock != 'no';";
	$summary_title = "Tissue : RNA";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$import_summary[$summary_title]['@@WARNING@@']['RNA/DNA tQC tube available'][] = "DNA/RNA tube [".$row['aliquot_label']."] is available into ATiM because this one has not been used for quality control! Please confirm and correct if required!";
	}
	
	$query = "
		SELECT am.aliquot_label
		FROM aliquot_masters am 
		INNER JOIN ".$controls['sample_aliquot_controls']['tissue']['aliquots']['block']['detail_tablename']." ad ON ad.aliquot_master_id = am.id
		WHERE am.deleted <> 1 
		AND am.in_stock != 'no' AND ad.qcroc_left_over <> 1 AND am.aliquot_control_id = ".$controls['sample_aliquot_controls']['tissue']['aliquots']['block']['aliquot_control_id'].";";
	$summary_title = "Tissue : Block";	
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$import_summary[$summary_title]['@@MESSAGE@@']['Tissue Block Available Beacause No Extraction Done'][] = "Block [".$row['aliquot_label']."]! Please confirm and correct if required!";
	}

	$query = "
		SELECT am.aliquot_label
		FROM aliquot_masters am
		WHERE am.deleted <> 1
		AND am.in_stock != 'no'  AND am.aliquot_control_id = ".$controls['sample_aliquot_controls']['tissue']['aliquots']['tube']['aliquot_control_id'].";";
	$summary_title = "Tissue : Tube";
	$results = customQuery($query, __FILE__, __LINE__);
	 while($row = $results->fetch_assoc()){
		$import_summary[$summary_title]['@@MESSAGE@@']['Tissue Tube Available Beacause No Block Created'][] = "Tube [".$row['aliquot_label']."]! Please confirm and correct if required!";
	}
}

function loadBlood(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	
//TODO
$limit_data = false;
$limit_pattern = '/^[0-9]+\-B[0-9]+\-0[1]/';
	
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];

	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

	$blood_collection_labels_to_ids = array();
	
	// *1* Create Collection **
	
	$blood_collection_and_sample_ids = array();
	
	$worksheet = 'Collection';
	$summary_title = "Blood : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$blood_collection_label = $new_line_data['Collection Id'];
if($limit_data && !preg_match($limit_pattern, $blood_collection_label)) continue;
			if(preg_match('/^([0-9]+)\-B([0-9]+)-([0-9]+)$/', $blood_collection_label, $matches)) {
				$collection_id = getCollectionId($matches[1], $matches[3], 'B', $matches[2], $new_line_data['Date of collection'], $new_line_data['Time collection'], $new_line_data['Site'], '', $summary_title, $file_name, $worksheet, $line_counter);
				$blood_collection_and_sample_ids[$blood_collection_label] = array('collection_id' => $collection_id, 'sample_master_ids' => array(), 'created_aliquots' => array());
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Collection Value Format Not Supported'][] = "See value [$blood_collection_label]! The collection won't be created! [file '$file_name' ($worksheet) - line: $line_counter]";
			}
		}
	}
	
	// *2* Create Sample **
	
	$worksheet = 'Derivative';
	$summary_title = "Blood : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$derivative_label = $new_line_data['Derivation Id'];
if($limit_data && !preg_match($limit_pattern, $derivative_label)) continue;
			if(preg_match('/^([0-9]+-B[0-9]+-[0-9]+)-((EDTA)|(CTAD))-((P)|(BC))$/', $derivative_label, $matches)) {
				$blood_collection_label = $matches[1];
				$blood_type = $matches[2];
				$blood_label = $blood_collection_label.'-'.$blood_type;
				$derivative_type = ($matches[5] == 'P')? 'plasma': 'pbmc';
				if(array_key_exists($blood_collection_label, $blood_collection_and_sample_ids)) {
					$collection_id = $blood_collection_and_sample_ids[$blood_collection_label]['collection_id'];
					//Blood
					if(!array_key_exists($blood_label, $blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'])) {
						$sample_data = array(
							'SampleMaster' => array(
								'collection_id' => $collection_id,
								'sample_control_id' => $controls['sample_aliquot_controls']['blood']['sample_control_id'],
								'initial_specimen_sample_type' => 'blood'),
							'SpecimenDetail' => array(),
							'SampleDetail' => array('blood_type' => $blood_type));
						$blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'][$blood_label] = createSample($sample_data, $controls['sample_aliquot_controls']['blood']['detail_tablename']);
						
					}
					$blood_sample_master_id = $blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'][$blood_label];
					//Derivative
					if(!array_key_exists($derivative_label, $blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'])) {
						$date_of_derivative_creation = getDateTimeAndAccuracy($new_line_data, 'Process Date', 'Process Time', $summary_title, $file_name, $worksheet, $line_counter);
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
						$blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'][$derivative_label] = createSample($sample_data, $controls['sample_aliquot_controls'][$derivative_type]['detail_tablename']);
					} else {
						$import_summary[$summary_title]['@@WARNING@@']['Derivative Was Defiend Twice'][] = "See derivative [$derivative_label]! Sample won't be created twice, please verify data are the same! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Collection ID Unknown'][] = "See value [$blood_collection_label] from derivative ID [$derivative_label]! No samples will be created! [file '$file_name' ($worksheet) - line: $line_counter]";
				}
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Derivativation ID Format Not Supported'][] = "See value [$derivative_label]! The derivative won't be created! [file '$file_name' ($worksheet) - line: $line_counter]";
			}
		}
	}	
	
	// *3* Create Aliquot **
	$tmp_barcodes_check = array();
	$worksheet = 'Tube';
	$summary_title = "Blood : $worksheet";
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$tube_label = $new_line_data['Tube id'];
if($limit_data && !preg_match($limit_pattern, $tube_label)) continue;
			if(preg_match('/^(([0-9]+-B[0-9]+-[0-9]+)-((EDTA)|(CTAD))-((P)|(BC)))[0-9]+$/', $tube_label, $matches)) {
				$blood_collection_label = $matches[2];
				$sample_label = $matches[1];
				$derivative_type = ($matches[6] == 'P')? 'plasma': 'pbmc';
				if(array_key_exists($sample_label, $blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'])) {
					$collection_id =  $blood_collection_and_sample_ids[$blood_collection_label]['collection_id'];
					$sample_master_id = $blood_collection_and_sample_ids[$blood_collection_label]['sample_master_ids'][$sample_label]; 
					if(in_array($tube_label, $blood_collection_and_sample_ids[$blood_collection_label]['created_aliquots'])) {
						$import_summary[$summary_title]['@@WARNING@@']['Tube Lable Used Twice'][] = "At least 2 aliquots with the same label [$tube_label] have been created! Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
					}
					$blood_collection_and_sample_ids[$blood_collection_label]['created_aliquots'][$tube_label] = $tube_label;
					$barcode = '';
					if(empty($new_line_data['BarCode']))  {
						$import_summary[$summary_title]['@@WARNING@@']['Blood Barcode Is Missing'][] = "See line $line_counter! [file '$file_name' ($worksheet) - line: $line_counter]";
						$barcode = getNextTmpBarcode();
					} else {
						$barcode = $new_line_data['BarCode'];
						if(in_array($barcode, $tmp_barcodes_check)) {
							$import_summary[$summary_title]['@@WARNING@@']['Blood Barcode Defined twice'][] = "Barcode '$barcode' is defined twice! Barcode of the aliquot $tube_label'' will be replaced by a system barcode! See line $line_counter! [file '$file_name' ($worksheet) - line: $line_counter]";
							$barcode = getNextTmpBarcode();
						}
						$tmp_barcodes_check[] = $barcode;
					}
					$storage_date = getDateTimeAndAccuracy($new_line_data, 'Storage Date', "Storage Time", $summary_title, $file_name, $worksheet, $line_counter);
					$initial_volume = getDecimal($new_line_data, 'Volume', $summary_title, $file_name, $worksheet, $line_counter);
					if(strlen($initial_volume)) {
						$initial_volume = $initial_volume/1000;
						if(strtolower($new_line_data['Volume unit']) != 'ul') {
							if(strlen($new_line_data['Volume unit'])) {
								$import_summary[$summary_title]['@@ERROR@@']['Blood volume unit not supported'][] = "See value [".$new_line_data['Volume unit']."]! Will be change to ul! Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
							} else {
								$import_summary[$summary_title]['@@WARNING@@']['Blood volume unit not defined'][] = "Will be change to ul! Please confirm! [file '$file_name' ($worksheet) - line: $line_counter]";
							}
						}						
					}					
					$hemolysis_signs = '';
					$comments = array();
					switch($new_line_data['Color']) {
						case '';
							break;
						case 'Clear':
						case 'Yellow':
						case 'Lemon Yellow':
						case 'Golden Yellow':
						case 'Dark Yellow':
						case 'Bright Yellow':
						case 'Light Yellow':
							$hemolysis_signs = 'n';
							$import_summary[$summary_title]['@@WARNING@@']['Tube Color Considered As Not Hemolysis signs'][$new_line_data['Color']] = "See value [".$new_line_data['Color']."] & confirm! [file '$file_name' ($worksheet) - line: $line_counter]";		
							$comments[] = 'Color: '.$new_line_data['Color'].'.';
							break;
						case 'Red':
						case 'Reddish Yellow':
						case 'Pinkish Yellow':
						case 'Orange':
						case 'Yellow-Orange':
						case 'Pink':
						case 'Pink & Milky':
							$hemolysis_signs = 'y';
							$import_summary[$summary_title]['@@WARNING@@']['Tube Color Considered As Hemolysis signs'][$new_line_data['Color']] = "See value [".$new_line_data['Color']."] & confirm! [file '$file_name' ($worksheet) - line: $line_counter]";		
							$comments[] = 'Color: '.$new_line_data['Color'].'.';
							break;
						default:
							$import_summary[$summary_title]['@@WARNING@@']['Blood Sample Color Not Supported'][] = "See value [".$new_line_data['Color']."]! [file '$file_name' ($worksheet) - line: $line_counter]";		
					}
					$storage_master_id = getStorageMasterId($new_line_data['BOX #'], 'blood', $summary_title, $file_name, $worksheet, $line_counter);
					$storage_coordinates = getPosition($new_line_data['BOX #'], $new_line_data['Location in box'], 'blood', $summary_title, $file_name, $worksheet, $line_counter);
					$comments[] = $new_line_data['Comments'];
					$aliquot_data = array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $sample_master_id,
							'aliquot_control_id' => $controls['sample_aliquot_controls'][$derivative_type]['aliquots']['tube']['aliquot_control_id'],
							'barcode' => $barcode,
							'aliquot_label' => $tube_label,
							'in_stock' => 'yes - available',
							'initial_volume' => $initial_volume,
							'current_volume' => $initial_volume,
							'use_counter' => '0',
							'storage_datetime' => $storage_date['datetime'],
							'storage_datetime_accuracy' => $storage_date['accuracy'],
							'storage_master_id' => $storage_master_id,
							'storage_coord_x' => $storage_coordinates['x'],
							'storage_coord_y' => $storage_coordinates['y'],
							'notes'=> implode(' ', $comments)),
						'AliquotDetail' => array(
							'hemolysis_signs' => $hemolysis_signs));
					$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
					customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls'][$derivative_type]['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
				} else {
					$import_summary[$summary_title]['@@ERROR@@']['Sample Label Unknown'][] = "See value [$sample_label] from tube ID [$tube_label]! No aliquot will be created! [file '$file_name' ($worksheet) - line: $line_counter]";	
				}
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Tube ID Format Not Supported'][] = "See value [$tube_label]! The aliquot won't be created! [file '$file_name' ($worksheet) - line: $line_counter]";	
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
			case 'RVH':
			case 'SCH':
			case 'CLH':
			case 'SMH':
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