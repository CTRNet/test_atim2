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
	//static $use_windows_xls_offset = true;
	
	//if reading excel file
	
	//static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/CHUQ-1a119-Atim2012_20120629_revised.xls';static $use_windows_xls_offset = true;
	//static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/VPC-1a150-Atim_20120629_revised.xls';static $use_windows_xls_offset = false;
	//static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/CHUM-1a100-ATiM_20120629_revised.xls';static $use_windows_xls_offset = false;
	//static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/UHN-Fleshner-1a150-ATiM_20120629_revised.xls';static $use_windows_xls_offset = false;
	static $xls_file_path = 'C:/_My_Directory/Local_Server/ATiM/tfri_cpcbn/data/McGill-1a100-Atim_20120629_revised.xls';static $use_windows_xls_offset = true;
	
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
	static $storage_master_id = null;
	static $sample_aliquot_controls = array();
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
	
	static $collection_sites = array();
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
Config::$config_files[] = $relative_path.'collections.php';

function addonFunctionStart(){
TODO
hormontherapy accepte les drugs
il faut créer un type trtt prechimio	
	$file_name = substr(Config::$xls_file_path, (strrpos(Config::$xls_file_path, '/') + 1));
	echo "<FONT COLOR=\"green\" >".Config::$line_break_tag.
	"=====================================================================".Config::$line_break_tag."
	DATA EXPORT PROCESS : CPCBN TFRI".Config::$line_break_tag."
	source_file = $file_name".Config::$line_break_tag."
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
	
	$query = "SELECT `value`, `en`, `fr` FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen collection sites');";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$collection_sites[strtolower($row['value'])] = $row['value'];
	}
	
	//TODO	
	$query = "SELECT MAX(rght) as last_rght FROM storage_masters;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	$last_rght = empty($row['last_rght'])? 0 : $row['last_rght'];
	$tma_name = substr($file_name, 0, strpos($file_name, '-'));
	$user_id = Config::$db_created_id;
	$query = "INSERT INTO `storage_masters` (`storage_control_id`, `short_label`, selection_label, `lft`, `rght`, `created`, `created_by`, `modified`, `modified_by`) 	VALUES (20, '$tma_name', '$tma_name', '".($last_rght+1)."', '".($last_rght+2)."', NOW(), $user_id, NOW(), $user_id);";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$storage_master_id = Config::$db_connection->insert_id;
	$query = 'UPDATE storage_masters SET code=id WHERE id='.$storage_master_id;
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	Database::insertRevForLastRow('storage_masters');
	Config::$storage_master_id = $storage_master_id;
	
	$query = "INSERT INTO `std_tma_blocks` (`storage_master_id`) VALUES ($storage_master_id);";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	Database::insertRevForLastRow('std_tma_blocks');
	
	$query = "select id,sample_type from sample_controls where sample_type in ('tissue');";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 1) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'volume_unit' => $row['volume_unit']);
		}	
	}
}

