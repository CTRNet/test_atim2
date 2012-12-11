<?php
#drop database atim_tf_prostate; create database atim_tf_prostate; use atim_tf_prostate;
class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "cpcbn";
	
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//Date format
	//static $use_windows_xls_offset = true;
	
	//if reading excel file
	
	static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/TMA_layout_20121200.xls';
	static $use_windows_xls_offset = false;
	
	static $xls_header_rows = 1;

	static $print_queries	= false;//whether to output the dataImporter generated queries
	static $insert_revs		= true;//whether to insert generated queries data in revs as well
	
	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	
	//for display
	static $line_break_tag = '<br>';
	
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
			die("Defining model ref name [".$ref_name."] more than once".Config::$line_break_tag);
		}
		Config::$models[$ref_name] = $m;
	}

	// Custom variables
	
	static $summary_msg = array();
	
	static $banks = array();
	
	static $tma_control_id = null;
	static $last_storage_rght = 0;
	
	static $sample_aliquot_controls = array();
	static $collection_ids = array();
	static $sample_master_ids = array();
}

//add you start queries here
Config::$addon_queries_start[] = "DROP TABLE IF EXISTS start_time";
Config::$addon_queries_start[] = "CREATE TABLE start_time (SELECT NOW() AS start_time)";

//add the parent models here
Config::$parent_models[] = "tma";

//add your configs
$relative_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/dataImporterConfig/tma/tablesMapping/';
Config::$config_files[] = $relative_path.'tmas.php';
Config::$config_files[] = $relative_path.'cores.php';

function addonFunctionStart(){
	$file_name = substr(Config::$xls_file_path, (strrpos(Config::$xls_file_path, '/') + 1));
	echo "<FONT COLOR=\"green\" >".Config::$line_break_tag.
	"=====================================================================".Config::$line_break_tag."
	DATA (TMA) EXPORT PROCESS : CPCBN TFRI".Config::$line_break_tag."
	source_file = $file_name".Config::$line_break_tag."
	".Config::$line_break_tag."=====================================================================
	</FONT>".Config::$line_break_tag."";	
	
	$query = "SELECT id FROM storage_controls WHERE storage_type = 'TMA-blc 23X23'";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$tma_data = $results->fetch_assoc();
	if($tma_data) {
		Config::$tma_control_id = $tma_data['id'];
	} else {
		die("[$query] ".__FUNCTION__." ".__LINE__);
	}
	
	$query = "SELECT MAX(rght) as last_rght FROM storage_masters;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	Config::$last_storage_rght = empty($row['last_rght'])? 0 : $row['last_rght'];
	
	$query = "select id,sample_type from sample_controls where sample_type in ('tissue');";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 1) die("get sample controls failed");
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'volume_unit' => $row['volume_unit']);
		}	
	}
	
	$query = "SELECT id, name FROM banks";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$banks[$row['name']] = $row['id'];
	}
}

function addonFunctionEnd(){
	
	$query = "UPDATE versions SET permissions_regenerated = 0;";
	mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	
	// MESSAGES
	
	global $insert;
	foreach(Config::$summary_msg as $data_type => $msg_arr) {
		echo "".Config::$line_break_tag."".Config::$line_break_tag."<FONT COLOR=\"blue\" >
		=====================================================================".Config::$line_break_tag."".Config::$line_break_tag."
		PROCESS SUMMARY: $data_type
		".Config::$line_break_tag."".Config::$line_break_tag."=====================================================================
		</FONT>".Config::$line_break_tag."";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
//TODO			$insert = false;
			echo "".Config::$line_break_tag."<FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT>".Config::$line_break_tag."";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "".Config::$line_break_tag." --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
				foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	
		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "".Config::$line_break_tag."<FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT>".Config::$line_break_tag."";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "".Config::$line_break_tag." --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
				foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	
		if(!empty($msg_arr['@@MESSAGE@@'])) {
		echo "".Config::$line_break_tag."<FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT>".Config::$line_break_tag."";
		foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
			echo "".Config::$line_break_tag." --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
			foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	}
	
//	echo Config::$line_break_tag."Don't forget to rebuild view : \app>..\lib\Cake\Console\cake view".Config::$line_break_tag;
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}
