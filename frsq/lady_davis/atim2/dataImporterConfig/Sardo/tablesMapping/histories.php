<?php

function loadFamHisto(&$tmp_xls_reader, $sheets_keys) {
	$worksheet_name = 'FamHistory';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838382');
	$summary_msg_title = 'Family History - Worksheet '.$worksheet_name;
	$excel_line_counter = 0;
	$headers = array();
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);	
			$jgh_nbr = $new_line_data['No de dossier'];
			if(isset(Config::$participants[$jgh_nbr])) {
				$participant_id = Config::$participants[$jgh_nbr]['participant_id'];
				if($new_line_data['Antécédents familiaux cancer sein'] != 'Oui') die('ERR 23298732 '.$excel_line_counter);
				Config::$participants[$jgh_nbr]['family_histories'][0] = array('qc_lady_breast_cancer' => 'y', 'participant_id' => $participant_id);
			}
		}
	} 
}

function loadReproHisto(&$tmp_xls_reader, $sheets_keys) {
	$worksheet_name = 'GPA';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838382');
	$summary_msg_title = 'Reporductive History - Worksheet '.$worksheet_name;
	$excel_line_counter = 0;
	$headers = array();
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);	
			$jgh_nbr = $new_line_data['No de dossier'];
			if(isset(Config::$participants[$jgh_nbr])) {
				$participant_id = Config::$participants[$jgh_nbr]['participant_id'];
				//GPA
				$jgh_nbr = $new_line_data['No de dossier'];
				$repro_data = array();
				if(preg_match('/^G([0-9]{2})\ P([0-9]{2})\ A([0-9]{2})$/', $new_line_data['Gravida Para Aborta'], $matches)) {
					//gravida
					if($matches[1] != '99') {
						if(preg_match('/^0([0-9])$/', $matches[1], $matches2)) {
							$matches[1] = $matches2[1];
						}
						$repro_data['gravida'] = $matches[1];
					}
					//para
					if($matches[2] != '99') {
						if(preg_match('/^0([0-9])$/', $matches[2], $matches2)) {
							$matches[2] = $matches2[1];
						}
						$repro_data['para'] = $matches[2];
					}
					//aborta
					if($matches[3] != '99') {
						if(preg_match('/^0([0-9])$/', $matches[3], $matches2)) {
							$matches[3] = $matches2[1];
						}
						$repro_data['aborta'] = $matches[3];
					}
				} else {
					pr($matches);
					die('ERR 23762876 2');
				}
				//menopause_status
				if(strlen($new_line_data['Ménopause'])) {
					switch($new_line_data['Ménopause']) {
						case 'pré-ménopausée':
							$repro_data['menopause_status'] = 'pre';							
							break;
						case 'péri-ménopausée':
							$repro_data['menopause_status'] = 'peri';	
							break;
						case 'post-ménopausée':
						case 'ménopausée par médication':
						case 'ménopausée par chirurgie':
							$repro_data['menopause_status'] = 'post';	
							break;
						case 'non ménopausée':
						case 'N/S':
						case '':
							break;
						default:
							die('ERR 37287 2873 '.$new_line_data['Ménopause']);
					}
				}
				//Année ménopause
				if(strlen($new_line_data['Année ménopause']) && $new_line_data['Année ménopause'] != '9999') {
					$menopause_date = $new_line_data['Année ménopause'];
					$date_of_birth = Config::$participants[$jgh_nbr]['date_of_birth'];
					if(empty($date_of_birth)) {					
						Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unable to calculate age at menopause'][] = "Date of birth unknown. See JGH# $jgh_nbr line $excel_line_counter";
					} else if(preg_match('/^([0-9]{4})\-[0-9]{2}\-[0-9]{2}$/', $date_of_birth, $matches)) {
						$age_at_menopause = $menopause_date - $date_of_birth;
						if(preg_match('/$[0-9]+$/', $age_at_menopause)) die('ERR 2387298 7329732 '."$age_at_menopause = $menopause_date - $date_of_birth");
						$repro_data['age_at_menopause'] = $age_at_menopause;
					} else {
						die('ERR 237 6298732987 32 ['.$date_of_birth.'] '.$excel_line_counter);
					}
				}
				//Add data
				if($repro_data) {
					$repro_data_key = serialize($repro_data);
					$repro_data['participant_id'] = $participant_id;
					$repro_data['date_captured'] = Config::$migration_date;
					$repro_data['date_captured_accuracy'] = 'c';
					if(!isset(Config::$participants[$jgh_nbr]['reproductive_histories'][$repro_data_key])) Config::$participants[$jgh_nbr]['reproductive_histories'][$repro_data_key] = $repro_data;
					if(sizeof(Config::$participants[$jgh_nbr]['reproductive_histories']) > 1) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['More than one reproductive history from sardo'][] = "See JGH# $jgh_nbr line $excel_line_counter"; 
				}
			}
		}
	} 
}