function addonFunctionEnd(){
	
	// ** Clean-up PARTICIPANTS ** 
	$queries = array(
		"UPDATE participants SET last_modification = NOW() WHERE id IN (".implode(',', Config::$create_participant_ids).");",
		"UPDATE participants SET date_of_birth = NULL WHERE date_of_birth LIKE '0000-00-00';",
		"UPDATE participants SET date_of_death = NULL WHERE date_of_death LIKE '0000-00-00';",
		"UPDATE participants SET qc_tf_suspected_date_of_death = NULL WHERE qc_tf_suspected_date_of_death LIKE '0000-00-00';",
		"UPDATE participants SET qc_tf_last_contact = NULL WHERE qc_tf_last_contact LIKE '0000-00-00';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('participants','participants_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	//  ** Clean-up DIAGNOSIS_MASTERS ** 
	$queries = array(
		"UPDATE diagnosis_masters SET primary_id=id WHERE primary_id IS NULL AND parent_id IS NULL;",
		"UPDATE diagnosis_masters SET primary_id=parent_id WHERE primary_id IS NULL AND parent_id IS NOT NULL;",
		"UPDATE diagnosis_masters SET dx_date = NULL WHERE dx_date LIKE '0000-00-00';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('diagnosis_masters','diagnosis_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}	
	
	//  ** Clean-up TREAMTENT_MASTERS ** 
	$queries = array(
		"UPDATE treatment_masters SET start_date = NULL WHERE start_date LIKE '0000-00-00';",
		"UPDATE treatment_masters SET start_date_accuracy = 'c' WHERE start_date IS NOT NULL AND start_date_accuracy LIKE '';",
		"UPDATE treatment_masters SET finish_date = NULL WHERE finish_date LIKE '0000-00-00';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('treatment_masters','treatment_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}	
	
	//  ** Clean-up EVENT_MASTERS ** 
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
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace(array('event_masters', 'diagnosis_masters'),array('event_masters_revs','diagnosis_masters_revs'),$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	// ** SURVIVAL & BCR **
	
	// Set all treatments defined as DFS Start
	$query = "SELECT participant_id FROM treatment_masters WHERE (start_date IS NULL OR start_date LIKE '') AND participant_id IN (".implode(',', Config::$create_participant_ids).");";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	$participant_ids_to_remove = array();
	while($row = $results->fetch_assoc()){
		//added to allow process to continue when dates are missing
		$participant_ids_to_remove[] = $row['participant_id'];
	}
	if(!empty($participant_ids_to_remove)) Config::$summary_msg['SURVIVAL & BCR']['@@ERROR@@']['free survival start event defintion'][] = "Following patient won't be studied because treatment start date is missing. See patient ids ".implode(',', $participant_ids_to_remove).".";
		
	$tx_methode_sorted_for_dfs = array(
		'1' => 'surgery-RP',
		'2' => 'surgery-TURP',
		'3' => 'hormonotherapy-general',
		'4' => 'radiation-general',
		'5' => 'chemotherapy-general',
		'6' => 'biopsy-general');
	
	$query = "SELECT tm.id, tm.participant_id, part.qc_tf_bank_participant_identifier, tm.start_date, tm.start_date_accuracy, tc.tx_method, tc.disease_site
		FROM treatment_masters tm INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id INNER JOIN participants part ON part.id = tm.participant_id
		WHERE tm.participant_id IN (".implode(',', Config::$create_participant_ids).")
		ORDER BY tm.participant_id, tm.start_date ASC";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");

	$dfs_tx_ids = array();
	$participant_id = '-1';
	$first_tx_list_per_method = array();
	$accuracy_warning = false;
	$qc_tf_bank_participant_identifier = null;
	while($row = $results->fetch_assoc()){
		if(!in_array($row['participant_id'], $participant_ids_to_remove)) {
			if($participant_id != $row['participant_id']) {
				if($participant_id != '-1') {
					foreach($tx_methode_sorted_for_dfs as $next_tx_method) {					
						if(isset($first_tx_list_per_method[$next_tx_method])) {
							$dfs_tx_ids[$participant_id] = $first_tx_list_per_method[$next_tx_method];
							if($accuracy_warning) if(empty($m->values['SURVIVAL & BCR'])) Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['free survival start event defintion'][] = "Free survival start event has been defined based on treatments with at least one unaccracy date. See patient # $qc_tf_bank_participant_identifier.";
							break;
						}
					}
				}
				$participant_id = $row['participant_id'];
				$first_tx_list_per_method = array();
				$accuracy_warning = false;
				$qc_tf_bank_participant_identifier = null;
			}
			
			$tx_method = $row['tx_method'].'-'.$row['disease_site'];	
			if(!in_array($tx_method, $tx_methode_sorted_for_dfs)) die("ERR88938 [".__FUNCTION__." ".__LINE__."]");
			if(!isset($first_tx_list_per_method[$tx_method])) $first_tx_list_per_method[$tx_method] = $row['id'];
			if($row['start_date_accuracy'] != 'c') $accuracy_warning = true;
			$qc_tf_bank_participant_identifier = $row['qc_tf_bank_participant_identifier'];
		}
	}
	foreach($tx_methode_sorted_for_dfs as $next_tx_method) {
		if(isset($first_tx_list_per_method[$next_tx_method])) {
			$dfs_tx_ids[$participant_id] = $first_tx_list_per_method[$next_tx_method];
			if($accuracy_warning) if(empty($m->values['SURVIVAL & BCR'])) Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['free survival start event defintion'][] = "Free survival start event has been defined based on treatments with at least one unaccracy date. See patient # $qc_tf_bank_participant_identifier.";
			break;
		}
	}
	
	if(!empty($dfs_tx_ids)) {
		$query = "UPDATE treatment_masters SET qc_tf_disease_free_survival_start_events = '1' WHERE id IN (".implode(',', $dfs_tx_ids).");";
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('treatment_masters','treatment_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	// Set first BCR
	$query = "SELECT dm.participant_id FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_recurrence_bio rec ON dm.id = rec.diagnosis_master_id WHERE (dm.dx_date IS NULL OR dm.dx_date LIKE '') AND dm.participant_id IN (".implode(',', Config::$create_participant_ids).");";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	$participant_ids_to_remove = array();
	while($row = $results->fetch_assoc()){
		//added to allow process to continue when dates are missing
		$participant_ids_to_remove[] = $row['participant_id'];
	}
	if(!empty($participant_ids_to_remove)) Config::$summary_msg['SURVIVAL & BCR']['@@ERROR@@']['first bcr defintion'][] = "Following patient won't be studied because dx date is missing. See patient ids ".implode(',', $participant_ids_to_remove).".";
	
	$query = "SELECT dm.id, dm.participant_id, part.qc_tf_bank_participant_identifier, dm.dx_date, dm.dx_date_accuracy
		FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_recurrence_bio rec ON dm.id = rec.diagnosis_master_id AND dm.deleted != 1 INNER JOIN participants part ON part.id = dm.participant_id
		WHERE dm.participant_id IN (".implode(',', Config::$create_participant_ids).") AND dm.dx_date IS NOT NULL
		ORDER BY dm.participant_id, dm.dx_date ASC";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	
	$participant_id = '-1';
	$first_bcr_dx_ids = array();
	$accuracy_warning = false;
	$previous_qc_tf_bank_participant_identifier = null;
	while($row = $results->fetch_assoc()) {
		if(!in_array($row['participant_id'], $participant_ids_to_remove)) {
			if($participant_id != $row['participant_id']) {
				$participant_id = $row['participant_id'];
				$first_bcr_dx_ids[$participant_id] = $row['id'];
				
				if($accuracy_warning) Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['first bcr defintion'][] = "Fisrt BCR has been defined based on bcrs with at least one unaccracy date. See patient # $previous_qc_tf_bank_participant_identifier.";
				$accuracy_warning = false;
				$previous_qc_tf_bank_participant_identifier = $row['qc_tf_bank_participant_identifier'];;
			}
			if($row['dx_date_accuracy'] != 'c') $accuracy_warning = true;
		}
	}
	if($accuracy_warning) Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['first bcr defintion'][] = "Fisrt BCR has been defined based on bcrs with at least one unaccracy date. See patient # $previous_qc_tf_bank_participant_identifier.";
		
	if(!empty($first_bcr_dx_ids)) {
		$query = "UPDATE qc_tf_dxd_recurrence_bio SET first_biochemical_recurrence = '1' WHERE diagnosis_master_id IN (".implode(',', $first_bcr_dx_ids).");";
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;	
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('qc_tf_dxd_recurrence_bio','qc_tf_dxd_recurrence_bio_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}	
	
	// Calculate survival and bcr
	$query = "SELECT dm.id as diagnosis_master_id, dm.participant_id, 
		part.qc_tf_bank_participant_identifier, part.date_of_death, part.date_of_death_accuracy, part.qc_tf_last_contact, part.qc_tf_last_contact_accuracy,
		bcr.bcr_date,
		bcr.bcr_date_accuracy,
		trt.start_date as dfs_date,
		trt.start_date_accuracy as dfs_date_accuracy	
		FROM diagnosis_masters dm 
		INNER JOIN diagnosis_controls dc ON dc.category = 'primary' AND dc.controls_type = 'prostate' 
		INNER JOIN participants part ON part.id = dm.participant_id
		INNER JOIN treatment_masters trt ON trt.diagnosis_master_id = dm.id AND trt.qc_tf_disease_free_survival_start_events = 1
		LEFT JOIN (
			SELECT dmr.primary_id, dmr.dx_date bcr_date, dmr.dx_date_accuracy bcr_date_accuracy
			FROM diagnosis_masters dmr INNER JOIN qc_tf_dxd_recurrence_bio rec ON dmr.id = rec.diagnosis_master_id AND dmr.deleted != 1
			WHERE rec.first_biochemical_recurrence = 1 AND dmr.participant_id IN (".implode(',', Config::$create_participant_ids).")
		) bcr ON bcr.primary_id = dm.id
		WHERE part.id IN (".implode(',', Config::$create_participant_ids).")
		ORDER BY dm.participant_id";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	
	$participant_id = '-1';
	while($row = $results->fetch_assoc()) {
		if($participant_id == $row['participant_id']) die('ERR889930303');

		$bcr_date = $row['bcr_date'];
		$bcr_accuracy = $row['bcr_date_accuracy'];
			
		$dfs_date = $row['dfs_date'];
		$dfs_accuracy = $row['dfs_date_accuracy'];
			
		$survival_end_date = '';
		$survival_end_date_accuracy = '';
		if(!empty($row['date_of_death'])) {
			$survival_end_date = $row['date_of_death'];
			$survival_end_date_accuracy = $row['date_of_death_accuracy'];
		} else if(!empty($row['qc_tf_last_contact'])) {
			$survival_end_date = $row['qc_tf_last_contact'];
			$survival_end_date_accuracy = $row['qc_tf_last_contact_accuracy'];
		}
			
		// Calculate Survival	
		$new_survival = '';
		if(!empty($dfs_date) && !empty($survival_end_date)) {
			if($survival_end_date_accuracy.$dfs_accuracy == 'cc') {
				$dfs_date_ob = new DateTime($dfs_date);
				$survival_end_date_ob = new DateTime($survival_end_date);
				$interval = $dfs_date_ob->diff($survival_end_date_ob);
				if($interval->invert) {
					Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['Survival'][] = "Survival cannot be calculated because dates are not chronological. See patient # ".$row['qc_tf_bank_participant_identifier'].".";
				} else {
					$new_survival = $interval->y*12 + $interval->m;
				}
			} else {
					Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['Survival'][] = "Survival cannot be calculated on inaccurate dates. See patient # ".$row['qc_tf_bank_participant_identifier'].".";
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
					Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['BCR'][] = "BCR cannot be calculated because dates are not chronological. See patient # ".$row['qc_tf_bank_participant_identifier'].".";
				} else {
					$new_bcr = $interval->y*12 + $interval->m;
				}
			} else {
				Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['BCR'][] = "BCR cannot be calculated  on inaccurate dates. See patient # ".$row['qc_tf_bank_participant_identifier'].".";
			}
		} else {
			$new_bcr = $new_survival;
		}
		
		// Data to update
			
		if(strlen($new_survival) || strlen($new_bcr)) {
			$query = "UPDATE qc_tf_dxd_cpcbn SET bcr_in_months = '$new_bcr', survival_in_months = '$new_survival' WHERE diagnosis_master_id = ".$row['diagnosis_master_id'].";";
			mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
			if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('treatment_masters','treatment_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");	
		}
	}
	
	if(true) {
		$queries = array(
			"DROP VIEW IF EXISTS view_collections;",
			"DROP TABLE IF EXISTS view_collections;",
			"CREATE TABLE view_collections (SELECT * FROM view_collections_view);",
			"ALTER TABLE view_collections
				ADD PRIMARY KEY(collection_id),
				ADD KEY(bank_id),
				ADD KEY(qc_tf_collection_type),
				ADD KEY(sop_master_id),
				ADD KEY(participant_id),
				ADD KEY(diagnosis_master_id),
				ADD KEY(consent_master_id),
				ADD KEY(treatment_master_id),
				ADD KEY(event_master_id),
				ADD KEY(participant_identifier),
				ADD KEY(qc_tf_bank_participant_identifier),
				ADD KEY(acquisition_label),
				ADD KEY(collection_site),
				ADD KEY(collection_datetime),
				ADD KEY(collection_property),
				ADD KEY(created);",
				
			"DROP VIEW IF EXISTS view_samples;",
			"DROP TABLE IF EXISTS view_samples;",
			"CREATE TABLE view_samples (SELECT * FROM view_samples_view);",		
			"ALTER TABLE view_samples
				ADD PRIMARY KEY(sample_master_id),
				ADD KEY(parent_sample_id),
				ADD KEY(initial_specimen_sample_id),
				ADD KEY(collection_id),
				ADD KEY(bank_id),
				ADD KEY(qc_tf_collection_type),
				ADD KEY(sop_master_id),
				ADD KEY(participant_id),
				ADD KEY(participant_identifier),
				ADD KEY(qc_tf_bank_participant_identifier),
				ADD KEY(acquisition_label),
				ADD KEY(initial_specimen_sample_type),
				ADD KEY(initial_specimen_sample_control_id),
				ADD KEY(parent_sample_type),
				ADD KEY(parent_sample_control_id),
				ADD KEY(sample_type),
				ADD KEY(sample_control_id),
				ADD KEY(sample_code),
				ADD KEY(sample_category),
				ADD KEY(coll_to_creation_spent_time_msg),
				ADD KEY(coll_to_rec_spent_time_msg);",
				
			"DROP VIEW IF EXISTS view_aliquots;",
			"DROP TABLE IF EXISTS view_aliquots;",
			"CREATE TABLE view_aliquots (SELECT * FROM view_aliquots_view);",
			"ALTER TABLE view_aliquots
				ADD PRIMARY KEY(aliquot_master_id),
				ADD KEY(sample_master_id),
				ADD KEY(collection_id),
				ADD KEY(bank_id),
				ADD KEY(qc_tf_collection_type),
				ADD KEY(storage_master_id),
				ADD KEY(participant_id),
				ADD KEY(participant_identifier),
				ADD KEY(qc_tf_bank_participant_identifier),
				ADD KEY(acquisition_label),
				ADD KEY(initial_specimen_sample_type),
				ADD KEY(initial_specimen_sample_control_id),
				ADD KEY(parent_sample_type),
				ADD KEY(parent_sample_control_id),
				ADD KEY(barcode),
				ADD KEY(aliquot_label),
				ADD KEY(aliquot_type),
				ADD KEY(aliquot_control_id),
				ADD KEY(in_stock),
				ADD KEY(code),
				ADD KEY(selection_label),
				ADD KEY(temperature),
				ADD KEY(temp_unit),
				ADD KEY(created),
				ADD KEY(has_notes);");
		foreach($queries as $query)	{
			mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
		}	
	}

	// MESSAGES
	
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
	
//	echo Config::$line_break_tag."Don't forget to rebuild view : \app>..\lib\Cake\Console\cake view".Config::$line_break_tag;
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}
