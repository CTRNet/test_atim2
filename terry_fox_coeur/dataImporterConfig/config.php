<?php
class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	static $db_port 		= "3306";//"8889";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "tfri";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/tp.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/DEMO.xls";
	
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/CHUM-COEUR-clinical data-v0.1.15.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/CHUS-COEUR v1-15.xls";
	//static $xls_file_path = "/Documents and Settings/u703617/Desktop/tfri_coeur/McGill-COEUR- v1-15.xls";
	//static $xls_file_path	= "/Documents and Settings/u703617/Desktop/tfri_coeur/TFRI-COEUR-CBCF-1.15.xls";//file to read
	//static $xls_file_path	= "/Documents and Settings/u703617/Desktop/tfri_coeur/TFRI-COEUR-CHUQ-clinical data v4-1.15.xls";//file to read
	//static $xls_file_path	= "/Documents and Settings/u703617/Desktop/tfri_coeur/TFRI-COEUR-OVCare v0-1.15.xls";//file to read
	static $xls_file_path	= "/Documents and Settings/u703617/Desktop/tfri_coeur/TTR-COEUR-clinical v1.15.xls";//file to read
	
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/DEMO.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/CHUM-COEUR-clinical data-v0.1.15.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/CHUS-COEUR v0.1-15.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TTR-COEUR-clinical data-v0.1.15.xls";
// 	static $xls_file_path = "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/McGill-COEUR- v0-1.15.xls";
	//header row =1 -> static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/OHRI-COEUR.xls";//file to read
// 	static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-CBCF-1.15.xls";//file to read
// 	static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-OVCare v0-1.15.xls";//file to read
//	static $xls_file_path	= "/Users/francois-michellheureux/Documents/CTRNet/Terry Fox/COEUR/TFRI-COEUR-CHUQ-clinical data v4-1.15.xls";//file to read

	static $xls_header_rows = 2;

	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= false;//wheter to insert generated queries data in revs as well
	
	static $addon_function_start= null;//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
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
			die("Defining model ref name [".$ref_name."] more than once\n");
		}
		Config::$models[$ref_name] = $m;
	}

	static $banks = array(
		'CHUM-COEUR' => array('id' => 1, 'misc_identifier_control_id' => 1),
		'CHUS-COEUR' => array('id' => 2, 'misc_identifier_control_id' => 2),
		'TTR-COEUR' => array('id' => 3, 'misc_identifier_control_id' => 3),
		'McGill-COEUR' => array('id' => 4, 'misc_identifier_control_id' => 4),
		'OHRI-COEUR' => array('id' => 5, 'misc_identifier_control_id' => 5),
		'CBCF-COEUR' => array('id' => 6, 'misc_identifier_control_id' => 6),
		'OVCare' => array('id' => 7, 'misc_identifier_control_id' => 7),
		'CHUQ-COEUR' => array('id' => 8, 'misc_identifier_control_id' => 8));
		
	static $eoc_file_event_types	= array('ca125', 'ct scan', 'biopsy', 'surgery(other)', 'surgery(ovarectomy)', 'chimiotherapy', 'radiotherapy');
	static $opc_file_event_types	= array('biopsy', 'surgery', 'chimiotherapy', 'radiology', 'radiotherapy', 'hormonal therapy');
	static $drugs	= array(
		'cisplatinum',
		'carboplatinum',
		'oxaliplatinum',
		'paclitaxel',
		'topotecan',
		'ectoposide',
		'tamoxifen',
		'doxetaxel',
		'doxorubicin',
		'other',
		'etoposide',
		'gemcitabine',
		'procytox',
		'vinorelbine');

	static $tissue_source = array('omentum','ovary','peritoneum','');
}

//add you start queries here
Config::$addon_queries_start[] = "DROP TABLE IF EXISTS start_time";
Config::$addon_queries_start[] = "CREATE TABLE start_time (SELECT NOW() AS start_time)";

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
Config::$addon_queries_end[] = "UPDATE aliquot_masters SET barcode=CONCAT('AUTOGEN - ', id) WHERE barcode=''";
//add some value domains names that you want to use in post read/write functions
//Config::$value_domains[] = "...";

//Config::$value_domains[] = new ValueDomain("qc_tf_eoc_event_drug", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
//Config::$value_domains[] = new ValueDomain("qc_tf_surgery_type", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
//Config::$value_domains[] = new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

