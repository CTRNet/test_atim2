<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Custom Require Section
//==============================================================================================

//require_once 'CustomFiles/cutsom_file.php';

//==============================================================================================
// Custom Variables
//==============================================================================================

//==============================================================================================
// Main Code
//==============================================================================================

displayMigrationTitle('CPCBN Tissue Blocks Creation');

$tmp = array();
foreach($excel_files_names as $excel_file_properties) {
	list($excel_file_name, $bank_name, $excel_xls_offset, $worksheet_name) = $excel_file_properties;
	$tmp[] = $excel_file_name;
}
 if(!testExcelFile($tmp)) {
	dislayErrorAndMessage();
	exit;
}


// Remove preivous record

if(true) {
	$import_date_like = '2016-05-30';
	$queries = array();
	$queries[] = "DELETE FROM ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." WHERE aliquot_master_id IN (
		SELECT id FROM aliquot_masters WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']." AND created LIKE '$import_date_like%' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM aliquot_masters WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']." AND created LIKE '$import_date_like%' AND created_by = $imported_by";
	$queries[] = "DELETE FROM ".$atim_controls['sample_controls']['tissue']['detail_tablename']." WHERE sample_master_id IN (
		SELECT id FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']." AND created LIKE '$import_date_like%' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM specimen_details WHERE sample_master_id IN (
		SELECT id FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']." AND created LIKE '$import_date_like%' AND created_by = $imported_by)";
	$queries[] = "UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']." AND created LIKE '$import_date_like%' AND created_by = $imported_by";
	$queries[] = "DELETE FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']." AND created LIKE '$import_date_like%' AND created_by = $imported_by";
	foreach($queries as $new_query) customQuery($new_query.';');
}

// *** Get storage data ***

$storages = getSelectQueryResult("SELECT id, flag_active, storage_type from storage_controls WHERE storage_type IN ('drawer', 'cabinet') AND flag_active = 1");
if(sizeof($storages) != 2) die("ERR_8848488 : Missing storage type 'drawer' & 'cabinet'");

$drawer_61_storage_master_id = getSelectQueryResult("SELECT SM.id
	FROM storage_masters SM INNER JOIN storage_controls SC ON SC.id = SM.storage_control_id 
	WHERE SM.deleted <> 1 AND SC.storage_type = 'drawer' AND SM.short_label = '61'");
if(sizeof($drawer_61_storage_master_id) != 1) die("ERR_8848489 : Missing 'drawer' '61'");
$drawer_61_storage_master_id = $drawer_61_storage_master_id[0]['id'];

// *** PARSE EXCEL FILES ***

$sample_counter=0;
$aliquot_counter=0;
foreach($excel_files_names as $excel_file_properties) {
	list($excel_file_name, $bank_name, $excel_xls_offset, $worksheet_name) = $excel_file_properties;
	recordErrorAndMessage('Parsed Files', '@@MESSAGE@@', "Files Names", $excel_file_name);
	$summary_section_title = "$excel_file_name :: '$worksheet_name'";
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Bank Patient'])) {
			$qc_tf_bank_participant_identifier = $excel_line_data['Bank Patient'];
			$qc_tf_collection_type = $excel_line_data['Collected Specimen Type'];
			$collection_site = strtolower($excel_line_data['Site of collection']);
			$excel_collection_date = array();
			$excel_field = 'Date of Specimen Collection Date of collection';
			list($excel_collection_date, $excel_collection_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", '');
			if($excel_line_data['Date of Specimen Collection Accuracy'] != 'c') die('ERR 383828823');
			$excel_collection_date_accuracy = 'h';
			//Get Collection id
			$query = "SELECT Collection.id
				FROM banks Bank
				INNER JOIN participants Participant ON Participant.qc_tf_bank_id = Bank.id 
				INNER JOIN collections Collection ON Participant.id = Collection.participant_id
				WHERE Bank.name = '$bank_name'
				AND Collection.deleted <> 1
				AND Collection.qc_tf_collection_type LIKE '$qc_tf_collection_type'
				AND ".($collection_site? "Collection.collection_site LIKE '$collection_site'" : 'TRUE')."
				AND Collection.collection_datetime LIKE '$excel_collection_date%'
				AND Participant.qc_tf_bank_participant_identifier = '$qc_tf_bank_participant_identifier';";
			$collection_found = getSelectQueryResult($query);
			$collection_id = null;
			if(!$collection_found) {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "No collection", "No collection matches following criteria (Bank '$bank_name' & participant '$qc_tf_bank_participant_identifier' & collection type '$qc_tf_collection_type' & collection site '$collection_site' & date '$excel_collection_date'). Create Block manually.");
			} else if(sizeof($collection_found) > 1) {
				$msg = "More than one collection matches following criteria (Bank '$bank_name' & participant '$qc_tf_bank_participant_identifier' & collection type '$qc_tf_collection_type' & collection site '$collection_site' & date '$excel_collection_date'). Added block to the first one. Check second collection should be deleted.";
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Duplicated collection", $msg, $msg);
				$collection_id = $collection_found[0]['id'];
			} else {
				$collection_id = $collection_found[0]['id'];
			}
			
			$storage_master_id = null;
			$in_stock_detail = '';
			$in_stock = 'yes - available';
			switch($excel_line_data['Localisation']) {
				case 'R12.118-Armoire A2-Étage 2-Tiroir 61':
					$storage_master_id = $drawer_61_storage_master_id;
					break;
				case 'Returned to site':
					$in_stock = 'no';
					$in_stock_detail = 'returned to site';
					break;
				case '':
					$in_stock = 'no';
					$in_stock_detail = 'pending';
					break;
				default:
					recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Unsupported Localisation Value", "Value '".$excel_line_data['Localisation']."' is not supported. Value won't be considered.");
			}
			
			if($collection_id) {
				//Create Prostate Tissue
				$sample_counter++;
				$sample_data = array(
					'sample_masters' => array(
						"sample_code" => 'tmp_tissue_'.$sample_counter,
						"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
						"initial_specimen_sample_type" => 'tissue',
						"collection_id" => $collection_id),
					'specimen_details' => array(),
					$atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
						'tissue_source' => 'prostate'));
				$sample_master_id = customInsertRecord($sample_data);
				//Create block
				$aliquot_counter++;
				$patho_dpt_block_code = trim($excel_line_data['Sample ID number']);
				if(!strlen($patho_dpt_block_code)) $patho_dpt_block_code = 'N.D.';
				$aliquot_data = array(
					'aliquot_masters' => array(
						"barcode" => 'tmp_core_'.$aliquot_counter,
						"aliquot_label" => $patho_dpt_block_code,
						"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
						"collection_id" => $collection_id,
						"sample_master_id" => $sample_master_id,
						'in_stock' => $in_stock,
						'in_stock_detail' => $in_stock_detail),
					$atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array());
				if($storage_master_id) $aliquot_data['aliquot_masters']['storage_master_id'] = $storage_master_id;
				$aliquot_master_id = customInsertRecord($aliquot_data);
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "'Bank Patient' column missing", "'Bank Patient' column is missing into worksheet '$worksheet_name'. No data will be parsed.");
		}
	}
}

$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';";
customQuery($query);
$query = "UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id=". $atim_controls['aliquot_controls']['tissue-block']['id']." AND barcode LIKE 'tmp_core_%';";
customQuery($query);
customQuery("UPDATE versions SET permissions_regenerated = 0;");
insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(true, 'Block Creation - Summary');
	
?>
		