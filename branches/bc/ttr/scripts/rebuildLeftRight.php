<?php
/**
 * @author FM L'Heureux
 * @date 2010-04-09
 * @description: Rebuilds the lft/rght numbering for a given table
 */

//$argv = array('1'=>'atim','2'=>'root','3'=>'');

Fmlh::launch($argv[1], $argv[2], $argv[3]);
Fmlh::launchSelectionLabelUpdate($argv[1], $argv[2], $argv[3]);

class Fmlh{
	public static $server = "localhost";
	public static $table_name = "storage_masters";
	
	private static $mysqli;//db_conn array
	private static $ps;//prepared statement array
	
	private static $mysqliu_left;//update mysqli
	private static $mysqliu_right;//update mysqli
	private static $update_left;//update ps
	private static $update_right;//update ps

	public static function launch($database_schema, $user, $password){
		Fmlh::$mysqli[] = mysqli_init();
		if (!Fmlh::$mysqli[0]) {
		    die('mysqli_init failed');
		}
		if (!Fmlh::$mysqli[0]->real_connect(Fmlh::$server, $user, $password, $database_schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') '
		            . mysqli_connect_error());
		}
		$query = "UPDATE ".Fmlh::$table_name." SET lft=NULL, rght=NULL";
		echo ("Clearing lft and rght\n");
		Fmlh::$mysqli[0]->query($query) or die("q1 failed".Fmlh::$mysqli[0]->error);
		
		
		Fmlh::$mysqliu_left = mysqli_init();
		if (!Fmlh::$mysqliu_left) {
		    die('mysqli_init failed');
		}
		if (!Fmlh::$mysqliu_left->real_connect(Fmlh::$server, $user, $password, $database_schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') '
		            . mysqli_connect_error());
		}
		Fmlh::$mysqliu_right = mysqli_init();
		if (!Fmlh::$mysqliu_right) {
		    die('mysqli_init failed');
		}
		if (!Fmlh::$mysqliu_right->real_connect(Fmlh::$server, $user, $password, $database_schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') '
		            . mysqli_connect_error());
		}

		Fmlh::$ps[] = Fmlh::$mysqli[0]->prepare("SELECT id FROM ".Fmlh::$table_name." WHERE parent_id IS NULL") or die("p0 failed".Fmlh::$mysqli[0]->error);
		Fmlh::$update_left = Fmlh::$mysqliu_left->prepare("UPDATE ".Fmlh::$table_name." SET lft=? WHERE id=?");
		Fmlh::$update_right = Fmlh::$mysqliu_right->prepare("UPDATE ".Fmlh::$table_name." SET rght=? WHERE id=?"); 
		Fmlh::updateLftRght(NULL, 0, 1, $user, $password, $database_schema);
		
		foreach(Fmlh::$ps as $ps){
			$ps->close();
		}
		foreach(Fmlh::$mysqli as $mysqli){
			$mysqli->close();
		}
		Fmlh::$update_left->close();
		Fmlh::$update_right->close();
		Fmlh::$mysqliu_left->close();
		Fmlh::$mysqliu_right->close();
	}
	
	private static function updateLftRght($parent_id, $depth, $left, $user, $password, $database_schema){
		if(!isset(Fmlh::$mysqli[$depth])){
			Fmlh::$mysqli[$depth] = mysqli_init();
			if (!Fmlh::$mysqli[$depth]) {
			    die('mysqli_init failed');
			}
			if (!Fmlh::$mysqli[$depth]->real_connect(Fmlh::$server, $user, $password, $database_schema)) {
			    die('Connect Error (' . mysqli_connect_errno() . ') '
			            . mysqli_connect_error());
			}
			Fmlh::$ps[$depth] = Fmlh::$mysqli[$depth]->prepare("SELECT id FROM ".Fmlh::$table_name." WHERE parent_id=?") or die("p$depth failed");
		}
		
		if($parent_id != NULL){
			Fmlh::$ps[$depth]->bind_param("i", $parent_id);
		}
		
		Fmlh::$ps[$depth]->execute() or die("Exec failed $depth");
		Fmlh::$ps[$depth]->bind_result($id);
		while(Fmlh::$ps[$depth]->fetch()){
			Fmlh::$update_left->bind_param("ii", $left, $id) or die("binding left failed $depth");
			Fmlh::$update_left->execute() or die("updating left failed $depth");
			$left = Fmlh::updateLftRght($id, $depth + 1, ++ $left, $user, $password, $database_schema);
			Fmlh::$update_right->bind_param("ii", $left, $id) or die("binding right failed $depth");
			Fmlh::$update_right->execute() or die("updating right failed $depth");
			++ $left;
		}
		return $left;
	}
	
