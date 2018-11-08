<?php

/**
 * Script to dowload new tissu blocks core and TMA block int ATiM ABCF.
 *
 * Notes:
 *   - No collection, sample and block will be created by the script.
 *   - Tissue Core will be created if the system is able to find a tissue block into ATiM matching bank, pathology id + block code. 
 *   - No control on existing core will be done. A new core will be created each time.
 *   - An existing TMA block will be reused then no control on duplicated position will be done.
 */
 
require_once 'system.php';

global $atim_storage_master_id_to_storage_data;
$atim_storage_master_id_to_storage_data = array();
global $created_storage_counter;
$created_storage_counter = 0;

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
	list($excel_file_name, $tmp) = $file_data;
	$tmp_files_names_list[] = $excel_file_name;
}

displayMigrationTitle('QBCF TMA Block Creation');

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** GET CONTROL SAMPLE ***

$query = "SELECT id FROM collections WHERE deleted <> 1 AND qbcf_pathology_id = 'Control' AND collection_property = 'independent collection';";
$query_data = getSelectQueryResult($query);
if(!$query_data) die("Create frist a 'Control' collection with patholodgy id = 'Control'!");
if(sizeof($query_data) > 1) die("Merge 'Control' collections with patholodgy id = 'Control'!");
$control_collection_id = $query_data[0]['id'];

$controls_samples = array();
$query = "SELECT SampleMaster.collection_id,
	SampleMaster.id AS sample_master_id,
	SampleMaster.qbcf_tma_sample_control_code,
	SampleDetail.tissue_source
	FROM sample_masters SampleMaster
	INNER JOIN ".$atim_controls['sample_controls']['tissue']['detail_tablename']." SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
	WHERE SampleMaster.collection_id = $control_collection_id
	AND SampleMaster.deleted <> 1 AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id'];
foreach(getSelectQueryResult($query) as $new_sample_flagged_control) {
	$sample_key = trim($new_sample_flagged_control['qbcf_tma_sample_control_code']).'--'.$new_sample_flagged_control['tissue_source'];
	$controls_samples[$sample_key] = $new_sample_flagged_control['sample_master_id'];
}

// *** PARSE EXCEL FILES ***

$tissue_sample_detail_tablename = $atim_controls['sample_controls']['tissue']['detail_tablename'];
$tissue_block_sample_detail_tablename = $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'];
$tissue_core_sample_detail_tablename = $atim_controls['aliquot_controls']['tissue-core']['detail_tablename'];

