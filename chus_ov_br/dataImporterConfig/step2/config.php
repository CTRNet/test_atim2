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
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/data/DONNEES CLINIQUES et BIOLOGIQUES-OVAIRE-2012-03-14_revised.xls";

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
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step2/tablesMapping/ovary_diagnoses.php'; 

//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/no_dossier_chus_identifiers.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/ovary_bank_identifiers.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/breast_bank_identifiers.php'; 

//=========================================================================================================
// START functions
//=========================================================================================================
	
function addonFunctionStart(){
	global $connection;
	
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS Step 2 : CHUS OVBR<br>
	Ovary Data Import<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	echo "ALL Consent will be defined as obtained!<br>";
	
	// ** Data check ** 
	
	$query = "SELECT COUNT(*) FROM participants;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step2: Participant table should be completed");
	}
	
	$query = "SELECT COUNT(*) FROM misc_identifiers;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step2: Identifiers table should be completed");
	}	
	
	$query = "SELECT COUNT(*) FROM diagnosis_masters;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step2: Diagnoses table should be empty");
	}	

	$query = "SELECT COUNT(*) FROM collections;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step2: Collections table should be empty");
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
	
	$query = "select value from structure_permissible_values_customs where control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'cytoreductions values');";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$cytoreduction_values[] = $row['value'];
	}

	// ** Set participant_id / identifier values links array **
	
	$query = "SELECT ident.id, ctrl.misc_identifier_name, ident.identifier_value, ident.participant_id
	FROM misc_identifier_controls AS ctrl INNER JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = ctrl.id
	WHERE ctrl.misc_identifier_name LIKE '%FRSQ%' AND ident.deleted != 1";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
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
		
		if(!isset(Config::$data_for_import_from_participant_id[$row['participant_id']])) Config::$data_for_import_from_participant_id[$row['participant_id']] = array('data_imported_from_ov_file' => false, 'data_imported_from_br_file' => false);
		Config::$data_for_import_from_participant_id[$row['participant_id']][$row['misc_identifier_name']][] = $row['identifier_value'];
	}
	
	// ** Set storage controls **
	
	$query = "select id,storage_type,detail_tablename from storage_controls where flag_active = '1';";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$storage_controls[$row['storage_type']] = array('storage_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
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
	
	$query = "UPDATE diagnosis_masters parent, diagnosis_masters child SET child.primary_id = parent.primary_id WHERE child.primary_id IS NULL AND child.parent_id IS NOT NULL AND child.parent_id = parent.id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('diagnosis_masters','diagnosis_masters_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	// ADD PATIENT OTHER DATA
	
//TODO	uncomment

//	addPatientsHistory();
//	addFamilyHistory();
  addCollections();
					
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
	
	echo "<br>";
//TODO
pr('exit before todo');
exit;		

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
			
			$years_quit_smoking = str_replace('ND','',$line_data['Tabac::Depuis combien année (An)']);
			if(strlen($years_quit_smoking)) {
				if(preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $years_quit_smoking,$matches)) {
					$detail_fields['years_quit_smoking'] = "'$years_quit_smoking'";
				} else {
					Config::$summary_msg['PATIENT HISTORY']['@@ERROR@@']['arrêt tabac années'][] = "Value '$years_quit_smoking' is not supported and won't be imported! [line: $line_counter]";
				}
			}			
			
			$chus_duration_in_years = str_replace('ND','',$line_data['Tabac::Durée (an)']);
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
				if(!isset(Config::$event_controls['lifestyle']['all']['smoking history questionnaire'])) die('ERR 88998379');
				$event_control_id = Config::$event_controls['lifestyle']['all']['smoking history questionnaire']['event_control_id'];
				$detail_tablename = Config::$event_controls['lifestyle']['all']['smoking history questionnaire']['detail_tablename'];				
				
				$master_fields = array(
					'participant_id' => $participant_id,
					'event_control_id' =>  $event_control_id,
					'event_summary' => "'".str_replace("'","''",$notes)."'"
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
			
			$hrt_use = str_replace(array('ND', 'nd',), array('',''), $line_data['HORMONES::Hormone de remplacement Oui-Non-S.R.']);
			$empty_test = str_replace(' ', '', $hrt_use);
			if(strlen($empty_test)) {
				if($hrt_use == 'non') {
					$data_to_insert['hrt_use'] = "'no'";
				} else {
					$data_to_insert['hrt_use'] = "'yes'";
					if(($hrt_use != 'oui') && ($hrt_use != 'oui ')) {
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

			$chus_evista_use = str_replace(array('ND'),array(''), $line_data['HORMONES::Tamoxifène / Évista (Oui-Non-S.R.)']);
			if(strlen($chus_evista_use)) {
				if(preg_match('/^ {0,1}non {0,1}$/', $chus_evista_use, $matches)) {
					$data_to_insert['chus_evista_use'] = "'no'";
				
				} else if(preg_match('/^oui {0,1}(.*)$/', $chus_evista_use, $matches)) {
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
		}
	}
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
						Config::$summary_msg['FAMILY HISTORY']['@@ERROR@@']['Unable to define relaiton'][] = "Unable to extract relation from 'Lien parenté #$counter' ($family_link_tmp) ! [line: $line_counter]";
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

function customInsertChusRecord($data_arr, $table_name, $is_detail_table = false) {
	global $connection;
	$created = $is_detail_table? array() : array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
	);
	
	$insert_arr = array_merge($data_arr, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$record_id = mysqli_insert_id($connection);
	
	$rev_insert_arr = array_merge($data_arr, array('id' => "$record_id", 'version_created' => "NOW()"));
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query($connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	return $record_id;	
}

function customGetFormatedDate($date_strg) {
	$date = null;
	if(!empty($date_strg)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date_strg - $xls_offset) * 86400));
		
		if(!preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/', $date, $matches)) die('ERR Wrong date format: '.$date);
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
	global $storage_list;
	global $collections_to_create;
	
	
	$storage_list = array();
	$collections_to_create = array();
	
	// ASCITE & TISSUE
	
	loadAscite2mlCollection();

	
	pr($collections_to_create);
	exit;
	
	
	
}

function loadAscite2mlCollection() {
	global $collections_to_create;
		
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
				$collection_date = customGetFormatedDate($line_data['Date collecte']).' 00:00:00';
				$collection_date_accuracy = 'h';
			}
			
			$collection_key = "participant_id=$participant_id#misc_identifier_id=".empty($misc_identifier_id)?'':$misc_identifier_id."#diagnosis_master_id=".empty($diagnosis_master_id)?'':$diagnosis_master_id."#date=$collection_date";
			
			if(!isset($collections_to_create[$collection_key])) {
				$collections_to_create[$collection_key] = array(
					'link' => array(
						'participant_id' => $participant_id, 
						'misc_identifier_id' => $misc_identifier_id, 
						'diagnosis_master_id' => $diagnosis_master_id,
						'consent_master_id' => $consent_master_id),
					'collection' => array(
						'collection_date' => $collection_date, 
						'collection_date_accuracy' => $collection_date_accuracy),
					'inventory' => array());
			}
			
			// Ascite
			
			$line_data['Heure Réception'] = str_replace('ND','',$line_data['Heure Réception']);
			if(!empty($line_data['Heure Réception']) && empty($collection_date)) die('ERR 890003');
			if(!empty($line_data['Heure Réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Réception'], $matches)) die('ERR  ['.$line_counter.'] 890004 be sure cell custom format is h:mm ['.$line_data['Heure Réception'].']');
			$reception_datetime = (!empty($collection_date) && !empty($line_data['Heure Réception']))? str_replace('00:00:00', $line_data['Heure Réception'].':00', $collection_date) : '';
			$reception_datetime_accuracy = (!empty($reception_datetime))? 'c' : '';
			
			if(!isset($collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime])) {
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['sample_masters'] = array('sample_type' => 'ascite');
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['specimen_details'] = array('reception_datetime' => $reception_datetime, 'reception_datetime_accuracy' => $reception_datetime_accuracy);
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite'][$reception_datetime]['derivatives'] = array();
			}
			
			// Ascite supernatant
			
			if(!isset($collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'])) {
				$collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'][0]['sample_masters'] = array('sample_type' => 'ascite supernatant');
				$collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'][0]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'][0]['derivative_details'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'][0]['aliquots'] = array();
				$collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'][0]['derivatives'] = array();
			}			
			
			// Ascite supernatant Tube
			
			$expected_nbr_of_tubes = $line_data['Qté'];
			
			$aliquot_label = $line_data['Échantillon'];
			
			$storage_datetime = '';
			$storage_datetime_accuracy = '';
			$line_data['Heure Entreposage'] = str_replace('ND','',$line_data['Heure Entreposage']);
			if(!empty($line_data['Date de congélation'])) {
				$storage_datetime = customGetFormatedDate($line_data['Date de congélation']).' 00:00:00';
				$storage_datetime_accuracy = 'h';
				if(!empty($line_data['Heure Entreposage'])) {
					if(!preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Entreposage'], $matches)) die('ERR  ['.$line_counter.'] 89000ddd4');
					$storage_datetime = str_replace('00:00:00', $line_data['Heure Entreposage'].':00', $storage_datetime);
					$storage_datetime_accuracy = 'c';
				}
			} else if(!empty($line_data['Heure Entreposage'])) {
				die('ERR ['.$line_counter.'] 99994884');
			}
			
			$aliquot_to_create = array();
			if(!empty($line_data['Emplacement'])) {
				// Created stored aliquot
				if(empty($line_data['Boite'])) die('ERR  ['.$line_counter.'] 88990373'.$line_data['Boite'].'//'.$line_data['Emplacement']);
				
				$storage_master_id = getStorageId('ascite_1_ml', 'box100', $line_data['Boite']);
				
				$stored_aliquots_positions = array();
				$emplacement_tmp = str_replace(array(' ','.'), array('',','), $line_data['Emplacement']);
				if(preg_match('/^0([1-9])$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions[] = $matches[1];
				} else if(preg_match('/^([1-9]|[1-9][0-9]|100)$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions[] = $matches[1];
				} else if(preg_match('/^([1-9],|[1-9][0-9],|100,)+([1-9]|[1-9][0-9]|100)$/', $emplacement_tmp, $matches)) {
					$stored_aliquots_positions = explode(',',$emplacement_tmp);
				} else if(preg_match('/^(0[1-9]|[1-9]|[1-9][0-9]|100)-(0[1-9]|[1-9]|[1-9][0-9]|100)$/', $emplacement_tmp, $matches)) {
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
					$aliquot_to_create[] = array(
						'aliquot_masters' => array(
							'aliquot_label' => $aliquot_label, 
							'aliquot_type' => 'tube',
							'initial_volume' => "1",
							'current_volume' => "1",
							'in_stock' => "yes - available",
							'storage_master_id' => $storage_master_id,
							'storage_datetime' => $storage_datetime,
							'storage_datetime_accuracy' => $storage_datetime_accuracy,
							'storage_coord_x' => $new_pos,
							'storage_coord_y' => '',
							'chus_time_limit_of_storage' => ''),
//TODO chus_time_limit_of_storage					
						'aliquot_details' => array(),
						'aliquot_internal_uses' => array()
					);
				}
			}
			
			if(!empty($line_data['Use#']) || !empty($line_data['Dons1'])) {
				if(empty($line_data['Use#']) || empty($line_data['Dons1'])) die('ERR ['.$line_counter.'] 8899eee944');
				if(!preg_match('/^[0-9]+$/',$line_data['Use#'],$matches)) die('ERR ['.$line_counter.'] 8899eeeddd944');
				
				$generic_aliquot_used_data = array(
					'aliquot_masters' => array(
						'aliquot_label' => $aliquot_label, 
						'aliquot_type' => 'tube',
						'initial_volume' => "1",
						'current_volume' => "1",
						'in_stock' => "no",
						'storage_master_id' => '',
						'storage_datetime' => '',
						'storage_datetime_accuracy' => '',
						'storage_coord_x' => '',
						'storage_coord_y' => '',
						'chus_time_limit_of_storage' => ''),
//TODO chus_time_limit_of_storage					
					'aliquot_details' => array());
			
				$aliquot_used_nbr = $line_data['Use#'];
				$used_aliquots_counter = 0;
				
				if(preg_match('/^([0-9]+) (.*) (19|20)([0-9]{2}\-[0-1][0-9])$/', $line_data['Dons1'], $matches)) {
					for($i = 0; $i < $matches[1]; $i++) {
						$used_aliquots_counter++;
						$aliquot_to_create[] = array_merge(
							$generic_aliquot_used_data, 
							array('aliquot_internal_uses' => array(
								'use_code' => 'Dons : '.$matches[2],
								'use_datetime' => $matches[3].$matches[4].'-01 00:00:00',
								'use_datetime_accuracy' => 'd'))
						);						
					}
				} else {
					die('ERR 989930033 '.$line_data['Dons1']);
				}
				
				if(!empty($line_data['Dons2'])) {
					if(preg_match('/^([0-9]+) (.*) (19|20)([0-9]{2}\-[0-1][0-9])$/', $line_data['Dons2'], $matches)) {
						for($i = 0; $i < $matches[1]; $i++) {
							$used_aliquots_counter++;
							$aliquot_to_create[] = array_merge(
								$generic_aliquot_used_data, 
								array('aliquot_internal_uses' => array(
									'use_code' => 'Dons : '.$matches[2],
									'use_datetime' => $matches[3].$matches[4].'-01 00:00:00',
									'use_datetime_accuracy' => 'd'))
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
			
			if(sizeof($aliquot_to_create) != $expected_nbr_of_tubes) Config::$summary_msg['ASCITE 2 ml']['@@WARNING@@']['Tube defintion error'][] = "The number of tubes defined into Qté ($expected_nbr_of_tubes) is different than the number of created tubes (".sizeof($aliquot_to_create).")! [line: $line_counter]";
		
			$collections_to_create[$collection_key]['inventory']['ascite']['derivatives']['ascite supernatant'][0]['aliquots'] = $aliquot_to_create;
		}
	}
}

function getParticipantIdentifierAndDiagnosisIds($worksheet, $line_counter, $frsq_value, $echantillon_value) {
	if(empty($frsq_value) && empty($echantillon_value)) die('ERR 888d88d88a9');
	
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
			Config::$summary_msg[$worksheet]['@@WARNING@@']['Too many OVCA(s) can be linked to Ascite'][] = "The patient having #FRSQ [$ov_nbr_from_frsq] and Échantillon [$ov_nbr_from_echantillon] has many OVCA diagnoses linked to this FRSQ#(s)! Then collection has to be linked to a diagnosis after migration process! [line: $line_counter]";
			$diagnosis_master_id = null;
		} else if(!$diag_found) {
			Config::$summary_msg[$worksheet]['@@WARNING@@']['No OVCA can be linked to Ascite'][] = "The patient having #FRSQ [$ov_nbr_from_frsq] and Échantillon [$ov_nbr_from_echantillon] has one or many OVCA diagnosis linked to following FRSQ#(s) [".implode(', ',$diagnoses_frsqs)."], but no one is linked to this FRSQ# [$collection_frsq_nbr]! Collection won't be linked to a OVCA diagnosis! [line: $line_counter]";
		}
	}
	
	return array('participant_id' => $participant_id, 'misc_identifier_id' => $misc_identifier_id, 'diagnosis_master_id' => $diagnosis_master_id);
}

function getStorageId($aliquot_description, $storage_control_type, $selection_label) {
	global $storage_list;
	
	$selection_label = preg_replace('/ +$/','',$selection_label);
	
	$storage_key = $aliquot_description.$storage_control_type.$selection_label;
	if(isset($storage_list[$storage_key])) return $storage_list[$storage_key];
	
	$next_id = sizeof($storage_list) + 1;
	
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
		
	$storage_list[$storage_key] = $storage_master_id;
	
	return $storage_master_id;	
}








?>