	//----------------------------------------------------------------------------------------------
	
	public static function launchSelectionLabelUpdate($database_schema, $user, $password){
		echo "Be sure to run following clean up before to migrate data: \n";
		echo "Missing storages : SELECT * FROM `towers` WHERE `storage_id` NOT IN (select id from storages))";
		echo "Missing storages : SELECT * FROM `boxes` WHERE `storage_id` NOT IN (select id from storages)";
		echo "Missing towers : SELECT * FROM `boxes` WHERE `tower_id` NOT IN (select id from towers)";
		
		
		Fmlh::$mysqli = mysqli_init();
		if (!Fmlh::$mysqli) {
		    die('mysqli_init failed');
		}
		if (!Fmlh::$mysqli->real_connect(Fmlh::$server, $user, $password, $database_schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') '
		            . mysqli_connect_error());
		}
		
		// Build short label
		$result = Fmlh::$mysqli->query("SELECT id,storage_type,short_label,selection_label FROM ".Fmlh::$table_name." ") or die("p0 failed".Fmlh::$mysqli[0]->error);
		
		while ($row = $result->fetch_object()) {
			$short_label = null;
			$precision = null;
			$id = $row->id;
			switch($row->storage_type) {
				case 'freezer':
					if(empty($row->short_label)) die('error #41411');
					break;
				case 'tower':
					if(preg_match("/[0-9]*-([0-9]*)(.*)/",$row->selection_label,$regs)) {
						$short_label = $regs[1];
						if(!empty($regs[2])) $precision = $regs[2];
					}
					break;
				case 'box';
					if(preg_match("/[0-9]*-[0-9]*-([0-9]*)(.*)/",$row->selection_label,$regs)) {
						$short_label = $regs[1];
						if(!empty($regs[2])) $precision = $regs[2];
					}		
					break;
				default:
					die('error #41412');
			}
			if(!is_null($short_label)) {
				$sql = "UPDATE ".Fmlh::$table_name." SET short_label = '".$short_label."', label_precision = '".$precision."' WHERE id = " . $id;
				Fmlh::$mysqli->query($sql) or die("error #3131313: ".$sql);
			}
		}	
		
		// Rebuilt selection label
		
		$result = Fmlh::$mysqli->query("SELECT id,short_label FROM ".Fmlh::$table_name." WHERE parent_id IS NULL") or die("p0 failed".Fmlh::$mysqli[0]->error);
		
		while ($row = $result->fetch_object()) {
			$selection_label = $row->short_label;
			$sql = "UPDATE ".Fmlh::$table_name." SET selection_label = '".$selection_label."' WHERE id = " . $row->id;
			Fmlh::$mysqli->query($sql) or die("error #313414143: ".$sql);			
			
			Fmlh::childSelectionLabelUpdate($row->id, $selection_label);
		}		
		
		Fmlh::$mysqli->close();
	}
	
	function childSelectionLabelUpdate($parent_id, $parent_selection_label) {
		$result = Fmlh::$mysqli->query("SELECT id,short_label FROM ".Fmlh::$table_name." WHERE parent_id = " . $parent_id) or die("p0 failed".Fmlh::$mysqli[0]->error);
		
		while ($row = $result->fetch_object()) {
			$selection_label = $parent_selection_label . '-'. $row->short_label;
			$sql = "UPDATE ".Fmlh::$table_name." SET selection_label = '".$selection_label."' WHERE id = " . $row->id;
			Fmlh::$mysqli->query($sql) or die("error #313414143: ".$sql);			
			
			Fmlh::childSelectionLabelUpdate($row->id, $selection_label);
		}	
		
		return;
	}
		
}
