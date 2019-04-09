<?php

require_once __DIR__.'/system.php';

// In prod
$view_update = false;
$permissions_regenerated_to_zero = true;
$insert_into_revs = true;
$commit_at_the_end = true;

// If test
if(isset($argv[1])) {
    if($argv[1] == 'test_import') {
        truncate();
        $view_update = true;
        $permissions_regenerated_to_zero = false;
        $insert_into_revs = true;
        $commit_at_the_end = true;
    } else if($argv[1] == 'test_message') {
        $view_update = false;
        $permissions_regenerated_to_zero = false;
        $insert_into_revs = false;
        $commit_at_the_end = false;
    } else {
        die('ERR ARG : '.$argv[1].' (should be test_import or test_message)');
    }
}

//==============================================================================================
// Main Code
//==============================================================================================

if(!testExcelFile(array_keys($excel_file_names))) {
	dislayErrorAndMessage();
	exit;
}

displayMigrationTitle("Block Migration Script", array_keys($excel_file_names));

echo "<font color='red'><br><br>Check at least one collection date of the excel file matches a date of a created collection into ATiM!<br></font>";

global $storages;
$storages = array();

// Counters

$matching_collections = 0;
$created_collections = 0;
$created_tissues = 0;
$created_blocks = 0;
$atim_blocks_linked_to_tma_creation_deleted = 0;
$atim_cores_linked_to_tma_creation_reassigned= 0;
$atim_collection_linked_to_tma_creation_deleted = 0;
$atim_tissue_linked_to_tma_creation_deleted = 0;
$created_storages = 0;

// Counters

$previous_file_matching_collections = 0;
$previous_file_created_collections = 0;
$previous_file_created_tissues = 0;
$previous_file_created_blocks = 0;
$previous_file_atim_blocks_linked_to_tma_creation_deleted = 0;
$previous_file_atim_cores_linked_to_tma_creation_reassigned= 0;
$previous_file_atim_collection_linked_to_tma_creation_deleted = 0;
$previous_file_atim_tissue_linked_to_tma_creation_deleted = 0;
$previous_file_created_storages = 0;

// Array to limit duplication of analysis

$duplicated_excel_line_check = array();
$excel_participant_data_to_atim_data = array();
$excel_participants_names_and_ramq_controls = array();
$excel_collection_data_to_atim_sardo_treatment = array();
$excel_collection_data_to_atim_collection = array();

// Array to display unmigratted lines

$blocks_not_migrated = array();
$expected_headers = array(
    'Nom',
    'Prénom',
    'No de dossier',
    'RAMQ',
    'Traitement description',
    'Date du prélèvement',
    'No Patho',
    'Lieu du Prélèvement ND, SL, HD',
    'Note de collection',
    'Enumeration des blocs',
    'Chambre',
    'Section',
    'Tablette',
    'Boite',
    'Tiroir');

