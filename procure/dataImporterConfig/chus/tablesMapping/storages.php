<?php

function loadStorages() {
	
	Config::$storages = array();
	Config::$storage_data_from_sample_type_and_label = array();
	Config::$additional_dna_miR_from_storage = array();
	
	$summary_msg_title = 'Storage data <br>  Files: '.
		substr(Config::$xls_file_path_storage_whatman_paper, (strrpos(Config::$xls_file_path_storage_whatman_paper,'/')+1)).
		' & '.
		substr(Config::$xls_file_path_storage_all, (strrpos(Config::$xls_file_path_storage_all,'/')+1));
	
	Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Check cell with diagonal'][] = "System will be unable to track cell diagonal. Ex: box R19-B9";
				
	// *** LOAD PLASMA, SERUM, etc  *** 
	
	$sample_type_controls = array(
		'Tissu congelé OCT' => array('sample_type' => 'tissue', 'precision' => 'ISO+OCT', 'alq_label_suffix' => 'FRZ'),   
		'Tissu congelé ISOPENTANE' => array('sample_type' => 'tissue', 'precision' => 'ISO', 'alq_label_suffix' => 'FRZ'),
		
		'Plasma' => array('sample_type' => 'plasma', 'precision' => '', 'alq_label_suffix' => 'PLA'),
		'Sérum' => array('sample_type' => 'serum', 'precision' => '', 'alq_label_suffix' => 'SER'),
		'Buffy Coat' => array('sample_type' => 'pbmc', 'precision' => '', 'alq_label_suffix' => 'BFC'),
		'ADN' => array('sample_type' => 'dna', 'precision' => '', 'alq_label_suffix' => 'DNA'),
		'ADN dilué 50 ng/ul' => array('sample_type' => 'dna', 'precision' => '50 ng/ul', 'alq_label_suffix' => 'DNA'),
		'ADN3' => array('sample_type' => 'dna', 'precision' => '', 'alq_label_suffix' => 'DNA'),
		'ARN' => array('sample_type' => 'rna', 'precision' => '', 'alq_label_suffix' => 'RNA'),
		'miRNA' => array('sample_type' => 'rna', 'precision' => 'miRNA', 'alq_label_suffix' => 'miR'),			
		'Urine non-clarifiée' => array('sample_type' => 'urine', 'precision' => 'non-clarifiée', 'alq_label_suffix' => 'URI'),
		'Urine clarifiée' => array('sample_type' => 'centrifuged urine', 'precision' => 'clarifiée', 'alq_label_suffix' => 'URN'),
		'Urine concentrée' => array('sample_type' => 'concentrated urine', 'precision' => '', 'alq_label_suffix' => 'URC')
	);
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_storage_all);	
	$sheets_nbr = array();
			
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) {
		$work_sheet_name = str_replace(' ','', $tmp['name']);
		if(in_array($work_sheet_name, array(utf8_decode('Résumé'), utf8_decode('Schéma')))) continue;
		
		$freezer_label = '';
		$shelf_label = '';
		$rack_label = '';
		$box_storage_master_id = getNewtStorageId();
		$box_label = '';
		$box_definition = '';
		$box_sample_type = '';
		$box_sample_type_details = '';
		$box_alq_label_suffix = array();
		$box_notes = array();;
		$studied_box_row = 0;
		$box_row_nbr = 0;
		$box_column_nbr = 0;
		
		$excel_line_counter = 0;
		foreach($tmp_xls_reader->sheets[$key]['cells'] as $line => $new_line) {
			$excel_line_counter++;
			if($excel_line_counter == 1) {
				if($new_line['1'] != utf8_decode('Boîte')) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_1'); }
				if(!$new_line['2']) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_1(1)'); }
				if(!preg_match('/^(C[0-9]+\-){0,1}(R[0-9]+\-B[0-9]+)(\-C[0-9]+){0,1}(\ {0,1})(.*)$/', $new_line['2'], $matches)) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_1(2)'); }
				$box_label = $matches[1].$matches[2].$matches[3];
				if($work_sheet_name != $box_label) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Box code mismatch'][] = "Worksheet name [$work_sheet_name] is different than box label [$box_label].";
				if(isset($matches[5]) && $matches[5]) $box_notes[] = $matches[5];
				unset($new_line['1']);
				unset($new_line['2']);
				if($new_line) $box_notes[] = str_replace(array("\n", '  '), array(' ', ' '), implode(' | ', $new_line));		
			} else if($excel_line_counter == 2) {
				if($new_line['1'] != utf8_decode('Contenu')) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_2'); }
				if(!$new_line['2']) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_1(1)'); }
				$box_label .= ' '.$new_line['2'];
				if(!array_key_exists(utf8_encode($new_line['2']), $sample_type_controls)) die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_2(1)');
				$box_definition = utf8_encode($new_line['2']);
				$box_sample_type = $sample_type_controls[utf8_encode($new_line['2'])]['sample_type'];
				$box_sample_type_details =  $sample_type_controls[utf8_encode($new_line['2'])]['precision'];
				$box_alq_label_suffix = $sample_type_controls[utf8_encode($new_line['2'])]['alq_label_suffix'];
			} else if($excel_line_counter == 3) {
				if(implode('-',$new_line) != utf8_decode("Emplacement-Congélateur-Étagère-Râtelier-Colonne-Rangée")) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_3'); }
			} else if($excel_line_counter == 4) {				
				$freezer_label = "freezer[".$new_line['2']."](-)";
				$shelf_label = "shelf[".$new_line['3']."](-)";
				$rack_label = "rack16[".$new_line['4']."](-)";
				$box_label = "[$box_label](".$new_line['5']."-".((isset($new_line['6']) && strtolower($new_line['6']) != 'x')? $new_line['6'] : '').")";
			} else if($excel_line_counter == 5) {
				$box_column_nbr = 0;
				if(sizeof($new_line) == 3) {
					$box_column_nbr = 3;
					$box_row_nbr = 10;
					$box_label = 'box30 3x10'.$box_label;
				} else if(sizeof($new_line) == 10) {
					$box_column_nbr = 10;
					$box_row_nbr = 10;
					$box_label = 'box100 10x10'.$box_label;
				} else if(sizeof($new_line) == 7) {
					$box_column_nbr = 7;
					$box_row_nbr = 7;
					$box_label = 'box49 7x7'.$box_label;				
				} else {
					pr($new_line);
					die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_5');
				}
				for($key = 2; $key < ($box_column_nbr+2); $key++) {
					if(in_array($new_line[$key], array('6A', '6B'))) {
						$box_notes[] = 'Changed column '.$new_line[$key].' to '.($key-1);
					} else if($new_line[$key] != ($key-1)) { 
						die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_5.2'); 
					}	
				}
			} else {
				$studied_box_row++;
				if($studied_box_row <= $box_row_nbr) {
					if($new_line['1'] != $studied_box_row) { die('ERR_parse_all_boxes_['.$work_sheet_name.']_line_>5'); }
					unset($new_line['1']);
					$line_notes = array();
					foreach($new_line as $key => $value) {
						$value = str_replace(array("\n"), array(' '), $value);
						$value = preg_replace('/(\ ){2,100}/', ' ', $value);
						$studied_box_column = ($key - 1);
						if($studied_box_column <= $box_column_nbr) {
							$aliquot_label = str_replace(
								array('PS4O', '-V0', 'PS4PO', 'PS4POO', '-O8', 'PS4PP', 'VO1', 'PA4P', 'P0 290'), 
								array('PS4P', ' V0', 'PS4P0', 'PS4P0', '-08', 'PS4P', 'V01', 'PS4P', 'P0290'),
								$value);
							$aliquot_label = preg_replace('/(\ ){2,100}/', ' ', $aliquot_label);
							if(preg_match('/^(PS[0-9]\ {0,1}P[0-9]{3,5})(\ ){0,1}(V0[0-9])(\ ){0,1}(\-{0,1}(PLA|URC|BRC|URN|SER|BFC|BCF|DNA|RNA|FRZ|miR|UNC)(\ ){0,1}([0-9]){0,2})(\ )*(([0-9]{2}\-[0-9]{2}\-[0-9]{4}){0,1}|([0-9]{4}\-[0-9]{2}\-[0-9]{2}){0,1})\ *$/', $aliquot_label, $matches)) {								
								$alq_label_suffix = str_replace(array('BRC','BCF', 'UNC'), array('BFC','BFC', 'URI'), $matches[6]);
								if($alq_label_suffix != $box_alq_label_suffix) {								
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']["Wrong aliquot label suffix for '$box_definition' box"][] = "The suffix [$alq_label_suffix] of the aliquot label [$aliquot_label] is different than the defined suffix [$box_alq_label_suffix] based on box description. See $work_sheet_name cell [$studied_box_column/$studied_box_row].";
								}
								$formated_participant_identifier = str_replace(' ','',$matches[1]);
								if(!preg_match('/^PS[0-9]P[0-9]{4}$/', $formated_participant_identifier)) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']["Wrong participant identifier"][] = "The format of the participant identifier [$formated_participant_identifier] extracted from the aliquot label [$aliquot_label] is wrong. Expected PS4P0000. See $work_sheet_name cell [$studied_box_column/$studied_box_row].";
								}
								$formated_visit = str_replace(' ','',$matches[3]);
								if(!preg_match('/^V0[0-9]$/', $formated_visit)) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']["Wrong visit"][] = "The format of the visit [$formated_visit] extracted from the aliquot label [$aliquot_label] is wrong. Expected V0[0-9]. See $work_sheet_name cell [$studied_box_column/$studied_box_row].";
								}
								$formated_aliquot_label_suffix = $alq_label_suffix.$matches[8];
								if(!preg_match('/^(((SRB|RNB|EDB|WHT|PLA|SER|BFC|FRZ|PAR|URI|URN|URC|DNA|RNA)[0-9]{1,2})|(miR))$/', $formated_aliquot_label_suffix)) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']["Wrong aliquot label suffix"][] = "The format of the aliquot label suffix [$formated_aliquot_label_suffix] extracted from the aliquot label [$aliquot_label] is wrong. Expected (SRB|RNB|EDB|WHT|PLA|SER|BFC|FRZ|PAR|URI|URN|URC|DNA|RNA)[0-9]{1,2})|(miR). See $work_sheet_name cell [$studied_box_column/$studied_box_row].";
								}
								$formated_aliquot_label = "$formated_participant_identifier $formated_visit -$formated_aliquot_label_suffix";
								$storage_datetime = "''";
								$storage_datetime_accuracy = "''";
								if(!empty($matches[10])) {
									if(preg_match('/^([0123][0-9])\-(0[1-9]|1[0-2])\-([0-9]{4})$/', $matches[10], $matches_2)) $matches[10] = $matches_2[3].'-'.$matches_2[2].'-'.$matches_2[1];
									$storage_date_data = getDateAndAccuracy($matches[10], $summary_msg_title, '-', "'-' - worksheet : '$work_sheet_name' + cell [$studied_box_column-$studied_box_row]");
									if($storage_date_data) {
										$storage_datetime = $storage_date_data['date'];
										$storage_datetime_accuracy = str_replace('c','h', $storage_date_data['accuracy']);
									}
								}
								$tmp_storage_data = array(
									'aliquot_label' => $formated_aliquot_label, 
									'sample_type' => $box_sample_type,
									'sample_type_precision' => $box_sample_type_details,
									'storage_datetime' => $storage_datetime,
									'storage_datetime_accuracy' => $storage_datetime_accuracy,
									'storage_master_id' => $box_storage_master_id,
									'x' => $studied_box_column, 
									'y' => $studied_box_row, 
									'storage_datetime' => $storage_datetime,
									'tmp_work_sheet_name' => $work_sheet_name,
									'tmp_cell_value' => $value);
								
								$patient_identification = '';
								$visit = '';
								$sample_label_suffix = '';
								if(preg_match('/^(PS[0-9]P[0-9]{3,5})\ (V0[0-9])\ \-((miR)|(DNA2)|(DNA3))$/', $formated_aliquot_label, $matches)) {
									$patient_identification = $matches[1];
									$visit = $matches[2];
									$sample_label_suffix = $matches[3];
									Config::$additional_dna_miR_from_storage[$patient_identification][$visit][$box_sample_type][] = $tmp_storage_data;
								} else {
									Config::$storage_data_from_sample_type_and_label[$box_sample_type][$formated_aliquot_label][] = $tmp_storage_data; 
								}
							} else {							
								Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong aliquot label'][] = "No aliquot label can be extracted from value [$value] in worksheet $work_sheet_name cell [$studied_box_column/$studied_box_row]. Format is not recognized. Aliquot positon won't be imported.";
							}
						} else {
							$line_notes[] = $value;
						}
					}
					$box_notes[] = implode(' | ', $line_notes);
				} else {
					$box_notes[] = str_replace(array("\n", '  '), array(' ', ' '), implode(' | ', $new_line));	
				}
			}
		}
		$box_label = utf8_encode($box_label);
		if(isset(Config::$storages[$freezer_label][$shelf_label][$rack_label][$box_label]))	die('ERR_parse_all_boxes_dup : '.$box_label); 
		Config::$storages[$freezer_label][$shelf_label][$rack_label][$box_label]['id'] = $box_storage_master_id;
		Config::$storages[$freezer_label][$shelf_label][$rack_label][$box_label]['notes'] = utf8_encode(str_replace("'", "''", implode("\n", array_filter($box_notes))));
	}	

	// *** LOAD WHATMAN PAPER ***
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_storage_whatman_paper);
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) {
		$work_sheet_name = $tmp['name'];
		if(!preg_match('/^Bo.te/', $work_sheet_name)) {	
			Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unexpected Worksheet'][] = "Worksheet name [$work_sheet_name] has not been parsed.";
			continue;
		}
		$box_storage_master_id = getNewtStorageId();
		$box_label_from_work_sheet_name = str_replace(array('Boîte', ' '), array('', ''), utf8_encode($tmp['name']));
		$box_label = '';
		
		$first_box_line = null;
		$box_data = array();
		foreach($tmp_xls_reader->sheets[$key]['cells'] as $line => $new_line) {			
			//Get box label
			if(in_array(utf8_decode('Boîte'), $new_line)) { 
				$new_line = array_values($new_line);			
				if($new_line['0'] != utf8_decode('Boîte')) die('ERR_whatman_paper.1 - '.$work_sheet_name);
				$new_line['1'] = str_replace(' et ', '-', $new_line['1']);
				if(!preg_match('/^[0-9]+(\-[0-9]+){0,1}$/', $new_line['1'], $matches)) die('ERR_whatman_paper.2 - '.$work_sheet_name);
				if($box_label_from_work_sheet_name != $new_line['1']) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Box code mismatch'][] = "Worksheet name [$work_sheet_name] is different than box label [".$new_line['1']."].";
				$box_label = "box40[".$new_line['1']."](-)";
			}		
			if(implode('',$new_line) == "12345678910") { 
				if(!$box_label) die('ERR_whatman_paper.3 - '.$work_sheet_name);
				$first_box_line = $line;
			}	
			if($first_box_line) {		
				if($line == $first_box_line) {		
					$box_data[0] = array('header' => $new_line, 'data' => array());
				} else if($line == ($first_box_line + 2)) {
					if(implode('',$new_line) != "11121314151617181920") die('ERR_whatman_paper.4 - '.$work_sheet_name);
					$box_data[1] = array('header' => $new_line, 'data' => array());
				} else if($line == ($first_box_line + 4)) {
					if(implode('',$new_line) != "21222324252627282930") die('ERR_whatman_paper.5 Add cell values 21 to 30 - '.$work_sheet_name);
					$box_data[2] = array('header' => $new_line, 'data' => array());
				} else if($line == ($first_box_line + 6)) {
					if(implode('',$new_line) != "31323334353637383940") die('ERR_whatman_paper.6 - '.$work_sheet_name);
					$box_data[3] = array('header' => $new_line, 'data' => array());
				} else if($line < ($first_box_line + 8)) {
					$box_key = ($line - $first_box_line -1)/2;
					if(!isset($box_data[$box_key])) die('ERR_whatman_paper.7 - '.$work_sheet_name);
					$box_data[$box_key]['data'] = $new_line;
				} else {
					die('ERR_whatman_paper.8 - '.$work_sheet_name);
				}
			}
		}
		if(empty($box_data)) die('ERR_whatman_paper.9 - '.$work_sheet_name);
		
		$box_storage_master_id = getNewtStorageId();
		$box_sample_type = 'blood';
		$box_sample_type_details = 'whatman paper';
		
		foreach($box_data as $new_row_data) {
			$positions = $new_row_data['header'];
			$aliquots = $new_row_data['data'];
			foreach($positions as $tmp_key => $x_position) {
				if(isset($aliquots[$tmp_key])) {
					$value = str_replace(array("\n"), array(' '), $aliquots[$tmp_key]);
					$value = preg_replace('/(\ ){2,100}/', ' ', $value);	
					$aliquot_label = str_replace(array('WHT1', 'WTH-1','WHT-1'), array('-WHT1','-WHT1','-WHT1'), $value);
					if(preg_match('/^(PS[0-9]\ {0,1}P[0-9]{3,5})(\ ){0,1}(V0[0-9])(\ ){0,1}(\-WHT1)(\ ){0,1}(([0-9]{2}\-[0-9]{2}\-[0-9]{4}){0,1}|([0-9]{4}\-[0-9]{2}\-[0-9]{2}){0,1})\ *$/', $aliquot_label, $matches)) {
						$aliquot_label = str_replace(' ','',$matches[1]).' '.$matches[3].' '.$matches[5];												
						$storage_datetime = "''";
						$storage_datetime_accuracy = "''";
						if(!empty($matches[9])) {			
							if(preg_match('/^([0123][0-9])\-(0[1-9]|1[0-2])\-([0-9]{4})$/', $matches[9], $matches_2)) $matches[9] = $matches_2[3].'-'.$matches_2[2].'-'.$matches_2[1];
							$storage_date_data = getDateAndAccuracy($matches[9], $summary_msg_title, '-', "'-' - worksheet : '$work_sheet_name' + cell [$x_position]");
							if($storage_date_data) {	
								$storage_datetime = $storage_date_data['date'];
								$storage_datetime_accuracy = str_replace('c','h', $storage_date_data['accuracy']);
							}
						}
						Config::$storage_data_from_sample_type_and_label[$box_sample_type][$aliquot_label][] = array(
							'aliquot_label' => $aliquot_label,
							'sample_type' => $box_sample_type,
							'sample_type_precision' => $box_sample_type_details,
							'storage_datetime' => $storage_datetime,
							'storage_datetime_accuracy' => $storage_datetime_accuracy,
							'storage_master_id' => $box_storage_master_id,
							'x' => $x_position,
							'y' => '',
							'tmp_work_sheet_name' => $work_sheet_name,
							'tmp_cell_value' => $value);
					} else {
						Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong aliquot label'][] = "Aliquot label can not be extracted from value [$value] in worksheet $work_sheet_name cell [$x_position]. Format is not recognized. Aliquot positon won't be imported.";
					}
					unset($aliquots[$tmp_key]);
				}
			}
			if(!empty($aliquots))  die('ERR_whatman_paper.10 - '.$work_sheet_name);
		}
		if(isset(Config::$storages["room[Bureau Procure](-)"][$box_label]))	die('ERR_parse_all_boxes_dup : '.$box_label);
		Config::$storages["room[Bureau Procure](-)"][$box_label]['id'] = $box_storage_master_id;
		Config::$storages["room[Bureau Procure](-)"][$box_label]['notes'] = '';
	}
	
	// *** End of process ***
	
	// Check same label
	foreach(Config::$storage_data_from_sample_type_and_label as $sample_type => $storage_data_from_label) {
		foreach($storage_data_from_label AS $label => $aliquots) {
			if(sizeof($aliquots) > 1) {
				$msg = "<br>Aliquot label $label has been associated to many positioned aliquots:";
				foreach($aliquots as $new_aliquot) {
					$msg .= "<br> - - - > See worksheet [".$new_aliquot['tmp_work_sheet_name']."] cell (".$new_aliquot['x']."/".$new_aliquot['y'].") value [".$new_aliquot['tmp_cell_value']."]";
				}
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Duplicated aliquot label'][] = $msg;
			}
		}
	}
	
	recordChildrenStorage(Config::$storages);
	foreach(Config::$storages as $key => $val) unset(Config::$storages[$key]);
	
	setTemperature();
}