Config::$value_domains['qc_tf_ct_scan_precision']= new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['tissue_laterality']= new ValueDomain("tissue_laterality", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['qc_tf_flash_frozen_volume_unit']= new ValueDomain("qc_tf_flash_frozen_volume_unit", ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "participants";
Config::$parent_models[] = "collections";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/participants.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_eocs.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_no_site.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site1.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site2.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_progression_site_ca125.php';
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_primary_cancers.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_dxd_other_progression.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_eocs.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_tx_eocs.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_ed_other.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/terry_fox_coeur/dataImporterConfig/tablesMapping/qc_tf_tx_other.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM//terry_fox_coeur/dataImporterConfig/tablesMapping/collections.php'; 

function mainDxCondition(Model $m){
	//used as pre insert, not a real test
	global $primary_number;
	$m->values['primary_number'] = $primary_number ++;
	
	$m->custom_data['last_participant_id'] = $m->parent_model->last_id;
	return true;
}

function addonFunctionEnd(){
	$query  ="SELECT participant_id, COUNT(*) AS c FROM diagnosis_masters WHERE created >= (SELECT start_time FROM start_time) GROUP BY participant_id HAVING c > 1";
	$result = mysqli_query(Config::$db_connection, $query) or die("reading in addonFunctionEnd failed");
	$ids = array();
	while($row = $result->fetch_assoc()){
		$ids[] = $row['participant_id'];
	}
	mysqli_free_result($result);
	
	if(!empty($ids)){
		echo "MESSAGE: The tx and events for participants with ids (".implode(", ", $ids).") couldn't be linked to a dx because they have more than one.\n";
	}
	
	$ids[] = 0;
	$query = "UPDATE event_masters "
		."LEFT JOIN diagnosis_masters ON event_masters.participant_id=diagnosis_masters.participant_id "
		."SET event_masters.diagnosis_master_id=diagnosis_masters.id "
		."WHERE event_masters.created >= (SELECT start_time FROM start_time) AND event_masters.participant_id NOT IN(".implode(", ", $ids).")";
	mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed");
	
	if(Config::$insert_revs){
		$query = "UPDATE event_masters_revs INNER JOIN event_masters ON event_masters.id = event_masters_revs.id SET event_masters_revs.diagnosis_master_id = event_masters.diagnosis_master_id";
		mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed (revs table)");
	}	

	$query = "UPDATE tx_masters "
		."LEFT JOIN diagnosis_masters ON tx_masters.participant_id=diagnosis_masters.participant_id "
		."SET tx_masters.diagnosis_master_id=diagnosis_masters.id "
		."WHERE tx_masters.created >= (SELECT start_time FROM start_time) AND tx_masters.participant_id NOT IN(".implode(", ", $ids).")";
	mysqli_query(Config::$db_connection, $query) or die("update 2 in addonFunctionEnd failed");

	if(Config::$insert_revs){
		$query = "UPDATE tx_masters_revs INNER JOIN tx_masters ON tx_masters.id = tx_masters_revs.id SET tx_masters_revs.diagnosis_master_id = tx_masters.diagnosis_master_id";
		mysqli_query(Config::$db_connection, $query) or die("update 2 in addonFunctionEnd failed (revs table)");
	}	
	
	"UPDATE xxx SET = null WHERE xxxx LIKE '0000-00-00%'";
	
	$date_times_to_check = array(
		'collections.collection_datetime',
		'diagnosis_masters.dx_date',
		'event_masters.event_date',
		'participants.date_of_birth',
		'participants.date_of_death',
		'participants.qc_tf_suspected_date_of_death',
		'participants.qc_tf_last_contact',
		'tx_masters.start_date',
		'tx_masters.finish_date');

	foreach($date_times_to_check as $table_field) {
		$names = explode(".", $table_field);
		
		$query = "UPDATE ".$names[0]." SET ".$names[1]." = null WHERE ".$names[1]." LIKE '0000-00-00%'";
		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
		
		if(Config::$insert_revs){
			$query = "UPDATE ".$names[0]."_revs SET ".$names[1]." = null WHERE ".$names[1]." LIKE '0000-00-00%'";
			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");			
		}
	}
	
	echo "----------------------------------------------------\n";
	echo " !!!!!!!!!!!! translation to do\n";
	echo " !!!!!!!!!!!! allow search on diagnosis detail into databrowser to do\n";	
	echo " !!!!!!!!!!!! Fichier CBCF manque les Flash Frozen Tissues  Volume Unit\n";	
	echo " !!!!!!!!!!!! Faut il ajouter drug cyclophosphamide\n";	
	echo " !!!!!!!!!!!! Date EOC diag pour ovcare\n";	
	echo " !!!!!!!!!!!! tumor site Female Genital-Peritoneal Pelvix Abdomen pour ovcare\n";	
	echo " !!!!!!!!!!!! Fichier ovcare Flash Frozen Tissues  Volume Unit == tube a traiter\n";	
	echo " !!!!!!!!!!!! tumor site Female Genital-Peritoneal/omental pour ttr\n";	
	echo " !!!!!!!!!!!! Fichier ttr manque les Flash Frozen Tissues  Volume Unit\n";	
	echo " !!!!!!!!!!!! Fichier ttr manque les Flash Frozen Tissues  Volume Unit\n";	
	echo " !!!!!!!!!!!! tissue type other metastasis pour ovcare\n";	
	echo " !!!!!!!!!!!! tissue type vide autorisé?\n";	
	
	
	
	
}