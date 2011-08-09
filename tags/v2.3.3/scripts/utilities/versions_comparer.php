<?php 
/**
 * @author FM L'Heureux
 * @date 2010-05-26
 * @description: Compares the diff of diff between(x -> x+1) and (x -> x custom) to find potential 
 * threats in upgrading a customized version 
 */

Vc::launch();

class Vc{
	public static $database_schemaX = "atim_21";
	public static $database_schemaX1 = "atim_new";
	public static $database_schemaXc = "atim_nd";
	
	public static $server = "localhost:8889";
	public static $user = "root";
	public static $password = "root";
	
	public static function launch(){
		$dbX = Vc::getConnection(Vc::$database_schemaX);
		$dbX1 = Vc::getConnection(Vc::$database_schemaX1);
		$dbXc = Vc::getConnection(Vc::$database_schemaXc);
		$query = "SELECT s.alias AS s_alias, sfi.plugin AS sfi_plugin, sfi.model AS sfi_model, sfi.tablename AS sfi_tablename, "
			."sfi.field AS sfi_field, sfi.language_label AS sfi_language_label, sfi.language_tag AS sfi_language_tag, "
			."sfi.type AS sfi_type, sfi.setting AS sfi_setting, sfi.default AS sfi_default, "
			."sfi.structure_value_domain AS sfi_structure_value_domain, sfi.language_help AS sfi_language_help, "
			."sfi.validation_control AS sfi_validation_control, sfi.value_domain_control AS sfi_value_domain_control, "
			."sfi.field_control AS sfi_field_control, sfo.display_column AS sfo_display_column, "
			."sfo.display_order AS sfo_display_order, sfo.language_heading AS sfo_language_heading, " 
			."sfo.flag_override_label AS sfo_flag_override_label, sfo.language_label AS sfo_language_label, "
			."sfo.flag_override_tag AS sfo_flag_override_tag, sfo.language_tag AS sfo_language_tag, "
			."sfo.flag_override_help AS sfo_override_help, sfo.language_help AS sfo_language_help, "
			."sfo.flag_override_type AS sfo_flag_override_type, sfo.type AS sfo_type, "
			."sfo.flag_override_setting AS sfo_flag_override_setting, sfo.setting AS sfo_setting, " 
			."sfo.flag_override_default AS sfo_flag_override_default, sfo.default AS sfo_default, "
			."sfo.flag_add AS sfo_flag_add, sfo.flag_add_readonly AS sfo_flag_add_readonly, "
			."sfo.flag_edit AS sfo_flag_edit, sfo.flag_edit_readonly AS sfo_flag_edit_readonly, "
			."sfo.flag_search AS sfo_flag_search, sfo.flag_search_readonly AS sfo_flag_search_readonly, "
			."sfo.flag_datagrid AS sfo_flag_datagrid, sfo.flag_datagrid_readonly AS sfo_flag_datagrid_readonly, "
			."sfo.flag_index AS sfo_flag_index, sfo.flag_detail AS sfo_flag_detail, svd.domain_name AS svd_domain_name "
			."FROM structures AS s "
			."INNER JOIN structure_formats AS sfo ON s.id=sfo.structure_id "
			."INNER JOIN structure_fields AS sfi ON sfo.structure_field_id=sfi.id "
			."LEFT JOIN structure_value_domains AS svd ON sfi.structure_value_domain=svd.id "
			."ORDER BY s_alias, sfi_model, sfi_tablename, sfi_field ";

		$resultX = $dbX->query($query) or die("query X failed");
		$resultX1 = $dbX1->query($query) or die("query X1 failed");
		$resultXc = $dbXc->query($query) or die("query Xc failed");
		$rowX1 = $resultX1->fetch_assoc();
		$rowXc = $resultXc->fetch_assoc();
		$keyX1 = Vc::getKey($rowX1);
		$keyXc = Vc::getKey($rowXc);
		
		$x1Diff = array();
		$xcDiff = array();
		while($rowX = $resultX->fetch_assoc()){
			//compare with X1
			$keyX = Vc::getKey($rowX);
			Vc::compare($resultX1, $rowX, $rowX1, $keyX, $keyX1, $x1Diff);
			Vc::compare($resultXc, $rowX, $rowXc, $keyX, $keyXc, $xcDiff);
		}
	}
	
	public static function compare(&$resultTo ,$rowFrom, &$rowTo, $keyFrom, &$keyTo, &$diffArray){
		if($rowTo != NULL){
			while(strcmp($keyFrom, $keyTo) > 0){
				//data doesn't exist in X, print it
				$rowTo['difference type'] = "+";
				$diffArray[$keyTo] = $rowTo;
				$rowTo = $resultTo->fetch_assoc();
				$keyTo = Vc::getKey($rowTo);
			} 
			if($keyFrom == $keyTo){
				//same key, compare fields and all
				$diff = Vc::getDiffFields($rowFrom, $rowTo);
				if(!empty($diff)){
					$diff['difference_type'] = "C";
					$diffArray[$keyTo] = $diff;
				}
				$rowTo = $resultTo->fetch_assoc();
				$keyTo = Vc::getKey($rowTo);
			}else{
				//data doesn't exist in X1, print
				$rowFrom['difference type'] = "-";
				$diffArray[$keyFrom] = $rowFrom;
			}
		}
	}
	
	public static function getConnection($schema){
		$mysqli = mysqli_init();
		if (!$mysqli){
		    die('mysqli_init failed');
		}
		if (!$mysqli->real_connect(Vc::$server, Vc::$user, Vc::$password, $schema)) {
		    die('Connect Error (' . mysqli_connect_errno() . ') [' . mysqli_connect_error()."]");
		}
		return $mysqli;
	}
	
	public static function getKey($row){
		return Vc::pad($row['s_alias']).Vc::pad($row['sfi_model']).Vc::pad($row['sfi_tablename']).Vc::pad($row['sfi_field']);
	}
	
	public static function pad($string){
		$empty = "                                        ";
		if(strlen($string) > 40){
			die("pad got a too long string [".$string."]");
		}
		return $string.(strlen($string) > 0 ? substr($empty, 0, -1 * strlen($string)) : $empty);
	}
	
	/**
	 * Compares the values of 2 arrays with the same keys and returns the keys where the values were not the same
	 * @param $arr1
	 * @param $arr2
	 */
	public static function getDiffFields($arr1, $arr2){
		$result = array();
		foreach($arr1 as $key => $value){
			if($value != $arr2[$key]){
				$result[] = $key;
			}
		}
		return $result;
	}
}