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
	static $db_schema		= "chusovbr";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/data/DONNEES CLINIQUES ET BIOLOGIQUES-SEIN 2012-05-08.xls";
	
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
	static $diagnosis_controls = array();
	static $treatment_controls = array();
	static $event_controls = array();
	static $storage_controls = array();
	
	static $participant_id_linked_to_br_dx_in_step2 = array();
	static $participant_id_from_br_nbr = array();
	static $misc_identifier_id_from_br_nbr = array();
	static $data_for_import_from_participant_id = array();
	static $patient_history_from_id = array();
	static $personal_past_history_from_id = array();
	static $family_history_from_id = array();
	static $storage_id_from_storage_key = array();
	static $nbr_storage_in_step2 = 0;
		
	static $summary_msg = array();	

}

//add the parent models here
Config::$parent_models[] = "BreastDiagnosisMaster";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step3/tablesMapping/breast_diagnoses.php'; 

//=========================================================================================================
// START functions
//=========================================================================================================
	
function addonFunctionStart(){
	global $connection;
	
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS Step 3 : CHUS OVBR<br>
	Breast Data Import<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	echo "ALL Consent will be defined as obtained!<br>";
	echo "<FONT COLOR=\"red\" >WARNING: Be sure Dates columns have been formatted.</FONT><br>";
	
	// ** Data check ** 
	
	$query = "SELECT COUNT(*) FROM participants;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step3: Participant table should be completed");
	}
	
	$query = "SELECT COUNT(*) FROM misc_identifiers;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step3: Identifiers table should be completed");
	}	
	
	$query = "SELECT COUNT(*) FROM diagnosis_masters;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step3: Diagnoses table should not be empty");
	}	

	$query = "SELECT COUNT(*) FROM collections;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step3: Collections table should not be empty");
	}	
	
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
	
	// ** Set diagnosis controls **
	
	$query = "select id,category,controls_type,detail_tablename from diagnosis_controls where flag_active = '1' AND category IN ('primary','secondary');";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$diagnosis_controls[$row['category']][$row['controls_type']] = array('diagnosis_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** Set treatment controls **
	
	$query = "select id,tx_method,disease_site,detail_tablename from treatment_controls where flag_active = '1';";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$treatment_controls[$row['tx_method']][$row['disease_site']] = array('treatment_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** Set event controls **
	
	$query = "select id,disease_site,event_group,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$event_controls[$row['event_group']][$row['disease_site']][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** Set cytoreduction value **
	
//	$query = "select value from structure_permissible_values_customs where control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values');";
//	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
//	while($row = $results->fetch_assoc()){
//		Config::$cytoreduction_values[] = $row['value'];
//	}

	// ** Set participant_id / identifier values links array **
	
	$query = "SELECT ident.id, ctrl.misc_identifier_name, ident.identifier_value, ident.participant_id, part.date_of_birth, part.date_of_birth_accuracy
	FROM misc_identifier_controls AS ctrl 
	INNER JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = ctrl.id
	INNER JOIN participants AS part ON part.id = ident.participant_id
	WHERE ctrl.misc_identifier_name IN ('#FRSQ BR','#FRSQ OV') AND ident.deleted != 1 
	ORDER BY ctrl.misc_identifier_name";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ($query) ".__LINE__);
	while($row = $results->fetch_assoc()){	
		switch($row['misc_identifier_name']) {
			case '#FRSQ BR':
				if(!preg_match('/^BR([0-9]+)$/', $row['identifier_value'], $matches)) {
					echo "<FONT COLOR=\"red\" >WARNING: FRSQ BR identifier format to confirm: ".$row['identifier_value']."</FONT>";
				}
				Config::$participant_id_from_br_nbr[$row['identifier_value']] = $row['participant_id'];
				Config::$misc_identifier_id_from_br_nbr[$row['identifier_value']] = $row['id'];
				
				if(!isset(Config::$data_for_import_from_participant_id[$row['participant_id']])) Config::$data_for_import_from_participant_id[$row['participant_id']] = array('data_imported_from_br_file' => false);
				Config::$data_for_import_from_participant_id[$row['participant_id']][$row['misc_identifier_name']][] = $row['identifier_value'];
				Config::$data_for_import_from_participant_id[$row['participant_id']]['date_of_birth_from_step2'] = $row['date_of_birth'];	
				break;
				
			case '#FRSQ OV';
				if(isset(Config::$data_for_import_from_participant_id[$row['participant_id']])) {
					Config::$data_for_import_from_participant_id[$row['participant_id']][$row['misc_identifier_name']][] = $row['identifier_value'];
				}
				break;
				
			default:
				die('ERR 999e00e9e');
		}
	}
	
	// ** Set storage controls **
	
	$query = "select id,storage_type,detail_tablename from storage_controls where flag_active = '1';";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$storage_controls[$row['storage_type']] = array('storage_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** existing breast cancer **
	
	$query = "select dm.participant_id from diagnosis_controls AS dc INNER JOIN diagnosis_masters AS dm ON dm.diagnosis_control_id = dc.id where dc.flag_active = '1' AND dc.controls_type = 'breast';";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()) Config::$participant_id_linked_to_br_dx_in_step2[] = $row['participant_id'];
	
	// ** patient history data from step2 **
	
	$followup_event_control_id = Config::$event_controls['clinical']['all']['followup']['event_control_id']	;
	$smoking_event_control_id = Config::$event_controls['lifestyle']['all']['smoking history questionnaire']['event_control_id'];
	
	$query = "SELECT part.id, 
	
	part.vital_status, part.chus_date_of_status, part.chus_date_of_status_accuracy, part.chus_cause_of_death,
	em_fol.id AS fol_event_id, em_fol.event_summary AS fol_summary, ed_fol.weight_in_kg, ed_fol.height_in_cm,
	em_smok.id AS smok_event_id, ed_smok.smoking_history, ed_smok.smoking_status, ed_smok.years_quit_smoking, ed_smok.chus_duration_in_years, ed_smok.chus_quantity_per_day,
	rep.id AS reproduct_id, rep.age_at_menarche,rep.gravida,rep.para,rep.chus_abortus,rep.menopause_status,rep.age_at_menopause,rep.menopause_onset_reason,rep.hrt_use,rep.chus_hrt_use_precision,rep.hrt_years_used,rep.chus_evista_use,rep.chus_evista_use_precision
	
	FROM participants AS part 
	
	LEFT JOIN event_masters AS em_fol ON em_fol.participant_id = part.id AND em_fol.event_control_id = $followup_event_control_id AND em_fol.deleted != 1 
	LEFT JOIN chus_ed_clinical_followups AS ed_fol ON ed_fol.event_master_id = em_fol.id
	
	LEFT JOIN event_masters AS em_smok ON em_smok.participant_id = part.id AND em_smok.event_control_id = $smoking_event_control_id AND em_smok.deleted != 1 
	LEFT JOIN ed_all_lifestyle_smokings AS ed_smok ON ed_smok.event_master_id = em_smok.id	
	
	LEFT JOIN reproductive_histories AS rep ON rep.participant_id = part.id AND rep.deleted != 1;";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__."<br>$query");
	while($row = $results->fetch_assoc()) Config::$patient_history_from_id[$row['id']] = $row;   

	// personal past history
	
	$event_control_id = Config::$event_controls['clinical']['all']['past history']['event_control_id'];
	$query = "SELECT em.participant_id, em.event_date,em.event_date_accuracy,em.event_summary,ed.type
	FROM chus_ed_past_histories AS ed
	INNER JOIN event_masters AS em ON ed.event_master_id = em.id AND em.deleted != 1 AND em.event_control_id = $event_control_id;";	
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__."<br>$query");
	while($row = $results->fetch_assoc()) {
		if(array_key_exists($row['participant_id'], Config::$personal_past_history_from_id) && array_key_exists($row['type'], Config::$personal_past_history_from_id[$row['participant_id']])) die('ERR 84994944');
		Config::$personal_past_history_from_id[$row['participant_id']][$row['type']] = array('event_date' => $row['event_date'], 'event_date_accuracy' => $row['event_date_accuracy'], 'event_summary' => $row['event_summary']);
	}
	
	// family history
	
	$query = "SELECT participant_id, relation, chus_tumor_description, chus_tumor_origin, family_domain, chus_notes, age_at_dx FROM family_histories;";	
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__."<br>$query");
	while($row = $results->fetch_assoc()) {
		Config::$family_history_from_id[$row['participant_id']][$row['relation'].'-'.$row['chus_tumor_description']] = $row;
	}
	
	// storage

	$query = "SELECT sm.id, sm.short_label, sc.storage_type, sm.notes FROM storage_masters AS sm INNER JOIN storage_controls AS sc ON sc.id = sm.storage_control_id;";	
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__."<br>$query");
	while($row = $results->fetch_assoc()) {
		Config::$nbr_storage_in_step2++;
		Config::$storage_id_from_storage_key[$row['notes'].$row['storage_type'].$row['short_label']]= $row['id'];
	}
}

//=========================================================================================================
// END functions
//=========================================================================================================
	
