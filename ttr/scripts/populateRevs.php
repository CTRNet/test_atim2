<?php
/**
 * All data of tables with *_revs will be inserted in the later.
 * All aliquots with the flag in_stock='no' and storage_master_id NOT NULL 
 * will be updated to remove storage data. The updated version will be
 * inserted into the matching *_revs.
 * @author FM L'Heureux for Nicolas Luc
 */

//$argv = array('1'=>'atim','2'=>'root','3'=>'');

global $schema;
$schema = $argv[1];
$user = $argv[2];
$password = $argv[3];

$server = "localhost";

global $db;
$db = @new mysqli($server, $user, $password, $schema);

if ($db->connect_errno) {
    die('Connect Error: ' . $db->connect_errno);
}
if(!$db->set_charset("utf8")){
	die("We failed");
}
echo "**************************\n"
	,"*  Revs                  *\n"
	,"**************************\n";
copyDataToRevs($schema);
echo "sleep 5 seconds to leave a gap in version_created\n";
sleep(5);
echo "***********END************\n";


function copyDataToRevs(){
	global $db;
	global $schema;
	
	// Set default date
	$res = $db->query("SELECT NOW() AS modified");
	$res2 = $res->fetch_assoc();
	$default_date = date('Y-m-d H').':00:00';
	$default_aliquot_v1 = date('Y-m-d H').':01:00';
	$default_aliquot_v2 = date('Y-m-d H').':02:00';
	
	// Set migration user id
	$user_id = '0';	

	$revs_tables = array();
	$tables = array();
	$result = $db->query("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='".$schema."' AND TABLE_NAME LIKE '%_revs' AND TABLE_NAME NOT IN ('aliquot_masters_revs','storage_masters_revs') ORDER BY TABLE_NAME") or die($db->error);
	while ($row = $result->fetch_assoc()) {
		$revs_tables[$row['TABLE_NAME']] = null;
	}
	$result->free();
	
	$result = $db->query("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='".$schema."' AND TABLE_NAME NOT LIKE '%_revs' AND TABLE_NAME NOT IN ('aliquot_masters','storage_masters') ORDER BY TABLE_NAME") or die($db->error);
	$tables = array();
	while ($row = $result->fetch_assoc()) {
		$tables[] = $row['TABLE_NAME'];
	}
	$result->free();
	
	foreach($tables as $table_name){
		$revs_table_name = $table_name."_revs";
		if(array_key_exists($revs_table_name, $revs_tables)){
			
			echo "-- New table : ".$table_name." \n";
			
			$sql = "UPDATE ".$table_name." SET created = '".$default_date."', created_by = ".$user_id.", modified = '".$default_date."', modified_by = ".$user_id." WHERE deleted = 0";
			$db->query($sql) or die("died on ".$table_name .":".$sql);
			$sql = "UPDATE ".$table_name." SET created = deleted_date, created_by = ".$user_id.", modified = deleted_date, modified_by = ".$user_id." WHERE deleted = 1";
			$db->query($sql) or die("died on ".$table_name .":".$sql);
					
			$table_cols = getFields($table_name);
			$revs_table_cols = getFields($revs_table_name);
			$common_columns = array_intersect($table_cols, $revs_table_cols);
			
			$sql = "TRUNCATE $revs_table_name";
			$db->query($sql) or die("died on ".$table_name .":".$sql);
			$sql = "INSERT INTO ".$revs_table_name." (`".implode("`, `", $common_columns)."`, `version_created`) (SELECT `".implode("`, `", $common_columns)."`, '".$default_date."' FROM ".$table_name.")";
			$db->query($sql) or die("died on ".$table_name .":".$sql);
		}
	}
	
	echo "-- update storage_masters and alqiuto_masters :  \n";
	
	$sql = "UPDATE storage_masters SET created = '".$default_date."', created_by = ".$user_id.", modified = '".$default_date."', modified_by = ".$user_id." WHERE deleted = 0";
	$db->query($sql) or die("died on :".$sql);
	$sql = "UPDATE storage_masters SET created = deleted_date, created_by = ".$user_id.", modified = deleted_date, modified_by = ".$user_id." WHERE deleted = 1";
	$db->query($sql) or die("died on :".$sql);	
	
	$sql = "UPDATE storage_masters_revs SET created = '".$default_date."', created_by = ".$user_id.", modified = '".$default_date."', modified_by = ".$user_id.", version_created = '".$default_aliquot_v2."' WHERE deleted = 0";
	$db->query($sql) or die("died on :".$sql);
	$sql = "UPDATE storage_masters_revs SET created = deleted_date, created_by = ".$user_id.", modified = deleted_date, modified_by = ".$user_id.", version_created = deleted_date WHERE deleted = 1";
	$db->query($sql) or die("died on :".$sql);		
	
	
	$sql = "UPDATE aliquot_masters SET created = '".$default_aliquot_v2."', created_by = ".$user_id.", modified = '".$default_aliquot_v2."', modified_by = ".$user_id." WHERE deleted = 0";
	$db->query($sql) or die("died on :".$sql);
	$sql = "UPDATE aliquot_masters SET created = deleted_date, created_by = ".$user_id.", modified = deleted_date, modified_by = ".$user_id." WHERE deleted = 1";
	$db->query($sql) or die("died on :".$sql);	
	
	$sql = "UPDATE aliquot_masters_revs SET created = '".$default_aliquot_v2."', created_by = ".$user_id.", modified = '".$default_aliquot_v2."', modified_by = ".$user_id.", version_created = '".$default_aliquot_v2."' WHERE deleted = 0";
	$db->query($sql) or die("died on :".$sql);
	$sql = "UPDATE aliquot_masters_revs SET created = deleted_date, created_by = ".$user_id.", modified = deleted_date, modified_by = ".$user_id.", version_created = deleted_date WHERE deleted = 1";
	$db->query($sql) or die("died on :".$sql);			
	
	$sql= "SELECT id,count(*) AS count FROM `aliquot_masters_revs` group by (id) ORDER BY count(*) DESC";
	$result = $db->query($sql) or die($db->error .':'. $sql);
	
	while ($row = $result->fetch_assoc()) {
		if($row['count'] < 2) {
			break;
		}
		$sql = "SELECT version_id FROM aliquot_masters_revs WHERE id = ".$row['id']." ORDER BY version_id ASC LIMIT 0,1";
		$result_tmp = $db->query($sql) or die($db->error .':'. $sql);
		$row_tmp = $result_tmp->fetch_assoc();
		$result_tmp->free();
		$sql = "UPDATE `aliquot_masters_revs` SET created = '".$default_aliquot_v1."', modified = '".$default_aliquot_v1."', version_created = '".$default_aliquot_v1."' WHERE id = ".$row['id']." AND version_id = ".$row_tmp['version_id'];
		$db->query($sql) or die("died on ".aliquot_masters_revs .":".$sql);		
	}
	$result->free();	
	

}

function getFields($table_name){
	global $db;
	$fields = array();
	$result = $db->query("DESC ".$table_name) or die("desc ".$table_name." failed");
	while($row = $result->fetch_assoc()){
		$fields[] = $row['Field'];
	}
	$result->free();
	return $fields;	
}