foreach($excel_file_names as $excel_file_name => $file_info) {
    
    echo "<br><br><br><FONT COLOR=\"green\" ><b>************************************************************************************************************************************************************<br>";
    echo "File : ".$excel_file_name."<br>";
    echo "************************************************************************************************************************************************************</b></FONT>";
    
	//-----------------------------------------------------------------------------------------------------------------------
	// NEW PARSED FILE
	//-----------------------------------------------------------------------------------------------------------------------
	
	foreach($file_info['worksheets'] as $worksheet_name) {
	    $date_check_done = false;
		$header_check_done = false;
		$line_number_check = 0;
		while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {		    
			$excel_file_name_for_summary = utf8_encode($excel_file_name)." [$worksheet_name]";
			
			$line_number_check++;
			if($line_number_check == 500) {
			    echo "Line $line_number_check done<br>";
			    $line_number_check = 0;
			}
			
			$block_has_been_created = false;
			
			// *** NEW STEP **************************************************************************************************************************************************************
			//	Check File Headers
			// ***************************************************************************************************************************************************************************
			
			if(!$header_check_done) {
				$missing_header = false;
				foreach($expected_headers as $new_header) {
					if(!array_key_exists($new_header, $excel_line_data)) {
						$missing_header = true;
						recordErrorAndMessage('File Check'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - File header missing. No file data will be migrated into ATiM.", "Check header '$new_header' in the Excel file '$excel_file_name_for_summary'.");
					}
				}
				if($missing_header) break;
				$header_check_done = true;
			}
//TODO
//if($excel_line_data['No de dossier'] != 'H1058953') continue;			
			$duplicated_excel_line_check_key = $excel_line_data['No de dossier'].$excel_line_data['RAMQ'].$excel_line_data['Date du prélèvement'].$excel_line_data['No Patho'].$excel_line_data['Enumeration des blocs'];
			if(array_key_exists($duplicated_excel_line_check_key, $duplicated_excel_line_check)) {
			    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", 
			        '@@ERROR@@', 
			        "#".__LINE__." - You are creating block twice <u>for the same participant</u> and date. Second block won't be created.", 
			        "See block [".$excel_line_data['No Patho'].'-'.$excel_line_data['Enumeration des blocs']."] on line $line_number and ".$duplicated_excel_line_check[$duplicated_excel_line_check_key]."!");
			    	
			} else {
			    $duplicated_excel_line_check[$duplicated_excel_line_check_key] = $line_number;
			
    			// *** NEW STEP **************************************************************************************************************************************************************
    			//	Find a participant matching participant information
    			// ***************************************************************************************************************************************************************************
    			
    			//Flush value that should be considered as empty (comment)
    			foreach(array('RAMQ', 'No de dossier') as $excel_field) 
    				$excel_line_data[$excel_field] = str_replace(array('rien sur diamic', 'pas sur diamic'), array('', ''), $excel_line_data[$excel_field]);
    			
    			//Set info for summary message
    			$summary_label_see_line_and_file = "file '<i>".substr($excel_file_name_for_summary, 0, 20)."...xls</i>' line $line_number ".((array_key_exists('Validé', $excel_line_data) && $excel_line_data['Validé'] == 'oui')? "<font color='green'>Validated</font>": '');
    			
    			if(!strlen($excel_line_data['RAMQ'].$excel_line_data['No de dossier'])) {
    				recordErrorAndMessage('File Check'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - The participant identifier values ('RAMQ' & 'No de dossier') are empty in a parsed Excel line. The Excel data of the line won't be migrated into ATiM.", "See $summary_label_see_line_and_file.");
    			} else {
    				//Set info for summary message
    				$summary_label_participant_excel_nominal_data = "Excel participant ".$excel_line_data['Prénom']." ".$excel_line_data['Nom']." [RAMQ = '".$excel_line_data['RAMQ']."' and No de dossier' = '".$excel_line_data['No de dossier']."'] -  $summary_label_see_line_and_file";
    				
    				// *** Check RAMQ and names are always the same for an identifier accross lines and files ************************************************************************************
    						
    				$participant_names_and_ramq_key = strtolower(str_replace(array('-', 'é', 'è', 'ê'), array(' ', 'e', 'e', 'e'), $excel_line_data['Prénom']." ".$excel_line_data['Nom']." [RAMQ='".$excel_line_data['RAMQ']."']"));
    				$continue_line_parsing = true;
    				foreach(array('RAMQ', 'No de dossier') as $identifier) {
    					$identifier_value = $excel_line_data[$identifier];
    					if(strlen($identifier_value)) {
    						$identifier_value = "$identifier=$identifier_value";
    						if(!array_key_exists($identifier_value, $excel_participants_names_and_ramq_controls)) {
    							$excel_participants_names_and_ramq_controls[$identifier_value] = array('inital_names_and_ramq' => $participant_names_and_ramq_key, 'initial_parsed_line' => $summary_label_see_line_and_file);
    						} else if($excel_participants_names_and_ramq_controls[$identifier_value]['inital_names_and_ramq'] != $participant_names_and_ramq_key) {
    							recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - The $identifier value is listed into more than one Excel line but the nominal data (names & 'RAMQ') of the new parsed line does not match data of a previous parsed line. No data of the new parsed Excel line will be migrated into ATiM.", "Please compare <b>$participant_names_and_ramq_key</b> and <b>".$excel_participants_names_and_ramq_controls[$identifier_value]['inital_names_and_ramq']."</b>. See $excel_file_name_for_summary plus ".$excel_participants_names_and_ramq_controls[$identifier_value]['initial_parsed_line']." & line $line_number.");
    							$continue_line_parsing = false;
    						}
    					}
    				}
    				
    				if($continue_line_parsing) {
    					
    					$excel_participant_data_to_atim_data_key = $excel_line_data['RAMQ']."//".$excel_line_data['No de dossier'];
    					if(!isset($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key])) {
    						
    						// *** First time RAMQ and No Dossier combination parsed : Check identifiers match one participant *************************************************************************
    									
    						$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key] = array(
    							'participant_id' => null,
    							'first_name' => null,
    							'last_name' => null,
    							'collections' => array(),
    						    'collections_with_no_block' => array()
    						);
    						$participant_detection_error = false;
    						$matching_participants = array();
    						$all_misc_identifier_control_ids = array(
    							'RAMQ' => array($atim_controls['misc_identifier_controls']['ramq nbr']['id']),
    							'No de dossier' => array($atim_controls['misc_identifier_controls']['hotel-dieu id nbr']['id'], $atim_controls['misc_identifier_controls']['notre-dame id nbr']['id'], $atim_controls['misc_identifier_controls']['saint-luc id nbr']['id']));
    						foreach($all_misc_identifier_control_ids as $excel_field => $misc_identifier_controls_ids) {
    							$excel_value = $excel_line_data[$excel_field];
    							if(strlen($excel_value)) {
    								$query = "SELECT DISTINCT participant_id, first_name, last_name 
    									FROM misc_identifiers INNER JOIN participants ON participants.id = participant_id
    									WHERE identifier_value = '".str_replace("'", "''", $excel_value)."'
    									AND misc_identifiers.deleted <> 1
    									AND misc_identifier_control_id IN (".implode(",", $misc_identifier_controls_ids).")";
    								$atim_data = getSelectQueryResult($query);
    								if(sizeof($atim_data) > 1) {
    									recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - More than one ATiM participant matches a $excel_field value. No data of the Excel lines matching this $excel_field will be migrated into ATiM.", "See all lines with  '$excel_field' = '$excel_value'. See for example : $summary_label_participant_excel_nominal_data.");
    									$participant_detection_error = true;
    								} else if(sizeof($atim_data)) {
    									$matching_participants[$excel_field] = $atim_data;
    								}
    							}
    						}
    						if(!$participant_detection_error) {
    							//At least one participant matched based on at least one identifier
    							if(sizeof($matching_participants) == '2') {
    								$matching_participants = array_values($matching_participants);
    								if($matching_participants[0][0]['participant_id'] == $matching_participants[1][0]['participant_id']) {
    									//Perfect match (on 2 identifiers) : Set participant_id and names
    									$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['participant_id'] = $matching_participants[0][0]['participant_id'];
    									$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['first_name'] = $matching_participants[0][0]['first_name'];
    									$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['last_name'] = $matching_participants[0][0]['last_name'];
    								} else {
    									//The identifiers matche 2 different participant
    									recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - <u>Two different ATiM participants</u> match the Excel participant identifiers ('RAMQ' and 'No de dossier'). No data of the Excel lines with these 2 identifiers will be migrated into ATiM.", "See the 2 ATiM 'Participant System Codes' : ".$matching_participants[0][0]['participant_id']." & ".$matching_participants[1][0]['participant_id'].". See for example : $summary_label_participant_excel_nominal_data.");
    								}
    							} else if(sizeof($matching_participants)) {
    								//Match (on 1 identifier) : Set participant_id and names
    								$matching_identifier = array_keys($matching_participants);
    								$matching_identifier = array_shift($matching_identifier);
    								$matching_participants = array_values($matching_participants);
    								$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['participant_id'] = $matching_participants[0][0]['participant_id'];
    								$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['first_name'] = $matching_participants[0][0]['first_name']; 
    								$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['last_name'] = $matching_participants[0][0]['last_name'];
    								recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - Participant matches based on only the $matching_identifier of the Excel line. Data of Excel file lines matching these $matching_identifier will be migrated into ATiM but please confirm match.", "See for example ATiM participant ".$matching_participants[0][0]['first_name']." ".$matching_participants[0][0]['last_name']." matching $summary_label_participant_excel_nominal_data.");
    							} else {
    								recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - No participant matches the Excel participant identifiers ('RAMQ' and/or 'No de dossier'). No data of the Excel lines matching these identifier values combination will be migrated into ATiM.", "See for example : $summary_label_participant_excel_nominal_data.");
    							}
    						}
    					}
    					
    					// *** NEW STEP **************************************************************************************************************************************************************
    					//	Find collection
    					// ***************************************************************************************************************************************************************************
    					
    					if($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['participant_id']) {
    						$participant_id = $excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['participant_id'];
    						
    						//Collection date
    						//...............
    						list($excel_collection_datetime, $excel_collection_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['Date du prélèvement'], 'Block Definition', 'Date du prélèvement', "See $summary_label_participant_excel_nominal_data.");
    						if($excel_collection_datetime_accuracy == 'c' && !$date_check_done) {
    						    $date_check_done = true;
    						    echo "<font color='red'><br><br>For validation : Imported collection date is '$excel_collection_datetime' for $summary_label_participant_excel_nominal_data!<br><br></font>";
    						}
    						$excel_collection_datetime_accuracy = ($excel_collection_datetime_accuracy == 'c')? 'h' : $excel_collection_datetime_accuracy;
    						$excel_collection_datetime_formated_for_summary = formateDateForSummary($excel_collection_datetime, $excel_collection_datetime_accuracy);
    						$excel_collection_year = substr($excel_collection_datetime, 0, 4);
    						$excel_collection_year_2_digits = substr($excel_collection_datetime, 2, 2);
    						
    						// Check block has to be created
    						//---------------------------------------------------------------------------
    						
//     						$block_code_pattern = array(
//                                 'Congel',
//                                 '[IV]{1,3}\-[A-Za-z]{1,3}',
//                                 '[A-Za-z]{1,3}',
//                                 '[IV]{1,3}\-[GD][0-9]',
//                                 'I 4 NIV\.',
//                                 'CONG B[0-9]',
//                                 '([A-Za-z]+)[\-]{0,1}([0-9]+)',
//                                 '([0-9]+)([A-Za-z]+)',
//                                 '[AB].{1,2}((CONGEL)|(congel))',
//                                 '([A-Za-z]+)([0-9]+)(([A-Za-z]+)|(\-[0-9]+))',
//                                 '[0-9]+',
//     						    'O\-[0-9]+([\ A-Za-z]*)' 
//     						);
//     						$block_code_pattern= '/^(('.implode(')|(', $block_code_pattern).'))$/';
//     						if(strlen($excel_line_data['Enumeration des blocs']) && strtolower($excel_line_data['Enumeration des blocs']) != 'nul' && !preg_match($block_code_pattern, $excel_line_data['Enumeration des blocs'], $matches)) {
//     							recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - Wrong Block code format (ex:A1). Block (plus collection and tissue) won't be created into ATiM.", "See value [".$excel_line_data['Enumeration des blocs']."] of the $summary_label_participant_excel_nominal_data.");
//     						} else 
						    if(!strlen($excel_collection_datetime)) {
    						    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - Block collection date is missing. Block (plus collection and tissue) won't be created into ATiM.", "See $summary_label_participant_excel_nominal_data.");
    						} else {
    							$sample_notes = array();
    							
    							// Get the block excel data
    							//---------------------------------------------------------------------------
    							
    							//Block Code
    							//..........
    							$excel_block_code = $excel_line_data['Enumeration des blocs'];
    							$excel_block_prefix = 'tmp'.$line_number;
    							if(!strlen($excel_line_data['Enumeration des blocs']) || strtolower($excel_line_data['Enumeration des blocs']) == 'nul') {
    							    $excel_block_code = null;
    							} else if(preg_match('/^((([A-Z]{0,1})([0-9]*))|(([A-Z])([0-9]+[A-Z]))|([A-Z])([0-9]+\ [Bb]leu))$/', $excel_block_code, $matches)) {
    							    $excel_block_prefix = $matches[3];
    							} else {
    							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - The format of the Block code seams to be different than regular block code. A specific tissue sample will be created for this block (1 to 1 relationship). Please confirm.", "See value [$excel_block_code] of the $summary_label_participant_excel_nominal_data.");
    							}
    							
    							$excel_no_patho = '';
    							if(preg_match('/^[\']{0,1}([0-9A-Za-z\-\ ]{2,100})$/', $excel_line_data['No Patho'], $matches)) {
    							    $excel_no_patho = $matches[1];
    							} else {
    							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - Wrong pathology code format. The pathology code won't be recorded so block (plus collection and tissue) won't be created into ATiM.", "See value [".$excel_line_data['No Patho']."] of the $summary_label_participant_excel_nominal_data.");
    							}
    							if(preg_match('/^200([3-9])/', $excel_collection_datetime, $matches)) {
    							    if(preg_match('/^'.$matches[1].'/', $excel_no_patho)) {
    							        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - Added a 0 to the pathology code. Please confirm.", "Changed value [".$excel_no_patho."] to [0".$excel_no_patho."] for block collected on '$excel_collection_datetime' for the $summary_label_participant_excel_nominal_data.");
    							        $excel_no_patho = '0'.$excel_no_patho;
    							    }
    							}
    								
    							//Collection Treatment
    							//....................
    							$qc_nd_surgery_biopsy_details = $excel_line_data['Traitement description'];
    														
    							//Collection site
    							//...............
    							$excel_collection_site = '';
    							if(in_array($excel_line_data['Lieu du Prélèvement ND, SL, HD'], array('ND', 'SL', 'HD'))) {
    								$excel_collection_site = str_replace(array('ND', 'SL', 'HD'), array('notre dame hospital', 'saint luc hospital', 'hotel dieu hospital'), $excel_line_data['Lieu du Prélèvement ND, SL, HD']);
    							} else if(strlen($excel_line_data['Lieu du Prélèvement ND, SL, HD'])) {
    								$sample_notes[] = "Tissue collection site = ".$excel_line_data['Lieu du Prélèvement ND, SL, HD'].".";
    								recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - Wrong 'Lieu du Prélèvement ND, SL, HD' format. The value won't be recorded at collection but in tissue notes.", "See value [".$excel_line_data['Lieu du Prélèvement ND, SL, HD']."].", $excel_line_data['Lieu du Prélèvement ND, SL, HD']);
    							}
    							
    							if(strlen($excel_no_patho)) {
    							    
    							    // At this level both collection date and no patho exist
    							    if(!strlen($excel_collection_datetime)) die('ERR 88378398383');  //Should already be checked    		
    							    
    							    $excel_collection_data_to_atim_data_key = "$participant_id//$excel_no_patho//$excel_collection_datetime_formated_for_summary";
        							
        							// Try to find an ATiM SARDO BIOP/SURG linked to this collection (plus check SARDO BIOP/SURG of other participants)
        							//-----------------------------------------------------------------------------------------------------------------
                                    
        							if(!array_key_exists($excel_collection_data_to_atim_data_key, $excel_collection_data_to_atim_sardo_treatment)) {
        							    
            							$linked_sardo_tx = array();
            							
            							// Check match on year and Patho#
            							//.....................................................
            							
            							$query = "SELECT TreatmentMaster.id, 
                                            TreatmentMaster.start_date,
                                            TreatmentMaster.start_date_accuracy,
                                            TreatmentMaster.qc_nd_sardo_tx_detail_summary,
                                            TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs
                							FROM treatment_masters TreatmentMaster, treatment_controls TreatmentControl
                							WHERE TreatmentMaster.deleted <> 1
                							AND TreatmentMaster.start_date LIKE '$excel_collection_year%'
                							AND TreatmentMaster.participant_id = $participant_id
                							AND TreatmentMaster.treatment_control_id = TreatmentControl.id
                							AND TreatmentControl.flag_active = 1
                							AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
                							AND TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE '%$excel_no_patho%';";
            							$atim_tx_data = getSelectQueryResult($query);
            							if(sizeof($atim_tx_data) == 1) {
            							    if($excel_collection_datetime_accuracy == 'h' && $atim_tx_data[0]['start_date_accuracy'] == 'c' && $excel_collection_datetime == $atim_tx_data[0]['start_date']) {
            							        $linked_sardo_tx = $atim_tx_data[0];
            							    } else if($excel_collection_datetime_accuracy != 'h' && $atim_tx_data[0]['start_date_accuracy'] == 'c') {
            							        $linked_sardo_tx = $atim_tx_data[0];
            							        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							            (strlen($excel_no_patho) > 5 || preg_match("/$excel_no_patho\-$excel_collection_year_2_digits/", $atim_tx_data[0]['qc_nd_sardo_tx_all_patho_nbrs']))? '@@MESSAGE@@' : '@@WARNING@@',
            							            "#".__LINE__." - A SARDO SURG/BIOP matches the block collection based on both the excel year and the excel patho# (exact or approximatively). SARDO SURG/BIOP will be used to set the exact date of the block collection. Please confirm and/or correct data after migration.",
            							            "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and the SARDO SURG/BIOP on <b>'".formateDateForSummary($atim_tx_data[0]['start_date'], $atim_tx_data[0]['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$atim_tx_data[0]['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$atim_tx_data[0]['qc_nd_sardo_tx_detail_summary']."). See $summary_label_participant_excel_nominal_data.");
            							    } else  {
            							        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							            '@@WARNING@@',
            							            "#".__LINE__." - A SARDO SURG/BIOP matches the block collection based on both the excel year and the excel patho# (exact or approximatively) but the date(s) are not exact or exactly the same. No BIOP/STUDY will be used to set the exact date of collection. Please confirm and/or correct data after migration.",
            							            "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and the SARDO SURG/BIOP on <b>'".formateDateForSummary($atim_tx_data[0]['start_date'], $atim_tx_data[0]['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$atim_tx_data[0]['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$atim_tx_data[0]['qc_nd_sardo_tx_detail_summary']."). See $summary_label_participant_excel_nominal_data.");
            							    }
            							} else if (sizeof($atim_tx_data)) {
            							    $tmp_tx_sardo = array();
            							    foreach($atim_tx_data as $new_atim_tx_data) {
            							        $tmp_tx_sardo[] = "BIOP/SURG on <b>'".formateDateForSummary($new_atim_tx_data['start_date'], $new_atim_tx_data['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$new_atim_tx_data['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$new_atim_tx_data['qc_nd_sardo_tx_detail_summary'].")."; 
            							        if($excel_collection_datetime_accuracy == 'h'  && $new_atim_tx_data['start_date_accuracy'] == 'c' && $excel_collection_datetime == $new_atim_tx_data['start_date']) $linked_sardo_tx[] = $new_atim_tx_data;
            							    }
            							    $linked_sardo_tx = (sizeof($linked_sardo_tx) == 1)? $linked_sardo_tx[0] : array();  							        
            							    if(!$linked_sardo_tx) {
                							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                							        '@@WARNING@@',
                							        "#".__LINE__." - Too many SARDO SURG/BIOP match the block collection based on both the excel year (or the exact date) and the excel patho# (exact or approximatively) <u>for the participant</u>. No BIOP/STUDY will be used to set the exact date of collection. Please confirm and/or correct data after migration.",
                							        "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and following SARDO SURG/BIOP treatments for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_tx_sardo).".");
                                            }
            							}
            							$excel_collection_data_to_atim_sardo_treatment[$excel_collection_data_to_atim_data_key] = $linked_sardo_tx;
            							
                						if(!$linked_sardo_tx) {
                						    
                						    // Check all SARDO BIOP/SURG of the participant based on year or patho # just in case and generate warnings for any match
                						    //.........................................................................................................................
                						    
                						    // Check on year
                						    
                						    $query = "SELECT TreatmentMaster.id, TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, TreatmentMaster.qc_nd_sardo_tx_detail_summary, TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs
                    						    FROM treatment_masters TreatmentMaster, treatment_controls TreatmentControl
                    						    WHERE TreatmentMaster.deleted <> 1
                    						    AND TreatmentMaster.start_date LIKE '$excel_collection_year%'
                    						    AND TreatmentMaster.participant_id = $participant_id
                    						    AND TreatmentMaster.treatment_control_id = TreatmentControl.id
                    						    AND TreatmentControl.flag_active = 1
                    						    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop';";
                						    $atim_tx_data = getSelectQueryResult($query);
                						    if($atim_tx_data) {
                    						    $tmp_tx_sardo = array();
                    						    foreach($atim_tx_data as $new_atim_tx_data) {
                    						        $tmp_tx_sardo[] = "BIOP/SURG on <b>'".formateDateForSummary($new_atim_tx_data['start_date'], $new_atim_tx_data['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$new_atim_tx_data['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$new_atim_tx_data['qc_nd_sardo_tx_detail_summary'].").";
                    						    }
                    						    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                    						        '@@WARNING@@',
                    						        "#".__LINE__." - No SARDO SURG/BIO matches the block collection excel year (or exact date) and excel patho# but many SARDO SURG/BIOP match the block based on the year of collection only <u>for the participant</u>. No comparison to collection information will be done by the script. Link to SARDO SURG/BIOP could be problematic in the future. Please confirm and/or correct data after migration.",
                    						        "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and following SARDO SURG/BIOP treatments for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_tx_sardo).".");
                						    }
                						    
                						    // Check on patho #
                						    
                						    $query = "SELECT TreatmentMaster.id,
                    						    TreatmentMaster.start_date,
                    						    TreatmentMaster.start_date_accuracy,
                    						    TreatmentMaster.qc_nd_sardo_tx_detail_summary,
                    						    TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs
                    						    FROM treatment_masters TreatmentMaster, treatment_controls TreatmentControl
                    						    WHERE TreatmentMaster.deleted <> 1
                    						    AND TreatmentMaster.participant_id = $participant_id
                    						    AND TreatmentMaster.treatment_control_id = TreatmentControl.id
                    						    AND TreatmentControl.flag_active = 1
                    						    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
                    						    AND TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE '%$excel_no_patho%';";
                						    $atim_tx_data = getSelectQueryResult($query);
                						    if($atim_tx_data) {
                						        $tmp_tx_sardo = array();
                						        foreach($atim_tx_data as $new_atim_tx_data) {
                						            $tmp_tx_sardo[] = "BIOP/SURG on <b>'".formateDateForSummary($new_atim_tx_data['start_date'], $new_atim_tx_data['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$new_atim_tx_data['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$new_atim_tx_data['qc_nd_sardo_tx_detail_summary'].").";
                						        }
                						        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                						            (strlen($excel_no_patho) > 6)? '@@ERROR@@' : '@@WARNING@@',
                						            "#".__LINE__." - No SARDO SURG/BIO matches the block collection excel date and excel patho# but many SARDO SURG/BIOP match the block collection based on the patho# (approximatively) only <u>for the participant</u>. No comparison to collection information can be done. Link to SARDO SURG/BIOP could be problematic in the future. Please confirm and/or correct data after migration.",
                						            "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> and patho # <b>$excel_no_patho</b> and following SARDO SURG/BIOP treatments for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_tx_sardo).".");
                						    }
            							}
            							
            							// Check all SARDO BIOP/SURG of other participants based on year and patho # (or just patho#) just in case and generate warnings for any match
            							//..............................................................................................................................................
            							
            							$query = "SELECT TreatmentMaster.id,
                							TreatmentMaster.start_date,
                							TreatmentMaster.start_date_accuracy,
                							TreatmentMaster.qc_nd_sardo_tx_detail_summary,
                							TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs
                							FROM treatment_masters TreatmentMaster, treatment_controls TreatmentControl
                							WHERE TreatmentMaster.deleted <> 1
                							AND TreatmentMaster.start_date LIKE '$excel_collection_year%'
                							AND TreatmentMaster.participant_id != $participant_id
                							AND TreatmentMaster.treatment_control_id = TreatmentControl.id
                							AND TreatmentControl.flag_active = 1
                							AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
                							AND TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE '%$excel_no_patho%';";
            							$atim_tx_data = getSelectQueryResult($query);
            							if($atim_tx_data) {
            							    $tmp_tx_sardo = array();
            							    foreach($atim_tx_data as $new_atim_tx_data) {
            							        $tmp_tx_sardo[] = "BIOP/SURG on <b>'".formateDateForSummary($new_atim_tx_data['start_date'], $new_atim_tx_data['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$new_atim_tx_data['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$new_atim_tx_data['qc_nd_sardo_tx_detail_summary'].").";
            							    }
                                            recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                                                (strlen($excel_no_patho) > 6)? '@@ERROR@@' : '@@WARNING@@',
            							        "#".__LINE__." - Many SARDO SURG/BIOP match the block collection based on the excel patho# (approximatively) and the excel block collection year <u>for other participants</u>. Please confirm no error could have been done into the excel source file.",
            							        "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and following SARDO SURG/BIOP treatments for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_tx_sardo).".");
            							}
            							
            							$excel_no_patho_to_test = (strlen($excel_no_patho) > 5)? $excel_no_patho : $excel_no_patho."-$excel_collection_year_2_digits";
            							$query = "SELECT TreatmentMaster.id,
                							TreatmentMaster.start_date,
                							TreatmentMaster.start_date_accuracy,
                							TreatmentMaster.qc_nd_sardo_tx_detail_summary,
                							TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs
                							FROM treatment_masters TreatmentMaster, treatment_controls TreatmentControl
                							WHERE TreatmentMaster.deleted <> 1
                							AND (TreatmentMaster.start_date NOT LIKE '$excel_collection_year%' OR TreatmentMaster.start_date IS NULL)
                							AND TreatmentMaster.participant_id != $participant_id
                							AND TreatmentMaster.treatment_control_id = TreatmentControl.id
                							AND TreatmentControl.flag_active = 1
                							AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
                							AND TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE '%$excel_no_patho_to_test%';";
            							$atim_tx_data = getSelectQueryResult($query);
            							if($atim_tx_data) {
            							    $tmp_tx_sardo = array();
            							    foreach($atim_tx_data as $new_atim_tx_data) {
            							        $tmp_tx_sardo[] = "BIOP/SURG on <b>'".formateDateForSummary($new_atim_tx_data['start_date'], $new_atim_tx_data['start_date_accuracy'])."'</b> with Patho#(s) <b>'".$new_atim_tx_data['qc_nd_sardo_tx_all_patho_nbrs']."'</b> (".$new_atim_tx_data['qc_nd_sardo_tx_detail_summary'].").";
            							    }
            							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							        '@@WARNING@@',
            							        "#".__LINE__." - Many SARDO SURG/BIOP match the block collection based on the excel patho# (approximatively) but not the excel block collection year <u>for other participants</u>. Please confirm no error could have been done into the excel source file.",
            							        "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and following SARDO SURG/BIOP treatments for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_tx_sardo).".");
            							}
        							}
        							$linked_sardo_tx = $excel_collection_data_to_atim_sardo_treatment[$excel_collection_data_to_atim_data_key];
        							
        							// Try to find an ATiM collection to link to this block
        							//-----------------------------------------------------
        							
        							// Update inexact excel date
        							 
        							if($linked_sardo_tx && $excel_collection_datetime_accuracy != 'h') {
        							    if($linked_sardo_tx['start_date_accuracy'] != 'c') die('ERR 234823923723897');
        							    $excel_collection_datetime = $linked_sardo_tx['start_date'];
        							    $excel_collection_datetime_accuracy = 'h';
        							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
        							        '@@MESSAGE@@',
        							        "#".__LINE__." - Excel collection date is not exact but the system is able to link collection to a unique SARDO SURG/BIOP based on both the excel collection year and the excel Patho #. Approximative date of the created collection will be updated to the date of the SARDO SURG/BIOP. Please confirm or correct data after migration.",
        							        "See SARDO treatment '".$linked_sardo_tx['qc_nd_sardo_tx_detail_summary']."' on <b>".$linked_sardo_tx['start_date']."</b> with patho # <b>".$linked_sardo_tx['qc_nd_sardo_tx_all_patho_nbrs']."</b> and excel collection with date <b>$excel_collection_year</b> and patho # <b>$excel_no_patho</b>. See $summary_label_participant_excel_nominal_data and more.",
        							        "$excel_collection_datetime//$excel_no_patho");
        							}
        							
        							if(is_null($excel_block_code)) {
                                    
                                        // Collection created to track patho# and inform users that either blocks have not been found or destroyed
                                        
        							    if(isset($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key])) {
        							        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", 
        							            '@@ERROR@@', 
        							            "#".__LINE__." - Blocks still have been created with this patho# and date by the script but system is trying to create a collection to inform users that blocks have not been found or destroyed (field 'Enumeration des blocs' empty). Please delete this excel row with no block data.", 
        							            "See $summary_label_participant_excel_nominal_data.");
        							    
        							    } else if(!isset($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections_with_no_block'][$excel_collection_data_to_atim_data_key])) {
                                            recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", 
                                                '@@MESSAGE@@', 
                                                "#".__LINE__." - 'Enumeration des blocs' value is empty or equal to 'NULL': Script considers that no block has been found or blocks have been destroyed. An empty collection will be created to track the Patho # plus define that no block can be found.", 
                                                "See $summary_label_participant_excel_nominal_data.");
                                            $query = "SELECT DISTINCT
                                                Collection.id collection_id,
                                                Collection.acquisition_label,
                                                Collection.participant_id,
                                                Collection.collection_datetime,
                                                Collection.collection_datetime_accuracy,
                                                Collection.qc_nd_pathology_nbr,
                                                Collection.treatment_master_id,
                                                Collection.collection_site
                                                FROM collections Collection
                                                INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id
                                                WHERE Collection.deleted <> 1
                                                AND Collection.participant_id = $participant_id
                                                AND Collection.collection_datetime LIKE '$excel_collection_year%'
                                                AND AliquotMaster.deleted <> 1
                                                AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id'];
                                            $tmp_atim_collection_data = getSelectQueryResult($query);
                                            $tmp_dates_and_patho_nbr = array();
                                            foreach($tmp_atim_collection_data as $new_tmp_coll) {
                                                $tmp_dates_and_patho_nbr[] = "Collection on [".$new_tmp_coll['collection_datetime']."] with Patho# [".$new_tmp_coll['qc_nd_pathology_nbr']."]";
                                            }
                                            if($tmp_dates_and_patho_nbr) {
                                                recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                                                    '@@WARNING@@',
                                                    "#".__LINE__." - 'Enumeration des blocs' value is empty or equal to 'NULL': Script considers that no block has been found or blocks have been destroyed. An empty collection will be created to track the Patho # plus define that no block can be found but some collections of blocks still exist into ATiM for the same year. Please validate block are not still into the bank.",
                                                    "See ".implode(" & ", $tmp_dates_and_patho_nbr) ." for $summary_label_participant_excel_nominal_data.");
                                            }
                                            $collection_data = array(
                                                'participant_id' => $participant_id,
                                                'acquisition_label' => 'Pathology Blocks Collection Not Found Or Destroyed',
                                                'collection_property' => 'participant collection',
                                                'qc_nd_pathology_nbr' => $excel_no_patho,
                                                'collection_site' => $excel_collection_site,
                                                'collection_notes' => 'No block found in pathology department or blocks destroyed. '.(strlen($excel_line_data['Note de collection'])? ' '.$excel_line_data['Note de collection']: '').' Created by the process to download the pathology blocks data from excel file on '.date("Y-m-d").'.'
                                            );
                                            if($excel_collection_datetime) {
                                                $collection_data['collection_datetime'] = $excel_collection_datetime;
                                                $collection_data['collection_datetime_accuracy'] = ($excel_collection_datetime_accuracy == 'c')? 'h' : $excel_collection_datetime_accuracy;
                                            }
                                            $collection_id = customInsertRecord(array('collections' => $collection_data));
                                            $created_collections++; 
                                            $excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections_with_no_block'][$excel_collection_data_to_atim_data_key] = array('collection_id' => $collection_id);
                                        } else {
                                            recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - Blocks not found or destroyed (field 'Enumeration des blocs' empty) has still been defined on an excel line above. Don't duplicate information. Line data won't be migrated.", "See $summary_label_participant_excel_nominal_data.");
                                        }
                                    
                                    } else {
                                        
                                        // Collection with block
                                        
            							if(!array_key_exists($excel_collection_data_to_atim_data_key, $excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'])) {
            							    	
            							    $linked_collection = array();
            							    
            							    //Match should be exact because process won't update information of an existing collection (like the patho#) or the date of collection
            							    //So we can not link our block to an exiting collection still linked to a SARDO BIOP/SURG with no NoPatho (only message will be generated). 
            							    //....................................................................................................................................
                							
                							$query = "SELECT DISTINCT
                							    Collection.id collection_id,
                							    Collection.acquisition_label,
                							    Collection.participant_id,
                							    Collection.collection_datetime,
                							    Collection.collection_datetime_accuracy,
                							    Collection.qc_nd_pathology_nbr,
                							    Collection.treatment_master_id,
                							    Collection.collection_site
                							    FROM collections Collection
                							    WHERE Collection.deleted <> 1
                							    AND Collection.participant_id = $participant_id
                							    AND Collection.collection_datetime LIKE '$excel_collection_year%'
                							    AND Collection.qc_nd_pathology_nbr LIKE '%$excel_no_patho%' 
                							    AND LENGTH(Collection.qc_nd_pathology_nbr) > 2";
            							    $atim_collection_data = getSelectQueryResult($query);
            							    if(sizeof($atim_collection_data) == 1) {
            							        if(formateDateForSummary($atim_collection_data[0]['collection_datetime'], $atim_collection_data[0]['collection_datetime_accuracy']) == formateDateForSummary($excel_collection_datetime, $excel_collection_datetime_accuracy)
                                                && (in_array($atim_collection_data[0]['collection_datetime_accuracy'], array('h', 'i','c')) || $atim_collection_data[0]['collection_datetime_accuracy'] == $excel_collection_datetime_accuracy)) {
                                                    if(preg_match('/Pathology Blocks Collection Not Found Or Destroyed/', $atim_collection_data[0]['acquisition_label'])) {
                                                        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                                                            '@@WARNING@@',
                                                            "#".__LINE__." - Block will be linked to an existing collection that you previously defined with block as lost or not found in a previons excel file for block migration so the acquisition label of the collection has to be updtaed manually after migration.",
                                                            "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> for $summary_label_participant_excel_nominal_data");
                                                    }
                                                    $linked_collection = $atim_collection_data[0];
            							            $matching_collections++;
            							        } else {
            							            recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							                '@@WARNING@@',
            							                "#".__LINE__." - An ATiM collection match the block collection based on both the excel year and the excel patho# but the date(s) are not exactly the same <u>for the participant</u>. A new collection will be created for the block. Please confirm and/or correct data after migration.",
            							                "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and the Collection on <b>'".formateDateForSummary($atim_collection_data[0]['collection_datetime'], $atim_collection_data[0]['collection_datetime_accuracy'])."'</b> with Patho#(s) <b>'".$atim_collection_data[0]['qc_nd_pathology_nbr']."'</b> (Label : ".$atim_collection_data[0]['acquisition_label']." & id = ".$atim_collection_data[0]['collection_id'].").");
            							        }
            							    } else if(sizeof($atim_collection_data)) {
            							        $tmp_collection = array();
            							        $coll_for_no_block_found = false;
                                                foreach($atim_collection_data as $new_atim_collection_data) {
                                                    if(preg_match('/Pathology Blocks Collection Not Found Or Destroyed/', $new_atim_collection_data['acquisition_label'])) $coll_for_no_block_found = true;
                                                    $tmp_collection[] = "Collection on <b>'".formateDateForSummary($new_atim_collection_data['collection_datetime'], $new_atim_collection_data['collection_datetime_accuracy'])."'</b> with Patho#(s) <b>'".$new_atim_collection_data['qc_nd_pathology_nbr']."'</b> (Label : ".$new_atim_collection_data['acquisition_label']." & id = ".$new_atim_collection_data['collection_id'].").";
                                                    if($excel_collection_datetime_accuracy == 'h'  && in_array($new_atim_collection_data['collection_datetime_accuracy'], array('c', 'i', 'h')) && $excel_collection_datetime == formateDateForSummary($new_atim_collection_data['collection_datetime'], 'c')) $linked_collection[] = $new_atim_collection_data;
                                                }
                                                if(sizeof($linked_collection) == 1){
                                                    $linked_collection = $linked_collection[0];
            							            $matching_collections++;
                                                } else if(sizeof($linked_collection)) {
                                                    $linked_collection = $linked_collection[0];
            							            $matching_collections++;
                                                    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
                                                        '@@WARNING@@',
                                                        "#".__LINE__." - Too many ATiM collections match the block collection based on both the excel year (or the exact date) and the excel patho# <u>for the participant</u>. Block will be added to the first collection. ".($coll_for_no_block_found? 'Please note that you previously defined block as lost or not found in a previons excel file for block migration so the acquisition label of the collection has to be updtaed manually after migration.' : '')." Please check if clean up and/or collection merge has to be done after migration.",
                                                        "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and following ATiM collection for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_collection).".");
                                                }
            							    }
            							    if($linked_collection) {
            							        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							            '@@MESSAGE@@',
            							            "#".__LINE__." - An existing ATiM collection will be used to create block. Please confirm or correct data after migration.",
            							            "See ATiM collection '".$linked_collection['acquisition_label']."' (id = ".$linked_collection['collection_id'].") on  '<b>".formateDateForSummary($linked_collection['collection_datetime'], $linked_collection['collection_datetime_accuracy'])."</b>' with Patho# <b>".$linked_collection['qc_nd_pathology_nbr']."</b> and excel collection with date <b>$excel_collection_datetime_formated_for_summary</b> and patho # <b>$excel_no_patho</b>. See $summary_label_participant_excel_nominal_data and more.",
            							            "$excel_collection_datetime//$excel_no_patho");
            							        if(strlen($excel_collection_site) && $linked_collection['collection_site'] != $excel_collection_site) {
            							            recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							                '@@MESSAGE@@',
            							                "#".__LINE__." - An existing ATiM collection will be used to create block but the site of collection are different. Site won't be updated. Please confirm or correct data after migration.",
            							                "See ATiM collection '".$linked_collection['acquisition_label']."' (id = ".$linked_collection['collection_id'].") on  '".formateDateForSummary($linked_collection['collection_datetime'], $linked_collection['collection_datetime_accuracy'])."' with Patho# <b>".$linked_collection['qc_nd_pathology_nbr']."</b> and site <b>".(strlen($linked_collection['collection_site'])? $linked_collection['collection_site'] : 'no site')."</b> and excel collection with date <b>$excel_collection_datetime_formated_for_summary</b> and patho # <b>$excel_no_patho</b> and site '<b>".($excel_collection_site? $excel_collection_site : 'No Site')."</b>'. See $summary_label_participant_excel_nominal_data and more.",
            							                "$excel_collection_datetime//$excel_no_patho//$excel_collection_site");
            							        }
            							        if(strlen($excel_line_data['Note de collection'])) {
            							            recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							                '@@WARNING@@',
            							                "#".__LINE__." - Created blocks will be linked to an existing ATiM collection but a collection note exists into excel. This note won't be added to the notes of the existing ATiM collection . Please update the collection with the note after migration.",
            							                "See ATiM collection '".$linked_collection['acquisition_label']."' (id = ".$linked_collection['collection_id'].") note '".$excel_line_data['Note de collection']."' for $summary_label_participant_excel_nominal_data (collection id = ".$linked_collection['collection_id'].")");
            							        }
            							        $excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key] = array('collection_id' => $linked_collection['collection_id'], 'tissues' => array());
                                            }
    
            							    // Check all Collections of other participants based on year and patho # just in case and generate warnings for any match
            							    //.........................................................................................................................
            							    
            							    $query = "SELECT DISTINCT
                							    Collection.id collection_id,
                							    Collection.participant_id,
                							    Collection.collection_datetime,
                							    Collection.collection_datetime_accuracy,
                							    Collection.collection_site,
                							    Collection.qc_nd_pathology_nbr
                							    FROM collections Collection
                							    WHERE Collection.deleted <> 1
                							    AND Collection.participant_id != $participant_id
                							    AND Collection.collection_datetime LIKE '$excel_collection_year%'
                							    AND Collection.qc_nd_pathology_nbr LIKE '%$excel_no_patho%';";
            							    $atim_collection_data = getSelectQueryResult($query);
            							    if($atim_collection_data) {
            							        $tmp_atim_collections = array();
            							        foreach($atim_collection_data as $new_atim_collection_data) {
            							            $tmp_atim_collections[] = "ATiM collection (id=".$new_atim_collection_data['collection_id'].") on <b>".formateDateForSummary($new_atim_collection_data['collection_datetime'], $new_atim_collection_data['collection_datetime_accuracy'])."</b> with ".(strlen($new_atim_collection_data['qc_nd_pathology_nbr'])? "Patho#(s) <b>'".$new_atim_collection_data['qc_nd_pathology_nbr']."'</b>." : " no Patho #.");
            							        }
            							        recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							            '@@WARNING@@',
            							            "#".__LINE__." - Many ATiM collections of <u>other participants</u> match the block collection based on the excel patho# (approximatively) and the excel year of collection. Please confirm no error could have been done into the excel source file.",
            							            "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> and following collections of other participants for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_atim_collections).".");
            							    }
            							}
            							
            							// Check block aliquot label does not match aliquot label of the block of another participant
            							//-------------------------------------------------------------------------------------------
            							
            							//Check block patho and code not still into ATiM
            							$excel_block_code_limited_conditions = $excel_block_code;
            							$excel_block_code_digits = null;
            							if(preg_match('/^([A-Za-z]+)([0-9]+)$/', $excel_block_code, $matches)) {
            							    $excel_block_code_limited_conditions = "(".$matches[1]."){0,1}$matches[2]";  //to remove A from A1, A2, etc
            							    $excel_block_code_digits = $matches[2];
            							}
            							$block_label_regular_expression = "^$excel_no_patho(\-$excel_collection_year_2_digits){0,1}\-$excel_block_code_limited_conditions$";
            							$query = "SELECT AliquotMaster.aliquot_label,
                							YEAR(Collection.collection_datetime) AS year_of_collection
                							FROM aliquot_masters AliquotMaster
                							INNER JOIN aliquot_controls AliquotControl ON AliquotControl.id = AliquotMaster.aliquot_control_id
                							INNER JOIN sample_controls SampleControl ON SampleControl.id = AliquotControl.sample_control_id
                							INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
                							WHERE AliquotMaster.deleted <> 1
                							AND AliquotMaster.aliquot_label REGEXP '$block_label_regular_expression'
                							AND SampleControl.sample_type = 'tissue'
                							AND AliquotControl.aliquot_type = 'block'
                							AND Collection.participant_id != $participant_id;";
            							$atim_blocks_of_other_participants = getSelectQueryResult($query);
            							if($atim_blocks_of_other_participants) {
            							    $tmp_blocks_labels = array();
            							    foreach($atim_blocks_of_other_participants as $new_atim_block_of_other_participant) {
            							         $tmp_blocks_labels[] = "ATiM tissue block <b>".$new_atim_block_of_other_participant['aliquot_label']."</b> collected on <b>".$new_atim_block_of_other_participant['year_of_collection']."</b>.";
            							    }
            							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]",
            							        '@@WARNING@@',
            							        "#".__LINE__." - The excel patho# and code of the block match the tissue block aliquot label of <u>another participant</u>. Please confirm no error could have been done into the excel source file.",
            							        "See excel block code <b>$excel_block_code</b> with patho # <b>$excel_no_patho</b> and following atim blocks aliquot label of other participants for $summary_label_participant_excel_nominal_data and more : <br> . . . . - ".implode('.<br> . . . . - ', $tmp_blocks_labels).".");
            							}
            							
                                        // *** NEW STEP **************************************************************************************************************************************************************
            							//	Create Collection When Required plus get the collection_id
            							// ***************************************************************************************************************************************************************************
            							
                                       if(!isset($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key])) {
    										$collection_data = array(
    											'participant_id' => $participant_id,
    											'acquisition_label' => 'Pathology Blocks Collection',
    											'collection_property' => 'participant collection',
    											'qc_nd_pathology_nbr' => $excel_no_patho,
    											'collection_site' => $excel_collection_site,
    											'collection_notes' => (strlen($excel_line_data['Note de collection'])? ' '.str_replace('"', '\"', $excel_line_data['Note de collection']).'. ': '').'Created by the process to download the pathology blocks data from excel file on '.date("Y-m-d").'.'
                                            );
    										if($excel_collection_datetime) {
    											$collection_data['collection_datetime'] = $excel_collection_datetime;
    											$collection_data['collection_datetime_accuracy'] = ($excel_collection_datetime_accuracy == 'c')? 'h' : $excel_collection_datetime_accuracy;
    										}
    										$collection_id = customInsertRecord(array('collections' => $collection_data));
    										$created_collections++;
            								$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key] = array('collection_id' => $collection_id, 'tissues' => array());
            							}
            							$collection_id = $excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key]['collection_id'];
            							
            							if(isset($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections_with_no_block'][$excel_collection_data_to_atim_data_key])) {
            							    recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", 
            							        '@@ERROR@@', 
            							        "#".__LINE__." - A collection with no block (to flag block not found or destroyed - field 'Enumeration des blocs' empty) still has been created with same patho # and date. Please delete this collection after migration.",
                                                "See excel block collection on date <b>$excel_collection_datetime_formated_for_summary</b> with patho # <b>$excel_no_patho</b> for $summary_label_participant_excel_nominal_data.");
            							}
            							
            							// *** NEW STEP **************************************************************************************************************************************************************
            							//	Create/Load Tissue
            							// ***************************************************************************************************************************************************************************
            							
            							$sample_master_id = null;
            							$atim_sample_data_key = $excel_block_prefix.'-'.$qc_nd_surgery_biopsy_details;
            							if(!isset($excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key]['tissues'][$atim_sample_data_key])) {
            								$sample_notes[] = "Created by the process to download the pathology blocks data from excel file on ".date("Y-m-d").".";
            								$sample_data = array(
            									'sample_masters' => array(
            										'collection_id' => $collection_id,
            										'sample_control_id' => $atim_controls['sample_controls']['tissue']['id'],
            										'initial_specimen_sample_type' => 'tissue',
            										'qc_nd_sample_label' => "n/a - n/a n/a",
            										'sample_code' => 'tmp_tissue_'.($created_tissues),
            										'notes' => implode(' ', $sample_notes)),
            									'specimen_details' => array(),
            									$atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
            									    'qc_nd_surgery_biopsy_details' => $qc_nd_surgery_biopsy_details
            									));
            								$excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key]['tissues'][$atim_sample_data_key] = customInsertRecord($sample_data);
            								$created_tissues++;
            							}
            							$sample_master_id = $excel_participant_data_to_atim_data[$excel_participant_data_to_atim_data_key]['collections'][$excel_collection_data_to_atim_data_key]['tissues'][$atim_sample_data_key];
            							
            							// *** NEW STEP **************************************************************************************************************************************************************
            							//	Create block
                                        // ***************************************************************************************************************************************************************************
            							
                                        $created_excel_block_aliquot_label = "$excel_no_patho-$excel_block_code";
            							$aliquot_data = array(
            								'aliquot_masters' => array(
            									"barcode" => 'tmp_block_'.($created_blocks),
            									"aliquot_label" => $created_excel_block_aliquot_label,
            									"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
            									"collection_id" => $collection_id,
            									"sample_master_id" => $sample_master_id,
            									'in_stock' => 'yes - available',
                                                'notes' => 'Created by the process to download the pathology blocks data from excel file on '.date("Y-m-d").'.'),
            								$atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
            									'block_type'  => 'paraffin',		
            									'sample_position_code' => $excel_block_code));
            							setStorageData($aliquot_data, $excel_line_data, $created_excel_block_aliquot_label, $summary_label_participant_excel_nominal_data, $excel_file_name);					
            							$created_excel_block_aliquot_master_id = customInsertRecord($aliquot_data);
            							$created_blocks++;
            							$block_has_been_created = true;
            							
            							// *** NEW STEP **************************************************************************************************************************************************************
            							//	Check if block matches an exiting block into ATiM that has been created for the TMA block migration, then link all cores to the created block and delete the previous block. 
            							//	Check exising participant ATiM Blocks that match approximatively the aliquot_label created to generate warnign 
            							// ***************************************************************************************************************************************************************************
                                        
            							//Check block created for a TMA block match the created block				
            							$atim_block_created_for_tma_aliquot_data = array();
                                        $query = "SELECT AliquotMaster.id as aliquot_master_id,
                                            AliquotMaster.aliquot_label,
                							AliquotMaster.sample_master_id,
                							AliquotMaster.collection_id,
                							Collection.*
                							FROM aliquot_masters AliquotMaster
                							INNER JOIN aliquot_controls AliquotControl ON AliquotControl.id = AliquotMaster.aliquot_control_id
                							INNER JOIN sample_controls SampleControl ON SampleControl.id = AliquotControl.sample_control_id
                							INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
                							WHERE AliquotMaster.deleted <> 1
                							AND AliquotMaster.aliquot_label = '".str_replace("'", "''", $created_excel_block_aliquot_label)."'
                							AND SampleControl.sample_type = 'tissue'
                							AND AliquotControl.aliquot_type = 'block'
            							    AND Collection.participant_id = $participant_id
            							    AND AliquotMaster.id != $created_excel_block_aliquot_master_id
                                            AND Collection.acquisition_label = 'Collection Created From TMA Layout'
                                            AND AliquotMaster.created_by = 9;";
                                        $atim_block_created_for_tma_aliquot_data_tmp = getSelectQueryResult($query);
                                        if(sizeof($atim_block_created_for_tma_aliquot_data_tmp) == 1) {
                                            //Blocks match: 1 to 1
                                            $atim_block_created_for_tma_aliquot_data = $atim_block_created_for_tma_aliquot_data_tmp[0];
                                        } else if($atim_block_created_for_tma_aliquot_data_tmp) {
                                            pr('-- Tissue Block Core To Develop #001 -------------------');
                                            pr("See $summary_label_participant_excel_nominal_data");
                                            pr($excel_line_data);
                                            pr($tmp_block);
                                        }
                                        
                                        //Check block patho and code still into ATiM and not created for TMA to geneate warning
                                        $query = "SELECT AliquotMaster.id as aliquot_master_id,
                                            AliquotMaster.aliquot_label,
                                            AliquotMaster.sample_master_id,
                                            AliquotMaster.collection_id,
                                            AliquotMaster.created as aliquot_created,
                                            AliquotMaster.created_by as aliquot_created_by,
                                            Collection.*
                                            FROM aliquot_masters AliquotMaster
                                            INNER JOIN aliquot_controls AliquotControl ON AliquotControl.id = AliquotMaster.aliquot_control_id
                                            INNER JOIN sample_controls SampleControl ON SampleControl.id = AliquotControl.sample_control_id
                                            INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
                                            WHERE AliquotMaster.deleted <> 1
                                            AND AliquotMaster.aliquot_label REGEXP '$block_label_regular_expression'
                                            AND SampleControl.sample_type = 'tissue'
                                            AND AliquotControl.aliquot_type = 'block'
                                            AND Collection.participant_id = $participant_id
                                            AND AliquotMaster.id NOT IN ($created_excel_block_aliquot_master_id, ".($atim_block_created_for_tma_aliquot_data? $atim_block_created_for_tma_aliquot_data['aliquot_master_id'] : '-1').");";
                                        $atim_block_created_for_tma_aliquot_data_tmp = getSelectQueryResult($query);
                                        if($atim_block_created_for_tma_aliquot_data_tmp) {
                                            $atim_block_still_created_and_matching_aliquot_label = array();
                                            $atim_block_just_created_and_matching_aliquot_label = array();
                                            foreach($atim_block_created_for_tma_aliquot_data_tmp as $tmp_dup_code) {
                                                if($tmp_dup_code['aliquot_created'] == $import_date && $tmp_dup_code['aliquot_created_by'] == $migration_user_id) {
                                                    $atim_block_just_created_and_matching_aliquot_label[] = $tmp_dup_code['aliquot_label'];
                                                } else {
                                                    $atim_block_still_created_and_matching_aliquot_label[] = $tmp_dup_code['aliquot_label'];
                                                }
                                            }
                                            if($atim_block_just_created_and_matching_aliquot_label) {
                                                recordErrorAndMessage('Block Core Reassigned'." [FILE : $excel_file_name]",
                                                    '@@WARNING@@',
                                                    "#".__LINE__." - At least one ATiM block created by this migration process (based on parsed .xls (see above)) matches exactly or approximatively the Patho# plus code (from excel) of the new created block. The new block has been created but please validate this block is not one of the listed blocks below. Please confirm and/or correct data after migration.",
                                                    "Please validate the created block with label '$created_excel_block_aliquot_label' is not one of the following blocks of the participant :'".implode("', '", $atim_block_just_created_and_matching_aliquot_label)."'. See $summary_label_participant_excel_nominal_data."); 
                                            }
                                            if($atim_block_still_created_and_matching_aliquot_label) {
                                                recordErrorAndMessage('Block Core Reassigned'." [FILE : $excel_file_name]",
                                                    '@@WARNING@@',
                                                    "#".__LINE__." - At least one existing participant ATiM block matching exactly or approximatively the Patho# plus code of the excel file have been found into ATiM. The new block has been created but please validate this block is not one of the listed blocks below. Please confirm and/or correct data after migration.",
                                                    "Please validate the created block with label '$created_excel_block_aliquot_label' is not one of the following blocks of the participant :'".implode("', '", $atim_block_still_created_and_matching_aliquot_label)."'. See $summary_label_participant_excel_nominal_data."); 
                                            }
                                        }
                                        if($atim_block_created_for_tma_aliquot_data) {
        						            recordErrorAndMessage('Block Core Reassigned'." [FILE : $excel_file_name]",
                                                '@@MESSAGE@@',
                                                "#".__LINE__." - One existing participant ATiM block (created to import TMA block in 2015) matches the Patho# plus code of the excel file. System will delete this block and link all its TMA cores to the new created block (excepted if error detected below). Please validate.",
                                                "ATiM tissue block (created for TMA core) '<b>".$atim_block_created_for_tma_aliquot_data['aliquot_label']."</b>' will be replaced by created new block '<b>$created_excel_block_aliquot_label</b>'. Please validate. See $summary_label_participant_excel_nominal_data.");
                                            $atim_block_created_for_tma_aliquot_master_id = $atim_block_created_for_tma_aliquot_data['aliquot_master_id'];
            						        //Check tissue block has not been used for anything else than realiquoting to core (test to validate block can be deleted)
            						        $query = "SELECT CONCAT(AliquotInternalUse.id, '#1') AS id
            							        FROM aliquot_internal_uses AS AliquotInternalUse
            							        WHERE AliquotInternalUse.deleted <> 1 AND AliquotInternalUse.aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id
            							        UNION ALL
            							        SELECT CONCAT(SourceAliquot.id, '#2') AS id
            							        FROM source_aliquots AS SourceAliquot
            							        WHERE SourceAliquot.deleted <> 1 AND SourceAliquot.aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id
            							        UNION ALL
            							        SELECT CONCAT(QualityCtrl.id, '#3') AS id
            							        FROM quality_ctrls AS QualityCtrl
            							        WHERE QualityCtrl.deleted <> 1 AND QualityCtrl.aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id
            							        UNION ALL
            							        SELECT CONCAT(OrderItem.id, '#4') AS id
            							        FROM order_items OrderItem
            							        WHERE OrderItem.deleted <> 1 AND OrderItem.aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id
            							        UNION ALL
            							        SELECT CONCAT(AliquotReviewMaster.id, '#5') AS id
            							        FROM aliquot_review_masters AS AliquotReviewMaster
            							        WHERE AliquotReviewMaster.deleted <> 1 AND AliquotReviewMaster.aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id
            							        UNION ALL
            							        SELECT CONCAT(Realiquoting.id, '#6') AS id
            							        FROM realiquotings AS Realiquoting
            							        WHERE Realiquoting.deleted <> 1 AND Realiquoting.child_aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id;";
                                            $check_aliquot_use_data = getSelectQueryResult($query);
                                            if($check_aliquot_use_data) {
                                                pr('-- Tissue Block Core To Develop #003 -------------------');
                                                pr("See $summary_label_participant_excel_nominal_data");
                                                pr($excel_line_data);
                                                pr($atim_block_created_for_tma_aliquot_data);
                                                pr($check_aliquot_use_data);
                                            } else {
                                                // Get realiquoted aliquots from the tissue block still created into ATiM for TAM blocks
                                                $query = "SELECT Realiquoting.id as realiquoting_id,
                                                    ChildSampleControl.sample_type,
                                                    ChildAliquotControl.aliquot_type,
                                                    ChildAliquotMaster.id AS aliquot_master_id,
                                                    ChildAliquotMaster.*,
                                                    ChildAliquotDetail.*
                                                    FROM realiquotings AS Realiquoting
                                                    JOIN aliquot_masters AS ChildAliquotMaster ON ChildAliquotMaster.id = Realiquoting.child_aliquot_master_id
                                                    JOIN aliquot_controls AS ChildAliquotControl ON ChildAliquotMaster.aliquot_control_id = ChildAliquotControl.id
                                                    JOIN sample_controls AS ChildSampleControl ON ChildSampleControl.id = ChildAliquotControl.sample_control_id
                                                    LEFT JOIN ".$atim_controls['aliquot_controls']['tissue-core']['detail_tablename']." AS ChildAliquotDetail ON ChildAliquotDetail.aliquot_master_id = ChildAliquotMaster.id
                                                    WHERE Realiquoting.deleted <> 1  
                                                    AND Realiquoting.parent_aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id";
                                                $atim_core_data = getSelectQueryResult($query);
                                                $atim_core_aliquot_master_ids_to_link_to_new_block = array();
                                                $atim_core_aliquot_master_data_to_link_to_new_block = array();
                                                foreach($atim_core_data as $new_atim_core_data) {
                                                    //New Tissue Core Created From Tissue Block (created by TMA blocs script)
                                                    if($new_atim_core_data['sample_type'].'-'.$new_atim_core_data['aliquot_type'] != 'tissue-core' || $new_atim_core_data['created_by'] != '9') {
                                                        pr('-- Tissue Block Core To Develop #004 -------------------');
                                                        pr("See $summary_label_participant_excel_nominal_data");
                                                        pr($excel_line_data);
                                                        pr($atim_block_created_for_tma_aliquot_data);
                                                        pr($new_atim_core_data);
                                                    } else {
                                                        $atim_core_aliquot_master_ids_to_link_to_new_block[] = $new_atim_core_data['aliquot_master_id'];
                                                        $atim_core_aliquot_master_data_to_link_to_new_block[] = $new_atim_core_data;
                                                    }
                                                }
                                                if(!$atim_core_aliquot_master_ids_to_link_to_new_block) {
                                                    pr('-- Tissue Block Core To Develop #010 -------------------');
                                                    pr("See $summary_label_participant_excel_nominal_data");
                                                    pr($excel_line_data);
                                                    pr($atim_block_created_for_tma_aliquot_data);
                                                    pr($check_aliquot_use_data);
                                            } else {
                                                //Check all cores have not been used (test to validate they can be deleted)
                                                $atim_core_aliquot_master_ids_to_link_to_new_block_strg = implode(',', $atim_core_aliquot_master_ids_to_link_to_new_block);
                                                $query = "SELECT CONCAT(AliquotInternalUse.id, '#1') AS id
                                                    FROM aliquot_internal_uses AS AliquotInternalUse
                                                    WHERE AliquotInternalUse.deleted <> 1 
                                                    AND AliquotInternalUse.aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg)
                                                    UNION ALL
                                                    SELECT CONCAT(SourceAliquot.id, '#2') AS id
                                                    FROM source_aliquots AS SourceAliquot
                                                    WHERE SourceAliquot.deleted <> 1
                                                    AND SourceAliquot.aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg)
                                                    UNION ALL
                                                    SELECT CONCAT(QualityCtrl.id, '#3') AS id
                                                    FROM quality_ctrls AS QualityCtrl
                                                    WHERE QualityCtrl.deleted <> 1 
                                                    AND QualityCtrl.aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg)
                                                    UNION ALL
                                                    SELECT CONCAT(OrderItem.id, '#4') AS id
                                                    FROM order_items OrderItem
                                                    WHERE OrderItem.deleted <> 1 
                                                    AND OrderItem.aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg)
                                                    UNION ALL
                                                    SELECT CONCAT(AliquotReviewMaster.id, '#5') AS id
                                                    FROM aliquot_review_masters AS AliquotReviewMaster
                                                    WHERE AliquotReviewMaster.deleted <> 1 
                                                    AND AliquotReviewMaster.aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg)
                                                    UNION ALL
                                                    SELECT CONCAT(Realiquoting.id, '#6') AS id
                                                    FROM realiquotings AS Realiquoting
                                                    WHERE Realiquoting.deleted <> 1 
                                                    AND Realiquoting.child_aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg)
                                                    AND Realiquoting.parent_aliquot_master_id != $atim_block_created_for_tma_aliquot_master_id
                                                    UNION ALL
                                                    SELECT CONCAT(Realiquoting.id, '#7') AS id
                                                    FROM realiquotings AS Realiquoting
                                                    WHERE Realiquoting.deleted <> 1 
                                                    AND Realiquoting.parent_aliquot_master_id IN ($atim_core_aliquot_master_ids_to_link_to_new_block_strg);";
                                                $check_aliquot_use_data = getSelectQueryResult($query);
                                                if($check_aliquot_use_data) {
                                                    pr('-- Tissue Block Core To Develop #005 -------------------');
                                                    pr("See $summary_label_participant_excel_nominal_data");
                                                    pr($excel_line_data);
                                                    pr($atim_block_created_for_tma_aliquot_data);
                                                    pr($check_aliquot_use_data);
                                                } else {
                                                    //Core can be linked to created block
                                                    foreach($atim_core_aliquot_master_data_to_link_to_new_block as $new_atim_core_data) {					              
                                                        updateTableData($new_atim_core_data['realiquoting_id'], array('realiquotings' => array('deleted' => '1'))); 
                                                        updateTableData($new_atim_core_data['aliquot_master_id'], array('aliquot_masters' => array('deleted' => '1')));
                                                        //New core
                                                        $atim_cores_linked_to_tma_creation_reassigned++;
                                                        $aliquot_data = array(
                                                          'aliquot_masters' => array(
                                                              "barcode" => 'tmp_core_'.($atim_cores_linked_to_tma_creation_reassigned),
                                                              "aliquot_label" => str_replace($atim_block_created_for_tma_aliquot_data['aliquot_label'], $created_excel_block_aliquot_label, $new_atim_core_data['aliquot_label']),
                                                              "aliquot_control_id" => $new_atim_core_data['aliquot_control_id'],
                                                              "collection_id" => $collection_id,
                                                              "sample_master_id" => $sample_master_id,
                                                              'in_stock' => $new_atim_core_data['in_stock'],
                                                              'in_stock_detail' => $new_atim_core_data['in_stock_detail'],
                                                              'storage_datetime_accuracy' => $new_atim_core_data['storage_datetime_accuracy'],
                                                              'storage_master_id' => $new_atim_core_data['storage_master_id'],
                                                              'storage_coord_x' => $new_atim_core_data['storage_coord_x'],
                                                              'storage_coord_y' => $new_atim_core_data['storage_coord_y'],
                                                              'stored_by' => $new_atim_core_data['stored_by'],
                                                              'notes' => $new_atim_core_data['notes']),
                                                          $atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array(
                                                              'qc_nd_core_nature'  => $new_atim_core_data['qc_nd_core_nature']));
                                                        if($new_atim_core_data['study_summary_id']) $aliquot_data['aliquot_masters']['study_summary_id'] = $new_atim_core_data['study_summary_id'];
                                                        if($new_atim_core_data['storage_datetime']) $aliquot_data['aliquot_masters']['storage_datetime'] = $new_atim_core_data['storage_datetime'];
                                                        if($new_atim_core_data['qc_nd_size_mm']) $aliquot_data[$atim_controls['aliquot_controls']['tissue-core']['detail_tablename']]['qc_nd_size_mm'] = $new_atim_core_data['qc_nd_size_mm'];        							              
                                                        $created_reassigned_core_aliquot_master_id = customInsertRecord($aliquot_data);
                                                        customInsertRecord(array('realiquotings' => array('parent_aliquot_master_id' => $created_excel_block_aliquot_master_id, 'child_aliquot_master_id' => $created_reassigned_core_aliquot_master_id)));
                                                    } 
                                                    //Block created for TMA can be deleted
                                                    $query = "SELECT *
                                                        FROM realiquotings AS Realiquoting
                                                        WHERE Realiquoting.deleted <> 1
                                                        AND Realiquoting.parent_aliquot_master_id = $atim_block_created_for_tma_aliquot_master_id";
                                                    $check_undeleted_block_childs = getSelectQueryResult($query);
                                                    if(empty($check_undeleted_block_childs)) {     
                                                        updateTableData($atim_block_created_for_tma_aliquot_master_id, array('aliquot_masters' => array('deleted' => '1')));
                                                        $atim_blocks_linked_to_tma_creation_deleted++;
                                                    }
                                                    $atim_block_created_for_tma_sample_master_id = $atim_block_created_for_tma_aliquot_data['sample_master_id'];
                                                    $query = "SELECT sample_master_id FROM specimen_review_masters WHERE deleted <> 1 AND sample_master_id = $atim_block_created_for_tma_sample_master_id
                                                        UNION ALL 
                                                        SELECT sample_master_id FROM quality_ctrls WHERE deleted <> 1 AND sample_master_id = $atim_block_created_for_tma_sample_master_id
                                                        UNION ALL
                                                        SELECT parent_id FROM sample_masters WHERE deleted <> 1 AND parent_id = $atim_block_created_for_tma_sample_master_id";
                                                    $check_undeleted_tissue_aliquots_and_uses = getSelectQueryResult($query);
                                                    if(empty($check_undeleted_tissue_aliquots_and_uses)) {   
                                                        updateTableData($atim_block_created_for_tma_sample_master_id, array('sample_masters' => array('deleted' => '1')));
                                                        $atim_tissue_linked_to_tma_creation_deleted++;
                                                    }
                                                    $atim_block_created_for_tma_collection_id = $atim_block_created_for_tma_aliquot_data['collection_id'];
                                                    $query = "SELECT * FROM sample_masters WHERE deleted <> 1 AND collection_id = $atim_block_created_for_tma_collection_id;";
                                                    $check_undeleted_collection_samples = getSelectQueryResult($query);
                                                    if(empty($check_undeleted_collection_samples)) {
                                                        updateTableData($atim_block_created_for_tma_collection_id, array('collections' => array('deleted' => '1')));
                                                        $atim_collection_linked_to_tma_creation_deleted++;
                                                    }
                							      }
            							      }
            						       }
            						    }
            						}
        						}
        					}
    					}
    				}
    			}
    		}
    		
    		if(!$block_has_been_created) {
    		    $data_to_display = array('file' => $excel_file_name, 'line' => $line_number);
    		    foreach($expected_headers as $new_header) {
    		        $data_to_display[$new_header] = $excel_line_data[$new_header];
    		    }
    		    $blocks_not_migrated[] = $data_to_display;
    		}
    		
		} // End of new line
	}
	
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($matching_collections - $previous_file_matching_collections)." ATiM collections used");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($created_collections - $previous_file_created_collections)." collections created");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($created_tissues - $previous_file_created_tissues)." tissues samples created");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($created_blocks - $previous_file_created_blocks)." aliquots created");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($created_storages - $previous_file_created_storages)." storages created");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($atim_blocks_linked_to_tma_creation_deleted - $previous_file_atim_blocks_linked_to_tma_creation_deleted)." blocks created by TMA construction script have been deleted");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($atim_cores_linked_to_tma_creation_reassigned - $previous_file_atim_cores_linked_to_tma_creation_reassigned)." cores created by TMA construction script have been reassigned to created blocks");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($atim_tissue_linked_to_tma_creation_deleted - $previous_file_atim_tissue_linked_to_tma_creation_deleted)." tissue created by TMA construction script ave been deleted");
	recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", ($atim_collection_linked_to_tma_creation_deleted - $previous_file_atim_collection_linked_to_tma_creation_deleted)." collections created by TMA construction script have been deleted");
	
	$previous_file_matching_collections = $matching_collections;
	$previous_file_created_collections = $created_collections;
	$previous_file_created_tissues = $created_tissues;
	$previous_file_created_blocks = $created_blocks;
	$previous_file_atim_blocks_linked_to_tma_creation_deleted = $atim_blocks_linked_to_tma_creation_deleted;
	$previous_file_atim_cores_linked_to_tma_creation_reassigned= $atim_cores_linked_to_tma_creation_reassigned;
	$previous_file_atim_collection_linked_to_tma_creation_deleted = $atim_collection_linked_to_tma_creation_deleted;
	$previous_file_atim_tissue_linked_to_tma_creation_deleted = $atim_tissue_linked_to_tma_creation_deleted;
	$previous_file_created_storages = $created_storages;
	
	dislayErrorAndMessage(false, 'Migration Summary :: ' . $excel_file_name, false);
	$import_summary = array();
}

