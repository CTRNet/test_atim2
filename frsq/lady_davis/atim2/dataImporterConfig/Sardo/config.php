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
	static $db_schema		= "jghbreast";
	
// 	static $db_port 		= "3306";
// 	static $db_user 		= "root";
// 	static $db_pwd			= "";
// 	static $db_schema		= "tfri";
	
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	static $use_windows_xls_offset = true;
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	
//	static $xls_file_path = "C:/_Perso/Server/tfri_coeur/data/COEUR-OTB-#1_20131129.xls";
 	static $xls_file_path = "C:/_Perso/Server/jgh_breast/data/SardoDxTxReceptors.xls";
 	
 	
	static $xls_header_rows = 1;

	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well
	
	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	//--------------------------------------
	
	
	//this shouldn't be edited here
	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
	
	static function addModel(Model $m, $ref_name){
		if(array_key_exists($ref_name, Config::$models)){
			die("Defining model ref name [".$ref_name."] more than once\n");
		}
		Config::$models[$ref_name] = $m;
	}
	
	static $summary_msg = array();
	
	static $migration_date = null;
	static $line_break_tag = '<br>';
	
	static $participants = array();	
	static $topos = array();
	static $morphos = array();
	static $surgical_procedures = array();
	static $biopsy_procedures = array();
	static $radiation_procedures = array();
	static $drugs = array();
	static $protocols = array();
	
	


}

//add your end queries here
// Config::$addon_queries_end[] = "UPDATE diagnosis_masters SET primary_id=id WHERE parent_id IS NULL";

// Config::$value_domains['qc_tf_ct_scan_precision']= new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
// Config::$value_domains['tissue_laterality']= new ValueDomain("tissue_laterality", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
// Config::$value_domains['qc_tf_tissue_type']= new ValueDomain("qc_tf_tissue_type", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
//Config::$parent_models[] = "participants";

//add your configs
$relative_path = '../jgh_breast/dataImporterConfig/Sardo/tablesMapping/';
Config::$config_files[] = $relative_path.'diagnosis.php';
Config::$config_files[] = $relative_path.'treatments.php';
Config::$config_files[] = $relative_path.'receptors.php';

// Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc.php';
// Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_no_site.php';
// Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_site1.php';
// Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_site2.php';
// Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_ca125.php';
// Config::$config_files[] = $relative_path.'qc_tf_ed_eoc.php';
// Config::$config_files[] = $relative_path.'qc_tf_tx_eoc.php';

// Config::$config_files[] = $relative_path.'qc_tf_dxd_other_primary_cancer.php';
// Config::$config_files[] = $relative_path.'qc_tf_dxd_other_progression.php';
// Config::$config_files[] = $relative_path.'qc_tf_ed_other.php';
// Config::$config_files[] = $relative_path.'qc_tf_tx_other.php';

// Config::$config_files[] = $relative_path.'collections.php';

function addonFunctionStart(){
	
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS : COEUR<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";

	$query = "select NOW() AS migration_date;";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	Config::$migration_date = $row['migration_date'];
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	$sheets_keys = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;
	
	loadDxCodes($tmp_xls_reader, $sheets_keys);
	loadDiagnosis($tmp_xls_reader, $sheets_keys);
	loadTreatments($tmp_xls_reader, $sheets_keys);
	loadReceptors($tmp_xls_reader, $sheets_keys);
	
	
	
	
	

}

