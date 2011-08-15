<?php

class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "chuq";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/scripts/v2.3.0/data/chuq_all_data.xls";

	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= false;//wheter to insert generated queries data in revs as well

	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	
	//--------------------------------------

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
//Config::$addon_queries_end[] = "..."

//add some value domains names that you want to use in post read/write functions
//Config::$value_domains['health_status']= new ValueDomain("health_status", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "Participant";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/participants.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/dos_identifiers.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/patho_identifiers.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/mdeie_identifiers.php';
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/consents.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/diagnoses.php'; 

function addonFunctionStart(){}
function addonFunctionEnd(){}

?>
