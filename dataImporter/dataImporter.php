<?php
require_once("config.php");
require_once("dataImporter.php");
require_once("tables_mapping/consents.php");
require_once("tables_mapping/participants.php");
require_once("tables_mapping/sd_spe_bloods.php");

//validate each file exists and prep them
foreach($tables as $ref_name => &$table){
	if(strlen($table['app_data']['file']) > 0){
		if(!is_file($table['app_data']['file'])){
			die("File for [".$ref_name."] does not exist. [".$table['app_data']['file']."]\n");
		}
		$table['app_data']['file_handler'] = fopen($table['app_data']['file'], 'r');
		if(!$table['app_data']['file_handler']){
			die("fopen failed on ".$ref_name);
		}
		$table['app_data']['query_master_insert'] = "INSERT INTO ".$table["app_data"]['master_table_name']." (".buildInsertQuery($tables[$ref_name]['master']).") VALUES(";
		if(isset($table["app_data"]['detail_table_name'])){
			$table['app_data']['query_detail_insert'] = "INSERT INTO ".$table["app_data"]['detail_table_name']." (".buildInsertQuery($tables[$ref_name]['detail']).") VALUES(";
		}
		$table['app_data']['keys'] = lineToArray(fgets($table['app_data']['file_handler'], 4096));	
		$table['app_data']['values'] = lineToArray(fgets($table['app_data']['file_handler'], 4096));
		associate($table['app_data']['keys'], $table['app_data']['values']);
	}
}
unset($table);//weird bug otherwise

//init database connection
global $connection;
$connection = @mysqli_connect($database['ip'].":".$database['port'], $database['user'], $database['pwd']) or die("Could not connect to MySQL");
if(!mysqli_set_charset($connection, $database['charset'])){
	die("Invalid charset");
}
@mysqli_select_db($connection, $database['schema']) or die("db selection failed");
mysqli_autocommit($connection, false);

//create the temporary id linking table
$query = "CREATE TEMPORARY TABLE id_linking(
	csv_id varchar(10) not null,
	mysql_id int unsigned not null, 
	model varchar(15) not null
	)Engine=InnoDB";
mysqli_query($connection, $query) or die("temporary table query failed[".mysqli_errno($connection) . ": " . mysqli_error($connection)."]\n");

$primary_tables = array(//"participants" => $participants,
						"sd_spe_bloods" => $sd_spe_bloods);

foreach($primary_tables as $table_name => $table){
	insertTable($table_name, $tables);
}

//TODO: treat special tables such as collection links
$insert = true;
foreach($tables as $ref_name => &$table){
	if(strlen($table['app_data']['file']) > 0){
		if(!feof($table['app_data']['file_handler'])){
			echo("ERROR: Data was not all fetched from [".$ref_name."]\n");
			$insert = false;
		}
	}
}

if($insert){
//	mysqli_commit($connection);
	echo("Insertions commited\n");
}else{
	echo("Insertions cancelled\n");
}

echo("*************************\n"
	."* Integration completed *\n"
	."*************************\n");

/**
 * Takes an array of field and returns a string contianing those who have a non empty string value
 * @param array $fields 
 * @return string
 */
function buildInsertQuery($fields){
	$result = "";
	foreach($fields as $field => $value){
		if($field != "app_data" && strlen($value) > 0){
			$result .= $field.", ";
		}
	}
	
	return $result."created, created_by, modified, modified_by";
}

function buildValuesQuery($fields, $values){
	global $created_id;
	$result = "";
	foreach($fields as $field => $value){
		if(strpos($value, "@") === 0){
			$result .= "'".substr($value, 1)."', ";
		}else if(strlen($value) > 0){
			$result .= "'".$values[$value]."', ";
		}
	}
	return $result."NOW(), ".$created_id.", NOW(), ".$created_id;	
}

function clean($element){
	return str_replace('"', '', $element);
}

function associate($keys, &$values){
	foreach($keys as $i => $v){
		$values[$v] = $values[$i];
//		echo($keys[$i]." -> ".$values[$i]."\n");
	}
}

function lineToArray($line){
	$result = explode(";", substr($line, 0, strlen($line) - 1));
	return array_map("clean", $result);
	
}


