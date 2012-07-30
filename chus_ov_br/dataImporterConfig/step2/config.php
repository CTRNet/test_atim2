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
//	static $xls_file_path	= "C:/_My_Directory/Local_Server/ATiM/chus_ovbr/data/DONNEES CLINIQUES et BIOLOGIQUES-OVAIRE-2012-03-14_revised.xls";
	static $xls_file_path	= "C:/_My_Directory/Local_Server/ATiM/chus_ovbr/data/atim DONNEES CLINIQUES et BIOLOGIQUES-OVAIRE-2012-06-04.xls";
	
	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well

	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	static $line_break_tag = '<br>';
	
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
	
	static $cytoreduction_values = array();
	
	static $ids_from_frsq_nbr = array();
	static $participant_id_from_ov_nbr = array();
	
	static $data_for_import_from_participant_id = array();
	
	static $summary_msg = array();	
	
}

//add you start queries here
//Config::$addon_queries_start[] = "..."

//add your end queries here
//Config::$addon_queries_end[] = "..."

//add some value domains names that you want to use in post read/write functions
//Config::$value_domains['health_status']= new ValueDomain("health_status", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "OvaryDiagnosisMaster";

//add your configs
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/chus_ovbr/dataImporterConfig/step2/tablesMapping/ovary_diagnoses.php'; 

//Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/no_dossier_chus_identifiers.php'; 
//Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/ovary_bank_identifiers.php'; 
//Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/breast_bank_identifiers.php'; 

//=========================================================================================================
// START functions
//=========================================================================================================
	
function addonFunctionStart(){
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS Step 2 : CHUS OVBR<br>
	Ovary Data Import<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	echo "ALL Consent will be defined as obtained!<br>";
	echo "<FONT COLOR=\"red\" >WARNING: Be sure Dates columns have been formatted.</FONT>";
		
	// ** Data check ** 
	
	$query = "SELECT COUNT(*) FROM participants;";
	$results = mysqli_query(Config::$db_connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step2: Participant table should be completed");
	}
	
	$query = "SELECT COUNT(*) FROM misc_identifiers;";
	$results = mysqli_query(Config::$db_connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step2: Identifiers table should be completed");
	}	
	
	$query = "SELECT COUNT(*) FROM diagnosis_masters;";
	$results = mysqli_query(Config::$db_connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step2: Diagnoses table should be empty");
	}	

	$query = "SELECT COUNT(*) FROM collections;";
	$results = mysqli_query(Config::$db_connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step2: Collections table should be empty");
	}	
	
	// ** Set sample aliquot controls **
	
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue','blood', 'ascite', 'peritoneal wash', 'ascite cell', 'ascite supernatant', 'cell culture', 'serum', 'plasma', 'dna', 'rna', 'blood cell')";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 12) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}	
	}	
	
	// ** Set diagnosis controls **
	
	$query = "select id,category,controls_type,detail_tablename from diagnosis_controls where flag_active = '1' AND category IN ('primary','secondary');";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$diagnosis_controls[$row['category']][$row['controls_type']] = array('diagnosis_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** Set treatment controls **
	
	$query = "select id,tx_method,disease_site,detail_tablename from treatment_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$treatment_controls[$row['tx_method']][$row['disease_site']] = array('treatment_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** Set event controls **
	
	$query = "select id,disease_site,event_group,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$event_controls[$row['event_group']][$row['disease_site']][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	// ** Set cytoreduction value **
	
	$query = "select value from structure_permissible_values_customs where control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values');";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$cytoreduction_values[] = $row['value'];
	}

	// ** Set participant_id / identifier values links array **
	
	$query = "SELECT ident.id, ctrl.misc_identifier_name, ident.identifier_value, ident.participant_id
	FROM misc_identifier_controls AS ctrl INNER JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = ctrl.id
	WHERE ctrl.misc_identifier_name LIKE '%FRSQ%' AND ident.deleted != 1";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		if(isset(Config::$ids_from_frsq_nbr[$row['identifier_value']])) {
			pr($row);
			die('ERR 99887399.1');
		}
		Config::$ids_from_frsq_nbr[$row['identifier_value']]['participant_id'] = $row['participant_id'];
		Config::$ids_from_frsq_nbr[$row['identifier_value']]['misc_identifier_id'] = $row['id'];
		
		if(preg_match('/^OV[A-Z]{0,1}([0-9]+)$/', $row['identifier_value'], $matches)) {
			Config::$participant_id_from_ov_nbr['OV'.$matches[1]] = $row['participant_id'];
		}
		
		if(!isset(Config::$data_for_import_from_participant_id[$row['participant_id']])) Config::$data_for_import_from_participant_id[$row['participant_id']] = array('data_imported_from_ov_file' => false);
		Config::$data_for_import_from_participant_id[$row['participant_id']][$row['misc_identifier_name']][] = $row['identifier_value'];
	}
	
	// ** Set storage controls **
	
	$query = "select id,storage_type,detail_tablename from storage_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$storage_controls[$row['storage_type']] = array('storage_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
}

//=========================================================================================================
// END functions
//=========================================================================================================
	
