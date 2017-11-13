<?php

/**
 * Script to dowload all block slide reviews into ATiM QBCF.
 *
 * Notes:
 *   - No collection, sample, block and slide will be created by the script.
 *   - Path review data will be created if the system is able to find a tissue block into ATiM matching bank, pathology id and block code then block slide.
 *   - No Path review will be created if an existing one already exists for the tissue block.
 */
 
require_once 'system.php';

//==============================================================================================
// Main Code
//==============================================================================================

$commit_all = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commit_all = false;
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

$tmp_files_names_list = array();

foreach($excel_files_names as $file_data) {
	list($excel_file_name, $excel_xls_offset) = $file_data;
	$tmp_files_names_list[] = $excel_file_name;
}

displayMigrationTitle('QBCF Slide Review Creation');

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** PARSE EXCEL FILES ***

$bank_to_bank_id = array();
$qbcf_bank_participant_identifier_to_participant_id = array();
$created_sample_counter = 0;
$created_aliquot_counter = 0;
	$file_counter = 0;
foreach($excel_files_names as $file_data) {
	$file_counter++;
	
	// New Excel File
	
	list($excel_file_name, $excel_xls_offset) = $file_data;
	$excel_file_name_for_ref = "File#$file_counter - ".((strlen($excel_file_name) > 30)? substr($excel_file_name, '0', '30')."...xls" : $excel_file_name);
	
	recordErrorAndMessage('Files', '@@MESSAGE@@', "Excel Files Parsed", "File#$file_counter - $excel_file_name");
	
	$worksheet_name = 'Feuil1';
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $excel_xls_offset)) {
		if($line_number > 2)  {
			$qbcf_bank_participant_identifier = $excel_line_data['Patient #'];
			$bank = $excel_line_data['Site'];
			$excel_data_references = "Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>' & Excel '<b>$excel_file_name_for_ref</b>' & Line '<b>$line_number</b>' & Worksheet '<b>$worksheet_name</b>'";
			
			if(strlen($qbcf_bank_participant_identifier)) {
				
				// 1- CHECK BANK
				//..............................................................................................

				$qbcf_bank_id = null;
				if(isset($bank_to_bank_id[$bank])) {
					$qbcf_bank_id = $bank_to_bank_id[$bank];
				} else {
					$banks_data = getSelectQueryResult("SELECT id, name FROM banks WHERE name like '$bank%'");
					if(!$banks_data) {
						recordErrorAndMessage('Bank', '@@ERROR@@', "Bank unknown into ATiM - No line data will be migrated", "See Bank '$bank' for participant : $excel_data_references");
					} else if(sizeof($banks_data) > 1) {
						$ATiM_banks_names = array();
						foreach($banks_data as $new_bank) {
							$ATiM_banks_names[] = $new_bank['name'];
						}
						recordErrorAndMessage('Bank', '@@ERROR@@', "More than one bank matches the bank name - No line data will be migrated", "See Bank '$bank' for participant : $excel_data_references");
					} else {
						$qbcf_bank_id = $banks_data[0]['id'];
						$bank_to_bank_id[$bank] = $qbcf_bank_id;
					}
				}
				
				if($qbcf_bank_id) {
					
					// 2- BLOCK DETECTION
					//..............................................................................................
					
					$excel_pathology_id = $excel_line_data['Pathology ID number'];
					$excel_block_code = $excel_line_data['Block ID'];
						
					if(!strlen($excel_pathology_id) || !strlen($excel_block_code)) {
							
						recordErrorAndMessage('Block', '@@ERROR@@', "The Pathology ID or the Block Code is missing - No data will be migrated", "See data for following participant : $excel_data_references.");
							
					} else {
						
						$block_collection_id = null;
						$block_sample_master_id = null;
						$block_aliquot_master_id = null;
						
						$tissue_sample_detail_tablename = $atim_controls['sample_controls']['tissue']['detail_tablename'];
						$tissue_block_sample_detail_tablename = $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'];
						
						$excel_block_aliquot_label = $excel_pathology_id.' '.$excel_block_code;
						
						$query = "SELECT Participant.qbcf_bank_id,
							Participant. qbcf_bank_participant_identifier,
							Collection.id as collection_id,
							Collection.treatment_master_id,
							Collection.qbcf_pathology_id,
							SampleMaster.id AS sample_master_id,
							SampleDetail.tissue_source,
							AliquotMaster.id AS aliquot_master_id,
							AliquotMaster.barcode,
							AliquotMaster.aliquot_label,
							AliquotMaster.in_stock,
							AliquotMaster.storage_master_id,
							AliquotMaster.storage_coord_x,
							AliquotMaster.storage_coord_y,
							AliquotDetail.patho_dpt_block_code
							FROM participants Participant
							INNER JOIN collections Collection ON Collection.participant_id = Participant.id
							INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
							INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
							INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND SampleMaster.id = AliquotMaster.sample_master_id
							INNER JOIN $tissue_block_sample_detail_tablename AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
							WHERE Participant.deleted <> 1
							AND Participant.qbcf_bank_id = '$qbcf_bank_id'
							AND Collection.deleted <> 1
							AND Collection.qbcf_pathology_id = '$excel_pathology_id'
							AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
							AND SampleMaster.deleted <> 1
							AND AliquotMaster.deleted <> 1
							AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
							AND AliquotDetail.patho_dpt_block_code = '$excel_block_code';";
						$query_data = getSelectQueryResult($query);
						
						if($query_data) {
							if(sizeof($query_data) > 1) {
								// Two bank blocks matched the excel file block based on 'Pathology ID number' & 'Block Code' & the bank
								recordErrorAndMessage('Block', '@@ERROR@@', "More than one ATiM tissue block matches the excel tissue block (based on Pathology ID number' & 'Block Code' & the bank name) - System will only work on the first ATiM record. Please validate.", "See block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
							}
							$atim_block_data = $query_data[0];
							if($atim_block_data['qbcf_bank_participant_identifier'] != $qbcf_bank_participant_identifier) {
								// ATiM block not linked to the same participant idenitifier than this one listed into excel
								recordErrorAndMessage('Block', '@@ERROR@@', "Bank block already exists into ATiM (based on 'Pathology ID number' & 'Block Code' & the bank name) but the participant does not match the excel participant based on the Patient # in biobank - ATiM review data won't be migrated.", "See block '$excel_block_aliquot_label' linked to ATiM bank participant '".$atim_block_data['qbcf_bank_participant_identifier']."'for following participant : $excel_data_references.");
							} else {
								$block_collection_id = $atim_block_data['collection_id'];
								$block_sample_master_id = $atim_block_data['sample_master_id'];
								$block_aliquot_master_id = $atim_block_data['aliquot_master_id'];
							}	
						} else {	
							//Check block has not be linked to another bank
							$query = "SELECT AliquotMaster.barcode
								FROM collections Collection
								INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
								INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
								INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND SampleMaster.id = AliquotMaster.sample_master_id
								INNER JOIN $tissue_block_sample_detail_tablename AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
								WHERE Collection.deleted <> 1
								AND Collection.qbcf_pathology_id = '$excel_pathology_id'
								AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
								AND SampleMaster.deleted <> 1
								AND AliquotMaster.deleted <> 1
								AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
								AND AliquotDetail.patho_dpt_block_code = '$excel_block_code';";
							$query_data = getSelectQueryResult($query);
							if($query_data) {
								recordErrorAndMessage('Block', '@@WARNING@@', "Block already exists into ATiM (based on 'Pathology ID number' & 'Block Code') but the bank is different - No block review will be migrated.", "See block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
							}
						}
						
						if($block_aliquot_master_id) {
							
							// 3- SLIDE DETECTION
							//..............................................................................................
						
							$slide_aliquot_master_id = null;
						
							$query = "SELECT AliquotMaster.id AS aliquot_master_id
								FROM aliquot_masters AliquotMaster
								INNER JOIN realiquotings Realiquoting ON Realiquoting.child_aliquot_master_id = AliquotMaster.id AND Realiquoting.deleted <> 1
								WHERE AliquotMaster.deleted <> 1
								AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-slide']['id']."
								AND AliquotMaster.collection_id = $block_collection_id
								AND AliquotMaster.sample_master_id =$block_sample_master_id
								AND Realiquoting.parent_aliquot_master_id = $block_aliquot_master_id";
							$query_data = getSelectQueryResult($query);
							if($query_data) {
								if(sizeof($query_data) > 1) {
									// Two bank slides matched the excel file slide based on 'Pathology ID number' & 'Block Code' & the bank
									recordErrorAndMessage('Slide', '@@ERROR@@', "More than one ATiM tissue slide are linked to the excel tissue block (based on Pathology ID number' & 'Block Code' & the bank name) - System will only work on the first ATiM record. Please validate.", "See slide of block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								}
								$slide_aliquot_master_id = $query_data[0]['aliquot_master_id'];							
							} else {
								$query = "SELECT AliquotMaster.id AS aliquot_master_id
									FROM aliquot_masters AliquotMaster
									WHERE AliquotMaster.deleted <> 1
									AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-slide']['id']."
									AND AliquotMaster.collection_id = $block_collection_id
									AND AliquotMaster.sample_master_id =$block_sample_master_id";
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									if(sizeof($query_data) > 1) {
										// Two bank slides matched the excel file slide based on 'Pathology ID number' & 'Block Code' & the bank
										recordErrorAndMessage('Slide', '@@ERROR@@', "More than one ATiM tissue slide are linked to the tissue of the excel block (based on Pathology ID number' & 'Block Code' & the bank name) - System will only work on the first ATiM record. Please validate.", "See slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
									}
									$slide_aliquot_master_id = $query_data[0]['aliquot_master_id'];
									recordErrorAndMessage('Slide', '@@ERROR@@', "Tissue slide has been found (based on Pathology ID number' & 'Block Code' & the bank name)  but this one is not linked to the block of the tissue - Please validate and add correction to ATiM if required.", "See slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								} else {
									recordErrorAndMessage('Slide', '@@ERROR@@', "No Tissue slide has been found (based on Pathology ID number' & 'Block Code' & the bank name) - Path review data will be migrated but not linked to a slide. Please validate and add correction manually into ATiM.", "See slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								}
							}
							
							// 4- PATH REVIEW CREATION
							//..............................................................................................
									
							$query = "SELECT id 
								FROM specimen_review_masters 
								WHERE deleted <> 1
								AND sample_master_id = $block_sample_master_id";
							$query_data = getSelectQueryResult($query);
							if($query_data) {
								// A path review already exists for the tissue of the block
								recordErrorAndMessage('Slide Review', '@@WARNING@@', "A slide review already exists into ATiM for the tissue of the excel block (based on Pathology ID number' & 'Block Code' & the bank name) - System will not create a new one. Please validate.", "See tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
							
							} else {
							
								//Specimen Review
								
								$qbcf_reviewed_by_dr_tran_thanh = '';
								$excel_field = 'Reviewed by Dr Tran';
								if(in_array(strtolower($excel_line_data[$excel_field]), array('yes','y'))) {
									$qbcf_reviewed_by_dr_tran_thanh = '1';
								} else if(in_array($excel_line_data[$excel_field], array('no','n'))) {
								} else if(strlen($excel_line_data[$excel_field])) {
									recordErrorAndMessage('Slide Review', '@@ERROR@@', "Wrong Yes value - Value won't be migrated so add correction manually into ATiM.", "See value '".$excel_line_data[$excel_field]."' of field '$excel_field' for slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								}
								
								$domain_name = 'custom_laboratory_staff';
								$excel_field = "Reviewed by";
								$qbcf_reviewer = validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, 'Slide Review', $excel_field, "See $excel_data_references");
								
								$specimen_review_data = array(
									'specimen_review_masters' => array(
										'specimen_review_control_id' => $atim_controls['specimen_review_controls']['tissue block review']['id'],
										'collection_id' => $block_collection_id,
										'sample_master_id' => $block_sample_master_id,
										'qbcf_reviewer' => $qbcf_reviewer,
										'qbcf_reviewed_by_dr_tran_thanh' => $qbcf_reviewed_by_dr_tran_thanh),
									$atim_controls['specimen_review_controls']['tissue block review']['detail_tablename'] => array());
								$specimen_review_master_id = customInsertRecord($specimen_review_data);
							
								//Aliquot Review	
								
								$aliquot_review_detail_tablename = $atim_controls['specimen_review_controls']['tissue block review']['aliquot_review_detail_tablename'];
								$aliquot_review_data = array(
									'aliquot_review_masters' => array(
										'aliquot_review_control_id' => $atim_controls['specimen_review_controls']['tissue block review']['aliquot_review_control_id'],
										'specimen_review_master_id' => $specimen_review_master_id,
										'aliquot_master_id' => $slide_aliquot_master_id,
                                        'review_code' => '-1'),
									$aliquot_review_detail_tablename => array('notes' => $excel_line_data['comments']));
								
								$fields_data = array(
									array("Histology", 'histology', 'qbcf_path_review_histology'),
									array("Warning", 'qbcf_warnings', 'qbcf_path_review_warnings'),
									array("Tubular formation", 'tubular_formation', 'qbcf_1_2_3'),
									array("Nuclear Atypia", 'nuclear_atypia', 'qbcf_1_2_3'),
									array("Mitosis count", 'mitosis_count', 'qbcf_1_2_3'),
									array("Final Grade (Nottingham)", 'final_grade', 'qbcf_1_2_3'));
								foreach($fields_data as $field_data) {
									list($excel_field, $atim_field, $domain_name) = $field_data;
									if($domain_name == 'qbcf_1_2_3' && preg_match('/^\-$/', $excel_line_data[$excel_field])) $excel_line_data[$excel_field] = '';
									$aliquot_review_data[$aliquot_review_detail_tablename][$atim_field] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, 'Slide Review', $excel_field, "See $excel_data_references");
								}
								
								$fields_data = array(
									array("Lymphoid Aggregate", 'lymphoid_aggregate_outside_of_the_tumor'),
									array("Large Tumor Zone", 'large_tumor_zone'),
									array("DCIS on slide", 'dcis_on_slide'),
									array("LCIS on slide", 'lcis_on_slide'));
								foreach($fields_data as $field_data) {
									list($excel_field, $atim_field) = $field_data;
									$excel_line_data[$excel_field] = strtolower($excel_line_data[$excel_field]);
									if(in_array($excel_line_data[$excel_field], array('yes','y'))) {
										$aliquot_review_data[$aliquot_review_detail_tablename][$atim_field] = 'y';
									} else if(in_array($excel_line_data[$excel_field], array('no','n'))) {
										$aliquot_review_data[$aliquot_review_detail_tablename][$atim_field] = 'n';
									} else if(strlen($excel_line_data[$excel_field])) {
										recordErrorAndMessage('Slide Review', '@@ERROR@@', "Wrong Yes-No value - Value won't be migrated so add correction manually into ATiM.", "See value '".$excel_line_data[$excel_field]."' of field '$excel_field' for slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
									}
								}
								
								$excel_field = "Tumour lymphocytes (TILs)";
								$tils_pct = validateAndGetInteger(str_replace('%', '', $excel_line_data[$excel_field]), 'Slide Review', "For field '$excel_field'", "See slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								if(preg_match('/[a-zA-Z\-\<]/', $excel_line_data[$excel_field])) {
									recordErrorAndMessage('Slide Review', '@@WARNING@@', "Check value of field 'Tumour lymphocytes (TILs)' does not mean value < 5 - Check box 'TILs <5' manually if required.", "See value '".$excel_line_data[$excel_field]."' of field '$excel_field' for slide of the tissue of the block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								}
								if(strlen($tils_pct)) {
									$aliquot_review_data[$aliquot_review_detail_tablename]['tils_pct'] = $tils_pct;
									if($tils_pct < 5) $aliquot_review_data[$aliquot_review_detail_tablename]['tils_pct_less_than_5'] = '1';
								}
								
								customInsertRecord($aliquot_review_data);
							}							
						} // End tissue block found						
					}
				} // Bank found in section above
			} else if(strlen($excel_line_data['Pathology ID number'])) {
				//No $qbcf_bank_participant_identifier but block defined
				recordErrorAndMessage('Participant', '@@ERROR@@', "No participant defined for a block pathology ID - No review data will be migrated", "See block '".$excel_line_data['Pathology ID number']." ".$excel_line_data['Block ID']."' for participant : $excel_data_references");
			}
		}
	}  //End new line
}
	
$last_queries_to_execute = array();
foreach($last_queries_to_execute as $query)	customQuery($query);

//*** SUMMARY DISPLAY ***

global $import_summary;

$creation_update_summary = array();
foreach(array('Data Update Summary', 'Data Creation Summary') as $new_section) {
	if(isset($import_summary[$new_section])) {
		$creation_update_summary[$new_section] = $import_summary[$new_section];
		unset($import_summary[$new_section]);
	}
}

dislayErrorAndMessage(false, 'Migration Errors/Warnings/Messages');

$import_summary = $creation_update_summary;

dislayErrorAndMessage($commit_all, 'Creation/Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================
	
?>
		