function insertTable($table_name, &$tables, $csv_parent_key = null, $mysql_parent_id = null){
	global $connection;
	$current_table = &$tables[$table_name];
	$i = 0;
//	if($table_name == "consent_masters"){
//		echo("Size: ".sizeof($current_table['app_data']['values'])."\n");
//		echo($current_table['app_data']['values'][$current_table['master'][$current_table['app_data']['parent_key']]]."  -  ".$csv_parent_key."\n");
//		print_r($current_table['app_data']['values']);
//		echo($current_table['app_data']['values'][$current_table['master'][$current_table['app_data']['parent_key']]]."\n");
//	}
	while(sizeof($current_table['app_data']['values']) > 0 && 
		($csv_parent_key == null || $current_table['app_data']['values'][$current_table['master'][$current_table['app_data']['parent_key']]] == $csv_parent_key)){
		//replace parent value.
		if($mysql_parent_id != null){
			$current_table['app_data']['key before replace'] = $current_table['app_data']['values'][$current_table[$current_table['app_data']['parent_key']]];
			$current_table['app_data']['values'][$current_table['master'][$current_table['app_data']['parent_key']]] = $mysql_parent_id;
		}
		
		$query = $current_table['app_data']['query_master_insert'].buildValuesQuery($current_table["master"], $current_table['app_data']['values']).")";
		mysqli_query($connection, $query) or die("query failed[".$table_name."][".$query."][".mysqli_errno($connection) . ": " . mysqli_error($connection)."]".print_r($current_table)."\n");
		$last_id = mysqli_insert_id($connection);
		$last_detail_id = 0;
		echo $query."\n";
		if(isset($current_table['app_data']['query_detail_insert'])){
			//detail level
			$current_table['detail'][$current_table['app_data']['detail_parent_key']] = "@".$last_id;
			$query = $current_table['app_data']['query_detail_insert'].buildValuesQuery($current_table["detail"], $current_table['app_data']['values']).")";
			mysqli_query($connection, $query) or die("query failed[".$table_name."][".$query."][".mysqli_errno($connection) . ": " . mysqli_error($connection)."]".print_r($current_table)."\n");
			$last_detail_id = mysqli_insert_id($connection);
			echo $query."\n";
		}
		
		if(isset($current_table["app_data"]['additional_queries'])){
			//treat additional querries
			foreach($current_table["app_data"]['additional_queries'] as $ad_query){
				$ad_query = str_replace("%%last_master_insert_id%%", $last_id, str_replace("%%last_detail_insert_id%%", $last_detail_id, $ad_query));
				mysqli_query($connection, $ad_query) or die("ad query failed[".$table_name."][".$ad_query."][".mysqli_errno($connection) . ": " . mysqli_error($connection)."]".print_r($current_table)."\n");
				echo $ad_query."\n";
			}
		}
		if(isset($current_table['app_data']['save_id']) && $current_table['app_data']['save_id']){
			$query = "INSERT INTO id_linking (csv_id, mysql_id, model) VALUES('"
					.$current_table['app_data']['values'][$current_table['app_data']['pkey']]."', "
					.$last_id.", '".$table_name."')";
			echo $query."\n";
			mysqli_query($connection, $query) or die("tmp id query failed[".$table_name."][".$query."][".mysqli_errno($connection) . ": " . mysqli_error($connection)."]".print_r($current_table)."\n");	
		}
		
		//treat child
		foreach($current_table["app_data"]['child'] as $child_table_name){
			insertTable($child_table_name, $tables, $current_table['app_data']['values'][$current_table["app_data"]["pkey"]], $last_id);
		}
		flush();
		if(feof($current_table['app_data']['file_handler'])){
			$current_table['app_data']['values'] = array();
		}else{
			do{
				//read line, skip empty lines
				$line = fgets($current_table['app_data']['file_handler'], 4096);
//				echo($line."\n");
				$current_table['app_data']['values'] = lineToArray($line);
				associate($current_table['app_data']['keys'], $current_table['app_data']['values']);
			}while(!feof($current_table['app_data']['file_handler']) && (sizeof($current_table['app_data']['values']) <= (sizeof($current_table['app_data']['keys']) + 1) || 
				(strlen($current_table["app_data"]["pkey"]) > 0 && strlen($current_table['app_data']['values'][$current_table["app_data"]["pkey"]]) == 0)));
			if(feof($current_table['app_data']['file_handler'])){
				$current_table['app_data']['values'] = array();
			}
		}
	}
}
