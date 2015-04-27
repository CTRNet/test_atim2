<?php

set_time_limit('3600');

//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

//TODO $file_name_blood = "JGH Blood Bank Boxes_20150427.xls";
$file_name_tissue = "JGH and CHUM Tumor and biopsies Bank boxes_20150427.xls";
$file_path = "C:/_Perso/Server/jgh_breast/data/";
require_once 'Excel/reader.php';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "jghbreast";
$db_charset		= "utf8";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

$db_connection = @mysqli_connect(
		$db_ip.(empty($db_port)? '' : ":").$db_port,
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
mysqli_autocommit($db_connection, false);

//-- GLOBAL VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------

$modified_by = '1';

$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

//===========================================================================================================================================================
//===========================================================================================================================================================

echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
Aliquots Positions<br>".
//TODO source_file = $file_name_blood<br>
"source_file = $file_name_tissue<br>
<br>=====================================================================</FONT><br><br>";

$query = "select id, detail_tablename from storage_controls where flag_active = 1 AND storage_type = 'box100 1-100';";
$results = mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
if($results->num_rows != 1) die('ERR 2387 62387 632');
$row = $results->fetch_assoc();
$storage_controls = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);

// $query = "select max(rght) as last_left_rght from storage_masters;";
// $results = mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
// if($results->num_rows != 1) die('ERR 2387 62387 632');
// $row = $results->fetch_assoc();
// $last_storage_left_rght = $row['last_left_rght'];

$query = "SELECT sc.sample_type, ac.aliquot_type, ac.id, ac.detail_tablename
	FROM sample_controls sc
	INNER JOIN aliquot_controls ac ON ac.sample_control_id = sc.id
	WHERE sc.sample_type IN ('plasma','serum','pbmc','tissue') AND ac.aliquot_type = 'tube';";
$results = mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
$aliquot_control_ids = array();
while($row = $results->fetch_assoc()) {
	if($row['detail_tablename'] != 'ad_tubes') die('ERR23 76287632 7826 ');
	switch($row['sample_type']) {
		case 'plasma':
			$aliquot_control_ids['plasma'] = $row['id'];
			$aliquot_control_ids['ctad'] = $row['id'];
			$aliquot_control_ids['plasma edta'] = $row['id'];
			$aliquot_control_ids['ctad plasma'] = $row['id'];
			$aliquot_control_ids['edta plasma'] = $row['id'];
			$aliquot_control_ids['plasma ctad'] = $row['id'];
			break;
		case 'serum':
			$aliquot_control_ids['serum'] = $row['id'];
			break;
		case 'pbmc':
			$aliquot_control_ids['buffy coat'] = $row['id'];
			break;
		case 'tissue':
			$aliquot_control_ids['tissue'] = $row['id'];
			break;
	}
}
if(sizeof($aliquot_control_ids) != 9) die('ERR 23 7628 29292929292');

$query = "SELECT id, selection_label FROM storage_masters WHERE selection_label IN ('#6', '#85', 'LN');";
$results = mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
$freezers_ids = array();
while($row = $results->fetch_assoc()) $freezers_ids[$row['selection_label']] = $row['id'];
if(sizeof($freezers_ids) != 3) die('ERR 2387 287 8327');