$bank_to_bank_id = array();
$created_sample_counter = 0;
$created_aliquot_counter = 0;
$file_counter = 0;
foreach($excel_files_names as $file_data) {
	$file_counter++;
	
	// New Excel File
	
	list($excel_file_name, $worksheet_name) = $file_data;
	$excel_file_name_for_ref = "File#$file_counter - ".((strlen($excel_file_name) > 30)? substr($excel_file_name, '0', '30')."...xls" : $excel_file_name);
	
	recordErrorAndMessage('TMA Blocks Files', '@@MESSAGE@@', "Excel Files Parsed", "File#$file_counter - $excel_file_name");
	
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
		if($line_number > 1) {
			foreach($excel_line_data as &$new_val) if(preg_match('/^\.$/', $new_val)) $new_val = '';
			$excel_data_references = "Excel '<b>$excel_file_name_for_ref</b>', Worksheet '<b>$worksheet_name</b>', Line '<b>$line_number</b>'";
			if(strlen($excel_line_data['sample Type'])) {
			    //Get Block id
			    $tma_block_short_label = $excel_line_data['TMA ID'] . ((isset($excel_line_data['TMA number']) && strlen($excel_line_data['TMA number']))? ' '.$excel_line_data['TMA number'] : '');
			    $block_storage_master_id = getStorageMasterId($excel_data_references, $tma_block_short_label, 'TMA-blc 29X29', null);
				if($block_storage_master_id) {
					//Check core position
					$storage_coord_x = $excel_line_data['X'];
					$storage_coord_y = $excel_line_data['Y'];
					if(preg_match('/^(([1-9])|(1[0-9])|(2[0-7]))$/', $storage_coord_x)  && preg_match('/^(([1-9])|(1[0-9])|(2[0-7]))$/', $storage_coord_y)) {
                        $storage_coord_x += 2;
						$storage_coord_y += 2;
						// Build core notes
						$excel_notes = array(
						    ((isset($excel_line_data['NUMERO CORE']) && strlen($excel_line_data['NUMERO CORE']))? 'NUMERO CORE : '.$excel_line_data['NUMERO CORE'].'.' : ''),
						    ((isset($excel_line_data['lignée + Code ATiM']) && strlen($excel_line_data['lignée + Code ATiM']))? 'lignée + Code ATiM : '.$excel_line_data['lignée + Code ATiM'].'.' : ''),
						    ((isset($excel_line_data['notes']) && $excel_line_data['notes']))? $excel_line_data['notes'] : '');
						$excel_notes = array_filter($excel_notes, function($var){return (!($var == '' || is_null($var)));});
						$excel_notes = implode(' ', $excel_notes);
						//Tissue source
						$excel_field = 'Tissue Source';
						$excel_tissue_source = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'tissue_source_list', "TMA Blocks File ($excel_file_name :: $worksheet_name)", $excel_field, "See $excel_data_references.");
						//Build core
						$collection_id = null;
						$tissue_sample_master_id = null;
						$block_aliquot_master_id = null;
						$new_core_aliquot_label = '';
						if($excel_line_data['sample Type'] == 'sample') {
						    // 1- Bank Tissue Core : To link to a block
						    $patho_id = $excel_line_data['Sample Patho ID'];
						    $new_core_aliquot_label = $patho_id;
						    if(strlen($patho_id)) {
    						    $excel_data_references = "block '$patho_id' in ". $excel_data_references;
    						    if($excel_line_data['Control Code']) {
    						        recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@WARNING@@', "Control Code defined for a bank block core. Control code value won't be migrated. Please confirm.", "See $excel_data_references."); 
    						    }
    						    $qbcf_bank_id = null;
    						    if(isset($excel_line_data['Bank'])) {
        							$bank = $excel_line_data['Bank'];
        							if(isset($bank_to_bank_id[$bank])) {
        								$qbcf_bank_id = $bank_to_bank_id[$bank];
        							} else {
        								$banks_data = getSelectQueryResult("SELECT id, name FROM banks WHERE name like '%$bank%'");
        								if(!$banks_data) {
        									recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "Bank unknown into ATiM. Bank won't be considered in core creation.", "See Bank '$bank' associated to $excel_data_references.");
        								} else if(sizeof($banks_data) > 1) {
        									recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "More than one bank matches the bank name. Bank won't be considered in core creation.", "See Bank '$bank' associated to $excel_data_references.");
        								} else {
        									$qbcf_bank_id = $banks_data[0]['id'];
        									$bank_to_bank_id[$bank] = $qbcf_bank_id;
        								}
        							}
    						    }
    							if($excel_tissue_source != 'breast') {
    								recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@WARNING@@', "Specimen value of a bank tissue core different than 'breast' into excel. Please confirm.", "See '$excel_tissue_source' specimen of the $excel_data_references.");
    							}
    							$query = "SELECT Collection.id as collection_id,
    								SampleMaster.id AS sample_master_id,
    								AliquotMaster.id AS aliquot_master_id
    								FROM participants Participant
    								INNER JOIN collections Collection ON Collection.participant_id = Participant.id
    								INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
    								INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
    								INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND SampleMaster.id = AliquotMaster.sample_master_id
    								INNER JOIN $tissue_block_sample_detail_tablename AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
    								WHERE Participant.deleted <> 1
    								AND " . ($qbcf_bank_id? "Participant.qbcf_bank_id = '$qbcf_bank_id'" : "TRUE") . "
    								AND Collection.deleted <> 1
    								AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    								AND SampleMaster.deleted <> 1
    								AND SampleDetail.tissue_source = '$excel_tissue_source'
    								AND AliquotMaster.deleted <> 1
    								AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    								AND AliquotMaster.aliquot_label = '$patho_id';";
    							$query_data = getSelectQueryResult($query);
    							if($query_data) {
    								if(sizeof($query_data) > 1) {
    									recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "More than one bank tissue block of a core has been found into ATiM. New core will be created and linked to the first one. Please confirm.", "See $excel_data_references.");
    								}
    								$collection_id = $query_data[0]['collection_id'];
    								$tissue_sample_master_id = $query_data[0]['sample_master_id'];
    								$block_aliquot_master_id = $query_data[0]['aliquot_master_id'];
    							} else {
    								recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "The bank tissue block of a core is not found into ATiM. No core will be created. Please confirm.",  "See $excel_data_references.");
    							}
							} else {
							    recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "The Sample Patho ID of a breast tissue core is not defined into excel. No core will be created. Please confirm.", "See $excel_data_references.");	
							}								
						} else if($excel_line_data['sample Type'] == 'control') {
							// 2- ControlTissue Core : To link to a control tissue
						    $control_code = $excel_line_data['Control Code'];
						    $new_core_aliquot_label = $control_code;
						    if(strlen($control_code)) {
						        $excel_data_references = "control '$control_code' in ". $excel_data_references;
						        if($excel_line_data['Sample Patho ID']) {
						            recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@WARNING@@', "'Sample Patho ID defined for a control. Value won't be migrated. Please confirm.", "See value '".$excel_line_data['Sample Patho ID']."' defined for $excel_data_references.");
						        }
    							$collection_id = $control_collection_id;
    							$query = "SELECT SampleMaster.id AS sample_master_id
    								FROM collections Collection
    								INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
    								INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
    								WHERE Collection.deleted <> 1
    								AND Collection.id = $collection_id
    								AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    								AND SampleMaster.deleted <> 1
    								AND SampleMaster.qbcf_tma_sample_control_code = '$control_code'
    								AND SampleDetail.tissue_source = '$excel_tissue_source';";
    							$query_data = getSelectQueryResult($query);
    							if($query_data) {
    								if(sizeof($query_data) > 1) {
    									recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "More than one control tissue has been found into ATiM. New core will be created and linked to the first one. Please confirm.", "See '$excel_tissue_source' Control Tissue with code '$patho_id' for $excel_data_references.");
    								}
    								$tissue_sample_master_id = $query_data[0]['sample_master_id'];
    							} else {
    								$created_sample_counter++;
    								$sample_data = array(
    									'sample_masters' => array(
    										"sample_code" => 'tmp_tissue_'.$created_sample_counter,
    										"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
    										"initial_specimen_sample_type" => 'tissue',
    										"collection_id" => $collection_id,
    										'qbcf_is_tma_sample_control' => 'y',
    										'qbcf_tma_sample_control_code' => $control_code),
    									'specimen_details' => array(),
    									$tissue_sample_detail_tablename => array(
    										'tissue_source' => $excel_tissue_source));
    								$tissue_sample_master_id = customInsertRecord($sample_data);
    								addCreatedDataToSummary('New Control Tissue', "Control Tissue ('$excel_tissue_source' ) with code '$control_code'.", $excel_data_references);
    							}
							} else {
							    recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "The Control Code of a control is not defined into Excel. No core 'control' will be created. Please confirm.", "$excel_data_references.");
							}
						} else {
						    die("ERR 8837376 : Sample Type value is different than 'sample' or 'control' (".$excel_line_data['sample Type'].") :: $excel_data_references");
						}
						if($tissue_sample_master_id) {
							//Create core
							$created_aliquot_counter++;
							$aliquot_data = array(
								'aliquot_masters' => array(
									"barcode" => 'tmp_core_'.$created_aliquot_counter,
									'aliquot_label' => $new_core_aliquot_label,
									"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-core']['id'],
									"collection_id" => $collection_id,
									"sample_master_id" => $tissue_sample_master_id,
									'storage_master_id' => $block_storage_master_id,
									'storage_coord_x' => $storage_coord_x,
									'storage_coord_y' => $storage_coord_y,
									'in_stock' => 'yes - available',
									'notes' => $excel_notes),
								$atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array());
							$core_aliquot_master_id = customInsertRecord($aliquot_data);
							addCreatedDataToSummary('Core', "Core creation : $new_core_aliquot_label", "See $excel_data_references");
							if($block_aliquot_master_id) {
								$realiquoting_data = array('realiquotings' => array(
									'parent_aliquot_master_id' => $block_aliquot_master_id,
									'child_aliquot_master_id' => $core_aliquot_master_id));
								customInsertRecord($realiquoting_data);
							}
						}
					} else {
						recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "At least one core positions is not set or is wrong (>29). The core won't be created. Please check core positions in excel file.", "Block '".$tma_block_short_label."' positions : $storage_coord_x/$storage_coord_y. See $excel_data_references.");
					}
				} else {
					recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "The Block TMA has not been created. The core won't be created. Please check TMA block name in excel file (field 'TMA ID' +/- 'TMA number'.", "Block '".$tma_block_short_label."'. See $excel_data_references.");
				}
            } else {
                $fieldToCheck = array(
                    'NUMERO CORE',
                    'Tissue Source',
                    'Sample Patho ID',
                    'Control Code'
                );
                $coreInfoFound = array();
                foreach($fieldToCheck as $field) {
                    if(strlen($excel_line_data[$field])) {
                        $coreInfoFound[] = "$field = $excel_line_data[$field]";
                    }
                }
                if($coreInfoFound) {
            	   recordErrorAndMessage("TMA Blocks File ($excel_file_name :: $worksheet_name)", '@@WARNING@@', "Sample type value is empty. No core is supposed to be defined at this postion but one to many core fields contain(s) a value. Core won't be created. Please confirm.", "See values ".implode(', ', $coreInfoFound)." in $excel_data_references.");
                }
            }
		}
	}  //End new line
}
$last_queries_to_execute = array(
	"UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;",
	"UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';",
	"UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id=".$atim_controls['aliquot_controls']['tissue-core']['id']." AND barcode LIKE 'tmp_core_%';",
	"UPDATE storage_masters SET code=id WHERE  code LIKE 'tmp%';",
	"UPDATE versions SET permissions_regenerated = 0;"
);
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

