<?php
#drop database atim_tf_prostate; create database atim_tf_prostate; use atim_tf_prostate;
class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "cpcbn";
	
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//Date format
	static $use_windows_xls_offset = false;
	
	//if reading excel file
	
 	//static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/McGill-1a100-Atim.xls';
 	static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/VPC-1a150-Atim.xls';
 	//static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/CHUQ-1a119-Atim2012.xls';
 	
	static $xls_header_rows = 2;

	static $print_queries	= false;//whether to output the dataImporter generated queries
	static $insert_revs		= false;//whether to insert generated queries data in revs as well
	
	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	
	//for display
	static $line_break_tag = '<br>';
	
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
			die("Defining model ref name [".$ref_name."] more than once".Config::$line_break_tag);
		}
		Config::$models[$ref_name] = $m;
	}

//*	static $eoc_file_event_types	= array('ca125', 'ct scan', 'biopsy', 'surgery(other)', 'surgery(ovarectomy)', 'chemotherapy', 'radiotherapy');
//*	static $opc_file_event_types	= array('biopsy', 'surgery', 'chemotherapy', 'radiology', 'radiotherapy', 'hormonal therapy');
	
//*	static $sample_aliquot_controls = array();
//*	static $banks = array();
//*	static $drugs	= array();
//*	static $tissue_source = array();
	
//*		static $identifiers = array();

	// Custom variables
	
	static $summary_msg = array();
	static $banks = array();
	static $drugs = array();
	
	static $dx_controls = array();
	static $event_controls = array();
	static $tx_controls = array();
	
	static $existing_patient_unique_keys = array();
	
	static $create_participant_ids = array();
	
}

//add you start queries here
Config::$addon_queries_start[] = "DROP TABLE IF EXISTS start_time";
Config::$addon_queries_start[] = "CREATE TABLE start_time (SELECT NOW() AS start_time)";

Config::$value_domains['qc_tf_ct_scan_precision']= new ValueDomain("qc_tf_ct_scan_precision", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['tissue_laterality']= new ValueDomain("tissue_laterality", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
Config::$value_domains['qc_tf_tissue_type']= new ValueDomain("qc_tf_tissue_type", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "participants";
//*Config::$parent_models[] = "inventory";

//add your configs
$relative_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/dataImporterConfig/tablesMapping/';
Config::$config_files[] = $relative_path.'participants.php';
Config::$config_files[] = $relative_path.'dx_primary.php';
Config::$config_files[] = $relative_path.'dx_metastasis.php';
Config::$config_files[] = $relative_path.'tx_surgery.php';
Config::$config_files[] = $relative_path.'tx_biopsy.php';
Config::$config_files[] = $relative_path.'dx_recurrence.php';
Config::$config_files[] = $relative_path.'tx_radiotherapy.php';
Config::$config_files[] = $relative_path.'tx_hormonotherapy.php';
Config::$config_files[] = $relative_path.'tx_chemotherapy.php';
Config::$config_files[] = $relative_path.'event_psa.php';
Config::$config_files[] = $relative_path.'dx_other_primary.php';

//*Config::$config_files[] = $relative_path.'inventory.php';
//*

function mainDxCondition(Model $m){
	pr('TODO : mainDxCondition');exit;
	//used as pre insert, not a real test
	global $primary_number;
	$m->values['primary_number'] = $primary_number ++;
	
	$m->custom_data['last_participant_id'] = $m->parent_model->last_id;
	return true;
}

function addonFunctionStart(){
	
	$file_path = Config::$xls_file_path;
	echo "".Config::$line_break_tag."<FONT COLOR=\"green\" >
	=====================================================================".Config::$line_break_tag."
	DATA EXPORT PROCESS : CPCBN TFRI".Config::$line_break_tag."
	source_file = $file_path".Config::$line_break_tag."
	".Config::$line_break_tag."=====================================================================
	</FONT>".Config::$line_break_tag."";	
	
	$query = "SELECT id, name FROM banks";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$banks[$row['name']] = $row['id'];
	}
	
	$query = "SELECT qc_tf_bank_id, qc_tf_bank_participant_identifier FROM participants";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$existing_patient_unique_keys[] = $row['qc_tf_bank_id'].'-'.$row['qc_tf_bank_participant_identifier'];
	}	
	
	$query = "SELECT id, disease_site, event_group, event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$event_controls[$row['event_group']][$row['event_type']][$row['disease_site']] = array('id'=> $row['id'], 'detail_tablename'=> $row['detail_tablename']);
	}		
	
	$query = "SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$dx_controls[$row['category']][$row['controls_type']] = array('id'=> $row['id'], 'detail_tablename'=> $row['detail_tablename']);
	}	
	
	$query = "SELECT id, tx_method, disease_site, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$tx_controls[$row['tx_method']][$row['disease_site']] = array('id'=> $row['id'], 'detail_tablename'=> $row['detail_tablename']);
	}	
	
	$query = "SELECT id, generic_name FROM drugs WHERE type = 'chemotherapy';";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$drugs[strtolower($row['generic_name'])] = $row['id'];
	}
		
	Config::$create_participant_ids = array();
	
	
	
	
	
