<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Main Code
//==============================================================================================

$excel_file_name = 'ListFrozenBlocksATiMs_20160215_revised.xls';

displayMigrationTitle('PROCURE Blocks Clean Up', array($excel_file_name));

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}

$new_procure_box_master_ids = array();

$max_rght = getSelectQueryResult("select max(rght) as last_rght from $procure_db_schema.storage_masters WHERE deleted <> 1;");
$max_rght = $max_rght[0]['last_rght'];

$worksheet_name = 'Feuil1';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
	if(strlen(trim($excel_line_data['Identification (alq.)']))) {
		$icm_to_procure = preg_match('/trans{0,1}fer(\ )+to(\ )+procure/i', $excel_line_data['Comments'])? true : false;
		$sent_to_processing_site = preg_match('/sent(\ )+to(\ )+procure/i', $excel_line_data['Comments'])? true : false;
		
		$xls_storage_selection_label = $excel_line_data['Storage'];
		$xls_storage_coord_x = $excel_line_data['Position (x)'];
		$xls_procure_barcode = $excel_line_data['Identification (alq.)'];
		$xls_procure_participant_identifier = $excel_line_data['Identification (part.)'];
		$xls_no_labo = $excel_line_data['No Labo'];
		$xls_patho_misc_identifier = $excel_line_data['Patho Identifier'];
		$xls_procure_sd_procure_report_number = $excel_line_data['Pathology #'];
		
		$xls_procure_origin_of_slice = $excel_line_data['Origin of Slice'];
		
		$xls_tissue_type_note_from_nowhere = $excel_line_data['Tissue Type'];
		
		$xls_new_storage_selection_label = $excel_line_data['New Storage'];
		$xls_new_storage_coord_x = $excel_line_data['New Position (x)'];
			
		if(!$icm_to_procure) {
			
			//*** BLOCK IN ATiM PROCURE ***
			
			$query = "SELECT
				p.id as participant_id,
				sam.id as sample_master_id,			
				am.id as aliquot_master_id,
				am.barcode,
				p.participant_identifier,
				mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
				mid_nopatho.identifier_value as 'mid_nopatho_identifier_value',
				sd.procure_report_number,
				ad.procure_origin_of_slice,
				am.in_stock,
				am.use_counter,
				stm.selection_label,
				am.storage_coord_x, 
				am.notes
				FROM $procure_db_schema.ad_blocks ad
				INNER JOIN $procure_db_schema.aliquot_masters am ON am.id = ad.aliquot_master_id
				INNER JOIN $procure_db_schema.sample_masters sam ON sam.id = am.sample_master_id
				INNER JOIN $procure_db_schema.sd_spe_tissues sd ON sd.sample_master_id = sam.id
				INNER JOIN $procure_db_schema.collections col ON col.id = sam.collection_id
				INNER JOIN $procure_db_schema.participants p ON p.id = col.participant_id
				LEFT JOIN $procure_db_schema.storage_masters stm ON stm.id = am.storage_master_id AND stm.deleted <> 1
				LEFT JOIN $procure_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
				LEFT JOIN $procure_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
				WHERE am.deleted <> 1 AND (ad.block_type = 'frozen' OR ad.procure_freezing_type IN ('OCT', 'ISO+OCT')) 
				AND %%criteria%%;";
			$query_criteria = "am.barcode = '$xls_procure_barcode'";
			$procure_block = getSelectQueryResult(str_replace(array('%%criteria%%'), array($query_criteria), $query));
						
			$found_by_position = false;
			if(!$procure_block) {
				//In case block not found...
				$query_criteria = "stm.selection_label = '$xls_storage_selection_label' AND am.storage_coord_x = '$xls_storage_coord_x'";
				$procure_block_based_on_position =  getSelectQueryResult(str_replace(array('%%criteria%%', "LEFT JOIN $procure_db_schema.storage_masters stm"), array($query_criteria, "INNER JOIN $procure_db_schema.storage_masters stm"), $query));
				if(sizeof($procure_block_based_on_position) == '1') {
					recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "Block found by position and not by identification :: Please validate.", "See excel identification '$xls_procure_barcode' replaced by '".$procure_block_based_on_position[0]['barcode']."' that exists in box '$xls_storage_selection_label (pos#$xls_storage_coord_x)'.");
					$procure_block = $procure_block_based_on_position;
					$found_by_position = true;
				}
			}
			
			if($procure_block && sizeof($procure_block) == 1) {
				$atim_procure_block_data = $procure_block[0];
				
				$participant_id = $atim_procure_block_data['participant_id'];
				$sample_master_id = $atim_procure_block_data['sample_master_id'];
				$aliquot_master_id = $atim_procure_block_data['aliquot_master_id'];
				
				// 1 - Check Data Integriy
				
				$update_position = true;
				
				if($xls_procure_participant_identifier && $xls_procure_participant_identifier != $atim_procure_block_data['participant_identifier']) {
					if($found_by_position) {
						recordErrorAndMessage('PROCURE Block Update', '@@MESSAGE@@', "Identification (part.) mismatch (note aliquot not found by label but by position - label has probably be updated after excel build) :: Position update should be done (to check) but the identification clean up won't be. To do manually after update process.", ("See excel value '$xls_procure_participant_identifier' and ATiM value '".$atim_procure_block_data['participant_identifier']."' for the block '$xls_procure_barcode'. "));
					} else {
						recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "Identification (part.) mismatch :: Position update should be done (to check) but the identification clean up won't be. To do manually after update process.", ("See excel value '$xls_procure_participant_identifier' and ATiM value '".$atim_procure_block_data['participant_identifier']."' for the block '$xls_procure_barcode'. "));
					}
				}
						
				if($xls_no_labo != $atim_procure_block_data['mid_nolabo_identifier_value'])
					recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "NoLabo mismatch  :: Position update should be done (to check) but the NoLabo clean up won't be. To do manually after update process.", "See excel value '$xls_no_labo' and ATiM value '".$atim_procure_block_data['mid_nolabo_identifier_value']."' for the block '$xls_procure_barcode'.");
				
				$procure_patho_report_number = array(trim($xls_patho_misc_identifier), trim($xls_procure_sd_procure_report_number), trim($atim_procure_block_data['mid_nopatho_identifier_value']), trim($atim_procure_block_data['procure_report_number']));
				$procure_patho_report_number = array_filter($procure_patho_report_number);
				$procure_patho_report_number = array_unique($procure_patho_report_number);
				$record_mid_nopatho_identifier_value = false;
				$update_procure_report_number = false;
				if($procure_patho_report_number) {
					$procure_patho_report_number = array_values($procure_patho_report_number);
					if(sizeof($procure_patho_report_number) == '2' && ($procure_patho_report_number[0] == ('0'.$procure_patho_report_number[1]) || $procure_patho_report_number[1] == ('0'.$procure_patho_report_number[0]))) {
						//989239 == 0989239
						unset($procure_patho_report_number[1]);
					}
					if(sizeof($procure_patho_report_number) == '1') {
						$procure_patho_report_number = array_shift($procure_patho_report_number);
						if(empty($atim_procure_block_data['mid_nopatho_identifier_value'])) {
							//Create participant 'Patho Identifier'
							$record_mid_nopatho_identifier_value = true;
						}
						if(empty($atim_procure_block_data['procure_report_number'])) {
							//Create tissue 'Report#'
							$update_procure_report_number = true;
						}
					} else {
						recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "More than one pathology report number :: Position update should be done (to check) but the patho number clean up won't be. To do manually after update process.", "More than one number exist ('".implode("', '", $procure_patho_report_number)."') for the block '$xls_procure_barcode'. Check excel data plus participant 'Patho Identifier' and tissue 'Report#'.");
					}
				}			
				
				if($xls_procure_origin_of_slice && $xls_procure_origin_of_slice != 'frozen' && $xls_procure_origin_of_slice != $atim_procure_block_data['procure_origin_of_slice'])
					recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "Origin of slice mismatch :: Position update should be done (to check) but the origin value clean up won't be. To do manually after update process.", "See excel value '$xls_procure_origin_of_slice' and ATiM value '".$atim_procure_block_data['procure_origin_of_slice']."' for the block '$xls_procure_barcode'.");
				
				if($xls_storage_selection_label != $atim_procure_block_data['selection_label'] || $xls_storage_coord_x != $atim_procure_block_data['storage_coord_x']) {
					if(isset($new_procure_box_master_ids[$atim_procure_block_data['selection_label']])) {
						$update_position = false;
						recordErrorAndMessage('PROCURE Block Update', '@@ERROR@@', "Initial block position mismatch - Aliquot seams to be already moved :: Check aliquot is not defined twice. Both the value clean up (no patho, etc) and the postion update won't be done. To do manually after update process.", "See excel value '$xls_storage_selection_label (pos#$xls_storage_coord_x)' and ATiM value '".$atim_procure_block_data['selection_label']." (pos#".$atim_procure_block_data['storage_coord_x'].")' for the block '$xls_procure_barcode'.");
					} else {
						recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "Initial block position mismatch :: But position update should be done (to check).", "See excel value '$xls_storage_selection_label (pos#$xls_storage_coord_x)' and ATiM value '".$atim_procure_block_data['selection_label']." (pos#".$atim_procure_block_data['storage_coord_x'].")' for the block '$xls_procure_barcode'.");
					}
				}
	
				if(!$xls_new_storage_selection_label) {
					$update_position = false;
					recordErrorAndMessage('PROCURE Block Update', '@@ERROR@@', "No box defined :: Both the value clean up (no patho, etc) and the postion update won't be done. To do manually after update process.", "See block '$xls_procure_barcode'.");
				}
				
				if(!$xls_new_storage_coord_x || !preg_match('/^(([1-9])|(1[0-9])|(2[0-7]))$/', $xls_new_storage_coord_x)) {
					$update_position = false;
					recordErrorAndMessage('PROCURE Block Update', '@@ERROR@@', "No or wrong box position defined :: Both the value clean up (no patho, etc) and the postion update won't be done. To do manually after update process.", "See block '$xls_procure_barcode'.");
				}
					
				if($atim_procure_block_data['in_stock'] == 'no') {
					$update_position = false;
					recordErrorAndMessage('PROCURE Block Update', '@@ERROR@@', "Position can not be set for an aliquot not in stock :: Both the value clean up (no patho, etc) and the postion update won't be done. To do manually after update process.", "See block '$xls_procure_barcode'.");
				}
				
				// 2 - Update Data
				
				if($update_position) {
					
					// a - Update aliquot master
					if(!isset($new_procure_box_master_ids[$xls_new_storage_selection_label])) {
						//Create box
						$storage_data = array(
							'storage_masters' => array(
								'storage_control_id' => $atim_controls[$procure_db_schema]['storage_controls']['box27']['id'],
								'code' => 'tmp_'.sizeof($new_procure_box_master_ids),
								'short_label' => $xls_new_storage_selection_label,
								'selection_label' => $xls_new_storage_selection_label,
								'lft' => ($max_rght++),
								'rght' => ($max_rght++)),
							$atim_controls[$procure_db_schema]['storage_controls']['box27']['detail_tablename'] => array());
						$new_procure_box_master_ids[$xls_new_storage_selection_label] = customInsertRecord($storage_data, $procure_db_schema);
						customQuery("UPDATE $procure_db_schema.storage_masters SET code = id WHERE code LIKE 'tmp%'");
						$diagnosis_data_to_update = array(
							'storage_masters' => array('code' => $new_procure_box_master_ids[$xls_new_storage_selection_label]),
							$atim_controls[$procure_db_schema]['storage_controls']['box27']['detail_tablename'] => array());
						updateTableData($new_procure_box_master_ids[$xls_new_storage_selection_label], $diagnosis_data_to_update, $procure_db_schema);
						recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Box creation", $xls_new_storage_selection_label);
					}
					$aliquot_master_data_to_update = array(
						'aliquot_masters' => array(
							'storage_master_id' => $new_procure_box_master_ids[$xls_new_storage_selection_label],
							'storage_coord_x' => $xls_new_storage_coord_x,
							'storage_coord_y' => "",
							'notes' => (strlen($xls_tissue_type_note_from_nowhere)? "Tissue Type = '$xls_tissue_type_note_from_nowhere'. ".$atim_procure_block_data['notes'] : $atim_procure_block_data['notes'])),	
						$atim_controls[$procure_db_schema]['aliquot_controls']['tissue-block']['detail_tablename'] => array());
					if($sent_to_processing_site) {
						$aliquot_master_data_to_update['aliquot_masters']['in_stock'] = 'yes - not available';
						$aliquot_master_data_to_update['aliquot_masters']['use_counter'] = $atim_procure_block_data['use_counter'] + 1;
					}
					updateTableData($aliquot_master_id, $aliquot_master_data_to_update, $procure_db_schema);
					recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Changed aliquot position", "$xls_procure_barcode moved to $xls_new_storage_selection_label position $xls_new_storage_coord_x.");

					// b - Sent to processing site :: Add aliquot internal use
					if($sent_to_processing_site) {
						$internal_use_data = array(
							'aliquot_internal_uses' => array(
								'use_code' => 'Temporaire',
								'type' => 'sent to processing site',
								'aliquot_master_id' => $aliquot_master_id,
								'procure_created_by_bank' => '1'));
						customInsertRecord($internal_use_data, $procure_db_schema);
						recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Internal Use 'sent to processing site' creation", "For $xls_procure_barcode");
					}
					
					// c - Recrod participant 'Patho Identifier'
					if($record_mid_nopatho_identifier_value) {
						$id_query = "SELECT id FROM $procure_db_schema.misc_identifiers WHERE identifier_value = '$procure_patho_report_number' AND misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id']." AND deleted <> 1;";					
						if(getSelectQueryResult($id_query)) {
							recordErrorAndMessage('PROCURE Block Update', '@@WARNING@@', "Duplicated participant 'Patho Identifier' :: Code already assigned to a patient. No new record. Please check conflict.", "$procure_patho_report_number for patient '".$atim_procure_block_data['participant_identifier']."' of the block '$xls_procure_barcode'.");
						} else {
							$misc_identifier_data = array(
								'misc_identifiers' => array(
									'identifier_value' => $procure_patho_report_number,
									'participant_id' => $participant_id,
									'misc_identifier_control_id' => $atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id'],
									'flag_unique' => $atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['flag_unique']));
							customInsertRecord($misc_identifier_data, $procure_db_schema);
							recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Recorded missing participant 'Patho Identifier'.", "$procure_patho_report_number for patient '".$atim_procure_block_data['participant_identifier']."' of the block '$xls_procure_barcode'.");	
						}	
					}
					
					// d -Record the procure tissue report number
					if($update_procure_report_number) {
						$sample_master_data_to_update = array(
							'sample_masters' => array(),
							'sd_spe_tissues' => array('procure_report_number' => $procure_patho_report_number));
						updateTableData($sample_master_id, $sample_master_data_to_update, $procure_db_schema);
						recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Recorded missing tissue 'Report#'.", "$procure_patho_report_number for tissue of the block '$xls_procure_barcode'.");
					}
				}
			} else if(sizeof($procure_block) > 1) {
				recordErrorAndMessage('PROCURE Block Update', '@@ERROR@@', "More than one block in database :: No value clean up (no patho, etc) and postion update can been done.", "$xls_procure_barcode defined in excel as stored in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
			} else {
				recordErrorAndMessage('PROCURE Block Update', '@@ERROR@@', "Block not found in database (based on identification or position checks):: No value clean up (no patho, etc) and postion update can been done.", "$xls_procure_barcode defined in excel as stored in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
			}
			
		} else {
			
			//*** BLOCK IN ONCO AXIS TO MOVE IN ATiM PROCURE ***
			
			$query = "SELECT
				p.id as participant_id,
				col.id as collection_id,
				sam.id as sample_master_id,
				am.id as aliquot_master_id,
				mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
				mid_nopatho.identifier_value as 'mid_nopatho_identifier_value',
				col.*,
				sam.*,
				sam.notes AS sample_notes,
				spd.*,
				sd.*,
				stm.selection_label,
				am.*,
				am.notes AS aliquot_notes,
				ad.*
				FROM $chumoncoaxis_db_schema.ad_blocks ad
				INNER JOIN $chumoncoaxis_db_schema.aliquot_masters am ON am.id = ad.aliquot_master_id
				INNER JOIN $chumoncoaxis_db_schema.sample_masters sam ON sam.id = am.sample_master_id
				INNER JOIN $chumoncoaxis_db_schema.specimen_details spd ON spd.sample_master_id = sam.id
				INNER JOIN $chumoncoaxis_db_schema.sd_spe_tissues sd ON sd.sample_master_id = sam.id
				INNER JOIN $chumoncoaxis_db_schema.collections col ON col.id = sam.collection_id
				INNER JOIN $chumoncoaxis_db_schema.participants p ON p.id = col.participant_id
				LEFT JOIN $chumoncoaxis_db_schema.storage_masters stm ON stm.id = am.storage_master_id
				LEFT JOIN $chumoncoaxis_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$chumoncoaxis_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
				LEFT JOIN $chumoncoaxis_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$chumoncoaxis_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
				WHERE am.deleted <> 1 AND ad.block_type IN ('frozen', 'OCT', 'isopentane + OCT') AND col.bank_id = 4 
				AND %%criteria%%;";
			$query_criteria = "am.aliquot_label = '$xls_procure_barcode'";
			$atim_oncologyaxis_block = getSelectQueryResult(str_replace(array('%%criteria%%'), array($query_criteria), $query));
			$atim_oncologyaxis_block_based_on_position = array();
			if(sizeof($atim_oncologyaxis_block) > 1) {
				//Check by postion
				$query_criteria = "am.aliquot_label = '$xls_procure_barcode' AND stm.selection_label = '$xls_storage_selection_label' AND am.storage_coord_x = '$xls_storage_coord_x'";
				$atim_oncologyaxis_block_based_on_position = getSelectQueryResult(str_replace(array('%%criteria%%', "LEFT JOIN $chumoncoaxis_db_schema.storage_masters stm"), array($query_criteria, "INNER JOIN $chumoncoaxis_db_schema.storage_masters stm"), $query));
				if(sizeof($atim_oncologyaxis_block_based_on_position) == 1) {
					$atim_oncologyaxis_block = $atim_oncologyaxis_block_based_on_position;
				}
			}
			
			if($atim_oncologyaxis_block && sizeof($atim_oncologyaxis_block) == 1) {
				$atim_oncologyaxis_block_data = $atim_oncologyaxis_block[0];
				
				// 1 - Check ATiM Onco Axis block exists then is not used, etc
				
				$move_to_atim_procure = true;
				
				if($atim_oncologyaxis_block_data['in_stock'] == 'no') {
					// ALiquot not in stock
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "Aliquot not in stock in Oncology Axis ATiM :: Block won't be moved to PROCURE ATiM.", "See block '$xls_procure_barcode' in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
					$move_to_atim_procure = false;
				}
				
				$block_use_check_query = "SELECT aliquot_master_id FROM $chumoncoaxis_db_schema.aliquot_internal_uses WHERE deleted <> 1 AND aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id']."
					UNION All
					SELECT aliquot_master_id FROM $chumoncoaxis_db_schema.source_aliquots WHERE deleted <> 1 AND aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id']."
					UNION All
					SELECT parent_aliquot_master_id as aliquot_master_id FROM $chumoncoaxis_db_schema.realiquotings WHERE deleted <> 1 AND parent_aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id']."
					UNION All
					SELECT child_aliquot_master_id as aliquot_master_id FROM $chumoncoaxis_db_schema.realiquotings WHERE deleted <> 1 AND child_aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id']."
					UNION All
					SELECT aliquot_master_id FROM $chumoncoaxis_db_schema.quality_ctrls WHERE deleted <> 1 AND aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id']."
					UNION All
					SELECT aliquot_master_id FROM $chumoncoaxis_db_schema.order_items WHERE deleted <> 1 AND aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id']."
					UNION All
					SELECT aliquot_master_id FROM $chumoncoaxis_db_schema.aliquot_review_masters WHERE deleted <> 1 AND aliquot_master_id = ".$atim_oncologyaxis_block_data['aliquot_master_id'];
				if(getSelectQueryResult($block_use_check_query)) {
					//ALiquot defined as used
ajouter un message et devra etre fait a bras 
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "Aliquot linked to an aliquot use data in Oncology Axis ATiM (internal use, or QC, or order, etc) :: Block won't be moved to PROCURE ATiM.", "See block '$xls_procure_barcode' (aliquot_master_id ".$atim_oncologyaxis_block_data['aliquot_master_id'].") in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
					$move_to_atim_procure = false;
				}
				
				if($xls_storage_selection_label != $atim_oncologyaxis_block_data['selection_label'] || $xls_storage_coord_x != $atim_oncologyaxis_block_data['storage_coord_x']) {
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Initial block position mismatch :: But aliquot move should be done (to check).", "See excel value '$xls_storage_selection_label (pos#$xls_storage_coord_x)' and ATiM value '".$atim_oncologyaxis_block_data['selection_label']." (pos#".$atim_oncologyaxis_block_data['storage_coord_x'].")' for the block '$xls_procure_barcode'.");
				}
				
				if(!$xls_new_storage_selection_label) {
					$move_to_atim_procure = false;
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "No box defined :: Both the value clean up (no patho, etc) and the aliquot move won't be done. To do manually after update process.", "See block '$xls_procure_barcode' in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
				}
				
				if(!$xls_new_storage_coord_x || !preg_match('/^(([1-9])|(1[0-9])|(2[0-7]))$/', $xls_new_storage_coord_x)) {
					$move_to_atim_procure = false;
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "No or wrong box position defined :: Both the value clean up (no patho, etc) and aliquot move won't be done. To do manually after update process.", "See block '$xls_procure_barcode' in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
				}
				
				// 2 - Look for ATiM PROCURE tissue matching or create a new one
						
				$procure_participant_id = null;
				$procure_collection_id = null;
				$procure_sample_master_id = null;
				$procure_no_labo = '';
				$procure_participant_identifier = '';
				$procure_report_number = '';
				$procure_nopatho_identifier_value = '';
				
				$is_new_tissue = false;
				
				if($move_to_atim_procure) {
					$procure_db_query = "SELECT
						p.id as participant_id,
						p.participant_identifier,
						col.id AS collection_id,
						sam.id as sample_master_id,
						mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
						mid_nopatho.identifier_value as 'mid_nopatho_identifier_value',
						sd.procure_report_number
						FROM $procure_db_schema.sample_masters sam
						INNER JOIN $procure_db_schema.sd_spe_tissues sd ON sd.sample_master_id = sam.id
						INNER JOIN $procure_db_schema.collections col ON col.id = sam.collection_id
						INNER JOIN $procure_db_schema.participants p ON p.id = col.participant_id
						INNER JOIN $procure_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
						LEFT JOIN $procure_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
						WHERE sam.deleted <> 1 
						AND mid_nolabo.identifier_value = '".$atim_oncologyaxis_block_data['mid_nolabo_identifier_value']."'
						AND  col.procure_visit = 'V01';";
					$procure_tissue = getSelectQueryResult($procure_db_query);
					if($procure_tissue) {
						//Matches on visit, sample type and NoLabo
						if(sizeof($procure_tissue) != 1) die('ERR 23 76287 26872 36');
						$procure_tissue_data = $procure_tissue[0];
						$procure_participant_id = $procure_tissue_data['participant_id'];
						$procure_collection_id = $procure_tissue_data['collection_id'];
						$procure_sample_master_id = $procure_tissue_data['sample_master_id'];
						$procure_no_labo = $procure_tissue_data['mid_nolabo_identifier_value'];
						$procure_participant_identifier = $procure_tissue_data['participant_identifier'];
						$procure_report_number = $procure_tissue_data['procure_report_number'];
						$procure_nopatho_identifier_value = $procure_tissue_data['mid_nopatho_identifier_value'];
						//We won't compare information: Just make a list for Claudia
						if($atim_oncologyaxis_block_data['sample_master_id'] == $procure_sample_master_id) {
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@MESSAGE@@', "Sample tissue found with sample_master_ids match :: Note system did not compare collection and sample information excepted visit and no labo.", $atim_oncologyaxis_block_data['mid_nolabo_identifier_value'], $atim_oncologyaxis_block_data['mid_nolabo_identifier_value']);
						} else {
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@MESSAGE@@', "Sample tissue found but sample_master_ids different :: Note system did not compare collection and sample information excepted visit and no labo.", $atim_oncologyaxis_block_data['mid_nolabo_identifier_value'], $atim_oncologyaxis_block_data['mid_nolabo_identifier_value']);
						}
					} else {
						//No tissue match on visit, sample type and NoLabo : Create collection then tissue if participant exists.
						$procure_db_query = "SELECT
							p.id as participant_id,
							p.participant_identifier,
							mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
							mid_nopatho.identifier_value as 'mid_nopatho_identifier_value'
							FROM $procure_db_schema.participants p
							INNER JOIN $procure_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
							LEFT JOIN $procure_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
							WHERE p.deleted <> 1 
							AND mid_nolabo.identifier_value = '".$atim_oncologyaxis_block_data['mid_nolabo_identifier_value']."';";
						$procure_participant = getSelectQueryResult($procure_db_query);
						if(!$procure_participant) {
							$move_to_atim_procure = false;
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "Participant unknown in procure database :: Participant of a block listed in oncology axis database can not be found in procure database. Block won't be moved.", "See participant ".$atim_oncologyaxis_block_data['mid_nolabo_identifier_value']." of the block $xls_procure_barcode defined in excel as stored in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
						} else {
							if(sizeof($procure_participant) != 1) die('ERR 23 76287 26872eeee');
							$is_new_tissue = true;
							$procure_participant_data = $procure_participant[0];
							$procure_participant_id = $procure_participant_data['participant_id'];
							$procure_no_labo = $procure_participant_data['mid_nolabo_identifier_value'];
							$procure_participant_identifier = $procure_participant_data['participant_identifier'];
							$procure_report_number = $procure_participant_data['mid_nopatho_identifier_value'];
							$procure_nopatho_identifier_value = $procure_participant_data['mid_nopatho_identifier_value'];
							$procure_collection_data = array(
								'collections' => array(
									'participant_id' => $procure_participant_id,
									'procure_visit' => 'V01',
									'procure_collected_by_bank' => '1',
									'collection_datetime' => $atim_oncologyaxis_block_data['collection_datetime'],
									'collection_datetime_accuracy' => $atim_oncologyaxis_block_data['collection_datetime_accuracy'],
									'collection_site' => $atim_oncologyaxis_block_data['collection_site'],
									'collection_notes' => $atim_oncologyaxis_block_data['collection_notes']));
							$procure_collection_id = customInsertRecord($procure_collection_data, $procure_db_schema);
							$procure_sample_data = array(
								'sample_masters' => array(
									'sample_control_id' => $atim_controls[$procure_db_schema]['sample_controls']['tissue']['id'],
									'collection_id' => $procure_collection_id,
									'notes' => $atim_oncologyaxis_block_data['sample_notes'],
									'procure_created_by_bank' => '1'),
								'specimen_details' => array(
									'supplier_dept' => $atim_oncologyaxis_block_data['supplier_dept'],
									'time_at_room_temp_mn' => $atim_oncologyaxis_block_data['time_at_room_temp_mn'],
									'reception_by' => $atim_oncologyaxis_block_data['reception_by'],
									'reception_datetime' => $atim_oncologyaxis_block_data['reception_datetime'],
									'reception_datetime_accuracy' => $atim_oncologyaxis_block_data['reception_datetime_accuracy']),
								'sd_spe_tissues' => array(
									'procure_report_number' => $procure_report_number,
									'tissue_size' => $atim_oncologyaxis_block_data['tissue_size'],
									'tissue_size_unit' => $atim_oncologyaxis_block_data['tissue_size_unit'],
									'tissue_weight' => $atim_oncologyaxis_block_data['tissue_weight'],
									'tissue_weight_unit' => $atim_oncologyaxis_block_data['tissue_weight_unit'],
									'procure_transfer_to_pathology_on_ice' => $atim_oncologyaxis_block_data['tmp_on_ice']));
							$procure_sample_master_id = customInsertRecord($procure_sample_data, $procure_db_schema);
							recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: New collection & tissue (no tissue found in procure database)", 'See '.$atim_oncologyaxis_block_data['mid_nolabo_identifier_value'], $atim_oncologyaxis_block_data['mid_nolabo_identifier_value']);
						}
					}
				}
					
				if($move_to_atim_procure) {
						
					// 3 - Check data integrity
				
					//Checo PSP number (won't use this one recorded in onco axis)
					if($xls_procure_participant_identifier && $xls_procure_participant_identifier != $procure_participant_identifier)
						recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Identification (part.) mismatch  :: Aliquot move will be done but the identification clean up won't be. To do manually after update process.", ("See excel value '$xls_procure_participant_identifier' and PROCURE ATiM value '$procure_participant_identifier' for the block '$xls_procure_barcode'. "));
							
					//Checks on no labo (onco axis value = procure value)
					if($xls_no_labo != $procure_no_labo) die('ERR 23 7862387 6287623 11');
					
					$procure_patho_report_number = array(
						trim($xls_patho_misc_identifier), 
						trim($xls_procure_sd_procure_report_number), 
						trim($atim_oncologyaxis_block_data['mid_nopatho_identifier_value']), 
						trim($atim_oncologyaxis_block_data['patho_dpt_block_code']),
						trim($procure_report_number), 
						trim($procure_nopatho_identifier_value));
					$procure_patho_report_number = array_filter($procure_patho_report_number);
					$procure_patho_report_number = array_unique($procure_patho_report_number);
					$record_mid_nopatho_identifier_value = false;
					$update_procure_report_number = false;
					if($procure_patho_report_number) {
						$procure_patho_report_number = array_values($procure_patho_report_number);
						if(sizeof($procure_patho_report_number) == '2' && ($procure_patho_report_number[0] == ('0'.$procure_patho_report_number[1]) || $procure_patho_report_number[1] == ('0'.$procure_patho_report_number[0]))) {
							//989239 == 0989239
							unset($procure_patho_report_number[1]);
						}
						if(sizeof($procure_patho_report_number) == '1') {
							$procure_patho_report_number = array_shift($procure_patho_report_number);
							if(empty($procure_nopatho_identifier_value)) {
								//Create participant 'Patho Identifier'
								$record_mid_nopatho_identifier_value = true;
							}
							if(empty($procure_report_number)) {
								//Create tissue 'Report#'
								$update_procure_report_number = true;
							}
						} else {
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "More than one pathology report number :: Aliquot move will be done but the patho number clean up won't be. To do manually after update process.", "More than one number exist ('".implode("', '", $procure_patho_report_number)."') for the block '$xls_procure_barcode'. Check excel data plus participant 'Patho Identifier' in both ATiMs (participant, sample and aliquot levels).");
						}
					}	
					
					$procure_freezing_type = 'OCT';
					switch($atim_oncologyaxis_block_data['block_type']) {
						case 'OCT':
							break;
						case 'isopentane + OCT':
							$procure_freezing_type = 'ISO+OCT';
							break;
						default:
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Unknwon Block Type :: Value will be set to OCT.", "See type '".$atim_oncologyaxis_block_data['block_type']."' in Onco Axis ATiM More for the block '$xls_procure_barcode'.");
					}
					
					$procure_origin_of_slice = '';
					switch($xls_procure_origin_of_slice) {
						case 'LA':
						case 'LP':
						case 'RA':
						case 'RP':
						case '':
							break;
						case 'frozen':
							$xls_procure_origin_of_slice = '';
							break;
						default:
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Unknwon Excel Origin Of Slice :: Aliquot move will be done but this value won't be taken in consideration.", "See value '$xls_procure_origin_of_slice' in Excel for the block '$xls_procure_barcode'.");
							$xls_procure_origin_of_slice = '';
					}
					if($atim_oncologyaxis_block_data['procure_origin_of_slice']) {
						if($xls_procure_origin_of_slice && $atim_oncologyaxis_block_data['procure_origin_of_slice'] != $xls_procure_origin_of_slice) {
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Origin of Slice Mismatch :: Move will be done and system will use ATiM Oncology Axis Value.", "See excel value '$xls_procure_origin_of_slice' and ATiM value '".$atim_oncologyaxis_block_data['procure_origin_of_slice']."' for the block '$xls_procure_barcode'.");	
						}
						$procure_origin_of_slice = $atim_oncologyaxis_block_data['procure_origin_of_slice'];
					} else if($xls_procure_origin_of_slice) {
						$procure_origin_of_slice = $xls_procure_origin_of_slice;
						recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@MESSAGE@@', "Use of Excel Origin of Slice (ATiM Oncology Axis value is not set).", "See excel value '$xls_procure_origin_of_slice' for the block '$xls_procure_barcode'.");
					}					
					
					// 4 -Block Creation
					
					if(!isset($new_procure_box_master_ids[$xls_new_storage_selection_label])) {
						//Create box
						$storage_data = array(
							'storage_masters' => array(
								'storage_control_id' => $atim_controls[$procure_db_schema]['storage_controls']['box27']['id'],
								'code' => 'tmp_'.sizeof($new_procure_box_master_ids),
								'short_label' => $xls_new_storage_selection_label,
								'selection_label' => $xls_new_storage_selection_label,
								'lft' => ($max_rght++),
								'rght' => ($max_rght++)),
							$atim_controls[$procure_db_schema]['storage_controls']['box27']['detail_tablename'] => array());
						$new_procure_box_master_ids[$xls_new_storage_selection_label] = customInsertRecord($storage_data, $procure_db_schema);
						customQuery("UPDATE $procure_db_schema.storage_masters SET code = id WHERE code LIKE 'tmp%'");
						$diagnosis_data_to_update = array(
							'storage_masters' => array('code' => $new_procure_box_master_ids[$xls_new_storage_selection_label]),
							$atim_controls[$procure_db_schema]['storage_controls']['box27']['detail_tablename'] => array());
						updateTableData($new_procure_box_master_ids[$xls_new_storage_selection_label], $diagnosis_data_to_update, $procure_db_schema);
						recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Box creation", $xls_new_storage_selection_label);
					}					
					
					
					$bloc_frz_id = 1;
					if(!$is_new_tissue) {
						$query_frz = "SELECT MAX(SUBSTRING(am.barcode,18) + 0) AS max_frz
							FROM $procure_db_schema.aliquot_masters am
							INNER JOIN $procure_db_schema.sample_masters sam ON sam.id = am.sample_master_id
							INNER JOIN $procure_db_schema.collections col ON col.id = sam.collection_id
							WHERE am.deleted <> 1 AND col.participant_id = $procure_participant_id AND am.barcode LIKE '$procure_participant_identifier V01 -FRZ%';";
						$max_frz = getSelectQueryResult($query_frz);
						if($max_frz[0]['max_frz']) $bloc_frz_id = ($max_frz[0]['max_frz'] + 1);
					}
					
					$aliquot_data = array(
						'aliquot_masters' => array(
							'collection_id' => $procure_collection_id,
							'sample_master_id' => $procure_sample_master_id,
							'barcode' => "$procure_participant_identifier V01 -FRZ$bloc_frz_id", 
							'aliquot_label' => $atim_oncologyaxis_block_data['aliquot_label'], 
							'aliquot_control_id' => $atim_controls[$procure_db_schema]['aliquot_controls']['tissue-block']['id'], 
							'in_stock' => $sent_to_processing_site? 'yes - not available' : $atim_oncologyaxis_block_data['in_stock'],  
							'in_stock_detail' => $atim_oncologyaxis_block_data['in_stock_detail'], 
							'use_counter' => $sent_to_processing_site? '1' : '0', 
							'storage_master_id' => $new_procure_box_master_ids[$xls_new_storage_selection_label], 
							'storage_coord_x' => $xls_new_storage_coord_x, 
							'storage_datetime' => $atim_oncologyaxis_block_data['storage_datetime'],
							'storage_datetime_accuracy' => $atim_oncologyaxis_block_data['storage_datetime_accuracy'], 
							'qc_nd_stored_by' => $atim_oncologyaxis_block_data['stored_by'],  
							'notes' => (strlen($xls_tissue_type_note_from_nowhere)? "Tissue Type = '$xls_tissue_type_note_from_nowhere'. ": '').$atim_oncologyaxis_block_data['aliquot_notes'],
							'procure_created_by_bank' => '1'),  
						$atim_controls[$procure_db_schema]['aliquot_controls']['tissue-block']['detail_tablename'] => array(
							'block_type' => 'frozen',
							'procure_freezing_type' => $procure_freezing_type,
							'procure_origin_of_slice' => $procure_origin_of_slice,
							'qc_nd_sample_position_code' => $atim_oncologyaxis_block_data['sample_position_code'],
							'qc_nd_gleason_primary_grade' => $atim_oncologyaxis_block_data['tmp_gleason_primary_grade'],
							'qc_nd_gleason_secondary_grade' => $atim_oncologyaxis_block_data['tmp_gleason_secondary_grade'],
							'qc_nd_tissue_primary_desc' => $atim_oncologyaxis_block_data['tmp_tissue_primary_desc'],
							'qc_nd_tissue_secondary_desc' => $atim_oncologyaxis_block_data['tmp_tissue_secondary_desc'],
							'qc_nd_tumor_presence' => $atim_oncologyaxis_block_data['tumor_presence']));
					$aliquot_master_id = customInsertRecord($aliquot_data, $procure_db_schema);
					recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Created new Block (validate new identification)", "$procure_participant_identifier V01 -FRZ$bloc_frz_id (".$atim_oncologyaxis_block_data['aliquot_label'].") in $xls_new_storage_selection_label position $xls_new_storage_coord_x");

					
Si dans icm on a deja -FRZ[0-9] le garder dans procure
attention bien reconstrauire le label mais garder le -FRZ
IF(preg_match('/\FRZ/', $atim_oncologyaxis_block_data['aliquot_label'])) recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Renamed -FRZ aliquot label :: Please validate", $atim_oncologyaxis_block_data['aliquot_label']." identification changed to $procure_participant_identifier V01 -FRZ$bloc_frz_id");
						
					// Sent to processing site :: Add aliquot internal use
					if($sent_to_processing_site) {
						$internal_use_data = array(
							'aliquot_internal_uses' => array(
								'use_code' => 'Temporaire',
								'type' => 'sent to processing site',
								'aliquot_master_id' => $aliquot_master_id,
								'procure_created_by_bank' => '1'));
						customInsertRecord($internal_use_data, $procure_db_schema);
						recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Internal Use 'sent to processing site' creation", "For $procure_participant_identifier V01 -FRZ$bloc_frz_id (".$atim_oncologyaxis_block_data['aliquot_label'].")");
					}
	
					// Recrod participant 'Patho Identifier'
					if($record_mid_nopatho_identifier_value) {
						$id_query = "SELECT id FROM $procure_db_schema.misc_identifiers WHERE identifier_value = '$procure_patho_report_number' AND misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id']." AND deleted <> 1;";
						if(getSelectQueryResult($id_query)) {
							recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@WARNING@@', "Duplicated participant 'Patho Identifier' :: Code already assigned to a patient. No new record. Please check conflict.", "$procure_patho_report_number for patient '$procure_participant_identifier' of the block '$xls_procure_barcode'.");
						} else {
							$misc_identifier_data = array(
								'misc_identifiers' => array(
									'identifier_value' => $procure_patho_report_number,
									'participant_id' => $procure_participant_id,
									'misc_identifier_control_id' => $atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id'],
									'flag_unique' => $atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['flag_unique']));
							customInsertRecord($misc_identifier_data, $procure_db_schema);
							recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Recorded missing participant 'Patho Identifier'.", "$procure_patho_report_number for patient '$procure_participant_identifier' of the block '$xls_procure_barcode'.");	
						}
					}
						
					// Record the procure tissue report number
					if($update_procure_report_number) {
						$sample_master_data_to_update = array(
							'sample_masters' => array(),
							'sd_spe_tissues' => array('procure_report_number' => $procure_patho_report_number));
						updateTableData($sample_master_id, $sample_master_data_to_update, $procure_db_schema);
						if(!$is_new_tissue) recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Recorded missing tissue 'Report#'.", "$procure_patho_report_number for tissue of the block '$xls_procure_barcode'.");
					}

					// 5 - Delete Onco Axis Block
					
					$aliquot_master_data_to_update = array(
						'aliquot_masters' => array('deleted' => '1'),
						'ad_blocks' => array());
					updateTableData($atim_oncologyaxis_block_data['aliquot_master_id'], $aliquot_master_data_to_update, $chumoncoaxis_db_schema);
					recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "ONCO-AXIS :: Deleted aliquot", "$xls_procure_barcode");
					
					$check_sample_query = "SELECT CONCAT('Alq#',id) as record FROM $chumoncoaxis_db_schema.aliquot_masters WHERE sample_master_id = ".$atim_oncologyaxis_block_data['sample_master_id']." AND deleted <> 1
						UNION ALL 
						SELECT CONCAT('Qc#',id) as record FROM $chumoncoaxis_db_schema.quality_ctrls WHERE sample_master_id = ".$atim_oncologyaxis_block_data['sample_master_id']." AND deleted <> 1
						UNION ALL 
						SELECT CONCAT('SpRev#',id) as record FROM $chumoncoaxis_db_schema.specimen_review_masters WHERE sample_master_id = ".$atim_oncologyaxis_block_data['sample_master_id']." AND deleted <> 1
						UNION ALL 
						SELECT CONCAT('Sam#',id) as record FROM $chumoncoaxis_db_schema.sample_masters WHERE parent_id = ".$atim_oncologyaxis_block_data['sample_master_id']." AND deleted <> 1";
					$check_sample_result = getSelectQueryResult($check_sample_query);
					if(!$check_sample_result) {
						$sample_master_data_to_update = array(
							'sample_masters' => array('deleted' => '1'),
							'sd_spe_tissues' => array());
						updateTableData($atim_oncologyaxis_block_data['sample_master_id'], $sample_master_data_to_update, $chumoncoaxis_db_schema);
						recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "ONCO-AXIS :: Deleted sample", $atim_oncologyaxis_block_data['qc_nd_sample_label']);
						$check_collection_result = getSelectQueryResult("SELECT id FROM $chumoncoaxis_db_schema.sample_masters WHERE collection_id = ".$atim_oncologyaxis_block_data['collection_id']." AND deleted <> 1");
						if(!$check_collection_result) {
							$collection_data_to_update = array('collections' => array('deleted' => '1'));
							updateTableData($atim_oncologyaxis_block_data['collection_id'], $collection_data_to_update, $chumoncoaxis_db_schema);
							recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "ONCO-AXIS :: Deleted collection", "$procure_participant_identifier ".$atim_oncologyaxis_block_data['visit_label']." (".$atim_oncologyaxis_block_data['collection_id'].")");
						}
					}					
				}
			} else if(sizeof($atim_oncologyaxis_block) > 1) {
				$barcodes = array();
				foreach($atim_oncologyaxis_block as $new_block) $barcodes[] = $new_block['barcode'];
				if(!$atim_oncologyaxis_block_based_on_position) {
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "More than one block in database with same label but no one stored in defined position :: Block won't be moved to PROCURE ATiM. Note that the check has been done on identification + position.", "$xls_procure_barcode defined in excel as stored in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'. See aliquot_master_ids : ".implode(',', $barcodes));
				} else {
					recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "More than one block in database in same postion :: Block won't be moved to PROCURE ATiM. Note that the check has been done on identification + position.", "$xls_procure_barcode defined in excel as stored in '$xls_storage_selection_label (pos#$xls_storage_coord_x)' See aliquot_master_ids : ".implode(',', $barcodes));
				}			
			} else {
				recordErrorAndMessage('Oncology Axis Block Move To PROCURE', '@@ERROR@@', "Block not found in database :: Block won't be moved to PROCURE ATiM. Note that check is done based on [identification + position] or [identification only].", "$xls_procure_barcode defined in excel as stored in '$xls_storage_selection_label (pos#$xls_storage_coord_x)'");
			}
		}	
	}
}

