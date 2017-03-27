<?php

//First Line of any main.php file
require_once 'system.php';

displayMigrationTitle('PROCURE CHUQ : PSA and Testo Reload Prcoess', array($excel_file_name));

$query = "UPDATE event_masters SET deleted = 1, modified = '$import_date', modified_by = '$imported_by' WHERE deleted <> 1 AND event_control_id = '".$atim_controls['event_controls']['laboratory']['id']."'";
customQuery($query);

addToModifiedDatabaseTablesList('event_masters', $atim_controls['event_controls']['laboratory']['detail_tablename']);

$worksheet_name = 'Feuil1';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
	$participant_identifier = $excel_line_data['NoProcure'];
	$importation_done = false;
	if(strlen($participant_identifier)) {
		$query = "SELECT id FROM participants WHERE deleted <> 1 AND participant_identifier = '$participant_identifier';";
		$atim_patient_data = getSelectQueryResult($query);
		if(!isset($atim_patient_data)) {
			recordErrorAndMessage('PSA / Testo', '@@ERROR@@', "Participant not found into ATiM. The data of the line won't be migrated.", "See participant '$participant_identifier' line .$line_number.");
		} else {
			$notes_at_psa_date = array();
			//Date of PSA
			$date_field = 'DPSA';
			list($date_of_psa, $date_of_psa_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$date_field], 'PSA / Testo', "$worksheet_name::$date_field:", "See Line: $line_number");
			if(!in_array($excel_line_data['DPSA(P)'], array('', 'j', 'jm', 'jma'))) {
				recordErrorAndMessage('PSA / Testo', '@@WARNING@@', "PSA date precision not supported. Please update after migration into ATiM.", "Precision value [".$excel_line_data['DPSA(P)']."]. See participant '$participant_identifier' line .$line_number.");
				$excel_line_data['DPSA(P)'] = '';
			}
			$date_of_psa_accuracy = ($excel_line_data['DPSA(P)'] == 'j')? 'd' : (($excel_line_data['DPSA(P)'] == 'jm')? 'm' : (($excel_line_data['DPSA(P)'] == 'jma')? 'y' : $date_of_psa_accuracy));
			//Psa value
			$psa_value = validateAndGetDecimal($excel_line_data['PSA'], 'PSA / Testo', "Wrong PSA value format.", "See participant '$participant_identifier' line .$line_number.");
			if(strlen($excel_line_data['Minimum'])) {
				$psa_minimum = validateAndGetDecimal($excel_line_data['Minimum'], 'PSA / Testo', "Wrong PSA Minimum valueformat.", "See participant '$participant_identifier' line .$line_number.");
				$notes_at_psa_date[] = "PSA note : Value defined as '".strlen($psa_minimum)? $psa_minimum : $excel_line_data['Minimum']."'.";
			}
			//Is BCR
			$is_bcr = false;
			if(strlen($excel_line_data['récidive procure selon définition strcte (2 mesure consécut. >0,2 )'])) {
				if($excel_line_data['récidive procure selon définition strcte (2 mesure consécut. >0,2 )'] != $excel_line_data['DPSA']) {
					recordErrorAndMessage('PSA / Testo', '@@WARNING@@', "Please validate PSA date is similar than BCR date and update data into ATiM if requried.", "BCR value [".$excel_line_data['récidive procure selon définition strcte (2 mesure consécut. >0,2 )']."] different than PSA date [".$excel_line_data['DPSA']."]. See participant '$participant_identifier' line .$line_number.");
				}
				$is_bcr = true;
			}
			//Testo
			$testo_at_psa_date = '';
			$testo_at_other_date_value_and_date = '';
			if(strlen($excel_line_data['testo'])) {
				if(preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $excel_line_data['testo'])) {
					$testo_at_psa_date = validateAndGetDecimal($excel_line_data['testo'], 'PSA / Testo', "Testo value", "See Line:$line_number");
				} else if(preg_match('/^<[0-9]+([\.,][0-9]+){0,1}$/', trim($excel_line_data['testo']))) {
					$testo_at_psa_date = '0';
					$notes_at_psa_date[] = "Testosterone note : Value defined as '".$excel_line_data['testo']."' into the Excel.";
				} else if(preg_match('/^0[\ ]{0,1}\(<0[\.,]1\)$/', trim($excel_line_data['testo']))) {
					$testo_at_psa_date = '0';
					$notes_at_psa_date[] = "Testosterone note : Value defined as '<0,1' into the Excel.";
				} else if(preg_match('/^(testo[\ ]+((du)|(au)|(le))[\ ]+){0,1}([0-9]{2}\-[0-9]{2}\-[0-9]{4})\:[\ ]*([0-9]+([\.,][0-9]+){0,1})$/', trim($excel_line_data['testo']), $matches)) {
					$testo_at_other_date_value_and_date = $matches[7].'//'.$matches[6];
				} else if(preg_match('/^([0-9]+([\.,][0-9]+){0,1})[\ ]*le[\ ]*([0-9]{2}\-[0-9]{2}\-[0-9]{4})$/', trim($excel_line_data['testo']), $matches)) {
					$testo_at_other_date_value_and_date = $matches[1].'//'.$matches[3];
				} else {
					switch(trim($excel_line_data['testo'])) {
						case 'testo 7 juill 2009: 19,4':
							$testo_at_other_date_value_and_date = '19,4//07-07-2009';
							break;
						case 'testo 10-08-2010: 16,8':
							$testo_at_other_date_value_and_date = '16,8//10-08-2010';
							break;
						case 'testo du 22 dÃ©c 2016: 11,5':
							$testo_at_other_date_value_and_date = '11,5//22-12-2016';
							break;
						case '15-05-2014,testo:11,5':
							$testo_at_other_date_value_and_date = '11,5//15-05-2014';
							break;
						case '7-08-2009, testo: 0':
							$testo_at_other_date_value_and_date = '0//07-08-2009';
							break;
						case 'testo du 5-07-2010: 16,3':
							$testo_at_other_date_value_and_date = '16,3//05-07-2010';
							break;
						case '16,0 le 19 oct 2009':
							$testo_at_other_date_value_and_date = '16,0//19-10-2009';
							break;
						case '0,1 le 19 janv 2010':
							$testo_at_other_date_value_and_date = '0,1//19-01-2010';
							break;
						case 'testo: 5,9 le 24 juill 2014':
							$testo_at_other_date_value_and_date = '5,9//24-07-2014';
							break;
						case 'en 1985, testo:5,6':
							$testo_at_other_date_value_and_date = '5,6//1985';
							break;
						case '10,9 le 8-05-2015':
							$testo_at_other_date_value_and_date = '10,9//08-05-2015';
							break;
						case '19,5 le 8-12-2014':
							$testo_at_other_date_value_and_date = '19,5//08-12-2014';
							break;
						case '0,2 le 15 nov 2012':
							$testo_at_other_date_value_and_date = '0,2//15-11-2012';
							break;
						case '10,9 le 2016-06-14':
							$testo_at_other_date_value_and_date = '10,9//2016-06-14';
							break;
						case '4 oct 2012: testo: 12,8':
							$testo_at_other_date_value_and_date = '12,8//04-10-2012';
							break;
						case 'testo du 22 déc 2016: 11,5':
							$testo_at_other_date_value_and_date = '11,5//22-12-2016';
							break;
						default:
							recordErrorAndMessage('PSA / Testo', '@@WARNING@@', "A testosterone value can not been migrated according to its format. To enter manually after migration.", "See 'testo' excel value [".$excel_line_data['testo']."] for the participant '$participant_identifier' at line .$line_number.");
									
					}					
				}
			}
			if(strlen($psa_value) && strlen($date_of_psa)) {
				$importation_done = true;
				$event_data = array(
					'event_masters' => array(
						'participant_id' => $atim_patient_data[0]['id'],
						'event_control_id' => $atim_controls['event_controls']['laboratory']['id'],
						'event_date' => $date_of_psa,
						'event_date_accuracy' => $date_of_psa_accuracy,
						'event_summary' => implode(' ',$notes_at_psa_date)),
					$atim_controls['event_controls']['laboratory']['detail_tablename'] => array(
						'psa_total_ngml' => $psa_value,
						'biochemical_relapse' => ($is_bcr)? 'y': '',
						'testosterone_nmoll' => $testo_at_psa_date
					));
				customInsertRecord($event_data);
				if($testo_at_other_date_value_and_date) {
					$tmp = explode('//', $testo_at_other_date_value_and_date);
					$testo_value = validateAndGetDecimal($tmp[0], 'PSA / Testo', "Wrong testo value format extracted from the note of the field 'testo'. To enter manually after migration.", "See 'testo' excel value [".$excel_line_data['testo']."] for the participant '$participant_identifier' at line .$line_number.");
					$tmp_date_of_testo_accuracy = null;
					if($tmp[1] == '1985') {
						$tmp[1] = '1985-01-01';
						$tmp_date_of_testo_accuracy = 'm';
					}
					list($date_of_testo, $date_of_testo_accuracy) = validateAndGetDateAndAccuracy($tmp[1], 'PSA / Testo', "Wrong testo date format extracted from the note of the field 'testo'. To enter manually after migration.", "See 'testo' excel value [".$excel_line_data['testo']."] for the participant '$participant_identifier' at line .$line_number.");
					if($tmp_date_of_testo_accuracy) $date_of_testo_accuracy = $tmp_date_of_testo_accuracy;
					if(strlen($testo_value) && strlen($date_of_testo)) {
						recordErrorAndMessage('PSA / Testo', '@@MESSAGE@@', "Created a testoterone record at another date based on 'testo' field content. Please validate.", "Created testo record with value [$testo_value] on '$date_of_testo' from testo note [".$excel_line_data['testo']."] for the participant '$participant_identifier' at line .$line_number.");
						$event_data = array(
							'event_masters' => array(
								'participant_id' => $atim_patient_data[0]['id'],
								'event_control_id' => $atim_controls['event_controls']['laboratory']['id'],
								'event_date' => $date_of_testo,
								'event_date_accuracy' => $date_of_testo_accuracy),
							$atim_controls['event_controls']['laboratory']['detail_tablename'] => array(
								'testosterone_nmoll' => $testo_value
							));
						customInsertRecord($event_data);	
					} else {
						recordErrorAndMessage('PSA / Testo', '@@MESSAGE@@', "Date or value is missing (or does not match the expected format) to create a testoterone record at another date. To create after migration.", "Either testo wrong value [$testo_value] or wrong date '$date_of_testo' extracted from testo note [".$excel_line_data['testo']."] for the participant '$participant_identifier' at line .$line_number.");
					}
				}
			} else  {
				recordErrorAndMessage('PSA / Testo', '@@WARNING@@', "No PSA value and/or date have been parsed. No PSA to migrate. Please validate and create data after migration.", "See participant '$participant_identifier' line .$line_number.");
			}
		}
	}
	if(!$importation_done) {
		$xls_data = array();
		$excel_line_data = array_filter($excel_line_data, function($var){return (!($var == '' || is_null($var)));});
		foreach($excel_line_data as $key => $value) $xls_data[] = "$key = [$value]";
		$xls_data = implode(' & ', $xls_data);
		recordErrorAndMessage('P, SA / Testo', '@@WARNING@@', "No Data of the line have been migrated. Please validate.", "See line .$line_number. Data : $xls_data");
	}
}

insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(true);
	
?>
		