echo "<br><br><br><FONT COLOR=\"green\" ><b>************************************************************************************************************************************************************<br>";
echo "Conclusions <br>";
echo "************************************************************************************************************************************************************</b></FONT>";

recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$matching_collections ATiM collections used");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_collections collections created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_tissues tissues samples created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_blocks aliquots created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_storages storages created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$atim_blocks_linked_to_tma_creation_deleted blocks created by TMA construction script have been deleted");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$atim_cores_linked_to_tma_creation_reassigned cores created by TMA construction script have been reassigned to created blocks");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$atim_tissue_linked_to_tma_creation_deleted tissue created by TMA construction script ave been deleted");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$atim_collection_linked_to_tma_creation_deleted collections created by TMA construction script have been deleted");

$final_queries = array(
	"UPDATE sample_masters SET sample_code = id WHERE sample_code LIKE 'tmp_tissue_%';",
	"UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE 'tmp_block_%';",
	"UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE 'tmp_core_%';",
	"UPDATE storage_masters SET code = id WHERE code LIKE 'tmp_storage_%';",
    "UPDATE collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl
		SET Collection.treatment_master_id = TreatmentMaster.id
		WHERE Collection.deleted <> 1
		AND Collection.treatment_master_id IS NULL
		AND TreatmentMaster.deleted <> 1
		AND TreatmentMaster.participant_id = Collection.participant_id
		AND TreatmentMaster.treatment_control_id = TreatmentControl.id
	    AND TreatmentControl.flag_active = 1
	    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
		AND Collection.collection_datetime IS NOT NULL
		AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
	    AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
	    AND (TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE CONCAT('%', Collection.qc_nd_pathology_nbr, '%') OR Collection.qc_nd_pathology_nbr LIKE CONCAT('%', TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs, '%'))
        AND LENGTH(Collection.qc_nd_pathology_nbr) >= 2
	    AND LENGTH(TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs) >= 2
        AND Collection.created_by = '".$migration_user_id."'
		AND Collection.created = '".$import_date."';",
	"UPDATE collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl, sample_masters SampleMaster, sample_controls SampleControl
		SET Collection.treatment_master_id = TreatmentMaster.id
		WHERE Collection.deleted <> 1
		AND Collection.treatment_master_id IS NULL
		AND TreatmentMaster.deleted <> 1
		AND TreatmentMaster.participant_id = Collection.participant_id
		AND TreatmentMaster.treatment_control_id = TreatmentControl.id
	    AND TreatmentControl.flag_active = 1
	    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
		AND SampleMaster.deleted <> 1
		AND SampleMaster.collection_id = Collection.id
		AND SampleMaster.sample_control_id = SampleControl.id
		AND SampleControl.sample_type = 'tissue'
		AND Collection.collection_datetime IS NOT NULL
		AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
	    AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
        AND (Collection.qc_nd_pathology_nbr IS NULL OR Collection.qc_nd_pathology_nbr = '')
        AND Collection.created_by = '".$migration_user_id."'
		AND Collection.created = '".$import_date."';",
    "UPDATE collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl, sample_masters SampleMaster, sample_controls SampleControl
		SET Collection.treatment_master_id = TreatmentMaster.id
		WHERE Collection.deleted <> 1
		AND Collection.treatment_master_id IS NULL
		AND TreatmentMaster.deleted <> 1
		AND TreatmentMaster.participant_id = Collection.participant_id
		AND TreatmentMaster.treatment_control_id = TreatmentControl.id
	    AND TreatmentControl.flag_active = 1
	    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
		AND SampleMaster.deleted <> 1
		AND SampleMaster.collection_id = Collection.id
		AND SampleMaster.sample_control_id = SampleControl.id
		AND SampleControl.sample_type = 'tissue'
		AND Collection.collection_datetime IS NOT NULL
		AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
	    AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
	    AND LENGTH(Collection.qc_nd_pathology_nbr) >= 2
        AND (TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs IS NULL OR TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs = '')
        AND Collection.created_by = '".$migration_user_id."'
		AND Collection.created = '".$import_date."';"
);

