<?php

//First Line of any main.php file
require_once 'system.php';

$excel_file_name = 'BLOCK DLBCL NOV2017_nl_revised.xls';
$worksheet_name = 'MigratedData';

displayMigrationTitle('ATiM - LD LYMPHOMA - Blocks and slides migration', array($excel_file_name));

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}

$u_number_misc_identifier_control_id = $atim_controls['misc_identifier_controls']['hospital number']['id'];
if(!$u_number_misc_identifier_control_id) die('ERR#1');

recordErrorAndMessage('Migration Rules', '@@MESSAGE@@', "See below:", 'Data will be created if both ATiM# and Unit# match a participant in ATiM.');
recordErrorAndMessage('Migration Rules', '@@MESSAGE@@', "See below:", "One new collection will be created per excel row with a number of new paraffin blocks equals to the number of blocks defined into the row. System don't try to re-use a collection.");
recordErrorAndMessage('Migration Rules', '@@MESSAGE@@', "See below:", "One paraffin block then 1 slide and 3 tubes will be created per new collection.");
recordErrorAndMessage('Migration Rules', '@@MESSAGE@@', "See below:", "Created collection will be automatically linked to a participant consent if only one 'obtained' consent exists into ATiM else no consent will be linked to the collection.");
recordErrorAndMessage('Migration Rules', '@@MESSAGE@@', "See below:", "Created collection will be automatically linked to a participant biopsy if only one exists into ATiM based on both the date, the pathology number and the site else a new biopsy will be created then linked to the collection.");
recordErrorAndMessage('Migration Rules', '@@MESSAGE@@', "See below:", "No collection then block, slide and tube will be created if block patho number already exists into ATiM.");

