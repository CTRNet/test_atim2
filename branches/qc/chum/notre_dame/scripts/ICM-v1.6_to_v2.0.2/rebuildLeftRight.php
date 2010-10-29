<?php
/**
 * @author FM L'Heureux
 * @date 2010-04-09
 * @description: Rebuilds the lft/rght numbering for a given table
 */

Fmlh::launch();

class Fmlh{
	public static $database_schema = "atim_nd";
	public static $server = "127.0.0.1:8889";
	public static $user = "root";
	public static $password = "root";
	public static $table_name = "storage_masters";
	
	private static $mysqli;//db_conn array
	private static $ps;//prepared statement array
	
	private static $mysqliu_left;//update mysqli
	private static $mysqliu_right;//update mysqli
	private static $update_left;//update ps
	private static $update_right;//update ps

	public static function launch(){
		Fmlh::$mysqli[] = mysqli_init();
		if (!Fmlh::$mysqli[0]) {
		    die('mysqli_init failed');
		}
		if (!Fmlh::$mysqli[0]->real_connect(Fmlh::$server, Fmlh::$user, Fmlh::$password, Fmlh::$database_schema)) {
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
		if (!Fmlh::$mysqliu_left->real_connect(Fmlh::$server, Fmlh::$user, Fmlh::$password, Fmlh::$database_schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') '
		            . mysqli_connect_error());
		}
		Fmlh::$mysqliu_right = mysqli_init();
		if (!Fmlh::$mysqliu_right) {
		    die('mysqli_init failed');
		}
		if (!Fmlh::$mysqliu_right->real_connect(Fmlh::$server, Fmlh::$user, Fmlh::$password, Fmlh::$database_schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') '
		            . mysqli_connect_error());
		}

		Fmlh::$ps[] = Fmlh::$mysqli[0]->prepare("SELECT id FROM ".Fmlh::$table_name." WHERE parent_id IS NULL") or die("p0 failed".Fmlh::$mysqli[0]->error);
		Fmlh::$update_left = Fmlh::$mysqliu_left->prepare("UPDATE ".Fmlh::$table_name." SET lft=? WHERE id=?");
		Fmlh::$update_right = Fmlh::$mysqliu_right->prepare("UPDATE ".Fmlh::$table_name." SET rght=? WHERE id=?"); 
		Fmlh::updateLftRght(NULL, 0, 1);
		
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
	
	private static function updateLftRght($parent_id, $depth, $left){
		if(!isset(Fmlh::$mysqli[$depth])){
			Fmlh::$mysqli[$depth] = mysqli_init();
			if (!Fmlh::$mysqli[$depth]) {
			    die('mysqli_init failed');
			}
			if (!Fmlh::$mysqli[$depth]->real_connect(Fmlh::$server, Fmlh::$user, Fmlh::$password, Fmlh::$database_schema)) {
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
			$left = Fmlh::updateLftRght($id, $depth + 1, ++ $left);
			Fmlh::$update_right->bind_param("ii", $left, $id) or die("binding right failed $depth");
			Fmlh::$update_right->execute() or die("updating right failed $depth");
			++ $left;
		}
		return $left;
	}
}