if($view_update) addViewUpdate($final_queries);
if($permissions_regenerated_to_zero) $final_queries[] = "UPDATE versions SET permissions_regenerated = 0;";
if($insert_into_revs) insertIntoRevsBasedOnModifiedValues();

foreach($final_queries as $new_query) customQuery($new_query);

dislayErrorAndMessage($commit_at_the_end);

echo "<br><br><FONT COLOR=\"RED\" >
==========================================================================================================================================<br><br>
<b> Unmigrated blocks</b> <br><br>
==========================================================================================================================================</FONT><br>";

if(!$blocks_not_migrated) {
    echo "<br><FONT COLOR=\"BLACK\" >None!</FONT><br>";
} else {
    $firstRecord = true;
    foreach($blocks_not_migrated as $lineData) {
        if($firstRecord) {
            $newLineToDisplay = "\"";
            $headers = array_keys($lineData);
            $newLineToDisplay .= implode("\";\"", $headers);
            $newLineToDisplay .= "\"<br>";
            echo $newLineToDisplay;
        }
        $firstRecord = false;
        $newLineToDisplay = "\"";
        $newLineToDisplay .= implode("\";\"", $lineData);
        $newLineToDisplay .= "\"<br>";
        echo $newLineToDisplay;
    }
}

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function truncate() {
	global $migration_user_id;
	global $import_date;
	
	$truncate_date_limit = substr($import_date, 0, 10);
	
	$truncate_queries = array(
	    "DELETE FROM realiquotings  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
	    
		"DELETE FROM  ad_tissue_cores WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  ad_tissue_cores_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
        "DELETE FROM  ad_blocks WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  ad_blocks_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
        "LOCK TABLES `aliquot_masters` WRITE;" ,
	    "DELETE FROM aliquot_masters  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';", 
		"UNLOCK TABLES;", 
	    "DELETE FROM aliquot_masters_revs  WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';", 
		"DELETE FROM  sd_spe_tissues WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  sd_spe_tissues_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  specimen_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  specimen_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM sample_masters_revs WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';", 
		
	    "DELETE FROM view_aliquot_uses WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM view_aliquots WHERE collection_id IN (SELECT id FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM view_samples WHERE collection_id IN (SELECT id FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM view_collections WHERE collection_id IN (SELECT id FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	        
	    "DELETE FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM collections_revs WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';");
    
	foreach($truncate_queries as $query) {
	    customQuery($query, __FILE__, __LINE__);
	}
}