function addonFunctionEnd(){
	// DIAGNOSIS UPDATE
	
	$query = "UPDATE diagnosis_masters SET primary_id = id WHERE parent_id IS NULL;";
	mysqli_query(Config::$db_connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$query = str_replace('diagnosis_masters','diagnosis_masters_revs',$query);
	mysqli_query(Config::$db_connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	$query = "UPDATE diagnosis_masters parent, diagnosis_masters child SET child.primary_id = parent.primary_id WHERE child.primary_id IS NULL AND child.parent_id IS NOT NULL AND child.parent_id = parent.id;";
	mysqli_query(Config::$db_connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$query = str_replace('diagnosis_masters','diagnosis_masters_revs',$query);
	mysqli_query(Config::$db_connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));

	// ADD PATIENT OTHER DATA
	
	addPatientsHistory();
	addFamilyHistory();
 	addCollections();

  	// INVENTORY COMPLETION
		
//	$query = "UPDATE sample_masters SET sample_code=id;";
//	mysqli_query(Config::$db_connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
//	$query = "UPDATE sample_masters_revs SET sample_code=id;";
//	mysqli_query(Config::$db_connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));	
	
	$query = "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;";
	mysqli_query(Config::$db_connection, $query) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$query = "UPDATE sample_masters_revs SET initial_specimen_sample_id=id WHERE parent_id IS NULL;";
	mysqli_query(Config::$db_connection, $query) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));	
	
//	$query = "UPDATE aliquot_masters SET barcode=id;";
//	mysqli_query(Config::$db_connection, $query) or die("barcode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
//	$query = "UPDATE aliquot_masters_revs SET barcode=id;";
//	mysqli_query(Config::$db_connection, $query) or die("barcode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	// WARNING DISPLAY

	echo "<br><br><FONT COLOR=\"blue\" >
	=====================================================================<br><br>
	PARTICIPANT WITH MULTI-#FRSQ
	<br><br>=====================================================================
	</FONT><br>";	
	
	echo "<br> --> <FONT COLOR=\"orange\" >Data like the CA125, DX, CTSCan can be duplicated for participants having more than one #FRSQ (see below). Clean up will be required! </FONT><br>";
	foreach(Config::$data_for_import_from_participant_id as $new_part_dat_set) {
		if(isset($new_part_dat_set['#FRSQ OV']) && (sizeof($new_part_dat_set['#FRSQ OV']) > 1)) {
			 echo "New participant : ".implode(",", $new_part_dat_set['#FRSQ OV'])."<br>";
		}
	}
	
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
			
			$participant_id = isset(Config::$ids_from_frsq_nbr[$frsq_nbr])? Config::$ids_from_frsq_nbr[$frsq_nbr]['participant_id'] : null;
			if(!$participant_id)  {
				$frsq_nbrs = preg_replace(array('/(\({0,1}voir)/i','/(\))/','/(\()/','/([A-Z]+)([0-9]+),([0-9]+)/','/([A-Z]+[0-9]+),([A-Z]+)([0-9]+)-([0-9]+)/'), array('-', '','-','$1$2-$1$3','$1-$2$3-$2$4'), $frsq_nbr);
				$frsq_nbrs = explode('-',$frsq_nbrs);
				foreach($frsq_nbrs as $new_frsq_nbr) {
					$new_participant_id = isset(Config::$ids_from_frsq_nbr[$new_frsq_nbr])? Config::$ids_from_frsq_nbr[$new_frsq_nbr]['participant_id'] : null;
					if(!$new_participant_id) {
						Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Participant With Many FRSQ# #1'][] = "The FRSQ# '".$new_frsq_nbr."' is not defined in step 1! [Will try to assign data to other FRSQ# '".$line_data['#FRSQ']."'! [line: $line_counter]";
					} else {
						if($participant_id && ($new_participant_id != $participant_id)){
							Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Participant With Many FRSQ# #2'][] = "The FRSQ#s '".$line_data['#FRSQ']."' have beend assigned to the same participant in step2 ('PATIENT HISTORY') but match different participants in step 1! [line: $line_counter]";
						} else if(!$participant_id) {
							$participant_id = $new_participant_id;
						}
					}
				}
			}
			if(!$participant_id) {
				Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Unknown participant'][] = "The FRSQ# '".$line_data['#FRSQ']."' has beend assigned to a participant in step2 ('PATIENT HISTORY') but this number is not defined in step 1! [line: $line_counter]";
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
			
			if(!empty($line_data['Statut'])) {
				
				if(in_array($line_data['Statut'], array('Vie', 'Vie ','vie', 'vie '))) {
					$update_sql =  "vital_status = 'alive'";
				} else if(in_array($line_data['Statut'], array('DCD','DCD '))) {
					$update_sql =  "vital_status = 'deceased'";
					$is_dcd = true;
				} else if($line_data['Statut'] == '?DCD?') {
					$update_sql =  "vital_status = 'deceased'";
					$notes_to_update = 'Vital status note: Deceased to confirm.';
					$is_dcd = true;
				} else if(preg_match('/^vie \(.*\)/i', $line_data['Statut'], $matches)) {
					$update_sql =  "vital_status = 'alive'";
					$notes_to_update = 'Vital status note: '. $line_data['Statut'].'.';
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Status unknonw'][] = "The patient status '".$line_data['Statut']."' is not supported & not imported! Please check data! [line: $line_counter]";
				}
			}
			
			if(!empty($line_data['DateStatut'])) {
				$status_date = $line_data['DateStatut'];
				if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-00$/', $status_date, $matches)) {
					$update_sql .= (empty($update_sql)? '' : ', ')."chus_date_of_status = '".str_replace('-00','-01',$status_date)."', chus_date_of_status_accuracy = 'd'";			
				} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/', $status_date, $matches)) {
					$update_sql .= (empty($update_sql)? '' : ', ')."chus_date_of_status = '$status_date', chus_date_of_status_accuracy = 'c'";			
				} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])$/', $status_date, $matches)) {
					$update_sql .= (empty($update_sql)? '' : ', ')."chus_date_of_status = '$status_date-01', chus_date_of_status_accuracy = 'd'";
				} else if(preg_match('/^([01][0-9])\-(19|20)([0-9]{2})$/', $status_date, $matches)) {
					$update_sql .= (empty($update_sql)? '' : ', ')."chus_date_of_status = '".$matches[2].$matches[3]."-".$matches[1]."-01', chus_date_of_status_accuracy = 'd'";
				} else if(preg_match('/^(19|20)([0-9]{2})$/',$status_date,$matches)) {
					$update_sql .= (empty($update_sql)? '' : ', ')."chus_date_of_status = '$status_date-01-01', chus_date_of_status_accuracy = 'm'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Status date format'][] = "Status date format not supported & not imported: $status_date! Please check data! [line: $line_counter]";
				}
			}
			
			if(!empty($line_data['Cause décès'])) {	
				if(!$is_dcd) Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['Cause décès'][] = "'Cause décès' defined on alive patiente! Please check data! [line: $line_counter]";
				$update_sql .= (empty($update_sql)? '' : ', ')."chus_cause_of_death = '".str_replace("'","''",$line_data['Cause décès'])."'";
			}

			if(!empty($line_data['Mutation BRCA 1 ou 2'])) {
				switch($line_data['Mutation BRCA 1 ou 2']) {
					case 'BRCA 1 et 2 nég':
						$update_sql .= (empty($update_sql)? '' : ', ')."chus_brca_1 = 'n', chus_brca_2 = 'n'";
						break;
					case 'BRCA1':
					case 'BRCA1 ':
						$update_sql .= (empty($update_sql)? '' : ', ')."chus_brca_1 = 'y'";
						break;
					case 'BRCA2':
					case 'BRCA2 mut':
						$update_sql .= (empty($update_sql)? '' : ', ')."chus_brca_2 = 'y'";
						break;
					default:
						Config::$summary_msg['PATIENT HISTORY']['@@WARNING@@']['BRCA Values'][] = "BRCA Value '".$line_data['Mutation BRCA 1 ou 2']."' not supported & not imported! Please check data! [line: $line_counter]";
				}
			}				
			
			if(!empty($notes_to_update)) {
				$update_sql .= (empty($update_sql)? '' : ', ')."notes = CONCAT('$notes_to_update', ' // ', IFNULL(notes, ''))";
			}
			if(!empty($update_sql)) {
				$query = "UPDATE participants SET $update_sql WHERE id = $participant_id;";
				mysqli_query(Config::$db_connection, $query) or die("participants update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$query = str_replace('participants','participants_revs',$query);
				mysqli_query(Config::$db_connection, $query) or die("participants update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));		
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
				if(!isset(Config::$event_controls['clinical']['general']['followup'])) die('ERR 88998379.1');
				$event_control_id = Config::$event_controls['clinical']['general']['followup']['event_control_id'];
				$detail_tablename = Config::$event_controls['clinical']['general']['followup']['detail_tablename'];				
				
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
			
			// ADD lifestyle all smoking history questionnaire  ed_all_lifestyle_smokings
		
			$detail_fields = array();
			
			$smoking_history = str_replace(array('ND','-'),array('',''), $line_data['Tabac::Tabac']);
			if(strlen($smoking_history)) {
				if(preg_match('/^ {0,1}non {0,1}$/', $smoking_history, $matches)) {
					$detail_fields['smoking_history'] = "'no'";
				
				} else if(preg_match('/^ {0,1}oui {0,1}$/', $smoking_history, $matches)) {
					$detail_fields['smoking_history'] = "'yes'";

				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Tabac'][] = "Value '$smoking_history' is not supported and won't be imported! [line: $line_counter]";
				}
			}	

			$smoking_status = str_replace(array('ND','-'),array('',''), $line_data['Tabac::arrêt tabac?']);
			if(strlen($smoking_status)) {
				if(preg_match('/^ {0,1}non {0,1}$/', $smoking_status, $matches)) {
					$detail_fields['smoking_status'] = "'smoker'";
				} else if(preg_match('/^ {0,1}oui {0,1}$/', $smoking_status, $matches)) {
					$detail_fields['smoking_status'] = "'ex-smoker'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['arrêt tabac'][] = "Value '$smoking_status' is not supported and won't be imported! [line: $line_counter]";
				}
			}	
			
			$years_quit_smoking = str_replace(array('ND','-'),array('',''),$line_data['Tabac::Depuis combien année (An)']);
			if(strlen($years_quit_smoking)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $years_quit_smoking,$matches)) {
					$detail_fields['years_quit_smoking'] = "'$years_quit_smoking'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['arrêt tabac années'][] = "Value '$years_quit_smoking' is not supported and won't be imported! [line: $line_counter]";
				}
			}			
			
			$chus_duration_in_years = str_replace(array('ND','-'),array('',''),$line_data['Tabac::Durée (an)']);
			if(strlen($chus_duration_in_years)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $chus_duration_in_years,$matches)) {
					$detail_fields['chus_duration_in_years'] = "'$chus_duration_in_years'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Tabac Durée (an)'][] = "Value '$chus_duration_in_years' is not supported and won't be imported! [line: $line_counter]";
				}
			}				
			
			$chus_quantity_per_day = str_replace('ND','',$line_data['Tabac::Qté / jour 1pqt = 20']);
			if(strlen($chus_quantity_per_day)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $chus_quantity_per_day,$matches)) {
					$detail_fields['chus_quantity_per_day'] = "'$chus_quantity_per_day'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['Tabac::Qté / jour 1pqt = 20'][] = "Value '$chus_quantity_per_day' is not supported and won't be imported! [line: $line_counter]";
				}
			}
			
			if(!empty($detail_fields)) {
				if(!isset(Config::$event_controls['lifestyle']['general']['smoking history questionnaire'])) die('ERR 88998379.2');
				$event_control_id = Config::$event_controls['lifestyle']['general']['smoking history questionnaire']['event_control_id'];
				$detail_tablename = Config::$event_controls['lifestyle']['general']['smoking history questionnaire']['detail_tablename'];				
				
				$master_fields = array(
					'participant_id' => $participant_id,
					'event_control_id' =>  $event_control_id
				);
				$event_master_id = customInsertChusRecord($master_fields, 'event_masters');	
				$detail_fields['event_master_id'] = $event_master_id;
				customInsertChusRecord($detail_fields, $detail_tablename, true);				
			}
			
			// reproductive_histories
			
			$data_to_insert = array();
			
			$age_at_menarche = str_replace('ND','',$line_data['Âge 1ere menstruation']);
			if(strlen($age_at_menarche)) {
				if(!preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $age_at_menarche,$matches)) die('ERR 9874994812 age_at_menarche : ' .$age_at_menarche. ' line '.$line_counter);
				$data_to_insert['age_at_menarche'] = "'$age_at_menarche'";
			}
			$gravida = str_replace('ND','',$line_data['G']);
			if(strlen($gravida)) {
				if(!preg_match('/^[0-9]+$/', $gravida,$matches)) die('ERR 987499482 gravida : '.$gravida);
				$data_to_insert['gravida'] = "'$gravida'";
			}			
			$para = str_replace('ND','',$line_data['P']);
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
			$chus_abortus = str_replace('ND','',$line_data['A']);
			if(strlen($chus_abortus)) {
				if(!preg_match('/^[0-9]+$/', $chus_abortus, $matches)) die('ERR 9874994843 $chus_abortus : '.$chus_abortus);
				$data_to_insert['chus_abortus'] = "'$chus_abortus'";
			}
			
			$line_data['Statut ménopause::Préménopause'] = str_replace(array('ND', '-'),array('',''),$line_data['Statut ménopause::Préménopause']);
			if(strlen($line_data['Statut ménopause::Préménopause'])) {
				if($line_data['Statut ménopause::Préménopause'] != 'x')  {
					die('ERR 98dds843 Préménopause : '.$line_data['Statut ménopause::Préménopause']);
				} else {
					$data_to_insert['menopause_status'] = "'pre'";
				}
			}			
			if(strlen($line_data['Statut ménopause::Ménopause'])) {
				if($line_data['Statut ménopause::Ménopause'] != 'x')  die('ERR 98dds843 Ménopause : '.$line_data['Statut ménopause::Ménopause']);
				if(isset($data_to_insert['menopause_status'])) die('Menopause status recorded twice');
				$data_to_insert['menopause_status'] = "'peri'";
			}			
			if(strlen($line_data['Statut ménopause::Post ménopause'])) {
				if($line_data['Statut ménopause::Post ménopause'] != 'x')  die('ERR 98dds8sasas43 Post ménopause : '.$line_data['Statut ménopause::Post ménopause']);
				if(isset($data_to_insert['menopause_status'])) die('Menopause status recorded twice');
				$data_to_insert['menopause_status'] = "'post'";
			}			
	
			$age_at_menopause = str_replace(array('ND', '-'),array('',''),$line_data['Âge début ménopause']);
			if(strlen($age_at_menopause)) {
				if(!preg_match('/^[0-9]+$/', $age_at_menopause, $matches)) die('ERR 9833343');
				$data_to_insert['age_at_menopause'] = "'$age_at_menopause'";
			}
			
			if(strlen($line_data['Cause fin menstruation::Naturelle'])) {
				if($line_data['Cause fin menstruation::Naturelle'] != 'x')  die('ERR 98ddsssaa843 Cause fin menstruation::Naturelle : '.$line_data['Cause fin menstruation::Naturelle']);
				$data_to_insert['menopause_onset_reason'] = "'natural'";
			}			
			if(strlen($line_data['Cause fin menstruation::Chirurgie/Provoquée'])) {
				if($line_data['Cause fin menstruation::Chirurgie/Provoquée'] != 'x')  die('ERR 98dds111843 Cause fin menstruation::Chirurgie/Provoquée : '.$line_data['Cause fin menstruation::Chirurgie/Provoquée']);
				if(isset($data_to_insert['menopause_onset_reason'])) die('ERR ssaseyue');
				$data_to_insert['menopause_onset_reason'] = "'surgical/induced'";
			}			
			if(strlen($line_data['Cause fin menstruation::Chimio/Radiothérapie'])) {
				if($line_data['Cause fin menstruation::Chimio/Radiothérapie'] != 'x')  die('ERR 98dds111843 Cause fin menstruation::Chimio/Radiothérapie : '.$line_data['Cause fin menstruation::Chimio/Radiothérapie']);
				if(isset($data_to_insert['menopause_onset_reason'])) die('ERR sssaaaaaseyue');
				$data_to_insert['menopause_onset_reason'] = "'chemo/radio'";
			}
			
			$hrt_use = str_replace(array('ND', 'nd','-'), array('','',''), $line_data['HORMONES::Hormone de remplacement Oui-Non-S.R.']);
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
			$hrt_years_used = str_replace(array('ND', '-'),array('',''),$line_data['HORMONES::Durée Hormone (An)']);
			if(strlen($hrt_years_used)) {
				if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $hrt_years_used, $matches)) die('ERR 98334000343 Durée Hormone : '.$hrt_years_used);
				$data_to_insert['hrt_years_used'] = "'$hrt_years_used'";
			}

			$chus_evista_use = str_replace(array('ND','-'),array('',''), $line_data['HORMONES::Tamoxifène / Évista (Oui-Non-S.R.)']);
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
				$data_to_insert['participant_id'] = $participant_id;
				customInsertChusRecord($data_to_insert, 'reproductive_histories');	
			}
			
			// ADD ATCD
			
			if(!isset(Config::$event_controls['clinical']['general']['past history'])) die('ERR 88998379.3');
			$event_control_id = Config::$event_controls['clinical']['general']['past history']['event_control_id'];
			$detail_tablename = Config::$event_controls['clinical']['general']['past history']['detail_tablename'];				
			
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
					$all_atcd_events[] = $event_data;
				}
			}
			
			if(!empty($line_data['ATCD autres'])) {
				$date = null;
				$date_accuracy = null;
				$summary = '';
				
				$data_tmp = preg_replace(array('/^(.*) {0,1}(19|20)([0-9]{2})$/', '/^(.*) {0,1}\((19|20)([0-9]{2})\)$/'), array('$2$3 : $1', '$2$3 : $1'), $line_data['ATCD autres']);
				
				if(preg_match('/^(19|20)([0-9]{2}) {0,1}: {0,1}(.*)$/', $data_tmp, $matches)) {
					$date = $matches[1].$matches[2].'-01-01';
					$date_accuracy = 'm';
					$summary = $matches[3];
				} else if(preg_match('/^(19|20)([0-9]{2})-([01][0-9]) {0,1}: {0,1}(.*)$/', $data_tmp, $matches)) {
					$date = $matches[1].$matches[2].'-'.$matches[3].'-01';
					$date_accuracy = 'd';
					$summary = $matches[4];
				} else if(preg_match('/^(19|20)([0-9]{2})-([01][0-9])-([0-3][0-9]) {0,1}: {0,1}(.*)$/', $data_tmp, $matches)) {
					$date = $matches[1].$matches[2].'-'.$matches[3].'-'.$matches[4];
					$date_accuracy = 'c';
					$summary = $matches[5];					
				
				} else {
					$summary = $data_tmp;
				}
				
				$event_data = array(
					'master' => array(
						'participant_id' => $participant_id,
						'event_control_id' =>  $event_control_id,
						'event_summary' => "'".str_replace("'","''",$summary)."'"
						),
					'detail' => array('type' => "'other'"));
				if(!empty($date)) {
					$event_data['master']['event_date'] = "'$date'";
					$event_data['master']['event_date_accuracy'] = "'$date_accuracy'";
				}	
				$all_atcd_events[] = $event_data;
			}
			
			foreach($all_atcd_events as $new_atcd) {
				$event_master_id = customInsertChusRecord($new_atcd['master'], 'event_masters');	
				$new_atcd['detail']['event_master_id'] = $event_master_id;
				customInsertChusRecord($new_atcd['detail'], $detail_tablename, true);	
			}			
		}
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
		'hodgkin' => array('tumor' => 'hodgkin', 'origin' => ''),
		'intestin' => array('tumor' => 'intestine', 'origin' => ''),
		'rein' => array('tumor' => 'kidney', 'origin' => ''),
		'leucemie' => array('tumor' => 'leukemia', 'origin' => ''),
		'leucémie' => array('tumor' => 'leukemia', 'origin' => ''),
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
		'thyroide' => array('tumor' => 'thyroid', 'origin' => ''));

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
					$line_data[utf8_encode($field)] =  preg_replace(array('/( +)$/', '/^( +)/', '/^nd$/', '/^aucun$/'), array('','','',''), ($field == '#FRSQ')? $new_line[$key] : strtolower($new_line[$key]));
				} else {
					$line_data[utf8_encode($field)] = '';
				}
			}
			
			// GET PARTICIPANT ID
			
			if(empty($line_data['#FRSQ'])) die('ERR Missing #FRSQ in Historique Familial worksheet line : '.$line_counter);
			$frsq_nbr = utf8_encode($line_data['#FRSQ']);
			
			$participant_id = isset(Config::$ids_from_frsq_nbr[$frsq_nbr])? Config::$ids_from_frsq_nbr[$frsq_nbr]['participant_id'] : null;
			if(!$participant_id)  {
				$frsq_nbrs = preg_replace(array('/(\({0,1}voir)/i','/(\))/','/(\()/','/([A-Z]+)([0-9]+),([0-9]+)/','/([A-Z]+[0-9]+),([A-Z]+)([0-9]+)-([0-9]+)/'), array('-', '','-','$1$2-$1$3','$1-$2$3-$2$4'), $frsq_nbr);
				$frsq_nbrs = explode('-',$frsq_nbrs);
				foreach($frsq_nbrs as $new_frsq_nbr) {
					$new_participant_id = isset(Config::$ids_from_frsq_nbr[$new_frsq_nbr])? Config::$ids_from_frsq_nbr[$new_frsq_nbr]['participant_id'] : null;
					if(!$new_participant_id) {
						Config::$summary_msg['FAMILY HISTORY']['@@WARNING@@']['Participant With Many FRSQ# #1'][] = "The FRSQ# '".$new_frsq_nbr."' is not defined in step 1! [Will try to assign data to other FRSQ# '".$line_data['#FRSQ']."'! [line: $line_counter]";
					} else {
						if($participant_id && ($new_participant_id != $participant_id)){
							Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Participant With Many FRSQ# #2'][] = "The FRSQ#s '".$line_data['#FRSQ']."' have beend assigned to the same participant in step2 ('FAMILY HISTORY') but match different participants in step 1! [line: $line_counter]";
						} else if(!$participant_id) {
							$participant_id = $new_participant_id;
						}
					}
				}
			}
			if(!$participant_id) {
				Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Unknown participant'][] = "The FRSQ# '".$line_data['#FRSQ']."' has beend assigned to a participant in step2 ('FAMILY HISTORY') but this number is not defined in step 1! [line: $line_counter]";
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
			for($counter = 1; $counter < 10; $counter++) {
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
					} else  if(preg_match('/^(grand-père) {0,1}(.*)$/',$family_link_tmp,$matches)) {
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
						'chus_tumor_description' => "'$tumor'",
						'relation' => "'$relation'"
					);
					if(!empty($origin))  $data_to_insert['chus_tumor_origin'] = "'$origin'";
					if(!empty($family_domain))  $data_to_insert['family_domain'] = "'$family_domain'";
					if(!empty($chus_notes))  $data_to_insert['chus_notes'] = "'$chus_notes'";
					if(!empty($age_at_dx))  $data_to_insert['age_at_dx'] = "'$age_at_dx'";
					
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
	mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	$record_id = mysqli_insert_id(Config::$db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()");
	
	$rev_insert_arr = array_merge($data_arr, $additional_fields);
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
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
	
	global $next_sample_code;
	$next_sample_code = 1;
	global $next_aliquot_code;
	$next_aliquot_code = 1;
	global $storage_list;
	$storage_list = array();
	global $shipping_list;
	$shipping_list = array();
	
	// ASCITE & TISSUE
	
	$collections_to_create = array();
	
	$collections_to_create = loadAscite2mlCollection($collections_to_create);
	$collections_to_create = loadAscite10mlCollection($collections_to_create);
	$collections_to_create = loadTissueCollection($collections_to_create);

	// BLOOD
	
	$dnas_from_ov_nbr = loadDNACollection();
	$collections_to_create = loadBloodCollection($collections_to_create, $dnas_from_ov_nbr);

	createCollection($collections_to_create);
}

function loadAscite2mlCollection($collections_to_create) {
		
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('Ascite Disponible (2ml)', $sheets_nbr)) die("ERROR: Worksheet Ascite Disponible (2ml) is missing!\n");

	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr['Ascite Disponible (2ml)']]['cells'] as $line => $new_line) {	
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

			if(empty($line_data['Qté'])) {
				Config::$summary_msg['ASCITE 2 ml']['@@ERROR@@']['Empty Qté'][] = "No Qté: Row data won't be migrated! [line: $line_counter]";
				continue;
			}
			
			// GET Participant Id & Misci Identifier Id & FRSQ Nbr
			
			if(empty($line_data['Échantillon']) && empty($line_data['#FRSQ'])) {
				Config::$summary_msg['ASCITE 2 ml']['@@ERROR@@']['No FRSQ # & Échantillon value'][] = "No FRSQ# & Échantillon values. Data won't be migrated! [line: $line_counter]";
				continue;
			}
			
			$echantillon_value = preg_replace('/ +$/','',$line_data['Échantillon']);
			$frsq_value = preg_replace('/ +$/','',$line_data['#FRSQ']);
			
			$ids = getParticipantIdentifierAndDiagnosisIds('ASCITE 2 ml', $line_counter, $frsq_value, $echantillon_value);
			if(empty($ids)) continue;
			
			$participant_id = $ids['participant_id'];
			$misc_identifier_id = $ids['misc_identifier_id'];
			$diagnosis_master_id = $ids['diagnosis_master_id'];

			// GET CONSENT_MASTER_ID	
					
			$consent_master_id = isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'])? Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] : null;
	
			// Collection
			
			$collection_date = '';
			$collection_date_accuracy = '';
			if(!empty($line_data['Date collecte'])) {
				$collection_date = customGetFormatedDate($line_data['Date collecte'], 'ASCITE 2 ml', $line_counter).' 00:00:00';
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
			
			// Ascite
			
			$line_data['Heure Réception'] = str_replace('ND','',$line_data['Heure Réception']);
			if(!empty($line_data['Heure Réception']) && empty($collection_date)) die('ERR 890003');
			if(!empty($line_data['Heure Réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Réception'], $matches)) die('ERR  ['.$line_counter.'] 890004 be sure cell custom format is h:mm ['.$line_data['Heure Réception'].']');
			$reception_datetime = (!empty($line_data['Heure Réception']))? str_replace('00:00:00', $line_data['Heure Réception'].':00', $collection_date) : $collection_date;
			$reception_datetime_accuracy = (!empty($line_data['Heure Réception']))? 'c' : 'h';
			
			if(!isset($collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime])) {
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['sample_masters'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['specimen_details'] = array('reception_datetime' => "'$reception_datetime'", 'reception_datetime_accuracy' => "'$reception_datetime_accuracy'");
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives'] = array();
			}
			
			// Ascite supernatant
			
			if(!isset($collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'])) {
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['sample_masters'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['derivative_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['derivatives'] = array();
			}			
			
			// Ascite supernatant Tube
			
			$expected_nbr_of_tubes = $line_data['Qté'];
			
			$aliquot_label = $line_data['Échantillon'];
			
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
			$line_data['Heure Entreposage'] = str_replace('ND','',$line_data['Heure Entreposage']);
			if(!empty($line_data['Date collecte'])) {
				$storage_datetime = customGetFormatedDate($line_data['Date collecte'], 'ASCITE 2 ml', $line_counter).' 00:00:00';
				$storage_datetime_accuracy = 'h';
				if(!empty($line_data['Heure Entreposage'])) {
					if(!preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Entreposage'], $matches)) die('ERR  ['.$line_counter.'] 89000ddd4');
					$storage_datetime = str_replace('00:00:00', $line_data['Heure Entreposage'].':00', $storage_datetime);
					$storage_datetime_accuracy = 'c';
				}
			} else if(!empty($line_data['Heure Entreposage'])) {
				die('ERR ['.$line_counter.'] 99994884');
			}
			
			if(!empty($collection_date) && !empty($storage_datetime)) {
				$collection_date_tmp = str_replace(array(' ', ':', '-'), array('','',''), $collection_date);
				$storage_datetime_tmp = str_replace(array(' ', ':', '-'), array('','',''), $storage_datetime);
				if($storage_datetime_tmp < $collection_date_tmp) Config::$summary_msg['ASCITE 2 ml']['@@ERROR@@']['Collection & Storage Dates'][] = "Sotrage should be done after collection. Please check collection and storage date! [line: $line_counter]";
			}
			
			$remisage = str_replace(array(' ','ND'), array('',''), $line_data['Temps au remisage (H)']);
			if(!empty($remisage)) {
				if(!in_array($remisage, array('<1h','1h<<4h','4h<','<8h'))) {
					if(preg_match('/^00:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '<1h';
					} else if(preg_match('/^0[1-3]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '1h<<4h';
					} else if(preg_match('/^0[4-7]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '<8h';
					} else {
						Config::$summary_msg['ASCITE 2 ml']['@@ERROR@@']['Remisage error'][] = "unsupported remisage value : $remisage (be sure cell custom format is h:mm)! [line: $line_counter]";
						$remisage = '';
					}
				}
			}			
			
			$created_aliquots = 0;
			if(!empty($line_data['Emplacement'])) {
				// Created stored aliquot
				if(empty($line_data['Boite'])) die('ERR  ['.$line_counter.'] 88990373'.$line_data['Boite'].'//'.$line_data['Emplacement']);
				
				$storage_master_id = getStorageId('ascite 1ml', 'box100', $line_data['Boite']);
				
				$stored_aliquots_positions = array();
				$emplacement_tmp = str_replace(array(' ','.'), array('',','), $line_data['Emplacement']);
				if(preg_match('/^0([1-9])$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions[] = $matches[1];
				} else if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions[] = $matches[1];
				} else if(preg_match('/^([1-9],|[1-9][0-9],|100,)+([1-9]|[1-9][0-9]|100)$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions = explode(',',$emplacement_tmp);
				} else if(preg_match('/^0{0,1}([1-9]|[1-9][0-9]|100)-0{0,1}([1-9]|[1-9][0-9]|100)$/', $emplacement_tmp, $matches)) {
					$start = $matches[1];
					$end  = $matches[2];
					if($start >= $end) die('ERR ['.$line_counter.'] 89938399303 : '.$emplacement_tmp);
					While($start <=  $end) {
						$stored_aliquots_positions[] = $start;
						$start++;
					}
				} else {
					die('ERR  ['.$line_counter.'] 9984949494 : '.$emplacement_tmp);
				}
				
				foreach($stored_aliquots_positions as $new_pos) {
					$created_aliquots++;
					$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][] = array(
						'aliquot_masters' => array(
							'aliquot_label' => "'$aliquot_label'", 
							'initial_volume' => "'1'",
							'current_volume' => "'1'",
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
				}
			}
			
			if(!empty($line_data['NbrDeDons']) || !empty($line_data['Dons1'])) {
				if(empty($line_data['NbrDeDons']) || empty($line_data['Dons1'])) die('ERR ['.$line_counter.'] 8899eee944');
				if(!preg_match('/^[0-9]+$/',$line_data['NbrDeDons'],$matches)) die('ERR ['.$line_counter.'] 8899eeeddd944');
				
				$generic_aliquot_used_data = array(
					'aliquot_masters' => array(
						'aliquot_label' => "'$aliquot_label'", 
						'initial_volume' => "'1'",
						'current_volume' => "'1'",
						'in_stock' => "'no'",
						'in_stock_detail' => "'shipped'",
						'storage_master_id' => "''",
						'storage_datetime' => "'$storage_datetime'",
						'storage_datetime_accuracy' => "'$storage_datetime_accuracy'",
						'storage_coord_x' => "''",
						'storage_coord_y' => "''",
						'chus_time_limit_of_storage' => "'$remisage'"),				
					'aliquot_details' => array(),
					'aliquot_internal_uses' => array());
			
				$aliquot_used_nbr = $line_data['NbrDeDons'];
				$used_aliquots_counter = 0;
				
				if(preg_match('/^([0-9]+) (Aris|TFRI) (19|20)([0-9]{2}\-[0-1][0-9])$/', $line_data['Dons1'], $matches)) {
					for($i = 0; $i < $matches[1]; $i++) {
						$used_aliquots_counter++;
						$created_aliquots++;
						$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][] = array_merge(
							$generic_aliquot_used_data, 
							array('shippings' => array(
								'recipient' => "'".$matches[2]."'",
								'shipping_datetime' => "'".$matches[3].$matches[4]."-01 00:00:00'",
								'shipping_datetime_accuracy' => "'d'"))
						);						
					}
				} else {
					die('ERR 989930033 '.$line_data['Dons1']);
				}
				
				if(!empty($line_data['Dons2'])) {
					if(preg_match('/^([0-9]+) (Aris|TFRI) (19|20)([0-9]{2}\-[0-1][0-9])$/', $line_data['Dons2'], $matches)) {
						for($i = 0; $i < $matches[1]; $i++) {
							$used_aliquots_counter++;
							$created_aliquots++;
							$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][] = array_merge(
								$generic_aliquot_used_data, 
								array('shippings' => array(
									'recipient' => "'".$matches[2]."'",
									'shipping_datetime' => "'".$matches[3].$matches[4]."-01 00:00:00'",
									'shipping_datetime_accuracy' => "'d'"))
							);				
						}
					} else {
						die('ERR 989930033.2 '.$line_data['Dons2']);
					}
				}				
				
				if($used_aliquots_counter != $aliquot_used_nbr) die('ERR ['.$line_counter.'] 8899393');
			
			} else if(!empty($line_data['Dons2'])) {
				die('ERR ['.$line_counter.'] 8899944 ['.$line_data['Dons2'].']');
			}
			
			if($created_aliquots != $expected_nbr_of_tubes) Config::$summary_msg['ASCITE 2 ml']['@@WARNING@@']['Tube defintion error'][] = "The number of tubes defined into Qté ($expected_nbr_of_tubes) is different than the number of created tubes ($created_aliquots)! [line: $line_counter]";
		}
	}
	
	return $collections_to_create;
}

function loadAscite10mlCollection($collections_to_create) {
		
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('Ascite Disponible (10ml)', $sheets_nbr)) die("ERROR: Worksheet Ascite Disponible (10ml) is missing!\n");

	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr['Ascite Disponible (10ml)']]['cells'] as $line => $new_line) {	
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

			if(empty($line_data['Qté'])) {
				Config::$summary_msg['ASCITE 10 ml']['@@ERROR@@']['Empty Qté'][] = "No Qté: Row data won't be migrated! [line: $line_counter]";
				continue;
			}
			
			// GET Participant Id & Misci Identifier Id & FRSQ Nbr
			
			if(empty($line_data['Échantillon']) && empty($line_data['#FRSQ'])) {
				Config::$summary_msg['ASCITE 10 ml']['@@ERROR@@']['No FRSQ # & Échantillon value'][] = "No FRSQ# & Échantillon values. Data won't be migrated! [line: $line_counter]";
				continue;
			}
			
			$echantillon_value = preg_replace('/ +$/','',$line_data['Échantillon']);
			$frsq_value = preg_replace('/ +$/','',$line_data['#FRSQ']);
			
			$ids = getParticipantIdentifierAndDiagnosisIds('ASCITE 10 ml', $line_counter, $frsq_value, $echantillon_value);
			if(empty($ids)) continue;
			
			$participant_id = $ids['participant_id'];
			$misc_identifier_id = $ids['misc_identifier_id'];
			$diagnosis_master_id = $ids['diagnosis_master_id'];

			// GET CONSENT_MASTER_ID	
					
			$consent_master_id = isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'])? Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] : null;
	
			// Collection
			
			$collection_date = '';
			$collection_date_accuracy = '';
			if(!empty($line_data['Date collecte'])) {
				$collection_date = customGetFormatedDate($line_data['Date collecte'], 'ASCITE 10 ml', $line_counter).' 00:00:00';
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
			
			// Ascite
			
			$line_data['Heure Réception'] = str_replace('ND','',$line_data['Heure Réception']);
			if(!empty($line_data['Heure Réception']) && empty($collection_date)) die('ERR 890wwww003');
			if(!empty($line_data['Heure Réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Réception'], $matches)) die('ERR  ['.$line_counter.'] 890rqrqrq004 be sure cell custom format is h:mm ['.$line_data['Heure Réception'].']');
			$reception_datetime = (!empty($line_data['Heure Réception']))? str_replace('00:00:00', $line_data['Heure Réception'].':00', $collection_date) : $collection_date;
			$reception_datetime_accuracy = (!empty($line_data['Heure Réception']))? 'c' : $collection_date_accuracy;
			
			if(!isset($collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime])) {
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['sample_masters'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['specimen_details'] = array('reception_datetime' => "'$reception_datetime'", 'reception_datetime_accuracy' => "'$reception_datetime_accuracy'");
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives'] = array();
			}
			
			// Ascite supernatant
			
			if(!isset($collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'])) {
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['sample_masters'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['derivative_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['derivatives'] = array();
			}			
			
			// Ascite supernatant Tube
					
			$aliquot_label = $line_data['Échantillon'];
			
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
			$line_data['Heure congélation'] = str_replace('ND','',$line_data['Heure congélation']);
			if(!empty($line_data['Date collecte'])) {
				$storage_datetime = customGetFormatedDate($line_data['Date collecte'], 'ASCITE 10 ml', $line_counter).' 00:00:00';
				$storage_datetime_accuracy = 'h';
				if(!empty($line_data['Heure congélation'])) {
					if(!preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure congélation'], $matches)) die('ERR  ['.$line_counter.'] 89000eqweddd4');
					$storage_datetime = str_replace('00:00:00', $line_data['Heure congélation'].':00', $storage_datetime);
					$storage_datetime_accuracy = 'c';
				}
			} else if(!empty($line_data['Heure congélation'])) {
				die('ERR ['.$line_counter.'] 99994www884');
			}
			
			$remisage = str_replace(array(' ','ND'), array('',''), $line_data['Temps au remisage']);
			if(!empty($remisage)) {
				if(!in_array($remisage, array('<1h','1h<<4h','4h<','<8h'))) {
					if(preg_match('/^00:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '<1h';
					} else if(preg_match('/^0[1-3]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '1h<<4h';
					} else if(preg_match('/^0[4-7]:[0-5][0-9]$/',$remisage, $matches)) {
						$remisage = '<8h';
					} else {
						Config::$summary_msg['ASCITE 10 ml']['@@ERROR@@']['Remisage error'][] = "unsupported remisage value : $remisage (be sure cell custom format is h:mm)! [line: $line_counter]";
						$remisage = '';
					}
				}	
			}		
			
			$created_aliquots = 0;
			$ascite_volume = $line_data['Qté'];
			if(!preg_match('/^[0-9]*$/', $ascite_volume, $matches)) die('ERR 9994849944 ' . $ascite_volume);
			if(!empty($line_data['Emplacement'])) {
				// Created stored aliquot
				if(empty($line_data['Boite'])) die('ERR  ['.$line_counter.'] 88990rrr373'.$line_data['Boite'].'//'.$line_data['Emplacement']);
				
				$storage_master_id = getStorageId('ascite 10ml', 'box49', $line_data['Boite']);
				
				$stored_aliquots_positions = array();
				$emplacement_tmp = str_replace(array(' ','.'), array('',','), $line_data['Emplacement']);
				if(preg_match('/^0([1-9])$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions[] = $matches[1];
				} else if(preg_match('/^([1-9]|[1-4][0-9])$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions[] = $matches[1];
				} else if(preg_match('/^([1-9],|[1-4][0-9],)+([1-9]|[1-4][0-9])$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions = explode(',',$emplacement_tmp);
				} else if(preg_match('/^0{0,1}([1-9]|[1-4][0-9])-0{0,1}([1-9]|[1-4][0-9])$/', $emplacement_tmp, $matches)) {
					$start = $matches[1];
					$end  = $matches[2];
					if($start >= $end) die('ERR ['.$line_counter.'] 89938399303 : '.$emplacement_tmp);
					While($start <=  $end) {
						$stored_aliquots_positions[] = $start;
						$start++;
					}
				} else {
					die('ERR  ['.$line_counter.'] 9984949494 : '.$emplacement_tmp);
				}
				
				$div = sizeof($stored_aliquots_positions);
				$div = (empty($div)? 1 : $div);
				$ascite_volume_per_tube = $ascite_volume / $div;
				
				foreach($stored_aliquots_positions as $new_pos) {
					$created_aliquots++;
					$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][] = array(
						'aliquot_masters' => array(
							'aliquot_label' => "'$aliquot_label'", 
							'initial_volume' => "'$ascite_volume_per_tube'",
							'current_volume' => "'$ascite_volume_per_tube'",
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
				}
			} else {
				
				// Created unstored aliquot?
				Config::$summary_msg['ASCITE 10 ml']['@@WARNING@@']['Creating unpositioned aliquot'][] = "Will create one tube unpositioned. See line: $line_counter";
				
				$storage_master_id = (!empty($line_data['Boite']))? getStorageId('ascite_10_ml', 'box49', $line_data['Boite']) : '';
				
				$created_aliquots++;
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][] = array(
					'aliquot_masters' => array(
						'aliquot_label' => "'$aliquot_label'", 
						'initial_volume' => "'$ascite_volume'",
						'current_volume' => "'$ascite_volume'",
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
			}
			
			if(!empty($line_data['Dons Volume']) || !empty($line_data['à Qui']) || !empty($line_data['Date'])) {
				if(empty($line_data['Dons Volume']) || empty($line_data['à Qui']) || empty($line_data['Date'])) die('ERR ['.$line_counter.'] 8899edddee944');
				if(!preg_match('/^[0-9]+$/',$line_data['Dons Volume'],$matches)) die('ERR ['.$line_counter.'] 8899eeedeeeedd944');
				if(!preg_match('/^(19|20)([0-9]{2}\-[0-1][0-9])$/',$line_data['Date'],$matches)) die('ERR ['.$line_counter.'] 88aascc2eeeedd944');
				if(!preg_match('/^(aliquot 1 ml)$/',$line_data['à Qui'],$matches)) die('ERR ['.$line_counter.'] 88aasccddddd2eeeedd944');
				if($created_aliquots != 1) die('ERR ['.$line_counter.'] 88adcacadd944');
				
				$aliquot_internal_uses = array();
				for($i = 0; $i < $line_data['Dons Volume']; $i++) {
					$aliquot_internal_uses[] = array(
						'use_code' => "'?'",
						'used_volume' => "'1'",
						'use_datetime' => "'".$line_data['Date']."-01 00:00:00'",
						'use_datetime_accuracy' => "'d'"
					);						
				}
				
				$last_aliquot_key = sizeof($collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots']) - 1;
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][$last_aliquot_key]['aliquot_internal_uses'] = $aliquot_internal_uses;
				$initial_volume = $collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][$last_aliquot_key]['aliquot_masters']['initial_volume'];
				$initial_volume = str_replace("'","",$initial_volume);
				$initial_volume += $line_data['Dons Volume'];
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives']['ascite supernatant'][0]['aliquots'][$last_aliquot_key]['aliquot_masters']['initial_volume'] = $initial_volume;
			}
		}
	}
	
	return $collections_to_create;
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
					
			$echantillon_value = preg_replace('/ +$/','',$line_data['Échantillon']);
			$frsq_value = preg_replace('/ +$/','',$line_data['# FRSQ']);

			$ids = getParticipantIdentifierAndDiagnosisIds('TISSU', $line_counter, $frsq_value, $echantillon_value);
			if(empty($ids)) continue;
			
			$participant_id = $ids['participant_id'];
			$misc_identifier_id = $ids['misc_identifier_id'];
			$diagnosis_master_id = $ids['diagnosis_master_id'];

			// GET CONSENT_MASTER_ID	
					
			$consent_master_id = isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'])? Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] : null;
	
			// Collection
			
			$collection_date = '';
			$collection_date_accuracy = '';
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
			
			$line_data['Heure Réception'] = str_replace(array('ND','?',' '),array('','',''),$line_data['Heure Réception']);
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
				
				if(preg_match('/^OV(N|C)[0-9]{1,4}.*$/', $line_data['Échantillon'], $matches)) {
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
			
			$aliquot_label = $line_data['Échantillon'];
			$note_to_add = utf8_encode($line_data['Note']);
			if(!empty($note_to_add)) {
				$note_to_add = str_replace("'", "''", $note_to_add);
				$tmp_existing_note = substr($collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_masters']['notes'], 1, (strlen($collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_masters']['notes'])-2));
				$new_note = "''";
				if(strlen($tmp_existing_note)) {
					$new_note = "'$tmp_existing_note // $note_to_add'";
				} else {
					$new_note = "'$note_to_add'";
				}
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_masters']['notes'] = $new_note;
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
					} else {
						Config::$summary_msg['TISSU']['@@ERROR@@']['Remisage error'][] = "unsupported remisage value : $remisage (be sure cell custom format is h:mm)! [line: $line_counter]";
						$remisage = '';
					}
				}	
			}		
			
			$stored_tissue_weights = array();
			foreach(array($line_data['Poids 1 (mg)'],$line_data['Poids 2 (mg)']) as $new_weight) {
				$new_weight = str_replace(array('-','ND',' '), array('','',''), $new_weight);
				if(!empty($new_weight)) {
					if($new_weight == '~200') {
						$stored_tissue_weights[] = array('value' => '200', 'note' => 'Weight defined as ~200');
					} else if($new_weight == '<50') {
						$stored_tissue_weights[] = array('value' => '49', 'note' => 'Weight defined as < 50');
					} else if(preg_match('/^([0-9]+),([0-9]+)$/', $new_weight, $matches)) {
						$stored_tissue_weights[] = array('value' => $matches[1], 'note' => '');
						$stored_tissue_weights[] = array('value' => $matches[2], 'note' => '');
					} else if(preg_match('/^([0-9]+)$/', $new_weight, $matches)) {
						$stored_tissue_weights[] = array('value' => $matches[1], 'note' => '');
					} else {
						$stored_tissue_weights[] = array('value' => '', 'note' => 'Unsupported weight: '.$new_weight);
						Config::$summary_msg['TISSU']['@@ERROR@@']['Tissue weight format error'][] = "The unit or format of weight ($new_weight) is not supported! Value will be recorded in note! [line: $line_counter]";
						//die('ERR88948399 '.$new_weight);
					}
				}
			}
						
			$stored_tissue_positions = array();
			$tmp_intial_emplacement = $line_data['Emplacement'];
			$line_data['Emplacement'] = str_replace(array(' ','.'),array('',','), $line_data['Emplacement']);			
			$line_data['Emplacement'] = preg_replace('/^(.*),$/','$1', $line_data['Emplacement']);		
			$line_data['Boite'] = str_replace(array(' '),array(''), $line_data['Boite']);
			if(!empty($line_data['Emplacement'])) {
				// Created stored aliquot
				if(empty($line_data['Boite'])) die('ERR  ['.$line_counter.'] 88990rrr373 '.$line_data['Boite'].'//'.$line_data['Emplacement']);
				
				if(in_array($line_data['Emplacement'], array('81,01','81,1','81-1'))) {
					
					// 2 Boxes
					
					if(preg_match('/^(FT[0-9]\-[0-9]),(FT){0,1}([0-9]\-[0-9])$/', $line_data['Boite'], $matches)) {
						$stored_tissue_positions[] = array('box' => $matches[1], 'pos' => '81');
						$stored_tissue_positions[] = array('box' => (empty($matches[2])? 'FT'.$matches[3] : $matches[2].$matches[3]), 'pos' => '1');
					} else {
						die('ERRR storage emplacement x2 '.$line_data['Boite']);
					}
					
				} else {
					
					// 1 Box
					
					if(!preg_match('/^(FT[0-9]\-[0-9]|L[0-9]R[0-9]B[0-9])$/', $line_data['Boite'], $matches)) die('ERR  ['.$line_counter.'] 88990reeeeesa3 '.$line_data['Boite'].'//'.$line_data['Emplacement']);
					if(preg_match('/^0([1-9])$/', $line_data['Emplacement'], $matches)) {
						$stored_tissue_positions[] = array('box' => $line_data['Boite'], 'pos' => $matches[1]);
					} else if(preg_match('/^([1-9]|[1-7][0-9]|80|81)$/', $line_data['Emplacement'], $matches)) {
						$stored_tissue_positions[] = array('box' => $line_data['Boite'], 'pos' => $matches[1]);
					} else if(preg_match('/^0{0,1}([1-9]|[1-7][0-9]|80)-0{0,1}([1-9]|[1-7][0-9]|80|81)$/', $line_data['Emplacement'], $matches)) {
						$start = $matches[1];
						$end = $matches[2];					
						if($start >= $end) die('ERR ['.$line_counter.'] 89938399303 : '.$line_data['Boite'].'//'.$line_data['Emplacement']);
						While($start <=  $end) {
							$stored_tissue_positions[] = array('box' => $line_data['Boite'], 'pos' => $start);
							$start++;
						}
					} else if(preg_match('/^([1-9],|[1-7][0-9],|80,|81,)+([1-9]|[1-7][0-9]|80|81)$/', $line_data['Emplacement'], $matches)) {
						foreach(explode(',', $line_data['Emplacement']) as $new_pos) {
							$stored_tissue_positions[] = array('box' => $line_data['Boite'], 'pos' => $new_pos);
						}					
					} else if(preg_match('/^([1-9]-|[1-7][0-9]-|80-|81-)+([1-9]|[1-7][0-9]|80|81)$/', $line_data['Emplacement'], $matches)) {
						foreach(explode('-', $line_data['Emplacement']) as $new_pos) {
							$stored_tissue_positions[] = array('box' => $line_data['Boite'], 'pos' => $new_pos);
						}										
					} else {
						die('ERR  ['.$line_counter.'] 9984949494 : '.$line_data['Boite'].'//'.$line_data['Emplacement']);
					}
				}
			}
				
			if(!empty($stored_tissue_weights) && (sizeof($stored_tissue_positions) != sizeof($stored_tissue_weights))) {
				Config::$summary_msg['TISSU']['@@WARNING@@']['Tissue weight error'][] = "The number of stored tissues is different than the number of tissue weights defined! [line: $line_counter]";
			}
			
			$nbr_of_created_aliquot = 0;
			$nbr_of_stored_aliquots = 0;
			foreach($stored_tissue_positions as $key => $new_stored_aliquot) {
				$storage_master_id = getStorageId('tissue', 'box81', $new_stored_aliquot['box']);
				$new_pos =  $new_stored_aliquot['pos'];
				
				$weight = '';
				$aliquot_note = '';
				if(isset($stored_tissue_weights[$key])) {
					$weight = $stored_tissue_weights[$key]['value'];
					$aliquot_note = $stored_tissue_weights[$key]['note'];					
				}
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['aliquots'][] = array(
					'aliquot_masters' => array(
						'aliquot_label' => "'$aliquot_label'", 
						'in_stock' => "'yes - available'",
						'storage_master_id' => "'$storage_master_id'",
						'storage_datetime' => "'$storage_datetime'",
						'storage_datetime_accuracy' => "'$storage_datetime_accuracy'",
						'storage_coord_x' => "'$new_pos'",
						'storage_coord_y' => "''",
						'chus_time_limit_of_storage' => "'$remisage'",
						'notes' => "'$aliquot_note'"),				
					'aliquot_details' => array(
						'chus_tissue_weight_mgr' => "'$weight'"
					),
					'aliquot_internal_uses' => array(),
					'shippings' => array()
				);

				$nbr_of_created_aliquot++;
				$nbr_of_stored_aliquots++;
			}
			
			$shipped_aliquots = array();
			foreach(array($line_data['Dons1'], $line_data['Dons2']) as $new_dons) {
				$test_empty = str_replace(' ','',$new_dons);
				if(strlen($test_empty)) {
					$new_shipments = explode(',', utf8_encode($new_dons));
					foreach($new_shipments as $new_shipment) {
						
						$shipped_aliquots_nbr = 0;
						$recipient = '';
						$shipping_datetime = '';
						$shipping_datetime_accuracy = '';
						if(preg_match('/^ {0,1}([0-9]+) (.*) (19|20)([0-9]{2}-[0-1][0-9])$/',$new_shipment, $matches)) {
							$shipped_aliquots_nbr = $matches[1];
							$recipient = $matches[2];
							$shipping_datetime = $matches[3].$matches[4]."-01 00:00:00";
							$shipping_datetime_accuracy = 'd';
						
						} else if(preg_match('/^ {0,1}([0-9]+) (.*) ([0-1][0-9])-(19|20)([0-9]{2})$/', $new_shipment, $matches)) {
							$shipped_aliquots_nbr = $matches[1];
							$recipient = $matches[2];
							$shipping_datetime = $matches[4].$matches[5]."-".$matches[3]."-01 00:00:00";
							$shipping_datetime_accuracy = 'd';
							
						} else if(preg_match('/^ {0,1}([0-9]+) {0,1}(.*) {0,1}([0-2][0-9]|30|31)-(0[0-9]|1[0-2])-(0[0-9]|1[0-2]) {0,1}$/', $new_shipment, $matches)) {
							$shipped_aliquots_nbr = $matches[1];
							$recipient = $matches[2];
							$shipping_datetime = '20'.$matches[5]."-".$matches[4]."-".$matches[3]." 00:00:00";
							$shipping_datetime_accuracy = 'h';
	
						} else  if(preg_match('/^ {0,1}([0-9]+) {0,1}(.+)$/', $new_shipment, $matches)) {
							$shipped_aliquots_nbr = $matches[1];
							switch($matches[2]) {
								case 'FTOG GDM 23/06/06':
									$recipient = 'FTOG GDM';
									$shipping_datetime = "2006-06-23 00:00:00";
									$shipping_datetime_accuracy = 'h';
									break;
								case 'Elvy 20-08-08 (35)':
									$recipient = 'Elvy (35)';
									$shipping_datetime = "2008-08-20 00:00:00";
									$shipping_datetime_accuracy = 'h';
									break;
								case 'Elvy 02-03-2009':
									$recipient = 'Elvy';
									$shipping_datetime = "2009-03-02 00:00:00";
									$shipping_datetime_accuracy = 'h';
									break;
								case 'GDM 7/2/20':
									$recipient = 'GDM';
									$shipping_datetime = "2007-02-20 00:00:00";
									$shipping_datetime_accuracy = 'h';
									break;
								case 'FT ???':
								case 'FT':
									$recipient = 'FT ???';
									break;
								case '???':
									$recipient = '???';
									break;
								default;
									Config::$summary_msg['TISSU']['@@ERROR@@']['Unsupported shipping information'][] = "The shipping information format ($new_shipment) is not supported by the migration process (good one can be [1 GDM 29-06-06]). No shipped aliquot will be created! [line: $line_counter]";
									$shipped_aliquots_nbr = 0;
							}
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
								'aliquot_details' => array(
									//No weitgh for shipped aliquot'chus_tissue_weight_mgr' => "'$weight'"
								),
								'aliquot_internal_uses' => array(),
								'shippings' => array(
									'recipient' => "'$recipient'",
									'shipping_datetime' => "'$shipping_datetime'",
									'shipping_datetime_accuracy' => "'$shipping_datetime_accuracy'"));
							$nbr_of_created_aliquot++;
						}
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

function loadBloodCollection($collections_to_create, &$dnas_from_ov_nbr) {
	
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

			$ids = getParticipantIdentifierAndDiagnosisIds('TISSU', $line_counter, $frsq_value, '');
			if(empty($ids)) continue;
			
			$participant_id = $ids['participant_id'];
			$misc_identifier_id = $ids['misc_identifier_id'];
			$diagnosis_master_id = $ids['diagnosis_master_id'];

			// GET CONSENT_MASTER_ID	
					
			$consent_master_id = isset(Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'])? Config::$data_for_import_from_participant_id[$participant_id]['consent_master_id'] : null;
	
			// Collection
			
			$collection_date = '';
			$collection_date_accuracy = '';
			if(!empty($line_data['Date Réception'])) {
				$collection_date = customGetFormatedDate($line_data['Date Réception'], 'TISSU', $line_counter).' 00:00:00';
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
					
			$line_data['Heure réception'] = str_replace(array('ND','?',' '),array('','',''),$line_data['Heure réception']);
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
				if(array_key_exists($frsq_value, $dnas_from_ov_nbr)) {
					$add_to_collection = true;
					$tmp_reception_datetime = str_replace(array(' ','-',':',"'"), array('','','',''), $reception_datetime);
					foreach($dnas_from_ov_nbr[$frsq_value] as $new_dna) {
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
					if($add_to_collection) $collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['dna'] = $dnas_from_ov_nbr[$frsq_value];
					unset($dnas_from_ov_nbr[$frsq_value]);
				}
			}
			
			// Plasma
			
			$centrifugation_date = '';
			$centrifugation_date_accuracy = '';
			if(!empty($line_data['Date traitement'])) {
				$centrifugation_date = customGetFormatedDate($line_data['Date traitement'], 'DNA', $line_counter).' 00:00:00';
				$centrifugation_date_accuracy = 'h';
				if(!empty($line_data['Heure début Traitement'])) {
					if(!preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure début Traitement'], $matches)) die('ERR  ['.$line_counter.'] fafasassa cacacacbe sure cell custom format is h:mm ['.$line_data['Heure début Traitement'].']');
					$centrifugation_date = str_replace('00:00:00', $line_data['Heure début Traitement'].':00', $centrifugation_date);
					$centrifugation_date_accuracy = 'c';
				}
			} else if(!empty($line_data['Heure début Traitement'])) {
				die("ERR 8873838 839 [$line_counter] [".$line_data['Date traitement']."] [".$line_data['Heure début Traitement']."]");
			}
			
			// plasma
			
			if(!isset($collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'])) {
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['sample_masters'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['derivative_details'] = array('creation_datetime' => "'$centrifugation_date'", 'creation_datetime_accuracy' => "'$centrifugation_date_accuracy'");
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['derivatives'] = array();
			}			
			
			// plasma Tube
			
			$aliquot_label = $line_data['# FRSQ'];
			
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
			$nbr_of_stored_aliquots = 0;
			
			$emplacement = str_replace(array(' ', utf8_decode('épuisé')),array('',''), $line_data['Emplacement']);
			if(!empty($emplacement)) {
				
				// Created stored aliquot
				
				$aliquot_positions = array();
				
				$boite = str_replace(array(' ', '-', '.'),array('',',',','), $line_data['Boite']);
				if(empty($boite)) die('ERR  ['.$line_counter.'] 8899034423273 '.$line_data['Boite'].' // '.$line_data['Emplacement']);
				
				if(preg_match('/^([0-9]+)$/', $boite, $matches)) {
					// - 1 - Box
					if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 33
						$aliquot_positions[] = array('box_label' => $boite, 'position' => $emplacement);
					} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 12-33
						if($matches[2] < $matches[1]) die('ERR 78939393 '.$emplacement);
						for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $boite, 'position' => $i);	
					} else if(preg_match('/^([1-9]|[1-9][0-9]|100),([1-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 12,23
						$aliquot_positions[] = array('box_label' => $boite, 'position' => $matches[1]);
						$aliquot_positions[] = array('box_label' => $boite, 'position' => $matches[2]);
					} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100),([1-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 12-14,22
						if($matches[2] < $matches[1]) die('ERR 7893939ee3 '.$emplacement);
						for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $boite, 'position' => $i);								
						$aliquot_positions[] = array('box_label' => $boite, 'position' => $matches[3]);	
					} elseif(preg_match('/^([1-9]|[1-9][0-9]|100),([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 12,22-24						
						$aliquot_positions[] = array('box_label' => $boite, 'position' => $matches[1]);
						if($matches[3] < $matches[2]) die('ERR 7893939ee3 '.$emplacement);
						for($i=$matches[2];$i <= $matches[3];$i++) $aliquot_positions[] = array('box_label' => $boite, 'position' => $i);			
					} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100),([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $emplacement, $matches)) {
						// 12-14,22-88
						if($matches[2] < $matches[1]) die('ERR 7893939easdasde3 '.$emplacement);
						for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $boite, 'position' => $i);								
						if($matches[4] < $matches[3]) die('ERR 7893939ddeee3 '.$emplacement);
						for($i=$matches[3];$i <= $matches[4];$i++) $aliquot_positions[] = array('box_label' => $boite, 'position' => $i);		
					} else {
						Config::$summary_msg['BLOOD']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the blood aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
					}
					
				} else if(preg_match('/^([0-9]+),([0-9]+)$/', $boite, $matches)) {
					$boite_1_label = $matches[1];
					$positions_1 = null;
					$boite_2_label = $matches[2];
					$positions_2 = null;
					
					if(preg_match('/^([0-9]+-{0,1}[0-9]*),([0-9]+-{0,1}[0-9]*)$/', $emplacement, $matches)) {
						$positions_1 = $matches[1];
						$positions_2 = $matches[2];
						
						if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $positions_1, $matches)) {
							// 33
							$aliquot_positions[] = array('box_label' => $boite_1_label, 'position' => $positions_1);
						} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $positions_1, $matches)) {
							// 12-33
							if($matches[2] < $matches[1]) die('ERR 78939393 '.$positions_1);
							for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $boite_1_label, 'position' => $i);	
						} else {
							$positions_2 = null;
							Config::$summary_msg['BLOOD']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the blood aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
						}
						if(!is_null($positions_2)) {
							if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $positions_2, $matches)) {
								// 33
								$aliquot_positions[] = array('box_label' => $boite_2_label, 'position' => $positions_2);
							} else if(preg_match('/^([1-9]|[1-9][0-9])-([2-9]|[1-9][0-9]|100)$/', $positions_2, $matches)) {
								// 12-33
								if($matches[2] < $matches[1]) die('ERR 78939393 '.$positions_2);
								for($i=$matches[1];$i <= $matches[2];$i++) $aliquot_positions[] = array('box_label' => $boite_2_label, 'position' => $i);	
							} else {	
								Config::$summary_msg['BLOOD']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the blood aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
							}
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
					$nbr_of_stored_aliquots++;
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
			
			$shipping_data = array(
				'1' => array('aliquot_nbr' => $line_data['Dons#1'], 'recipient' => $line_data['à qui#1'], 'date' => $line_data['Date#1']),
				'2' => array('aliquot_nbr' => $line_data['Dons#2'], 'recipient' => $line_data['à qui#2'], 'date' => $line_data['Date#2']),
				'3' => array('aliquot_nbr' => $line_data['Dons#3'], 'recipient' => $line_data['à qui#3'], 'date' => $line_data['Date#3'])
			);
			foreach($shipping_data as $key => $new_shipping) {
			
				if(!empty($new_shipping['aliquot_nbr']) || !empty($new_shipping['recipient']) || !empty($new_shipping['date'])) {
					if(empty($new_shipping['aliquot_nbr']) || empty($new_shipping['recipient']) || empty($new_shipping['date'])) {
						Config::$summary_msg['BLOOD']['@@ERROR@@']["Shipping Error 1"][] = "At least one information (either nbr of aliquots or date or recipient) is missing for the shipping #$key! [line: $line_counter]";		
					} else {
						$new_shipping['recipient'] = str_replace(' ','',$new_shipping['recipient']);
						if(!preg_match('/^[0-9]+$/',$new_shipping['aliquot_nbr'],$matches)) {
							Config::$summary_msg['BLOOD']['@@ERROR@@']["Shipping Error 2"][] = "Wrong aliquots number format (".$new_shipping['aliquot_nbr']."). See shipping #$key! No shipping will be created! [line: $line_counter]";	
						} else 	if(!preg_match('/^(Aris|MDEIE|TFRI)$/',$new_shipping['recipient'],$matches)){
							Config::$summary_msg['BLOOD']['@@ERROR@@']["Shipping Error 3"][] = "Wrong recipient format (".$new_shipping['recipient']."). See shipping #$key! No shipping will be created! [line: $line_counter]";	
						} else 	if(!preg_match('/^(19|20)([0-9]{2}\-[0-1][0-9])+$/',$new_shipping['date'],$matches)){
							Config::$summary_msg['BLOOD']['@@ERROR@@']["Shipping Error 4"][] = "Wrong date format (".$new_shipping['date']."). See shipping #$key! No shipping will be created! [line: $line_counter]";	
						} else {
							for($i = 0; $i < $new_shipping['aliquot_nbr']; $i++) {
								$created_aliquots++;
								$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['derivatives']['plasma'][$centrifugation_date]['aliquots'][] = array(
									'aliquot_masters' => array(
										'aliquot_label' => "'$aliquot_label'", 
			//							'initial_volume' => "'1'",
			//							'current_volume' => "'1'",
										'in_stock' => "'no'",
										'in_stock_detail' => "'shipped'",
										'storage_master_id' => "''",
										'storage_datetime' => "'$storage_datetime'",
										'storage_datetime_accuracy' => "'$storage_datetime_accuracy'",
										'storage_coord_x' => "''",
										'storage_coord_y' => "''"),				
									'aliquot_details' => array(),
									'aliquot_internal_uses' => array(),
									'shippings' => array(
										'recipient' => "'".$new_shipping['recipient']."'",
										'shipping_datetime' => "'".$new_shipping['date']."-01 00:00:00'",
										'shipping_datetime_accuracy' => "'d'")
								);
							}
						}
					}
				}
			}
			
			
			// QUANTITY CHECK
			
			if(($line_data['Qté'] != '-') && ($line_data['Qté'] != $nbr_of_stored_aliquots)) Config::$summary_msg['BLOOD']['@@ERROR@@']['Stored aliquots nbr mis-match'][] = "$nbr_of_stored_aliquots aliquots have been defined as stored by the process but the 'Qté' defined into the file was equal to ".$line_data['Qté']. "('Emplacement' = ".$line_data['Emplacement'].")! [line: $line_counter]";
			if(!$created_aliquots) Config::$summary_msg['BLOOD']['@@ERROR@@']['No aliquot created'][] = "No shipped or stored aliquot has been created! [line: $line_counter]";

		} // End new line
	}
	
	if(!empty($dnas_from_ov_nbr)) {		
		$ov_nbrs = array_keys($dnas_from_ov_nbr);
		$ov_nbrs = implode(', ', $ov_nbrs);
		Config::$summary_msg['DNA']['@@ERROR@@']['DNA not found in Blood'][] = "The following OV NBRs are found in DNA worksheet but not found into blood worksheet: ".$ov_nbrs."! Won't be imported! [line: $line_counter]";
	}
	
	return $collections_to_create;	
}

function loadDNACollection() {
	
	$dnas_from_ov_nbr = array();
	
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
			
			if(empty($line_data['# FRSQ']) || !strlen($line_data['Qté ug'])) {
				Config::$summary_msg['DNA']['@@ERROR@@']['Empty fields'][] = "No '# FRSQ' or 'Qté ug': Row data won't be migrated! [line: $line_counter]";
				continue;					
			}
			
			// GET Sample Data
					
			$ov_nbr = preg_replace('/ +$/','',$line_data['# FRSQ']);
			
			$extraction_date = '';
			$extraction_date_accuracy = '';
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
			
			$aliquot_label = preg_replace('/ +$/','',$line_data['Échantillon']);
			
			$inital_weight = $line_data['Qté ug'];		
			if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', '9', $matches)) {
				Config::$summary_msg['DNA']['@@ERROR@@']['Qté format'][] = "The format of the Qté value ($inital_weight) is not supported! No row data will be imported! [line: $line_counter]";
				continue;
			}		
	
			$current_weight = $line_data['Reste'];
			if(!preg_match('/^-{0,1}[0-9]+(\.[0-9]+){0,1}$/', $inital_weight, $matches)) {
				Config::$summary_msg['DNA']['@@ERROR@@']['Reste format'][] = "The format of the Reste value ($inital_weight) is not supported! No row data will be imported! [line: $line_counter]";
				continue;
			}
			if($current_weight < 0) {
				$current_weight = '0';
				Config::$summary_msg['DNA']['@@ERROR@@']['Reste format'][] = "Negatif 'reste': value will be set to 0! [line: $line_counter]";
			}				
			
			$concentration = '';
			if(strlen($line_data['Concentration (ug/ml)'])) {
				$concentration = $line_data['Concentration (ug/ml)'];
				if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $concentration, $matches)) {
					Config::$summary_msg['DNA']['@@WARNING@@']['Concentration format'][] = "The format of the concentration value ($concentration) is not supported! [line: $line_counter]";
					$concentration = '';
				}
			}
			
			$ratio = '';
			if(strlen($line_data['Ratio 260/280']) && ($line_data['Ratio 260/280'] != 'ND')) {
				$ratio = $line_data['Ratio 260/280'];
				if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $ratio, $matches)) {
					Config::$summary_msg['DNA']['@@WARNING@@']['Ratio format'][] = "The format of the Ratio value ($ratio) is not supported! [line: $line_counter]";
					$ratio = '';
				}
			}			
			
			$shipping_data = array(
				'1' => array('aliquot_weight' => $line_data['Dons (ug) #1'], 'recipient' => $line_data['à qui #1'], 'date' => $line_data['Date #1']),
				'2' => array('aliquot_weight' => $line_data['Dons (ug) #2'], 'recipient' => $line_data['à qui #2'], 'date' => $line_data['Date #2'])
			);
			$shipped_weight  = 0;
			foreach($shipping_data as $key => $new_shipping) {
				if(!empty($new_shipping['aliquot_weight']) || !empty($new_shipping['recipient']) || !empty($new_shipping['date'])) {					
					if(empty($new_shipping['aliquot_weight']) || empty($new_shipping['recipient']) || empty($new_shipping['date'])) {
						Config::$summary_msg['DNA']['@@ERROR@@']["Shipping Error 1"][] = "At least one information (either nbr of aliquots or date or recipient) is missing for the shipping #$key! [line: $line_counter]";		
					} else {
						$new_shipping['aliquot_weight'] = str_replace(',','.',$new_shipping['aliquot_weight']);
						if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $new_shipping['aliquot_weight'],$matches)) {
							Config::$summary_msg['DNA']['@@ERROR@@']["Shipping Error 2"][] = "Wrong aliquots number format (".$new_shipping['aliquot_weight']."). See shipping #$key! No shipping will be created! [line: $line_counter]";	
						} else 	if(!preg_match('/^(TFRI)$/',$new_shipping['recipient'],$matches)){
							Config::$summary_msg['DNA']['@@ERROR@@']["Shipping Error 3"][] = "Wrong recipient format (".$new_shipping['recipient']."). See shipping #$key! No shipping will be created! [line: $line_counter]";	
						} else 	if(!preg_match('/^(19|20)([0-9]{2}\-[0-1][0-9])+$/',$new_shipping['date'],$matches)){
							Config::$summary_msg['DNA']['@@ERROR@@']["Shipping Error 4"][] = "Wrong date format (".$new_shipping['date']."). See shipping #$key! No shipping will be created! [line: $line_counter]";	
						} else {
							$shipped_weight += $new_shipping['aliquot_weight'];
							$new_dna['aliquots'][] = array(
									'aliquot_masters' => array(
										'aliquot_label' => "'$aliquot_label'", 
										'initial_volume' => "'".$new_shipping['aliquot_weight']."'",
										'current_volume' => "'".$new_shipping['aliquot_weight']."'",
										'in_stock' => "'no'",
										'in_stock_detail' => "'shipped'",
										'storage_master_id' => "''",
										'storage_datetime' => "''",
										'storage_datetime_accuracy' => "''",
										'storage_coord_x' => "''",
										'storage_coord_y' => "''"),				
									'aliquot_details' => array(
										'chus_qc_ratio_260_280' => "'$ratio'",
										'concentration' => "'$concentration'",
										'concentration_unit' => (empty($concentration)? "''":"'ug/ml'")),
									'aliquot_internal_uses' => array(),
									'shippings' => array(
										'recipient' => "'".$new_shipping['recipient']."'",
										'shipping_datetime' => "'".$new_shipping['date']."-01 00:00:00'",
										'shipping_datetime_accuracy' => "'d'")
								);
						}
					}
				}
			}			
			
			if(empty($shipped_weight)) {
				if(($inital_weight - $current_weight) >= 0.01) {
					die("'Reste' != 'Qté ug' without shipping!");
				}
			} else {
				$calculated_current_weight = $inital_weight - $shipped_weight;
				if($calculated_current_weight < 0) {
					$calculated_current_weight = 0;
				}
				if(($calculated_current_weight - $current_weight) >= 0.01) {
					Config::$summary_msg['DNA']['@@ERROR@@']['Calculated current weight'][] = "Calculated current weight ($calculated_current_weight) is different than the value of 'reste' column in file ($current_weight)! No row data will be exported! [line: $line_counter]";
					continue;
				}
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
						
					} else if(preg_match('/^([0-9]+),([0-9]+)$/', $boite, $label_matches)) {
						if(preg_match('/^([1-9]|[1-9][0-9]|100),([1-9]|[1-9][0-9]|100)$/', $emplacement, $position_matches)) {
							$aliquot_positions[] = array('box_label' => $label_matches[1], 'position' => $position_matches[1]);
							$aliquot_positions[] = array('box_label' => $label_matches[2], 'position' => $position_matches[2]);
						} else {
							Config::$summary_msg['DNA']['@@ERROR@@']["'Boite' & 'Emplacement' errors"][] = "There is an error in the dna aliquot position defintion: Boite '$boite' && Emplacement '$emplacement' can not be loaded! No stored aliquot will be imported! [line: $line_counter]";
						}		
					} else  {
						die('ERR 89948793993 39 83 92 : '.$boite.' - '.$emplacement);
					}
				
				} else  {
					Config::$summary_msg['DNA']['@@WARNING@@']["'Boite' & 'Emplacement' warning"][] = "There is an aliquot stored into a box with no position: Boite '$boite' && Emplacement '$emplacement'. Please set position after migration process! [line: $line_counter]";
					if(!preg_match('/^([0-9]+)$/', $boite, $matches)) {
						pr($line_data); 
						die('ERR  ['.$line_counter.'] 88499 48 92 '.$line_data['Boite'].' // '.$line_data['Emplacement']);
					}
					$aliquot_positions[] = array('box_label' => $boite, 'position' => '');
				}
				
				$div_val = sizeof($aliquot_positions)? sizeof($aliquot_positions) : 1;
				$current_weight_per_aliquot = $current_weight/$div_val;
				if(sizeof($aliquot_positions) > 1) Config::$summary_msg['DNA']['@@MESSAGE@@']["Split current weight"][] = "Split current weight ($current_weight) in ".sizeof($aliquot_positions)." => ($current_weight_per_aliquot). Please confirm! [line: $line_counter]";
				if($current_weight_per_aliquot == '0.0') Config::$summary_msg['DNA']['@@ERROR@@']["Empty 'available' aliquot"][] = "The current weight of aliquot is equal to 0 but the status is still equal to 'yes - available'. Please confirm! [line: $line_counter]";
				foreach($aliquot_positions as $new_stored_aliquot) {
					$storage_master_id = getStorageId('dna', 'box100', $new_stored_aliquot['box_label']);
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
			$dnas_from_ov_nbr[$ov_nbr][] = $new_dna;
		} // End new line
	}
	
	return $dnas_from_ov_nbr;
}

