<?php
/**
 * All data of tables with *_revs will be inserted in the later.
 * All aliquots with the flag in_stock='no' and storage_master_id NOT NULL 
 * will be updated to remove storage data. The updated version will be
 * inserted into the matching *_revs.
 * @author FM L'Heureux for Nicolas Luc
 */

global $database_schema;
$database_schema = $argv[1];
$user = $argv[2];
$password = $argv[3];
$server = "localhost";

global $db;
$db = @new mysqli($server, $user, $password, $database_schema);

if ($db->connect_errno) {
    die('Connect Error: ' . $db->connect_errno);
}
if(!$db->set_charset("utf8")){
	die("We failed");
}
echo "**************************\n"
	,"*  Revs + storage check  *\n"
	,"**************************\n";
copyDataToRevs();
echo "sleep 5 seconds to leave a gap in version_created\n";
sleep(5);
updateAliquotsStorage();
echo "***********END************\n";


function copyDataToRevs(){
	global $db;
	global $database_schema;
	$revs_tables = array();
	$tables = array();
	$result = $db->query("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='".$database_schema."' AND TABLE_NAME LIKE '%_revs' ORDER BY TABLE_NAME") or die($db->error);
	while ($row = $result->fetch_assoc()) {
		$revs_tables[$row['TABLE_NAME']] = null;
	}
	$result->free();
	
	$result = $db->query("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA='".$database_schema."' AND TABLE_NAME NOT LIKE '%_revs' ORDER BY TABLE_NAME") or die($db->error);
	$tables = array();
	while ($row = $result->fetch_assoc()) {
		$tables[] = $row['TABLE_NAME'];
	}
	$result->free();
	
	foreach($tables as $table_name){
		$revs_table_name = $table_name."_revs";
		if(array_key_exists($revs_table_name, $revs_tables)){
			//echo "Copying ",$table_name,"\n";
			$table_cols = getFields($table_name);
			$revs_table_cols = getFields($revs_table_name);
			$common_columns = array_intersect($table_cols, $revs_table_cols);
			$db->query("INSERT INTO ".$revs_table_name." (`".implode("`, `", $common_columns)."`, `version_created`) (SELECT `".implode("`, `", $common_columns)."`, NOW() FROM ".$table_name.")") or die("died on ".$table_name);
		}
	}
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

function updateAliquotsStorage(){
	global $db;
	
	//prepare master table data
	$aliquot_master_common_columns = array_intersect(getFields("aliquot_masters"), getFields("aliquot_masters_revs"));
	
	//prepare details tables data
	$controls_mapping = array();
	$results = $db->query("SELECT id, detail_tablename FROM aliquot_controls") or die("aliquots0 failed");
	while($row = $results->fetch_assoc()){
		$controls_mapping[$row['id']]['detail_tablename'] = $row['detail_tablename'];
	}
	$results->free();
	
	foreach($controls_mapping as &$content){
		$content['common_columns'] = array_intersect(getFields($content['detail_tablename']), getFields($content['detail_tablename']."_revs"));
	}
	
	//get aliquot_master_id to update
	$result = $db->query("SELECT id, aliquot_control_id FROM aliquot_masters WHERE in_stock='no' AND storage_master_id IS NOT NULL") or die("aliquots1 failed");
	$studied_aliquot_master_ids = array();
	while($row = $result->fetch_assoc()){
		$studied_aliquot_master_ids[$row['id']] = $row['aliquot_control_id'];
	}
	$result->free();
	
	// modified modified_by
	$result = $db->query(" select id from users where first_name = 'Migration'") or die("aliquots133 failed");
	$modified_by = null;
	while($row = $result->fetch_assoc()){
		$modified_by = $row['id'];
	}
	$modified = date('Y-m-d G:i');
	
	
	if(count($studied_aliquot_master_ids) > 0){
		//echo "Updating aliquot: ";
		foreach($studied_aliquot_master_ids as $id => $control_id){
			//echo $id," ";
			if(!isset($controls_mapping[$control_id])) die("aliquots8893 failed");
			$current_control = $controls_mapping[$control_id];

			$db->query("UPDATE aliquot_masters SET storage_master_id=NULL, storage_coord_x=NULL, storage_coord_y=NULL, modified = '".$modified."', modified_by = '".$modified_by."' WHERE id=".$id) or die("aliquots died on id ".$id);
			$db->query("UPDATE ".$current_control['detail_tablename']." SET modified = '".$modified."', modified_by = '".$modified_by."' WHERE aliquot_master_id=".$id) or die("aliquots died on id ".$id);

			$db->query("INSERT INTO aliquot_masters_revs (`".implode("`, `", $aliquot_master_common_columns)."`, `version_created`) (SELECT `".implode("`, `", $aliquot_master_common_columns)."`, '".$modified."' FROM aliquot_masters WHERE id=".$id.")") or die("aliquots died on id ".$id);
			$db->query("INSERT INTO ".$current_control['detail_tablename']."_revs (`".implode("`, `", $current_control['common_columns'])."`, `version_created`) (SELECT `".implode("`, `", $current_control['common_columns'])."`, '".$modified."' FROM ".$current_control['detail_tablename']." WHERE aliquot_master_id=".$id.")") or die("aliquots died on id ".$id);
		}
		//echo "\n";
	}
}