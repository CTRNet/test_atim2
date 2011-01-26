<?php
$database['ip'] = "127.0.0.1";
$database['port'] = "8889";
$database['user'] = "root";
$database['pwd'] = "root";
$database['schema'] = "atim_terry_fox";
$database['charset'] = "utf8";

$config['printQueries'] = true;
$config['insertRevs'] = false;
$config['input type'] = "xls";
//$config['xls input file'] = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/CHUM-COEUR-clinical data-v0.1.13.xls";
//$config['xls input file'] = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/CHUS-COEUR v0-1.13.xls";
$config['xls input file'] = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/TTR-COEUR-clinical data v1.13.xls";
$config['xls header rows'] = 2;
date_default_timezone_set("America/Montreal");

$addonQueries['end'][] = "INSERT INTO clinical_collection_links (participant_id, collection_id, created, created_by, modified, modified_by) 
(SELECT p.mysql_id, c.mysql_id, 1, NOW(), 1, NOW() 
FROM id_linking AS p 
INNER JOIN id_linking AS c ON c.csv_reference='collections' AND p.csv_id=c.csv_id WHERE p.csv_reference='participants')";
$addonQueries['end'][] = "UPDATE collections AS c 
INNER JOIN clinical_collection_links AS ccl ON c.id=ccl.collection_id
SET c.acquisition_label=CONCAT(ccl.participant_id, '-', c.id)
WHERE c.id IN(SELECT mysql_id FROM id_linking AS l WHERE l.csv_reference='collections')";  
$addonQueries['end'][] = "TRUNCATE id_linking";
$addonQueries['end'][] = "UPDATE misc_identifiers AS i
INNER JOIN misc_identifier_controls AS c ON i.misc_identifier_control_id=c.id
SET i.identifier_name=c.misc_identifier_name, i.identifier_abrv=c.misc_identifier_name_abbrev";



global $created;
$created_id = 1;

class MyTime{
	public static $months = array(
		"january"	=> "01",
		"janvier"	=> "01",
		"jan"		=> "01",
		"february"	=> "02",
		"février"	=> "02",
		"fevrier"	=> "02",
		"fev"		=> "02",
		"fév"		=> "02",
		"march"		=> "03",
		"mars"		=> "03",
		"mar"		=> "03",
		"april"		=> "04",
		"avril"		=> "04",
		"apr"		=> "04",
		"avr"		=> "04",
		"may"		=> "05",
		"mai"		=> "05",
		"june"		=> "06",
		"juin"		=> "06",
		"july"		=> "07",
		"jul"		=> "07",
		"juillet"	=> "07",
		"august"	=> "08",
		"août"		=> "08",
		"aout"		=> "08",
		"aug"		=> "08",
		"aou"		=> "08",
		"september"	=> "09",
		"septembre"	=> "09",
		"sep"		=> "09",
		"sept"		=> "09",
		"october"	=> "10",
		"octobre"	=> "10",
		"oct"		=> "10",
		"november"	=> "11",
		"novembre"	=> "11",
		"nov"		=> "11",
		"december"	=> "12",
		"décembre"	=> "12",
		"decembre"	=> "12",
		"dec"		=> "12",
		"déc"		=> "12"
	);
	
	public static $full_date_pattern 	= '/^([^ \t0-9]+)[ \t]*([0-9]{1,2})(th)?[ \t]*[\,| \t][ \t]*([0-9]{4})$/';
	public static $short_date_pattern	= '/^([^ \t0-9\,]+)[ \t]*[\,]?[ \t]*([0-9]{4})$/';
	
	public static $uncertainty_level = array('c' => 0, 'd' => 1, 'm' => 2, 'y' => 3, 'u' => 4);
}

function postRead(Model $m){
	//rearrange dates
	foreach($m->custom_data['date_fields'] as $date_field => $accuracy_field){
		$m->values[$date_field] = trim($m->values[$date_field]);
		echo "IN DATE: ",$m->values[$date_field]," -> ";
		$matches = array();
		if(preg_match_all(MyTime::$full_date_pattern, $m->values[$date_field], $matches, PREG_OFFSET_CAPTURE) > 0){
			$m->values[$date_field];
			$m->values[$date_field] = $matches[4][0][0]."-".MyTime::$months[strtolower($matches[1][0][0])]."-".sprintf("%02d", $matches[2][0][0]);
			if(strlen($m->values[$date_field]) != 10){
				echo "WARNING ON DATE [",$old_val,"] (A)\n";
			}
		}else if(preg_match_all(MyTime::$short_date_pattern, $m->values[$date_field], $matches, PREG_OFFSET_CAPTURE) > 0){
			$old_val = $m->values[$date_field];
			$m->values[$date_field] = $matches[2][0][0]."-".MyTime::$months[strtolower($matches[1][0][0])]."-01";
			if(strlen($m->values[$date_field]) != 10){
				echo "WARNING ON DATE [",$old_val,"] month[".strtolower($matches[1][0][0])."](B)\n";
			}
			if($accuracy_field != null && MyTime::$uncertainty_level[$m->values[$accuracy_field]] < MyTime::$uncertainty_level['d']){
				$m->values[$accuracy_field] = 'd';
			}
		}else if(is_numeric($m->values[$date_field])){
			if($m->values[$date_field] < 2500){
				//only year
				$m->values[$date_field] = $m->values[$date_field]."-01-01";
				if($accuracy_field != null && MyTime::$uncertainty_level[$m->values[$accuracy_field]] < MyTime::$uncertainty_level['m']){
					$m->values[$accuracy_field] = 'm';
				}
			}else{
				//excel date integer representation
				$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
				$xls_offset = 36526;//2000-01-01
				$m->values[$date_field] = date("Y-m-d", $php_offset + (($m->values[$date_field] - $xls_offset) * 86400));
			}
			
		}else if(strlen($m->values[$date_field]) > 0 && preg_match_all('/[0-9]{4}-[0-9]{2}-[0-9]{2}/', $m->values[$date_field], $matches) === 0 && $accuracy_field != NULL){
			//not a standard date, consider unknown
			$m->values[$accuracy_field] = "u";
			if(strlen($m->values[$date_field]) != 10){
				echo "WARNING ON DATE [",$m->values[$date_field],"] (C)\n";
			}
		}
		echo $m->values[$date_field],"\n";
	}
}

require_once("tablesMapping/participants.php");
require_once("tablesMapping/qc_tf_dxd_eocs.php");
require_once("tablesMapping/qc_tf_dxd_other_primary_cancers.php");
require_once("tablesMapping/qc_tf_ed_eocs.php");
require_once("tablesMapping/qc_tf_ed_other_primary_cancer.php");
require_once("tablesMapping/collections.php");

?>
