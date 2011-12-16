<?php

class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "ldovary";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path	= "C:/Documents and Settings/u703617/Desktop/ldovary/GotliebBankData_submited_by_AmberYasmeen_20111216_and_revised.xls";

	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well

	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	
	//--------------------------------------

	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
	
	//--------------------------------------

	static $sample_aliquot_controls = array();
	static $label_2_sample_description = array();
			
	static $storages = array('next_left' => 1, 'current_id' => null);
	static $current_participant = array("initial" => null, "collection_label" => null, "collection_date" => null, 'samples' => array());

	static $migration_date	= null;
	
	static $end_of_file_detected =false;
}

//add you start queries here
//Config::$addon_queries_start[] = "..."

//add your end queries here
//Config::$addon_queries_end[] = "..."

//add some value domains names that you want to use in post read/write functions
Config::$value_domains['tissue_laterality']= new ValueDomain("tissue_laterality", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['qc_ldov_tissue_type']= new ValueDomain("qc_ldov_tissue_type", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "Collection";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/ld_ovary/dataImporterConfig/tablesMapping/collections.php'; 

function addonFunctionStart(){
	Config::$migration_date	= "'".Date("Y-m-d")."'";
	
	echo("<br>//=========== MIGRATION SUMMARY ====================================================<br>");
	echo("<br>DATE : ".Config::$migration_date."<br>");
	echo("<br>FILE : ".Config::$xls_file_path."<br>");
	echo("<br>//==================================================================================<br><br>");
	
	echo("<br>//=========== setStaticDataForCollection ====================================================<br>");
	setStaticDataForCollection();
	echo("<br>//=========== Launch data import process ====================================================<br>");
}

function addonFunctionEnd(){
	echo("<br>//=========== END OF FILE DETECTED ====================================================<br>");
	if(!Config::$end_of_file_detected) die('END OF FILE NOT DETECTED');
	echo("<br>//=========== cleanUpCollectionDate ====================================================<br>");
	cleanUpCollectionDate();
	echo("<br>//=========== Complete revs table ====================================================<br>");
	completeInvetoryRevsTable();
	echo("<br>//=========== End ====================================================<br>");
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function setStaticDataForCollection() {
	
	global $connection;

	//-------------------------------------------------------------------
	// Set sample aliquot controls
	//-------------------------------------------------------------------
	
	$query = "SELECT DISTINCT derivative_sample_control_id FROM parent_to_derivative_sample_controls WHERE flag_active = '1' AND parent_sample_control_id IS NULL";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	$new_ids = array();
	$all_ids = array();
	while($row = $results->fetch_assoc()){
		$new_ids[] = $row['derivative_sample_control_id'];
		$all_ids[] = $row['derivative_sample_control_id'];
	}
	$sount = 0;
	while(!empty($new_ids)) {
		$query = "SELECT DISTINCT derivative_sample_control_id FROM parent_to_derivative_sample_controls WHERE flag_active = '1' AND parent_sample_control_id IN ('".implode("','", $new_ids)."')";
		$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
		$new_ids = array();
		while($row = $results->fetch_assoc()){
			if(!in_array($row['derivative_sample_control_id'], $all_ids)) {
				$new_ids[] = $row['derivative_sample_control_id'];
				$all_ids[] = $row['derivative_sample_control_id'];
			}
		}
	}
	
	$query = "select id,sample_type,detail_tablename from sample_controls where id in ('".implode("','", $all_ids)."')";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}	
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}	
	}
	
	//-------------------------------------------------------------------
	// Set Tissue Source
	//-------------------------------------------------------------------
	
	$tissue_source_list = array();
	$query = "SELECT value FROM structure_permissible_values_customs INNEr JOIN structure_permissible_values_custom_controls "
		."ON structure_permissible_values_custom_controls.id = structure_permissible_values_customs.control_id "
		."WHERE name LIKE 'qc ldov tissues sources'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$tissue_source_list[] = $row['value'];
	}
	$tissue_source_list[] = '';	
	
	//-------------------------------------------------------------------
	// Set label to sample description
	//-------------------------------------------------------------------
	
	$xls_reader_matches = new Spreadsheet_Excel_Reader();
	$xls_reader_matches->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($xls_reader_matches->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

	if(!array_key_exists('Match Table', $sheets_nbr)) die("ERROR: Worksheet 'Match Table' is missing!\n");

	$headers = array_flip($xls_reader_matches->sheets[$sheets_nbr['Match Table']]['cells'][1]);
	if(!array_key_exists('file value', $headers)
	|| !array_key_exists('sample type', $headers)
	|| !array_key_exists('Tissue Source Match', $headers)
	|| !array_key_exists('Tissue Type Match', $headers)
	|| !array_key_exists('Tissue Laterality Match', $headers)) die("ERROR: Headers of Match Table!\n"); 
	
	$line_counter = 0;
	foreach($xls_reader_matches->sheets[$sheets_nbr['Match Table']]['cells'] as $line => $new_line) {
		$line_counter++;
		
		if($line_counter != 1) {	
			$label = preg_replace(array('/\s\s+/', '/\ $/', '/^\ /'), array(' ', '', ''), $new_line[$headers['file value']]);
			$label = utf8_encode($label);
			$sample_type = array_key_exists($headers['sample type'], $new_line)? $new_line[$headers['sample type']] : '';
			$tissue_source = array_key_exists($headers['Tissue Source Match'], $new_line)? $new_line[$headers['Tissue Source Match']] : '';
			$tissue_type = array_key_exists($headers['Tissue Type Match'], $new_line)? $new_line[$headers['Tissue Type Match']] : '';
			$tissue_laterality = array_key_exists($headers['Tissue Laterality Match'], $new_line)? $new_line[$headers['Tissue Laterality Match']] : '';
			
			if(!empty($label)) {				
				if(empty($sample_type)) {
					echo "<br><FONT COLOR=\"red\" >SAMPLE LABEL MATCHES : Missing match for label [$label]</FONT>";
					
				} else {
					$is_clot = false;
					if($sample_type == 'blood cell clot') {
						$sample_type = 'blood cell';
						$is_clot = true;
					}
					
					if(!array_key_exists($sample_type, Config::$sample_aliquot_controls)) die("ERROR: Sample Type $sample_type not supported!\n");
					
					$working_array = array();
					switch($sample_type) {
						case 'tissue':
							
							if($tissue_source == 'other') $tissue_source = '';
							if(!in_array($tissue_source, $tissue_source_list)) die ("WARNING: Unmatched tissue source value [$tissue_source] at line [$line_counter]\n"); 
							
							$tissue_type_domain = Config::$value_domains['qc_ldov_tissue_type'];
							$tissue_type_value = $tissue_type_domain->isValidValue($tissue_type);
							if($tissue_type_value === null) die ("WARNING: Unmatched tissue type value [$tissue_type] at line [$line_counter]\n");
										
							$lat_domain = Config::$value_domains['tissue_laterality'];
							$lat_value = $lat_domain->isValidValue($tissue_laterality);
							if($lat_value === null) die ("WARNING: Unmatched laterality value [$tissue_laterality] at line [$line_counter]\n");
														
							$working_array = array(
								'sample_type' => $sample_type, 
								'tissue_source' => $tissue_source, 
								'tissue_type' => $tissue_type, 
								'tissue_laterality' => $tissue_laterality);
							break;
							
						case 'blood cell':
							$working_array = array(
								'sample_type' => $sample_type, 
								'is_clot' => $is_clot);
							break;
							
						default:
							$working_array = array('sample_type' => $sample_type);
					}
					
					
				
					if(array_key_exists($label, Config::$label_2_sample_description)) {
						$dupliacted_array = Config::$label_2_sample_description[$label];
						if($dupliacted_array !== $working_array) {
							echo "<br><FONT COLOR=\"green\" >SAMPLE LABEL MATCHES : Label '$label' is defined twice with 2 differents data!</FONT>";
							pr($dupliacted_array);pr($working_array);
						}
					} else {					
						Config::$label_2_sample_description[$label] = $working_array;
					}
				}
			}
		}
	}
		
	echo "<br>";
}