function getParticipantIdentifierAndDiagnosisIds($worksheet, $line_counter, $frsq_value, $echantillon_value) {
	if(empty($frsq_value) && empty($echantillon_value)) die('ERR 888d88d88a9 '.$line_counter);
	
	// Get Data FROM FRSQ & ECHANTILLON
		
	$ov_nbr_from_frsq = $frsq_value;
	$ov_nbr_from_echantillon = '';
	$frsq_value_from_echantillon = '';
	if(preg_match('/^([A-Z]+)([0-9]+) {0,2}([a-zA-Z]+ {0,1}.*)$/', $echantillon_value, $matches)) {
		$frsq_value_from_echantillon = $matches[1].$matches[2];
		$ov_nbr_from_echantillon = 'OV'.$matches[2];
		if(!preg_match('/^OV([A-Z]{0,1})([0-9]+)$/', $frsq_value_from_echantillon, $matches)) {
			Config::$summary_msg[$worksheet]['@@WARNING@@']['Wrong format of "Échantillon" value'][] = "The format of the 'Échantillon' value [$echantillon_value] is not an expected format (like OV999 asc, OVB999 FA, etc)! [line: $line_counter]";
		}
		if(!empty($ov_nbr_from_frsq) && ($ov_nbr_from_frsq != $ov_nbr_from_echantillon)) {
			Config::$summary_msg[$worksheet]['@@WARNING@@']['2 different OV Nbrs'][] = "The ov nbr '$ov_nbr_from_frsq' defined in '#FRSQ' ($frsq_value) is different than this one '$ov_nbr_from_echantillon' defined from 'Échantillon' value ($echantillon_value)! [line: $line_counter]";
		}
	} else if(!empty($echantillon_value_tmp)) {
		die('ERR 88767383 : '.$echantillon_value);
	}	
	
	$ov_nbr = empty($ov_nbr_from_echantillon)? $ov_nbr_from_frsq : $ov_nbr_from_echantillon;
	$frsq_nbr = $frsq_value_from_echantillon;

	// GET PARTICIPANT_ID & MISC_IDENTIFIER_ID & COLLECTION_FRSQ_NBR
	
	$participant_id = null;
	$misc_identifier_id = null;
	
	$collection_frsq_nbr = '';
		
	if(array_key_exists($frsq_nbr, Config::$ids_from_frsq_nbr)) {
		$participant_id = Config::$ids_from_frsq_nbr[$frsq_nbr]['participant_id'];
		$misc_identifier_id = Config::$ids_from_frsq_nbr[$frsq_nbr]['misc_identifier_id'];
		$collection_frsq_nbr = $frsq_nbr;
		
		if(array_key_exists($ov_nbr, Config::$participant_id_from_ov_nbr) && (Config::$participant_id_from_ov_nbr[$ov_nbr] != $participant_id)) {
			Config::$summary_msg[$worksheet]['@@ERROR@@']['2 different participants'][] = "The patient defintion is different according to the analyzed value : '#FRSQ' ($frsq_value) or 'Échantillon' value ($echantillon_value)! [line: $line_counter]";
		}
		
	} else if(array_key_exists($ov_nbr, Config::$participant_id_from_ov_nbr)) {
		if(!empty($frsq_nbr)) Config::$summary_msg[$worksheet]['@@MESSAGE@@']["'Echantillon' FRSQ Nbr unknown"][] = "The frsq number ($frsq_nbr) extracted from 'Échantillon' value ($echantillon_value) is not defined into step1! Will use Ov Nbr ($ov_nbr) to find participant! [Line: $line_counter]";
		
		$participant_id = Config::$participant_id_from_ov_nbr[$ov_nbr];
		
		if(sizeof(Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ OV'] == 1)) {
			$collection_frsq_nbr = Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ OV'][0];
			if(!isset(Config::$ids_from_frsq_nbr[$collection_frsq_nbr])) die('ERR 7890044');
			$misc_identifier_id = Config::$ids_from_frsq_nbr[$collection_frsq_nbr]['misc_identifier_id'];
			Config::$summary_msg[$worksheet]['@@MESSAGE@@']['Assign FRSQ# not defined into Échantillon'][] = "The FRSQ# ($frsq_nbr) extracted from 'Échantillon' value [$echantillon_value] does not exist. Will link collection to the unique FRSQ# [$collection_frsq_nbr] created for the participant from diagnosis file or step 1! [line: $line_counter]";
		
		} else {
			Config::$summary_msg[$worksheet]['@@WARNING@@']['Unable to assign FRSQ#'][] = "The FRSQ# ($frsq_nbr) extracted from 'Échantillon' value [$echantillon_value] does not exist and the participant has too many FRSQ# (".implode(', ',Config::$data_for_import_from_participant_id[$participant_id]['#FRSQ OV'])."). Unable to select the good one! [line: $line_counter]";
		}
		
	} else {
		Config::$summary_msg[$worksheet]['@@ERROR@@']['Unknown Participant'][] = "Unknown participant having FRSQ# ($frsq_nbr) and 'Échantillon' value [$echantillon_value]. Won't import data! [line: $line_counter]";
		return array();				
	}
	
	// GET DIAGNOSIS MASTER ID
	
	$diagnosis_master_id = null;
	if(array_key_exists('ovca_diagnosis_ids', Config::$data_for_import_from_participant_id[$participant_id])) {
		$diag_found = 0;
		$diagnoses_frsqs = array();
		foreach(Config::$data_for_import_from_participant_id[$participant_id]['ovca_diagnosis_ids'] as $new_ovcas) {
			$diagnoses_frsqs[$new_ovcas['FRSQ#']] = $new_ovcas['FRSQ#'];
			if($new_ovcas['FRSQ#'] == $collection_frsq_nbr) {
				$diag_found ++;
				$diagnosis_master_id = $new_ovcas['diagnosis_master_id'];
			}
		}
		if($diag_found > 1){
			Config::$summary_msg[$worksheet]['@@WARNING@@']['Too many OVCA(s) can be linked to sample'][] = "The patient having #FRSQ [$ov_nbr_from_frsq] and Échantillon [$ov_nbr_from_echantillon] has many OVCA diagnoses linked to this FRSQ#(s)! Then collection has to be linked to a diagnosis after migration process! [line: $line_counter]";
			$diagnosis_master_id = null;
		} else if(!$diag_found) {
			Config::$summary_msg[$worksheet]['@@WARNING@@']['No OVCA can be linked to sample'][] = "The patient having #FRSQ [$ov_nbr_from_frsq] and Échantillon [$ov_nbr_from_echantillon] has one or many OVCA diagnosis linked to following FRSQ#(s) [".implode(', ',$diagnoses_frsqs)."], but no one is linked to this FRSQ# [$collection_frsq_nbr]! Collection won't be linked to a OVCA diagnosis! [line: $line_counter]";
		}
	}
	
	return array('participant_id' => $participant_id, 'misc_identifier_id' => $misc_identifier_id, 'diagnosis_master_id' => $diagnosis_master_id);
}

function getStorageId($aliquot_description, $storage_control_type, $selection_label) {
	global $storage_list;
	
	$selection_label = str_replace(' ', '', $selection_label)."[OV/$aliquot_description]";
	
	$storage_key = $aliquot_description.$storage_control_type.$selection_label;
	if(isset($storage_list[$storage_key])) return $storage_list[$storage_key];
	
	$next_id = sizeof($storage_list) + 1;
	
	$master_fields = array(
		"code" => "'$next_id'",
		"storage_control_id"	=> Config::$storage_controls[$storage_control_type]['storage_control_id'],
		"short_label"			=> "'".$selection_label."'",
		"selection_label"		=> "'".$selection_label."'",
		"lft"		=> "'".(($next_id*2)-1)."'",
		"rght"		=> "'".($next_id*2)."'",
		"notes" => "'$aliquot_description'"
	);
	$storage_master_id = customInsertChusRecord($master_fields, 'storage_masters');	
	customInsertChusRecord(array("storage_master_id" => $storage_master_id), Config::$storage_controls[$storage_control_type]['detail_tablename'], true);	
		
	$storage_list[$storage_key] = $storage_master_id;
	
	return $storage_master_id;	
}

function createCollection($collections_to_create) {
	global $next_sample_code;
	
	foreach($collections_to_create as $new_collection) {	
		// Create colleciton
		if(!isset($new_collection['collection'])) die('ERR 889940404023');
		$collection_id = customInsertChusRecord(array_merge($new_collection['collection'], $new_collection['link'], array('bank_id' => '2', 'collection_property' => "'participant collection'")), 'collections', false, true);	
		
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
				customInsertChusRecord(array_merge($new_specimen_products['specimen_details'], array('sample_master_id' => $sample_master_id)), 'specimen_details', true, true);
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
			customInsertChusRecord(array_merge($new_derivative['derivative_details'], array('sample_master_id' => $sample_master_id)), 'derivative_details', true, true);
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