$storage_code_counter = 1;
$total_aliquots_listed = 0;
$total_aliquots_updated = 0;
//TODO foreach(array($file_name_blood => 'blood', $file_name_tissue => 'tissue') as $file_name => $file_sample_type) {
foreach(array($file_name_tissue => 'tissue') as $file_name => $file_sample_type) {
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read($file_path.$file_name);
	$sheets_keys = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;
	foreach($sheets_keys as $box_short_label => $worksheet) {
		if(preg_match('/^Feuil/', $box_short_label)) continue;
		//New box
		echo "<br><FONT COLOR=\"green\" >***** File $file_name :: Box $box_short_label *****</FONT><br><br>";
		$aliquots_listed = 0;
		$aliquots_updated = 0;
		$aliquot_data_to_update_per_type = array();
		if(isset($tmp_xls_reader->sheets[$worksheet]['cells'])) {
			$headers = array();
			foreach($tmp_xls_reader->sheets[$worksheet]['cells'] as $excel_line_counter => $new_line) {
				if($excel_line_counter == 1) {
					$headers = $new_line;
				} else {
					$new_line = formatNewLineData($headers, $new_line);
					$barcode = isset($new_line['Scan barcode'])? trim($new_line['Scan barcode']) : '';
					$position = isset($new_line['Slot'])? trim($new_line['Slot']) : '';
					if(strlen($barcode)) {
						if(!strlen($position)) die('ERR 237 6287 6322 '. $box_short_label . ' ' . $excel_line_counter);
						if(!preg_match('/^([1-9])|([1-9][0-9])|(100)$/', $position)) die('ERR 237 6287 63332 '. $box_short_label . ' ' . $excel_line_counter.' '.$position);
						$aliquot_control_id = null;
						$sample_type = '';
						if($file_sample_type == 'tissue') {
							$aliquot_control_id = $aliquot_control_ids['tissue'];
							$sample_type = 'tissue';
						} else {
							$sample_type = empty($new_line['Type'])? '' : trim(strtolower($new_line['Type']));
							if(empty($sample_type)) {
								echo "<FONT COLOR=\"#A44057\" >Error#1</FONT> : <FONT COLOR=\"red\" >The sample type for the aliquot $barcode is not specified. Aliquot position won't be updated.</FONT><br>";
							} else if(!isset($aliquot_control_ids[$sample_type])) {
								echo "<FONT COLOR=\"#4097A4\" >Error#2</FONT> : <FONT COLOR=\"red\" >The sample type [$sample_type] is not supported. See aliquot $barcode. Aliquot position won't be updated.</FONT><br>";
							} else {
								$aliquot_control_id = $aliquot_control_ids[$sample_type];
							}
						}
						if($aliquot_control_id) {
							$aliquot_data_to_update_per_type[$aliquot_control_id]['sample_types'][$sample_type] = $sample_type;
							$aliquot_data_to_update_per_type[$aliquot_control_id]['barcodes_and_positions'][$barcode] = $position;
						}
						$aliquots_listed++;
					} else {
						//if(strlen($position)) die('ERR 237 628eeee2 '. $box_short_label . ' ' . $excel_line_counter);
					}
				}
			}
		}
		//Create storage
		$storage_code_counter++;
		$parent_storage_master_short_label = '';
		$parent_storage_master_id = '';
		if($file_sample_type == 'tissue') {
			$parent_storage_master_short_label = 'LN';
			$parent_storage_master_id = $freezers_ids['LN'];
			if(!preg_match('/^JGHBox\ [3-7]\ Breast\ Biopsies$/', $box_short_label) && !preg_match('/^JGHBox#[0-9]+\ Breast\ Tumors$/', $box_short_label)) die('ERR 3939939393ee ['.$box_short_label.']');
		} else {
			if(!preg_match('/^Bo[xX][\ ]{0,1}[#]{0,1}([0-9]+)$/', $box_short_label, $matches)) die('ERR 38388383 4884');
			$box_short_label = "JGH Blood Bank Box ".$matches[1]; 
			$parent_storage_master_short_label = '#85';
			$parent_storage_master_id = $freezers_ids['#85'];
			if($matches[1] > 64) {
				$parent_storage_master_short_label = '#6';
				$parent_storage_master_id = $freezers_ids['#6'];
			}			
		}
		$box_seletion_label = $parent_storage_master_short_label.'-'.$box_short_label;
		$storage_master_id = customInsertRecord(array('code' => 'tmp_xxxx_'.$storage_code_counter, 'storage_control_id' => $storage_controls['id'], 'short_label' => $box_short_label, 'selection_label' => $box_seletion_label, 'parent_id' => $parent_storage_master_id), 'storage_masters', false);
		customInsertRecord(array('storage_master_id' => $storage_master_id), $storage_controls['detail_tablename'], true);
		echo "Created Box '$box_seletion_label'<br><br>";
		//Update aliquots	
		foreach($aliquot_data_to_update_per_type as $aliquot_control_id => $aliquots_data){		
			$sample_types = '<b>'.str_replace(
				array('ctad','plasma','edta','ctad','serum','buffy coat','tissue'), 
				array('CTAD','Plasma','EDTA','CTAD','Serum','Buffy Coat','Tissue'),
				implode(' or ', $aliquots_data['sample_types'])).'</b>';
			$barcodes_and_positions = $aliquots_data['barcodes_and_positions'];
			// ****** TEST 1 ******
			//Get duplicated barcodes
			$query = "SELECT barcode FROM (SELECT barcode, count(*) as nbr FROM aliquot_masters WHERE aliquot_control_id = $aliquot_control_id AND barcode IN ('".implode("','",array_keys($barcodes_and_positions))."') AND deleted <> 1 GROUP BY barcode) AS res WHERE res.nbr > 1;";
			$results = mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
			if($results->num_rows) {
				$dub_parcodes = array();
				while($row = $results->fetch_assoc()) {
					$db_barcode = trim($row['barcode']);
					echo "<FONT COLOR=\"#40A451\" >Error#3</FONT> : <FONT COLOR=\"red\" >Barcode $db_barcode for $sample_types Aliquot is assigned to more than one aliquot. Aliquot position won't be updated.</FONT><br>";
					unset($barcodes_and_positions[$db_barcode]);
				}				
			}
			//Get aliquot_master_id
			$query = "SELECT am.id, am.barcode, am.aliquot_control_id, am.storage_master_id, sm.short_label, am.storage_coord_x, am.in_stock
				FROM aliquot_masters am
				LEFT JOIN storage_masters sm ON sm.id = am.storage_master_id
				WHERE am.aliquot_control_id = $aliquot_control_id AND am.barcode IN ('".implode("','",array_keys($barcodes_and_positions))."') AND am.deleted <> 1;";
			$results = mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
			while($row = $results->fetch_assoc()) {
				$db_aliquot_master_id = $row['id'];
				$db_barcode = trim($row['barcode']);
				$db_storage_master_id = $row['storage_master_id'];
				if(!array_key_exists($db_barcode, $barcodes_and_positions)) {
					die('ERR327732732732 :: ' . $db_barcode);
				} else if($row['in_stock'] == 'no') {
					echo "<FONT COLOR=\"#CBE200\" >Error#4</FONT> : <FONT COLOR=\"red\" >$sample_types Aliquot with barcode $db_barcode is defined as 'Not in Stock' into ATiM so it can not be stored. Aliquot position won't be updated.</FONT><br>";
				} else if($db_storage_master_id && $row['short_label'] != "JGH Blood Bank Box 1") {
					echo "<FONT COLOR=\"#E23C00\" >Error#5.1</FONT> : <FONT COLOR=\"red\" >$sample_types Aliquot with barcode $db_barcode is already stored into ATiM (See ATiM box '".$row['short_label']."' at position ".$row['storage_coord_x']."). Aliquot position (".$barcodes_and_positions[$db_barcode]." (excel)) won't be updated.</FONT><br>";
				} else {
					if($db_storage_master_id) {
						echo "<FONT COLOR=\"#E23C00\" >Warning#5.2</FONT> : <FONT COLOR=\"blue\" >$sample_types Aliquot with barcode $db_barcode was stored into ATiM (See ATiM box '".$row['short_label']."' at position ".$row['storage_coord_x']."). Aliquot will be moved to the new box at position ".$barcodes_and_positions[$db_barcode]." (excel). Please confirm.</FONT><br>";
					}					
					//update statements
					$query = "UPDATE aliquot_masters SET storage_master_id = $storage_master_id, storage_coord_x = '".$barcodes_and_positions[$db_barcode]."', modified = '$modified', modified_by = $modified_by WHERE id = $db_aliquot_master_id;";
					mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
					$aliquots_updated++;
				}
				unset($barcodes_and_positions[$db_barcode]);
			}
			if(!empty($barcodes_and_positions)) {
				echo "<FONT COLOR=\"#0F00E2\" >Error#6</FONT> : <FONT COLOR=\"red\" >Following $sample_types barcodes have not been found into ATiM : ".implode(', ',array_keys($barcodes_and_positions)).".</FONT><br>";
			}
		}
		echo "<br><b>Updated $aliquots_updated/$aliquots_listed aliquots.</b><br>";	
		$total_aliquots_listed += $aliquots_listed;
		$total_aliquots_updated += $aliquots_updated;
	}
}