function addonFunctionEnd(){
	global $connection;
	
	// DIAGNOSIS UPDATE
	
	$query = "UPDATE diagnosis_masters SET primary_id = id WHERE parent_id IS NULL;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('diagnosis_masters','diagnosis_masters_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE chus_dxd_breasts SET intraductal_perc_of_infiltrating = null WHERE intraductal_perc_of_infiltrating = '-9999';";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('chus_dxd_breasts','chus_dxd_breasts_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE chus_dxd_breasts SET ganglion_total = null WHERE ganglion_total = '-9999';";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('chus_dxd_breasts','chus_dxd_breasts_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE chus_dxd_breasts SET ganglion_invaded = null WHERE ganglion_invaded = '-9999';";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('chus_dxd_breasts','chus_dxd_breasts_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	// ADD PATIENT OTHER DATA

 	addPatientsHistory();
   	addFamilyHistory();
  	addCollections();

  	// INVENTORY COMPLETION
		
	$query = "UPDATE sample_masters SET sample_code=id;";
	mysqli_query($connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE sample_masters_revs SET sample_code=id;";
	mysqli_query($connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
	
	$query = "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;";
	mysqli_query($connection, $query) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE sample_masters_revs SET initial_specimen_sample_id=id WHERE parent_id IS NULL;";
	mysqli_query($connection, $query) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
	
	$query = "UPDATE aliquot_masters SET barcode=id;";
	mysqli_query($connection, $query) or die("barcode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE aliquot_masters_revs SET barcode=id;";
	mysqli_query($connection, $query) or die("barcode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	

	
	$query = "UPDATE storage_masters SET notes = '';";
	mysqli_query($connection, $query) or die("storage note update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE storage_masters_revs SET notes = '';";
	mysqli_query($connection, $query) or die("storage note update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
	
	// WARNING DISPLAY
	
	foreach(Config::$summary_msg as $data_type => $msg_arr) {
		
		echo "<br><br><FONT COLOR=\"blue\" >
		=====================================================================<br><br>
		PROCESS SUMMARY: $data_type
		<br><br>=====================================================================
		</FONT><br>";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
			echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT><br>";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo "$msg<br>";
			}
		}	
		
		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT><br>";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo "$msg<br>";
			}
		}	
		
		if(!empty($msg_arr['@@MESSAGE@@'])) {
			echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT><br>";
			foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo "$msg<br>";
			}
		}
	}
}

function addPatientsHistory() {
	global $connection;
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('Historique patiente', $sheets_nbr)) die("ERROR: Worksheet Historique patiente is missing!\n");

	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr['Historique patiente']]['cells'] as $line => $new_line) {	
		$line_counter++;
		if($line_counter == 1) {
			// HEADER
			$headers = $new_line;
		
		} else {
			
			// SET DATA ARRAY
			
			$line_data = array();
			$frsq_nbr = '';
			foreach($headers as $key => $field) {
				if(isset($new_line[$key])) {
					$line_data[utf8_encode($field)] = utf8_encode($new_line[$key]);
				} else {
					$line_data[utf8_encode($field)] = '';
				}
			}
			
			// GET PARTICIPANT ID
			
			if(empty($line_data['#FRSQ'])) die('ERR Missing #FRSQ in patient history worksheet line : '.$line_counter);
			$frsq_nbr = str_replace(' ', '', $line_data['#FRSQ']);
			
			$participant_id = isset(Config::$participant_id_from_br_nbr[$frsq_nbr])? Config::$participant_id_from_br_nbr[$frsq_nbr] : null;
			if(!$participant_id) {
				Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Unknown participant'][] = "The FRSQ# '".$line_data['#FRSQ']."' has beend assigned to a participant in step3 ('PATIENT HISTORY') but this number is not defined in step 1! [line: $line_counter]";
				continue;
			}
			
			// CHECK PARTICIPANT ON MULTI ROW
			
			if(!isset(Config::$data_for_import_from_participant_id[$participant_id]['history_data'])) {
				Config::$data_for_import_from_participant_id[$participant_id]['history_data'] = $line_data;
			} else {				
				$data_diff_test = array_diff_assoc(Config::$data_for_import_from_participant_id[$participant_id]['history_data'], $line_data); 
				unset($data_diff_test['#FRSQ']);
				unset($data_diff_test['Date recrutement']);
				if(!empty($data_diff_test)) {
					//$diff_fields = "<br> - ".implode("<br> - ",array_keys($data_diff_test));
					$previous_frsq_nbr = Config::$data_for_import_from_participant_id[$participant_id]['history_data']['#FRSQ'];
					Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Duplicated Patient History'][] = "The FRSQ#s '".$line_data['#FRSQ']."' & '$previous_frsq_nbr' are assigned to the same patient but there are more than one row in 'Historique patiente' and data are different (just first one will be imported)! Please check data! [line: $line_counter]";//fields : $diff_fields";
				}
				continue;
			}
			
			// UPDATE PROFILE
			
			$notes_to_update = '';
			$update_sql = '';
			
			$is_dcd = false;

			$old_status = Config::$patient_history_from_id[$participant_id]['vital_status'];
			$new_status = '';
			$file_value = preg_replace(array('/^ /','/ $/'), array('',''),$line_data['Statut VITAL']);
			if(!empty($file_value)) {
				if(preg_match('/^(DCD)(, ){0,1}(.*){0,1}$/i', $file_value, $matches)) {
					$new_status = 'deceased';
					$is_dcd = true;
					if(isset($matches[3])) $notes_to_update = 'Vital status note: '.$matches[3];
				} else if(preg_match('/^vie$/i', $file_value, $matches)) {
					$new_status = 'alive';					
				} else {
					die('ERR 8849884844 ['.$file_value.']');
				}
				$update_sql = "vital_status = '$new_status'";
			}
			editHistoryConflict($old_status, $new_status, $frsq_nbr, 'Statut VITAL', 'PATIENT HISTORY', $line_counter);
						
			$old_date = empty(Config::$patient_history_from_id[$participant_id]['chus_date_of_status'])? '' : Config::$patient_history_from_id[$participant_id]['chus_date_of_status'].' ['.Config::$patient_history_from_id[$participant_id]['chus_date_of_status_accuracy'].']';
			$new_date = '';
			$file_value = preg_replace(array('/^ /','/ $/'), array('',''),$line_data['DateStatut']);
			if(!empty($file_value)) {
				$chus_date_of_status = '';
				$chus_date_of_status_accuracy = '';
				if(preg_match('/^([0-9]{5})$/', $file_value, $matches)) {
					$file_value_tmp = customGetFormatedDate($file_value,'PATIENT HISTORY', $line_counter);
					if($file_value_tmp) $file_value = $file_value_tmp;
				}
				if(preg_match('/^(19|20)([0-9]{2})\-00\-00$/', $file_value, $matches)) {
					$chus_date_of_status = str_replace('-00-00','-01-01',$file_value); 
					$chus_date_of_status_accuracy = 'm';
				} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-00$/', $file_value, $matches)) {
					$chus_date_of_status = str_replace('-00','-01',$file_value); 
					$chus_date_of_status_accuracy = 'd';
				} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/', $file_value, $matches)) {
					$chus_date_of_status = $file_value;
					$chus_date_of_status_accuracy = 'c';
				} else if(preg_match('/^([01][0-9])\-(19|20)([0-9]{2})$/', $file_value, $matches)) {
					$chus_date_of_status = $matches[2].$matches[3].'-'.$matches[1].'-01';
					$chus_date_of_status_accuracy = 'd';	
				}else if(preg_match('/^([0-3][0-9])\-([01][0-9])\-(19|20)([0-9]{2})$/', $file_value, $matches)) {
					$chus_date_of_status = $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1];
					$chus_date_of_status_accuracy = 'c';	
				} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/', $file_value, $matches)) {
					$chus_date_of_status = $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1];
					$chus_date_of_status_accuracy = 'c';	
				} else if($file_value == '10-07-1009') {
					$chus_date_of_status = '2009-07-01';
					$chus_date_of_status_accuracy = 'c';	
				} else {
					die("ERR 988391 [".$file_value."] line : ".$line_counter);
				}
				$new_date = "$chus_date_of_status [$chus_date_of_status_accuracy]" ;
				$update_sql .= (empty($update_sql)? '': ', ')."chus_date_of_status = '$chus_date_of_status', chus_date_of_status_accuracy = '$chus_date_of_status_accuracy'"; 
			}
			editHistoryConflict($old_date, $new_date, $frsq_nbr, 'DateStatut', 'PATIENT HISTORY', $line_counter);

			$old_cause = Config::$patient_history_from_id[$participant_id]['chus_cause_of_death'];
			$new_cause = '';
			$file_value = preg_replace(array('/^ /','/ $/'), array('',''),$line_data['Cause décès']);
			if(!empty($file_value)) {
				if(!$is_dcd) Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Cause décès'][] = "'Cause décès' defined on alive patiente! Please check data! [line: $line_counter]";
				$update_sql .= (empty($update_sql)? '': ', ')."chus_cause_of_death = '".str_replace("'","''",$file_value)."'"; 
				$new_cause = $file_value;
			}		
			editHistoryConflict($old_cause, $new_cause, $frsq_nbr, 'Cause décès', 'PATIENT HISTORY', $line_counter);

			if(!empty($line_data['Mutation BRCA 1 ou 2'])) {
				Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['BRCA Values'][] = "BRCA Value '".$line_data['Mutation BRCA 1 ou 2']."' not imported in step 3! Please record data manually! [line: $line_counter]";
			}				
			
			if(!empty($notes_to_update)) {
				$update_sql .= (empty($update_sql)? '' : ', ')."notes = CONCAT('$notes_to_update', ' // ', IFNULL(notes, ''))";
			}
			if(!empty($update_sql)) {
				$query = "UPDATE participants SET $update_sql WHERE id = $participant_id;";
				mysqli_query($connection, $query) or die("participants update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$query = str_replace('participants','participants_revs',$query);
				mysqli_query($connection, $query) or die("participants update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
			}

			// ADD clinical-all-followup (chus_ed_clinical_followups)
						
			$height_in_cm  =null;
			$weight_in_kg = null;
			$bmi = null;
			$notes = null;
			
			$line_data['Poids::Kg'] = str_replace('ND','',$line_data['Poids::Kg']);
			$line_data['Poids::Lbs'] = str_replace('ND','',$line_data['Poids::Lbs']);
			$line_data['Taille::cm'] = str_replace('ND','',$line_data['Taille::cm']);
			$line_data['Taille::Pieds'] = str_replace('ND','',$line_data['Taille::Pieds']);
			
			if(!empty($line_data['Poids::Kg'])) {
				$weight_in_kg = str_replace(',', '.', $line_data['Poids::Kg']);
				if(!is_numeric($weight_in_kg)) {
					$weight_in_kg = null;
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Poids::Kg'][] = "Wrong 'Poids::Kg' format[".$line_data['Poids::Kg']."]! Please check data! [line: $line_counter]";
				}
			} else if(!empty($line_data['Poids::Lbs'])) {
				$weight_in_lbs =  str_replace(',', '.', $line_data['Poids::Lbs']);
				if(!is_numeric($weight_in_lbs)) {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Poids::Lbs'][] = "Wrong 'Poids::Lbs' format [".$line_data['Poids::Lbs']."]! Please check data! [line: $line_counter]";
				} else {
					$weight_in_kg = $weight_in_lbs * 0.45359;
				}				
			}
			if(!empty($line_data['Taille::cm'])) {
				$height_in_cm = str_replace(',', '.', $line_data['Taille::cm']);
				if(!is_numeric($height_in_cm)) {
					$height_in_cm = null;
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Taille::cm'][] = "Wrong 'Taille::cm' format [".$line_data['Taille::cm']."]! Please check data! [line: $line_counter]";
				}
			} else if(!empty($line_data['Taille::Pieds'])) {
				$height_in_feet = $line_data['Taille::Pieds'];
				if(preg_match('/^([0-9])(\-1{0,1}[0-9]){0,1}$/', $height_in_feet, $matches)) {				
					$feet = $matches[1];
					$inches = str_replace('-','',isset($matches[2])? $matches[2]: '0');
					$height_in_cm = ($feet * 30.48) + ($inches * 2.54);
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Taille::Pieds'][] = "Wrong 'Taille::Pieds' format [".$line_data['Taille::Pieds']."]! Please check data! [line: $line_counter]";
				}				
			}
			
			$bmi = null;
			if(!is_null($height_in_cm) && !is_null($weight_in_kg)) {
				$bmi  = ($weight_in_kg/($height_in_cm*$height_in_cm)) * 10000;
			}

			$notes = empty($line_data['Poids::Lbs'])? '' : 'Weight was defined in Lbs in source file ('.$line_data['Poids::Lbs'].').';
			$notes .= empty($line_data['Taille::Pieds'])? '' : (empty($notes)? '' : ' // ').'Height was defined in feet in source file ('.$line_data['Taille::Pieds'].').';
			$notes .= empty($line_data['IMC'])? '' : (empty($notes)? '' : ' // ').'IMC was defined in source file ('.$line_data['IMC'].').';

			if(!is_null($height_in_cm) || !is_null($weight_in_kg)) {
				if(!empty(Config::$patient_history_from_id[$participant_id]['fol_event_id'])) {
					if((Config::$patient_history_from_id[$participant_id]['height_in_cm'] != $height_in_cm) || (Config::$patient_history_from_id[$participant_id]['weight_in_kg'] != $weight_in_kg)) {
						Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Followup conflict'][] = "There are conflicts between heights and weight defined both in step2 and 3 for frsq# $frsq_nbr (height_in_cm : ".Config::$patient_history_from_id[$participant_id]['height_in_cm']."!= $height_in_cm || weight_in_kg : ".Config::$patient_history_from_id[$participant_id]['weight_in_kg']."!= $weight_in_kg)! Data won't be updated and please check data! [line: $line_counter]";
					}
				} else {
					if(!isset(Config::$event_controls['clinical']['all']['followup'])) die('ERR 88998379');
					$event_control_id = Config::$event_controls['clinical']['all']['followup']['event_control_id'];
					$detail_tablename = Config::$event_controls['clinical']['all']['followup']['detail_tablename'];				
					
					$master_fields = array(
						'participant_id' => $participant_id,
						'event_control_id' =>  $event_control_id,
						'event_summary' => "'".str_replace("'","''",$notes)."'"
					);
					$event_master_id = customInsertChusRecord($master_fields, 'event_masters');	
					
					$detail_fields = array('event_master_id' => $event_master_id);
					if($height_in_cm) $detail_fields['height_in_cm'] = $height_in_cm;
					if($weight_in_kg) $detail_fields['weight_in_kg'] = $weight_in_kg;
					if($bmi) $detail_fields['bmi'] = $bmi;
					customInsertChusRecord($detail_fields, $detail_tablename, true);
				}
			}
			
			// ADD lifestyle all smoking history questionnaire  ed_all_lifestyle_smokings
		
			$detail_fields = array();
			
			$smoking_history = str_replace(array('ND','-'),array('',''), $line_data['TABAC::Fumeur']);
			if(strlen($smoking_history)) {
				if(preg_match('/^ {0,1}non {0,1}$/i', $smoking_history, $matches)) {
					$detail_fields['smoking_history'] = "'no'";
				
				} else if(preg_match('/^ {0,1}oui {0,1}$/i', $smoking_history, $matches)) {
					$detail_fields['smoking_history'] = "'yes'";

				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Tabac'][] = "Value '$smoking_history' is not supported and won't be imported! [line: $line_counter]";
				}
			}	

			$smoking_status = str_replace(array('ND','-'),array('',''), $line_data['TABAC::arrêt tabac?']);
			if(strlen($smoking_status)) {
				if(preg_match('/^ {0,1}non {0,1}$/i', $smoking_status, $matches)) {
					$detail_fields['smoking_status'] = "'smoker'";
				} else if(preg_match('/^ {0,1}oui {0,1}$/i', $smoking_status, $matches)) {
					$detail_fields['smoking_status'] = "'ex-smoker'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['arrêt tabac'][] = "Value '$smoking_status' is not supported and won't be imported! [line: $line_counter]";
				}
			}	
			
			$years_quit_smoking = str_replace(array('ND','MD','-'),array('','',''),$line_data['TABAC::Depuis combien année (An)']);
			if(strlen($years_quit_smoking)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $years_quit_smoking,$matches)) {
					$detail_fields['years_quit_smoking'] = "'$years_quit_smoking'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['arrêt tabac années'][] = "Value '$years_quit_smoking' is not supported and won't be imported! [line: $line_counter]";
				}
			}	 
			
			$chus_duration_in_years = str_replace(array('ND','-'),array('',''),$line_data['TABAC::la durée (an)']);
			if(strlen($chus_duration_in_years)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $chus_duration_in_years,$matches)) {
					$detail_fields['chus_duration_in_years'] = "'$chus_duration_in_years'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Tabac Durée (an)'][] = "Value '$chus_duration_in_years' is not supported and won't be imported! [line: $line_counter]";
				}
			}				
			
			$chus_quantity_per_day = str_replace(array('ND','/jour'),array('',''),$line_data['TABAC::Qté/jour 1pqt = 20']);
			if(strlen($chus_quantity_per_day)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $chus_quantity_per_day,$matches)) {
					$detail_fields['chus_quantity_per_day'] = "'$chus_quantity_per_day'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Tabac::Qté / jour 1pqt = 20'][] = "Value '$chus_quantity_per_day' is not supported and won't be imported! [line: $line_counter]";
				}
			}	
			
			if(!empty($detail_fields)) {
				if(!empty(Config::$patient_history_from_id[$participant_id]['smok_event_id'])) {
					$diff = array();
					$tmp_headers = array(
						'smoking_history' => 'Tabac',
						'smoking_status' => 'arrêt tabac',
						'years_quit_smoking' => 'arrêt tabac années',
						'chus_duration_in_years' => 'Tabac Durée (an)',
						'chus_quantity_per_day' => 'Tabac::Qté / jour 1pqt = 20');
					foreach($tmp_headers as $tmp_field => $file_field) {
						$old_value =Config::$patient_history_from_id[$participant_id][$tmp_field];
						$new_value = isset($detail_fields[$tmp_field])? preg_replace('/^\'(.*)\'$/', '$1', $detail_fields[$tmp_field]): '';
						if((!empty($old_value) || !empty($new_value)) && ($new_value != $old_value)) {
							$diff[] =  utf8_decode($file_field) . ": new [$new_value] <=> old [$old_value]";
						}
					}
					if(!empty($diff)) {
						$tmp_msg = "There are conflicts between smoking information defined both in step2 and 3 for frsq# $frsq_nbr! Data won't be updated and please check data! [line: $line_counter]";
						foreach($diff as $new_ex) $tmp_msg .= "<br> -> ".$new_ex;
						Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Somking conflict'][] = $tmp_msg;
					}
				} else {
					if(!isset(Config::$event_controls['lifestyle']['all']['smoking history questionnaire'])) die('ERR 88998379');
					$event_control_id = Config::$event_controls['lifestyle']['all']['smoking history questionnaire']['event_control_id'];
					$detail_tablename = Config::$event_controls['lifestyle']['all']['smoking history questionnaire']['detail_tablename'];				
					
					$master_fields = array(
						'participant_id' => $participant_id,
						'event_control_id' =>  $event_control_id
					);
					$event_master_id = customInsertChusRecord($master_fields, 'event_masters');	
					$detail_fields['event_master_id'] = $event_master_id;
					customInsertChusRecord($detail_fields, $detail_tablename, true);				
				}
			}

			// reproductive_histories
			
			$headers_list = array();
			$data_to_insert = array();
			
			$headers_list['Âge 1ere menstruation'] = 'age_at_menarche';
			$age_at_menarche = str_replace('ND','',$line_data['Âge 1ere menstruation']);
			if(strlen($age_at_menarche)) {
				if(!preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $age_at_menarche,$matches)) die('ERR 9874994812 age_at_menarche : ' .$age_at_menarche. ' line '.$line_counter);
				$data_to_insert['age_at_menarche'] = "'$age_at_menarche'";
			}
			$headers_list['ENFANTS::G'] = 'gravida';
			$gravida = str_replace(array('ND','-'),array('',''),$line_data['ENFANTS::G']);
			if(strlen($gravida)) {
				if(!preg_match('/^[0-9]+$/', $gravida, $matches)) die('ERR 987499482 gravida : '.$gravida);
				$data_to_insert['gravida'] = "'$gravida'";
			}	
			$headers_list['ENFANTS::P'] = 'para';
			$para = str_replace(array('ND','-'),array('',''),$line_data['ENFANTS::P']);
			if(strlen($para)) {
				if(preg_match('/^([0-9]+) {0,1}(.*)$/', $para,$matches)) {
					$para = $matches[1];
					if(!empty($matches[2])) {
						Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['P Value with comment'][] = "The P Value '".$matches[0]."' contains comment '".$matches[2]."' that won't be imported! Please check data! [line: $line_counter]";
					}
				} else if($para == 'en cours') {
						$para = '0';
						Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['P Value = en cours'][] = "The P Value contains comment 'en cours' that won't be imported! P value will be equal to 0! Please check data! [line: $line_counter]";
				} else {
					die('ERR 987499483 para : '.$para);
				}
				$data_to_insert['para'] = "'$para'";
			}
			$headers_list['ENFANTS::A'] = 'chus_abortus';
			$chus_abortus = str_replace(array('ND','-'),array('',''),$line_data['ENFANTS::A']);
			if(strlen($chus_abortus)) {
				if(!preg_match('/^[0-9]+$/', $chus_abortus, $matches)) die('ERR 9874994843 $chus_abortus : '.$chus_abortus);
				$data_to_insert['chus_abortus'] = "'$chus_abortus'";
			}
			$headers_list['Statut ménopause'] = 'menopause_status';	
			$pre_menopause_value = str_replace(array('ND', '-'),array('',''),$line_data['Statut ménopause::Pré']);
			if(strlen($pre_menopause_value)) {
				if($pre_menopause_value != 'x')  {
					die('ERR 98dds843 Préménopause : '.$pre_menopause_value);
				} else {
					$data_to_insert['menopause_status'] = "'pre'";
				}
			}
			$menopause_value = str_replace(array('ND', '-'),array('',''),$line_data['Statut ménopause::Ménopause']);
			if(strlen($menopause_value)) {
				if($menopause_value != 'x')  die('ERR 98dds843 Ménopause : '.$menopause_value);
				if(isset($data_to_insert['menopause_status'])) die('Menopause status recorded twice (1) line:'. $line_counter);
				$data_to_insert['menopause_status'] = "'peri'";
			}			
			$post_menopause_value = str_replace(array('ND', '-'),array('',''),$line_data['Statut ménopause::Post']);
			if(strlen($post_menopause_value)) {
				if($post_menopause_value != 'x')  die('ERR 98dds8sasas43 Post ménopause : '.$post_menopause_value);
				if(isset($data_to_insert['menopause_status'])) die('Menopause status recorded twice (2) line:'. $line_counter);
				$data_to_insert['menopause_status'] = "'post'";
			}			
			$headers_list['Âge début ménopause'] = 'age_at_menopause';	
			$age_at_menopause = str_replace(array('ND', 'nd', '-'),array('','',''),$line_data['Âge début ménopause']);
			if(strlen($age_at_menopause)) {
				if(!preg_match('/^[0-9]+$/', $age_at_menopause, $matches)) die('ERR 9833343 '.$age_at_menopause);
				$data_to_insert['age_at_menopause'] = "'$age_at_menopause'";
			}
			
			$headers_list['Cause fin menstruation'] = 'menopause_onset_reason';	
			$natural_menopause_reason = str_replace(array('ND', '-','oui'),array('','','x'),$line_data['Cause fin menstruation::Naturelle']);
			if(strlen($natural_menopause_reason)) {
				if($natural_menopause_reason != 'x')  die('ERR 98ddsssaa843 Cause fin menstruation::Naturelle : '.$natural_menopause_reason);
				$data_to_insert['menopause_onset_reason'] = "'natural'";
			}		
			$induced_menopause_reason = str_replace(array('ND', '-','oui'),array('','','x'),$line_data['Cause fin menstruation::Chirurgie/Provoquée']);
			if(strlen($induced_menopause_reason)) {
				if($induced_menopause_reason != 'x')  die('ERR 98dds111843 Cause fin menstruation::Chirurgie/Provoquée : '.$induced_menopause_reason);
				if(isset($data_to_insert['menopause_onset_reason'])) die('ERR ssaseyue');
				$data_to_insert['menopause_onset_reason'] = "'surgical/induced'";
			}	
			$chimio_menopause_reason = str_replace(array('ND', '-','oui'),array('','','x'),$line_data['Cause fin menstruation::Chimio/Radiothérapie']);	
			if(strlen($chimio_menopause_reason)) {
				if($chimio_menopause_reason != 'x')  die('ERR 98dds111843 Cause fin menstruation::Chimio/Radiothérapie : '.$chimio_menopause_reason);
				if(isset($data_to_insert['menopause_onset_reason'])) die('ERR sssaaaaaseyue');
				$data_to_insert['menopause_onset_reason'] = "'chemo/radio'";
			}

			$headers_list['Hormone de remplacement Oui-Non-S.R.'] = 'hrt_use';		
			$headers_list['Hormone de remplacement Oui-Non-S.R. (precision)'] = 'chus_hrt_use_precision';		
			$hrt_use = str_replace(array('ND', 'nd','-'), array('','',''), $line_data['Hormone de remplacement Oui-Non-S.R.']);
			$empty_test = str_replace(' ', '', $hrt_use);
			if(strlen($empty_test)) {
				if(preg_match('/^non {0,1}$/i',$hrt_use,$matches)) {
					$data_to_insert['hrt_use'] = "'no'";
				} else {
					$data_to_insert['hrt_use'] = "'yes'";
					if(!preg_match('/^oui {0,1}$/i',$hrt_use,$matches)) {
						if(preg_match('/^oui (.+)$/', $hrt_use, $matches)) {
							$data_to_insert['chus_hrt_use_precision'] = "'".$matches[1]. "'";
							Config::$summary_msg['PATIENT HISTORY']['@@MESSAGE@@']['Hormone de remplacement'][] = "Added precision to 'Hormone de remplacement' = 'oui': value [".$matches[1]."]! [line: $line_counter]";
						} else {
							$data_to_insert['chus_hrt_use_precision'] = "'$hrt_use'";
							Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Hormone de remplacement to confirm'][] = "Value '$hrt_use' will be defined as 'Hormone de remplacement' = 'oui'. The value will be added to precision! [line: $line_counter]";
						}
					}	
				}				
			}
			$headers_list['Durée Hormone (An)'] = 'hrt_years_used';			
			$hrt_years_used = str_replace(array('ND', '-'),array('',''),$line_data['Durée Hormone (An)']);
			if(strlen($hrt_years_used)) {
				if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $hrt_years_used, $matches)) die('ERR 98334000343 Durée Hormone : '.$hrt_years_used);
				$data_to_insert['hrt_years_used'] = "'$hrt_years_used'";
			}
			$headers_list['Tamoxifène / Évista  PRÉ OP (Oui-Non-ND)'] = 'chus_evista_use';	
			$headers_list['Tamoxifène / Évista  PRÉ OP (Oui-Non-ND) (precision)'] = 'chus_evista_use_precision';	
			$chus_evista_use = str_replace(array('ND','-'),array('',''), $line_data['Tamoxifène / Évista  PRÉ OP (Oui-Non-ND)']);
			if(strlen($chus_evista_use)) {
				if(preg_match('/^ {0,1}non {0,1}$/i', $chus_evista_use, $matches)) {
					$data_to_insert['chus_evista_use'] = "'no'";
				
				} else if(preg_match('/^oui {0,1}(.*)$/i', $chus_evista_use, $matches)) {
					$data_to_insert['chus_evista_use'] = "'yes'";
					if(!empty($matches[1])) $data_to_insert['chus_evista_use_precision'] = "'".$matches[1]."'";
				
				} else {
					$data_to_insert['chus_evista_use'] = "'yes'";
					$data_to_insert['chus_evista_use_precision'] = "'$chus_evista_use'";
					Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Tamoxifène / Évista'][] = "Value '$chus_evista_use' will be defined as 'Evista' = 'oui'. The value will be added to precision! [line: $line_counter]";
				}
			}	
			
			if(!empty($data_to_insert)) {
				if(!empty(Config::$patient_history_from_id[$participant_id]['reproduct_id'])) {
					$diff = array();
					foreach($headers_list as $file_field => $tmp_field) {
						$old_value =Config::$patient_history_from_id[$participant_id][$tmp_field];
						$new_value = isset($data_to_insert[$tmp_field])? preg_replace('/^\'(.*)\'$/', '$1', $data_to_insert[$tmp_field]): '';
						if((!empty($old_value) || !empty($new_value)) && ($new_value != $old_value)) {
							$diff[] =  utf8_decode($file_field) . ": new [$new_value] <=> old [$old_value]";
						}
					}
					if(!empty($diff)) {
						$tmp_msg = "There are conflicts between reproductive history defined both in step2 and 3 for frsq# $frsq_nbr! Data won't be updated and please check data! [line: $line_counter]";
						foreach($diff as $new_ex) $tmp_msg .= "<br> -> ".$new_ex;
						Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Reproductive history conflict'][] = $tmp_msg;
					}
				} else {
					$data_to_insert['participant_id'] = $participant_id;
					customInsertChusRecord($data_to_insert, 'reproductive_histories');	
				}
			}
			
			// ADD ATCD
			
			if(!isset(Config::$event_controls['clinical']['all']['past history'])) die('ERR 88998379');
			$event_control_id = Config::$event_controls['clinical']['all']['past history']['event_control_id'];
			$detail_tablename = Config::$event_controls['clinical']['all']['past history']['detail_tablename'];				
			
			$all_atcd_events = array();
			
			$headers_list = array(
				'ATCD Personnel::Ovaire::Bénin' => 'ovary - benin',
				'ATCD Personnel::Ovaire::Cancer' => 'ovary - cancer',
				'ATCD Personnel::Sein::Bénin' => 'breast - benin',
				'ATCD Personnel::Sein::Cancer' => 'breast - cancer',
				'ATCD Personnel::Utérus::Bénin' => 'uterus - benin',
				'ATCD Personnel::Utérus::Cancer' => 'uterus - cancer');	
			foreach($headers_list as $header => $type) {			
				if(!empty($line_data[$header])) {
					$event_data = array(
						'master' => array(
							'participant_id' => $participant_id,
							'event_control_id' =>  $event_control_id,
							'event_summary' => "'".str_replace("'","''",preg_replace(array('/^(oui {0,2})/', '/^\((.*)\)$/'), array('', '$1'), $line_data[$header]))."%%date_detail%%'"
							),
						'detail' => array('type' => "'$type'"));				
					$event_date_data = getAtcdDate($line_data[$header.'::Date'], $line_counter);
					
					if(!empty($event_date_data['date'])) {
						$event_data['master']['event_date'] = "'".$event_date_data['date']."'";
						$event_data['master']['event_date_accuracy'] = "'".$event_date_data['accuracy']."'";
					}
					if(!empty($event_date_data['note'])) {
						$event_data['master']['event_summary'] = str_replace('%%date_detail%%', ((($event_data['master']['event_summary'] == "'%%date_detail%%'")? 'Date Info: ' : ' // Date Info: ').str_replace("'","''",$event_date_data['note'])), $event_data['master']['event_summary']);
					} else {
						$event_data['master']['event_summary'] = str_replace('%%date_detail%%', '', $event_data['master']['event_summary']);
					}				
					if(array_key_exists($participant_id, Config::$personal_past_history_from_id) 
					&& array_key_exists($type, Config::$personal_past_history_from_id[$participant_id])) {
						$old_date = empty(Config::$personal_past_history_from_id[$participant_id][$type]['event_date'])? '' : Config::$personal_past_history_from_id[$participant_id][$type]['event_date'];
						$old_date_accuracy = empty(Config::$personal_past_history_from_id[$participant_id][$type]['event_date_accuracy'])? '' : Config::$personal_past_history_from_id[$participant_id][$type]['event_date_accuracy'];
						$old_summary = empty(Config::$personal_past_history_from_id[$participant_id][$type]['event_summary'])? '' : Config::$personal_past_history_from_id[$participant_id][$type]['event_summary'];
						
						$new_date =  isset($event_data['master']['event_date'])? $event_data['master']['event_date'] : '';
						$new_date_accuracy =  isset($event_data['master']['event_date_accuracy'])? $event_data['master']['event_date_accuracy'] : '';
						$new_summary =  $event_data['master']['event_summary'];
						
						if($old_date.$old_date_accuracy != $new_date.$new_date_accuracy) {
							Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['2 ATCD with different dates'][] = "A same type of ATCD '$type' is defined both in step2 and 3 for frsq# $frsq_nbr but event dates are different : $old_date ($old_date_accuracy) <=> $new_date ($new_date_accuracy)! 2 ATCD events will be created: please confirm! [line: $line_counter]";
						} else if($old_summary != $new_summary) {
							Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Same ATCD with different summary'][] = "A same type of ATCD '$type' with ".(empty($old_date)? 'no date' : "same date ($old_date ($old_date_accuracy))")." is defined both in step2 and 3 for frsq# $frsq_nbr but summaries are different :  [$old_summary] <=> [$new_summary] ! No new ATCD event will be created: please add summary if required! [line: $line_counter]";							
							$event_data = null;
						}
					}
					
					if(!empty($event_data)) $all_atcd_events[] = $event_data;
				}		
			}
		
			foreach($all_atcd_events as $new_atcd) {
				$event_master_id = customInsertChusRecord($new_atcd['master'], 'event_masters');	
				$new_atcd['detail']['event_master_id'] = $event_master_id;
				customInsertChusRecord($new_atcd['detail'], $detail_tablename, true);	
			}	
		}
	}
}