$created_sample_counter = 0;
$created_aliquot_counter = 0;
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
	$excel_participant_identifier = $excel_line_data['ATiM #'];
	$excel_participant_unit_number = $excel_line_data['Unit #'];
	$msg = "See ATiM# [$excel_participant_identifier] and Unit#[$excel_participant_unit_number] line $line_number.";
    
	// ***********************************************************************
	// Check data errors
	// ***********************************************************************
	
	//Get participant
    $query = "SELECT Participant.id, MiscIdentifier.identifier_value
		FROM participants Participant
		LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = $u_number_misc_identifier_control_id
		WHERE Participant.deleted <> 1 AND Participant.participant_identifier = '$excel_participant_identifier';";
	$atim_patient_data = getSelectQueryResult($query);
	
	//Check Participant
	if(!$atim_patient_data) {
		//Error: Particiipant does not exist
		recordErrorAndMessage('Patient', '@@ERROR@@', "Participant does not exist into ATiM - No data created", $msg);	
	} else if(sizeof($atim_patient_data) != 1) {
		//Error: Too many particiipants match
		recordErrorAndMessage('Patient', '@@ERROR@@', "More than one ATiM participant match your data - No data created", $msg);	
	} else {
		$atim_participant_id = $atim_patient_data['0']['id'];
		$atim_unit_number = $atim_patient_data['0']['identifier_value'];
		
		//Check ATiM Unit#
		if($atim_unit_number != $excel_participant_unit_number) {
			//Error: Not the same Unit# (hospital number)
			recordErrorAndMessage('Patient', '@@ERROR@@', "ATiM and excel Unit# don't match - No data created", "[$excel_participant_unit_number](Excel) != [$atim_unit_number].(ATiM). $msg");
			continue;
		}
		
		//Check blocks don't exist in ATiM
		$blocks_to_migrate = array();
		for ($i = 1; $i <= 4; $i++) {
		    if(array_key_exists('Block#'.$i, $excel_line_data)) {
    			$barcode = trim($excel_line_data['Block#'.$i]);
    			if(strlen($barcode)) {
    				if(!getSelectQueryResult("SELECT id FROM aliquot_masters WHERE barcode = '$barcode' AND deleted <> 1")) {
    					$blocks_to_migrate[] = $barcode;
    				} else {
    					recordErrorAndMessage('Aliquot', '@@ERROR@@', "Tissue block barcode already exists into ATiM. No block and slide will be created. Please review ATiM data and validate migration.", "Barcode = [$barcode]. $msg");
    				}
    			}
		    }
		}
		if(empty($blocks_to_migrate)) {
			recordErrorAndMessage('Aliquot', '@@WARNING@@', "No tissue block to migrate for the participant. Please review ATiM data and validate migration.", "$msg");
			continue;
		}
		
		// ***********************************************************************
		// Data Migration
		// ***********************************************************************
		
		$excel_path_nbr = $excel_line_data['Path #'];
		list($excel_event_date, $excel_event_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['Date of Biopsy'], 'Collection', "Date of Biopsy (excel value)", $msg);
		$excel_site = strtolower($excel_line_data['Source']);
		if(preg_match('/^(.*)(\ {0,1}\(.+)$/', $excel_site, $matches)) $excel_site = $matches[1];
		$excel_site = trim($excel_site);
		$validated_excel_site = validateAndGetStructureDomainValue($excel_site, 'custom_biopsy_site_list', 'Collection', "The source of the biopsy (excel value) won't be used to either to compare excel data of a biopsy or to create a new one into ATiM. Please review and update data after migration.", 'Source', $msg);
		
		//Get consent
		$atim_consent_master_id = null;
		$query = "SELECT id, consent_signed_date FROM consent_masters ConsentMaster WHERE deleted <> 1 AND participant_id = $atim_participant_id AND consent_status = 'obtained'";
		$atim_consent_data = getSelectQueryResult($query);
		if(sizeof($atim_consent_data) == 1) {
			$atim_consent_master_id = $atim_consent_data['0']['id'];
			recordErrorAndMessage('Collection', '@@MESSAGE@@', "Linked collection to an existing consent.", "Consent on '".$atim_consent_data['0']['consent_signed_date']."' for the tissue collection on '$excel_event_date'. $msg");
		} else if(!$atim_consent_data) {
			recordErrorAndMessage('Collection', '@@WARNING@@', "No participant consent exists into ATiM. Created collection won't be linked to a consent into ATiM.", $msg);
		} else {
			recordErrorAndMessage('Collection', '@@ERROR@@', "More than one participant consents exists into ATiM. Created collection won't be linked to a consent into ATiM.", $msg);
		}
		
		//Get biopsy
		$atim_event_master_id = null;
		$query = "SELECT EventMaster.id, EventMaster.event_date, EventMaster.event_date_accuracy, EventDetail.path_nbr, EventDetail.site
			FROM event_masters EventMaster 
			INNER JOIN ".$atim_controls['event_controls']['biopsy']['detail_tablename']." EventDetail ON EventMaster.id = EventDetail.event_master_id
			WHERE EventMaster.deleted <> 1 
			AND EventMaster.participant_id = $atim_participant_id 
			AND EventMaster.event_control_id = ".$atim_controls['event_controls']['biopsy']['id']."
			AND EventMaster.event_date = '$excel_event_date' 
			AND EventDetail.path_nbr = '$excel_path_nbr' 
			AND EventDetail.site = '$excel_site'";
		$atim_event_data = getSelectQueryResult($query);
		$biopsy_msg = "Biopsy of '$excel_site' on '$excel_event_date'. $msg";
		$create_biopsy = false;
		if(sizeof($atim_event_data) == 1) {
			$atim_event_master_id = $atim_event_data[0]['id'];
			recordErrorAndMessage('Collection', '@@MESSAGE@@', "Linked collection to an existing biopsy.", $biopsy_msg);
		} else if(!$atim_event_data) {
		    $query = "SELECT EventMaster.id, EventMaster.event_date, EventMaster.event_date_accuracy, EventDetail.path_nbr, EventDetail.site
                FROM event_masters EventMaster
                INNER JOIN ".$atim_controls['event_controls']['biopsy']['detail_tablename']." EventDetail ON EventMaster.id = EventDetail.event_master_id
    			WHERE EventMaster.deleted <> 1
    			AND EventMaster.participant_id = $atim_participant_id
    			AND EventMaster.event_control_id = ".$atim_controls['event_controls']['biopsy']['id']."
    			AND EventMaster.event_date = '$excel_event_date'";
		    $atim_unmatching_event_data = getSelectQueryResult($query);
		    $other_sites_in_atim = array();
		    foreach($atim_unmatching_event_data as $new_unmatching_event_data) {
		        $other_sites_in_atim[$atim_event_data[0]['site']] = $atim_event_data[0]['site'];
		    }
		    $other_sites_in_atim = implode(' & ', $other_sites_in_atim);
		    if($other_sites_in_atim) {
    			recordErrorAndMessage('Collection', 
    			    '@@WARNING@@', 
    			    "No participant biopsy matches both the date, the 'Path #' and the site of the tissue collection but some biopsy on different site(s) exist into ATiM on this date. A new participant biopsy will be created then linked to the created collection into ATim. Please review ATiM data and validate migration.", 
    			    "Ohter biopsy : $other_sites_in_atim. $biopsy_msg");
		    } else {
    			recordErrorAndMessage('Collection', 
    			    '@@WARNING@@', 
    			    "No participant biopsy matches both the date, the 'Path #' and the site of the tissue collection. A new participant biopsy will be created then linked to the created collection into ATim. Please review ATiM data and validate migration.", 
    			    $biopsy_msg);
		    }
			$biopsy_data = array(
				'event_masters' => array(
					'participant_id' => $atim_participant_id,
					'event_control_id' => $atim_controls['event_controls']['biopsy']['id'],
					'event_date' => $excel_event_date,
					'event_date_accuracy' => $excel_event_date_accuracy),
				$atim_controls['event_controls']['biopsy']['detail_tablename'] => array(
					'path_nbr' => $excel_path_nbr,
					'site' => $excel_site));
			$atim_event_master_id = customInsertRecord($biopsy_data);
		} else {
			recordErrorAndMessage('Collection', '@@ERROR@@', "More than one ATiM participant biopsy matches both the date, the 'Path #' and the site. No new biopsy will be created and collection won't be linked to a biopsy. Please review ATiM data and validate migration.", $biopsy_msg);
		}
		
		//Create collection
		$collection_data = array(
			'collections' => array(
				'participant_id' => $atim_participant_id,
				'event_master_id' => $atim_event_master_id,
				'consent_master_id' => $atim_consent_master_id,
				'bank_id' => '1',
				'collection_site' => 'JGH',
				'collection_datetime' => $excel_event_date,
				'collection_datetime_accuracy' => 'h',
				'collection_property' => 'participant collection',
				'collection_notes' => "Created by blocks migration process on '$import_date'."
			)
		);
		$atim_collection_id = customInsertRecord($collection_data);
		
		//Create tissue
		// -- $default_number
		preg_match('/^([0-9]{4})-([0-9]{2})-([0-9]{2})/', $excel_event_date, $res);
		$tmp_year = (isset($res[1]) && !empty($res[1]))? substr($res[1], 2) : date('y', time());
		$max_ld_lymph_specimen_number = getSelectQueryResult("SELECT MAX(SampleMaster.ld_lymph_specimen_number) as max_ld_lymph_specimen_number FROM sample_masters SampleMaster WHERE SampleMaster.ld_lymph_specimen_number LIKE '$tmp_year%' AND SampleMaster.deleted <> 1");
		$default_number = $max_ld_lymph_specimen_number[0]['max_ld_lymph_specimen_number'];
		if(empty($default_number)) {
			$default_number = $tmp_year.(($tmp_year > 13)? '0':'')."001";
		} else if($default_number == '13999') {
			$default_number = '13A01';
		} else if(preg_match('/^(13([A-Z])([0-9]{2}))$/', $default_number, $matches)) {
			$character = $matches[2];
			$incremental_value = $matches[3];
			if($character.$incremental_value == 'Z99') die('ERR#1');
			$incremental_value++;
			if(strlen($incremental_value) == 1) $incremental_value = '0'.$incremental_value;
			if($incremental_value == '100') {
				$character = chr(ord($character)+1);
				$incremental_value = '01';
			}
			$default_number = '13'.$character.$incremental_value;
		} else {
			$default_number += 1;
		}
		if(strlen($default_number) < 5) {
		    $default_number = sprintf( "%05d", $default_number );
		}
		// -- $default_number
		$validated_excel_tissue_source = validateAndGetStructureDomainValue($excel_site, 'custom_tissue_source_list', 'Collection & Sample', "The source of the tissue (excel value) won't be used to create the tissue. Please review and update data after migration.", 'Source', $msg);
		// -- create tissue
		$created_sample_counter++;
		$sample_data = array(
			'sample_masters' => array(
				"sample_code" => 'tmp_tissue_'.$created_sample_counter,
				"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
				"initial_specimen_sample_type" => 'tissue',
				"collection_id" => $atim_collection_id,
				'ld_lymph_specimen_number' => $default_number,
				'notes' => "Created by blocks migration process on '$import_date'."),
			'specimen_details' => array(),
			$atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
				'tissue_source' => $validated_excel_tissue_source));
		$block_sample_master_id = customInsertRecord($sample_data);
		
		//Create aliquot
		$slide_id = 0;
		$tube_id = 0;
		foreach ($blocks_to_migrate as $new_block_barcode) {
			//Create block	
			$aliquot_data = array(
				'aliquot_masters' => array(
					"barcode" => $new_block_barcode,
					"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
					"collection_id" => $atim_collection_id,
					"sample_master_id" => $block_sample_master_id,
					'in_stock' => 'no',
					'in_stock_detail' => 'pathology department aliquot',
					'notes' => "Created by blocks migration process on '$import_date'."),
				$atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
					'block_type' => 'paraffin'));
			$block_aliquot_master_id = customInsertRecord($aliquot_data);			
			//Create slide
			for($id = 1; $id <= 20; $id++) {
				$slide_id++;
				$barcode = $default_number.'-SL'.sprintf("%02d", $slide_id);
				if(!getSelectQueryResult("SELECT id FROM aliquot_masters WHERE barcode LIKE '$barcode' AND deleted <> 1" )) {
					$aliquot_data = array(
						'aliquot_masters' => array(
							"barcode" => $barcode,
							"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-slide']['id'],
							"collection_id" => $atim_collection_id,
							"sample_master_id" => $block_sample_master_id,
							'in_stock' => 'yes - available',
							'notes' => "Created by blocks migration process on '$import_date'."),
						$atim_controls['aliquot_controls']['tissue-slide']['detail_tablename'] => array());
					$slide_aliquot_master_id = customInsertRecord($aliquot_data);
					
					$realiquoting_data = array('realiquotings' => array(
							'parent_aliquot_master_id' => $block_aliquot_master_id,
							'child_aliquot_master_id' => $slide_aliquot_master_id));
					customInsertRecord($realiquoting_data);				
				} else {
					recordErrorAndMessage('Aliquot', '@@ERROR@@', "Tissue block slide barcode already exists into ATiM. The slide won't be created. Please review ATiM data and validate migration.", "Barcode = [$barcode]. $msg");
				}
			}
				
			//Create tubes
			for($id = 1; $id <= 3; $id++) {
				$tube_id++;
				$barcode = $default_number.'-SC'.sprintf("%02d", $tube_id);
				if(!getSelectQueryResult("SELECT id FROM aliquot_masters WHERE barcode LIKE '$barcode' AND deleted <> 1" )) {
					$aliquot_data = array(
							'aliquot_masters' => array(
									"barcode" => $barcode,
									"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-tube']['id'],
									"collection_id" => $atim_collection_id,
									"sample_master_id" => $block_sample_master_id,
									'in_stock' => 'yes - available',
									'notes' => "Created by blocks migration process on '$import_date'."),
							$atim_controls['aliquot_controls']['tissue-tube']['detail_tablename'] => array());
					$tube_aliquot_master_id = customInsertRecord($aliquot_data);
				
					$realiquoting_data = array('realiquotings' => array(
							'parent_aliquot_master_id' => $block_aliquot_master_id,
							'child_aliquot_master_id' => $tube_aliquot_master_id));
					customInsertRecord($realiquoting_data);
				} else {
					recordErrorAndMessage('Aliquot', '@@ERROR@@', "Tissue block scroll barcode already exists into ATiM. The scroll won't be created. Please review ATiM data and validate migration.", "Barcode = [$barcode]. $msg");
				}
			}
		}
	}
}

$last_queries_to_execute = array(
	"UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

dislayErrorAndMessage(true);

?>
		