echo "<br><br><br><FONT COLOR=\"green\" >
=====================================================================<br>
Final count: Updated $total_aliquots_updated/$total_aliquots_listed aliquots
<br>=====================================================================</FONT><br><br>";

$queries = array("UPDATE storage_masters SET code = id WHERE code LIKE 'tmp_xxxx_%';",
	"UPDATE storage_masters_revs SET code = id WHERE code LIKE 'tmp_xxxx_%';",
	"INSERT INTO aliquot_masters_revs(
		id,
		barcode,
		aliquot_label,
		aliquot_control_id,
		collection_id,
		sample_master_id,
		sop_master_id,
		initial_volume,
		current_volume,
		in_stock,
		in_stock_detail,
		use_counter,
		study_summary_id,
		storage_datetime,
		storage_datetime_accuracy,
		storage_master_id,
		storage_coord_x,
		storage_coord_y,
		product_code,
		notes,
		modified_by,
		version_created)
		(SELECT 
		id,
		barcode,
		aliquot_label,
		aliquot_control_id,
		collection_id,
		sample_master_id,
		sop_master_id,
		initial_volume,
		current_volume,
		in_stock,
		in_stock_detail,
		use_counter,
		study_summary_id,
		storage_datetime,
		storage_datetime_accuracy,
		storage_master_id,
		storage_coord_x,
		storage_coord_y,
		product_code,
		notes,
		modified_by,
		modified
		FROM aliquot_masters WHERE modified = '$modified' AND modified_by = '$modified_by');",
	"INSERT INTO ad_tubes_revs (
		aliquot_master_id,
		lot_number,
		concentration,
		concentration_unit,
		cell_count,
		cell_count_unit,
		cell_viability,
		hemolysis_signs,
		version_created,
		qc_lady_storage_solution,
		qc_lady_hemoysis_color,
		qc_lady_hemoysis_color_other,
		qc_lady_storage_method)
		(SELECT 
		aliquot_master_id,
		lot_number,
		concentration,
		concentration_unit,
		cell_count,
		cell_count_unit,
		cell_viability,
		hemolysis_signs,
		modified,
		qc_lady_storage_solution,
		qc_lady_hemoysis_color,
		qc_lady_hemoysis_color_other,
		qc_lady_storage_method
		FROM aliquot_masters INNER JOIN ad_tubes ON aliquot_masters.id = ad_tubes.aliquot_master_id WHERE modified = '$modified' AND modified_by = '$modified_by');",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($queries as $query) {
	mysqli_query($db_connection, $query) or die("Query Error Line ".__LINE__." [$query] ");
}

mysqli_commit($db_connection);

//===========================================================================================================================================================
//===========================================================================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsertRecord($data_arr, $table_name, $is_detail_table = false) {
	global $db_connection;
	global $modified_by;
	global $modified;
	
	$created = $is_detail_table? array() : array(
		"created"		=> "'$modified'", 
		"created_by"	=> $modified_by, 
		"modified"		=> "'$modified'",
		"modified_by"	=> $modified_by
	);
	
	$data_to_insert = array();
	foreach($data_arr as $key => $value) {
		if(strlen($value)) {
			$data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
		}
	}
	//}
	
	$insert_arr = array_merge($data_to_insert, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	$record_id = mysqli_insert_id($db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()");
	$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	return $record_id;	
}

function formatNewLineData($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		$field = str_replace("\n", ' ', trim(utf8_encode($field)));
		if(isset($data[$key])) {
			$line_data[$field] = trim(utf8_encode($data[$key]));
		} else {
			$line_data[$field] = '';
		}
	}
	return $line_data;
}

?> 