function editHistoryConflict($old_value, $new_value, $frsq_nbr, $field, $worksheet, $line) {
	if(!empty($old_value)) {
		if(empty($new_value)) {
//			Config::$summary_msg[$worksheet]['@@MESSAGE@@']['History Conflict #1'][] = "The value of field '$field' has been defined during step2 ($old_value) but this one is not defined in step3 (see frsq# $frsq_nbr)! Data in DB won't be updated please confirm! [line: $line]";
		} else if($old_value != $new_value) {
			Config::$summary_msg[$worksheet]['@@ERROR@@']['History Conflict #2'][] = "The value of field '$field' has been defined during step2 ($old_value) and step3 ($new_value) and are different (see frsq# $frsq_nbr)! Please resolve conflict! [line: $line]";
		}
	} else if(!empty($new_value)) {
//		Config::$summary_msg[$worksheet]['@@MESSAGE@@']['History Conflict #3'][] = "The value of field '$field' has been defined during step3 ($new_value) but this one is not defined in step2 (see frsq# $frsq_nbr)! Data in DB will be updated please confirm! [line: $line]";
	}
}

function getAtcdDate($date_string, $line_counter) {
	$date_string = preg_replace(array('/^-$/','/^nd$/','/^ND$/'),array('','',''), $date_string);
	if(!empty($date_string)) {
		if(preg_match('/^(19|20)([0-9]{2})$/', $date_string, $matches)) {
			return array('date' => "$date_string-01-01", 'accuracy' => 'm', 'note' => null);
		
		} else if(preg_match('/^(19|20)([0-9]{2})-([01][0-9])$/', $date_string, $matches)) {
			return array('date' => "$date_string-01", 'accuracy' => 'd', 'note' => null);
		
		} else if(preg_match('/^([01][0-9])-(19|20)([0-9]{2})$/', $date_string, $matches)) {
			return array('date' => $matches[2].$matches[3].'-'.$matches[1].'-01', 'accuracy' => 'd', 'note' => null);

		} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/', $date_string, $matches)) {
			return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c', 'note' => null);
			
		} else if(preg_match('/^(Jan|Mar|Apr|May|Jun|Aug|Sep|Nov)-(19|20)([0-9]{2})$/', $date_string, $matches)) {
			return array('date' => $matches[2].$matches[3].'-'.str_replace(array('Jan','Mar','Apr','May','Jun','Aug','Sep','Nov'), array('01','03','04','05','06','08','09','11'), $matches[1]).'-01', 'accuracy' => 'd', 'note' => null);

		} else if(preg_match('/^([03][0-9])-([01][0-9])-(19|20)([0-9]{2})$/', $date_string, $matches)) {
			return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c', 'note' => null);				
		
		} else {
			Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['ATCD date not supported'][] = "ATCD date '$date_string' is not supported and will be added to the note! [line: $line_counter]";							
			return array('date' => null, 'accuracy' => null, 'note' => $date_string);
		}
	}
	
	return array('date' => null, 'accuracy' => null, 'note' => null);
}

