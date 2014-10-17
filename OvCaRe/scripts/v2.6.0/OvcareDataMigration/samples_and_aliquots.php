<?php

function loadSamplesAndAliquots(&$xls_sheets, $sheets_keys, $voas_to_collection_ids, $atim_controls) {
	global $summary_msg;
	
	$tissue_matches = getTissueMatches();
	$aliquot_label_to_storage_data = loadStorageData($xls_sheets, $sheets_keys, $atim_controls);
	
	//===============================================================================================================
	// PARSE WORKSHEET : SpecimenQualityControl
	//===============================================================================================================
	
	$studied_voa_nbr = null;
	$specimen_review = array();
	$specimen_review_from_aliquot_label = array();
	$worksheet_name = 'Specimen Quality Control';
	$file_voa_nbr = null;
	foreach($xls_sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			if($new_line_data['VOA Number']) $file_voa_nbr = $new_line_data['VOA Number'];
			if(strlen($new_line_data['Sample Identifier'])) {
				if(!preg_match('/^VOA0*([1-9][0-9]+)/', $new_line_data['Sample Identifier'], $matches)) die('ERR 238728 73287231 '.$excel_line_counter);
				$studied_voa_nbr = $matches[1];
				if(!$studied_voa_nbr) die('ERR 37372882372332');
				if($studied_voa_nbr != $file_voa_nbr) die('ERR 3737288237233333');
				// Specimen Review
				$patho_reviewer = $new_line_data['Pathology Reviewer'];
				$reviewed_pathology = $new_line_data['Reviewed Pathology'];
				$patho_key_2 = (empty($reviewed_pathology)? '?' : $reviewed_pathology).' '.$patho_reviewer;
				if(strlen($patho_reviewer)) {
					if(!isset($specimen_review[$studied_voa_nbr][$patho_key_2] )) {
						$specimen_review[$studied_voa_nbr][$patho_key_2] = array(
							'SpecimenReviewMaster' => array(
								'review_code' => $patho_key_2,
								'specimen_review_control_id' => $atim_controls['reviews_controls']['specimen_review_control_id']),
							'SpecimenReviewDetail' => array(
								'pathology_reviewer' => $patho_reviewer),
							'specimen_review_detail_tablename' => $atim_controls['reviews_controls']['specimen_review_detail_tablename'],
							'AliquotReviews' => array()
						);
					} 
					// Aliquot Review
					$aliquot_label = $new_line_data['Sample Identifier'];
					if(isset($specimen_review[$studied_voa_nbr][$patho_key_2]['AliquotReviews'][$aliquot_label])) die('ERR 8837228282');
					if(!in_array($new_line_data['Reviewed Grade'], array('Ungraded','Not Assessed',''))) die('ERR 38837833');
					$cellularity_subjective = $new_line_data['Cellularity Subjective'];
					$cellularity_subjective_notes = '';
					if($cellularity_subjective) {
						if(!preg_match('/^%{0,1}([0-9]{1,2})%{0,1}([\ -]{1,3}(.+)){0,1}$/', $new_line_data['Cellularity Subjective'], $matches)) die('ERR 773737373 '.$new_line_data['Cellularity Subjective']);
						$cellularity_subjective = $matches[1];
						if(isset($matches[3])) $cellularity_subjective_notes = $matches[3];
					}
					$specimen_review[$studied_voa_nbr][$patho_key_2]['AliquotReviews'][$aliquot_label] = array(
						'AliquotReviewMaster' => array('review_code' => 'n/a', 'aliquot_review_control_id' => $atim_controls['reviews_controls']['aliquot_review_control_id']),
						'AliquotReviewDetail' => array(
							'cellularity_assessor' => $new_line_data['Cellularity Assessor'],
							'cellularity_subjective_prct' => $cellularity_subjective,
							'reviewed_pathology' => $reviewed_pathology,
							'notes' => $cellularity_subjective_notes),
						'aliquot_review_detail_tablename' => $atim_controls['reviews_controls']['aliquot_review_detail_tablename']	
					);
					$specimen_review_from_aliquot_label[$aliquot_label] = array('key1' => $studied_voa_nbr, 'key2' => $patho_key_2);
			 	} else if(strlen($new_line_data['Cellularity Assessor'].$new_line_data['Cellularity Subjective'].$new_line_data['Reviewed Grade'].$new_line_data['Reviewed Pathology'].$new_line_data['Sample Identifier'])) {
			 			die('ERR 3872372837283');
		 		}
			}
		}
	}
	
	//===============================================================================================================
	// PARSE WORKSHEET : SpecimenRelease
	//===============================================================================================================
	
	$studied_voa_nbr = null;
	$released_aliquots = array();
	$worksheet_name = 'Specimen Release';
	$file_voa_nbr = null;
	foreach($xls_sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);		
			if($new_line_data['Sample Indentifier']) {	
				if($new_line_data['VOA Number']) $file_voa_nbr = $new_line_data['VOA Number'];
				$studied_voa_nbr = null;
				if(!preg_match('/^VOA0*([1-9][0-9]*)/', $new_line_data['Sample Indentifier'], $matches)) die('ERR 238728 73287232 ['.$new_line_data['Sample Indentifier'].']');
				$studied_voa_nbr = $matches[1];
				if(!$studied_voa_nbr) die('ERR 37372882372332');
				if($file_voa_nbr != $studied_voa_nbr)  {
pr("1-str_replace($studied_voa_nbr, $file_voa_nbr, ".$new_line_data['Sample Indentifier'].")");
					$new_identifier = str_replace($studied_voa_nbr, $file_voa_nbr, $new_line_data['Sample Indentifier']);
					$summary_msg['Specimen Release']['@@ERROR@@']["Voa Number and Sample Indentifier mismatch"][] = "Voa $file_voa_nbr does not match the sample Identifier voa ".$new_line_data['Sample Indentifier'].". Will change sample Identifier to $new_identifier. Please check. [Worksheet $worksheet_name / line: $excel_line_counter]";
					$new_line_data['Sample Indentifier'] = $new_identifier;
					$studied_voa_nbr = $file_voa_nbr;
				}
				$aliquot_label = $new_line_data['Sample Indentifier'];
				if(!isset($released_aliquots[$studied_voa_nbr][$aliquot_label])) {
					$new_line_data['Date'] = str_replace('?', '', $new_line_data['Date']);
					$release_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date', $excel_line_counter);
					if(is_null($release_data)) $release_data = array();
					$release_data['requestor'] = $new_line_data['Requestor'];
					foreach(array('Section Thickness','Number of Sections','Volume') as $field) {
						$new_line_data[$field] = str_replace('?', '', $new_line_data[$field]);
						if(!preg_match('/^[0-9]*$/', $new_line_data[$field]))die('ERR 838298934743 '.$field.' '.v);
					}
					$release_data['ovcare_tissue_section_thickness'] = $new_line_data['Section Thickness'];
					$release_data['ovcare_tissue_section_numbers'] = $new_line_data['Number of Sections'];
					$release_data['used_volume'] = $new_line_data['Volume'];
					$released_aliquots[$studied_voa_nbr][$aliquot_label] = $release_data;
				} else {
					$summary_msg['Specimen Release']['@@ERROR@@']["Aliquot released twice"][] = "Aliquot $aliquot_label has been defined as released twice in Worksheet $worksheet_name. To create manually. [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
			} else if(strlen($new_line_data['Date'].$new_line_data['Requestor'].$new_line_data['Volume'].$new_line_data['Section Thickness'].$new_line_data['Number of Sections'])) {
				die('ERR 388738384 '.$excel_line_counter);
			}
		}
	}
	
	//===============================================================================================================
	// PARSE WORKSHEET : SpecimenAccural
	//===============================================================================================================		
				
	$comments_used_to_define_released_aliquots = array();
	$comments_used_to_define_not_banked_aliquots = array();

	$previous_voa_nbr = null;
	$collection_data = array();
	$tmp_sample_code = 0;
	$aliquot_master_id = 0;
	$worksheet_name = 'Specimen Accrual';
	$file_voa_nbr = null;
	foreach($xls_sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			//Get File Data to migrate
			if($new_line_data['VOA Number']) $file_voa_nbr = $new_line_data['VOA Number'];
			if($new_line_data['Sample Identifier']) {
				$studied_voa_nbr = null;
				if(preg_match('/^VOA0*([1-9][0-9]*)/', $new_line_data['Sample Identifier'], $matches)) {
					$studied_voa_nbr = $matches[1];
				} else if(preg_match('/^0*([1-9][0-9]*)/', $new_line_data['Sample Identifier'], $matches)) {
					$studied_voa_nbr = $matches[1];
					$new_line_data['Sample Identifier'] = 'VOA'.$new_line_data['Sample Identifier'];
				} else {
					die('ERR 238728 73287233 ['.$new_line_data['Sample Identifier'].']');
				}
				if($studied_voa_nbr != $file_voa_nbr) {
pr("2-str_replace($studied_voa_nbr, $file_voa_nbr, ".$new_line_data['Sample Identifier'].")");					
					$new_identifier = str_replace($studied_voa_nbr, $file_voa_nbr, $new_line_data['Sample Identifier']);
					$summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Voa Number and Sample Indentifier mismatch"][] = "Voa $file_voa_nbr does not match the sample Identifier voa ".$new_line_data['Sample Identifier'].". Will change sample Identifier to $new_identifier. Please check. [Worksheet $worksheet_name / line: $excel_line_counter]";
					$new_line_data['Sample Identifier'] = $new_identifier;
					$studied_voa_nbr = $file_voa_nbr;
				}
				if(is_null($previous_voa_nbr) || $studied_voa_nbr != $previous_voa_nbr) {
					//New Voa
					if(!is_null($previous_voa_nbr)) recordSamplesAndAliquots($collection_data, $previous_voa_nbr, $voas_to_collection_ids, $aliquot_label_to_storage_data);
					$collection_data = array('samples' => array(), 'notes' => array());
					$previous_voa_nbr = $studied_voa_nbr;
				}
				$file_specimen_type = $new_line_data['Specimen Type'];
				$file_aliquot_label = $new_line_data['Sample Identifier'];
				$file_anatomic_location = str_replace(array("\n", 'N/A', '?'), array('','',''), $new_line_data['Anatomic Location']);
				$file_ischemia_time = str_replace('?', '', $new_line_data['Ischaemia Time']);
				$file_comments = $new_line_data['Comments'];
				$file_aliquot_released = $new_line_data['Released'];
				if(!$file_specimen_type) {
					//No specimen type => Nothing will be imported excepted notes added to collection notes
					if($file_comments) $collection_data['notes'][] = $file_comments;
					if($file_aliquot_label) $summary_msg['InventoryManagement Specimen']['@@WARNING@@']["No Specimen Type but a Sample Identifier exists: No aliquot will be created"][] = "See aliquot '".$new_line_data['Sample Identifier']."'. [Worksheet $worksheet_name / line: $excel_line_counter]";
					if($file_anatomic_location) $summary_msg['InventoryManagement Specimen']['@@WARNING@@']["No Specimen Type but a Sample Anatomic Location: No aliquot will be created"][] = "$file_anatomic_location... [Worksheet $worksheet_name / line: $excel_line_counter]";
				} else {
					//Create new aliquot
					if(!$file_aliquot_label) {
						$file_aliquot_label = $studied_voa_nbr.' #?#';
					} else {
						if(!preg_match('/'.$studied_voa_nbr.'/', $file_aliquot_label)) $summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Voa Nbr and aliquot label error"][] = "The $file_aliquot_label does not match the Voa# $studied_voa_nbr. [Worksheet $worksheet_name / line: $excel_line_counter]";
					}
					$aliquot_master_id++;
					$in_stock = 'yes - available';
					$realeased = false;
					//Define aliquot released or not
					$relase_precision = null;
					if($file_aliquot_released == 'Yes') {
						$realeased = true;
						$in_stock = 'no';
					} else if(preg_match('/(([Tt]o|[Ff]or).{1,10}([Gg]ilks|[Nn]elson|[Pp]ress|[Cc]lara|[Ss]teve))|(^[Ff]or\ )|(^[Gg]iven)/', $file_comments, $matches)) {
						$realeased = true;
						$in_stock = 'no';
						$relase_precision = $matches['3'];
						$comments_used_to_define_released_aliquots[$file_comments][] = $excel_line_counter;
					} else if(preg_match('/(([Nn]ot\ +in\ +bank)|([Mm][Ii]ssing)|([Nn]ot banked)|(^[Nn]ot frozen)|(^[Nn]o frozen vials)|(^lost vial))/', $file_comments)) {
						$in_stock = 'no';
						$comments_used_to_define_not_banked_aliquots[$file_comments][] = $excel_line_counter;
					}
					//Manage QC & Internal Uses
					$aliquot_internal_uses = array();
					if(isset($released_aliquots[$studied_voa_nbr]) && isset($released_aliquots[$studied_voa_nbr][$file_aliquot_label])) {
						$in_stock = 'no';			
						$aliquot_internal_uses['aliquot_master_id'] = $aliquot_master_id;
						$aliquot_internal_uses['use_code'] = 'To '.($released_aliquots[$studied_voa_nbr][$file_aliquot_label]['requestor']? $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['requestor'] : '?');
						$aliquot_internal_uses['type'] = 'release';
						$aliquot_internal_uses['use_datetime'] = '';
						$aliquot_internal_uses['use_datetime_accuracy'] = '';
						if(isset($released_aliquots[$studied_voa_nbr][$file_aliquot_label]['date'])) {
							$aliquot_internal_uses['use_datetime'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['date'];
							$aliquot_internal_uses['use_datetime_accuracy'] = ($released_aliquots[$studied_voa_nbr][$file_aliquot_label]['accuracy'] == 'c')? 'h' : $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['accuracy'];				
						}
						$aliquot_internal_uses['ovcare_tissue_section_thickness'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['ovcare_tissue_section_thickness'];
						$aliquot_internal_uses['ovcare_tissue_section_numbers'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['ovcare_tissue_section_numbers'];	
						$aliquot_internal_uses['used_volume'] = $released_aliquots[$studied_voa_nbr][$file_aliquot_label]['used_volume'];
						unset($released_aliquots[$studied_voa_nbr][$file_aliquot_label]);
						if(empty($released_aliquots[$studied_voa_nbr])) unset($released_aliquots[$studied_voa_nbr]);
						if($realeased) $summary_msg['InventoryManagement Specimen']['@@MESSAGE@@']["Sample was both defined as released in Specimen Accrual and Specimen Release"][] = "See $file_aliquot_label. Will just use information of Specimen Release worksheet. Please check no additional release has to be migrated. [Worksheet $worksheet_name / line: $excel_line_counter]";
					} else if($realeased) {
						$in_stock = 'no';
						$aliquot_internal_uses['aliquot_master_id'] = $aliquot_master_id;
						$aliquot_internal_uses['use_code'] = 'To '.($relase_precision? $relase_precision : '?');
						$aliquot_internal_uses['type'] = 'release';
						$aliquot_internal_uses['use_details'] = $file_comments;	
						$aliquot_internal_uses['used_volume'] = null;
					}
					// Gett additional info
					if(!preg_match('/^[0-9]*$/', $file_ischemia_time))die('ERR 38833728 79823 ');
					//Add samples
					switch($file_specimen_type) {
						case 'FFPE - Tumour':
						case 'FFPE - Normal':
						case 'MolFix':
						case 'MolFix - Tumour':
						case 'MolFix - Normal':
						case 'Frozen - Tumour':
						case 'Frozen - Normal':
							$tissue_source = 'other';
							$tissue_laterality = '';
							if(!isset($tissue_matches[strtolower($file_anatomic_location)])) {
								if($file_anatomic_location) {
									$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Tissue Anatomic Location Unsupported"][] = "Tissue anatomic location [$file_anatomic_location] is not supported. [Worksheet $worksheet_name / line: $excel_line_counter]";
									$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Tissue Anatomic Location Unsupported (distinct list)"][$file_anatomic_location] = "Tissue anatomic location [$file_anatomic_location] is not supported.";
								}
							} else {
								$tissue_source = $tissue_matches[strtolower($file_anatomic_location)]['source'];
								$tissue_laterality = $tissue_matches[strtolower($file_anatomic_location)]['laterality'];
							}
							$tissue_nature = preg_match('/Tumour/', $file_specimen_type)? 'tumour' : (preg_match('/Normal/', $file_specimen_type)? 'normal': '');
							if($tissue_nature != 'tumour' &&  preg_match('/[Tt]umo[u]{0,1]r/',$file_anatomic_location )) {
								$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Tissue Nature Mismatch"][] = "Tissue nature is defined as $tissue_nature in tissue specimen type but as tumour in anatomic location. [Worksheet $worksheet_name / line: $excel_line_counter]";
							}
							$ovcare_tissue_source_precision = '';
							$aliquot_notes = $file_comments? array($file_comments) : array();
							$sample_notes = '';
							if($file_anatomic_location) {
								if(preg_match('/(.+)\ ([#]{0,1}[0-9])$/', $file_anatomic_location, $matches)) {
									$ovcare_tissue_source_precision = $matches[1];
									$sample_notes = $file_anatomic_location;
								} else {
									$ovcare_tissue_source_precision = $file_anatomic_location;
								}
							}
							$tmp_specimen_key = md5($tissue_source.$file_anatomic_location.$tissue_laterality.$tissue_nature.$file_ischemia_time);
							if(!isset($collection_data['samples'][$tmp_specimen_key])) {
								//Create sample
								$tmp_sample_code++;
								$collection_data['samples'][$tmp_specimen_key] = array(
									'SampleMaster' => array(									
										'sample_code' => 'tmp'.$tmp_sample_code,
										'sample_control_id' => $atim_controls['sample_aliquot_controls']['tissue']['sample_control_id'],
										'initial_specimen_sample_type' => 'tissue',
										'notes' => $sample_notes),
									'SpecimenDetail' => array(),
									'SampleDetail' => array(
										'tissue_source' => $tissue_source,
										'ovcare_tissue_source_precision' => $ovcare_tissue_source_precision,
										'tissue_laterality' => $tissue_laterality,
										'ovcare_tissue_type' => $tissue_nature,
										'ovcare_ischemia_time_mn' => $file_ischemia_time),
									'detail_tablename' => $atim_controls['sample_aliquot_controls']['tissue']['detail_tablename'],
									'Aliquots' => array(),
									'Derivatives' => array(),
									'SpecimenReviews' => array()
								);
							}	
							//Create aliquot
							$aliquot_type = 'tube';
							$aliquot_details = array();
							if(!preg_match('/^Frozen/', $file_specimen_type)) {
								$aliquot_type = 'block';
								$aliquot_details['block_type'] = 'paraffin';
							}
							if($aliquot_internal_uses && strlen($aliquot_internal_uses['used_volume'])) {
								if($aliquot_internal_uses['used_volume'] == '0') {
									$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Tissue Volume Released'][] = "A released volume equal to 0 is associated to a tissue. No volume will be migrated. See aliquot $file_aliquot_label. [Worksheet $worksheet_name / line: $excel_line_counter]";
								} else {
									$summary_msg['InventoryManagement Specimen']['@@ERROR@@']['Tissue Volume Released'][] = "A released volume is associated to a tissue. No volume will be migrated. See aliquot $file_aliquot_label volume = '".$aliquot_internal_uses['used_volume']."'. [Worksheet $worksheet_name / line: $excel_line_counter]";
								}
								unset($aliquot_internal_uses['used_volume']);
							}
							$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id] = array(
								'AliquotMaster' => array(
									'id' => $aliquot_master_id,
									'barcode' => $aliquot_master_id,
									'aliquot_label' => $file_aliquot_label,
									'aliquot_control_id' => $atim_controls['sample_aliquot_controls']['tissue']['aliquots'][$aliquot_type]['aliquot_control_id'],
									'in_stock' => $in_stock,							
									'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
									'notes' => implode(' & ', $aliquot_notes)),
								'AliquotDetail' => array_merge(array('aliquot_master_id' => $aliquot_master_id), $aliquot_details),
								'detail_tablename' => $atim_controls['sample_aliquot_controls']['tissue']['aliquots'][$aliquot_type]['detail_tablename'],					
								'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
							//Add specimen Review
							if(isset($specimen_review_from_aliquot_label[$file_aliquot_label])) {
								$specimen_review_key2 = $specimen_review_from_aliquot_label[$file_aliquot_label]['key2'];
								if($studied_voa_nbr != $specimen_review_from_aliquot_label[$file_aliquot_label]['key1']) die('ERR88339ddsdds938 '.$excel_line_counter);
								if(!isset($specimen_review[$studied_voa_nbr][$specimen_review_key2]['AliquotReviews'][$file_aliquot_label])) die('ERR88339ddsdds938 '.$excel_line_counter);
								if(!isset($collection_data['samples'][$tmp_specimen_key]['SpecimenReviews'][$specimen_review_key2])) $collection_data['samples'][$tmp_specimen_key]['SpecimenReviews'][$specimen_review_key2] = $specimen_review[$studied_voa_nbr][$specimen_review_key2];
								$collection_data['samples'][$tmp_specimen_key]['SpecimenReviews'][$specimen_review_key2]['AliquotReviews'][$file_aliquot_label]['AliquotReviewMaster']['aliquot_master_id'] = $aliquot_master_id;
								$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id]['AliquotMaster']['use_counter']++;
								unset($specimen_review_from_aliquot_label[$file_aliquot_label]);
							}					
							break;
	
						case 'Cell Block':
						case 'Cryostasis':
							$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["Specimen Type not supported: No aliquot created"][] = "Specimen Type $file_specimen_type is not supported. No aloquot will be created. [Worksheet $worksheet_name / line: $excel_line_counter]";
							break;
		
						case 'Ascites':
//TODO Is it ascite or ascite celles							
							if($file_anatomic_location && !in_array($file_anatomic_location, array('Abdominal','Pelvic-Abdominal'))) $summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Specimen Type & Anatomic Location Mismatch"][] = "Specimen Type [$file_specimen_type] and anatomic location [$file_anatomic_location] does not match. Please correct. [Worksheet $worksheet_name / line: $excel_line_counter]";
							$aliquot_notes = $file_comments? array($file_comments) : array();
							$tmp_specimen_key = md5('Ascites'.$file_ischemia_time);
							if(!isset($collection_data['samples'][$tmp_specimen_key])) {
								//Create sample
								$tmp_sample_code++;
								$collection_data['samples'][$tmp_specimen_key] = array(
									'SampleMaster' => array(
										'sample_code' => 'tmp'.$tmp_sample_code,
										'sample_control_id' => $atim_controls['sample_aliquot_controls']['ascite']['sample_control_id'],
										'initial_specimen_sample_type' => 'ascite'),
									'SpecimenDetail' => array(),
									'SampleDetail' => array(
										'ovcare_ischemia_time_mn' => $file_ischemia_time),
									'detail_tablename' => $atim_controls['sample_aliquot_controls']['ascite']['detail_tablename'],
									'Aliquots' => array(),
									'Derivatives' => array());
							}
							//Create aliquot
							$aliquot_type = 'tube';
							$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id] = array(
								'AliquotMaster' => array(
									'id' => $aliquot_master_id,
									'barcode' => $aliquot_master_id,
									'aliquot_label' => $file_aliquot_label,
									'aliquot_control_id' => $atim_controls['sample_aliquot_controls']['ascite']['aliquots']['tube']['aliquot_control_id'],
									'in_stock' => $in_stock,
									'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
									'notes' => implode(' & ', $aliquot_notes)),
								'AliquotDetail' => array('aliquot_master_id' => $aliquot_master_id),
								'detail_tablename' => $atim_controls['sample_aliquot_controls']['ascite']['aliquots']['tube']['detail_tablename'],
								'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
							break;
								
						case 'Frozen - Buffy Coat':
						case 'Frozen - Serum':
						case 'Frozen - Plasma':
							if($file_anatomic_location && $file_anatomic_location != 'Blood') $summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Specimen Type & Anatomic Location Mismatch"][] = "Specimen Type [$file_specimen_type] and anatomic location [$file_anatomic_location] does not match. Please correct. [Worksheet $worksheet_name / line: $excel_line_counter]";
							$aliquot_notes = $file_comments? array($file_comments) : array();
							$tmp_specimen_key = md5(($file_specimen_type == 'Frozen - Serum'? 'blood1' : 'blood2').$file_ischemia_time);
							if(!isset($collection_data['samples'][$tmp_specimen_key])) {
								//Create sample
								$tmp_sample_code++;
								$collection_data['samples'][$tmp_specimen_key] = array(
									'SampleMaster' => array(
										'sample_code' => 'tmp'.$tmp_sample_code,
										'sample_control_id' => $atim_controls['sample_aliquot_controls']['blood']['sample_control_id'],
										'initial_specimen_sample_type' => 'blood'),
									'SpecimenDetail' => array(),
									'SampleDetail' => array(
										'ovcare_ischemia_time_mn' => $file_ischemia_time),
									'detail_tablename' => $atim_controls['sample_aliquot_controls']['blood']['detail_tablename'],
									'Aliquots' => array(),
									'Derivatives' => array()
								);
							}
							$derivative_type = str_replace(array('Frozen - Serum', 'Frozen - Buffy Coat','Frozen - Plasma'), array('serum', 'blood cell', 'plasma'), $file_specimen_type);
							if(!isset($collection_data['samples'][$tmp_specimen_key]['Derivatives'][$derivative_type] )) {
								$tmp_sample_code++;
								$collection_data['samples'][$tmp_specimen_key]['Derivatives'][$derivative_type] = array(
									'SampleMaster' => array(
										'sample_code' => 'tmp'.$tmp_sample_code,
										'sample_control_id' => $atim_controls['sample_aliquot_controls'][$derivative_type]['sample_control_id'],
										'initial_specimen_sample_type' => 'blood',
										'parent_sample_type' => 'blood'),
									'DerivativeDetail' => array(),
									'SampleDetail' => array(),
									'detail_tablename' => $atim_controls['sample_aliquot_controls'][$derivative_type]['detail_tablename'],
									'Aliquots' => array()
								);
							}
							//Create aliquot			
							$aliquot_type = 'tube';					
							$collection_data['samples'][$tmp_specimen_key]['Derivatives'][$derivative_type]['Aliquots'][$aliquot_master_id] = array(
								'AliquotMaster' => array(
									'id' => $aliquot_master_id,
									'barcode' => $aliquot_master_id,
									'aliquot_label' => $file_aliquot_label,
									'aliquot_control_id' => $atim_controls['sample_aliquot_controls'][$derivative_type]['aliquots']['tube']['aliquot_control_id'],
									'in_stock' => $in_stock,
									'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
									'notes' => implode(' & ', $aliquot_notes)),
								'AliquotDetail' => array('aliquot_master_id' => $aliquot_master_id),
								'detail_tablename' => $atim_controls['sample_aliquot_controls'][$derivative_type]['aliquots']['tube']['detail_tablename'],
								'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
							break;
							
						case 'Frozen - Saliva':
							if($file_anatomic_location && $file_anatomic_location != 'Saliva') $summary_msg['InventoryManagement Specimen']['@@ERROR@@']["Specimen Type & Anatomic Location Mismatch"][] = "Specimen Type [$file_specimen_type] and anatomic location [$file_anatomic_location] does not match. Please correct. [Worksheet $worksheet_name / line: $excel_line_counter]";
							$aliquot_notes = $file_comments? array($file_comments) : array();
							$tmp_specimen_key = md5('Saliva'.$file_ischemia_time);
							if(!isset($collection_data['samples'][$tmp_specimen_key])) {
								//Create sample
								$tmp_sample_code++;
								$collection_data['samples'][$tmp_specimen_key] = array(
									'SampleMaster' => array(
										'sample_code' => 'tmp'.$tmp_sample_code,
										'sample_control_id' => $atim_controls['sample_aliquot_controls']['saliva']['sample_control_id'],
										'initial_specimen_sample_type' => 'saliva'),
									'SpecimenDetail' => array(),
									'SampleDetail' => array(
										'ovcare_ischemia_time_mn' => $file_ischemia_time),
									'detail_tablename' => $atim_controls['sample_aliquot_controls']['saliva']['detail_tablename'],
									'Aliquots' => array(),
									'Derivatives' => array());
							}
							//Create aliquot
							$aliquot_type = 'tube';
							$collection_data['samples'][$tmp_specimen_key]['Aliquots'][$aliquot_master_id] = array(
								'AliquotMaster' => array(
									'id' => $aliquot_master_id,
									'barcode' => $aliquot_master_id,
									'aliquot_label' => $file_aliquot_label,
									'aliquot_control_id' => $atim_controls['sample_aliquot_controls']['saliva']['aliquots']['tube']['aliquot_control_id'],
									'in_stock' => $in_stock,
									'use_counter' => (empty($aliquot_internal_uses)? '0' : 1),
									'notes' => implode(' & ', $aliquot_notes)),
								'AliquotDetail' => array('aliquot_master_id' => $aliquot_master_id),
								'detail_tablename' => $atim_controls['sample_aliquot_controls']['saliva']['aliquots']['tube']['detail_tablename'],
								'InternalUses' => $aliquot_internal_uses); //aliquot_internal_uses
							break;
		
						default:
							die('ERR 34837227368268232 '.$file_specimen_type);				
					}
				}
			} else {
				if($new_line_data['Specimen Type']) {
					$summary_msg['InventoryManagement Specimen']['@@WARNING@@']["No Sample Identifier but a Sample Type is set: No aliquot will be created"][] = $new_line_data['Specimen Type']."... [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
				if($new_line_data['Comments'] && !empty($collection_data)) {
					$collection_data['notes'][] = $new_line_data['Comments'];
				}
			}
		} 
	}
	if(!is_null($previous_voa_nbr)) recordSamplesAndAliquots($collection_data, $previous_voa_nbr, $voas_to_collection_ids, $aliquot_label_to_storage_data);

	// add migration summaries / results
	foreach($voas_to_collection_ids as $voa => $tmp) {
		$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['No Voa collection data in Specimen Accrual'][] = "The voa $voa defined in other worksheet is not defined into specimen accural worksheet. No collection will be created for them." ;
	}
	foreach($specimen_review_from_aliquot_label as $aliquot_label => $data) $summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Specimen Quality Control Un-migrated'][] = 'see Sample Indentifier'.$aliquot_label;
	foreach($released_aliquots as $voa_nbr => $data1) {
		foreach($data1 as $aliquot_label => $data2) $summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Released specimen not found'][] = "The specimen '.$aliquot_label' has been defined as released in Specimen Release worksheet but this specimen has not been found in Specimen Accural worksheet. This release information won't be imported.";
	}
	foreach($aliquot_label_to_storage_data as $aliquot_label => $aliquot_data) {
		$summary_msg['InventoryManagement Specimen']['@@WARNING@@']['Stored Aliquot not found in Specimen Accural'][] = "The aliquot $aliquot_label defined as stored in box ".$aliquot_data['box_name']." at position ".$aliquot_data['storage_coord_x']." has not been found into specimen accural worksheet. No position data will be migrated." ;
	}
	foreach($comments_used_to_define_released_aliquots as $comment => $lines)
		$summary_msg['InventoryManagement Specimen']['@@MESSAGE@@']['Specimen defined as realeased based on comment: Here is the list of comments for control'][] = "$comment'. See lines ".implode(', ', $lines);
	foreach($comments_used_to_define_not_banked_aliquots as $comment => $lines)
		$summary_msg['InventoryManagement Specimen']['@@MESSAGE@@']['Specimen defined as not banked based on comment: Here is the list of comments for control'][] = "$comment'. See lines ".implode(', ', $lines);
	
	return;
}	
	
function recordSamplesAndAliquots($collection_data, $voa, &$voas_to_collection_ids, &$aliquot_label_to_storage_data) {
	global $summary_msg;
	global $db_connection;
	
	if(!isset($voas_to_collection_ids[$voa])) die('ERR 4747387432 '.$voa);
	$collection_id = $voas_to_collection_ids[$voa];
	unset($voas_to_collection_ids[$voa]);

	if($collection_data['notes']) {
		$query = "UPDATE collections SET collection_notes = '".str_replace("'", "''", implode(' & ', $collection_data['notes']))."' WHERE id = $collection_id;";
		mysqli_query($db_connection, $query) or die("record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		mysqli_query($db_connection, str_replace('collections','collections_revs',$query)) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	}
	
	//Add samples
	foreach($collection_data['samples'] as $new_specimen_and_derivatives) {	
		//New specimen		
		$specimen_sample_master_id = customInsertRecord(array_merge($new_specimen_and_derivatives['SampleMaster'], array('collection_id' => $collection_id)), 'sample_masters');
		customInsertRecord(array_merge($new_specimen_and_derivatives['SampleDetail'], array('sample_master_id' => $specimen_sample_master_id)), $new_specimen_and_derivatives['detail_tablename'], true);
		customInsertRecord(array_merge($new_specimen_and_derivatives['SpecimenDetail'], array('sample_master_id' => $specimen_sample_master_id)), 'specimen_details', true);
		recordAliquots($new_specimen_and_derivatives['Aliquots'], $collection_id, $specimen_sample_master_id, $aliquot_label_to_storage_data);
		//Specimen Review
		if(isset($new_specimen_and_derivatives['SpecimenReviews'])) {		
			foreach($new_specimen_and_derivatives['SpecimenReviews'] as $specimen_review) {
				$specimen_review_master_id = customInsertRecord(array_merge($specimen_review['SpecimenReviewMaster'], array('collection_id' => $collection_id, 'sample_master_id' => $specimen_sample_master_id)), 'specimen_review_masters');
				customInsertRecord(array_merge($specimen_review['SpecimenReviewDetail'], array('specimen_review_master_id' => $specimen_review_master_id)), $specimen_review['specimen_review_detail_tablename'], true);
				foreach($specimen_review['AliquotReviews'] as $aliquot_review) {
					if(isset($aliquot_review['AliquotReviewMaster']['aliquot_master_id']) && $aliquot_review['AliquotReviewMaster']['aliquot_master_id']) {
						$aliquot_review_master_id = customInsertRecord(array_merge($aliquot_review['AliquotReviewMaster'], array('specimen_review_master_id' => $specimen_review_master_id)), 'aliquot_review_masters');
						customInsertRecord(array_merge($aliquot_review['AliquotReviewDetail'], array('aliquot_review_master_id' => $aliquot_review_master_id)), $aliquot_review['aliquot_review_detail_tablename'], true);
					}
				}
			}
		}
		//Derivatives
		foreach($new_specimen_and_derivatives['Derivatives'] as $new_derivative) {
			$derivative_sample_master_id = customInsertRecord(array_merge($new_derivative['SampleMaster'], array('collection_id' => $collection_id, 'parent_id' => $specimen_sample_master_id, 'initial_specimen_sample_id' => $specimen_sample_master_id)), 'sample_masters');
			customInsertRecord(array_merge($new_derivative['SampleDetail'], array('sample_master_id' => $derivative_sample_master_id)), $new_derivative['detail_tablename'], true);
			customInsertRecord(array_merge($new_derivative['DerivativeDetail'], array('sample_master_id' => $derivative_sample_master_id)), 'derivative_details', true);
			recordAliquots($new_derivative['Aliquots'], $collection_id, $derivative_sample_master_id, $aliquot_label_to_storage_data);
		}
	}
}

function recordAliquots($aliquots, $collection_id, $sample_master_id, &$aliquot_label_to_storage_data) {
	global $summary_msg;
	foreach($aliquots as $new_aliquot) {
		$aliquot_label = $new_aliquot['AliquotMaster']['aliquot_label'];
		if(isset($aliquot_label_to_storage_data[$aliquot_label])) {
			if($new_aliquot['AliquotMaster']['in_stock'] == 'no') {
				$summary_msg['InventoryManagement Specimen']['@@ERROR@@']['Aliquot Position for an aliquot not in stock'][] = "The aliquot $aliquot_label was defined as stored in box ".$aliquot_label_to_storage_data[$aliquot_label]['box_name']." at position ".$aliquot_label_to_storage_data[$aliquot_label]['storage_coord_x']." but the aliquot was defined as not in stock by the migration process (cause released, etc). No storage data will be migrated.";
			} else {
				$new_aliquot['AliquotMaster']['storage_master_id'] = $aliquot_label_to_storage_data[$aliquot_label]['storage_master_id'];
				$new_aliquot['AliquotMaster']['storage_coord_x'] = $aliquot_label_to_storage_data[$aliquot_label]['storage_coord_x'];
				$new_aliquot['AliquotMaster']['storage_datetime'] = $aliquot_label_to_storage_data[$aliquot_label]['storage_datetime'];
				$new_aliquot['AliquotMaster']['storage_datetime_accuracy'] = $aliquot_label_to_storage_data[$aliquot_label]['storage_datetime_accuracy'];
			}
			unset($aliquot_label_to_storage_data[$aliquot_label]);
		}
		$aliquot_master_id = $new_aliquot['AliquotMaster']['id'];
		$aliquot_master_id = customInsertRecord(array_merge($new_aliquot['AliquotMaster'], array('collection_id' => $collection_id, 'sample_master_id' => $sample_master_id)), 'aliquot_masters', false);
		customInsertRecord(array_merge($new_aliquot['AliquotDetail'], array('aliquot_master_id' => $aliquot_master_id)), $new_aliquot['detail_tablename'], true);
		if(!empty($new_aliquot['InternalUses'])) {
			customInsertRecord($new_aliquot['InternalUses'], 'aliquot_internal_uses');
		}
	}
}

function getTissueMatches() {
//TODO review per ying	
	$tissue_matches = array(
		'Abdominal mass' => array('source' => 'abdominal mass', 'laterality' => ''),
		'Abdominal Wall' => array('source' => 'abdominal wall', 'laterality' => ''),
		'Abdominal wall tumour' => array('source' => 'abdominal wall', 'laterality' => ''),
		'Adnexa' => array('source' => 'adnexal', 'laterality' => ''),
		'Adnexal Mass' => array('source' => 'adnexal', 'laterality' => ''),
		'Anterior Vulva' => array('source' => 'vulva', 'laterality' => ''),
		'Anus' => array('source' => 'anus', 'laterality' => ''),
		'Appendix' => array('source' => 'appendix', 'laterality' => ''),
		'Bilateral Tube' => array('source' => 'fallopian tube', 'laterality' => 'bilateral'),
		'Bladder' => array('source' => 'bladder', 'laterality' => ''),
		'Bladder-peritoeum' => array('source' => 'mix', 'laterality' => ''),
		'Brain' => array('source' => 'brain', 'laterality' => ''),
		'Cervis' => array('source' => 'uterine cervix', 'laterality' => ''),
		'Cervix' => array('source' => 'uterine cervix', 'laterality' => ''),
		'Colon' => array('source' => 'colon', 'laterality' => ''),
		'Cul de sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'cul-de-sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'cystic mass' => array('source' => 'other', 'laterality' => ''),
		'Dermoid cyst' => array('source' => 'other', 'laterality' => ''),
		'Descending colon' => array('source' => 'colon', 'laterality' => ''),
		'Distal rectal sigmoid tumour' => array('source' => 'other', 'laterality' => ''),
		'Endometrial' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrial mass' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrial Polyp' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrial polypoid tumour' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium #3' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium (polypoid)' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium (polypoid)' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 1' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 2' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium 4' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium cavity' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium Myomentum' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium Polyploid Nodule' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium Polyploid Nodule' => array('source' => 'endometrium', 'laterality' => ''),
		'Fallopian Tube NOS' => array('source' => 'fallopian tube', 'laterality' => ''),
		'Fimbrial Mass' => array('source' => 'other', 'laterality' => ''),
		'Granulosa Cell Tumor' => array('source' => 'other', 'laterality' => ''),
		'Granulosa Cell Tumour' => array('source' => 'other', 'laterality' => ''),
		'Hernia sac' => array('source' => 'hernia sac', 'laterality' => ''),
		'Hernia sac' => array('source' => 'hernia sac', 'laterality' => ''),
		'Large Bowel' => array('source' => 'other', 'laterality' => ''),
		'Larger ovary' => array('source' => 'ovary', 'laterality' => ''),
		'Left (LSO) nodule' => array('source' => 'other', 'laterality' => 'left'),
		'Left Adnexa' => array('source' => 'adnexal', 'laterality' => 'left'),
		'Left Adnexal' => array('source' => 'adnexal', 'laterality' => 'left'),
		'Left External Iliac Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left external iliac node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left Fallopian Tube' => array('source' => 'fallopian tube', 'laterality' => 'left'),
		'Left Fallopian Tube + Left Ovary' => array('source' => 'mix', 'laterality' => 'left'),
		'Left Fallopian Tube fimbria' => array('source' => 'fallopian tube', 'laterality' => 'left'),
		'Left Fimbria' => array('source' => 'other', 'laterality' => 'left'),
		'Left Iliac Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left labia' => array('source' => 'other', 'laterality' => 'left'),
		'Left Lower Quadrant' => array('source' => 'other', 'laterality' => 'left'),
		'Left Ovarian Mass' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary + Tube' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary 1' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary 1' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary 2' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary 2' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left Ovary/Tube' => array('source' => 'mix', 'laterality' => 'left'),
		'Left Para-Aortic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'left Paratubrae mass' => array('source' => 'other', 'laterality' => 'left'),
		'Left pelvic L. node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left Pelvic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left Pelvic Node' => array('source' => 'other', 'laterality' => 'left'),
		'Left Pelvic Sidewall' => array('source' => 'other', 'laterality' => 'left'),
		'Left retroperitoneal mass' => array('source' => 'other', 'laterality' => 'left'),
		'Left Uretecic Nodule' => array('source' => 'other', 'laterality' => 'left'),
		'Left Uterosacral' => array('source' => 'other', 'laterality' => 'left'),
		'Leiomyoma' => array('source' => 'other', 'laterality' => ''),
		'Lieomyoma' => array('source' => 'other', 'laterality' => ''),
		'Liver' => array('source' => 'liver', 'laterality' => ''),
		'Lt Ovary 3' => array('source' => 'ovary', 'laterality' => 'left'),
		'Lt ovary/tube' => array('source' => 'mix', 'laterality' => 'left'),
		'Lt ovary/tube' => array('source' => 'mix', 'laterality' => 'left'),
		'Mesentery Transverse Left Colon' => array('source' => 'colon', 'laterality' => 'left'),
		'middle pelvic tumour' => array('source' => 'other', 'laterality' => ''),
		'midline peri-urachal mass' => array('source' => 'other', 'laterality' => ''),
		'Myometrium' => array('source' => 'other', 'laterality' => ''),
		'nerve sheath tumour' => array('source' => 'other', 'laterality' => ''),
		'Nodes' => array('source' => 'other', 'laterality' => ''),
		'Nodes' => array('source' => 'other', 'laterality' => ''),
		'Nodule close to LSO' => array('source' => 'other', 'laterality' => ''),
		'Nodules' => array('source' => 'other', 'laterality' => ''),
		'Nodules ' => array('source' => 'other', 'laterality' => ''),
		'Normal Omentum' => array('source' => 'omentum', 'laterality' => ''),
		'Normal omentum 3' => array('source' => 'omentum', 'laterality' => ''),
		'Omental Nodule' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum #1' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum #2' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum #3' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum Bx' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum Bx #1' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum Bx' => array('source' => 'omentum', 'laterality' => ''),
		'Ovarian cyst' => array('source' => 'ovary', 'laterality' => ''),
		'Ovarian tumour (R)' => array('source' => 'ovary', 'laterality' => 'right'),
		'Ovary + Tube' => array('source' => 'mix', 'laterality' => ''),
		'Ovary + Tube NOS' => array('source' => 'mix', 'laterality' => ''),
		'Ovary NOS' => array('source' => 'ovary', 'laterality' => ''),
		'Para-aortic node' => array('source' => 'other', 'laterality' => ''),
		'Pelvic Mass' => array('source' => 'pelvic mass', 'laterality' => ''),
		'Pelvic Mass (left)' => array('source' => 'pelvic mass', 'laterality' => 'left'),
		'Pelvic Node' => array('source' => 'other', 'laterality' => ''),
		'Pelvic Side Wall' => array('source' => 'other', 'laterality' => ''),
		'Pelvic Tumour' => array('source' => 'other', 'laterality' => ''),
		'Pelvic-Abdominal' => array('source' => 'other', 'laterality' => ''),
		'Pelvic-Abdominal Sidewall' => array('source' => 'other', 'laterality' => ''),
		'Pelvis' => array('source' => 'other', 'laterality' => ''),
		'Peritoneal Nodule' => array('source' => 'peritoneum', 'laterality' => ''),
		'Peritoneal Tumor Wall' => array('source' => 'peritoneum', 'laterality' => ''),
		'Peritoneal Tumour' => array('source' => 'peritoneum', 'laterality' => ''),
		'Post Liver Tumour' => array('source' => 'other', 'laterality' => ''),
		'Posterior cul-de-sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'Recto sigmoid serosa' => array('source' => 'sigmoid', 'laterality' => ''),
		'Rectosigmoid' => array('source' => 'sigmoid', 'laterality' => ''),
		'Rectovagina' => array('source' => 'vagina', 'laterality' => ''),
		'retroperitoneal ' => array('source' => 'peritoneum', 'laterality' => ''),
		'Retroperitoneum' => array('source' => 'peritoneum', 'laterality' => ''),
		'Retrouterine' => array('source' => 'other', 'laterality' => ''),
		'Right Adnexal' => array('source' => 'adnexal', 'laterality' => ''),
		'Right Adnexal Mass' => array('source' => 'adnexal', 'laterality' => ''),
		'right and left ovary' => array('source' => 'ovary', 'laterality' => 'bilateral'),
		'Right Broad Ligament Fibroid' => array('source' => 'other', 'laterality' => 'right'),
		'Right Colon' => array('source' => 'colon', 'laterality' => 'right'),
		'Right Fallopian Tube' => array('source' => 'fallopian tube', 'laterality' => 'right'),
		'Right Fallopian Tube + Ovary' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Fallopian Tube + Right Ovary' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Flank' => array('source' => 'other', 'laterality' => 'right'),
		'Right Groin mass' => array('source' => 'other', 'laterality' => 'right'),
		'Right Inguinal Node' => array('source' => 'other', 'laterality' => 'right'),
		'Right Lower Quadrant' => array('source' => 'other', 'laterality' => 'right'),
		'Right Ovarian Cyst' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary + Right Tube' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Ovary + Tube' => array('source' => 'mix', 'laterality' => 'right'),
		'Right Ovary 3' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary 3' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Ovary 4' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right Paracolonic Gutter' => array('source' => 'other', 'laterality' => 'right'),
		'Right Pelvic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Right Pelvic Mass' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvic Node' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvic Ovary Mass' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvic Sidewall' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Pelvis' => array('source' => 'pelvis', 'laterality' => 'right'),
		'Right Retroperitonium' => array('source' => 'other', 'laterality' => 'right'),
		'Right Shoulder' => array('source' => 'other', 'laterality' => 'right'),
		'Right Uretecic Nodule' => array('source' => 'other', 'laterality' => 'right'),
		'Right uterosacral' => array('source' => 'uterus', 'laterality' => 'right'),
		'Right Utero-Sacral' => array('source' => 'uterus', 'laterality' => 'right'),
		'Right Uterus Node' => array('source' => 'uterus', 'laterality' => 'right'),
		'Rt ovary + tube #1' => array('source' => 'mix', 'laterality' => 'right'),
		'Rt ovary + tube #2' => array('source' => 'mix', 'laterality' => 'right'),
		'Rt Ovary 1' => array('source' => 'ovary', 'laterality' => 'right'),
		'Rt Ovary 2' => array('source' => 'ovary', 'laterality' => 'right'),
		'RT Pelvic Side wall' => array('source' => 'other', 'laterality' => 'right'),
		'Rt tube/Ovary #2' => array('source' => 'mix', 'laterality' => 'right'),
		'Rt tube/Ovary #3' => array('source' => 'mix', 'laterality' => 'right'),
		'Sigmoid Colon' => array('source' => 'colon', 'laterality' => ''),
		'Sigmoid Tumour' => array('source' => 'colon', 'laterality' => ''),
		'Small Bowel' => array('source' => 'small bowel', 'laterality' => ''),
		'Small Bowel Mesentary' => array('source' => 'small bowel', 'laterality' => ''),
		'Small bowel mesentary tumour' => array('source' => 'small bowel', 'laterality' => ''),
		'Small Bowel Tumour' => array('source' => 'small bowel', 'laterality' => ''),
		'Small Intestine' => array('source' => 'small intestine', 'laterality' => ''),
		'Smaller ovary' => array('source' => 'ovary', 'laterality' => ''),
		'Spetum' => array('source' => 'other', 'laterality' => ''),
		'Splenic Flexure Tumour' => array('source' => 'other', 'laterality' => ''),
		'Splenic Flexure TumourEndometrium' => array('source' => 'mix', 'laterality' => ''),
		'Stomach' => array('source' => 'stomach', 'laterality' => ''),
		'Transverse Colon' => array('source' => 'colon', 'laterality' => ''),
		'transverse mesentary, Right upper quadrant' => array('source' => 'other', 'laterality' => ''),
		'Tumour' => array('source' => 'other', 'laterality' => ''),
		'Tumour nodule' => array('source' => 'other', 'laterality' => ''),
		'Umbilical Mass' => array('source' => 'other', 'laterality' => ''),
		'Umbilicus Nodule' => array('source' => 'other', 'laterality' => ''),
		'Upper Abdomen' => array('source' => 'other', 'laterality' => ''),
		'Uterine Cavity' => array('source' => 'uterus', 'laterality' => ''),
		'Uterine Cervix' => array('source' => 'uterine cervix', 'laterality' => ''),
		'Uterine Fibroid' => array('source' => 'uterus', 'laterality' => ''),
		'Uterosacral Ligament' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus + Left Tube + Ovary' => array('source' => 'mix', 'laterality' => ''),
		'Uterus + Ovaries + Tubes' => array('source' => 'mix', 'laterality' => ''),
		'Uterus + Tubes + Ovaries' => array('source' => 'mix', 'laterality' => ''),
		'Uterus leiomyoma' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus malignant' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus Nodule' => array('source' => 'uterus', 'laterality' => ''),
		'Uterus/Endometrium' => array('source' => 'mix', 'laterality' => ''),
		'Vaginal' => array('source' => 'vagina', 'laterality' => ''),
		'Vulva' => array('source' => 'vulva', 'laterality' => ''),
			
		'Abdominal tumour' => array('source' => 'abdominal wall', 'laterality' => ''),
		'Abdominal tumour' => array('source' => 'abdominal wall', 'laterality' => ''),
		'Bladder Adhesion/Tumour' => array('source' => 'bladder', 'laterality' => ''),
		'Bladder peritoneum' => array('source' => 'bladder', 'laterality' => ''),
		'Bx cul-de-sac' => array('source' => 'cul-de-sac', 'laterality' => ''),
		'Bx of tumor on small bowel serosa' => array('source' => 'small intestine', 'laterality' => ''),
		'Cecum' => array('source' => 'cecum', 'laterality' => ''),
		'Cystic left ovary' => array('source' => 'ovary', 'laterality' => 'left'),
		'endometriod polyp' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium (polypoid mass)' => array('source' => 'endometrium', 'laterality' => ''),
		'Endometrium biopsy' => array('source' => 'endometrium', 'laterality' => ''),
		'Exterior left ovary' => array('source' => 'ovary', 'laterality' => 'left'),
		'Exterior right ovary' => array('source' => 'ovary', 'laterality' => 'right'),
		'Fallopian tube' => array('source' => 'fallopian tube', 'laterality' => ''),
		'Free floating tumor' => array('source' => 'other', 'laterality' => ''),
		'Free floating tumour' => array('source' => 'other', 'laterality' => ''),
		'intra-abdominal tumour' => array('source' => 'intra abdominal', 'laterality' => ''),
		'Intraperitoneal tumour' => array('source' => 'intraperitoneum', 'laterality' => ''),
		'Left adnexal mass' => array('source' => 'adnexal', 'laterality' => 'left'),
		'Left common iliac lymph node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Left ovarian cyst' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left ovary cyst' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left ovary mass' => array('source' => 'ovary', 'laterality' => 'left'),
		'Left pelvic mass' => array('source' => 'pelvis', 'laterality' => 'left'),
		'Left tube and fimbrae' => array('source' => 'fallopian tube and fimbraie', 'laterality' => 'left'),
		'Left upper omentum' => array('source' => 'omentum', 'laterality' => 'left'),
		'Left upper quad/mass' => array('source' => 'abdominal mass', 'laterality' => 'left'),
		'Left upper quadrant mass' => array('source' => 'abdominal mass', 'laterality' => 'left'),
		'Left uterosacral ' => array('source' => 'uterosacrel', 'laterality' => 'left'),
		'Lt Node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'LT ovarian mass' => array('source' => 'ovary', 'laterality' => 'left'),
		'Mass from right pelvic sidewall' => array('source' => 'pelvic mass', 'laterality' => 'right'),
		'myoendometrium' => array('source' => 'endometrium', 'laterality' => ''),
		'Nodule by the left of endometrium' => array('source' => 'endometrium', 'laterality' => 'left'),
		'Normal Endometrium' => array('source' => 'endometrium', 'laterality' => ''),
		'normal fallopian tube' => array('source' => 'fallopian tube', 'laterality' => ''),
		'Omental biopsy' => array('source' => 'omentum', 'laterality' => ''),
		'Omental Bx' => array('source' => 'omentum', 'laterality' => ''),
		'Omental nodules' => array('source' => 'omentum', 'laterality' => ''),
		'Omental Tumour' => array('source' => 'omentum', 'laterality' => ''),
		'Omentectomy' => array('source' => 'omentum', 'laterality' => ''),
		'omentum adhesion' => array('source' => 'omentum', 'laterality' => ''),
		'Omentum biopsy' => array('source' => 'omentum', 'laterality' => ''),
		'Ovary' => array('source' => 'ovary', 'laterality' => ''),
		'Ovary/tube' => array('source' => 'ovary', 'laterality' => ''),
		'Para aortic lymph node' => array('source' => 'lymph node', 'laterality' => ''),
		'Pelvic' => array('source' => 'pelvis', 'laterality' => ''),
		'Pelvic mass biopsy' => array('source' => 'pelvic mass', 'laterality' => ''),
		'Pelvic Tumor' => array('source' => 'pelvis', 'laterality' => ''),
		'Peri-rectal tumour' => array('source' => 'rectum', 'laterality' => ''),
		'Post Vagina' => array('source' => 'vagina', 'laterality' => ''),
		'Right adenexal mass' => array('source' => 'adnexal', 'laterality' => ''),
		'Right endometrioma' => array('source' => 'endometrium', 'laterality' => 'right'),
		'Right fallopian tube/fimbrea' => array('source' => 'fallopian tube', 'laterality' => 'right'),
		'Right Fimbraie' => array('source' => 'fimbraie', 'laterality' => 'right'),
		'Right groin node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Right Inguinal Femoral Lymph node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Right lower quad/mass' => array('source' => 'abdominal mass', 'laterality' => 'right'),
		'Right node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Right ovary cyst' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right ovary pelvic tumour' => array('source' => 'ovary', 'laterality' => 'right'),
		'Right tube and fimbrae' => array('source' => 'fallopian tube and fimbraie', 'laterality' => 'right'),
		'Right tube and fimbrae end' => array('source' => 'fallopian tube and fimbraie', 'laterality' => 'right'),
		'Right tube and ovary' => array('source' => 'fallopian tube', 'laterality' => 'right'),
		'Right Tube Ovary' => array('source' => 'fallopian tube', 'laterality' => 'right'),
		'Right uterosacral ' => array('source' => 'uterosacrel', 'laterality' => 'right'),
		'RT groin node' => array('source' => 'groin', 'laterality' => 'right'),
		'Rt Node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Rt ovarian mass' => array('source' => 'ovary', 'laterality' => 'right'),
		'Rt Ovary Mass' => array('source' => 'ovary', 'laterality' => 'right'),
		'Rt. Pelvic Lymph Node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Sigmoid' => array('source' => 'sigmoid', 'laterality' => ''),
		'Subserosal Mass' => array('source' => 'other', 'laterality' => ''),
		'Tumor from sigmoid colon' => array('source' => 'sigmoid', 'laterality' => ''),
		'Tumour from myometrium' => array('source' => 'myometrium', 'laterality' => ''),
		'Tumour Lt cul de sac' => array('source' => 'cul-de-sac', 'laterality' => 'left'),
		'tumour on umbilical hernia' => array('source' => 'umbilical hernia', 'laterality' => ''),
		'Tumour R cul de sac' => array('source' => 'cul-de-sac', 'laterality' => 'right'),
		'Uretaric tumour' => array('source' => 'ureter', 'laterality' => ''),
		'Uterine tumour' => array('source' => 'uterus', 'laterality' => ''),
		'Vag/Cardiac exudate tumor' => array('source' => 'vaginal Exudate', 'laterality' => ''),

		'Right fallopian tube/fimbrae' => array('source' => 'fallopian tube and fimbraie', 'laterality' => 'right'),
		'Left ovary surface' => array('source' => 'ovary', 'laterality' => 'left'),
		'Right upper quadrant tumour' => array('source' => 'other', 'laterality' => 'right'),
		'Pelvic lymph node' => array('source' => 'lymph node', 'laterality' => ''),
		'Left obturator lymph node' => array('source' => 'lymph node', 'laterality' => 'left'),
		'Right obturator lymph node' => array('source' => 'lymph node', 'laterality' => 'right'),
		'Left frimbriated end of tube' => array('source' => 'fallopian tube and fimbraie', 'laterality' => 'left')			
	);
	$tmp_tissue_matches = $tissue_matches;
	$tissue_matches = array();
	foreach($tmp_tissue_matches as $key => $data) $tissue_matches[strtolower($key)] = $data;
	unset($tmp_tissue_matches);
	return $tissue_matches;
}

//===========================================================================================================================================
// Sotarage Management Functions
//===========================================================================================================================================

function loadStorageData(&$xls_sheets, $sheets_keys, $atim_controls) {
	global $summary_msg;
	$summary_msg['Storage Creation']['@@WARNING@@']['Box Layout not imported'][] = "Freezer Box Map(Saliva)";
	$box_control = array(
		'1' => '1 2 3 4 5 6 7 8 9',
		'2' => '10 11 12 13 14 15 16 17 18',
		'3' => '19 20 21 22 23 24 25 26 27',
		'4' => '28 29 30 31 32 33 34 35 36',
		'5' => '37 38 39 40 41 42 43 44 45',
		'6' => '46 47 48 49 50 51 52 53 54',
		'7' => '55 56 57 58 59 60 61 62 63',
		'8' => '64 65 66 67 68 69 70 71 72',
		'9' => '73 74 75 76 77 78 79 80 81');
	$aliquot_label_to_storage_data = array();
	$created_storages = array();
	foreach(array('Freezer Box Map (Buffy coat)','Freezer Box Map (Serum)','Freezer Box Map (Plasma)','Freezer Box Map (Tissue)') as $worksheet_name) {
		$tissue_box = ($worksheet_name == 'Freezer Box Map (Tissue)')? true : false;
		$first_box_row_excel_line_counter = 0;
		$positions = array();
		$box_data = array('worksheet' => $worksheet_name, 'freezer' => '', 'shelf' => '', 'rack14' => '', 'rack16' => '', 'box81' => '', 'aliquot_positions' => array());
		if(!isset($sheets_keys[$worksheet_name])) die('ERR 2387 3287 32 '.$worksheet_name);
		foreach($xls_sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {	
			if(!$first_box_row_excel_line_counter) {
				//Looking for new box labels
				$imploded_new_line = implode(' ', $new_line);
				if(preg_match('/Freezer\ #([0-9]+)/', $imploded_new_line, $matches)) $box_data['freezer'] = $matches[1];				
				if(preg_match('/Shelf[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['shelf'] = $matches[1];
				if(preg_match('/Tower[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['rack14'] = $matches[1];
				if(preg_match('/Rack[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['rack16'] = $matches[1];
				if(preg_match('/Box[:\ #]{1,3}(.+)/', $imploded_new_line, $matches)) $box_data['box81'] = $matches[1];
				if(preg_match('/Freezer Box Name:\ (.+)$/', $imploded_new_line, $matches)) $box_data['box81'] = str_replace(array('Gyne Tumour Bank, '), array(''), $matches[1]);
				if($imploded_new_line == $box_control[1]) {
					if(implode('', array_keys($new_line)) != '2345678910') die('ERR23732732832832');
					$first_box_row_excel_line_counter = $excel_line_counter;
				}
			} 
			if($first_box_row_excel_line_counter) {
				//Parsing box layout
				$diff = $excel_line_counter - $first_box_row_excel_line_counter;	
				if(in_array($diff, array(0,2,4,6,8,10,12,14,16))) {
					//Positions
					if(implode(' ', $new_line) !== $box_control[(($diff/2)+1)]) die('WRONG BOX LAYOUT  : (in excel)['.implode(' ', $new_line)."] != (expected)[".$box_control[(($diff/2)+1)]."] Sheet $worksheet_name line $excel_line_counter");
					$positions = $new_line;
				} else if(in_array($diff, array(1,3,5,7,9,11,13,15,17))) {
					//$aliquots
					foreach($positions as $excel_column => $storage_coordinate_x) {
						if(isset($new_line[$excel_column]) && strlen($new_line[$excel_column])) {
							$box_data['aliquot_positions'][$storage_coordinate_x] = str_replace("\n", ' ', $new_line[$excel_column]);
						}
					}
				}
				if($diff > 16) {	
					//End Of The Box
					recordNewBox($aliquot_label_to_storage_data, $created_storages, $box_data, $atim_controls, $tissue_box);
					//Reset data
					$first_box_row_excel_line_counter = 0;
					$positions = array();
					$box_data = array('worksheet' => $worksheet_name, 'freezer' => '', 'shelf' => '', 'rack14' => '', 'rack16' => '', 'box81' => '', 'aliquot_positions' => array());
					//In case last box row was empty and system was redeaing line with freezer info ,etc.. 
					$imploded_new_line = implode(' ', $new_line);
					if(preg_match('/Freezer\ #([0-9]+)/', $imploded_new_line, $matches)) $box_data['freezer'] = $matches[1];
					if(preg_match('/Shelf[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['shelf'] = $matches[1];
					if(preg_match('/Rack[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['rack16'] = $matches[1];
					if(preg_match('/Freezer Box Name:\ (.+)$/', $imploded_new_line, $matches)) $box_data['box81'] = str_replace(array('Gyne Tumour Bank, '), array(''), $matches[1]);
					if($imploded_new_line == '1 2 3 4 5 6 7 8 9') die('ERR 2378 327823782 7');
				}
			}
		}
		if($box_data['aliquot_positions']) {
			recordNewBox($aliquot_label_to_storage_data, $created_storages, $box_data, $atim_controls, $tissue_box);
		}
	}
	return $aliquot_label_to_storage_data;
}

function recordNewBox(&$aliquot_label_to_storage_data, &$created_storages, $box_data, $atim_controls, $tissue_box){
	global $summary_msg;	
	if(!strlen($box_data['box81'])) die('ERR 327328 7287eeeeeqqw2');
	//Manage 
	$parent_storage_master_id = null;
	$parent_selection_label = '';
	foreach(array('freezer', 'shelf', 'rack14', 'rack16', 'box81') as $storage_type) {
		$box_data[$storage_type] = trim(preg_replace('/([0-9]+)(to)/' , '$1-', preg_replace('/(\ )+/', '', str_replace(array('Samples','Box'), array('',''), $box_data[$storage_type]))));
		if(strlen($box_data[$storage_type])) {
			$storage_key = "$storage_type#".$box_data[$storage_type];
			if(isset($created_storages[$storage_key])) {
				if($storage_type == 'box81') {
					$summary_msg['Aliquot Position Definition']['@@ERROR@@']['Box already created'][] = "Box [".$box_data['box81']."] has already been parsed. The box won't be created twice. See worksheet [".$box_data['worksheet']."].";
					return;
				}
				list($parent_storage_master_id, $parent_selection_label) = $created_storages[$storage_key];
			} else {
				if(strlen($box_data[$storage_type]) > 20) die('ERR3732773272732');
				$parent_selection_label .= (empty($parent_selection_label)? '' : '-').$box_data[$storage_type];
				if(strlen($parent_selection_label) > 60) die('ERR3732773272733');
				$storage_controls_data = $atim_controls['storage_control_ids'][$storage_type];
				$storage_master_data = array(
					"code" => (1+sizeof($created_storages)),				
					"short_label" => $box_data[$storage_type],
					"selection_label" => $parent_selection_label,
					"storage_control_id" => $storage_controls_data[0],
					"parent_id" => $parent_storage_master_id);
				$parent_storage_master_id = customInsertRecord($storage_master_data, 'storage_masters', false);
				customInsertRecord(array('storage_master_id' => $parent_storage_master_id), $storage_controls_data[1], true);
				$created_storages[$storage_key] = array($parent_storage_master_id, $parent_selection_label);
			}
		}
	}
	if(!$parent_storage_master_id) die('ERR 7326 76 73262');
	foreach($box_data['aliquot_positions'] as $storage_coord_x => $aliquot_data) {
		if(!preg_match('/^([1-9])|([1-7][0-9])|(8[01])$/', $storage_coord_x)) die('ERRR 327 6237 67632 '.$storage_coord_x);
		$aliquot_label_and_time = explode(' ', trim(preg_replace('/(\ )+/', ' ', str_replace("\n", ' ', $aliquot_data))));
		if($tissue_box) {
			//No storage date time
			$aliquot_label_and_time[0] =   trim(preg_replace('/(\ )+/', ' ', str_replace("\n", ' ', $aliquot_data)));
			$aliquot_label_and_time[1] = '';
		} else if(sizeof($aliquot_label_and_time) == 4 && preg_match('/^((0{0,1}[1-9])|([12][0-9])|(3[01]))$/', $aliquot_label_and_time[1]) && preg_match('/^([A-Za-z]{3,4})$/', $aliquot_label_and_time[2]) &&preg_match('/^(((19)|(20)){0,1}[0-9][0-9])$/', $aliquot_label_and_time[3])) {
			$aliquot_label_and_time[1] = $aliquot_label_and_time[1].$aliquot_label_and_time[2].$aliquot_label_and_time[3];
			unset($aliquot_label_and_time[2]);			
		} else if(sizeof($aliquot_label_and_time) == 3 && 
		((preg_match('/^((0{0,1}[1-9])|([12][0-9])|(3[01]))$/', $aliquot_label_and_time[1]) && preg_match('/^([A-Za-z]{3,4})(((19)|(20)){0,1}[0-9][0-9])$/', $aliquot_label_and_time[2])) ||
		(preg_match('/^((0{0,1}[1-9])|([12][0-9])|(3[01]))([A-Za-z]{3,4})$/', $aliquot_label_and_time[1]) && preg_match('/^(((19)|(20)){0,1}[0-9][0-9])$/', $aliquot_label_and_time[2])))) {
			$aliquot_label_and_time[1] = $aliquot_label_and_time[1].$aliquot_label_and_time[2];
			unset($aliquot_label_and_time[2]);			
		} else if(sizeof($aliquot_label_and_time) != 2) {
			$summary_msg['Aliquot Position Definition']['@@ERROR@@']['The system is unable to find an aliquot label and a date from cell content'][] = "See cell content [$aliquot_data] in box [".$box_data['box81']."] of worksheet [".$box_data['worksheet']."]. No postion and storage date time will be imported.";
			continue;
		}
		$aliquot_label = preg_replace('/(\ )+/', '', $aliquot_label_and_time[0]);
		$storage_datetime = strtoupper($aliquot_label_and_time[1]);
		$storage_datetime_accuracy = 'h';
		if(empty($storage_datetime)) {
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
		} else if(preg_match('/^((0{0,1}[1-9])|([12][0-9])|(3[01]))([A-Z]{3,4})(((19)|(20)){0,1}[0-9][0-9])$/', $storage_datetime, $matches)) {
			$month_matches = array(
				'JAN' => '01',
				'FEB' => '02',
				'MAR' => '03',
				'APR' => '04',
				'MAY' => '05',
				'JUN' => '06',
				'JULY' => '07',
				'JUL' => '07',
				'AUG' => '08',
				'SEPT' => '09',
				'SEP' => '09',
				'OCT' => '10',
				'NOV' => '11',
				'DEC' => '12');
			if(!in_array($matches[5], array_keys($month_matches))) {
				$summary_msg['Storage Creation']['@@ERROR@@']['Aliquot Storage Date format error'][] = "See date ($storage_datetime) for aliquot $aliquot_label in box [".$box_data['box81']."] of worksheet [".$box_data['worksheet']."]. No date will be imported.";
			} else {
				$storage_datetime = ((strlen($matches[6]) == 2)? '20'.$matches[6] : $matches[6]).'-'.str_replace(array_keys($month_matches), array_values($month_matches), $matches[5]).'-'.((strlen($matches[1]) == 1)? '0'.$matches[1] : $matches[1]);				
			}
		} else {
			$summary_msg['Storage Creation']['@@ERROR@@']['Aliquot Storage Date format error'][] = "See date ($storage_datetime) for aliquot $aliquot_label in box [".$box_data['box81']."] of worksheet [".$box_data['worksheet']."]. No date will be imported.";
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
		}
		if(!isset($aliquot_label_to_storage_data[$aliquot_label])) {
			$aliquot_label_to_storage_data[$aliquot_label] = array('storage_master_id' => $parent_storage_master_id, 'storage_coord_x' => $storage_coord_x, 'storage_datetime' => $storage_datetime, 'storage_datetime_accuracy' => $storage_datetime_accuracy, 'box_name' => $box_data['box81']);
		} else {
			$summary_msg['Aliquot Position Definition']['@@ERROR@@']['Aliquot Label assigned to 2 different positions'][] = "See aliquot $aliquot_label in box [".$box_data['box81']."] position $storage_coord_x in worksheet [".$box_data['worksheet']."]. Aliquot was already defined as stored in box [".$aliquot_label_to_storage_data[$aliquot_label]['box_name']."] at positon [".$aliquot_label_to_storage_data[$aliquot_label]['storage_coord_x']."]. New position won't be imported.";
		}
	}
}

?>