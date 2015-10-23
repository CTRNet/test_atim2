<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Main Code
//==============================================================================================

$excel_file_name = 'Extractions ARN.xls';

displayMigrationTitle('PROCURE CHUM RNA Migration', array($excel_file_name));

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}

$blood_types = getSelectQueryResult("SELECT DISTINCT blood_type
	FROM aliquot_masters am
	INNER JOIN sample_masters sm ON am.sample_master_id = sm.id
	INNER JOIN sd_spe_bloods sd ON sd.sample_master_id = sm.id
	WHERE am.deleted <> 1 AND am.barcode like '% -RNB%'");
if(sizeof($blood_types) != 1 || $blood_types[0]['blood_type'] != 'paxgene') die('ERR_1');

$sample_controls = $atim_controls['sample_controls'];
$aliquot_controls = $atim_controls['aliquot_controls'];

//==============================================================================================
$previous_modified = '2015-10-23 10:00:00';
if($previous_modified) {
	$queries = array(
			"UPDATE aliquot_masters SET in_stock = 'yes - available' WHERE modified_by = '$imported_by' AND modified >= '$previous_modified' AND aliquot_control_id = ".$aliquot_controls['blood-tube']['id'],

			"DELETE FROM quality_ctrls WHERE created_by = '$imported_by' AND created >= '$previous_modified'",
			"DELETE FROM quality_ctrls_revs WHERE modified_by = '$imported_by' AND version_created >= '$previous_modified'",

			"DELETE FROM source_aliquots WHERE created_by = '$imported_by' AND created >= '$previous_modified'",
			"DELETE FROM source_aliquots_revs WHERE modified_by = '$imported_by' AND version_created >= '$previous_modified'",
				
			"DELETE FROM ".$aliquot_controls['rna-tube']['detail_tablename']." WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND aliquot_control_id = ".$aliquot_controls['rna-tube']['id'].")",
			"DELETE FROM ".$aliquot_controls['rna-tube']['detail_tablename']."_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND aliquot_control_id = ".$aliquot_controls['rna-tube']['id'].")",
			"DELETE FROM aliquot_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND aliquot_control_id = ".$aliquot_controls['rna-tube']['id'],
			"DELETE FROM aliquot_masters_revs WHERE modified_by = '$imported_by' AND version_created >= '$previous_modified' AND aliquot_control_id = ".$aliquot_controls['rna-tube']['id'],
					
			"DELETE FROM derivative_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND sample_control_id = ".$sample_controls['rna']['id'].")",
			"DELETE FROM derivative_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND sample_control_id = ".$sample_controls['rna']['id'].")",
			"DELETE FROM ".$sample_controls['rna']['detail_tablename']." WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND sample_control_id = ".$sample_controls['rna']['id'].")",
			"DELETE FROM ".$sample_controls['rna']['detail_tablename']."_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND sample_control_id = ".$sample_controls['rna']['id'].")",
			"DELETE FROM sample_masters WHERE created_by = '$imported_by' AND created >= '$previous_modified' AND sample_control_id = ".$sample_controls['rna']['id'],
			"DELETE FROM sample_masters_revs WHERE modified_by = '$imported_by' AND version_created >= '$previous_modified' AND sample_control_id = ".$sample_controls['rna']['id']);
	foreach($queries as $query) customQuery("$query;");
	view_updates();
}

//==============================================================================================

$paxgene_aliquot_master_ids_to_remove = array();

global $storage_master_ids;
$storage_master_ids = array();
$rna_boxes = getSelectQueryResult("SELECT id, selection_label from storage_masters WHERE selection_label LIKE 'RNA.%' AND storage_control_id = (SELECT id FROM storage_controls WHERE storage_type = 'box100')");
foreach($rna_boxes as $new_box) $storage_master_ids[$new_box['selection_label']] = $new_box['id'];

$worksheet_name = 'Feuil1';
$creation_summaries = array('RNAs' => 0, 'RNA tubes' => 0, 'aliquot source' => 0, 'quality ctrls' => 0);
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
	$no_labo = $excel_line_data['No Labo'];
	$participant_identifier = 'PS1P'.sprintf("%04s",$excel_line_data['S1P']);
	$visit = 'V'.sprintf("%02s",$excel_line_data['Visite']);
	
	$paxgene_tube_data = getSelectQueryResult("SELECT * FROM view_aliquots 
		WHERE qc_nd_no_labo = '$no_labo' 
		AND procure_visit = '$visit'
		AND participant_identifier = '$participant_identifier'
		AND sample_type = 'blood'
		AND barcode LIKE '$participant_identifier $visit -RNB%'
		AND in_stock LIKE 'yes%';");
	if(!$paxgene_tube_data) {
		recordErrorAndMessage('Paxgene tube detection', '@@ERROR@@', "No paxgene tube exists for...", "Patient $participant_identifier // $no_labo and visit $visit. No RNA will be created. See line $line_number.");
	} else if(sizeof($paxgene_tube_data) > 1) {
		$collection_ids = array();
		$sample_master_ids = array();
		foreach($paxgene_tube_data as $tmp_tube) {
			$collection_ids[$tmp_tube['collection_id']] = $tmp_tube['collection_id'];
			$sample_master_ids[$tmp_tube['sample_master_id']] = $tmp_tube['sample_master_id'];
		}
		if(sizeof($sample_master_ids) == 1) {
			recordErrorAndMessage('Paxgene tube detection', '@@WARNING@@', "More than one paxgene tube exists for the same sample - No extraction tube will be created - To do manually", sizeof($paxgene_tube_data)." tubes. Patient $participant_identifier // $no_labo and visit $visit. See line $line_number.");
		} else {
			$error_detected = true;
			if(sizeof($collection_ids) == 1) {
				recordErrorAndMessage('Paxgene tube detection', '@@ERROR@@', "More than one paxgene blood sample exists - No extraction tube will be created", sizeof($paxgene_tube_data)." tubes. Patient $participant_identifier // $no_labo and visit $visit. See line $line_number.");
			} else {
				recordErrorAndMessage('Paxgene tube detection', '@@ERROR@@', "More than one collection with paxgene blood sample exists - No extraction tube will be created", sizeof($paxgene_tube_data)." tubes. Patient $participant_identifier // $no_labo and visit $visit. See line $line_number.");
			}
		}
	} else {
		$paxgene_collection_id = $paxgene_tube_data[0]['collection_id'];
		$paxgene_sample_master_id = $paxgene_tube_data[0]['sample_master_id'];
		$paxgene_aliquot_master_id = $paxgene_tube_data[0]['aliquot_master_id'];
		
		list($date_of_extraction, $date_of_extraction_accuracy) = validateAndGetDateAndAccuracy($excel_line_data["Date d'extraction"], 'RNA Creation', "Field 'Date d'extraction'", "See Patient $participant_identifier // $no_labo and visit $visit (line $line_number).");
		if(!$date_of_extraction) {
			recordErrorAndMessage('RNA Creation', '@@ERROR@@', "No date of extraction", "No RNA will be created. Patient $participant_identifier // $no_labo and visit $visit. See line $line_number.");
		} else {
			
			// * 1 * create RNA
		
			$sample_data = array(
				'sample_masters' => array(
					'collection_id' => $paxgene_collection_id,
					'sample_control_id' => $sample_controls['rna']['id'],
					'initial_specimen_sample_type' => 'blood',
					'initial_specimen_sample_id' => $paxgene_sample_master_id,
					'parent_sample_type' => 'blood',
					'parent_id' =>$paxgene_sample_master_id,
					'notes' => ''),
				'derivative_details' => array(
					'creation_datetime' =>$date_of_extraction,
					'creation_datetime_accuracy' => $date_of_extraction_accuracy,
					'creation_by' => (preg_match('/^2015/', $date_of_extraction)? "genevieve cormier" : "claudia syed")),
				$sample_controls['rna']['detail_tablename'] => array(
					'qc_nd_extraction_method' => "Qiacube Paxgene kit"));
			$derivative_sample_master_id = customInsertRecord($sample_data);
			$creation_summaries['RNAs']++;
			//Create aliquot to sample link
			$source_aliquot_data = array('source_aliquots' => array('sample_master_id' => $derivative_sample_master_id, 'aliquot_master_id' => $paxgene_aliquot_master_id));			
			customInsertRecord($source_aliquot_data);
			$creation_summaries['aliquot source']++;
			$paxgene_aliquot_master_ids_to_remove[] = $paxgene_aliquot_master_id;
			//Aliquot
			$initial_volume = validateAndGetDecimal($excel_line_data["Volume (ul)"], 'RNA Creation', "Field 'Volume (ul)'", "See Patient $participant_identifier // $no_labo and visit $visit (line $line_number).");
			$concentration_bioanalyzer = validateAndGetDecimal($excel_line_data["Conc Bioanalyzer (ng/ul)"], 'RNA Creation', "Field 'Conc Bioanalyzer (ng/ul)'", "See Patient $participant_identifier // $no_labo and visit $visit (line $line_number).");
			$concentration_unit_bioanalyzer = strlen($concentration_bioanalyzer)? 'ng/ul' : '';
			//current volume = initial volume: so current quantity on initial volume
			$procure_total_quantity_ug = (strlen($initial_volume) && strlen($concentration_bioanalyzer))? ($initial_volume*$concentration_bioanalyzer/1000): '';
			$concentration_nanodrop = validateAndGetDecimal($excel_line_data["Conc Nanodrop (ng/ul)"], 'RNA Creation', "Field 'Conc Nanodrop (ng/ul)'", "See Patient $participant_identifier // $no_labo and visit $visit (line $line_number).");
			$concentration_unit_nanodrop = strlen($concentration_nanodrop)? 'ng/ul' : '';
			//current volume = initial volume: so current quantity on initial volume
			$procure_total_quantity_ug_nanodrop = (strlen($initial_volume) && strlen($concentration_nanodrop))? ($initial_volume*$concentration_nanodrop/1000): '';
			$storage_master_id = getStorageMasterId($excel_line_data["Boîte"]);
			$storage_coordinate_x = null;
			if(strlen($excel_line_data["Position"])) {
				if(!preg_match('/^(([1-9])|([1-9][0-9]))$/', $excel_line_data["Position"])) {
					recordErrorAndMessage('RNA Creation', '@@ERROR@@', "Wrong rna tube postion", "Position [".$excel_line_data["Position"]."] won't be set. Patient $participant_identifier // $no_labo and visit $visit. See line $line_number.");
				} else {
					if(!$storage_master_id) {
						recordErrorAndMessage('RNA Creation', '@@ERROR@@', "RNA tube postion with no storage", "Position [".$excel_line_data["Position"]."] won't be set. Patient $participant_identifier // $no_labo and visit $visit. See line $line_number.");
					} else {
						$storage_coordinate_x = $excel_line_data["Position"];
					}
				}
			}
			$aliquot_data = array(
				'aliquot_masters' => array(
					'collection_id' => $paxgene_collection_id,
					'sample_master_id' => $derivative_sample_master_id,
					'aliquot_control_id' => $aliquot_controls['rna-tube']['id'],
					'barcode' => "$participant_identifier $visit -RNA1",
					'in_stock' => 'yes - available',
					'initial_volume' => $initial_volume,
					'current_volume' => $initial_volume,
					'use_counter' => '0',
					'storage_datetime' => $date_of_extraction,
					'storage_datetime_accuracy' => $date_of_extraction_accuracy,
					'storage_master_id' => $storage_master_id,
					'storage_coord_x' => $storage_coordinate_x,
					'storage_coord_y' => null),
				$aliquot_controls['rna-tube']['detail_tablename'] => array(
					'concentration' => $concentration_bioanalyzer,
					'concentration_unit' => $concentration_unit_bioanalyzer,
					'procure_total_quantity_ug' => $procure_total_quantity_ug,
					'procure_concentration_nanodrop' => $concentration_nanodrop,
					'procure_concentration_unit_nanodrop' => $concentration_unit_nanodrop,
					'procure_total_quantity_ug_nanodrop' => $procure_total_quantity_ug_nanodrop));
			$rna1_tube_master_id = customInsertRecord($aliquot_data);
			$creation_summaries['RNA tubes']++;
			
			// * 2 * create QC
			
			$qc_test = array();
			$rin = validateAndGetDecimal($excel_line_data["RIN"], 'QC Creation', "Field 'RIN'", "See Patient $participant_identifier // $no_labo and visit $visit (line $line_number).");
			if(strlen($rin)) $qc_test[] = array('type' => 'bioanalyzer', 'score' => $rin, 'unit' => 'RIN', 'procure_concentration' => '', 'procure_concentration_unit' => '');
			$test_28s_18s = validateAndGetDecimal($excel_line_data["28s/18s"], 'QC Creation', "Field '28s/18s'", "See Patient $participant_identifier // $no_labo and visit $visit (line $line_number).");
			if(strlen($test_28s_18s)) $qc_test[] = array('type' => 'bioanalyzer', 'score' => $test_28s_18s, 'unit' => '28/18', 'procure_concentration' => '', 'procure_concentration_unit' => '');
			if(strlen($concentration_bioanalyzer)) $qc_test[] = array('type' => 'bioanalyzer', 'score' => '', 'unit' => '', 'procure_concentration' => $concentration_bioanalyzer, 'procure_concentration_unit' => $concentration_unit_bioanalyzer);
			if(strlen($concentration_nanodrop)) $qc_test[] = array('type' => 'nanodrop', 'score' => '', 'unit' => '', 'procure_concentration' => $concentration_nanodrop, 'procure_concentration_unit' => $concentration_unit_nanodrop);
			if($qc_test) {
				$aliquot_data = array(
					'aliquot_masters' => array(
						'collection_id' => $paxgene_collection_id,
						'sample_master_id' => $derivative_sample_master_id,
						'aliquot_control_id' => $aliquot_controls['rna-tube']['id'],
						'barcode' => "$participant_identifier $visit -RNA2",
						'in_stock' => 'no',
						'use_counter' => sizeof($qc_test)),
					$aliquot_controls['rna-tube']['detail_tablename'] => array(
						'concentration' => $concentration_bioanalyzer,
						'concentration_unit' => $concentration_unit_bioanalyzer,
						'procure_concentration_nanodrop' => $concentration_nanodrop,
						'procure_concentration_unit_nanodrop' => $concentration_unit_nanodrop));
				$rna2_tube_master_id = customInsertRecord($aliquot_data);
				$creation_summaries['RNA tubes']++;
				$qc_code_counter = 0;
				foreach($qc_test as $test) {
					$qc_code_counter++;
					$test = array('quality_ctrls' => array_merge($test, array('qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter, 'sample_master_id' => $derivative_sample_master_id, 'aliquot_master_id' => $rna2_tube_master_id)));
					customInsertRecord($test);	
					$creation_summaries['quality ctrls']++;
				}
			}		
		}
	}
}

foreach($creation_summaries as $element => $count) recordErrorAndMessage('Creation summaries', '@@MESSAGE@@', "...", "Created $count $element.");
	
if($paxgene_aliquot_master_ids_to_remove) {
	$query = "UPDATE aliquot_masters 
		SET modified = '$import_date', modified_by = '$imported_by', in_stock = 'no', storage_master_id = null, storage_coord_x = null, storage_coord_y = null, use_counter = (use_counter + 1)  
		WHERE id IN (".implode(',',$paxgene_aliquot_master_ids_to_remove).") AND aliquot_control_id = ". $aliquot_controls['blood-tube']['id'].";";
	customQuery($query);
	$updated_element = getSelectQueryResult("SELECT id as nbr FROM aliquot_masters WHERE modified = '$import_date' AND  modified_by = '$imported_by' AND aliquot_control_id = ". $aliquot_controls['blood-tube']['id'].";");
	recordErrorAndMessage('Creation summaries', '@@MESSAGE@@', "...", "Updated ".sizeof($updated_element)." paxgene tube (?= ".sizeof($paxgene_aliquot_master_ids_to_remove).".");
	addToModifiedDatabaseTablesList('aliquot_masters', $aliquot_controls['blood-tube']['detail_tablename']);
}

insertIntoRevsBasedOnModifiedValues();
customQuery("UPDATE versions SET permissions_regenerated = 0;");

dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function getStorageMasterId($excel_storage_label) {
	global $storage_master_ids;
	
	$excel_storage_label = "RNA.$excel_storage_label";
	if(empty($excel_storage_label)) {
		return null;
	} else {
		if(array_key_exists($excel_storage_label, $storage_master_ids)) {
			return $storage_master_ids[$excel_storage_label];
		} else {
			die('ERR_89900: '.$excel_storage_label);
		}
	}
}

function view_updates() {
	
	$table_query = array();
	
	$table_query['view_aliquots'] =
	'SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
			Collection.bank_id,
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id,
		
			Participant.participant_identifier,
Participant.procure_proc_site_participant_identifier,
		
			Collection.acquisition_label,
Collection.procure_visit AS procure_visit,
		
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
AliquotMaster.procure_created_by_bank,
		
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
MiscIdentifier.identifier_value AS qc_nd_no_labo
		
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
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = 5 AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
			WHERE AliquotMaster.deleted != 1';
/*	
	$table_query['view_collections'] = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
Collection.procure_patient_identity_verified AS procure_patient_identity_verified,
Collection.procure_visit AS procure_visit,
Collection.procure_collected_by_bank AS procure_collected_by_bank,
		Participant.participant_identifier AS participant_identifier,
Participant.procure_proc_site_participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
MiscIdentifier.identifier_value AS qc_nd_no_labo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = 5 AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
		WHERE Collection.deleted <> 1';
	
	$table_query['view_samples'] = '
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
	
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
	
		Participant.participant_identifier,
Participant.procure_proc_site_participant_identifier,
	
		Collection.acquisition_label,
Collection.procure_visit AS procure_visit,
	
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
SampleMaster.procure_created_by_bank,
	
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
MiscIdentifier.identifier_value AS qc_nd_no_labo
	
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
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = 5 AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
		WHERE SampleMaster.deleted != 1 ';
	
*/
	
	foreach($table_query as $table_name => $table_query){
		customQuery("DELETE FROM $table_name");
		customQuery("INSERT INTO $table_name ($table_query)");
	
	}
}










	
?>
		