function addFamilyHistory() {
	global $connection;

	$tumors_list_matches = array(
		'vessie' => array('tumor' => 'bladder', 'origin' => ''),
		'os' => array('tumor' => 'bone', 'origin' => ''),
		'os métast' => array('tumor' => 'bone', 'origin' => 'secondary'),
		'cerveau' => array('tumor' => 'brain', 'origin' => ''),
		'sein' => array('tumor' => 'breast', 'origin' => ''),
		'ganglion' => array('tumor' => 'ganglion', 'origin' => ''),
		'ganglions' => array('tumor' => 'ganglion', 'origin' => ''),
		'généralisé' => array('tumor' => 'generalized', 'origin' => ''),
		'gynécologique' => array('tumor' => 'gynecological', 'origin' => ''),
		'gynecologique' => array('tumor' => 'gynecological', 'origin' => ''),
		'hodgkin' => array('tumor' => 'hodgkin', 'origin' => ''),
		'intestin' => array('tumor' => 'intestine', 'origin' => ''),
		'rein' => array('tumor' => 'kidney', 'origin' => ''),
		'leucemie' => array('tumor' => 'leukemia', 'origin' => ''),
		'leucémie' => array('tumor' => 'leukemia', 'origin' => ''),
		'larynx' => array('tumor' => 'larynx', 'origin' => ''),
		'sigmoide' => array('tumor' => 'sigmoide', 'origin' => ''),
		'poumon' => array('tumor' => 'lung', 'origin' => ''),
		'proumon' => array('tumor' => 'lung', 'origin' => ''),
		'lymphome' => array('tumor' => 'lymphoma', 'origin' => ''),
		'moelle' => array('tumor' => 'marrow', 'origin' => ''),
		'moëlle épinière' => array('tumor' => 'marrow', 'origin' => ''),
		'ovaire' => array('tumor' => 'ovary', 'origin' => ''),
		'pancreas' => array('tumor' => 'pancreas', 'origin' => ''),
		'pancréas' => array('tumor' => 'pancreas', 'origin' => ''),
		'prostate' => array('tumor' => 'prostate', 'origin' => ''),
		'rectum' => array('tumor' => 'rectum', 'origin' => ''),
		'colon' => array('tumor' => 'settler', 'origin' => ''),
		'estomac' => array('tumor' => 'stomach', 'origin' => ''),
		'estomas' => array('tumor' => 'stomach', 'origin' => ''),
		'testicule' => array('tumor' => 'testicle', 'origin' => ''),
		'testicules' => array('tumor' => 'testicle', 'origin' => ''),
		'utérus' => array('tumor' => 'uterus', 'origin' => ''),
		'angiosarcome' => array('tumor' => 'angiosarcoma', 'origin' => ''),
		'col utérus' => array('tumor' => 'cervix', 'origin' => ''),
		'endomètre' => array('tumor' => 'endometrial', 'origin' => ''),
		'foie' => array('tumor' => 'liver', 'origin' => ''),
		'foie métast' => array('tumor' => 'liver', 'origin' => 'secondary'),
		'gorge' => array('tumor' => 'throat', 'origin' => ''),
		'haine' => array('tumor' => 'groin', 'origin' => ''),
		'hypophyse' => array('tumor' => 'pituitary', 'origin' => ''),
		'inconnu' => array('tumor' => 'unknown', 'origin' => ''),
		'melanome' => array('tumor' => 'melanoma', 'origin' => ''),
		'mélanome' => array('tumor' => 'melanoma', 'origin' => ''),
		'myélome' => array('tumor' => 'myeloma', 'origin' => ''),
		'peau' => array('tumor' => 'skin', 'origin' => ''),
		'pénis' => array('tumor' => 'penis', 'origin' => ''),
		'oesophage' => array('tumor' => 'esophagus', 'origin' => ''),
		'thyroide' => array('tumor' => 'thyroid', 'origin' => ''),
		'vulve' => array('tumor' => 'vulva', 'origin' => '')
	);

	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('Historique Familial', $sheets_nbr)) die("ERROR: Worksheet Historique Familial is missing!\n");

	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr['Historique Familial']]['cells'] as $line => $new_line) {	
		$line_counter++;
		if($line_counter == 1) {
			// HEADER
			$headers = $new_line;
		
		} else {
			
			// SET DATA ARRAY
			
			$line_data = array();
			$frsq_nbr = '';
			foreach($headers as $key => $field) {
				if(isset($new_line[$key])) {
					$line_data[utf8_encode($field)] =  preg_replace(array('/( +)$/', '/^( +)/', '/^nd$/', '/^aucun$/', '/^aucune$/', utf8_decode('/^à venir$/')), array('','','','','',''), ($field == '#FRSQ')? $new_line[$key] : strtolower($new_line[$key]));
				} else {
					$line_data[utf8_encode($field)] = '';
				}
			}

			// GET PARTICIPANT ID
			
			if(empty($line_data['#FRSQ'])) die('ERR Missing #FRSQ in patient history worksheet line : '.$line_counter);
			$frsq_nbr = str_replace(' ', '', $line_data['#FRSQ']);
			
			$participant_id = isset(Config::$participant_id_from_br_nbr[$frsq_nbr])? Config::$participant_id_from_br_nbr[$frsq_nbr] : null;
			if(!$participant_id) {
				Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Unknown participant'][] = "The FRSQ# '".$line_data['#FRSQ']."' has beend assigned to a participant in step3 ('PATIENT HISTORY') but this number is not defined in step 1! [line: $line_counter]";
				continue;
			}	

			// CHECK PARTICIPANT ON MULTI ROW
			
			if(!isset(Config::$data_for_import_from_participant_id[$participant_id]['family_history_data'])) {
				Config::$data_for_import_from_participant_id[$participant_id]['family_history_data'] = $line_data;
			} else {				
				$data_diff_test = array_diff_assoc(Config::$data_for_import_from_participant_id[$participant_id]['family_history_data'], $line_data); 
				unset($data_diff_test['#FRSQ']);
				if(!empty($data_diff_test)) {
					//$diff_fields = "<br> - ".implode("<br> - ",array_keys($data_diff_test));
					$previous_frsq_nbr = Config::$data_for_import_from_participant_id[$participant_id]['family_history_data']['#FRSQ'];
					Config::$summary_msg['FAMILY HISTORY']['@@WARNING@@']['Duplicated Patient History'][] = "The FRSQ#s '".$line_data['#FRSQ']."' & '$previous_frsq_nbr' are assigned to the same patient but there are more than one row in 'Historique patiente' and data are different (just first one will be imported)! Please check data! [line: $line_counter]";//fields : $diff_fields";
				}
				continue;
			}

			$counter = 1;
			for($counter = 1; $counter < 7; $counter++) {
				$tumor_tmp = utf8_encode($line_data['Cancer #'.$counter]);
				$family_link_tmp = utf8_encode($line_data['Lien parenté #'.$counter]);
				if(empty($tumor_tmp) && empty($family_link_tmp)) continue;					
				
				if(!empty($tumor_tmp) && !isset($tumors_list_matches[$tumor_tmp])) Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Tumor value unknown'][] = "The 'Cancer' [$tumor_tmp] is not supported by the migration process (replace &OElig; by oe)! [line: $line_counter]";
//				if(!empty($relation) && !isset($relation_matches[$relation])) Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Family link value unknown'][] = "The 'Lien parenté' [$relation] is not supported by the migration process! [line: $line_counter]";
				if((!empty($tumor_tmp) && empty($family_link_tmp)) || (empty($tumor_tmp) && !empty($family_link_tmp))) Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Missing Data'][] = "At least one of the value of the follwoing fields is missing ('Cancer #$counter' & 'Lien parenté #$counter')! [line: $line_counter]";
				
				if(!empty($tumor_tmp) && isset($tumors_list_matches[$tumor_tmp]) && !empty($family_link_tmp)) {
					$tumor = $tumors_list_matches[$tumor_tmp]['tumor'];
					$origin = $tumors_list_matches[$tumor_tmp]['origin'];		
				
					$relation = '';
					$family_domain = '';
					$chus_notes = '';
					$age_at_dx = '';
					if(preg_match('/^(arr grand-père) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'great-grandfather';
					} else if(preg_match('/^(grand-mère) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'grandmother';
					} else if(preg_match('/^(g-mère) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'grandmother';
					} else if(preg_match('/^(grand-père) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'grandfather';
					
					} else if(preg_match('/^(père) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'father';
					} else if(preg_match('/^(mère) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'mother';
					
					} else if(preg_match('/^(frère) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'brother';
					}else if(preg_match('/^(soeur) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'sister';

					} else if(preg_match('/^(grand-oncle) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'great-uncle';
					} else if(preg_match('/^(grande-tante) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'great-aunt';
					
					} else if(preg_match('/^(fils) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'son';
					} else if(preg_match('/^(fille) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'daughter';
					} else if(preg_match('/^(tante) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'aunt';
					} else if(preg_match('/^(nièce) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'niece';
					} else if(preg_match('/^(petite-fille) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'granddaughter';
					} else if(preg_match('/^(cousine) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'cousin';
					} else if(preg_match('/^(cousin) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'cousin';
					} else if(preg_match('/^(oncle) {0,1}(.*)$/',$family_link_tmp,$matches)) {
						$relation = 'uncle';
					} else {
						Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Unable to define relation'][] = "Unable to extract relation from 'Lien parenté #$counter' ($family_link_tmp) ! [line: $line_counter]";
						continue;
					}
					if(isset($matches[2])) { 						
						$chus_notes = str_replace(array('(',')'), array('',''), $matches[2]);
						if(preg_match('/([0-9]{1,3}) {0,1}ans/', $chus_notes, $matches)) {
							$age_at_dx = $matches[1];
						}
						if(preg_match('/^p$|^pat$|^p[0-9]$|^p /', $chus_notes, $matches)) {
							$family_domain = 'paternal';
						} else if(preg_match('/^m$|^mat$|^m[0-9]$|^m /', $chus_notes, $matches)) {
							$family_domain = 'maternal';
						}
					}
					
					if(empty($relation) && empty($tumor)) die ('ERR889938933');
					
					$data_to_insert = array(
						'participant_id' => $participant_id,
						'relation' => "'$relation'",
						'chus_tumor_description' => "'$tumor'"
					);
					if(!empty($origin))  $data_to_insert['chus_tumor_origin'] = "'$origin'";
					if(!empty($family_domain))  $data_to_insert['family_domain'] = "'$family_domain'";
					if(!empty($chus_notes))  $data_to_insert['chus_notes'] = "'$chus_notes'";
					if(!empty($age_at_dx))  $data_to_insert['age_at_dx'] = "'$age_at_dx'";
					
					if(isset(Config::$family_history_from_id[$participant_id][$relation.'-'.$tumor])) {
						$data_for_test = array(
							'participant_id' => '',
							'relation' => '',
							'chus_tumor_description' => '',
							'chus_tumor_origin' => '',
							'family_domain' => '',
							'chus_notes' => '',
							'age_at_dx' => '');
						foreach($data_to_insert as $field => $value) $data_for_test[$field] = preg_replace('/^\'(.*)\'$/', '$1', $value);
						$diff_data = array_diff($data_for_test, Config::$family_history_from_id[$participant_id][$relation.'-'.$tumor]);
						if(!empty($diff_data)) {
							$str_msg = '';
							foreach($diff_data as $diff_field => $diff_val) $str_msg .= "$diff_field <=> $diff_val //";				
							Config::$summary_msg['FAMILY HISTORY']['@@WARNING@@']['Fam History Conflicts'][] = "$tumor tumor of $relation has already been recorded for $frsq_nbr during step 2 but data are not exaclty the same (see $str_msg): new data won't be imported. Please clean-up data! [line: $line_counter]";					
						}
						continue;
					}					
					
					customInsertChusRecord($data_to_insert, 'family_histories');
				}
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

function customInsertChusRecord($data_arr, $table_name, $is_detail_table = false, $flush_empty_fields = false) {
	global $connection;
	$created = $is_detail_table? array() : array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
	);
	
	if($flush_empty_fields) {
		$tmp = array();
		foreach($data_arr as $key => $value) {
			if(strlen($value) && ($value != "''")) $tmp[$key] = $value;
		}
		$data_arr = $tmp;
	}
	
	$insert_arr = array_merge($data_arr, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$record_id = mysqli_insert_id($connection);
	
	$rev_insert_arr = array_merge($data_arr, array('id' => "$record_id", 'version_created' => "NOW()"));
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query($connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	return $record_id;	
}

function customGetFormatedDate($date_strg, $worksheet, $line) {
	$date = null;
	
	if(!empty($date_strg)) {
		if(preg_match('/^([0-9]+)$/', $date_strg, $matches)) {
			//format excel date integer representation
			$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
			$xls_offset = 36526;//2000-01-01
			$date = date("Y-m-d", $php_offset + (($date_strg - $xls_offset) * 86400));
			
		} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/', $date_strg, $matches)) {
			$date = $date_strg;
		
		} else if(preg_match('/^(19|20)([0-9]{2})\-([1-9])\-([0-3][0-9])$/', $date_strg, $matches)) {
			$date = $matches[1].$matches[2].'-0'.$matches[3].'-'.$matches[4];
			
		} else {
			Config::$summary_msg[$worksheet]['@@ERROR@@']['Wrong excel date value format'][] = "The format of a date ($date_strg) into the excel file is wrong (line $line)! Date will be flushed!";
			$date = null;
		}
		
		if((!is_null($date)) && (!preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/', $date, $matches))) {
			Config::$summary_msg[$worksheet]['@@ERROR@@']['Wrong generated date format'][] = "The format of a date generated from file value is wrong (line $line): '$date_strg' => '$date'! Date will be flushed!";
			$date = null;
		}
	}
	
	return $date;
}

function getDateAndAccuracy($date) {
	if(empty($date)) {
		return null;
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$date,$matches)) {
		return array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])$/',$date,$matches)) {
		return array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else {
		die('ERR 83993272329');
	}	
}

//=========================================================================================================
// Collections Creation
//=========================================================================================================

function addCollections() {
	//TODO Veut on créer des realiquotés pour les shipped?
	
	global $connection;
	global $next_sample_code;
	global $next_aliquot_code;
	
	$query = "SELECT MAX(CAST(sample_code AS UNSIGNED)) AS last_sample_code from sample_masters;";
	$results = mysqli_query($connection, $query) or die("addCollections [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if(!isset($row['last_sample_code'])) die("ERR 889dadadad494094");
	$next_sample_code = $row['last_sample_code'] + 1;
	
	$query = "SELECT MAX(CAST(barcode AS UNSIGNED)) AS last_aliquot_code from aliquot_masters;";
	$results = mysqli_query($connection, $query) or die("addCollections [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if(!isset($row['last_aliquot_code'])) die("ERR 8894940ddssdsdds94");
	$next_aliquot_code = $row['last_aliquot_code'] + 1;	
	
	global $shipping_list;
	$shipping_list = array();
	
	// ASCITE & TISSUE
	
	$collections_to_create = array();
	
	$collections_to_create = loadTissueCollection($collections_to_create);
	
	$dnas_from_br_nbr = loadDNACollection();
	$collections_to_create = loadBloodCollection($collections_to_create, $dnas_from_br_nbr);

	createCollection($collections_to_create);
}

function loadTissueCollection($collections_to_create) {
		
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('Tissus Disponible', $sheets_nbr)) die("ERROR: Worksheet Tissus Disponible is missing!\n");

	$headers = array();
	$line_counter = 0;
	
	foreach($tmp_xls_reader->sheets[$sheets_nbr['Tissus Disponible']]['cells'] as $line => $new_line) {	
		$line_counter++;
		if($line_counter == 1) {
			// HEADER
			$headers = $new_line;
		
		} else {
			
			// SET DATA ARRAY
			
			$line_data = array();
			$frsq_nbr = '';
			foreach($headers as $key => $field) {
				if(isset($new_line[$key])) {
					$line_data[utf8_encode($field)] = $new_line[$key];
				} else {
					$line_data[utf8_encode($field)] = '';
				}
			}
			
			if(!empty($line_data['# FRSQ']) || !empty($line_data['Échantillon']) || strlen($line_data['Volume/Qté'])) {
				$empty_fields = '';
				if(empty($line_data['# FRSQ'])) $empty_fields = '# FRSQ';
				if(empty($line_data['Échantillon'])) $empty_fields .= (empty($empty_fields)? '' : ', ').'Échantillon';
				if(!strlen($line_data['Volume/Qté'])) $empty_fields .= (empty($empty_fields)? '' : ', ').'Volume/Qté';
				
				if(!empty($empty_fields)) {
					Config::$summary_msg['TISSU']['@@ERROR@@']['Empty fields'][] = "No $empty_fields: Row data won't be migrated! [line: $line_counter]";
					continue;					
				}
			} else {
				continue;
			}
			
			// GET Participant Id & Misci Identifier Id & FRSQ Nbr
					
			$frsq_value = preg_replace('/ +$/','',$line_data['# FRSQ']);
			
			$participant_id = isset(Config::$participant_id_from_br_nbr[$frsq_value])? Config::$participant_id_from_br_nbr[$frsq_value] : null;
			if(!$participant_id) {
				Config::$summary_msg['TISSU']['@@ERROR@@']['Unknown participant'][] = "The FRSQ# '$frsq_value' has beend assigned to a participant but this number is not defined in step 1! [line: $line_counter]";
				continue;
			}	
			
			$misc_identifier_id = Config::$misc_identifier_id_from_br_nbr[$frsq_value];
			
			$diagnosis_master_id = null;
			if(array_key_exists('br_diagnosis_ids', Config::$data_for_import_from_participant_id[$participant_id])
			&& array_key_exists($frsq_value, Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'])) {
				if(sizeof(Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'][$frsq_value]) > 1) {
					Config::$summary_msg['TISSU']['@@WARNING@@']['Too many BR Dx can be linked to sample'][] = "The patient having #FRSQ [$frsq_value] has many breast diagnoses to link to the collection! Then collection has to be linked to a diagnosis after migration process! [line: $line_counter]";
				} else if (!sizeof(Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'][$frsq_value])) {
					Config::$summary_msg['TISSU']['@@WARNING@@']['No BR Dx can be linked to sample'][] = "The patient having #FRSQ [$frsq_value] has no breast diagnosis to link to the collection! [line: $line_counter]";
				} else {
					$diagnosis_master_id = Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'][$frsq_value][0];
				}
			}
		
			// GET CONSENT_MASTER_ID	
					
			$consent_master_id = isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'])? Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] : null;
	
			// BUILD COLLECTION
			
			$collection_date = '';
			$collection_date_accuracy = '';
			$line_data['Date collecte'] = str_replace('ND','', $line_data['Date collecte']);
			if(!empty($line_data['Date collecte'])) {
				$collection_date = customGetFormatedDate($line_data['Date collecte'], 'TISSU', $line_counter).' 00:00:00';
				$collection_date_accuracy = 'h';
			}
			
			$collection_key = "participant_id=$participant_id#misc_identifier_id=".(empty($misc_identifier_id)?'':$misc_identifier_id)."#diagnosis_master_id=".(empty($diagnosis_master_id)?'':$diagnosis_master_id)."#date=$collection_date";
			
			if(!isset($collections_to_create[$collection_key])) {
				$collections_to_create[$collection_key] = array(
					'link' => array(
						'participant_id' => $participant_id, 
						'misc_identifier_id' => $misc_identifier_id, 
						'diagnosis_master_id' => $diagnosis_master_id,
						'consent_master_id' => $consent_master_id),
					'collection' => array(
						'collection_datetime' => "'$collection_date'", 
						'collection_datetime_accuracy' => "'$collection_date_accuracy'"),
					'inventory' => array());
			}
			
			// Tissue
			
			$line_data['Heure Réception'] = str_replace(array('ND','?',' ', '-'),array('','','',''),$line_data['Heure Réception']);
			if(!empty($line_data['Heure Réception']) && empty($collection_date)) { 
				Config::$summary_msg['TISSU']['@@ERROR@@']['Reception time defined but no collection date'][] = "Reception date & time won't be imported! [line: $line_counter]";
				$line_data['Heure Réception'] = '';
			}
			if(!empty($line_data['Heure Réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Réception'], $matches)) die('ERR  ['.$line_counter.'] fafasassa be sure cell custom format is h:mm ['.$line_data['Heure Réception'].']');
			$reception_datetime = (!empty($line_data['Heure Réception']))? str_replace('00:00:00', $line_data['Heure Réception'].':00', $collection_date) : $collection_date;
			$reception_datetime_accuracy = (!empty($line_data['Heure Réception']))? 'c' : $collection_date_accuracy;
			
			$tissue_key = $reception_datetime.$line_data['Échantillon'];
			if(!isset($collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key])) {
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_masters'] = array('notes' => "''");
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['specimen_details'] = array('reception_datetime' => "'$reception_datetime'", 'reception_datetime_accuracy' => "'$reception_datetime_accuracy'");
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['derivatives'] = array();
				
				if(preg_match('/^.*BR(N|C)[0-9]{1,4}.*$/', $line_data['Échantillon'], $matches)) {
					switch($matches[1]) {
						case 'N':
							$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_details']['tissue_nature'] = "'normal'";
							break;
						case 'C':
							$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_details']['tissue_nature'] = "'tumoral'";
							break;
						default:							
					}
				}
			}
			
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
			$line_data['Heure congélation'] = str_replace('ND','',$line_data['Heure congélation']);
			if(!empty($line_data['Date collecte'])) {
				$storage_datetime = customGetFormatedDate($line_data['Date collecte'], 'TISSU', $line_counter).' 00:00:00';
				$storage_datetime_accuracy = 'h';
				if(!empty($line_data['Heure congélation'])) {
					if(!preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure congélation'], $matches)) die('ERR  ['.$line_counter.'] 89000eqweddd4');
					$storage_datetime = str_replace('00:00:00', $line_data['Heure congélation'].':00', $storage_datetime);
					$storage_datetime_accuracy = 'c';
				}
			} else if(!empty($line_data['Heure congélation'])) {
				Config::$summary_msg['TISSU']['@@ERROR@@']['Storage time defined but no collection date'][] = "Storage date & time won't be imported! [line: $line_counter]";
			}
			
			$remisage = strtolower(str_replace(array(' ','ND', '?'), array('','',''), $line_data['Temps au remisage']));
			if(!empty($remisage)) {
				if(!in_array($remisage, array('<1h','1h<<4h','4h<','<8h'))) {				
					if($remisage == '<4h') {
						$remisage = '1h<<4h';
					} else if(preg_match('/^00:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '<1h';
					} else if(preg_match('/^0[1-3]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '1h<<4h';
					} else if(preg_match('/^0[4-7]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '<8h';
					} else if(preg_match('/^0[8-9]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '8h<';	
					} else if(preg_match('/^[1-9][0-9]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '8h<';	
					} else if($remisage == '>12H') {
						$remisage = '8h<';
					} else {
						Config::$summary_msg['TISSU']['@@ERROR@@']['Remisage error'][] = "unsupported remisage value : $remisage (be sure cell custom format is h:mm)! [line: $line_counter]";
						$remisage = '';
					}
				}	
			}	
			
			$stored_tissue_positions = array();
			$tmp_intial_emplacement = $line_data['Emplacement'];
			$line_data['Emplacement'] = preg_replace('/0([0-9])/','$1', str_replace(array(' ','.','-'),array('',',',','), $line_data['Emplacement']));			
			$line_data['Boite'] = str_replace(array(' '),array(''), $line_data['Boite']);
			if(!empty($line_data['Emplacement'])) {
				// Created stored aliquot
				if(empty($line_data['Boite'])) die('ERR  ['.$line_counter.'] 88990rrr373 '.$line_data['Boite'].'//'.$line_data['Emplacement']);
				
				if(preg_match('/(.*81),(1.*)/', $line_data['Emplacement'], $matches_pos)) {
					
					// 2 Boxes
					
					if(preg_match('/^(sein)([0-9]+)[\-\,\/]([0-9]+)$/', $line_data['Boite'], $matches_box)) {
						foreach(explode(',',$matches_pos[1]) as $new_pos) $stored_tissue_positions[] = array('box' => $matches_box[1].$matches_box[2], 'pos' => $new_pos);
						foreach(explode(',',$matches_pos[2]) as $new_pos) $stored_tissue_positions[] = array('box' => $matches_box[1].$matches_box[3], 'pos' => $new_pos);
					} else {
						die('ERRR storage emplacement x2 '.$line_data['Boite']);
					}
				
				} else {				
					// 1 Box
					
					if(preg_match('/^(sein)([0-9]+)[\-\,\/]([0-9]+)$/', $line_data['Boite'], $matches_box)) die('ERR  ['.$line_counter.'] 884431a3 '.$line_data['Boite'].'//'.$line_data['Emplacement']);
					$prev_pos = 0;
					foreach(explode(',',$line_data['Emplacement']) as $new_pos) {
						if($new_pos <= $prev_pos)  die('ERR  ['.$line_counter.'] 884433113 '.$line_data['Boite'].'//'.$line_data['Emplacement']);
						$stored_tissue_positions[] = array('box' => $line_data['Boite'], 'pos' => $new_pos);
						$prev_pos = $new_pos;
					}
				}
			}		
			
			$aliquot_label = $line_data['Échantillon'];
			
			$nbr_of_created_aliquot = 0;
			$nbr_of_stored_aliquots = 0;
			foreach($stored_tissue_positions as $key => $new_stored_aliquot) {
				$storage_master_id = getStorageId('tissue', 'box81', $new_stored_aliquot['box']);
				$new_pos =  $new_stored_aliquot['pos'];
				
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['aliquots'][] = array(
					'aliquot_masters' => array(
						'aliquot_label' => "'$aliquot_label'", 
						'in_stock' => "'yes - available'",
						'storage_master_id' => "'$storage_master_id'",
						'storage_datetime' => "'$storage_datetime'",
						'storage_datetime_accuracy' => "'$storage_datetime_accuracy'",
						'storage_coord_x' => "'$new_pos'",
						'storage_coord_y' => "''",
						'chus_time_limit_of_storage' => "'$remisage'"),				
					'aliquot_details' => array(),
					'aliquot_internal_uses' => array(),
					'shippings' => array()
				);

				$nbr_of_created_aliquot++;
				$nbr_of_stored_aliquots++;
			}
			
			$shipped_aliquots = array();
			$test_empty = str_replace(' ','',$line_data['Dons']);
			if(strlen($test_empty)) {
				$new_shipments = explode(',', str_replace("\n", '', utf8_encode($line_data['Dons'])));
				foreach($new_shipments as $new_shipment) {
					$new_shipment = preg_replace('/^1X/', '1',$new_shipment );
					$shipped_aliquots_nbr = 0;
					$recipient = '';
					$shipping_datetime = '';
					$shipping_datetime_accuracy = '';
					
					if(preg_match('/^ {0,1}([0-9]+) {0,1}\? {0,1}$/',$new_shipment, $matches)) {
						$shipped_aliquots_nbr = $matches[1];
						$recipient = '???';
					}  else if(preg_match('/^ {0,1}([0-9]+) {0,1}FT {0,1}\? {0,1}$/',$new_shipment, $matches)) {
						$shipped_aliquots_nbr = $matches[1];
						$recipient = 'FT';
					} else if(preg_match('/^ {0,1}([0-9]+) {0,1}(.*) {0,1}(06|07|08)-(0[0-9]|1[0-2])-([0-2][0-9]|30|31) {0,1}$/', $new_shipment, $matches)) {
						$shipped_aliquots_nbr = $matches[1];
						$recipient = $matches[2];
						$shipping_datetime = '20'.$matches[3]."-".$matches[4]."-".$matches[5]." 00:00:00";
						$shipping_datetime_accuracy = 'h';
					} else if(preg_match('/^ {0,1}([0-9]+) {0,1}(.*) {0,1}([0-2][0-9]|30|31)-(0[0-9]|1[0-2])-(06|07|08) {0,1}$/', $new_shipment, $matches)) {
						$shipped_aliquots_nbr = $matches[1];
						$recipient = $matches[2];
						$shipping_datetime = '20'.$matches[5]."-".$matches[4]."-".$matches[3]." 00:00:00";
						$shipping_datetime_accuracy = 'h';
					} else {
						Config::$summary_msg['TISSU']['@@ERROR@@']['Unsupported shipping information'][] = "The shipping information format ($new_shipment) is not supported by the migration process (good one can be [1 GDM 29-06-06]). No shipped aliquot will be created! [line: $line_counter]";
						$shipped_aliquots_nbr = 0;
					}
					
					for($i=0;$i<$shipped_aliquots_nbr;$i++) {
						$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['aliquots'][] = array(
							'aliquot_masters' => array(
								'aliquot_label' => "'$aliquot_label'", 
								'in_stock' => "'no'",
								'in_stock_detail' => "'shipped'",
								'storage_master_id' => "''",
								'storage_datetime' => "'$storage_datetime'",
								'storage_datetime_accuracy' => "'$storage_datetime_accuracy'",
								'storage_coord_x' => "''",
								'storage_coord_y' => "''",
								'chus_time_limit_of_storage' => "'$remisage'"),				
							'aliquot_details' => array(),
							'aliquot_internal_uses' => array(),
							'shippings' => array(
								'recipient' => "'$recipient'",
								'shipping_datetime' => "'$shipping_datetime'",
								'shipping_datetime_accuracy' => "'$shipping_datetime_accuracy'"));
						$nbr_of_created_aliquot++;
					}
				}
			}
			
			// QUANTITY CHECK
			
			if($line_data['Volume/Qté'] != $nbr_of_stored_aliquots) Config::$summary_msg['TISSU']['@@ERROR@@']['Stored aliquots nbr mis-match'][] = "$nbr_of_stored_aliquots aliquots have been defined as stored by the process but the Volume/Qté defined into the file was equal to ".$line_data['Volume/Qté']. "('Emplacement' = $tmp_intial_emplacement)! [line: $line_counter]";
			if(!$nbr_of_created_aliquot) Config::$summary_msg['TISSU']['@@ERROR@@']['No created aliquot'][] = "No aliquot has been created from this line! [line: $line_counter]";
			
		} // End new line
	}
	
	return $collections_to_create;
}

function loadBloodCollection($collections_to_create, &$dnas_from_br_nbr) {
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('Plasma Disponible', $sheets_nbr)) die("ERROR: Worksheet Plasma Disponible is missing!\n");

	$headers = array();
	$line_counter = 0;
	
	foreach($tmp_xls_reader->sheets[$sheets_nbr['Plasma Disponible']]['cells'] as $line => $new_line) {	
		$line_counter++;
		if($line_counter == 1) {
			// HEADER
			$headers = $new_line;
		
		} else {
			
			// SET DATA ARRAY
			
			$line_data = array();
			$frsq_nbr = '';
			foreach($headers as $key => $field) {
				if(isset($new_line[$key])) {
					$line_data[utf8_encode($field)] = $new_line[$key];
				} else {
					$line_data[utf8_encode($field)] = '';
				}
			}	
			
			if(empty($line_data['# FRSQ'])) {
				Config::$summary_msg['BLOOD']['@@ERROR@@']['Empty fields'][] = "No '# FRSQ': Row data won't be migrated! [line: $line_counter]";
				continue;					
			}
			
			// GET Participant Id & Misci Identifier Id & FRSQ Nbr
					
			$frsq_value = preg_replace('/ +$/','',$line_data['# FRSQ']);

			$participant_id = isset(Config::$participant_id_from_br_nbr[$frsq_value])? Config::$participant_id_from_br_nbr[$frsq_value] : null;
			if(!$participant_id) {
				Config::$summary_msg['BLOOD']['@@ERROR@@']['Unknown participant'][] = "The FRSQ# '$frsq_value' has beend assigned to a participant but this number is not defined in step 1! [line: $line_counter]";
				continue;
			}	
			
			$misc_identifier_id = Config::$misc_identifier_id_from_br_nbr[$frsq_value];
			
			$diagnosis_master_id = null;
			if(array_key_exists('br_diagnosis_ids', Config::$data_for_import_from_participant_id[$participant_id])
			&& array_key_exists($frsq_value, Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'])) {
				if(sizeof(Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'][$frsq_value]) > 1) {
					Config::$summary_msg['BLOOD']['@@WARNING@@']['Too many BR Dx can be linked to sample'][] = "The patient having #FRSQ [$frsq_value] has many breast diagnoses to link to the collection! Then collection has to be linked to a diagnosis after migration process! [line: $line_counter]";
				} else if (!sizeof(Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'][$frsq_value])) {
					Config::$summary_msg['BLOOD']['@@WARNING@@']['No BR Dx can be linked to sample'][] = "The patient having #FRSQ [$frsq_value] has no breast diagnosis to link to the collection! [line: $line_counter]";
				} else {
					$diagnosis_master_id = Config::$data_for_import_from_participant_id[$participant_id]['br_diagnosis_ids'][$frsq_value][0];
				}
			}

			// GET CONSENT_MASTER_ID	
					
			$consent_master_id = isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'])? Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] : null;
	
			// Collection
			
			$collection_date = '';
			$collection_date_accuracy = '';
			if(!empty($line_data['Date Réception'])) {
				$collection_date = customGetFormatedDate($line_data['Date Réception'], 'BLOOD', $line_counter).' 00:00:00';
				$collection_date_accuracy = 'h';
			}
			
			$collection_key = "participant_id=$participant_id#misc_identifier_id=".(empty($misc_identifier_id)?'':$misc_identifier_id)."#diagnosis_master_id=".(empty($diagnosis_master_id)?'':$diagnosis_master_id)."#date=$collection_date";
			
			if(!isset($collections_to_create[$collection_key])) {
				$collections_to_create[$collection_key] = array(
					'link' => array(
						'participant_id' => $participant_id, 
						'misc_identifier_id' => $misc_identifier_id, 
						'diagnosis_master_id' => $diagnosis_master_id,
						'consent_master_id' => $consent_master_id),
					'collection' => array(
						'collection_datetime' => "'$collection_date'", 
						'collection_datetime_accuracy' => "'$collection_date_accuracy'"),
					'inventory' => array());
			}
			
			// Blood
			
			$line_data['Heure réception'] = str_replace(array('ND','?',' ', '-'),array('','','',''),$line_data['Heure réception']);
			if(!empty($line_data['Heure réception']) && empty($collection_date)) { 
				Config::$summary_msg['BLOOD']['@@ERROR@@']['Reception time defined but no collection date'][] = "Reception date & time won't be imported! [line: $line_counter]";
				$line_data['Heure réception'] = '';
			}
			if(!empty($line_data['Heure réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure réception'], $matches)) die('ERR  ['.$line_counter.'] fafasassa be sure cell custom format is h:mm ['.$line_data['Heure réception'].']');
			$reception_datetime = (!empty($line_data['Heure réception']))? str_replace('00:00:00', $line_data['Heure réception'].':00', $collection_date) : $collection_date;
			$reception_datetime_accuracy = (!empty($line_data['Heure réception']))? 'c' : $collection_date_accuracy;
			
			if(!isset($collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime])) {
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['sample_masters'] = array('notes' => "''");
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['specimen_details'] = array('reception_datetime' => "'$reception_datetime'", 'reception_datetime_accuracy' => "'$reception_datetime_accuracy'");
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives'] = array();
				
				// Add DNA first
				if(array_key_exists($frsq_value, $dnas_from_br_nbr)) {
					$add_to_collection = true;
					$tmp_reception_datetime = str_replace(array(' ','-',':',"'"), array('','','',''), $reception_datetime);
					foreach($dnas_from_br_nbr[$frsq_value] as $new_dna) {
						$tmp_creation_datetime = str_replace(array(' ','-',':',"'"), array('','','',''), $new_dna['derivative_details']['creation_datetime']);
						if(empty($tmp_reception_datetime) && empty($tmp_creation_datetime)) {
							//Nothing to do
						} else if(empty($tmp_reception_datetime) && !empty($tmp_creation_datetime)) {
							Config::$summary_msg['DNA']['@@WARNING@@']['DNA creation & Blood reception conflict (1)'][] = "Added a DNA sample to a collection with no reception date! See ".$frsq_value." and validate!";
						} else if(!empty($tmp_reception_datetime) && empty($tmp_creation_datetime)) {
							Config::$summary_msg['DNA']['@@WARNING@@']['DNA creation & Blood reception conflict (2)'][] = "Added a DNA sample with no extraction date to a collection! See ".$frsq_value." and validate!";
						} else {
							if(($tmp_creation_datetime < $tmp_reception_datetime)) {
								$add_to_collection = false;
								Config::$summary_msg['DNA']['@@ERROR@@']['DNA creation & Blood reception error'][] = "DNA extaction (".$new_dna['derivative_details']['creation_datetime'].") is done before BLOOD collection ($reception_datetime) for frsq nbr ".$frsq_value."! No DNA will be created!";
							}
						}
					}
					if($add_to_collection) $collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['dna'] = $dnas_from_br_nbr[$frsq_value];
					unset($dnas_from_br_nbr[$frsq_value]);
				}
			}
			
			// Plasma
			
			$centrifugation_date = '';
			$centrifugation_date_accuracy = '';
			if(!empty($line_data['Date traitement'])) {
				$centrifugation_date = customGetFormatedDate($line_data['Date traitement'], 'BLOOD', $line_counter).' 00:00:00';
				$centrifugation_date_accuracy = 'h';
			}
			
			// plasma
			
			if(!isset($collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'])) {
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['sample_masters'] = array('notes' => "'".str_replace("'","''",utf8_encode( $line_data['Notes']))."'");
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['derivative_details'] = array('creation_datetime' => "'$centrifugation_date'", 'creation_datetime_accuracy' => "'$centrifugation_date_accuracy'");
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['derivatives'] = array();
			} else {
				if(strlen($line_data['Notes'])) die('ERR 99389399393 '.$line_counter);
			}			
			
			// plasma Tube
			
			$aliquot_label = $line_data['Échantillon'];
			
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
			$line_data['Heure Congélation'] = str_replace('ND','',$line_data['Heure Congélation']);
			if(!empty($line_data['Date traitement'])) {
				$storage_datetime = customGetFormatedDate($line_data['Date traitement'], 'BLOOD', $line_counter).' 00:00:00';
				$storage_datetime_accuracy = 'h';
				if(!empty($line_data['Heure Congélation'])) {
					if(!preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Congélation'], $matches)) die('ERR  ['.$line_counter.'] 89000ddd4');
					$storage_datetime = str_replace('00:00:00', $line_data['Heure Congélation'].':00', $storage_datetime);
					$storage_datetime_accuracy = 'c';
				}
			} else if(!empty($line_data['Heure Congélation'])) {
				die('ERR ['.$line_counter.'] 99994884');
			}
			
			if(!empty($collection_date) && !empty($storage_datetime)) {
				$collection_date_tmp = str_replace(array(' ', ':', '-'), array('','',''), $collection_date);
				$storage_datetime_tmp = str_replace(array(' ', ':', '-'), array('','',''), $storage_datetime);
				if($storage_datetime_tmp < $collection_date_tmp) Config::$summary_msg['BLOOD']['@@ERROR@@']['Collection & Storage Dates'][] = "Sotrage should be done after collection. Please check collection and storage date! [line: $line_counter]";
			}
			
			$created_aliquots = 0;
			
			$emplacement = str_replace(array(' ', '/', '--'),array('', ',', '-'), $line_data['Emplacement']);
			if(!empty($emplacement)) {
				
				// Created stored aliquot
				
				$aliquot_positions = array();
				
				$boite = str_replace(array(' ', '-', '.', '/'),array('',',',',',','), $line_data['Boite']);
				if(empty($boite)) die('ERR  ['.$line_counter.'] 8899034423273 '.$line_data['Boite'].' // '.$line_data['Emplacement']);
				
				if(preg_match('/^([0-9]+)$/', $boite, $matches)) {
					// - 1 - Box
					if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 33
						$aliquot_positions[] = array('box_label' => $boite, 'position' => $emplacement);
					} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 12-33
						if($matches[2] < $matches[1]) {
							Config::$summary_msg['DNA']['@@ERROR@@']['positions error'][] = "DNA positions $emplacement can not be imported: ".$matches[1]." > ".$matches[2] ."! [line: $line_counter]";
						} else {
							for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $boite, 'position' => $i);
						}	
					} else {
						Config::$summary_msg['BLOOD']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the blood aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
					}
					
				} else if(preg_match('/^([0-9]+),([0-9]+)$/', $boite, $matches)) {
					$boite_1_label = $matches[1];
					$boite_2_label = $matches[2];
					
					if(preg_match('/^([0-9]+-{0,1}[0-9]*),([0-9]+-{0,1}[0-9]*)$/', $emplacement, $matches)) {
						foreach(array($boite_1_label => $matches[1], $boite_2_label => $matches[2]) as $box => $positions)
						
							if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $positions, $matches)) {
								// 33
								$aliquot_positions[] = array('box_label' => $box, 'position' => $positions);
							} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $positions, $matches)) {
								// 12-33
								if($matches[2] < $matches[1]) die('ERR 78939ddw393 '.$emplacement);
								for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $box, 'position' => $i);	
							} else {
								Config::$summary_msg['BLOOD']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the blood aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
							}
					} else {
						Config::$summary_msg['BLOOD']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the blood aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";		
					}		
				} else  {
					die('ERR 89948793993 39 83 92 : '.$boite);
				}
				
				foreach($aliquot_positions as $new_stored_aliquot) {
					$storage_master_id = getStorageId('plasma', 'box100', $new_stored_aliquot['box_label']);
					
					$created_aliquots++;
					$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['aliquots'][] = array(
						'aliquot_masters' => array(
							'aliquot_label' => "'$aliquot_label'", 
//							'initial_volume' => "'1'",
//							'current_volume' => "'1'",
							'in_stock' => "'yes - available'",
							'storage_master_id' => "'$storage_master_id'",
							'storage_datetime' => "'$storage_datetime'",
							'storage_datetime_accuracy' => "'$storage_datetime_accuracy'",
							'storage_coord_x' => "'".$new_stored_aliquot['position']."'",
							'storage_coord_y' => "''"),				
						'aliquot_details' => array(),
						'aliquot_internal_uses' => array(),
						'shippings' => array()
					);
				}
			}
			
			// QUANTITY CHECK
			
			if(($line_data['Volume/Qté'] != '-') && ($line_data['Volume/Qté'] != $created_aliquots)) Config::$summary_msg['BLOOD']['@@ERROR@@']['Stored aliquots nbr mis-match'][] = "$created_aliquots aliquots have been defined as stored by the process but the 'Qté' defined into the file was equal to ".$line_data['Volume/Qté']. "('Emplacement' = ".$line_data['Emplacement'].")! [line: $line_counter]";
			if(!$created_aliquots) Config::$summary_msg['BLOOD']['@@ERROR@@']['No aliquot created'][] = "No shipped or stored aliquot has been created! [line: $line_counter]";

		} // End new line
	}
	
	if(!empty($dnas_from_br_nbr)) {		
		$ov_nbrs = array_keys($dnas_from_br_nbr);
		$ov_nbrs = implode(', ', $ov_nbrs);
		Config::$summary_msg['DNA']['@@ERROR@@']['DNA not found in Blood'][] = "The following OV NBRs are found in DNA worksheet but not found into blood worksheet: ".$ov_nbrs."! Won't be imported! [line: $line_counter]";
	}
	
	return $collections_to_create;	
}

function loadDNACollection() {
	
	$dnas_from_br_nbr = array();
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('ADN Disponible', $sheets_nbr)) die("ERROR: Worksheet ADN Disponible is missing!\n");

	$headers = array();
	$line_counter = 0;
	
	foreach($tmp_xls_reader->sheets[$sheets_nbr['ADN Disponible']]['cells'] as $line => $new_line) {	
		$line_counter++;
		if($line_counter == 1) {
			// HEADER
			$headers = $new_line;
			
		} else {
			
			// SET DATA ARRAY
			
			$line_data = array();
			$frsq_nbr = '';
			foreach($headers as $key => $field) {
				if(isset($new_line[$key])) {
					$line_data[utf8_encode($field)] = $new_line[$key];
				} else {
					$line_data[utf8_encode($field)] = '';
				}
			}
			
			if(empty($line_data['# FRSQ']) || !strlen($line_data['Qté en ug'])) {
				Config::$summary_msg['DNA']['@@ERROR@@']['Empty fields'][] = "No '# FRSQ' or 'Qté en ug': Row data won't be migrated! [line: $line_counter]";
				continue;					
			}
			
			// GET Sample Data
					
			$br_nbr = preg_replace('/ +$/','',$line_data['# FRSQ']);
			
			$extraction_date = '';
			$extraction_date_accuracy = '';
			if(!array_key_exists("Date extraction", $line_data)) die('ERR MISSING Date extraction');
			if(!empty($line_data['Date extraction'])) {
				$extraction_date = customGetFormatedDate($line_data['Date extraction'], 'DNA', $line_counter).' 00:00:00';
				$extraction_date_accuracy = 'h';
			}		
			
			$new_dna = array(
				'sample_masters' => array(),
				'sample_details' => array(),
				'derivative_details' => array('creation_datetime' => "'$extraction_date'", 'creation_datetime_accuracy' => "'$extraction_date_accuracy'"),
				'aliquots' => array(),
				'derivatives' => array());
			
			// GET Aliquot Data
			
			$aliquot_label = preg_replace('/ +$/','',$line_data['Échantillons']);
			
			$current_weight = $line_data['Qté en ug'];		
			if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', '9', $matches)) {
				Config::$summary_msg['DNA']['@@ERROR@@']['Qté format'][] = "The format of the Qté value ($inital_weight) is not supported! No row data will be imported! [line: $line_counter]";
				continue;
			}
			
			$concentration = '';
			if(strlen($line_data['Concentration (ug/ml)'])) {
				$concentration = $line_data['Concentration (ug/ml)'];
				if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $concentration, $matches)) {
					Config::$summary_msg['DNA']['@@WARNING@@']['Concentration format'][] = "The format of the concentration value ($concentration) is not supported! Please complete after migration! [line: $line_counter]";
					$concentration = '';
				}
			}
			
			$ratio = '';
			if(strlen($line_data['Ratio 260/280']) && ($line_data['Ratio 260/280'] != 'ND')) {
				$ratio = $line_data['Ratio 260/280'];
				if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $ratio, $matches)) {
					Config::$summary_msg['DNA']['@@WARNING@@']['Ratio format'][] = "The format of the Ratio value ($ratio) is not supported! Please complete after migration! [line: $line_counter]";
					$ratio = '';
				}
			}			
			
			$aliquot_notes = '';
			if(strlen($line_data['Dons'])) {
				if(utf8_encode($line_data['Dons']) != "Traitement pour WBC terminé le 11-08-2011. Centrifugé seulement 11 minutes.") die('TODO: SUPPORT DONS');
				$aliquot_notes = str_replace("'", "''", utf8_encode($line_data['Dons']));
			}
			
			//Boite	Emplacement
			
			$emplacement = str_replace(array(' ', '.'),array('', ','), $line_data['Emplacement']);
			$boite = str_replace(array(' ', '.'),array('',','), $line_data['Boite']);
			if(!empty($emplacement) || !empty($boite)) {
				$aliquot_positions = array();
				if(!empty($emplacement)) {
					
					// Created stored aliquot with position
					
					if(empty($boite)) die('ERR  ['.$line_counter.'] 88990344dddd23273 '.$line_data['Boite'].' // '.$line_data['Emplacement']);
					
					if(preg_match('/^([0-9]+)$/', $boite, $matches)) {
						// - 1 - Box
						if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
							// 33
							$aliquot_positions[] = array('box_label' => $boite, 'position' => $emplacement);
						} else if(preg_match('/^([1-9]|[1-9][0-9]|100),([1-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
							// 12,23
							$aliquot_positions[] = array('box_label' => $boite, 'position' => $matches[1]);
							$aliquot_positions[] = array('box_label' => $boite, 'position' => $matches[2]);
						} else {
							Config::$summary_msg['DNA']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the dna aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
						}
						
					} else  {
						die('ERR 8994834183 92 : '.$boite.' - '.$emplacement);
					}
				
				} else  {
					Config::$summary_msg['DNA']['@@WARNING@@']["'Boite' & 'Emplacement' warning"][] = "There is an aliquot stored into a box with no position: Boite '$boite' && Emplacement '$emplacement'. Please set position after migration process! [line: $line_counter]";
					if(!preg_match('/^([0-9]+)$/', $boite, $matches)) {
						pr($line_data); 
						die('ERR  ['.$line_counter.'] 88499 48 92 '.$line_data['Boite'].' // '.$line_data['Emplacement']);
					}
					$aliquot_positions[] = array('box_label' => $boite, 'position' => '');
				}
				
				$current_weight_per_aliquot = $current_weight/sizeof($aliquot_positions);
				if(sizeof($aliquot_positions) > 1) Config::$summary_msg['DNA']['@@MESSAGE@@']["Split current weight"][] = "Split current weight ($current_weight) in ".sizeof($aliquot_positions)." => ($current_weight_per_aliquot). Please confirm! [line: $line_counter]";
				if($current_weight_per_aliquot == '0.0') Config::$summary_msg['DNA']['@@ERROR@@']["Empty 'available' aliquot"][] = "The current weight of aliquot is equal to 0 but the status is still equal to 'yes - available'. Please confirm! [line: $line_counter]";
				foreach($aliquot_positions as $new_stored_aliquot) {
					$storage_master_id = getStorageId('plasma', 'box100', $new_stored_aliquot['box_label']);
					$new_dna['aliquots'][] = array(
						'aliquot_masters' => array(
							'aliquot_label' => "'$aliquot_label'", 
							'initial_volume' => "'$current_weight_per_aliquot'",
							'current_volume' => "'$current_weight_per_aliquot'",
							'in_stock' => "'yes - available'",
							'storage_master_id' => "'$storage_master_id'",
							'storage_datetime' => "''",
							'storage_datetime_accuracy' => "''",
							'storage_coord_x' => "'".$new_stored_aliquot['position']."'",
							'storage_coord_y' => "''"),				
						'aliquot_details' => array(
							'chus_qc_ratio_260_280' => "'$ratio'",
							'concentration' => "'$concentration'",
							'concentration_unit' => (empty($concentration)? "''":"'ug/ml'")),
						'aliquot_internal_uses' => array(),
						'shippings' => array()
					);
				}
			} 
	
			if(empty($new_dna['aliquots'])) Config::$summary_msg['DNA']['@@ERROR@@']['No aliquot created'][] = "No shipped or stored aliquot has been created! [line: $line_counter]";
			$dnas_from_br_nbr[$br_nbr][] = $new_dna;

		} // End new line
	}
	
	return $dnas_from_br_nbr;
}

function getStorageId($aliquot_description, $storage_control_type, $selection_label) {
	global $storage_list;
	
	$selection_label = str_replace(' ', '', $selection_label);
	
	$storage_key = $aliquot_description.$storage_control_type.$selection_label;
	
	if(isset(Config::$storage_id_from_storage_key[$storage_key])) {
		//if(Config::$storage_id_from_storage_key[$storage_key] < Config::$nbr_storage_in_step2) pr("Box $selection_label use in step2 & 3");
		return Config::$storage_id_from_storage_key[$storage_key];
	}
	
	$next_id = sizeof(Config::$storage_id_from_storage_key) + 1;
	
	$master_fields = array(
		"code" => "'$next_id'",
		"storage_control_id"	=> Config::$storage_controls[$storage_control_type]['storage_control_id'],
		"short_label"			=> "'".$selection_label."'",
		"selection_label"		=> "'".$selection_label."'",
		"lft"		=> "'".(($next_id*2)-1)."'",
		"rght"		=> "'".($next_id*2)."'"
	);
	$storage_master_id = customInsertChusRecord($master_fields, 'storage_masters');	
	customInsertChusRecord(array("storage_master_id" => $storage_master_id), Config::$storage_controls[$storage_control_type]['detail_tablename'], true);	
		
	Config::$storage_id_from_storage_key[$storage_key] = $storage_master_id;
	
	return $storage_master_id;	
}

function createCollection($collections_to_create) {
	global $next_sample_code;
	
	foreach($collections_to_create as $new_collection) {	
		// Create colleciton
		if(!isset($new_collection['collection'])) die('ERR 889940404023');
		$collection_id = customInsertChusRecord(array_merge($new_collection['collection'], array('bank_id' => '1', 'collection_property' => "'participant collection'")), 'collections');	
		
		if(!isset($new_collection['link'])) die('ERR 889940404023.3');
		customInsertChusRecord(array_merge($new_collection['link'], array('collection_id' => $collection_id)), 'clinical_collection_links', false, true);			
		
		if(!isset($new_collection['inventory'])) die('ERR 889940404023.1');
		foreach($new_collection['inventory'] as $specimen_type => $specimen_products_list) {
			foreach($specimen_products_list as $new_specimen_products) {
				$additional_data = array(
					'sample_code' => "'$next_sample_code'", 
					'sample_control_id' => Config::$sample_aliquot_controls[$specimen_type]['sample_control_id'],
					'collection_id' => $collection_id,
					'initial_specimen_sample_type' => "'$specimen_type'");
				$sample_master_id = customInsertChusRecord(array_merge($new_specimen_products['sample_masters'], $additional_data), 'sample_masters', false, true);			
				customInsertChusRecord(array_merge($new_specimen_products['sample_details'], array('sample_master_id' => $sample_master_id)), Config::$sample_aliquot_controls[$specimen_type]['detail_tablename'], true, true);			
				customInsertChusRecord(array_merge($new_specimen_products['specimen_details'], array('sample_master_id' => $sample_master_id)), 'specimen_details', false, true);
				$next_sample_code++;
				
				// Create Derivative
				createDerivative($collection_id, $sample_master_id, $specimen_type, $sample_master_id, $specimen_type, $new_specimen_products['derivatives']);
			
				// Create Aliquot
				createAliquot($collection_id, $sample_master_id, $specimen_type, $new_specimen_products['aliquots']);	
			}	
		}
	}
}

function createDerivative($collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id, $parent_sample_type, $derivatives_data) {
	global $next_sample_code;
	
	foreach($derivatives_data as $derivative_type => $derivatives_list) {
		foreach($derivatives_list as $new_derivative) {
			$additional_data = array(
				'sample_code' => "'$next_sample_code'", 
				'sample_control_id' => Config::$sample_aliquot_controls[$derivative_type]['sample_control_id'],
				'collection_id' => $collection_id,
				'initial_specimen_sample_id' => $initial_specimen_sample_id,
				'initial_specimen_sample_type' => "'$initial_specimen_sample_type'",
				'parent_id' => $parent_sample_master_id,
				'parent_sample_type' => "'$parent_sample_type'");
			$sample_master_id = customInsertChusRecord(array_merge($new_derivative['sample_masters'], $additional_data), 'sample_masters', false, true);			
			customInsertChusRecord(array_merge($new_derivative['sample_details'], array('sample_master_id' => $sample_master_id)), Config::$sample_aliquot_controls[$derivative_type]['detail_tablename'], true, true);			
			customInsertChusRecord(array_merge($new_derivative['derivative_details'], array('sample_master_id' => $sample_master_id)), 'derivative_details', false, true);
			$next_sample_code++;
				
			// Create Derivative
			createDerivative($collection_id,$initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $derivative_type, $new_derivative['derivatives']);
		
			// Create Aliquot
			createAliquot($collection_id, $sample_master_id, $derivative_type, $new_derivative['aliquots']);	
		}	
	}
}

function createAliquot($collection_id, $sample_master_id, $sample_type, $aliquots) {
	global $next_aliquot_code;
		
	foreach($aliquots as $new_aliquot) {
		$additional_data = array(
			'collection_id' => $collection_id,
			'aliquot_control_id' => Config::$sample_aliquot_controls[$sample_type]['aliquots']['tube']['aliquot_control_id'],
			'sample_master_id' => $sample_master_id,
			'barcode' => $next_aliquot_code);
		$aliquot_master_id = customInsertChusRecord(array_merge($new_aliquot['aliquot_masters'], $additional_data), 'aliquot_masters', false, true);			
		customInsertChusRecord(array_merge($new_aliquot['aliquot_details'], array('aliquot_master_id' => $aliquot_master_id)), Config::$sample_aliquot_controls[$sample_type]['aliquots']['tube']['detail_tablename'], true, true);			
		$next_aliquot_code++;
				
		createInternalUse($aliquot_master_id, $new_aliquot['aliquot_internal_uses']);
		createAliquotShipment($aliquot_master_id, $new_aliquot['shippings'], Config::$sample_aliquot_controls[$sample_type]['sample_control_id'], Config::$sample_aliquot_controls[$sample_type]['aliquots']['tube']['aliquot_control_id']);
	}
}

function createInternalUse($aliquot_master_id, $aliquot_internal_uses) {
	foreach($aliquot_internal_uses as $new_use) {
		$data = array(
			'aliquot_master_id' => $aliquot_master_id,
			'use_code' => $new_use['use_code'],
			'used_volume' => $new_use['used_volume'],
			'use_datetime' => $new_use['use_datetime'],
			'use_datetime_accuracy' => $new_use['use_datetime_accuracy']
		);
		customInsertChusRecord($data, 'aliquot_internal_uses', false, true);	
	}  
}

function createAliquotShipment($aliquot_master_id, $shipping_data, $sample_control_id, $aliquot_control_id) {
	if(empty($shipping_data)) return;
	
	$ids = getShippingIds($shipping_data['recipient'], $shipping_data['shipping_datetime'], $shipping_data['shipping_datetime_accuracy'], $sample_control_id, $aliquot_control_id);
	
	$order_item_data = array(
		'order_line_id' => $ids['order_line_id'],
		'aliquot_master_id' => $aliquot_master_id,
		'shipment_id' => $ids['shipment_id'],
		'status' => "'shipped'"
	); 
	customInsertChusRecord($order_item_data, 'order_items', false, true);
}

function getShippingIds($recipient, $shipping_datetime, $shipping_datetime_accuracy, $sample_control_id, $aliquot_control_id) {
	global $shipping_list;
	
	$order_key = $recipient."/".$shipping_datetime."/".$shipping_datetime_accuracy;
	if(!isset($shipping_list[$order_key])) {
		$order_data = array(
			'order_number' => $recipient,
			'processing_status' => "'completed'",
			'date_order_completed' => str_replace(' 00:00:00', '', $shipping_datetime),
			'date_order_completed_accuracy' => (($shipping_datetime_accuracy == "'h'")? "'c'" : $shipping_datetime_accuracy) 
		);
		$shipping_list[$order_key]['order_id'] = customInsertChusRecord($order_data, 'orders', false, true);
	}
	
	$shipment_key = $sample_control_id."/".$aliquot_control_id;
	if(!isset($shipping_list[$order_key]['shipments'][$shipment_key])) {
		$order_line_data = array(
			'sample_control_id' => $sample_control_id,
			'aliquot_control_id' => $aliquot_control_id,
			'order_id' => $shipping_list[$order_key]['order_id'],
			'status' => "'shipped'"
		); 
		$shipping_list[$order_key]['shipments'][$shipment_key]['order_line_id'] = customInsertChusRecord($order_line_data, 'order_lines', false, true);
		
		$shipment_data =  array(
			'shipment_code' => $recipient,
			'datetime_shipped' => $shipping_datetime,
			'datetime_shipped_accuracy' => $shipping_datetime_accuracy,
			'recipient' => $recipient,
			'order_id' => $shipping_list[$order_key]['order_id']
		); 	
		$shipping_list[$order_key]['shipments'][$shipment_key]['shipment_id'] = customInsertChusRecord($shipment_data, 'shipments', false, true);
	}
	
	return array_merge(array('order_id' => $shipping_list[$order_key]['order_id']), $shipping_list[$order_key]['shipments'][$shipment_key]); 
}

?>