function addonFunctionEnd(){
	// Update Profile
	foreach(Config::$participants as $jgh_nbr => $participant_data) {
		if($participant_data['participant_id']) {
			$participant_data_to_update = $participant_data['participant_db_data_to_update'];
			if($participant_data_to_update) {
				$participant_id = $participant_data['participant_id'];
				$participant_data_to_update[] = "modified = '".Config::$migration_date."'";
				$participant_data_to_update[] = "modified_by = '".Config::$db_created_id."'";
				$update_query = "UPDATE participants SET ".implode(', ',$participant_data_to_update)." WHERE id = $participant_id";
				mysqli_query(Config::$db_connection, $update_query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$update_query."]");
				$update_query = "
					INSERT INTO participants_revs (id,title,first_name,middle_name,last_name,date_of_birth,date_of_birth_accuracy,marital_status,language_preferred,
						sex,race,vital_status,notes,date_of_death,date_of_death_accuracy,
						cod_icd10_code,secondary_cod_icd10_code,cod_confirmation_source,participant_identifier,
						last_chart_checked_date,last_chart_checked_date_accuracy,last_modification,last_modification_ds_id,
						modified_by,
						version_created,
						qc_lady_spouse_name)
					(SELECT id,title,first_name,middle_name,last_name,date_of_birth,date_of_birth_accuracy,marital_status,language_preferred,
						sex,race,vital_status,notes,date_of_death,date_of_death_accuracy,
						cod_icd10_code,secondary_cod_icd10_code,cod_confirmation_source,participant_identifier,
						last_chart_checked_date,last_chart_checked_date_accuracy,last_modification,last_modification_ds_id,
						modified_by,
						modified,
						qc_lady_spouse_name FROM participants WHERE id = $participant_id);";
				mysqli_query(Config::$db_connection, $update_query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$update_query."]");
			}
		}
	}
	//Record Surgical Procedure
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Surgical Procedure'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	$control_id = $row['id'];
	foreach(Config::$surgical_procedures as $value => $fr) {
		customInsertRecord(array('value' => $value, 'fr' => $fr, 'use_as_input' => '1', 'control_id' => $control_id), 'structure_permissible_values_customs');
	}
	
	//Record Biopsy Procedure
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Biopsy Procedure'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	$control_id = $row['id'];
	foreach(Config::$biopsy_procedures as $value => $fr) {
		customInsertRecord(array('value' => $value, 'fr' => $fr, 'use_as_input' => '1', 'control_id' => $control_id), 'structure_permissible_values_customs');
	}
	
	//Record Radiation Procedure
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Radiation Procedure'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	$control_id = $row['id'];
	foreach(Config::$radiation_procedures as $value => $fr) {
		customInsertRecord(array('value' => $value, 'fr' => $fr, 'use_as_input' => '1', 'control_id' => $control_id), 'structure_permissible_values_customs');
	}
	
	//Record data
	foreach(Config::$participants as $jgh_nbr => $patient_data) {
		if(!empty($participant_data['participant_id'])) {
			if(isset($patient_data['diagnoses_data'])) {
				foreach($patient_data['diagnoses_data'] as $tmp_date_dx => $pt_data_level1) {
					foreach($pt_data_level1 as $icd10_code_morphology => $p_data_level2) {
						//Create Diagnosis
						foreach($p_data_level2['Diagnosis'] as $dx_data) {
							customInsertRecord($dx_data['diagnosis_masters'], 'diagnosis_masters');
							customInsertRecord($dx_data['qc_lady_dxd_breasts'], 'qc_lady_dxd_breasts', true);
						}
						if(isset($p_data_level2['Treatment'])) {
							//Create Treatment
							foreach($p_data_level2['Treatment'] as $tx_data) {
								$treatment_master_id = customInsertRecord($tx_data['treatment_masters'], 'treatment_masters');						
								if(array_key_exists('qc_lady_txd_biopsy_surgeries', $tx_data)) {
									customInsertRecord($tx_data['qc_lady_txd_biopsy_surgeries'], 'qc_lady_txd_biopsy_surgeries', true);
								} else if(array_key_exists('txd_chemos', $tx_data)) {
									customInsertRecord($tx_data['txd_chemos'], 'txd_chemos', true);
								} else if(array_key_exists('txd_radiations', $tx_data)) {
									customInsertRecord($tx_data['txd_radiations'], 'txd_radiations', true);
								} else if(array_key_exists('qc_lady_txd_hormonos', $tx_data)) {
									customInsertRecord($tx_data['qc_lady_txd_hormonos'], 'qc_lady_txd_hormonos', true);
								} else if(array_key_exists('qc_lady_txd_immunos', $tx_data)) {
									customInsertRecord($tx_data['qc_lady_txd_immunos'], 'qc_lady_txd_immunos', true);
								} else {
									pr($tx_data);
									die('ERR 77738883773');
								}
								$treatment_extends = array();
								if(isset($tx_data['treatment_extends'])) {
									foreach($tx_data['treatment_extends'] as $txe_data) {
										customInsertRecord($txe_data['treatment_extend_masters'], 'treatment_extend_masters');
										if(array_key_exists('txe_surgeries', $txe_data)) {
											customInsertRecord($txe_data['txe_surgeries'], 'txe_surgeries', true);
										} else if(array_key_exists('qc_lady_txe_biopsies', $txe_data)) {
											customInsertRecord($txe_data['qc_lady_txe_biopsies'], 'qc_lady_txe_biopsies', true);
										} else if(array_key_exists('txe_chemos', $txe_data)) {
											customInsertRecord($txe_data['txe_chemos'], 'txe_chemos', true);
										} else if(array_key_exists('qc_lady_txe_hormonos', $txe_data)) {
											customInsertRecord($txe_data['qc_lady_txe_hormonos'], 'qc_lady_txe_hormonos', true);
										} else if(array_key_exists('qc_lady_txe_radiations', $txe_data)) {
											customInsertRecord($txe_data['qc_lady_txe_radiations'], 'qc_lady_txe_radiations', true);
										} else if(array_key_exists('qc_lady_txe_immunos', $txe_data)) {
											customInsertRecord($txe_data['qc_lady_txe_immunos'], 'qc_lady_txe_immunos', true);
										} else {
											pr($txe_data);
											die('ERR 2387 6872 368 32');
										}
									}
								}
							}
						}
					}
				}
			} else {
				//Msg already displayed
			}
		} else {
			//Msg already displayed
		}
	}
	
	
//TODO calculer age au dx + survie	
	
	// EMPTY DATES CLEAN UP
	
	// 	$date_times_to_check = array(
	// 		'collections.collection_datetime',
	// 		'diagnosis_masters.dx_date',
	// 		'event_masters.event_date',
	// 		'participants.date_of_birth',
	// 		'participants.date_of_death',
	// 		'participants.qc_tf_suspected_date_of_death',
	// 		'participants.qc_tf_last_contact',
	// 		'treatment_masters.start_date',
	// 		'treatment_masters.finish_date');
	
	// 	foreach($date_times_to_check as $table_field) {
	// 		$names = explode(".", $table_field);
	// 		$table = $names[0];
	// 		$field = $names[1];
	
	// 		$query = "UPDATE $table SET $field = null WHERE $field LIKE '0000-00-00%'";
	// 		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
	// 		if(Config::$insert_revs){
	// 			$query = "UPDATE ".$table."_revs SET $field = null WHERE $field LIKE '0000-00-00%'";
	// 			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");
	// 		}
	
	// 		$field_accuracy = $field.'_accuracy';
	// 		$query = "UPDATE $table SET $field_accuracy = 'c' WHERE $field_accuracy = '' AND $field IS NOT NULL";
	// 		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
	// 		if(Config::$insert_revs){
	// 			$query = "UPDATE ".$table."_revs SET $field = null WHERE $field LIKE '0000-00-00%'";
	// 			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");
	// 		}
	// 	}
	
	
// 	$query = "UPDATE versions SET permissions_regenerated = 0";
// 	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	
	// Summary Message Display
	
	global $insert;
	foreach(Config::$summary_msg as $data_type => $msg_arr) {
		echo "".Config::$line_break_tag."".Config::$line_break_tag."<FONT COLOR=\"blue\" >
		=====================================================================".Config::$line_break_tag."".Config::$line_break_tag."
		PROCESS SUMMARY: $data_type
		".Config::$line_break_tag."".Config::$line_break_tag."=====================================================================
		</FONT>".Config::$line_break_tag."";
			
		foreach($msg_arr AS $msg_type => $msg_sub_arr) {
		if(!in_array($msg_type, array('@@ERROR@@','@@WARNING@@','@@MESSAGE@@'))) die('ERR 89939393 '.$msg_type);
			//TODO (if error)			$insert = false;
			$color = str_replace(array('@@ERROR@@','@@WARNING@@','@@MESSAGE@@'),array('red','orange','green'),$msg_type);
			echo "".Config::$line_break_tag."<FONT COLOR=\"$color\" ><b> ** $msg_type summary ** </b> </FONT>".Config::$line_break_tag."";
			foreach($msg_sub_arr as $type => $msgs) {
				echo "".Config::$line_break_tag." --> <FONT COLOR=\"$color\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
				foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	}
}
	
function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customArrayCombineAndUtf8Encode($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

function customInsertRecord($data_arr, $table_name, $is_detail_table = false) {
	$created = $is_detail_table? array() : array(
			"created"		=> "'".Config::$migration_date."'",
			"created_by"	=> Config::$db_created_id,
			"modified"		=> "'".Config::$migration_date."'",
			"modified_by"	=> Config::$db_created_id
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
	mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));

	$record_id = mysqli_insert_id(Config::$db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()");
	if(Config::$insert_revs) {
		$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
		$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
		mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}

	return $record_id;
}