function formateDateForSummary($date, $accuracy) {
    if($date) {
        switch($accuracy) {
            case 'd':
                return substr($date, 0, 7);
                break;
            case 'm':
                return substr($date, 0, 4);
            case 'c':
            case 'h':
            case 'i':
            case '':
                return substr($date, 0, 10);
                break;
            default:
                pr("<FONT COLOR='RED'>WARNING .... Date :  formateDateForSummary($date, $accuracy)</FONT>");
        }    
    }
    return '';
}

function setStorageData(&$aliquot_data, $excel_line_data, $aliquot_label, $summary_label_participant_excel_nominal_data, $excel_file_name) {
	global $atim_controls;
	global $storages;
	global $created_storages;
	
	$room_short_label = 'Patho-blocks';
	
	$storage_properties = array(
		'room' => 'Chambre',
//		'row' => '',
		'section' => 'Section',
		'shelf' => 'Tablette',
		'blocks box' => 'Boite',
		'position' => 'Tiroir');
	$selection_label = '';
	$previous_storage_master_id = null;
	foreach($storage_properties as $storage_type => $excel_field) {
//		$storage_value = ($storage_type == 'room')? $room_short_label : $excel_line_data[$excel_field];
		$storage_value = $excel_line_data[$excel_field];
		//Check data
		if($storage_type != 'position' && !isset($atim_controls['storage_controls'][$storage_type])) migrationDie("Storage $storage_type does not exist into ATiM.");
		if(!strlen($storage_value)) {
			recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - Position information is missing: See '$excel_field' value. The position of the block won't be set.", "See block [$aliquot_label] of the $summary_label_participant_excel_nominal_data.");
			return;
		} else if($storage_value == 'NUL' || ($storage_value != $room_short_label && strlen($storage_value) > 5)) {
			recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "#".__LINE__." - Position information format error: See '$excel_field' value [$storage_value]. The position of the block won't be set.", "See block [$aliquot_label] of the $summary_label_participant_excel_nominal_data.");
			return;
		}
		if($storage_type == 'position' && !preg_match('/^[1-8]$/', $storage_value)) {
			recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "#".__LINE__." - Block position is wrong: See '$excel_field' value. The position of the block won't be set.", "See block [$aliquot_label] and position [$storage_value] of the $summary_label_participant_excel_nominal_data.");
			return;
		}	
		if($storage_type != 'position') {
			//Get storage_master_id
			$selection_label = (strlen($selection_label)? $selection_label.'-' : '').$storage_value;
			if(isset($storages[$selection_label])) {
				$previous_storage_master_id = $storages[$selection_label];
			} else {
				$query = "SELECT id FROM storage_masters WHERE storage_control_id = ".$atim_controls['storage_controls'][$storage_type]['id']." AND deleted <> 1 AND selection_label = '".str_replace("'", "''", $selection_label)."'";
				$atim_data = getSelectQueryResult($query);
				if($atim_data) {
					$storages[$selection_label] = $atim_data[0]['id'];
					$previous_storage_master_id = $atim_data[0]['id'];
				}  else {
					$storage_data = array(
						'storage_masters' => array(
							"code" => 'tmp_storage_'.($created_storages),
							"short_label" => $storage_value,
							"selection_label" => $selection_label,
							"storage_control_id" => $atim_controls['storage_controls'][$storage_type]['id'],
							'notes' => 'Created by the process to download the pathology blocks data from excel file on '.date("Y-m-d").'.'),
						$atim_controls['storage_controls'][$storage_type]['detail_tablename'] => array());
					if($previous_storage_master_id) $storage_data['storage_masters']['parent_id'] = $previous_storage_master_id;
					$previous_storage_master_id = customInsertRecord($storage_data);
					$storages[$selection_label] = $previous_storage_master_id;
					$created_storages++;
				}
			}
		} else {
			//Set position
			if(!$previous_storage_master_id) migrationDie("Block box not created. See $summary_label_participant_excel_nominal_data."); 
			$aliquot_data['aliquot_masters']['storage_master_id'] = $previous_storage_master_id;
			$aliquot_data['aliquot_masters']['storage_coord_x'] = $storage_value;	
		}
	}
}	

