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
	static $db_schema		= "tfricpcbn";
	
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//Date format
	//static $use_windows_xls_offset = true;
	
	//if reading excel file
	
	//--------------------------------------------------------------------------------------------------------------------------
	//TODO: To change anytime
	static $relative_path = 'C:/_Perso/Server/tfri_cpcbn/dataImporterConfig/clinic/';
	static $xls_file_path = 'C:/_Perso/Server/tfri_cpcbn/data/TestDfs.xls';
	//static $relative_path = '/ATiM/atim-tfri/dataImporter/projects/tfri_cpcbn/';
	//static $xls_file_path = '/ATiM/atim-tfri/dataImporter/projects/tfri_cpcbn/data/';
	static $active_surveillance_project = true;
	static $use_windows_xls_offset = true;
	//--------------------------------------------------------------------------------------------------------------------------
	
	static $xls_header_rows = 2;

	static $print_queries	= false;//whether to output the dataImporter generated queries
	static $insert_revs		= true;//whether to insert generated queries data in revs as well
	
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

	static $storage_master_id = null;
	static $sample_aliquot_controls = array();

	// Custom variables
	
	static $summary_msg = array();
	static $banks = array();
	static $drugs = array();
	
	static $dx_controls = array();
	static $event_controls = array();
	static $tx_controls = array();
	
	static $existing_patient_unique_keys = array();
	
	static $created_participant_ids = array();
	
	static $collection_sites = array();
	
	static $metastatsis_controls = array();
	
}

//add you start queries here
Config::$addon_queries_start[] = "DROP TABLE IF EXISTS start_time";
Config::$addon_queries_start[] = "CREATE TABLE start_time (SELECT NOW() AS start_time)";

//add the parent models here
Config::$parent_models[] = "participants";
//*Config::$parent_models[] = "inventory";

//add your configs
Config::$config_files[] = Config::$relative_path.'tablesMapping/participants.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/dx_primary.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/dx_metastasis.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/tx_surgery.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/tx_biopsy.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/dx_recurrence.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/tx_radiotherapy.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/tx_chemotherapy.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/tx_hormonotherapy.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/tx_other_trt.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/event_psa.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/dx_other_primary.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/dx_unknown_primary.php';
Config::$config_files[] = Config::$relative_path.'tablesMapping/collections.php';