//=========================================================================================================
// Storage Record
//=========================================================================================================

function recordChildrenStorage($children_storages, $parent_selection_label = '', $parent_id = null) {
	if(empty($children_storages)) die('ERR 88838383');
	
	foreach($children_storages as $storage_label => $storage_content) {
		$storage_notes = '';
		if(isset($storage_content['notes'])) {
			$storage_notes = $storage_content['notes'];
			unset($storage_content['notes']);
		}
		$storage_master_id = null;
		if(isset($storage_content['id'])) {
			$storage_master_id = $storage_content['id'];
			unset($storage_content['id']);
			if(!empty($storage_content)) {
				pr($storage_content);die('ERR 9988998');
			}
		} else {
			$storage_master_id = getNewtStorageId();
		}
		
		if(!preg_match('/^([a-zA-Z0-9\ ]+)\[(.+)\]\((.*)-(.*)\)$/', $storage_label, $matches)) die('ERR 8839939393 '.$storage_label);
		if(!isset(Config::$storage_controls[$matches[1]])) die('ERR 8111119393 '.$storage_label);
		
		$storage_control = Config::$storage_controls[$matches[1]];
		$short_label = $matches[2];
		$selection_label = $parent_selection_label.(empty($parent_selection_label)? '' : '-').$short_label;
		
		$master_fields = array(
				"id" => $storage_master_id,
				"code" => $storage_master_id,
				"short_label" => $short_label,
				"selection_label" => $selection_label,
				"storage_control_id" => $storage_control['storage_control_id'],
				"parent_id" => $parent_id,
				"parent_storage_coord_x" => $matches[3],
				"parent_storage_coord_y" => $matches[4],
				"lft" => getNextLeftRight(),
				"notes" => $storage_notes
		);
		$storage_master_id = customInsertRecord($master_fields, 'storage_masters');
		customInsertRecord(array("storage_master_id" => $storage_master_id), $storage_control['detail_tablename'], true);
		
		if($storage_content) recordChildrenStorage($storage_content, $selection_label, $storage_master_id);
		
		$rght =  getNextLeftRight();
		$query = "UPDATE storage_masters SET rght = $rght WHERE id = $storage_master_id";
		mysqli_query(Config::$db_connection, $query) or die("Error on StorageMaster.rght value update. [$query] ");
		if(Config::$insert_revs){
			$query = str_replace('storage_masters','storage_masters_revs',$query);
			mysqli_query(Config::$db_connection, $query) or die("Error on StorageMaster.rght value update. [$query] ");
		}
	}
	return;
}

function getNewtStorageId() {
	Config::$previous_storage_master_id++;
	return Config::$previous_storage_master_id;
}

function getNextLeftRight() {
	Config::$previous_left_right++;
	return Config::$previous_left_right;
}

function setTemperature() {
	$query = "SELECT sm.id, sm.lft, sm.rght FROM storage_masters sm INNER JOIN storage_controls sc ON sc.id = sm.storage_control_id WHERE sc.storage_type = 'freezer';"	;
	$results =mysqli_query(Config::$db_connection, $query) or die("Error on StorageMaster temperature value update. [$query] ");
	while($row = $results->fetch_assoc()){
		$lft = $row['lft'];
		$rght  = $row['rght'];
		$query = "UPDATE storage_masters SET temperature = '-80', temp_unit = 'celsius' WHERE lft >= '$lft' AND rght <= '$rght'";
		mysqli_query(Config::$db_connection, $query) or die("Error on StorageMaster temperature value update. [$query] ");
		mysqli_query(Config::$db_connection, str_replace('storage_masters', 'storage_masters_revs', $query)) or die("Error on StorageMaster temperature value update. [$query] ");
	}
}
