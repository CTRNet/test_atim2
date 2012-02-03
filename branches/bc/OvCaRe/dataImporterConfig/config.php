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
	static $db_schema		= "ovcare";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/data/FullDataDump_20120123.xls";

	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well

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
	
	//--------------------------------------

	static $sample_aliquot_controls = array();
	static $dx_who_codes = array();
	static $current_voa_nbr = null;	
	static $participant_ids_from_voa = array();
	static $participant_additional_comments_from_voa = array();
		
	static $summary_msg = array(
		'@@ERROR@@' => array(),  
		'@@WARNING@@' => array(),  
		'@@MESSAGE@@' => array());
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
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/participants.php'; 

Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/medical_record_identifiers.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/personal_health_identifiers.php'; 

Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/consents.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/diagnoses.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/recurrences.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/metastasis.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/chemotherapy.php'; 

function addonFunctionStart(){
	
	setStaticDataForCollection();

	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS : OVCARE<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	flush();

}

function addonFunctionEnd(){
	global $connection;

	// EMPTY DATE CLEAN UP
	
	$query = "UPDATE participants SET date_of_birth = null WHERE date_of_birth LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE participants_revs SET date_of_birth = null WHERE date_of_birth LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE participants SET ovcare_last_followup_date = null WHERE ovcare_last_followup_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE participants_revs SET ovcare_last_followup_date = null WHERE ovcare_last_followup_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE consent_masters SET status_date = null WHERE status_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE consent_masters_revs SET status_date = null WHERE status_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE consent_masters SET consent_signed_date = null WHERE consent_signed_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE consent_masters_revs SET consent_signed_date = null WHERE consent_signed_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE diagnosis_masters SET dx_date = null WHERE dx_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE diagnosis_masters_revs SET dx_date = null WHERE dx_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE treatment_masters SET start_date = null WHERE start_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE treatment_masters_revs SET start_date = null WHERE start_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE treatment_masters SET finish_date = null WHERE finish_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE treatment_masters_revs SET finish_date = null WHERE finish_date LIKE '%0000%';";
	mysqli_query($connection, $query) or die("date '0000-00-00' clean up [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	// Additional participant comment.
	
	foreach(Config::$participant_additional_comments_from_voa as $voa => $msg) {
		$query = "UPDATE participants SET notes = CONCAT(notes, ' ', '$msg') WHERE participant_identifier = '$voa';";
		mysqli_query($connection, $query) or die("add participant notes [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$query = "UPDATE participants_revs SET notes = CONCAT(notes, ' ', '$msg') WHERE participant_identifier = '$voa';";
		mysqli_query($connection, $query) or die("add participant notes [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}

//	$query = "DELETE FROM misc_identifiers WHERE identifier_value LIKE ''"; 
//	mysqli_query($connection, $query) or die("misc_identifiers clean up failed [".$query."] ".mysqli_error($connection));
//	$query = "DELETE FROM misc_identifiers_revs WHERE identifier_value LIKE ''"; 
//	mysqli_query($connection, $query) or die("misc_identifiers clean up failed [".$query."] ".mysqli_error($connection));
//	
//	$query = "UPDATE aliquot_masters SET barcode= id";
//	mysqli_query($connection, $query) or die("aliquot barcode record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	$query = "UPDATE aliquot_masters_revs SET barcode= id";
//	mysqli_query($connection, $query) or die("aliquot barcode record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	
//	$query = "UPDATE diagnosis_masters SET primary_id = id";
//	mysqli_query($connection, $query) or die("aliquot barcode record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	$query = "UPDATE diagnosis_masters_revs SET primary_id = id";
//	mysqli_query($connection, $query) or die("aliquot barcode record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	echo "<br><FONT COLOR=\"red\" >
	=====================================================================<br>
	addonFunctionEnd: CCL
	<br>=====================================================================
	</FONT><br>";
	
	if(!empty(Config::$summary_msg['@@ERROR@@'])) {
		echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> (".sizeof(Config::$summary_msg['@@ERROR@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@ERROR@@'] as $type => $msgs) {
			echo "<br> --> <FONT COLOR=\"red\" >". $type . "</FONT><br>";
			foreach($msgs as $msg) echo "$msg<br>";
		}
	}	
	
	if(!empty(Config::$summary_msg['@@WARNING@@'])) {
		echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> (".sizeof(Config::$summary_msg['@@WARNING@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@WARNING@@'] as $type => $msgs) {
			echo "<br> --> <FONT COLOR=\"orange\" >". $type . "</FONT><br>";
			foreach($msgs as $msg) echo "$msg<br>";
		}
	}	
	
	if(!empty(Config::$summary_msg['@@MESSAGE@@'])) {
		echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> (".sizeof(Config::$summary_msg['@@MESSAGE@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@MESSAGE@@'] as $type => $msgs) {
			echo "<br> --> <FONT COLOR=\"green\" >". $type . "</FONT><br>";
			foreach($msgs as $msg) echo "$msg<br>";
		}
	}
	
	echo "<br>";
	
//	completeInventoryRevsTable();	
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function setStaticDataForCollection() {
	global $connection;
	
	// ** Set sample aliquot controls **
	
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue','blood', 'ascite', 'peritoneal wash', 'ascite cell', 'ascite supernatant', 'cell culture', 'serum', 'plasma', 'dna', 'rna', 'blood cell')";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 12) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}	
	}
	
	// ** WHO Codes **

	$query = "select id from coding_icd_o_3_morphology;";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$dx_who_codes[$row['id']] = $row['id'];
	}		
	
}

function completeInventoryRevsTable() {
	
	global $connection;
	
	if(Config::$insert_revs){
		$revs_tables = array(
			'clinical_collection_links',	
			'collections',	
	
			'sample_masters',
			'specimen_details',
			'derivative_details',
			'sd_der_ascite_cells',
			'sd_der_ascite_sups',
			'sd_der_blood_cells',
			'sd_der_cell_cultures',
			'sd_der_dnas',
			'sd_der_rnas',
			'sd_spe_ascites',
			'sd_der_serums',
			'sd_der_plasmas',
			'sd_spe_bloods',
			'sd_spe_peritoneal_washes',
			'sd_spe_tissues',
			
			'aliquot_masters',
			'ad_blocks',
			'ad_tubes',
			
			'storage_masters',
			'std_boxs');		
		
		foreach ($revs_tables as $table_name) {
			$query = '';
			switch($table_name) {
				case 'clinical_collection_links':
					$query = "INSERT INTO ".$table_name."_revs (id, collection_id, participant_id, version_created) "
						."SELECT id, collection_id, participant_id, NOW() FROM ".$table_name;
					break;		
					
				case 'collections':	
					$query = "INSERT INTO ".$table_name."_revs (id, acquisition_label, bank_id, collection_notes, collection_property, version_created) "
						."SELECT id, acquisition_label, bank_id, collection_notes, collection_property, NOW() FROM ".$table_name;
					break;
					
				case 'sample_masters':
					$query = "INSERT INTO ".$table_name."_revs (id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, version_created) "
						."SELECT id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, NOW() FROM ".$table_name;
					break;					
					
					
				case 'specimen_details':
				case 'derivative_details':

				case 'sd_der_ascite_cells':
				case 'sd_der_ascite_sups':
				case 'sd_der_blood_cells':
				case 'sd_der_cell_cultures':
				case 'sd_der_dnas':
				case 'sd_der_rnas':
				case 'sd_spe_ascites':
				case 'sd_der_serums':
				case 'sd_der_plasmas':
				case 'sd_spe_bloods':
				case 'sd_spe_peritoneal_washes':
				
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, version_created) "
						."SELECT id, sample_master_id, NOW() FROM ".$table_name;
					break;	
				
					
				case 'sd_spe_tissues':
				
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, chuq_tissue_code, tissue_nature, tissue_source, tissue_laterality, version_created) "
						."SELECT id, sample_master_id, chuq_tissue_code, tissue_nature, tissue_source, tissue_laterality, NOW() FROM ".$table_name;
					break;	

				case 'aliquot_masters':		
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, aliquot_control_id, in_stock, collection_id, aliquot_label, storage_master_id, version_created) "
						."SELECT id, sample_master_id, aliquot_control_id, in_stock, collection_id, aliquot_label, storage_master_id, NOW() FROM ".$table_name;
					break;	

				case 'ad_blocks':
					$query = "INSERT INTO ".$table_name."_revs (id, aliquot_master_id, block_type, version_created) "
						."SELECT id, aliquot_master_id, block_type, NOW() FROM ".$table_name;
					break;	
			
				case 'ad_tubes':
					$query = "INSERT INTO ".$table_name."_revs (id, aliquot_master_id, chuq_blood_solution, chuq_blood_cell_stored_into_rlt, version_created) "
						."SELECT id, aliquot_master_id, chuq_blood_solution, chuq_blood_cell_stored_into_rlt, NOW() FROM ".$table_name;
					break;	
			
				case 'storage_masters':
					$query = "INSERT INTO ".$table_name."_revs (id, code, storage_control_id, rght, lft, selection_label, short_label, version_created) "
						."SELECT id, code, storage_control_id, rght, lft, selection_label, short_label, NOW() FROM ".$table_name;
					break;					
				case 'std_boxs':	
					$query = "INSERT INTO ".$table_name."_revs (id, storage_master_id, version_created) "
						."SELECT id, storage_master_id, NOW() FROM ".$table_name;
					break;				
				
				default:
					die("ERR 007 : ".$table_name);	
			}
			mysqli_query($connection, $query) or die("inventroy revs table completion [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
		}	
	}
}

?>
