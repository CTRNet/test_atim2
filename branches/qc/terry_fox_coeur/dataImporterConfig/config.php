<?php
class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	static $db_port 		= "8889";
	static $db_user 		= "root";
	static $db_pwd			= "root";
	static $db_schema		= "atim_tf_coeur";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/DEMO.xls";
	//static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/CHUM-COEUR-clinical data-v0.1.15.xls";
	//static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/CHUS-COEUR v0.1-15.xls";
	//static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TTR-COEUR-clinical data-v0.1.15.xls";
	//static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/McGill-COEUR- v0-1.15.xls";
	//header row =1 -> static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/OHRI-COEUR.xls";//file to read
	//static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-CBCF-1.15.xls";//file to read
	//static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-OVCare v0-1.15.xls";//file to read
	static $xls_header_rows = 2;

	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= false;//wheter to insert generated queries data in revs as well
	//--------------------------------------
	
	
	//this shouldn't be edited here
	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
}

//add you start queries here
//Config::$addon_queries_start[] = "..."

//add your end queries here
Config::$addon_queries_end[] = "INSERT INTO clinical_collection_links (participant_id, collection_id, created, created_by, modified, modified_by) 
	(SELECT p.mysql_id, c.mysql_id, 1, NOW(), 1, NOW() 
	FROM id_linking AS p 
	INNER JOIN id_linking AS c ON c.csv_reference='collections' AND p.csv_id=c.csv_id WHERE p.csv_reference='participants')";
Config::$addon_queries_end[] = "UPDATE collections AS c 
	INNER JOIN clinical_collection_links AS ccl ON c.id=ccl.collection_id
	SET c.acquisition_label=CONCAT(ccl.participant_id, '-', c.id)
	WHERE c.id IN(SELECT mysql_id FROM id_linking AS l WHERE l.csv_reference='collections')";
Config::$addon_queries_end[] = "TRUNCATE id_linking";
Config::$addon_queries_end[] = "UPDATE misc_identifiers AS i
INNER JOIN misc_identifier_controls AS c ON i.misc_identifier_control_id=c.id
SET i.identifier_name=c.misc_identifier_name, i.identifier_abrv=c.misc_identifier_name_abbrev";
Config::$addon_queries_end[] = "UPDATE participants SET vital_status='deceased' WHERE vital_status='dead'";
//add some value domains names that you want to use in post read/write functions
//Config::$value_domains[] = "...";
Config::$value_domains[] = "";

//add the parent models here
Config::$parent_models[] = "participants";
Config::$parent_models[] = "collections";

//add your configs
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/participants.php'; 
/*Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_eocs.php'; 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_no_site.php'; 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site1.php'; 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site2.php'; 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site_ca125.php';*/
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_primary_cancers.php'; 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_progression.php'; 
/*Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_eocs.php'; 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_other_primary_cancer.php';*/ 
Config::$config_files[] = '../atim_tf_coeur/dataImporterConfig/tablesMapping/collections.php'; 


function mainDxCondition(Model $m){
	//used as pre insert, not a real test
	$connection = Config::$db_connection;
	$query = "SELECT (MAX(primary_number)) FROM diagnosis_masters";
	$result = mysqli_query($connection, $query) or die("dxdEocsPostRead failed on line ".__LINE__);
	$row = mysqli_fetch_array($result, MYSQL_NUM);
	$last_primary_number = is_numeric($row[0]) ? $row[0] : 0;
	mysqli_free_result($result);
	$m->values['primary_number'] = $last_primary_number + 1;
	
	$m->custom_data['last_participant_id'] = $m->parent_model->last_id;
	return true;
}