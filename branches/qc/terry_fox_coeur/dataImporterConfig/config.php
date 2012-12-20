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
	static $db_schema		= "coeur";
	
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
	
 	//static $xls_file_path = "C:/_My_Directory/Local_Server/ATiM/tfri_coeur/data/OVCARE#3-138pts (June 11_2012) TFRI-COEUR -v3.0 2011-09-01(kim)_r20121217.xls";
 	//static $xls_file_path = "C:/_My_Directory/Local_Server/ATiM/tfri_coeur/data/TFRI-COEUR-CHUQ#3-20 new samples 10.10.2012- 3_r20121217.xls";
 	static $xls_file_path = "C:/_My_Directory/Local_Server/ATiM/tfri_coeur/data/Test.xls";
 	
 	
	static $xls_header_rows = 2;

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

	static $eoc_file_event_types	= array('ca125', 'ct scan', 'biopsy', 'surgery(other)', 'surgery(ovarectomy)', 'chemotherapy', 'radiotherapy');
	static $opc_file_event_types	= array('biopsy', 'surgery', 'chemotherapy', 'radiology', 'radiotherapy', 'hormonal therapy');
	
	static $sample_aliquot_controls = array();
	static $banks = array();
	static $drugs	= array();
	static $tissue_source = array();
	
	static $identifiers = array();
	
	static $line_break_tag = '<br>';
	
	static $coeur_accuracy_def = array("c" => "c", "y" => "m", "m" => "d", "d" => "c", "" => "");

	static $eoc_dx_id_from_participant_id = array();
	
	static $studied_participant_ids = array('qc_tf_bank_identifier' => null, 'eoc_diagnosis_master_id' => null);
}

//add your end queries here
Config::$addon_queries_end[] = "UPDATE diagnosis_masters SET primary_id=id WHERE parent_id IS NULL";

Config::$value_domains['qc_tf_ct_scan_precision']= new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['tissue_laterality']= new ValueDomain("tissue_laterality", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['qc_tf_tissue_type']= new ValueDomain("qc_tf_tissue_type", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "participants";

//add your configs
$relative_path = '../tfri_coeur/dataImporterConfig/tablesMapping/';
Config::$config_files[] = $relative_path.'participants.php';

Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc.php';
Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_no_site.php';
Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_site1.php';
Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_site2.php';
Config::$config_files[] = $relative_path.'qc_tf_dxd_eoc_progression_ca125.php';
Config::$config_files[] = $relative_path.'qc_tf_ed_eoc.php';
Config::$config_files[] = $relative_path.'qc_tf_tx_eoc.php';

Config::$config_files[] = $relative_path.'qc_tf_dxd_other_primary_cancer.php';
Config::$config_files[] = $relative_path.'qc_tf_dxd_other_progression.php';
Config::$config_files[] = $relative_path.'qc_tf_ed_other.php';
Config::$config_files[] = $relative_path.'qc_tf_tx_other.php';

Config::$config_files[] = $relative_path.'collections.php';

function addonFunctionStart(){
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS : COEUR<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";

	$query = "SELECT qc_tf_bank_id, qc_tf_bank_identifier FROM participants WHERE deleted <> 1";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		if(!checkAndAddBankIdentifier($row['qc_tf_bank_id'], $row['qc_tf_bank_identifier'], ' Duplicate value into DB')) { 
			die('ERR 8894989390 qc_tf_bank_identifier='.$row['qc_tf_bank_identifier']);
		}
	}
	
	// SET banks
	$query = "SELECT id, name, misc_identifier_control_id FROM banks";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$banks[$row['name']] = array(
			'id' => $row['id'],
			'misc_identifier_control_id' => $row['misc_identifier_control_id']);
	}	
	
	$query = "SELECT generic_name FROM drugs";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$drugs[] = $row['generic_name'];
	}	
	
	$query = "select id,sample_type from sample_controls where sample_type in ('tissue','blood', 'ascite', 'serum', 'plasma', 'dna', 'blood cell')";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 7) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'volume_unit' => $row['volume_unit']);
		}	
	}

	$query = "SELECT value FROM structure_permissible_values_customs INNER JOIN structure_permissible_values_custom_controls "
		."ON structure_permissible_values_custom_controls.id = structure_permissible_values_customs.control_id "
		."WHERE name LIKE 'tissue source'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$tissue_source[] = $row['value'];
	}
	Config::$tissue_source[] = '';	
}

function checkAndAddBankIdentifier($qc_tf_bank_id, $qc_tf_bank_identifier, $error_precision){
	$key = $qc_tf_bank_id."-".$qc_tf_bank_identifier;
	if(array_key_exists($key, Config::$identifiers)){
		global $insert;
		$insert = false;
		Config::$summary_msg['Patients']['@@ERROR@@']['Duplicate Patient Bank Identifier'][] = "identifier value [$qc_tf_bank_identifier] already exists for bank id [$qc_tf_bank_id] $error_precision".Config::$line_break_tag;
		return false;	
	}else{
		Config::$identifiers[$key] = null;
		return true;
	}
}

function addonFunctionEnd(){
//TODO to review
//pr(Config::$summary_msg);
//die('addonFunctionEnd TO REVIEW' );	
	// DIAGNOSIS / TRT / EVENT LINKS CREATION
	
pr('TODO : Follow-up from ovarectomy (months)');	
pr('Lier ca125 si progression ca 125');
pr('Warning si date < eoc dx date');
	
	
	// EMPTY DATES CLEAN UP
	
	$date_times_to_check = array(
		'collections.collection_datetime',
		'diagnosis_masters.dx_date',
		'event_masters.event_date',
		'participants.date_of_birth',
		'participants.date_of_death',
		'participants.qc_tf_suspected_date_of_death',
		'participants.qc_tf_last_contact',
		'treatment_masters.start_date',
		'treatment_masters.finish_date');

	foreach($date_times_to_check as $table_field) {
		$names = explode(".", $table_field);
		$table = $names[0];
		$field = $names[1];
		
		$query = "UPDATE $table SET $field = null WHERE $field LIKE '0000-00-00%'";
		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
		if(Config::$insert_revs){
			$query = "UPDATE ".$table."_revs SET $field = null WHERE $field LIKE '0000-00-00%'";
			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");			
		}
		
		$field_accuracy = $field.'_accuracy';
		$query = "UPDATE $table SET $field_accuracy = 'c' WHERE $field_accuracy = '' AND $field IS NOT NULL";
		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
		if(Config::$insert_revs){
			$query = "UPDATE ".$table."_revs SET $field = null WHERE $field LIKE '0000-00-00%'";
			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");
		}
	}
	
	// LAST DATA UPDATE
	
	$query = "UPDATE participants SET last_modification=created WHERE last_modification LIKE '0000-00-00%'";
	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	if(Config::$insert_revs){
		$query = "UPDATE participants_revs SET last_modification = version_created WHERE last_modification LIKE '0000-00-00%'";
		mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	}
	
	$query = "UPDATE aliquot_masters SET barcode=id WHERE barcode=''";
	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	if(Config::$insert_revs){
		$query = "UPDATE aliquot_masters_revs SET barcode=id WHERE barcode=''";
		mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	}
	
	$query = "UPDATE versions SET permissions_regenerated = 0";
	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
	
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