// 	$query = "SELECT identifier_value, misc_identifier_control_id FROM misc_identifiers";
// 	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
// 	while($row = $results->fetch_assoc()){
// 		checkAndAddIdentifier($row['identifier_value'], $row['misc_identifier_control_id']);
// 	}
	
// 	// SET banks
// 	$query = "SELECT id, name, misc_identifier_control_id FROM banks";
// 	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
// 	while($row = $results->fetch_assoc()){
// 		Config::$banks[$row['name']] = array(
// 			'id' => $row['id'],
// 			'misc_identifier_control_id' => $row['misc_identifier_control_id']);
// 	}	
	
// 	$query = "SELECT generic_name FROM drugs";
// 	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
// 	while($row = $results->fetch_assoc()){
// 		Config::$drugs[] = $row['generic_name'];
// 	}	
	
// 	$query = "select id,sample_type from sample_controls where sample_type in ('tissue','blood', 'ascite', 'serum', 'plasma', 'dna', 'blood cell')";
// 	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
// 	while($row = $results->fetch_assoc()){
// 		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'aliquots' => array());
// 	}	
// 	if(sizeof(Config::$sample_aliquot_controls) != 7) die("get sample controls failed");
	
// 	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
// 		$query = "select id,aliquot_type,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
// 		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
// 		while($row = $results->fetch_assoc()){
// 			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'volume_unit' => $row['volume_unit']);
// 		}	
// 	}

// 	$query = "SELECT value FROM structure_permissible_values_customs INNEr JOIN structure_permissible_values_custom_controls "
// 		."ON structure_permissible_values_custom_controls.id = structure_permissible_values_customs.control_id "
// 		."WHERE name LIKE 'tissue source'";
// 	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
// 	while($row = $results->fetch_assoc()){
// 		Config::$tissue_source[] = $row['value'];
// 	}
// 	Config::$tissue_source[] = '';	
}

