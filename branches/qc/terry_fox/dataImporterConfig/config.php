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
$config['xls input file'] = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/CHUS-COEUR v0-1.13.xls";//RECONFIGURE colleciton->bank
$config['xls header rows'] = 2;

//-----addon querries------
//querries listed here will be run at the start/end of the process
//$addonQueries['start'][] = "ALTER TABLE sd_der_plasmas auto_increment=1000000";
//$addonQueries['start'][] = "ALTER TABLE sd_spe_bloods auto_increment=1000000";
//clinical_collection_links
//$addonQueries['end'][] = "INSERT INTO clinical_collection_links(`participant_id`, `collection_id`, `diagnosis_id`, `created`, `created_by`, `modified`, `modified_by`) 
//SELECT p.mysql_id, col.mysql_id, dx.mysql_id, NOW(), '1', NOW(), '1' FROM `id_linking` AS p
//LEFT JOIN id_linking AS dx ON dx.csv_id=p.mysql_id AND dx.model='diagnoses'
//LEFT JOIN id_linking AS col ON p.csv_id=col.csv_reference AND col.model='collections'
//WHERE p.model = 'participants'";

//$addonQueries['end'][] = "UPDATE sample_masters AS sm "
//	."INNER JOIN clinical_collection_links AS ccl on sm.collection_id=ccl.collection_id "
//	."INNER JOIN misc_identifiers AS mi ON ccl.participant_id=mi.participant_id AND mi.name='ovary bank no lab' "
//	."SET sample_label=CONCAT('S - ', mi.identifier_value, ' EDTA') "
//	."WHERE sm.collection_id IN(SELECT mysql_id FROM id_linking WHERE model='collections') AND sm.sample_control_id=2"; 
//$addonQueries['end'][] = "UPDATE sample_masters AS sm "
//	."INNER JOIN clinical_collection_links AS ccl on sm.collection_id=ccl.collection_id "
//	."INNER JOIN misc_identifiers AS mi ON ccl.participant_id=mi.participant_id AND mi.name='ovary bank no lab' "
//	."SET sample_label=CONCAT('BLD-C S - ', mi.identifier_value, ' EDTA') "
//	."WHERE sm.collection_id IN(SELECT mysql_id FROM id_linking WHERE model='collections') AND sm.sample_control_id=7";
//$addonQueries['end'][] = "UPDATE sample_masters AS sm "
//	."INNER JOIN clinical_collection_links AS ccl on sm.collection_id=ccl.collection_id "
//	."INNER JOIN misc_identifiers AS mi ON ccl.participant_id=mi.participant_id AND mi.name='ovary bank no lab' "
//	."SET sample_label=CONCAT('PLS S - ', mi.identifier_value, ' EDTA') "
//	."WHERE sm.collection_id IN(SELECT mysql_id FROM id_linking WHERE model='collections') AND sm.sample_control_id=9";
//$addonQueries['end'][] = "DELETE FROM derivative_details WHERE sample_master_id!=id";	
	
//$addonQueries[] = "UPDATE misc_identifiers AS mi INNER JOIN misc_identifier_controls AS mic ON mi.misc_identifier_control_id=mic.id 
//SET mi.identifier_name=mic.misc_identifier_name";
//
//$addonQueries[] = "UPDATE sd_spe_tissues AS t
//INNER JOIN sample_masters AS s ON t.sample_master_id=s.id
//SET qc_lady_tissue_type='NBR' WHERE s.sample_code LIKE '%Tissue-Norm%'";
//
//$addonQueries[] = "UPDATE sd_spe_tissues AS t
//INNER JOIN sample_masters AS s ON t.sample_master_id=s.id
//SET qc_lady_tissue_type='TBR' WHERE s.sample_code LIKE '%Tissue-Tum%'";
//
//$addonQueries[] = "UPDATE sd_spe_tissues AS t
//INNER JOIN sample_masters AS s ON t.sample_master_id=s.id
//SET qc_lady_tissue_type='NBR' WHERE s.sample_code LIKE '%Tissue\.Norm%'";
//
//$addonQueries[] = "UPDATE sd_spe_tissues AS t
//INNER JOIN sample_masters AS s ON t.sample_master_id=s.id
//SET qc_lady_tissue_type='TBR' WHERE s.sample_code LIKE '%Tissue\.Tum%'";
//-------------------------




global $created;
$created_id = 1;

class MyTime{
	public static $months = array(
		"january"	=> "01",
		"janvier"	=> "01",
		"february"	=> "02",
		"février"	=> "02",
		"fevrier"	=> "02",
		"march"		=> "03",
		"mars"		=> "03",
		"april"		=> "04",
		"avril"		=> "04",
		"may"		=> "05",
		"mai"		=> "05",
		"june"		=> "06",
		"juin"		=> "06",
		"july"		=> "07",
		"juillet"	=> "07",
		"august"	=> "08",
		"août"		=> "08",
		"aout"		=> "08",
		"september"	=> "09",
		"septembre"	=> "09",
		"october"	=> "10",
		"octobre"	=> "10",
		"november"	=> "11",
		"novembre"	=> "11",
		"december"	=> "12",
		"décembre"	=> "12",
		"decembre"	=> "12"
	);
	
	public static $full_date_pattern 	= '/([^ \t0-9]+)[ \t]*([0-9]{1,2})[ \t]*\,[ \t]*([0-9]{4})/';
	public static $short_date_pattern	= '/([^ \t0-9]+)[ \t]*\,[ \t]*([0-9]{4})/';
}

function postRead(Model $m){
	//rearrange dates
	foreach($m->custom_data['date_fields'] as $date_field){
		$matches = array();
		if(preg_match_all(MyTime::$full_date_pattern, $m->values[$date_field], $matches, PREG_OFFSET_CAPTURE) > 0){
			$m->values[$date_field] = $matches[3][0][0]."-".MyTime::$months[strtolower($matches[1][0][0])]."-".sprintf("%02d", $matches[2][0][0]);
		}else if(preg_match_all(MyTime::$short_date_pattern, $m->values[$date_field], $matches, PREG_OFFSET_CAPTURE) > 0){
			$m->values[$date_field] = $matches[2][0][0]."-".MyTime::$months[strtolower($matches[1][0][0])]."-01";
		}
	}
}

require_once("tablesMapping/participants.php");
require_once("tablesMapping/qc_tf_dxd_eocs.php");
require_once("tablesMapping/qc_tf_dxd_other_primary_cancers.php");
require_once("tablesMapping/qc_tf_ed_eocs.php");
require_once("tablesMapping/qc_tf_ed_other_primary_cancer.php");
//require_once("tablesMapping/collections.php");

?>