function getDataToUpdate($atim_data, $excel_data) {
	$data_to_update = array();
	foreach($excel_data as $key => $value) {
		if(!array_key_exists($key, $atim_data)) die('ERR_8837282882:'.$key);
		if(strlen($value) && $value != $atim_data[$key]) $data_to_update[$key] = $value;
	}
	return $data_to_update;
}

function addCreatedDataToSummary($creation_type, $detail, $excel_data_references) {
	recordErrorAndMessage('Data Creation Summary', '@@MESSAGE@@', $creation_type, "$detail. See $excel_data_references.");
}

function addUpdatedDataToSummary($update_type, $updated_data, $excel_data_references) {
	if($updated_data) {
		$updates = array();
		foreach($updated_data as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Data Update Summary', '@@MESSAGE@@', $update_type, "Updated field(s) : ".implode(' + ', $updates).". See $excel_data_references.");
	}
}

function getStorageMasterId($excel_data_references, $short_label, $storage_type, $parent_storage_master_id = null) {
	global $atim_controls;
	global $atim_storage_key_storage_master_id;
	global $atim_storage_master_id_to_storage_data;
	global $created_storage_counter;
	
	if(!isset($atim_controls['storage_controls'][$storage_type])) die('ERR_storage_control_type#80064884 :: '.$storage_type);
	$storage_controls = $atim_controls['storage_controls'][$storage_type];
	
	if(empty($short_label)) {
		return null;
	} else {
		$storage_key = $storage_type.'-'.($parent_storage_master_id? $parent_storage_master_id : 'null').'-'.$short_label;
		if(isset($atim_storage_key_storage_master_id[$storage_key])) {
			return $atim_storage_key_storage_master_id[$storage_key];
		} else {
			$query = "SELECT id AS storage_master_id
				FROM storage_masters
				WHERE deleted <> 1
				AND storage_control_id = ".$storage_controls['id']."
				AND short_label = '$short_label' 
				AND (".($parent_storage_master_id? 'parent_id = '.$parent_storage_master_id : 'TRUE').");";
			$query_data = getSelectQueryResult($query);
			if($query_data) {
				if(sizeof($query_data) > 1) {
					recordErrorAndMessage('Storage', '@@ERROR@@', "More than one storage matches the excel storage based on short label and storage type - System will only use the first one. Please update data if required.", "See $storage_type short label '$short_label' [$excel_data_references].");
				}
				return $query_data[0]['storage_master_id'];				
			} else {
				//Get parent storage
				if($parent_storage_master_id && !isset($atim_storage_master_id_to_storage_data[$parent_storage_master_id])) {
					$query = "SELECT short_label, selection_label FROM storage_masters WHERE id = $parent_storage_master_id AND deleted <> 1";
					$query_data = getSelectQueryResult($query);
					if(!$query_data) die('ERR_storage_master_id#74784884');
					$atim_storage_master_id_to_storage_data[$parent_storage_master_id] = array(
						'short_label' => $query_data[0]['short_label'],
						'selection_label' => $query_data[0]['selection_label']);
				}
				$selection_label = ($parent_storage_master_id? $atim_storage_master_id_to_storage_data[$parent_storage_master_id]['selection_label'].'-' : '').$short_label;
				if(sizeof($short_label) > 50) recordErrorAndMessage('Storage', '@@WARNING@@', "Storage short label too long (>50) - Will generate many storage creation.", "See $storage_type short label '$short_label' [$excel_data_references].");
				if(sizeof($selection_label) > 110) recordErrorAndMessage('Storage', '@@WARNING@@', "Storage selection label too long (>50) - Will generate many storage creation.", "See $storage_type selection label '$selection_label' [$excel_data_references].");
				$created_storage_counter++;
				$storage_data = array(
					'storage_masters' => array(
						"code" => 'tmp'.$created_storage_counter,
						"short_label" => $short_label,
						"selection_label" => $selection_label,
						"storage_control_id" => $storage_controls['id'],
						"parent_id" => $parent_storage_master_id),
					$storage_controls['detail_tablename'] => array());
				$storage_master_id = customInsertRecord($storage_data);
				addCreatedDataToSummary('Storage', "New Storage $storage_type '$short_label'.", $short_label);
				$atim_storage_key_storage_master_id[$storage_key] = $storage_master_id;
				return $storage_master_id;
			}
		}
	}
}
	
?>
		