function cleanUpCollectionDate() {
 	global $connection;
 	$query = "UPDATE collections SET collection_datetime = null WHERE collection_datetime = '0000-00-00 00:00:00'";
	mysqli_query($connection, $query) or die("collection_datetime clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}
function completeInvetoryRevsTable() {
	global $connection;

	if(Config::$insert_revs){
		$revs_tables = array(
			'participants',
			'misc_identifiers',		
		
			'clinical_collection_links',	
			'collections',	

			'sample_masters',
			'specimen_details',
			'derivative_details',
		
			'sd_spe_bloods',
			'sd_spe_cystic_fluids',
			'sd_spe_peritoneal_washes',
			'sd_spe_pleural_fluids',
			'sd_spe_tissues',
			'sd_spe_ascites',
			'sd_der_cystic_fl_sups',
			'sd_der_cystic_fl_cells',
			'sd_der_ascite_cells',
			'sd_der_ascite_sups',
			'sd_der_blood_cells',
			'sd_der_pleural_fl_cells',
			'sd_der_pleural_fl_sups',
			'sd_der_pw_cells',
			'sd_der_pw_sups',
			'sd_der_serums',
			'sd_der_plasmas',
		
			'aliquot_masters',
			'ad_tubes',
		
			'storage_masters',
			'std_boxs');		
		
		foreach ($revs_tables as $table_name) {
			$query = '';
			switch($table_name) {
				
				case 'participants':
					$query = "INSERT INTO ".$table_name."_revs (id, participant_identifier, qc_ldov_initals, version_created) "
						."SELECT id, participant_identifier, qc_ldov_initals, ".Config::$migration_date." FROM ".$table_name;
					break;	

				case 'misc_identifiers':
					$query = "INSERT INTO ".$table_name."_revs (id, identifier_value, participant_id, misc_identifier_control_id, version_created) "
						."SELECT id, identifier_value, participant_id, misc_identifier_control_id, ".Config::$migration_date." FROM ".$table_name;
					break;
		
				case 'clinical_collection_links':
					$query = "INSERT INTO ".$table_name."_revs (id, collection_id, participant_id, version_created) "
						."SELECT id, collection_id, participant_id, ".Config::$migration_date." FROM ".$table_name;
					break;		
					
				case 'collections':	
					$query = "INSERT INTO ".$table_name."_revs (id, acquisition_label, bank_id, collection_datetime, collection_datetime_accuracy, collection_site, collection_property, collection_notes, version_created) "
						."SELECT id, acquisition_label, bank_id, collection_datetime, collection_datetime_accuracy, collection_site, collection_property, collection_notes, ".Config::$migration_date." FROM ".$table_name;
					break;
		
				case 'sample_masters':
					$query = "INSERT INTO ".$table_name."_revs (id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, version_created) "
						."SELECT id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, parent_sample_type, ".Config::$migration_date." FROM ".$table_name;
					break;
				
				case 'specimen_details':
				case 'derivative_details':

				case 'sd_spe_bloods':
				case 'sd_spe_cystic_fluids':
				case 'sd_spe_peritoneal_washes':
				case 'sd_spe_pleural_fluids':
				case 'sd_spe_ascites':
					
				case 'sd_der_cystic_fl_sups':
				case 'sd_der_cystic_fl_cells':
				case 'sd_der_ascite_cells':
				case 'sd_der_ascite_sups':
				case 'sd_der_blood_cells':
				case 'sd_der_pleural_fl_cells':
				case 'sd_der_pleural_fl_sups':
				case 'sd_der_pw_cells':
				case 'sd_der_pw_sups':
				case 'sd_der_serums':
				case 'sd_der_plasmas':
				
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, version_created) "
						."SELECT id, sample_master_id, ".Config::$migration_date." FROM ".$table_name;
					break;	
				
					
				case 'sd_spe_tissues':
				
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, tissue_nature, tissue_source, tissue_laterality, version_created) "
						."SELECT id, sample_master_id, tissue_nature, tissue_source, tissue_laterality, ".Config::$migration_date." FROM ".$table_name;
					break;	

				case 'aliquot_masters':		
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, aliquot_control_id, in_stock, collection_id, aliquot_label, storage_master_id, version_created) "
						."SELECT id, sample_master_id, aliquot_control_id, in_stock, collection_id, aliquot_label, storage_master_id, ".Config::$migration_date." FROM ".$table_name;
					break;	
		
				case 'ad_tubes':
					$query = "INSERT INTO ".$table_name."_revs (id, aliquot_master_id, hemolysis_signs, version_created) "
						."SELECT id, aliquot_master_id, hemolysis_signs, ".Config::$migration_date." FROM ".$table_name;
					break;	
			
				case 'storage_masters':
					$query = "INSERT INTO ".$table_name."_revs (id, code, storage_control_id, rght, lft, selection_label, short_label, version_created) "
						."SELECT id, code, storage_control_id, rght, lft, selection_label, short_label, ".Config::$migration_date." FROM ".$table_name;
					break;					
				case 'std_boxs':	
					$query = "INSERT INTO ".$table_name."_revs (id, storage_master_id, version_created) "
						."SELECT id, storage_master_id, ".Config::$migration_date." FROM ".$table_name;
					break;				
				
				default:
					die("ERR 007 : ".$table_name);	
			}
			mysqli_query($connection, $query) or die("inventroy revs table completion [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
		}	
	}
}

?>