function addonFunctionStart(){
	
	$query = "SELECT NOW() as msgdate FROM banks";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	$date_for_msg = $row['msgdate'];
	
	$file_name = substr(Config::$xls_file_path, (strrpos(Config::$xls_file_path, '/') + 1));
	echo "<FONT COLOR=\"green\" >".Config::$line_break_tag.
	"=====================================================================".Config::$line_break_tag."
	DATA EXPORT PROCESS : CPCBN TFRI".Config::$line_break_tag."
	Excel = $file_name".Config::$line_break_tag.
	(Config::$active_surveillance_project? 'Active Surveillance Project' : 'Normal Project').Config::$line_break_tag.
	$date_for_msg.Config::$line_break_tag.
	"=====================================================================
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
	
	$query = "SELECT id, event_group, event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$event_controls[$row['event_group']][$row['event_type']] = array('id'=> $row['id'], 'detail_tablename'=> $row['detail_tablename']);
	}		
	
	$query = "SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$dx_controls[$row['category']][$row['controls_type']] = array('id'=> $row['id'], 'detail_tablename'=> $row['detail_tablename']);
	}	
	
	$query = "SELECT id, tx_method, disease_site, detail_tablename, treatment_extend_control_id FROM treatment_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$ctrl_data = array('id'=> $row['id'], 'detail_tablename'=> $row['detail_tablename'], 'treatment_extend_control_id' => $row['treatment_extend_control_id']);
		Config::$tx_controls[$row['tx_method']] = $ctrl_data;
	}	
	
	$query = "SELECT id, generic_name FROM drugs WHERE type = 'chemotherapy';";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$drugs[strtolower($row['generic_name'])] = $row['id'];
	}
		
	Config::$created_participant_ids = array();
	
	$query = "SELECT `value`, `en`, `fr` FROM structure_permissible_values_customs WHERE control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen collection sites');";
	$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$collection_sites[strtolower($row['value'])] = $row['value'];
	}
	
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
	$str_created_participant_ids = implode(',', Config::$created_participant_ids);
	
	// ** Clean-up PARTICIPANTS ** 
	
	$queries = array(
		"UPDATE participants SET last_modification = NOW() WHERE id IN ($str_created_participant_ids);",
		"UPDATE participants SET date_of_birth = NULL WHERE date_of_birth LIKE '0000-00-00';",
		"UPDATE participants SET date_of_death = NULL WHERE date_of_death LIKE '0000-00-00';",
		"UPDATE participants SET qc_tf_suspected_date_of_death = NULL WHERE qc_tf_suspected_date_of_death LIKE '0000-00-00';",
		"UPDATE participants SET qc_tf_last_contact = NULL WHERE qc_tf_last_contact LIKE '0000-00-00';",
		"UPDATE participants SET date_of_birth_accuracy = 'c' WHERE date_of_birth IS NOT NULL AND date_of_birth_accuracy LIKE '';",
		"UPDATE participants SET date_of_death_accuracy = 'c' WHERE date_of_death IS NOT NULL AND date_of_death_accuracy LIKE '';",
		"UPDATE participants SET qc_tf_suspected_date_of_death_accuracy = 'c' WHERE qc_tf_suspected_date_of_death IS NOT NULL AND qc_tf_suspected_date_of_death_accuracy LIKE '';",
		"UPDATE participants SET qc_tf_last_contact_accuracy = 'c' WHERE qc_tf_last_contact IS NOT NULL AND qc_tf_last_contact_accuracy LIKE '';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('participants','participants_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	//  ** Clean-up DIAGNOSIS_MASTERS ** 
	
	$queries = array(
		"UPDATE diagnosis_masters SET primary_id=id WHERE primary_id IS NULL AND parent_id IS NULL;",
		"UPDATE diagnosis_masters SET primary_id=parent_id WHERE primary_id IS NULL AND parent_id IS NOT NULL;",
		"UPDATE diagnosis_masters SET dx_date = NULL WHERE dx_date LIKE '0000-00-00';",
		"UPDATE diagnosis_masters SET dx_date_accuracy = 'c' WHERE dx_date IS NOT NULL AND dx_date_accuracy LIKE '';",
		"UPDATE diagnosis_masters SET age_at_dx = NULL WHERE age_at_dx LIKE '0';",
		"UPDATE qc_tf_dxd_cpcbn dd, diagnosis_masters dm SET dd.hormonorefractory_status = 'not HR' 
		WHERE dm.participant_id IN ($str_created_participant_ids) AND dm.id = dd.diagnosis_master_id AND (dd.hormonorefractory_status IS NULL OR dd.hormonorefractory_status = '');");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace(array('diagnosis_masters','qc_tf_dxd_cpcbn'),array('diagnosis_masters_revs','qc_tf_dxd_cpcbn_revs'),$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	//  ** Clean-up TREAMTENT_MASTERS ** 
	
	$queries = array(
		"UPDATE treatment_masters SET start_date = NULL WHERE start_date LIKE '0000-00-00';",
		"UPDATE treatment_masters SET start_date_accuracy = 'c' WHERE start_date IS NOT NULL AND start_date_accuracy LIKE '';",
		"UPDATE treatment_masters SET finish_date = NULL WHERE finish_date LIKE '0000-00-00';",
		"UPDATE treatment_masters SET finish_date_accuracy = 'c' WHERE finish_date IS NOT NULL AND finish_date_accuracy LIKE '';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('treatment_masters','treatment_masters_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}	
	
	//  ** Clean-up EVENT_MASTERS ** 
	
	$queries = array(
		"UPDATE event_masters SET event_date = NULL WHERE event_date LIKE '0000-00-00';",
		"UPDATE event_masters SET event_date_accuracy = 'c' WHERE event_date IS NOT NULL AND event_date_accuracy LIKE '';",
		"UPDATE event_masters ev, diagnosis_masters rec
		SET ev.diagnosis_master_id = rec.id
		WHERE rec.diagnosis_control_id = ".Config::$dx_controls['recurrence']['biochemical recurrence']['id']."
		AND ev.event_control_id = ".Config::$event_controls['lab']['psa']['id']."
		AND ev.diagnosis_master_id = rec.parent_id
		AND ev.event_date = rec.dx_date
		AND rec.dx_date IS NOT NULL
		AND rec.participant_id IN ($str_created_participant_ids);");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace(array('event_masters', 'diagnosis_masters'),array('event_masters_revs','diagnosis_masters_revs'),$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	//  ** Clean-up COLLECTIONS **
	
	$queries = array(
		"UPDATE collections SET collection_datetime = NULL WHERE collection_datetime LIKE '0000-00-00';",
		"UPDATE collections SET collection_datetime_accuracy = 'c' WHERE collection_datetime IS NOT NULL AND collection_datetime_accuracy LIKE '';");
	foreach($queries as $query)	{
		mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace(array('collections'),array('collections_revs'),$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	}
	
	//  ** Biopsy checks and clean up & Biopsy/TURP Gleason Score **
	
	$biopsy_and_turp_control_id = Config::$tx_controls['biopsy and turp']['id'];
	$prostate_primary_control_id = Config::$dx_controls['primary']['prostate']['id'];
	
	$query = "SELECT p.qc_tf_bank_participant_identifier, dm.id as diagnosis_master_id, dm.dx_date, dm.dx_date_accuracy, dd.tool
		FROM participants p
		INNER JOIN diagnosis_masters dm ON dm.participant_id = p.id
		INNER JOIN qc_tf_dxd_cpcbn dd ON dd.diagnosis_master_id = dm.id
		WHERE p.deleted <> 1 AND p.id IN ($str_created_participant_ids)
		AND dm.deleted <> 1 AND dm.diagnosis_control_id = $prostate_primary_control_id";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	while($prostate_dx_row = $results->fetch_assoc()) {
		$qc_tf_bank_participant_identifier = $prostate_dx_row['qc_tf_bank_participant_identifier'];
		$diagnosis_master_id = $prostate_dx_row['diagnosis_master_id'];
		$query = "SELECT tm.id, tm.start_date, tm.start_date_accuracy, td.type
			FROM treatment_masters tm, qc_tf_txd_biopsies_and_turps td
			WHERE tm.deleted <> 1 AND tm.treatment_control_id = $biopsy_and_turp_control_id AND tm.id = td.treatment_master_id AND tm.diagnosis_master_id = $diagnosis_master_id";
		$biop_turp_results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
		$bx_turp_dx_data = array();
		$participant_biopsies_and_turps = array();
		while($biop_turp_row = $biop_turp_results->fetch_assoc()) {
			if(in_array($biop_turp_row['type'], array("Bx Dx", "Bx Dx TRUS-Guided", "TURP Dx"))) {
				if(!empty($bx_turp_dx_data)) Config::$summary_msg['diagnosis: biopsy']['@@ERROR@@']["Participant is linked to more than one Biopsy/TURP defined as Dx"][] = "See patient # $qc_tf_bank_participant_identifier.";
				$bx_turp_dx_data = $biop_turp_row;		
			}
			$event_date_key = $biop_turp_row['start_date'].$biop_turp_row['start_date_accuracy'];
			if(isset($participant_biopsies_and_turps[$event_date_key])) die('ERR 2387628763287632');	// We assume one per date
			$participant_biopsies_and_turps[$event_date_key] = $biop_turp_row;
		}
		if(in_array($prostate_dx_row['tool'], array("biopsy", "TRUS-guided biopsy", "TURP"))) {
			//Dx method = Biopsy/TURP
			if($bx_turp_dx_data) {
				//A Biopsy/TURP was defined as Dx in file: check data integrity
				if($bx_turp_dx_data['start_date'] != $prostate_dx_row['dx_date'] || $bx_turp_dx_data['start_date_accuracy'] != $prostate_dx_row['dx_date_accuracy']) 
					Config::$summary_msg['diagnosis: biopsy']['@@ERROR@@']["A Biopsy/TURP event was defined as 'Dx' in file  but the date of this event does not match the diagnosis date (Note the diagnosis 'Gleason Score Biopsy/TURP' will be copied anyway from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier : Event date ".$bx_turp_dx_data['start_date']." (".$bx_turp_dx_data['start_date_accuracy'].") != diagnosis date ".$prostate_dx_row['dx_date']." (".$prostate_dx_row['dx_date_accuracy'].").";
				if(($prostate_dx_row['tool'] ==  'biopsy'  && $bx_turp_dx_data['type'] != 'Bx Dx') || ($prostate_dx_row['tool'] ==  'TURP'  && $bx_turp_dx_data['type'] != 'TURP Dx') || ($prostate_dx_row['tool'] ==  'TRUS-guided biopsy'  && $bx_turp_dx_data['type'] != 'Bx Dx TRUS-Guided'))
					Config::$summary_msg['diagnosis: biopsy']['@@ERROR@@']["A Biopsy/TURP event was defined as 'Dx' in file but the type of this event does not match the diagnosis method (Note the diagnosis 'Gleason Score Biopsy/TURP' will be copied anyway from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier : Diagnosis method [".$prostate_dx_row['tool']."] != event type [".$bx_turp_dx_data['type']."].";
			} else {
				//No Biopsy/TURP was defined as Dx in file: Try to set it
				if($prostate_dx_row['dx_date']) {
					$dx_date_key = $prostate_dx_row['dx_date'].$prostate_dx_row['dx_date_accuracy'];
					if(isset($participant_biopsies_and_turps[$dx_date_key])) {
						//Found a Biopsy/TURP matching Dx date with Dx method = Biopsy/TURP
						if(in_array($participant_biopsies_and_turps[$dx_date_key]['type'], array("Bx","TURP","Bx TRUS-Guided"))) {
							//Got one Biopsy that could be flagged as 'Dx'
							Config::$summary_msg['diagnosis: biopsy']['@@MESSAGE@@']["A Biopsy/TURP event was not defined as 'Dx' in file but the process can defined one based on datesand didagnosis method (So the diagnosis 'Gleason Score Biopsy/TURP' will be copied from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier : Diagnosis method [".$prostate_dx_row['tool']."] and event type [".$participant_biopsies_and_turps[$dx_date_key]['type']."] on ".$prostate_dx_row['dx_date'].".";
							$new_type = '';
							switch($participant_biopsies_and_turps[$dx_date_key]['type']) {
								case 'Bx':
									$new_type = 'Bx Dx';
									break;
								case 'Bx TRUS-Guided':
									$new_type = 'Bx Dx TRUS-Guided';
									break;
								case 'TURP':
									$new_type = 'TURP Dx';
									break;							
							}
							if(empty($new_type)) die('ERR72638726873268726876');
							$query = "UPDATE qc_tf_txd_biopsies_and_turps SET type = '$new_type' WHERE treatment_master_id = ".$participant_biopsies_and_turps[$dx_date_key]['id'];
							mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
							if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('qc_tf_txd_biopsies_and_turps', 'qc_tf_txd_biopsies_and_turps_revs', $query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
							if(($prostate_dx_row['tool'] ==  'biopsy'  && $new_type != 'Bx Dx') || ($prostate_dx_row['tool'] ==  'TURP'  && $new_type != 'TURP Dx') ||	($prostate_dx_row['tool'] ==  'TRUS-guided biopsy'  && $new_type != 'Bx Dx TRUS-Guided')) {
								Config::$summary_msg['diagnosis: biopsy']['@@ERROR@@']["A Biopsy/TURP event has been defined as 'Dx' by the process but the type of this event does not match the diagnosis method (Note the diagnosis 'Gleason Score Biopsy/TURP' will be copied anyway from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier : Diagnosis method [".$prostate_dx_row['tool']."] != event type [$new_type] on ".$prostate_dx_row['dx_date'].".";
							}
						} else {
							Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']["No Biopsy/TURP event was defined as 'Dx' in file and can be linked to a diagnosis based on date and dx method (The diagnosis date matches an event date but the type of the Biopsy/TURP event can not be defined as 'Dx':  The diagnosis 'Gleason Score Biopsy/TURP' won't be copied from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier : Diagnosis method = [".$prostate_dx_row['tool']."] and event type =  [".$participant_biopsies_and_turps[$dx_date_key]['type']."] on ".$prostate_dx_row['dx_date'].".";
						}
					} else {
						Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']["No Biopsy/TURP event was defined as 'Dx' in file and can be defined as 'Dx' by the process based on diagnosis date and method (No Biopsy/TURP date matches the diagnosis date: The diagnosis 'Gleason Score Biopsy/TURP' won't be copied from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier with diagnosis date on ".$prostate_dx_row['dx_date'].".";
					}
				} else {
					//Dx Date not set, the match won't be possible
					Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']["No Biopsy/TURP event was defined as 'Dx' in file and can be defined as 'Dx' by the process based on diagnosis date (date is missing) and method (The diagnosis 'Gleason Score Biopsy/TURP' won't be copied from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier.";
				}
			}		
		} else {
			//Dx method != Biopsy/TURP
			if($bx_turp_dx_data) {
				Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']["A Biopsy/TURP event was defined as 'Dx' but the method of diagnosis was set to something else (Note the diagnosis 'Gleason Score Biopsy/TURP' will be copied anyway from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier : Method [".$prostate_dx_row['tool']."] does not match event type [".$bx_turp_dx_data['type']."].";
			} else {
				Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']["No Biopsy/TURP event can be defined as 'Dx' based on event date and diagnosis method (No Biopsy/TURP event was defined as 'Dx' in the file and the method of diagnosis was different than TURP or biopsy: The diagnosis 'Gleason Score Biopsy/TURP' won't be copied from the Biopsy/TURP event)"][] = "See patient # $qc_tf_bank_participant_identifier. Dx method = [".$prostate_dx_row['tool']."] on ".$prostate_dx_row['dx_date'].".";
			}
		}
	}	
	
	// Update gleason score & ctnm
	$query = "UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, qc_tf_txd_biopsies_and_turps td
		SET dd.gleason_score_biopsy_turp = td.gleason_score, dd.ctnm = td.ctnm
		WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = $prostate_primary_control_id AND dm.id = dd.diagnosis_master_id
		AND tm.deleted <> 1 AND tm.treatment_control_id = $biopsy_and_turp_control_id AND tm.id = td.treatment_master_id
		AND tm.participant_id = dm.participant_id
		AND td.type IN ('Bx Dx', 'TURP Dx','Bx Dx TRUS-Guided')
		AND tm.participant_id IN ($str_created_participant_ids);";
	mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('qc_tf_dxd_cpcbn', 'qc_tf_dxd_cpcbn_revs', $query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	
	//  ** RP Check & RP Gleason Score **
 	
	$query = "SELECT p.qc_tf_bank_participant_identifier
		FROM participants p
		INNER JOIN (
			SELECT participant_id, count(*) AS res_nbr
			FROM treatment_masters tm, txd_surgeries td
			WHERE tm.deleted <> 1 AND tm.treatment_control_id = ".Config::$tx_controls['RP']['id']." AND tm.id = td.treatment_master_id
			AND tm.participant_id IN ($str_created_participant_ids)
			GROUP BY participant_id
		) AS res ON res.participant_id = p.id WHERE res.res_nbr > 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	while($row = $results->fetch_assoc()) {
		$qc_tf_bank_participant_identifier = $row['qc_tf_bank_participant_identifier'];
		Config::$summary_msg['diagnosis: RP']['@@ERROR@@']["Participant is linked to more than one RP"][] = "See patient # $qc_tf_bank_participant_identifier.";
	}
	
	//Update gleason score
	$query = "UPDATE diagnosis_masters dm, qc_tf_dxd_cpcbn dd, treatment_masters tm, txd_surgeries td
		SET dd.gleason_score_rp = td.qc_tf_gleason_score
		WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = ".Config::$dx_controls['primary']['prostate']['id']." AND dm.id = dd.diagnosis_master_id
		AND tm.deleted <> 1 AND tm.treatment_control_id = ".Config::$tx_controls['RP']['id']." AND tm.id = td.treatment_master_id
		AND tm.participant_id = dm.participant_id
		AND tm.participant_id IN ($str_created_participant_ids);";
	mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('qc_tf_dxd_cpcbn', 'qc_tf_dxd_cpcbn_revs', $query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	
	// ** SURVIVAL & BCR **
	
	// Set all treatments defined as DFS Start
	$query = "SELECT participant_id FROM treatment_masters WHERE (start_date IS NULL OR start_date LIKE '') AND participant_id IN ($str_created_participant_ids);";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	$participant_ids_to_remove = array();
	while($row = $results->fetch_assoc()){
		//added to allow process to continue when dates are missing
		$participant_ids_to_remove[] = $row['participant_id'];
	}
	if(!empty($participant_ids_to_remove)) Config::$summary_msg['SURVIVAL & BCR']['@@ERROR@@']['free survival start event defintion'][] = "Following patient won't be studied because treatment start date is missing. See patient ids ".implode(',', $participant_ids_to_remove).".";
		
	$tx_methode_sorted_for_dfs = array(
		'1' => 'RP',
		'2' => 'hormonotherapy',
		'3' => 'radiation',
		'4' => 'chemotherapy');
	$tc_conditions = array();
	foreach($tx_methode_sorted_for_dfs as $tmp_ct) $tc_conditions[] = "tc.tx_method = '$tmp_ct'";
	$tc_conditions = '('.implode(') OR (',$tc_conditions).')';
	$query = "SELECT tm.id, tm.participant_id, part.qc_tf_bank_participant_identifier, tm.start_date, tm.start_date_accuracy, tc.tx_method, tc.disease_site
		FROM treatment_masters tm INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id INNER JOIN participants part ON part.id = tm.participant_id
		WHERE tm.participant_id IN ($str_created_participant_ids) 
		AND ($tc_conditions)
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
							if($accuracy_warning) if(empty($m->values['SURVIVAL & BCR'])) Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['free survival start event defintion'][] = "Free survival start event has been defined but at least one treatment (of the patient) was attached to an unaccracy date. Be sure this 'unaccracy' treatment should not be the 'DFS Start'. See patient # $qc_tf_bank_participant_identifier.";
							break;
						}
					}
				}
				$participant_id = $row['participant_id'];
				$first_tx_list_per_method = array();
				$accuracy_warning = false;
				$qc_tf_bank_participant_identifier = null;
			}
			
			$tx_method = $row['tx_method'].(empty($row['disease_site'])? '' : '-'.$row['disease_site']);	
			if(!in_array($tx_method, $tx_methode_sorted_for_dfs)) {
				pr($tx_method);
				pr($tx_methode_sorted_for_dfs);
				die("ERR88938 [".__FUNCTION__." ".__LINE__."]");
			}
			if(!isset($first_tx_list_per_method[$tx_method])) $first_tx_list_per_method[$tx_method] = $row['id'];
			if($row['start_date_accuracy'] != 'c') $accuracy_warning = true;
			$qc_tf_bank_participant_identifier = $row['qc_tf_bank_participant_identifier'];
		}
	}
	foreach($tx_methode_sorted_for_dfs as $next_tx_method) {
		if(isset($first_tx_list_per_method[$next_tx_method])) {
			$dfs_tx_ids[$participant_id] = $first_tx_list_per_method[$next_tx_method];
			if($accuracy_warning) if(empty($m->values['SURVIVAL & BCR'])) Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['free survival start event defintion'][] = "Free survival start event has been defined but at least one treatment (of the patient) was attached to an unaccracy date. Be sure this 'unaccracy' treatment should not be the 'DFS Start'. See patient # $qc_tf_bank_participant_identifier.";
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
	$query = "SELECT dm.participant_id FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_recurrence_bio rec ON dm.id = rec.diagnosis_master_id WHERE (dm.dx_date IS NULL OR dm.dx_date LIKE '') AND dm.participant_id IN ($str_created_participant_ids);";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	$participant_ids_to_remove = array();
	while($row = $results->fetch_assoc()){
		//added to allow process to continue when dates are missing
		$participant_ids_to_remove[] = $row['participant_id'];
	}
	if(!empty($participant_ids_to_remove)) Config::$summary_msg['SURVIVAL & BCR']['@@ERROR@@']['first bcr defintion'][] = "Following patient won't be studied because dx date is missing. See patient ids ".implode(',', $participant_ids_to_remove).".";
	
	$query = "SELECT dm.id, dm.participant_id, part.qc_tf_bank_participant_identifier, dm.dx_date, dm.dx_date_accuracy
		FROM diagnosis_masters dm INNER JOIN qc_tf_dxd_recurrence_bio rec ON dm.id = rec.diagnosis_master_id AND dm.deleted != 1 INNER JOIN participants part ON part.id = dm.participant_id
		WHERE dm.participant_id IN ($str_created_participant_ids) AND dm.dx_date IS NOT NULL
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
			WHERE rec.first_biochemical_recurrence = 1 AND dmr.participant_id IN ($str_created_participant_ids)
		) bcr ON bcr.primary_id = dm.id
		WHERE part.id IN ($str_created_participant_ids)
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
			if(in_array($survival_end_date_accuracy.$dfs_accuracy, array('cd','dc','cc'))) {
				if($survival_end_date_accuracy.$dfs_accuracy != 'cc') Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['Survival'][] = "Survival has been calculated with at least one unaccuracy date. See patient # ".$row['qc_tf_bank_participant_identifier'].".";
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
			if(in_array($dfs_accuracy.$bcr_accuracy, array('cd','dc','cc'))) {
				if($dfs_accuracy.$bcr_accuracy != 'cc') Config::$summary_msg['SURVIVAL & BCR']['@@WARNING@@']['Survival'][] = "BCR has been calculated with at least one unaccuracy date. See patient # ".$row['qc_tf_bank_participant_identifier'].".";
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
			if(Config::$insert_revs) mysqli_query(Config::$db_connection, str_replace('qc_tf_dxd_cpcbn','qc_tf_dxd_cpcbn_revs',$query)) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");	
		}
	}
	
	//Final test to check only one DFS start exists per primary diagnosis
	$query = "SELECT
			TreatmentMaster.participant_id,
			Bank.name as 'Bank',
			Participant.participant_identifier as 'ATim#',
			Participant.qc_tf_bank_participant_identifier as 'Bank#',
			res.primary_id,
			TreatmentMaster.id as treatment_master_id,
			TreatmentMaster.start_date,
			TreatmentControl.tx_method,
			TreatmentMaster.created AS 'TreatmentMaster.created',
			TreatmentMaster.created_by AS 'TreatmentMaster.created_by',
			TreatmentMaster.modified AS 'TreatmentMaster.modified',
			TreatmentMaster.modified_by AS 'TreatmentMaster.modified_by'
		 FROM(
			SELECT count(*) as nbr,
				DiagnosisMaster.primary_id,
				DiagnosisMaster.participant_id
			FROM diagnosis_masters AS DiagnosisMaster
			INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.qc_tf_disease_free_survival_start_events = 1
			INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
			WHERE DiagnosisMaster.deleted <> 1
			GROUP BY DiagnosisMaster.primary_id, DiagnosisMaster.participant_id
		) as res
		INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.id = res.primary_id
		INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.qc_tf_disease_free_survival_start_events = 1
		INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
		INNER JOIN participants Participant ON Participant.id = DiagnosisMaster.participant_id
		LEFT JOIN banks Bank ON Bank.id = Participant.qc_tf_bank_id
		WHERE nbr  >1
		ORDER BY res.participant_id, res.primary_id, TreatmentMaster.start_date, TreatmentControl.tx_method;";
	$results = mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");
	while($row = $results->fetch_assoc()){
		if(in_array($row['participant_id'], Config::$created_participant_ids)) {
			Config::$summary_msg['DFS Start Final Check']['@@ERROR@@']["A diagnosis is linked to more than one treatment flagged as 'DFS Start' (Patient of the migrated batch)"][$row['participant_id']] = "See Patient Bank# ".$row['Bank#'].".";
		} else {
			Config::$summary_msg['DFS Start Final Check']['@@ERROR@@']["A diagnosis is linked to more than one treatment flagged as 'DFS Start' (Patient Previously migrated)"][$row['participant_id']] ="See Patient Bank# ".$row['Bank#']." of bank '".$row['Bank']."'.";
		}
	}
	
	$query = "UPDATE versions SET permissions_regenerated = 0;";
	mysqli_query(Config::$db_connection, $query) or die("query [$query] failed [".__FUNCTION__." ".__LINE__."]");	

	// MESSAGES
	global $insert;
	//$insert = false;
	//TODO insert
		
	foreach(Config::$summary_msg as $data_type => $msg_arr) {
		echo "".Config::$line_break_tag."".Config::$line_break_tag."<FONT COLOR=\"blue\" >
		=====================================================================".Config::$line_break_tag."".Config::$line_break_tag."
		PROCESS SUMMARY: $data_type
		".Config::$line_break_tag."".Config::$line_break_tag."=====================================================================
		</FONT>".Config::$line_break_tag."";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
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
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsert($data, $table_name, $function, $line, $is_detail_table = false) {
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen($value)) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "NOW()", "created_by" => Config::$db_created_id, "modified" => "NOW()", "modified_by" => Config::$db_created_id);
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).");";
	mysqli_query(Config::$db_connection, $query) or die("Query error [$query] ".__FUNCTION__." ".__LINE__);
	$record_id = mysqli_insert_id(Config::$db_connection);
	// Insert into revs table
	if(Config::$insert_revs) {
		$revs_table_system_data = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()", "modified_by" => Config::$db_created_id);
		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
		$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).");";
		mysqli_query(Config::$db_connection, $query) or die("Query error [$query] ".__FUNCTION__." ".__LINE__);
	}
	return $record_id;
}