function addonFunctionEnd(){
	
	// Clean-up PARTICIPANTS

	$queries = array(
		"UPDATE participants SET last_modification = NOW() WHERE id IN (".implode(',', Config::$create_participant_ids).");",
		"UPDATE participants SET date_of_birth = NULL WHERE date_of_birth LIKE '0000-00-00';",
		"UPDATE participants SET date_of_death = NULL WHERE date_of_death LIKE '0000-00-00';",
		"UPDATE participants SET qc_tf_suspected_date_of_death = NULL WHERE qc_tf_suspected_date_of_death LIKE '0000-00-00';",
		"UPDATE participants SET qc_tf_last_contact = NULL WHERE qc_tf_last_contact LIKE '0000-00-00';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query(Config::$db_connection, str_replace('participants','participants_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	// Clean-up DIAGNOSIS_MASTERS
	$queries = array(
		"UPDATE diagnosis_masters SET primary_id=id WHERE primary_id IS NULL;",
		"UPDATE diagnosis_masters SET dx_date = NULL WHERE dx_date LIKE '0000-00-00';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query(Config::$db_connection, str_replace('diagnosis_masters','diagnosis_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}	
	
	// Clean-up TREAMTENT_MASTERS
	$queries = array(
		"UPDATE treatment_masters SET start_date = NULL WHERE start_date LIKE '0000-00-00';",
		"UPDATE treatment_masters SET finish_date = NULL WHERE finish_date LIKE '0000-00-00';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query(Config::$db_connection, str_replace('treatment_masters','treatment_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}	
	
	// Clean-up EVENT_MASTERS
	$queries = array(
		"UPDATE event_masters SET event_date = NULL WHERE event_date LIKE '0000-00-00';",
		"UPDATE event_masters ev, diagnosis_masters rec
		SET ev.diagnosis_master_id = rec.id
		WHERE rec.diagnosis_control_id = ".Config::$dx_controls['recurrence']['biochemical recurrence']['id']."
		AND ev.event_control_id = ".Config::$event_controls['lab']['psa']['general']['id']."
		AND ev.diagnosis_master_id = rec.parent_id
		AND ev.event_date = rec.dx_date
		AND rec.dx_date IS NOT NULL
		AND rec.participant_id IN (".implode(',', Config::$create_participant_ids).");");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query(Config::$db_connection, str_replace(array('event_masters', 'diagnosis_masters'),array('event_masters_revs','diagnosis_masters_revs'),$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	// Set all treatments defined as DFS Start
	$tx_methode_sorted_for_dfs = array(
		'1' => 'surgery-RP',
		'2' => 'surgery-TURP',
		'3' => 'hormonotherapy-general',
		'4' => 'radiation-general',
		'5' => 'chemotherapy-general',
		'6' => 'biopsy-general');
	
	$query = "SELECT tm.id, tm.participant_id, tm.start_date, tc.tx_method, tc.disease_site
		FROM treatment_masters tm INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id
		WHERE tm.participant_id IN (".implode(',', Config::$create_participant_ids).") AND tm.start_date IS NOT NULL
		ORDER BY tm.participant_id, tm.start_date ASC";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	
	$participant_id = '-1';
	$first_tx_list_per_method = array();
	$dfs_tx_ids = array();
	while($row = $results->fetch_assoc()){
		if($participant_id != $row['participant_id']) {
			if($participant_id != '-1') {
				// TODO update dfs if found
				$dfs_tx_id = null;			
				foreach($tx_methode_sorted_for_dfs as $next_tx_method) {					
					if(isset($first_tx_list_per_method[$next_tx_method])) {
						$dfs_tx_ids[$participant_id] = $first_tx_list_per_method[$next_tx_method];
						break;
					}
				}
			}
			$first_tx_list_per_method = array();
			$participant_id = $row['participant_id'];
		}
		
		// Set first tx if this one has not already been set for this method
		$tx_method = $row['tx_method'].'-'.$row['disease_site'];	
		if(!in_array($tx_method, $tx_methode_sorted_for_dfs)) die("ERR88938 [".__FUNCTION__." ".__LINE__."]");
		if(!isset($first_tx_list_per_method[$tx_method])) $first_tx_list_per_method[$tx_method] = $row['id'];
	}
	
	if(!empty($dfs_tx_ids)) {
		$query = "UPDATE treatment_masters SET qc_tf_disease_free_survival_start_events = '1' WHERE id IN (".implode(',', $dfs_tx_ids).");";
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query(Config::$db_connection, str_replace('treatment_masters','treatment_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
		
	
	//TODO definir premeiere recurrence et faire le calcul de la survie, etc

		
		

	
	
	
	
	
	
	
	 	
	
	
	
	
pr('TODO:
	- DFS Start  	
	- qc_tf_dxd_cpcbn
	- survival_in_months
	- and bcr_in_months');
	
		
// 	// DIAGNOSIS / TRT / EVENT LINKS CREATION
	
// 	$query  ="SELECT participant_id, COUNT(*) AS c FROM diagnosis_masters WHERE created >= (SELECT start_time FROM start_time) AND parent_id IS NULL GROUP BY participant_id HAVING c > 1";
// 	$result = mysqli_query(Config::$db_connection, $query) or die("reading in addonFunctionEnd failed");
// 	$ids = array();
// 	while($row = $result->fetch_assoc()){
// 		$ids[] = $row['participant_id'];
// 	}
// 	mysqli_free_result($result);
	
// 	if(!empty($ids)){
// 		echo "MESSAGE: The tx and events for participants with ids (".implode(", ", $ids).") couldn't be linked to a dx because they have more than one primary dx.".Config::$line_break_tag;
// 	}
	
// 	$ids[] = 0;
// 	$query = "UPDATE event_masters "
// 		."LEFT JOIN diagnosis_masters ON event_masters.participant_id=diagnosis_masters.participant_id AND diagnosis_masters.parent_id IS NULL "
// 		."SET event_masters.diagnosis_master_id=diagnosis_masters.id "
// 		."WHERE event_masters.created >= (SELECT start_time FROM start_time) AND event_masters.participant_id NOT IN(".implode(", ", $ids).")";
// 	mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed");
	
// 	if(Config::$insert_revs){
// 		$query = "UPDATE event_masters_revs INNER JOIN event_masters ON event_masters.id = event_masters_revs.id SET event_masters_revs.diagnosis_master_id = event_masters.diagnosis_master_id";
// 		mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed (revs table)");
// 	}	

// 	$query = "UPDATE treatment_masters "
// 		."LEFT JOIN diagnosis_masters ON treatment_masters.participant_id=diagnosis_masters.participant_id AND diagnosis_masters.parent_id IS NULL "
// 		."SET treatment_masters.diagnosis_master_id=diagnosis_masters.id "
// 		."WHERE treatment_masters.created >= (SELECT start_time FROM start_time) AND treatment_masters.participant_id NOT IN(".implode(", ", $ids).")";
// 	mysqli_query(Config::$db_connection, $query) or die("update 2 in addonFunctionEnd failed");

// 	if(Config::$insert_revs){
// 		$query = "UPDATE treatment_masters_revs INNER JOIN txreatment_masters ON treatment_masters.id = treatment_masters_revs.id SET treatment_masters_revs.diagnosis_master_id = treatment_masters.diagnosis_master_id";
// 		mysqli_query(Config::$db_connection, $query) or die("update 2 in addonFunctionEnd failed (revs table)");
// 	}	
	
// 	// COLLECTION / PARTICIPANTS LINKS CREATION
	
// 	$query = "INSERT INTO clinical_collection_links (participant_id, collection_id, created, created_by, modified, modified_by) 
// 		(SELECT p.mysql_id, c.mysql_id, 1, NOW(), 1, NOW() 
// 		FROM id_linking AS p 
// 		INNER JOIN id_linking AS c ON c.csv_reference='inventory' AND p.csv_id=c.csv_id WHERE p.csv_reference='participants')";
// 	mysqli_query(Config::$db_connection, $query) or die("collection linking failed qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
// 	if(Config::$insert_revs){
// 		$query = "INSERT INTO clinical_collection_links_revs (id, participant_id, collection_id, modified_by, version_created) "
// 			."(SELECT id, participant_id, collection_id, modified_by, NOW() FROM clinical_collection_links WHERE collection_id IN (SELECT c.mysql_id FROM id_linking AS c WHERE c.csv_reference='collections'))";
// 		mysqli_query(Config::$db_connection, $query) or die("collection linking failed qry failed [".$query."] ".mysqli_error(Config::$db_connection));
// 	}
	
// 	$query = "DELETE FROM id_linking";
// 	mysqli_query(Config::$db_connection, $query) or die("collection linking failed qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
// 	// EMPTY DATES CLEAN UP
	
// 	$date_times_to_check = array(
// 		'collections.collection_datetime',
// 		'diagnosis_masters.dx_date',
// 		'event_masters.event_date',
// 		'participants.date_of_birth',
// 		'participants.date_of_death',
// 		'participants.qc_tf_suspected_date_of_death',
// 		'participants.qc_tf_last_contact',
// 		'treatment_masters.start_date',
// 		'treatment_masters.finish_date');

// 	foreach($date_times_to_check as $table_field) {
// 		$names = explode(".", $table_field);
		
// 		$query = "UPDATE ".$names[0]." SET ".$names[1]." = null WHERE ".$names[1]." LIKE '0000-00-00%'";
// 		mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null.");
		
// 		if(Config::$insert_revs){
// 			$query = "UPDATE ".$names[0]."_revs SET ".$names[1]." = null WHERE ".$names[1]." LIKE '0000-00-00%'";
// 			mysqli_query(Config::$db_connection, $query) or die("set field $table_field 0000-00-00 to null (revs).");			
// 		}
// 	}
	
// 	// LAST DATA UPDATE
	
// 	$query = "UPDATE participants SET vital_status='deceased' WHERE vital_status='dead'";
// 	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
// 	if(Config::$insert_revs){
// 		$query = "UPDATE participants_revs SET vital_status='deceased' WHERE vital_status='dead'";
// 		mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
// 	}
	
// 	$query = "UPDATE aliquot_masters SET barcode=CONCAT('', id) WHERE barcode=''";
// 	mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
// 	if(Config::$insert_revs){
// 		$query = "UPDATE aliquot_masters_revs SET barcode=CONCAT('', id) WHERE barcode=''";
// 		mysqli_query(Config::$db_connection, $query) or die("update participants in addonFunctionEnd failed");
// 	}




	global $insert;
	foreach(Config::$summary_msg as $data_type => $msg_arr) {
		echo "".Config::$line_break_tag."".Config::$line_break_tag."<FONT COLOR=\"blue\" >
		=====================================================================".Config::$line_break_tag."".Config::$line_break_tag."
		PROCESS SUMMARY: $data_type
		".Config::$line_break_tag."".Config::$line_break_tag."=====================================================================
		</FONT>".Config::$line_break_tag."";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
//TODO			$insert = false;
			echo "".Config::$line_break_tag."<FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT>".Config::$line_break_tag."";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "".Config::$line_break_tag." --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
				foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	
		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "".Config::$line_break_tag."<FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT>".Config::$line_break_tag."";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "".Config::$line_break_tag." --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
				foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	
		if(!empty($msg_arr['@@MESSAGE@@'])) {
		echo "".Config::$line_break_tag."<FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT>".Config::$line_break_tag."";
		foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
			echo "".Config::$line_break_tag." --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT>".Config::$line_break_tag."";
			foreach($msgs as $msg) echo "$msg".Config::$line_break_tag."";
			}
		}
	}
	
	
// 	chir
// 	apres radio
// 	apres..
	
	
// 	'DiagnosisMaster.primary_id'=> $primary_id,
// 	'DiagnosisMaster.deleted != 1',
// 	'DiagnosisDetail.first_biochemical_recurrence'=> '1',	
	
// 	'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagnoses_ids,
// 	'TreatmentMaster.deleted != 1',
// 	'TreatmentMaster.qc_tf_disease_free_survival_start_events'=> '1');

	
	
//pr('addonFunctionEnd exit');	exit;

}


function calculateSurvivalAndBcr($studied_diagnosis_id) {
	if(empty($studied_diagnosis_id)) return;

	$all_linked_diagnoses_ids = $this->getAllTumorDiagnosesIds($studied_diagnosis_id);
	$conditions = array(
			'DiagnosisMaster.id' => $all_linked_diagnoses_ids,
			'DiagnosisMaster.deleted != 1',
			'DiagnosisControl.category' => 'primary',
			'DiagnosisControl.controls_type' => 'prostate');
	$prostate_dx = $this->find('first', array('conditions'=>$conditions));

	if(!empty($prostate_dx)) {
		$participant_id = $prostate_dx['DiagnosisMaster']['participant_id'];
		$primary_id = $prostate_dx['DiagnosisMaster']['id'];
		$primary_diagnosis_control_id = $prostate_dx['DiagnosisMaster']['diagnosis_control_id'];
			
		$previous_survival = $prostate_dx['DiagnosisDetail']['survival_in_months'];
		$previous_bcr = $prostate_dx['DiagnosisDetail']['bcr_in_months'];
			
		// Get 1st BCR
			
		$conditions = array(
				'DiagnosisMaster.primary_id'=> $primary_id,
				'DiagnosisMaster.deleted != 1',
				'DiagnosisDetail.first_biochemical_recurrence'=> '1',
		);
		$joins = array(array(
				'table' => 'qc_tf_dxd_recurrence_bio',
				'alias' => 'DiagnosisDetail',
				'type' => 'INNER',
				'conditions'=> array('DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id')));
		$bcr = $this->find('first', array('conditions'=>$conditions, 'joins' => $joins));
			
		$bcr_date = $bcr['DiagnosisMaster']['dx_date'];
		$bcr_accuracy = $bcr['DiagnosisMaster']['dx_date_accuracy'];
			
		// Get 1st DFS
			
		$treatment_master_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
		$conditions = array(
				'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagnoses_ids,
				'TreatmentMaster.deleted != 1',
				'TreatmentMaster.qc_tf_disease_free_survival_start_events'=> '1');
		$dfs = $treatment_master_model->find('first', array('conditions' => $conditions));
			
		$dfs_date = $dfs['TreatmentMaster']['start_date'];
		$dfs_accuracy = $dfs['TreatmentMaster']['start_date_accuracy'];
			
		// Get survival end date
			
		$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$participant = $participant_model->find('first', array('conditions' => array('Participant.id' => $participant_id)));
			
		$survival_end_date = '';
		$survival_end_date_accuracy = '';
		if(!empty($participant['Participant']['date_of_death'])) {
			$survival_end_date = $participant['Participant']['date_of_death'];
			$survival_end_date_accuracy = $participant['Participant']['date_of_death_accuracy'];
		} else if(!empty($participant['Participant']['qc_tf_last_contact'])) {
			$survival_end_date = $participant['Participant']['qc_tf_last_contact'];
			$survival_end_date_accuracy = $participant['Participant']['qc_tf_last_contact_accuracy'];
		}
			
		// Calculate Survival
			
		$new_survival = '';
		if(!empty($dfs_date) && !empty($survival_end_date)) {
			if($survival_end_date_accuracy.$dfs_accuracy == 'cc') {
				$dfs_date_ob = new DateTime($dfs_date);
				$survival_end_date_ob = new DateTime($survival_end_date);
				$interval = $dfs_date_ob->diff($survival_end_date_ob);
				if($interval->invert) {
					AppController::getInstance()->addWarningMsg(__('survival cannot be calculated because dates are not chronological'));
				} else {
					$new_survival = $interval->y*12 + $interval->m;
				}
			} else {
				AppController::getInstance()->addWarningMsg(__('survival cannot be calculated on inaccurate dates'));
			}
		}

		// Calculate bcr
			
		$new_bcr = '';
		if(!empty($dfs_date) && !empty($bcr_date)) {
			if($dfs_accuracy.$bcr_accuracy == 'cc') {
				$dfs_date_ob = new DateTime($dfs_date);
				$bcr_date_ob = new DateTime($bcr_date);
				$interval = $dfs_date_ob->diff($bcr_date_ob);
				if($interval->invert) {
					AppController::getInstance()->addWarningMsg(__('bcr cannot be calculated because dates are not chronological'));
				} else {
					$new_bcr = $interval->y*12 + $interval->m;
				}
			} else {
				AppController::getInstance()->addWarningMsg(__('bcr cannot be calculated on inaccurate dates'));
			}
		} else {
			$new_bcr = $new_survival;
		}
			
		// Data to update
			
		$data_to_update = array('DiagnosisMaster' => array('diagnosis_control_id' => $primary_diagnosis_control_id));
		if($new_bcr != $previous_bcr) $data_to_update['DiagnosisDetail']['bcr_in_months'] = $new_bcr;
		if($new_survival != $previous_survival) $data_to_update['DiagnosisDetail']['survival_in_months'] = $new_survival;
		if(sizeof($data_to_update) != 1) {
			$thid->data = array();
			$this->id = $primary_id;
			if(!$this->save($data_to_update)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	}
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}