//*** BLOCK IN PROCURE TO MOVE IN ATiM ONCO AXIS ***

if($new_procure_box_master_ids) {
	$bank = getSelectQueryResult("SELECT id FROM $chumoncoaxis_db_schema.banks WHERE name = 'Prostate'");
	if(!$bank) die('ERR 23 2332 3');
	$onco_axis_bank_id = $bank[0]['id'];

	$studied_onco_axis_boxes = array('' => array('id' => ''));

	$query = "SELECT
		p.id as participant_id,
		col.id AS collection_id,
		sam.id as sample_master_id,
		am.id as aliquot_master_id,
		mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
		mid_nopatho.identifier_value as 'mid_nopatho_identifier_value',
		col.*,
		sam.*,
		sam.notes AS sample_notes,
		spd.*,
		sd.*,
		stm.selection_label,
		stc.storage_type,
		am.*,
		am.notes AS aliquot_notes,
		ad.*
		FROM $procure_db_schema.ad_blocks ad
		INNER JOIN $procure_db_schema.aliquot_masters am ON am.id = ad.aliquot_master_id
		INNER JOIN $procure_db_schema.sample_masters sam ON sam.id = am.sample_master_id
		INNER JOIN $procure_db_schema.specimen_details spd ON spd.sample_master_id = sam.id
		INNER JOIN $procure_db_schema.sd_spe_tissues sd ON sd.sample_master_id = sam.id
		INNER JOIN $procure_db_schema.collections col ON col.id = sam.collection_id
		INNER JOIN $procure_db_schema.participants p ON p.id = col.participant_id
		LEFT JOIN $procure_db_schema.storage_masters stm ON stm.id = am.storage_master_id
		LEFT JOIN $procure_db_schema.storage_controls stc ON stc.id = stm.storage_control_id
		LEFT JOIN $procure_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
		LEFT JOIN $procure_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$procure_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
		WHERE am.deleted <> 1 AND (ad.block_type = 'frozen' OR ad.procure_freezing_type IN ('OCT', 'ISO+OCT'))
		AND (am.storage_master_id IS NULL OR am.storage_master_id LIKE '' OR am.storage_master_id NOT IN (".implode(',',$new_procure_box_master_ids)."))
		ORDER BY am.barcode;";
	foreach(getSelectQueryResult($query) as $new_procure_block_data_to_move) {
		
		// 1 - Check block can be moved
		
		$move_to_atim_onco = true;
		
		$block_use_check_query = "SELECT aliquot_master_id FROM $procure_db_schema.aliquot_internal_uses WHERE deleted <> 1 AND aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."
			UNION All
			SELECT aliquot_master_id FROM $procure_db_schema.source_aliquots WHERE deleted <> 1 AND aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."
			UNION All
			SELECT parent_aliquot_master_id as aliquot_master_id FROM $procure_db_schema.realiquotings WHERE deleted <> 1 AND parent_aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."
			UNION All
			SELECT child_aliquot_master_id as aliquot_master_id FROM $procure_db_schema.realiquotings WHERE deleted <> 1 AND child_aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."
			UNION All
			SELECT aliquot_master_id FROM $procure_db_schema.quality_ctrls WHERE deleted <> 1 AND aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."
			UNION All
			SELECT aliquot_master_id FROM $procure_db_schema.order_items WHERE deleted <> 1 AND aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."
			UNION All
			SELECT aliquot_master_id FROM $procure_db_schema.aliquot_review_masters WHERE deleted <> 1 AND aliquot_master_id = ".$new_procure_block_data_to_move['aliquot_master_id']."";
		if(getSelectQueryResult($block_use_check_query)) {
			//ALiquot defined as used
le block deviendra pas disponible dans procure mais il faudra le créér...	
car ils ont tt de memme eté envoyé a procure... on ne veut pas casser la chaine
			recordErrorAndMessage('PROCURE Block Move To Oncology Axis', '@@ERROR@@', "Aliquot linked to an aliquot use data in PROCURE ATiM (internal use, or QC, or order, etc) :: Block won't be moved to Onco Axis ATiM.", "See block '".$new_procure_block_data_to_move['barcode']."'");
			$move_to_atim_onco = false;
		}
		
		if($new_procure_block_data_to_move['selection_label']) {
			if(!isset($studied_onco_axis_boxes[$new_procure_block_data_to_move['selection_label']])) {
				//Check onco axis storage exists
				$storage_query = "SELECT storage_masters.id, storage_type FROM $chumoncoaxis_db_schema.storage_masters INNER JOIN $chumoncoaxis_db_schema.storage_controls ON storage_masters.storage_control_id = storage_controls.id WHERE deleted <> 1 AND selection_label = '".$new_procure_block_data_to_move['selection_label']."';";
				$storage = getSelectQueryResult($storage_query);
				if($storage) {
					if(sizeof($storage) > 1) die('ERR "3 232 32 32 23');
					$studied_onco_axis_boxes[$new_procure_block_data_to_move['selection_label']] = array('id' => $storage['0']['id'], 'type' => $storage['0']['storage_type']);
				} else {
					recordErrorAndMessage('PROCURE Block Move To Oncology Axis', '@@ERROR@@', "Aliquot stored in a PROCURE box that does not exist in Onco Axis :: Block won't be moved to Onco Axis ATiM.", "See block '".$new_procure_block_data_to_move['barcode']."' and box ".$new_procure_block_data_to_move['selection_label'].".");
					$move_to_atim_onco = false;
				}			
			}
			if(isset($studied_onco_axis_boxes[$new_procure_block_data_to_move['selection_label']]) && $studied_onco_axis_boxes[$new_procure_block_data_to_move['selection_label']]['type'] != $new_procure_block_data_to_move['storage_type']) {
				//Check same type of box
				die('ERR 2387 6287623876 238723');
			}
		} else if($new_procure_block_data_to_move['storage_coord_x']) {
			die('ERR 23 23 23');
		}
		
		// 2 - Look for ATiM ONCO tissue matching or create a new one
		
		$procure_sample_master_id_to_onco_data = array();
		
		if($move_to_atim_onco && !isset($procure_sample_master_id_to_onco_data[$new_procure_block_data_to_move['sample_master_id']])) {
			$onco_nopatho_identifier_value = null;
			$onco_collection_id = null;
			//Look for tissue collection
			$onco_db_query = "SELECT DISTINCT
				p.id as participant_id,
				p.participant_identifier,
				col.id AS collection_id,
				mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
				mid_nopatho.identifier_value as 'mid_nopatho_identifier_value'
				FROM $chumoncoaxis_db_schema.sample_masters sam
				INNER JOIN $chumoncoaxis_db_schema.sd_spe_tissues sd ON sd.sample_master_id = sam.id
				INNER JOIN $chumoncoaxis_db_schema.collections col ON col.id = sam.collection_id
				INNER JOIN $chumoncoaxis_db_schema.participants p ON p.id = col.participant_id
				INNER JOIN $chumoncoaxis_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$chumoncoaxis_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
				LEFT JOIN $chumoncoaxis_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$chumoncoaxis_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
				WHERE sam.deleted <> 1
				AND mid_nolabo.identifier_value = '".$new_procure_block_data_to_move['mid_nolabo_identifier_value']."'
				AND col.visit_label = '".$new_procure_block_data_to_move['procure_visit']."'
				AND col.bank_id = $onco_axis_bank_id
				AND col.collection_site = '".$new_procure_block_data_to_move['collection_site']."'
				AND col.collection_datetime = '".$new_procure_block_data_to_move['collection_datetime']."'
				AND col.collection_datetime_accuracy = '".$new_procure_block_data_to_move['collection_datetime_accuracy']."';";
			$onco_tissue_collection = getSelectQueryResult($onco_db_query);
			if($onco_tissue_collection) {
				//Collection found
				$onco_nopatho_identifier_value = $onco_tissue_collection[0]['mid_nopatho_identifier_value'];
				$onco_collection_id = $onco_tissue_collection[0]['collection_id'];
			} else {
				//Collection not found
				$onco_db_query = "SELECT
					p.id as participant_id,
					p.participant_identifier,
					mid_nolabo.identifier_value as 'mid_nolabo_identifier_value',
					mid_nopatho.identifier_value as 'mid_nopatho_identifier_value'
					FROM $chumoncoaxis_db_schema.participants p
					INNER JOIN $chumoncoaxis_db_schema.misc_identifiers mid_nolabo ON mid_nolabo.participant_id = p.id AND mid_nolabo.deleted <> 1 AND mid_nolabo.misc_identifier_control_id = ".$atim_controls[$chumoncoaxis_db_schema]['misc_identifier_controls']['prostate bank no lab']['id']."
					LEFT JOIN $chumoncoaxis_db_schema.misc_identifiers mid_nopatho ON mid_nopatho.participant_id = p.id AND mid_nopatho.deleted <> 1 AND mid_nopatho.misc_identifier_control_id = ".$atim_controls[$chumoncoaxis_db_schema]['misc_identifier_controls']['participant patho identifier']['id']."
					WHERE p.deleted <> 1
					AND mid_nolabo.identifier_value = '".$new_procure_block_data_to_move['mid_nolabo_identifier_value']."';";
				$onco_participant = getSelectQueryResult($onco_db_query);
				if(!$onco_participant) {
					$move_to_atim_onco = false;
					recordErrorAndMessage('PROCURE Block Move To Oncology Axis', '@@ERROR@@', "Participant unknown in onco axis database :: Block won't be moved.", "See PROCURE participant ".$new_procure_block_data_to_move['mid_nolabo_identifier_value']." of the block ".$new_procure_block_data_to_move['barcode'].".");
				} else {
					if(sizeof($onco_participant) != 1) die('ERR 88588885');
					$onco_nopatho_identifier_value = $onco_participant[0]['mid_nopatho_identifier_value'];
					//Create collection
					$onco_collection_data = array(
						'collections' => array(
							'participant_id' => $onco_participant[0]['participant_id'],
							'acquisition_label' => $new_procure_block_data_to_move['mid_nolabo_identifier_value']." ".$new_procure_block_data_to_move['procure_visit']." (Created by procure blocks clean up)",
							'visit_label' => $new_procure_block_data_to_move['procure_visit'],
							'bank_id' => $onco_axis_bank_id,
							'collection_datetime' => $new_procure_block_data_to_move['collection_datetime'],
							'collection_datetime_accuracy' => $new_procure_block_data_to_move['collection_datetime_accuracy'],
							'collection_site' => $new_procure_block_data_to_move['collection_site'],
							'collection_notes' => $new_procure_block_data_to_move['collection_notes']));
					$onco_collection_id = customInsertRecord($onco_collection_data, $chumoncoaxis_db_schema);
					recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "ONCO-AXIS :: New collection (no Onco Axis Tissue collection with same info exists)", 'See '.$new_procure_block_data_to_move['mid_nolabo_identifier_value']." ".$new_procure_block_data_to_move['procure_visit']);	
				}
			}
			if($onco_collection_id) {
				$onco_sample_data = array(
					'sample_masters' => array(
						'qc_nd_sample_label' => "PR - ".$new_procure_block_data_to_move['mid_nolabo_identifier_value']." n/a",
						'sample_control_id' => $atim_controls[$chumoncoaxis_db_schema]['sample_controls']['tissue']['id'],
						'collection_id' => $onco_collection_id,
						'notes' => $new_procure_block_data_to_move['sample_notes']),
					'specimen_details' => array(
						'supplier_dept' => $new_procure_block_data_to_move['supplier_dept'],
						'time_at_room_temp_mn' => $new_procure_block_data_to_move['time_at_room_temp_mn'],
						'reception_by' => $new_procure_block_data_to_move['reception_by'],
						'reception_datetime' => $new_procure_block_data_to_move['reception_datetime'],
						'reception_datetime_accuracy' => $new_procure_block_data_to_move['reception_datetime_accuracy'],
						'type_code' => 'PR'),
					'sd_spe_tissues' => array(
						'tissue_nature' => 'unknown',
						'tissue_size' => $new_procure_block_data_to_move['tissue_size'],
						'tissue_size_unit' => $new_procure_block_data_to_move['tissue_size_unit'],
						'tissue_weight' => $new_procure_block_data_to_move['tissue_weight'],
						'tissue_weight_unit' => $new_procure_block_data_to_move['tissue_weight_unit'],
						'tmp_on_ice' => $new_procure_block_data_to_move['procure_transfer_to_pathology_on_ice']));
				$onco_sample_master_id = customInsertRecord($onco_sample_data, $chumoncoaxis_db_schema);
				recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "ONCO-AXIS :: New tissue (Aliquot move from procure to onco axis will be linked to a new tissue)", "See PR -  ".$new_procure_block_data_to_move['mid_nolabo_identifier_value']." n/a ($onco_sample_master_id)");
				$procure_sample_master_id_to_onco_data[$new_procure_block_data_to_move['sample_master_id']] = array($onco_collection_id, $onco_sample_master_id, $onco_nopatho_identifier_value);
			}
		}
		
		if($move_to_atim_onco) {
		
			list($onco_collection_id, $onco_sample_master_id, $onco_nopatho_identifier_value) = $procure_sample_master_id_to_onco_data[$new_procure_block_data_to_move['sample_master_id']];
					
			// 3 - Check data integrity
		
			$onco_patho_report_number = array(
				trim($onco_nopatho_identifier_value),
				trim($new_procure_block_data_to_move['mid_nopatho_identifier_value']),
				trim($new_procure_block_data_to_move['procure_sample_number']),
				trim($new_procure_block_data_to_move['procure_report_number']));
			$onco_patho_report_number = array_filter($onco_patho_report_number);
			$onco_patho_report_number = array_unique($onco_patho_report_number);
			if($onco_patho_report_number) {
				$onco_patho_report_number = array_values($onco_patho_report_number);
				if(sizeof($onco_patho_report_number) == '2' && ($onco_patho_report_number[0] == ('0'.$onco_patho_report_number[1]) || $onco_patho_report_number[1] == ('0'.$onco_patho_report_number[0]))) {
					//989239 == 0989239
					unset($onco_patho_report_number[1]);
				}
				if(sizeof($onco_patho_report_number) == '1') {
					$onco_patho_report_number = array_shift($onco_patho_report_number);
					if(empty($onco_nopatho_identifier_value)) {
						recordErrorAndMessage('PROCURE Block Move To Oncology Axis', '@@WARNING@@', "Participant patho idetifiers missing in Onco Axis :: To complete manually.", "$onco_nopatho_identifier_value for participant ".$new_procure_block_data_to_move['mid_nolabo_identifier_value']);
					}
				} else {
					recordErrorAndMessage('PROCURE Block Move To Oncology Axis', '@@WARNING@@', "More than one pathology report number :: Please check all patho report number values.", "More than one number exist ('".implode("', '", $onco_patho_report_number)."') for the block '$xls_procure_barcode'. Check participant 'Patho Identifier' in both ATiMs (participant, sample and aliquot levels).");
					$onco_patho_report_number = '';
				}
			} else {
				$onco_patho_report_number = '';
			}
			
			if($new_procure_block_data_to_move['block_type'] != 'frozen')
			$onco_block_type = 'OCT';
			switch($new_procure_block_data_to_move['procure_freezing_type']) {
				case 'OCT':
					break;
				case 'ISO+OCT':
					$onco_block_type = 'isopentane + OCT';
					break;
				default:
					recordErrorAndMessage('PROCURE Block Move To Oncology Axis', '@@WARNING@@', "Unknwon Block Type :: Value will be set to OCT.", "See type '".$new_procure_block_data_to_move['procure_freezing_type']."' in PROCURE ATiM for the block '".$new_procure_block_data_to_move['barcode']."'.");
			}
		
			switch($new_procure_block_data_to_move['procure_origin_of_slice']) {
				case 'LA':
				case 'LP':
				case 'RA':
				case 'RP':
				case '':
					break;
				default:
					die('ERR 239 876987326 723 6');
			}
			
			// 4 -Block Creation
			
			$aliquot_data = array(
				'aliquot_masters' => array(
					'collection_id' => $onco_collection_id,
					'sample_master_id' => $onco_sample_master_id,
					'barcode' => 'tmp-mig',
					'aliquot_label' => strlen($new_procure_block_data_to_move['aliquot_label'])? $new_procure_block_data_to_move['aliquot_label'] : $new_procure_block_data_to_move['barcode'],
					'aliquot_control_id' => $atim_controls[$chumoncoaxis_db_schema]['aliquot_controls']['tissue-block']['id'],
					'in_stock' => $new_procure_block_data_to_move['in_stock'],
					'in_stock_detail' => $new_procure_block_data_to_move['in_stock_detail'],
					'use_counter' => '0',
					'storage_datetime' => $new_procure_block_data_to_move['storage_datetime'],
					'storage_datetime_accuracy' => $new_procure_block_data_to_move['storage_datetime_accuracy'],
					'stored_by' => $new_procure_block_data_to_move['qc_nd_stored_by'],
					'notes' => ((strlen($new_procure_block_data_to_move['aliquot_label']) && strlen($new_procure_block_data_to_move['barcode']))? "Previous code = '".$new_procure_block_data_to_move['barcode']."'. ": '').$new_procure_block_data_to_move['aliquot_notes']),
				$atim_controls[$chumoncoaxis_db_schema]['aliquot_controls']['tissue-block']['detail_tablename'] => array(
					'block_type' => $onco_block_type,
					'sample_position_code' => $new_procure_block_data_to_move['qc_nd_sample_position_code'],
					'patho_dpt_block_code' => $onco_patho_report_number,
					'tmp_gleason_primary_grade' => $new_procure_block_data_to_move['qc_nd_gleason_primary_grade'],
					'tmp_gleason_secondary_grade' => $new_procure_block_data_to_move['qc_nd_gleason_secondary_grade'],
					'tmp_tissue_primary_desc' => $new_procure_block_data_to_move['qc_nd_tissue_primary_desc'],
					'tmp_tissue_secondary_desc' => $new_procure_block_data_to_move['qc_nd_tissue_secondary_desc'],
					'procure_origin_of_slice' => $new_procure_block_data_to_move['procure_origin_of_slice'],
					'tumor_presence' => $new_procure_block_data_to_move['qc_nd_tumor_presence']));
			if($new_procure_block_data_to_move['selection_label']) {
				$aliquot_data['aliquot_masters']['storage_master_id'] = $studied_onco_axis_boxes[$new_procure_block_data_to_move['selection_label']]['id'];
				$aliquot_data['aliquot_masters']['storage_coord_x'] = $new_procure_block_data_to_move['storage_coord_x'];
				$aliquot_data['aliquot_masters']['storage_coord_y'] = $new_procure_block_data_to_move['storage_coord_y'];
			}
			$aliquot_master_id = customInsertRecord($aliquot_data, $chumoncoaxis_db_schema);
			recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "ONCO-AXIS :: New tissue block", "See PR -  ".$aliquot_data['aliquot_masters']['aliquot_label']." ($aliquot_master_id) ".(($new_procure_block_data_to_move['selection_label'])? "in ".$new_procure_block_data_to_move['selection_label']." position ".$new_procure_block_data_to_move['storage_coord_x']: ''));
			$aliquot_master_data_to_update = array(
				'aliquot_masters' => array('barcode' => $aliquot_master_id),
				'ad_blocks' => array());
			updateTableData($aliquot_master_id, $aliquot_master_data_to_update, $chumoncoaxis_db_schema);			
			
			// 5 - Delete PROCURE Block
		
			$aliquot_master_data_to_update = array(
				'aliquot_masters' => array('deleted' => '1'),
				'ad_blocks' => array());
			updateTableData($new_procure_block_data_to_move['aliquot_master_id'], $aliquot_master_data_to_update, $procure_db_schema);
			recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Deleted aliquot", $new_procure_block_data_to_move['barcode']);
			
			$check_sample_query = "SELECT CONCAT('Alq#',id) as record FROM $procure_db_schema.aliquot_masters WHERE sample_master_id = ".$new_procure_block_data_to_move['sample_master_id']." AND deleted <> 1
				UNION ALL
				SELECT CONCAT('Qc#',id) as record FROM $procure_db_schema.quality_ctrls WHERE sample_master_id = ".$new_procure_block_data_to_move['sample_master_id']." AND deleted <> 1
				UNION ALL
				SELECT CONCAT('SpRev#',id) as record FROM $procure_db_schema.specimen_review_masters WHERE sample_master_id = ".$new_procure_block_data_to_move['sample_master_id']." AND deleted <> 1
				UNION ALL
				SELECT CONCAT('Sam#',id) as record FROM $procure_db_schema.sample_masters WHERE parent_id = ".$new_procure_block_data_to_move['sample_master_id']." AND deleted <> 1";
			$check_sample_result = getSelectQueryResult($check_sample_query);
			if(!$check_sample_result) {
				$sample_master_data_to_update = array(
					'sample_masters' => array('deleted' => '1'),
					'sd_spe_tissues' => array());
				updateTableData($new_procure_block_data_to_move['sample_master_id'], $sample_master_data_to_update, $procure_db_schema);
				recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Deleted sample", $new_procure_block_data_to_move['mid_nolabo_identifier_value'].' '.$new_procure_block_data_to_move['procure_visit'].' #'.$new_procure_block_data_to_move['sample_code']);
				$check_collection_result = getSelectQueryResult("SELECT id FROM $procure_db_schema.sample_masters WHERE collection_id = ".$new_procure_block_data_to_move['collection_id']." AND deleted <> 1");
				if(!$check_collection_result) {
					$collection_data_to_update = array('collections' => array('deleted' => '1'));
					updateTableData($new_procure_block_data_to_move['collection_id'], $collection_data_to_update, $procure_db_schema);
					recordErrorAndMessage('Actions Summary', '@@MESSAGE@@', "PROCURE :: Deleted collection",$new_procure_block_data_to_move['mid_nolabo_identifier_value'].' '.$new_procure_block_data_to_move['procure_visit']);
				}
			}
			
		}	
	}
}


//Check no duplicated barcode

$duplicated_barcode = getSelectQueryResult("SELECT am.barcode, am.aliquot_label FROM
	(SELECT barcode, count(*) as dup_counter FROM aliquot_masters WHERE deleted <> 1 AND barcode LIKE '%-FRZ%' GROUP BY barcode) am_count,
	aliquot_masters am
	WHERE am_count.dup_counter > 1 AND am_count.barcode = am.barcode AND am.deleted <> 1;");
if($duplicated_barcode) die('ERR 232 2332 ');

//==============================================================================================
// End of the process
//==============================================================================================

$import_summary['tmp'] = $import_summary['Actions Summary'];
unset($import_summary['Actions Summary']);
$import_summary['Actions Summary'] = $import_summary['tmp'];
unset($import_summary['tmp']);

insertIntoRevsBasedOnModifiedValues();
customQuery("UPDATE $procure_db_schema.versions SET permissions_regenerated = 0;");
customQuery("UPDATE $chumoncoaxis_db_schema.versions SET permissions_regenerated = 0;");

dislayErrorAndMessage(true);

pr($all_update_insert_queries);

?>
		