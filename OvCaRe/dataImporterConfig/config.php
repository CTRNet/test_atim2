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
//	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/data/FullDataDump_20120123.xls";
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/data/ShortDataDump_20120123.xls";

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
	static $current_patient_session_data = array();
	static $record_ids_from_voa = array();
	
	static $sample_code_counter = 0;	
	
	static $tissue_source_and_laterality = array();
		
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
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/surgery.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/experimental_results.php'; 

Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/surgical_collections.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/pre_surgical_collections.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/OvCaRe/dataImporterConfig/tablesMapping/post_surgical_collections.php'; 

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

	// POPULATE PARTICIPANT CALCULATED FIELDS
	
	$query = "UPDATE participants SET ovcare_last_followup_date_accuracy = 'c' WHERE ovcare_last_followup_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE participants_revs SET ovcare_last_followup_date_accuracy = 'c' WHERE ovcare_last_followup_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE diagnosis_masters SET dx_date_accuracy = 'c' WHERE dx_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE diagnosis_masters_revs SET dx_date_accuracy = 'c' WHERE dx_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
	$query = "UPDATE treatment_masters SET start_date_accuracy = 'c' WHERE start_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE treatment_masters_revs SET start_date_accuracy = 'c' WHERE start_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "	SELECT 
		part.participant_identifier AS voa_nbr,
		
		part.id AS participant_id,
		diag.id AS diag_id, 
		surg.id AS surgery_id,
		
		part.date_of_birth,
		part.ovcare_last_followup_date,
		
		surg.start_date AS surgery_date,
		rec.dx_date AS recurence_date
		
		FROM participants AS part 
		LEFT JOIN diagnosis_masters AS diag ON part.id = diag.participant_id AND diag.diagnosis_control_id IN ('20','22')
		LEFT JOIN diagnosis_masters AS rec ON diag.id = rec.parent_id AND rec.diagnosis_control_id= '19'
		LEFT JOIN treatment_masters AS surg ON diag.id = surg.diagnosis_master_id AND surg.treatment_control_id = '7';";
	
	$results = mysqli_query($connection, $query) or die("calculate fields [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$participant_id = null;
	while($row = $results->fetch_assoc()){
		if($participant_id == $row['participant_id']) die('ERR 998763.1');
		if(empty($row['diag_id'])) die('ERR 998763.2');
		
		$voa_nbr = $row['voa_nbr'];
		
		$participant_id = $row['participant_id'];
		$diag_id = $row['diag_id'];
		$surgery_id = $row['surgery_id'];
		
		$date_of_birth = $row['date_of_birth'];
		$ovcare_last_followup_date = $row['ovcare_last_followup_date'];
		$surgery_date = $row['surgery_date'];
		$recurence_date = $row['recurence_date'];
		
		// 1- Age at surgery
		
		$age_in_years = null;		
		if(!empty($surgery_date) && !empty($date_of_birth)) {
			$birthDateObj = new DateTime($date_of_birth);
			$surgDateObj = new DateTime($surgery_date);
			$interval = $birthDateObj->diff($surgDateObj);
			$age_in_years = $interval->format('%r%y');
			if($age_in_years < 0) {
				$age_in_years = null;
				Config::$summary_msg['@@WARNING@@']['Age at surgery'][] = 'Error in the dates definitions, this value can not be generated. [VOA#: '.$voa_nbr.']';
			}
		}
		
		if(!is_null($age_in_years)) {
			$query = "UPDATE txd_surgeries SET ovcare_age_at_surgery = '$age_in_years' WHERE treatment_master_id = '$surgery_id';";
			mysqli_query($connection, $query) or die("Age at surgery [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$query = "UPDATE txd_surgeries_revs SET ovcare_age_at_surgery = '$age_in_years' WHERE treatment_master_id = '$surgery_id';";
			mysqli_query($connection, $query) or die("Age at surgery [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		
		// 2- Survival Time		
		
		$survival_time_months = null;
		if(!empty($ovcare_last_followup_date) && !empty($surgery_date)) {
			$initialSurgeryDateObj = new DateTime($surgery_date);
			$lastFollDateObj = new DateTime($ovcare_last_followup_date);
			$interval = $initialSurgeryDateObj->diff($lastFollDateObj);
			$survival_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');				
			if($survival_time_months < 0) {
				$survival_time_months = null;
				Config::$summary_msg['@@WARNING@@']['Survival Time'][] = 'Error in the dates definitions, this value can not be generated. [VOA#: '.$voa_nbr.']';
			}
		}

		if(!is_null($survival_time_months)) {
			$query = "UPDATE diagnosis_masters SET survival_time_months = '$survival_time_months' WHERE id = '$diag_id';";
			mysqli_query($connection, $query) or die("Age at surgery [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$query = "UPDATE diagnosis_masters_revs SET survival_time_months = '$survival_time_months' WHERE id = '$diag_id';";
			mysqli_query($connection, $query) or die("Age at surgery [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}		
		
		// 3- Progression Free Time
		
		$new_progression_free_time_months = null;
		if(!empty($surgery_date) && !empty($recurence_date)) {
			$initialSurgeryDateObj = new DateTime($surgery_date);
			$initialRecurrenceDateObj = new DateTime($recurence_date);
			$interval = $initialSurgeryDateObj->diff($initialRecurrenceDateObj);
			$new_progression_free_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');				
			if($new_progression_free_time_months < 0) {
				$new_progression_free_time_months = '';
				Config::$summary_msg['@@WARNING@@']['Progression Free Time'][] = 'Error in the dates definitions, this value can not be generated. [VOA#: '.$voa_nbr.']';
			}
		} else {
			$new_progression_free_time_months = $survival_time_months;
		}

		$data_to_insert = array();
		if(!is_null($new_progression_free_time_months))$data_to_insert['progression_free_time_months'] = $new_progression_free_time_months;
		if(!is_null($surgery_date))$data_to_insert['initial_surgery_date'] = $surgery_date;
		if(!is_null($recurence_date))$data_to_insert['initial_recurrence_date'] = $recurence_date;
		
		if(!empty($data_to_insert)) {
			$set_string = '';
			$separator = '';
			foreach($data_to_insert as $field => $field_value) {
				$set_string .= $separator.$field." = '".$field_value."'";
				$separator = ', ';
			}
			$query = "UPDATE ovcare_dxd_ovaries SET $set_string WHERE diagnosis_master_id = '$diag_id';";
			mysqli_query($connection, $query) or die("Progression Free Time [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$query = "UPDATE ovcare_dxd_ovaries_revs SET $set_string WHERE diagnosis_master_id = '$diag_id';";
			mysqli_query($connection, $query) or die("Progression Free Time [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
		}
	}
	
	$query = "UPDATE ovcare_dxd_ovaries SET initial_surgery_date_accuracy = 'c' WHERE initial_surgery_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE ovcare_dxd_ovaries_revs SET initial_surgery_date_accuracy = 'c' WHERE initial_surgery_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE ovcare_dxd_ovaries SET initial_recurrence_date_accuracy = 'c' WHERE initial_recurrence_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE ovcare_dxd_ovaries_revs SET initial_recurrence_date_accuracy = 'c' WHERE initial_recurrence_date NOT LIKE '';";
	mysqli_query($connection, $query) or die("Accuracy update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	// INVENTORY COMPLETION
		
	$query = "UPDATE sample_masters SET sample_code=id;";
	mysqli_query($connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE sample_masters_revs SET sample_code=id;";
	mysqli_query($connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
	
	// WARNING DISPLAY
	
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
	
	echo "<br><b> ** VALIDATE FOLLOWING TISSUE DEFINITION ** </b>:<br><br>";
	
	foreach(Config::$tissue_source_and_laterality as $key => $new_def) {
		echo "$key => type = ".$new_def['sample_type']." | source = ".$new_def['source']." (".$new_def['source_precision'].") | laterality = '".$new_def['laterality']."'<br>";
	}
	
	echo "<br>";
		
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
	die('sadsaasdsadadsdsa');
	global $connection;
	
	if(Config::$insert_revs){
		$revs_tables = array(	
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