function addViewUpdate(&$final_queries) {
	global $migration_user_id;
	global $import_date;
	
    $truncate_date_limit = date("Y-m-d");
    
    $final_queries[] = "DELETE FROM view_aliquots WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE modified_by = $migration_user_id AND modified LIKE  '$truncate_date_limit%' AND deleted = 1);";
    $final_queries[] = "DELETE FROM view_samples WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE modified_by = $migration_user_id AND modified LIKE  '$truncate_date_limit%' AND deleted = 1);";
    $final_queries[] = "DELETE FROM view_collections WHERE collection_id IN (SELECT id FROM collections WHERE modified_by = $migration_user_id AND modified LIKE  '$truncate_date_limit%' AND deleted = 1);";
	
    $final_queries[] = "INSERT INTO view_collections (
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Collection.collection_protocol_id AS collection_protocol_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
        WHERE Collection.deleted <> 1
			AND Collection.created = '$import_date' AND Collection.created_by = '$migration_user_id'
);";

    $final_queries[] = 'INSERT INTO view_samples (
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
    
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
		Collection.collection_protocol_id AS collection_protocol_id,
    
		Participant.participant_identifier,
    
		Collection.acquisition_label,
    
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
    
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
		
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg,
		 
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
    
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
		WHERE SampleMaster.deleted != 1 
