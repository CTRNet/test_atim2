<?php

function loadReceptors(&$tmp_xls_reader, $sheets_keys) {
	$worksheet_name = 'Sardo Receptors';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838382');
	$summary_msg_title = 'Receptor - Worksheet '.$worksheet_name;
	$summary_msg_title_participant = 'Participant - Worksheet '.$worksheet_name;
	$excel_line_counter = 0;
	$headers = array();
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);			
			$jgh_nbr = $new_line_data['No de dossier'];
			if(!isset(Config::$participants[$jgh_nbr])) die('ERR 837623876287632732 : '.$jgh_nbr);
			$participant_id = Config::$participants[$jgh_nbr]['participant_id'];
			if(!$participant_id) {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient not defined into Dx worksheet'][] = "See JGH# $jgh_nbr line $excel_line_counter";
			} else {
				//Work on patient data
				if(empty(Config::$participants[$jgh_nbr]['rec_worksheet_patient_data'])) {
					Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['first_name'] = $new_line_data['Prénom'];
					Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['last_name'] = $new_line_data['Nom'];
					Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['phone_number'] = $new_line_data['Téléphone 1'];
					//Work on last name & first name
					if($new_line_data['Prénom']){
						$db_first_name = Config::$participants[$jgh_nbr]['db_first_name'];
						if($db_first_name!= $new_line_data['Prénom']) {
							Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['First Names Are Different (Will be updated into ATiM)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (atim) [$db_first_name] != (file) [".$new_line_data['Prénom']."]";
							Config::$participants[$jgh_nbr]['participant_db_data_to_update']['first_name'] = 'first_name = "'.$new_line_data['Prénom'].'"';
						}
					}
					if($new_line_data['Nom']) {
						$db_last_name = Config::$participants[$jgh_nbr]['db_last_name'];
						if($db_last_name!= $new_line_data['Nom']) {
							Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Last Names Are Different (Will be updated into ATiM)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (atim) [$db_last_name] != (file) [".$new_line_data['Nom']."]";
							Config::$participants[$jgh_nbr]['participant_db_data_to_update']['last_name'] = 'last_name = "'.$new_line_data['Nom'].'"';
						}
					}
					if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name']!= Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['last_name']) {
						Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Last Names Are Different in worksheets (Dx Vs Rec)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (rec. worksheet) [".Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['last_name']."] != (dx worksheet) [".Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name']."]";
					}
					//Work On phone numbers
					if(strlen(str_replace(' ','',$new_line_data['Téléphone 1']))) {
						$query_phone = "SELECT c.id, c.relationship, c.phone, c.phone_secondary
							FROM participant_contacts c 
							WHERE c.participant_id = $participant_id AND c.deleted != 1 
							AND (c.phone LIKE '%".str_replace('-','%',$new_line_data['Téléphone 1'])."%' OR c.phone_secondary LIKE '%".str_replace('-','%',$new_line_data['Téléphone 1'])."%')";
						$res_phone = mysqli_query(Config::$db_connection, $query_phone) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query_phone."]");
						if($res_phone->num_rows){
							$row_phone = $res_phone->fetch_assoc();
							if($row_phone['relationship'] && $row_phone['relationship'] == 'the participant') {
								//Config::$summary_msg[$summary_msg_title]['@@MESSAGE@@']['Existing Participant Phone Number'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter";
							} else {
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Existing Phone Number Has Been Defined AS Participant Phone'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter";
								$update_query = "UPDATE participant_contacts SET relationship = 'the participant' WHERE id = ".$row_phone['id'];
								mysqli_query(Config::$db_connection, $update_query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$update_query."]");
								$update_query = "
									INSERT INTO participant_contacts_revs (id,contact_name,contact_type,other_contact_type,effective_date,effective_date_accuracy,
										expiry_date,expiry_date_accuracy,notes,street,locality,region,country,mail_code,phone,phone_type,phone_secondary,phone_secondary_type,
										relationship,modified_by,version_created,participant_id,confidential)
									(SELECT id,contact_name,contact_type,other_contact_type,effective_date,effective_date_accuracy,
										expiry_date,expiry_date_accuracy,notes,street,locality,region,country,mail_code,phone,phone_type,phone_secondary,phone_secondary_type,
										relationship,modified_by,modified,participant_id,confidential FROM participant_contacts WHERE id = ".$row_phone['id'].")";
								mysqli_query(Config::$db_connection, $update_query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$update_query."]");
							}
						} else {
							customInsertRecord(array('participant_id' => $participant_id, 'relationship' => 'the participant', 'phone' => "'".$new_line_data['Téléphone 1']."'"), 'participant_contacts');
						}
					}
				} else {
					if(Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['first_name'] != $new_line_data['Prénom']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Prénom'][] = "See JGH# $jgh_nbr line $excel_line_counter";
					if(Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['last_name'] != $new_line_data['Nom']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Date Nom'][] = "See JGH# $jgh_nbr line $excel_line_counter";
					if(Config::$participants[$jgh_nbr]['rec_worksheet_patient_data']['phone_number'] != $new_line_data['Téléphone 1']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Téléphone'][] = "See JGH# $jgh_nbr line $excel_line_counter";
				}
				//New Receptor data set
				if(!in_array($new_line_data['Type traitement'], array('CHIR','BIOP'))) die('ERR 2736 87268 72632');
				if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']])) die('ERR 2744333332');
				$rec_data = $new_line_data;
				unset($rec_data['No de dossier']);
				unset($rec_data['Nom']);
				unset($rec_data['Prénom']);
				unset($rec_data['Téléphone 1']);
				unset($rec_data['Fanions']);
				unset($rec_data['Diagnostic']);
				unset($rec_data['Date du diagnostic']);
				unset($rec_data['Type traitement']);
				unset($rec_data['Traitement']);
				unset($rec_data['Date début traitement']);
				unset($rec_data['Lieu du traitement']);
				Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']]['tmp_receptor_data'][$new_line_data['Type traitement']][$new_line_data['Date début traitement']][$new_line_data['Traitement']][] = $rec_data;
			}
		}
	} 
}