AND SampleMaster.created = "'.$import_date.'" AND SampleMaster.created_by = "'.$migration_user_id.'"
);';

    $final_queries[] = '
 INSERT INTO view_aliquots (
SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
			Collection.bank_id,
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id,
		
			Participant.participant_identifier,
		
			Collection.acquisition_label,
            Collection.collection_protocol_id AS collection_protocol_id,
		
			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,
		
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			AliquotMaster.in_stock_detail,
			StudySummary.title AS study_summary_title,
			StudySummary.id AS study_summary_id,
		
			StorageMaster.code,
			StorageMaster.selection_label,
			AliquotMaster.storage_coord_x,
			AliquotMaster.storage_coord_y,
		
			StorageMaster.temperature,
			StorageMaster.temp_unit,
		
			AliquotMaster.created,
		
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(Collection.collection_datetime IS NULL, -1,
			 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(SpecimenDetail.reception_datetime IS NULL, -1,
			 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(DerivativeDetail.creation_datetime IS NULL, -1,
			 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,
    
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes,
		
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
		
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
			WHERE  AliquotMaster.deleted != 1 
 AND AliquotMaster.created = "'.$import_date.'" AND AliquotMaster.created_by = "'.$migration_user_id.'"
);';
    
    
    
$final_queries[] = "
    INSERT INTO view_aliquot_uses (
		SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'realiquoted to' AS use_definition,
CONCAT(AliquotMasterChild.aliquot_label,' [',AliquotMasterChild.barcode,']') AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1
        AND AliquotMaster.created = '".$import_date."' AND AliquotMaster.created_by = '".$migration_user_id."'
    );";         
}

?>
		