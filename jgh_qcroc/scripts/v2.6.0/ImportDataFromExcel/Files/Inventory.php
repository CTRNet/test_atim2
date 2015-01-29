<?php

function loadTissue(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	$collection_labels_to_ids = array();
	
	//*** Collection ***
	
	$worksheet = 'Collection';
	$summary_title = "Tissue : $worksheet";
	foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 1){
			$new_line_data = formatNewLineData($headers, $new_line);
			$excel_collectoin_value = $new_line_data['Collection'];
			if(preg_match('/^01\-([12])-0*([0-9]+)$/', $excel_collectoin_value, $matches)) {
				$collection_id = getCollectionId($matches[2], $matches[1], $new_line_data['Date'], $new_line_data['Hospital site'], $new_line_data['Note'], $summary_title, $file_name, $worksheet, $line_counter);
				$collection_labels_to_ids[$excel_collectoin_value] = $collection_id;
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Collection Value Format Not Supported'][] = "See value [$excel_collectoin_value]! [file '$file_name' ($worksheet) - line: $line_counter]";
			}
		}
	}
	
	
	pr($collection_labels_to_ids);
	
	
}


function getCollectionId($qcroc_id, $pre_post_id, $excel_collection_date, $collection_site, $notes, $summary_title, $file_name, $worksheet, $line_counter){
	global $import_summary;
	global $import_date;
	global $controls;
	global $qcroc_ids_to_part_and_col_ids;
	
	//Participant Management
	
	if(!array_key_exists($qcroc_id, $qcroc_ids_to_part_and_col_ids)) {
		//Create Participant
		$data = array('participant_identifier' => (sizeof($qcroc_ids_to_part_and_col_ids) + 1), 'last_modification' => $import_date);
		$atim_participant_id  = customInsert($data, 'participants', __FILE__, __LINE__);
		$qcroc_ids_to_part_and_col_ids[$qcroc_id] = array('participant_id' => $atim_participant_id, 'collections' => array());
		//Create MiscIdentifier
		$data = array(
			'misc_identifier_control_id' => $controls['MiscIdentifierControl']['QCROC-01']['id'],
			'participant_id' => $atim_participant_id,
			'flag_unique' => $controls['MiscIdentifierControl']['QCROC-01']['flag_unique'],
			'identifier_value' => $qcroc_id);
		customInsert($data, 'misc_identifiers', __FILE__, __LINE__, false);
	} 
	$atim_participant_id = $qcroc_ids_to_part_and_col_ids[$qcroc_id]['participant_id'];
	
	//Collection Management
	
	$collection_date = getDateAndAccuracy(array('Date' => $excel_collection_date), 'Date', 'Consent & Questionnaire', $summary_title, $file_name, $worksheet, $line_counter);
	$collection_date['accuracy'] = str_replace('c', 'h', $collection_date['accuracy']);
	$collection_key = $pre_post_id."//".$collection_date['date']."//".$collection_date['accuracy']."//".$collection_site;
	if(!array_key_exists($collection_key, $qcroc_ids_to_part_and_col_ids[$qcroc_id]['collections'])) {
		switch($collection_site) {
			case 'JGH':
			case '':
				break;
			default;
			$import_summary[$summary_title]['@@WARNING@@']['Collection Site Unknown'][] = "See value [$collection_site]! No collection site will be set! [file '$file_name' ($worksheet) - line: $line_counter]";
			$collection_site = '';
		}
		if(!in_array($pre_post_id, array('1','2'))) die('ERR323672673262736='.$pre_post_id);
		$collection_data = array(
			'participant_id' => $atim_participant_id,
			'collection_datetime' => $collection_date['date'],
			'collection_datetime_accuracy' => $collection_date['accuracy'],
			'collection_property' => 'participant collection',
			'collection_site' => $collection_site,
			'qcrcoc_misc_identifier_control_id' => $controls['MiscIdentifierControl']['QCROC-01']['id'],
			'qcrcoc_collection_type' => (($pre_post_id == '1')? 'pre-treatment' : 'post-treatment'),
			'collection_notes' => $notes);
		$qcroc_ids_to_part_and_col_ids[$qcroc_id]['collections'][$collection_key] = customInsert($collection_data, 'collections', __FILE__, __LINE__); 
	} else if(strlen($notes)) {
		$notes = str_replace("'", "''", $notes);
		$query = "UPDATE collections SET notes = CONCAT('$notes', ' ', notes) WHERE id = ".$qcroc_ids_to_part_and_col_ids[$qcroc_id]['collections'][$collection_key].";";
		customQuery($query, __FILE__, __LINE__);
	}
	
	return $qcroc_ids_to_part_and_col_ids[$qcroc_id]['collections'][$collection_key];
}



































//TODO remove code below ==================================================================================================================================================================================
// ==================================================================================================================================================================================
// ==================================================================================================================================================================================
// ==================================================================================================================================================================================


function loadBlood($participant_id, $participant_identifier, $file_name, $worksheet, $line_counter, $new_line_data) {
	global $import_summary;
	global $controls;
	
	if($new_line_data['date prélèv. sang']) {
		//Collection
		$date_of_collection = getDateTimeAndAccuracy($new_line_data, 'date prélèv. sang', "hre de prélèvement sang", 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
		$collection_data = array(
			'participant_id' => $participant_id,
			'collection_datetime' => $date_of_collection['datetime'],
			'collection_datetime_accuracy' => $date_of_collection['accuracy'],
			'collection_property' => 'participant collection',
			'collection_notes' => '',
			'procure_visit' => $worksheet);
		$collection_id = customInsert($collection_data, 'collections', __FILE__, __LINE__);
		
		$date_of_derivative_creation = $date_of_collection;
		$date_of_derivative_creation['accuracy'] = str_replace(array('c','i'), array('h','h'), $date_of_derivative_creation['accuracy']);
		
		$collection_aliquot_created = false;
		
		// *** Create Serum Blood + Derivatives ***
		
		if($new_line_data['sérum nb tubes']) {
			//Blood
			$sample_data = array(
				'SampleMaster' => array(
					'collection_id' => $collection_id,
					'sample_control_id' => $controls['sample_aliquot_controls']['blood']['sample_control_id'],
					'initial_specimen_sample_type' => 'blood',
					'notes' => ''),
				'SpecimenDetail' => array(
					'reception_datetime' => $date_of_derivative_creation['datetime'],
					'reception_datetime_accuracy' => $date_of_derivative_creation['accuracy'],
					'procure_refrigeration_time' => getTime($new_line_data, 'hre de réfrigération tube sérum', 'Inventory - Blood', "$file_name ($worksheet)", $line_counter)),
				'SampleDetail' => array(
					'blood_type' => 'serum'));
			$blood_sample_master_id = createSample($sample_data, $controls['sample_aliquot_controls']['blood']['detail_tablename']);
			//Serum
			$serum_controls = $controls['sample_aliquot_controls']['serum'];
			$sample_data = array(
				'SampleMaster' => array(
					'collection_id' => $collection_id,
					'sample_control_id' => $serum_controls['sample_control_id'],
					'initial_specimen_sample_type' => 'blood',
					'initial_specimen_sample_id' => $blood_sample_master_id,
					'parent_sample_type' => 'blood',
					'parent_id' => $blood_sample_master_id,
					'notes' => ''),
				'DerivativeDetail' => array(
					'creation_datetime' => $date_of_derivative_creation['datetime'],
					'creation_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
				'SampleDetail' => array());
			$derivative_sample_master_id = createSample($sample_data, $serum_controls['detail_tablename']);
			//aliquots
			$storage_date = getDateTimeAndAccuracy($new_line_data, 'date prélèv. sang', "hre de congélation sérum", 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
			$created_aliquots = 0;
			for($id=1;$id<6;$id++){
				$initial_volume = getDecimal($new_line_data, 'ser-'.$id, 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
				if($initial_volume) {
					//Storage data
					$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte de rangement sérum-'.$id], 'serum', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
					$storage_coordinates = getPosition($participant_identifier, $new_line_data['position dans bte de rangement sérum-'.$id], $new_line_data['bte de rangement sérum-'.$id], 'serum', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
					//Create aliquot
					$aliquot_data = array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $derivative_sample_master_id,
							'aliquot_control_id' => $serum_controls['aliquots']['tube']['aliquot_control_id'],
							'barcode' => "$participant_identifier $worksheet -SER".$id,
							'in_stock' => 'yes - available',
							'initial_volume' => $initial_volume,
							'current_volume' => $initial_volume,
							'use_counter' => '0',
							'storage_datetime' => $storage_date['datetime'],
							'storage_datetime_accuracy' => $storage_date['accuracy'],
							'storage_master_id' => $storage_master_id,
							'storage_coord_x' => $storage_coordinates['x'],
							'storage_coord_y' => $storage_coordinates['y']),
						'AliquotDetail' => array());	
					$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
					customInsert($aliquot_data['AliquotDetail'], $serum_controls['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);		
					$created_aliquots++;
					$collection_aliquot_created = true;
				} else if(str_replace('x','',$new_line_data['position dans bte de rangement sérum-'.$id]) || str_replace('x','',$new_line_data['bte de rangement sérum-'.$id])) {
					$import_summary['Inventory - Blood']['@@WARNING@@']["No serum volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -SER".$id." is empty but a storage information is set (".$new_line_data['bte de rangement sérum-'.$id]." : ".$new_line_data['position dans bte de rangement sérum-'.$id]."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
				}
			}
			if($created_aliquots != $new_line_data['sérum nb tubes']) {
				$import_summary['Inventory - Blood']['@@WARNING@@']["Numbers of serum tubes (created and defined) are different"][] = "Based on all volume fields, the system created $created_aliquots aliquots but the number of aliquots defined into column 'sérum nb tubes' was equal to ".$new_line_data['sérum nb tubes'].". Please confirm. Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
			}
		} else if(str_replace('x','',$new_line_data['ser-1'])) {
			$import_summary['Inventory - Blood']['@@ERROR@@']["No serum defined as banked but aliquot volume set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
		}	
		
		// *** Create EDTA Blood + Derivatives (plasma + Whatman + BFC) ***
		
		if($new_line_data['plasma nb tubes'] || $new_line_data['FTA Elute WHT'] || $new_line_data['BFC en banque oui-non']) {
			//EDTA Blood
			$blood_controls = $controls['sample_aliquot_controls']['blood'];
			$sample_data = array(
				'SampleMaster' => array(
					'collection_id' => $collection_id,
					'sample_control_id' => $blood_controls['sample_control_id'],
					'initial_specimen_sample_type' => 'blood',
					'notes' => ''),
				'SpecimenDetail' => array(
					'reception_datetime' => $date_of_derivative_creation['datetime'],
					'reception_datetime_accuracy' => $date_of_derivative_creation['accuracy'],
					'procure_refrigeration_time' => getTime($new_line_data, 'hre de réfrigération tube EDTA', 'Inventory - Blood', "$file_name ($worksheet)", $line_counter)),
				'SampleDetail' => array(
					'blood_type' => 'k2-EDTA'));
			$blood_sample_master_id = createSample($sample_data, $blood_controls['detail_tablename']);
			//1-Whatman
			if($new_line_data['FTA Elute WHT'] == '1') {
				//Storage data
				$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement WHT'], 'whatman', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
				//Create aliquot
				$aliquot_data = array(
					'AliquotMaster' => array(
						'collection_id' => $collection_id,
						'sample_master_id' => $blood_sample_master_id,
						'aliquot_control_id' => $blood_controls['aliquots']['whatman paper']['aliquot_control_id'],
						'barcode' => "$participant_identifier $worksheet -WHT1",
						'in_stock' => 'yes - available',
						'use_counter' => '0',
						'storage_master_id' => $storage_master_id),
					'AliquotDetail' => array());
				$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
				customInsert($aliquot_data['AliquotDetail'], $blood_controls['aliquots']['whatman paper']['detail_tablename'], __FILE__, __LINE__, true);
				$collection_aliquot_created = true;
			} else if(str_replace('x','',$new_line_data['bte rangement WHT'])) {
				$import_summary['Inventory - Blood']['@@ERROR@@']["No Whatman paper defined as banked but aliquot storage set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
			}
			//2-plasma
			if($new_line_data['plasma nb tubes']) {
				$plasma_controls = $controls['sample_aliquot_controls']['plasma'];
				$sample_data = array(
					'SampleMaster' => array(
						'collection_id' => $collection_id,
						'sample_control_id' => $plasma_controls['sample_control_id'],
						'initial_specimen_sample_type' => 'blood',
						'initial_specimen_sample_id' => $blood_sample_master_id,
						'parent_sample_type' => 'blood',
						'parent_id' => $blood_sample_master_id,
						'notes' => ''),
					'DerivativeDetail' => array(
						'creation_datetime' => $date_of_derivative_creation['datetime'],
						'creation_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
					'SampleDetail' => array());
				$derivative_sample_master_id = createSample($sample_data, $plasma_controls['detail_tablename']);
				//aliquots
				$storage_date = getDateTimeAndAccuracy($new_line_data, 'date prélèv. sang', "hre de congélation plasma", 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
				$created_aliquots = 0;
				for($id=1;$id<6;$id++){
					$initial_volume = getDecimal($new_line_data, 'pla-'.$id, 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
					if($initial_volume) {
						//Storage data
						$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte de rangement plasma-'.$id], 'plasma', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
						$storage_coordinates = getPosition($participant_identifier, $new_line_data['position plasma-'.$id.' dans bte rangement'], $new_line_data['bte de rangement plasma-'.$id], 'plasma', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
						//Create aliquot
						$aliquot_data = array(
							'AliquotMaster' => array(
								'collection_id' => $collection_id,
								'sample_master_id' => $derivative_sample_master_id,
								'aliquot_control_id' => $plasma_controls['aliquots']['tube']['aliquot_control_id'],
								'barcode' => "$participant_identifier $worksheet -PLA".$id,
								'in_stock' => 'yes - available',
								'initial_volume' => $initial_volume,
								'current_volume' => $initial_volume,
								'use_counter' => '0',
								'storage_datetime' => $storage_date['datetime'],
								'storage_datetime_accuracy' => $storage_date['accuracy'],
								'storage_master_id' => $storage_master_id,
								'storage_coord_x' => $storage_coordinates['x'],
								'storage_coord_y' => $storage_coordinates['y']),
							'AliquotDetail' => array());
						$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
						customInsert($aliquot_data['AliquotDetail'], $plasma_controls['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
						$created_aliquots++;
						$collection_aliquot_created = true;
					} else if(str_replace('x','',$new_line_data['position plasma-'.$id.' dans bte rangement']) || str_replace('x','',$new_line_data['bte de rangement plasma-'.$id])) {
						$import_summary['Inventory - Blood']['@@WARNING@@']["No plasma volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -PLA".$id." is empty but a storage information is set (".$new_line_data['bte de rangement plasma-'.$id]." : ".$new_line_data['position plasma-'.$id.' dans bte rangement']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
					}
				}
				if($created_aliquots != $new_line_data['plasma nb tubes']) {
					$import_summary['Inventory - Blood']['@@WARNING@@']["Numbers of plasma tubes (created and defined) are different"][] = "Based on volume field, the system created $created_aliquots aliquots but the number of aliquots defined into column 'plasma nb tubes' was equal to ".$new_line_data['plasma nb tubes'].". Please confirm. Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
				}
			} else if(str_replace('x','',$new_line_data['pla-1'])) {
					$import_summary['Inventory - Blood']['@@ERROR@@']["No plasma defined as banked but aliquot volume set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
			}
			//3-BFC (pbmc)
			if($new_line_data['BFC en banque oui-non']) {
				$bfc_controls = $controls['sample_aliquot_controls']['pbmc'];
				$sample_data = array(
					'SampleMaster' => array(
						'collection_id' => $collection_id,
						'sample_control_id' => $bfc_controls['sample_control_id'],
						'initial_specimen_sample_type' => 'blood',
						'initial_specimen_sample_id' => $blood_sample_master_id,
						'parent_sample_type' => 'blood',
						'parent_id' => $blood_sample_master_id,
						'notes' => ''),
					'DerivativeDetail' => array(
						'creation_datetime' => $date_of_derivative_creation['datetime'],
						'creation_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
					'SampleDetail' => array());
				$derivative_sample_master_id = createSample($sample_data, $bfc_controls['detail_tablename']);
				//aliquots
				$storage_date = getDateTimeAndAccuracy($new_line_data, 'date prélèv. sang', "hre de congélation plasma", 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
				$created_aliquots = false;
				for($id=1;$id<4;$id++){
					$initial_volume = 0;
					if($id!=3) {
						$initial_volume = getDecimal($new_line_data, 'BFC cong. X2 (ml) '.$id, 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);
					} else {
						
						if($new_line_data['BFC 300ul'] == '1') {
							$initial_volume = '0.3';
						} else if(str_replace('x', '', $new_line_data['BFC 300ul'])) {
							$import_summary['Inventory - Blood']['@@ERROR@@']["Wrong 'BFC 300ul' value format"][] = "Value (".$new_line_data['BFC 300ul'].") different than '1'. No third aliquot will be created. See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
						}
					}
					if($initial_volume) {
						//Storage data
						$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement BFC-'.$id], 'pbmc', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
						$storage_coordinates = getPosition($participant_identifier, $new_line_data['position BFC-'.$id.' dans bte rangement'], $new_line_data['bte rangement BFC-'.$id], 'pbmc', 'Inventory - Blood', $file_name, $worksheet, $line_counter);
						//Create aliquot
						$aliquot_data = array(
							'AliquotMaster' => array(
								'collection_id' => $collection_id,
								'sample_master_id' => $derivative_sample_master_id,
								'aliquot_control_id' => $bfc_controls['aliquots']['tube']['aliquot_control_id'],
								'barcode' => "$participant_identifier $worksheet -BFC".$id,
								'in_stock' => 'yes - available',
								'initial_volume' => $initial_volume,
								'current_volume' => $initial_volume,
								'use_counter' => '0',
								'storage_datetime' => $storage_date['datetime'],
								'storage_datetime_accuracy' => $storage_date['accuracy'],
								'storage_master_id' => $storage_master_id,
								'storage_coord_x' => $storage_coordinates['x'],
								'storage_coord_y' => $storage_coordinates['y']),
							'AliquotDetail' => array());
						$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
						customInsert($aliquot_data['AliquotDetail'], $bfc_controls['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
						$collection_aliquot_created = true;
						$created_aliquots = true;
					} else if(str_replace('x','',$new_line_data['position BFC-'.$id.' dans bte rangement']) || str_replace('x','',$new_line_data['bte rangement BFC-'.$id])) {
						$import_summary['Inventory - Blood']['@@WARNING@@']["No BFC volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -BFC".$id." is empty but a storage information is set (".$new_line_data['bte rangement BFC-'.$id]." : ".$new_line_data['position BFC-'.$id.' dans bte rangement']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
					}
				}
				if(!$created_aliquots) {
					$import_summary['Inventory - Blood']['@@WARNING@@']["No tube of BFC defined"][] = "BFC tubes were defined as banked but no tube volume is set. No aliquot has been created .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
				}
			} else if(str_replace('x','',$new_line_data['BFC cong. X2 (ml) 1'])) {
				$import_summary['Inventory - Blood']['@@ERROR@@']["No BFC defined as banked but aliquot volume set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
			}
		} else if(str_replace('x','',$new_line_data['pla-1'])) {
			$import_summary['Inventory - Blood']['@@ERROR@@']["No plasma defined as banked but aliquot volume set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
		} else if(str_replace('x','',$new_line_data['BFC cong. X2 (ml) 1'])) {
			$import_summary['Inventory - Blood']['@@ERROR@@']["No BFC defined as banked but aliquot volume set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
		} else if(str_replace('x','',$new_line_data['bte rangement WHT'])) {
			//Test can only be done on storage
			$import_summary['Inventory - Blood']['@@ERROR@@']["No Whatman paper defined as banked but aliquot storage set"][] = "See Patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		
		// *** Create Paxgene Blood + Derivatives ***
		
		if($new_line_data['paxgene congelé'] == '1') {
			//Blood
			$sample_data = array(
				'SampleMaster' => array(
					'collection_id' => $collection_id,
					'sample_control_id' => $controls['sample_aliquot_controls']['blood']['sample_control_id'],
					'initial_specimen_sample_type' => 'blood',
					'notes' => ''),
				'SpecimenDetail' => array(
					'reception_datetime' => $date_of_derivative_creation['datetime'],
					'reception_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
				'SampleDetail' => array(
					'blood_type' => 'paxgene',
					'procure_tubes_correclty_stored' => (($new_line_data['paxgene congelé'] == 'oui')? '1' : '')));
			$blood_sample_master_id = createSample($sample_data, $controls['sample_aliquot_controls']['blood']['detail_tablename']);
			//Create aliquot
			$storage_date = getDateTimeAndAccuracy($new_line_data, 'date prélèv. sang', "hre de congélation paxgene", 'Inventory - Blood', "$file_name ($worksheet)", $line_counter);	
			$aliquot_data = array(
				'AliquotMaster' => array(
					'collection_id' => $collection_id,
					'sample_master_id' => $blood_sample_master_id,
					'aliquot_control_id' => $controls['sample_aliquot_controls']['blood']['aliquots']['tube']['aliquot_control_id'],
					'barcode' => "$participant_identifier $worksheet -RNB1",
					'in_stock' => 'yes - available',
					'use_counter' => '0',
					'storage_datetime' => $storage_date['datetime'],
					'storage_datetime_accuracy' => $storage_date['accuracy']),
				'AliquotDetail' => array());
			$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
			customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['blood']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
		}
		
		// *** Final Control ***
		
		if(!$collection_aliquot_created) {
			$import_summary['Inventory - Blood']['@@WARNING@@']["Collection date set but no aliquot created"][] = "See patient $participant_identifier. A collection was created (based on date) but no aliquot is defined into excel file. [file '$file_name :: $worksheet', line : $line_counter']";	
		}
	}  else {
		if(str_replace('x','', $new_line_data['sérum nb tubes'])) {
			$import_summary['Inventory - Blood']['@@WARNING@@']["No collection date but blood samples defined"][] = "See patient '$participant_identifier'. No collection has been created but '".$new_line_data['sérum nb tubes']."' serum tubes seam to be banked. Please confirm and create missing collection and samples. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		if(str_replace('x','', $new_line_data['plasma nb tubes'])) {
			$import_summary['Inventory - Blood']['@@WARNING@@']["No collection date but blood samples defined"][] = "See patient '$participant_identifier'. No collection has been created but '".$new_line_data['plasma nb tubes']."' plasma tubes seam to be banked. Please confirm and create missing collection and samples. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		if(str_replace('x','', $new_line_data['FTA Elute WHT'])) {
			$import_summary['Inventory - Blood']['@@WARNING@@']["No collection date but blood samples defined"][] = "See patient '$participant_identifier'. No collection has been created but 'Whatman Paper'  seams to be banked. Please confirm and create missing collection and samples. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		if(str_replace('x','', $new_line_data['BFC en banque oui-non'])) {
			$import_summary['Inventory - Blood']['@@WARNING@@']["No collection date but blood samples defined"][] = "See patient '$participant_identifier'. No collection has been created but 'BFC' plasma tubes seam to be banked. Please confirm and create missing collection and samples. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		if(str_replace('x','', $new_line_data['paxgene congelé'])) {
			$import_summary['Inventory - Blood']['@@WARNING@@']["No collection date but blood samples defined"][] = "See patient '$participant_identifier'. No collection has been created but paxgene tubes seam to be banked. Please confirm and create missing collection and samples. [file '$file_name :: $worksheet', line : $line_counter']";
		}
	}
}
	






















function loadTissue2($participant_id, $participant_identifier, &$psp_nbr_to_frozen_blocks_data, &$psp_nbr_to_paraffin_blocks_data, &$patho_nbr, $file_name, $worksheet, $line_counter, $new_line_data) {
	global $import_summary;
	global $controls;
	
	//*** PROSTATECTOMY + COLLECTION **
	
	$treatment_controls = $controls['TreatmentControl']['procure follow-up worksheet - treatment'];
	$prostatectomy_data = array();
	if($new_line_data['chirurgie fait'] == '1') {
		//Set prostatectomy data
		$date_of_prostatectomy = getDateAndAccuracy($new_line_data, 'date chirurgie', 'Inventory - Tissue', $file_name, $line_counter);
		$prostatectomy_data = array(
			'TreatmentMaster' => array(
				'participant_id' => $participant_id,
				'procure_form_identification' => "$participant_identifier  Vx -FSPx",
				'treatment_control_id' => $treatment_controls['treatment_control_id'],
				'start_date' => $date_of_prostatectomy['date'],
				'start_date_accuracy' => $date_of_prostatectomy['accuracy']),
			'TreatmentDetail' => array(
				'treatment_type' => 'prostatectomy'));
	} else {
		$comments = array();
		foreach(array('chirurgie fait', 'Tissus prélevé congelé') as $field) {
			if(!(preg_match('/^((0)|(non))$/', $new_line_data[$field]) || !strlen($new_line_data[$field]))) $comments[] = $new_line_data[$field];
		}
		if($comments) {
			$import_summary['Inventory - Tissue']['@@WARNING@@']['No prostatectomy but a surgery (or collection) comment has been added'][] = "See patient '$participant_identifier' with note(s) [".implode(' & ', $comments)."]. This note won't be migrated and has to be recorded manually by the user if required. [fields 'chirurgie fait' & 'Tissus prélevé congelé' - file '$file_name' :: $worksheet - line: $line_counter]";
		}		
	}
	$collection_id = null;
	$collection_data = null;
	if($prostatectomy_data) {
		if(in_array($new_line_data['Tissus prélevé congelé'], array('1', '1 retour patho')) ){
			//Create collection + add retour patho if required
			$date_of_collection = getDateTimeAndAccuracy($new_line_data, 'date chirurgie', "hre de prélèvement tissus (sortie de l'abdomen)", 'Inventory - Tissue', $file_name, $line_counter);
			$collection_data = array(
				'participant_id' => $participant_id,
				'collection_datetime' => $date_of_collection['datetime'],
				'collection_datetime_accuracy' => $date_of_collection['accuracy'],
				'collection_property' => 'participant collection',
				'collection_notes' => ($new_line_data['Tissus prélevé congelé'] == '1 retour patho')? '1 retour patho' : '',
				'procure_visit' => 'V01');				
			$collection_id = customInsert($collection_data, 'collections', __FILE__, __LINE__);	
		} else if(!preg_match('/^((0)|(non))$/', $new_line_data['Tissus prélevé congelé']) || !strlen($new_line_data['Tissus prélevé congelé'])) {
			$prostatectomy_data['TreatmentMaster']['notes'] = "Pas de tissu collecté (".$new_line_data['Tissus prélevé congelé'].').';
		}
		//Create prostatectomy
		$prostatectomy_data['TreatmentDetail']['treatment_master_id'] = customInsert($prostatectomy_data['TreatmentMaster'], 'treatment_masters', __FILE__, __LINE__, false);
		customInsert($prostatectomy_data['TreatmentDetail'], $treatment_controls['detail_tablename'], __FILE__, __LINE__, true);	
	}
	
	//*** TISSUE SAMPLE **
	
	$patient_frozen_block_data = array();
	if(array_key_exists($participant_identifier, $psp_nbr_to_frozen_blocks_data['blocks'])) {
		$patient_frozen_block_data = $psp_nbr_to_frozen_blocks_data['blocks'][$participant_identifier];
		unset($psp_nbr_to_frozen_blocks_data['blocks'][$participant_identifier]);
	}	
	
	$patient_paraffin_block_data = array();
	if(array_key_exists($participant_identifier, $psp_nbr_to_paraffin_blocks_data['blocks'])) {
		$patient_paraffin_block_data = $psp_nbr_to_paraffin_blocks_data['blocks'][$participant_identifier];
		unset($psp_nbr_to_paraffin_blocks_data['blocks'][$participant_identifier]);
	}
	
	if($collection_id) {
		$tissue_sample_controls = $controls['sample_aliquot_controls']['tissue'];
		//Set $procure_reference_to_biopsy_report
		$procure_reference_to_biopsy_report = str_replace('x','', $new_line_data['guidé par le rapport de biopsie']);
		switch($procure_reference_to_biopsy_report) {
			case '1':
			case 'oui':
				$procure_reference_to_biopsy_report = 'y';
				break;
			case 'non':
				$procure_reference_to_biopsy_report = 'n';
				break;
			case '':
				break;
			default:
				$import_summary['Inventory - Tissue']['@@WARNING@@']["Wrong 'guidé par le rapport de biopsie' value format"][] = "See patient '$participant_identifier' value [$procure_reference_to_biopsy_report]. This value won't be migrated. [field 'guidé par le rapport de biopsie' - file '$file_name' :: $worksheet - line: $line_counter]";
				$procure_reference_to_biopsy_report = '';
		}		
		//Create sample
		$sample_data = array(
			'SampleMaster' => array(
				'collection_id' => $collection_id,
				'sample_control_id' => $tissue_sample_controls['sample_control_id'],
				'initial_specimen_sample_type' => 'tissue',
				'notes' => str_replace(array('x','Aucune'),array('',''),$new_line_data['particularité tissus macroscopie'])),
			'SpecimenDetail' => array(
				'reception_datetime' => null,
				'reception_datetime_accuracy' => null),
			'SampleDetail' => array(
				'procure_tissue_identification' => $participant_identifier.' V01 PST1',
				'procure_prostatectomy_resection_time' => getTime($new_line_data, 'hre de résection laparoscopie', 'Inventory - Tissue', $file_name, $line_counter),
				'procure_report_number' => $patho_nbr,
				'prostate_fixation_time' => getTime($new_line_data, 'hre de fixation prostate', 'Inventory - Tissue', $file_name, $line_counter),
				'procure_lymph_nodes_fixation_time' => getTime($new_line_data, 'hre de fixation ganglions', 'Inventory - Tissue', $file_name, $line_counter),
				'procure_chuq_collected_prostate_slice_weight_gr' => getDecimal($new_line_data, 'poids de la tranche prélevé (gramme)', 'Pathology Report', "$file_name ($worksheet)", $line_counter),
				'procure_reference_to_biopsy_report' => $procure_reference_to_biopsy_report));
		$sample_master_id = createSample($sample_data, $tissue_sample_controls['detail_tablename']);
		
		$block_created = false;
		
		//*** FROZEN TISSUE BLOCKS **
		//Create block based on tissue size excel file
		
		//DateTime
		$storage_date = $prostatectomy_data['TreatmentMaster']['start_date'];
		if($storage_date && $new_line_data['Tissus congelé overnight'] == '1') {
			$date = new DateTime($storage_date);
			$date->add(new DateInterval('P1D'));
			$storage_date = $date->format('Y-m-d');
		}
		$storage_date_accuracy = $prostatectomy_data['TreatmentMaster']['start_date_accuracy'];
		$storage_time = getTime($new_line_data, 'hre de congélation tissus', 'Inventory - Tissue', $file_name, $line_counter);
		if($storage_time) {
			$storage_date .= ' '.$storage_time;
			if($storage_date_accuracy != 'c') die('ERR 8738728732');
		} else {
			$storage_date .= ' 00:00';
			$storage_date_accuracy = str_replace('c', 'h', $storage_date_accuracy);
		}
		//$duplicated_label_check = array();
		foreach($patient_frozen_block_data as $new_block) {
			//Note: All values of $new_block from file 'tissue size' already checked in previous function loadFrozenBlock()
			$block_created = true;
			$in_stock = 'yes - available';
			$aliquot_use = array();
			$notes = '';
			//Aliquot Internal Use Defintion: Check 'Date de coupe' comment
			switch($new_block['Date de coupe']) {
				case '':
					break;
				case 'envoi le 20 fév. 2012 au CUSM pour mapping et test extrac. ARN':
					$in_stock = 'yes - not available';
					$aliquot_use = array(
						'use_code' => 'Au CUSM pour Mapping + Extraction ARN', 
						'type' => 'on loan', 
						'use_details' => $new_block['Date de coupe'],
						'use_datetime' => '2012-02-20', 
						'use_datetime_accuracy' => 'h', 
						'used_by' => $new_block['Coupe réalisée par']);
					break;
				case 'retour des blocs congelé à la patho pour diagnostic':
					$in_stock = 'no';
					$aliquot_use = array(
						'use_code' => 'En Patho pour Diagnostic',
						'type' => 'on loan',
						'use_details' => $new_block['Date de coupe'],
						'use_datetime' => '',
						'use_datetime_accuracy' => '',
						'used_by' => $new_block['Coupe réalisée par']);
					break;
				case 'tissu redonné à la patho':
					$in_stock = 'no';
					$aliquot_use = array(
						'use_code' => 'Retour Patho',
						'type' => 'other',
						'use_details' => $new_block['Date de coupe'],
						'use_datetime' => '',
						'use_datetime_accuracy' => '',
						'used_by' => $new_block['Coupe réalisée par']);
					break;
				case 'un peu de calcifications':
					$notes = 'Un peu de calcifications';
					break;
				default:
					if(preg_match('/^2008\-10\-.+\/\/.+$/', $new_block['Date de coupe'])) {
						$use_datetime =array('date' => '2008-10-01 00:00', 'accuracy' =>'d');
					} else if('Hiver-Printemps 2007' == $new_block['Date de coupe']) {
						$use_datetime =array('date' => '2007-03-01 00:00', 'accuracy' =>'m');
					} else {
						$use_datetime = getDateAndAccuracy($new_block, 'Date de coupe', 'Inventory - Tissue', $psp_nbr_to_frozen_blocks_data['file_name'], $new_block['excel_line']);
						$use_datetime['accuracy'] = str_replace('c', 'h', $use_datetime['accuracy']);
					}
					if($use_datetime['date']) {
						$aliquot_use = array(
							'use_code' => 'Coupe',
							'type' => 'slide creation',
							'use_datetime' => $use_datetime['date'],
							'use_datetime_accuracy' => $use_datetime['accuracy'],
							'used_by' => $new_block['Coupe réalisée par']);
					} else {
						$import_summary['Inventory - Tissue']['@@ERROR@@']["Unable to extract 'Aliquot Use' information from 'Date de coupe'"][] = "Value '".$new_block['Date de coupe']."' is not supported and won't be migrated. See patient '$participant_identifier'. [file '".$psp_nbr_to_frozen_blocks_data['file_name']."', line '".$new_block['excel_line']."']";
					}
			}
			$use_counter = empty($aliquot_use)? ' 0' : '1';
			//time_spent_collection_to_freezing_end_mn
			$time_spent_collection_to_freezing_end_mn = null;
			if($storage_date &&  $collection_data['collection_datetime'] && ($collection_data['collection_datetime_accuracy'].$storage_date_accuracy) == 'cc') {				
				$col_date_ob = new DateTime($collection_data['collection_datetime']);
				$str_date_ob = new DateTime($storage_date);
				$interval = $col_date_ob->diff($str_date_ob);
				if(!$interval->invert) {
					$time_spent_collection_to_freezing_end_mn = $interval->d*24*60 + $interval->h*60 + $interval->i;
				}
			}
			//Storage data
			$storage_master_id = getStorageMasterId($participant_identifier, $new_block['boîte'], 'tissue', 'Inventory - Tissue', $psp_nbr_to_frozen_blocks_data['file_name'], '', $new_block['excel_line']);
			$storage_coordinates = getPosition($participant_identifier, $new_block['division'], $new_block['boîte'], 'tissue', 'Inventory - Tissue', $psp_nbr_to_frozen_blocks_data['file_name'], '', $new_block['excel_line']);
			if($in_stock == 'no' && $storage_master_id) {
				$import_summary['Inventory - Tissue']['@@WARNING@@']["Aliquot 'In Stock' value set to 'No'"][] = "Aliquot 'In Stock' value set to 'No' based on 'Date de coupe' value '".$new_block['Date de coupe']."' so storage information (".$new_block['boîte'].'/'.$new_block['division'].") won't be imported. See patient '$participant_identifier'. [file '".$psp_nbr_to_frozen_blocks_data['file_name']."', line '".$new_block['excel_line']."' &&  file '".$psp_nbr_to_frozen_blocks_data['file_name']."', line '".$new_block['excel_line']."']";
				$storage_master_id = null;
				$storage_coordinates = array('x'=>null, 'y'=>null);;
			}
			//Create aliquot	
			$aliquot_data = array(
				'AliquotMaster' => array(
					'collection_id' => $collection_id,
					'sample_master_id' => $sample_master_id,
					'aliquot_control_id' => $tissue_sample_controls['aliquots']['block']['aliquot_control_id'],
					'barcode' => "$participant_identifier V01 -".$new_block['label'],
					'in_stock' => $in_stock,
					'initial_volume' => null,
					'current_volume' => null,
					'use_counter' => $use_counter,
					'storage_datetime' => $storage_date,
					'storage_datetime_accuracy' => $storage_date_accuracy,
					'storage_master_id' => $storage_master_id,
					'storage_coord_x' => $storage_coordinates['x'],
					'storage_coord_y' => $storage_coordinates['y'],
					'notes' => $notes),
				'AliquotDetail' => array(
					'block_type' => 'frozen',
					'procure_freezing_type' => $new_block['i=iso  O=OCT'],
					'procure_origin_of_slice' => $new_block['quadrants'],
					'procure_dimensions' => $new_block['blocs (cm2)'],
					'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn));
			$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
			customInsert($aliquot_data['AliquotDetail'], $tissue_sample_controls['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
			//Aliquot Internal Use Record
			if(!empty($aliquot_use)) {
				$aliquot_use['aliquot_master_id'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
				customInsert($aliquot_use, 'aliquot_internal_uses', __FILE__, __LINE__, true);
			}
		}
		
		//*** PARAFFIN TISSUE BLOCKS **
		//Create block based on patho block excel file
				
		//$duplicated_label_check = array();
		foreach($patient_paraffin_block_data as $new_blocks_set) {
			$patho_nbr_from_paraffin_block = $new_blocks_set['# patho'];
			if(empty($patho_nbr_from_paraffin_block)) {
				$import_summary['Inventory - Tissue']['@@ERROR@@']['No Patho Number for paraffin block'][] = "The pathology number is not defined into the paraffin block file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. No block will be created. See patient '$participant_identifier'. ['".$psp_nbr_to_paraffin_blocks_data['file_name']."', line '".$new_blocks_set['excel_line']."']";
			} else {
				if(empty($patho_nbr)) {
					$patho_nbr = $patho_nbr_from_paraffin_block;
					$import_summary['Inventory - Tissue']['@@MESSAGE@@']['Used Patho Number of paraffin block'][] = "The pathology number ($patho_nbr_from_paraffin_block) is just set into the paraffin block file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. Will use this one for both sample and pathology report data. See patient '$participant_identifier'. ['".$psp_nbr_to_paraffin_blocks_data['file_name']."', line '".$new_blocks_set['excel_line']."']";	
					$query = "UPDATE ".$tissue_sample_controls['detail_tablename']." SET procure_report_number = '".str_replace("'", "''", $patho_nbr)."' WHERE sample_master_id = $sample_master_id;";
					customQuery($query, __FILE__, __LINE__);
				} else if($patho_nbr != $patho_nbr_from_paraffin_block){
					$import_summary['Inventory - Tissue']['@@ERROR@@']['Patho Numbers conflict'][] = "The pathology number ($patho_nbr) previously defined into patient excel file does not match the number ($patho_nbr_from_paraffin_block) defined into the paraffin block file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. Please confrim. See patient '$participant_identifier'. ['".$psp_nbr_to_paraffin_blocks_data['file_name']."', line '".$new_blocks_set['excel_line']."']";
				}
				foreach(array('bloc tumoral 1', 'bloc tumoral 2', 'bloc normal 1', 'bloc normal 2') as $block_key) {
					if($new_blocks_set[$block_key]) {
						$block_created = true;
						//Create aliquot
						$aliquot_data = array(
							'AliquotMaster' => array(
								'collection_id' => $collection_id,
								'sample_master_id' => $sample_master_id,
								'aliquot_control_id' => $tissue_sample_controls['aliquots']['block']['aliquot_control_id'],
								'barcode' => "$patho_nbr_from_paraffin_block-".$new_blocks_set[$block_key],
								'in_stock' => 'yes - available'),
							'AliquotDetail' => array(
								'block_type' => 'paraffin',
								'procure_classification' => preg_match('/^bloc normal/', $block_key)? 'NC' : 'C'));
						$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
						customInsert($aliquot_data['AliquotDetail'], $tissue_sample_controls['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
					}
				}
			}
		}
		
		//*** BLOCK CREATION CHECK **
		
		if(!$block_created) {
			$import_summary['Inventory - Tissue']['@@WARNING@@']["No Block defined for a patient tissue collection"][] = "See patient '$participant_identifier'. A tissue sample has been created but no block is defined into file '".$psp_nbr_to_frozen_blocks_data['file_name']."' or file '".$psp_nbr_to_paraffin_blocks_data['file_name']."'. No aliquot will be created.";
		}
	} else {
		if(!empty($patient_frozen_block_data)) {
			$import_summary['Inventory - Tissue']['@@ERROR@@']["No collection created but tissue blocks defined in tissue size file"][] = "See patient '$participant_identifier'. No tissue collection has been created but blocks are defined into tissue size file. No aliquot,sample and collection will be created. [file '".$psp_nbr_to_frozen_blocks_data['file_name']."']";
		}
		if(!empty($patient_paraffin_block_data)) {
			$import_summary['Inventory - Tissue']['@@ERROR@@']["No collection created but tissue blocks defined in path block file"][] = "See patient '$participant_identifier'. No tissue collection has been created but blocks are defined into patho block file. No aliquot,sample and collection will be created. [file '".$psp_nbr_to_paraffin_blocks_data['file_name']."']";
		}
	}
}

function loadRNA(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $controls;
	// Control
	$sample_aliquot_controls = $controls['sample_aliquot_controls'];
	$storage_control = $controls['storage_controls'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadConsentAndQuestionnaireData
	$headers = array();
	for($id=1;$id<10;$id++) {
//TODO
if(!in_array($id, array(1))) continue;
		$worksheet = "V0".$id;
		$paxgene_blood_tubes = array();	
		$query = "SELECT par.participant_identifier, am.collection_id, am.sample_master_id, am.barcode, am.id AS aliquot_master_id, am.storage_master_id, stm.selection_label
			FROM participants par
			INNER JOIN collections col ON col.participant_id = par.id
			INNER JOIN aliquot_masters am ON am.collection_id = col.id
			LEFT JOIN storage_masters stm ON stm.id = am.storage_master_id
			WHERE am.deleted <> 1 AND am.barcode LIKE '%-RNB%' AND col.procure_visit = '$worksheet' AND am.aliquot_control_id = ".$sample_aliquot_controls['blood']['aliquots']['tube']['aliquot_control_id'].";";
		$results = customQuery($query, __FILE__, __LINE__);
		while($row = $results->fetch_assoc()){
			$participant_identifier = $row['participant_identifier'];
			if(array_key_exists($participant_identifier, $paxgene_blood_tubes)) $import_summary['Inventory - RNA']['@@WARNING@@']["More than one paxgene tube exist"][] = "Only one will be used for RNA extraction. See patient '$participant_identifier'.";
			$paxgene_blood_tubes[$participant_identifier] = $row;
		}
		$procure_chuq_extraction_number = '';
		$aliquot_master_ids_to_remove = array('-1');
		foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
			//$line_counter++;
			if($line_counter == 2) {
				$headers = $new_line;
			} else if($line_counter > 3){
				$new_line_data = formatNewLineData($headers, $new_line);
				$participant_identifier = $new_line_data['# échantillon'];
				if(strlen($participant_identifier)) {
					if(preg_match('/^PS[0-9]P/', $participant_identifier)) {
						if(array_key_exists($participant_identifier, $paxgene_blood_tubes)) {
							//Parse excel data
							if(strlen($new_line_data['# extraction'])) $procure_chuq_extraction_number = $new_line_data['# extraction'];
							$extraction_date = getDateAndAccuracy($new_line_data, "Date             d'extraction", 'Inventory - RNA', $file_name, $line_counter);
							$extraction_date['accuracy'] = str_replace('c','h',$extraction_date['accuracy']);
							$notes = $new_line_data["Note d'incident         durant extration"];
							$procure_chuq_dnase_duration_mn = '';
							if($new_line_data["Délai DNAse"]) {
								if(preg_match('/^([0-9]+)\ min\.\ DNAse$/', $new_line_data["Délai DNAse"], $matches)) {
									$procure_chuq_dnase_duration_mn = $matches[1];
								} else {
									$import_summary['Inventory - RNA']['@@WARNING@@']["Wrong 'Délai DNAse' format"][] = "See value '".$new_line_data["Délai DNAse"]."' for patient '$participant_identifier'. No value imported. [file '$file_name' :: $worksheet - line: $line_counter]";
								}
							}
							$procure_chuq_extraction_method = '';
							if($new_line_data['extract. Manuelle'] == 1 && $new_line_data['Qiacube kit miRNA'] == 1) {
								$import_summary['Inventory - RNA']['@@WARNING@@']["Extraction method conflict"][] = "Extraction method defined both as manual and kit. No method will be set. See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
							} else if($new_line_data['extract. Manuelle'] == 1) {
								$procure_chuq_extraction_method = 'manual extraction';
							} else if($new_line_data['Qiacube kit miRNA'] == 1) {
								$procure_chuq_extraction_method = 'qiacube kit miRNA';
							}
							$created_by = '';
							switch($new_line_data['extrait par CHUQ']) {
								case 'CM':
								case 'MO':
								case 'VB':
								case  '':
									$created_by = $new_line_data['extrait par CHUQ'];
									break;
								case 'MO-CM':
								case 'CM (BC)':
								case 'CM (BC)':
								case 'VB et CM':
								case 'VB/CM':
									$created_by = 'CM';
									$import_summary['Inventory - RNA']['@@WARNING@@']["Changed lab staff who extracted RNA to 'CM'"][] = "Value '".$new_line_data['extrait par CHUQ']."' changed to 'CM'. See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
									break;
								default:
									$import_summary['Inventory - RNA']['@@ERROR@@']["Unknown lab staff who extracted RNA"][] = "Lab staff '".$new_line_data['extrait par CHUQ']."' is not supported. Value won't be migrated. See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
							}
							//Create RNA Sample
							$sample_data = array(
								'SampleMaster' => array(
									'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
									'sample_control_id' => $sample_aliquot_controls['rna']['sample_control_id'],
									'initial_specimen_sample_type' => 'blood',
									'initial_specimen_sample_id' => $paxgene_blood_tubes[$participant_identifier]['sample_master_id'],
									'parent_sample_type' => 'blood',
									'parent_id' => $paxgene_blood_tubes[$participant_identifier]['sample_master_id'],
									'notes' => $notes),
								'DerivativeDetail' => array(
									'creation_datetime' => $extraction_date['date'],
									'creation_datetime_accuracy' => $extraction_date['accuracy'],
									'creation_by' =>$created_by),
								'SampleDetail' => array(
									'procure_chuq_extraction_number' => $procure_chuq_extraction_number,
									'procure_chuq_dnase_duration_mn' => $procure_chuq_dnase_duration_mn,
									'procure_chuq_extraction_method' => $procure_chuq_extraction_method));
							$derivative_sample_master_id = createSample($sample_data, $sample_aliquot_controls['rna']['detail_tablename']);
							//Create aliquot to sample link		
							$source_aliquot_barcode = $paxgene_blood_tubes[$participant_identifier]['barcode'];
							$source_aliquot_master_id = $paxgene_blood_tubes[$participant_identifier]['aliquot_master_id'];
							customInsert(array('sample_master_id' => $derivative_sample_master_id, 'aliquot_master_id' => $source_aliquot_master_id), 'source_aliquots', __FILE__, __LINE__, false);
							//Update paxgen tube storage data
							$aliquot_master_ids_to_remove[] = $source_aliquot_master_id;
							if($paxgene_blood_tubes[$participant_identifier]['storage_master_id']) {
								$import_summary['Inventory - RNA']['@@WARNING@@']["Removed Paxgene Tube from Storage"][] = "Paxgen tube '$source_aliquot_barcode' was defined as used for RNA extraction. Migration process removed storage information (Tube was defined as stored into ".$paxgene_blood_tubes[$participant_identifier]['selection_label']."). See patient '$participant_identifier'. [file '$file_name' :: $worksheet - line: $line_counter]";
							}
							//Create aliquots
							$aliquot_master_ids = array();
							//... RNA1
							$initial_volume = getDecimal($new_line_data, 'RNA-1 volume (ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
							$concentration_bioanalyzer = getDecimal($new_line_data, 'Concentration (ng/ul) par Bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
							$concentration_unit_bioanalyzer = strlen($concentration_bioanalyzer)? 'ng/ul' : '';
							$procure_total_quantity_ug = (strlen($initial_volume) && strlen($concentration_bioanalyzer))? ($initial_volume*$concentration_bioanalyzer/1000): '';
							$concentration_nanodrop = getDecimal($new_line_data, 'Nanodrop (ng/ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
							$concentration_unit_nanodrop = strlen($concentration_nanodrop)? 'ng/ul' : '';
							$procure_total_quantity_ug_nanodrop = (strlen($initial_volume) && strlen($concentration_nanodrop))? ($initial_volume*$concentration_nanodrop/1000): '';
							if(strlen($new_line_data['bte rangement RNA-1']) || $initial_volume) {
								$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement RNA-1'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$storage_coordinates = getPosition($participant_identifier, $new_line_data['Position RNA-1 dans boîte de rangement'], $new_line_data['bte rangement RNA-1'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$aliquot_data = array(
									'AliquotMaster' => array(
										'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
										'sample_master_id' => $derivative_sample_master_id,
										'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
										'barcode' => "$participant_identifier $worksheet -RNA1",
										'in_stock' => 'yes - available',
										'initial_volume' => $initial_volume,
										'current_volume' => $initial_volume,
//TODO: Check use counter and volume updated after migration and newVersionSetup() execution											
										'use_counter' => '0',
										'storage_datetime' => $extraction_date['date'],
										'storage_datetime_accuracy' => $extraction_date['accuracy'],
										'storage_master_id' => $storage_master_id,
										'storage_coord_x' => $storage_coordinates['x'],
										'storage_coord_y' => $storage_coordinates['y']),
									'AliquotDetail' => array(
										'concentration' => $concentration_bioanalyzer,
										'concentration_unit' => $concentration_unit_bioanalyzer,
										'procure_total_quantity_ug' => $procure_total_quantity_ug,
										'procure_concentration_nanodrop' => $concentration_nanodrop,
										'procure_concentration_unit_nanodrop' => $concentration_unit_nanodrop,
										'procure_total_quantity_ug_nanodrop' => $procure_total_quantity_ug_nanodrop
									));
								$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
								customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
								$aliquot_master_ids['RNA-1'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							}
							//Mir
							if($new_line_data['MiR'] == '1' || strlen($new_line_data['Boîte de rangement Mir'])) {
								$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['Boîte de rangement Mir'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$storage_coordinates = getPosition($participant_identifier, $new_line_data['Position Mir dans boîte de rangement'], $new_line_data['Boîte de rangement Mir'], 'rna', 'Inventory - RNA', $file_name, $worksheet, $line_counter);
								$aliquot_data = array(
									'AliquotMaster' => array(
										'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
										'sample_master_id' => $derivative_sample_master_id,
										'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
//TODO: Confirm label										
										'barcode' => "$participant_identifier $worksheet -miRNA",
										'in_stock' => 'yes - available',
										'initial_volume' => null,
										'current_volume' => null,
										'use_counter' => '0',
										'storage_datetime' => $extraction_date['date'],
										'storage_datetime_accuracy' => $extraction_date['accuracy'],
										'storage_master_id' => $storage_master_id,
										'storage_coord_x' => $storage_coordinates['x'],
										'storage_coord_y' => $storage_coordinates['y']),
									'AliquotDetail' => array(
										'procure_chuq_micro_rna' => '1'));
								$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
								customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
								$aliquot_master_ids['RNA-micro'] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
							}
							for($id=2;$id<4;$id++) {
								$initial_volume = getDecimal($new_line_data, 'RNA-'.$id.' volume (ul)', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($initial_volume) {
									$aliquot_data = array(
										'AliquotMaster' => array(
											'collection_id' => $paxgene_blood_tubes[$participant_identifier]['collection_id'],
											'sample_master_id' => $derivative_sample_master_id,
											'aliquot_control_id' => $sample_aliquot_controls['rna']['aliquots']['tube']['aliquot_control_id'],
											'barcode' => "$participant_identifier $worksheet -RNA".$id,
											'in_stock' => 'no',
											'initial_volume' => $initial_volume,
											'current_volume' => $initial_volume,
											'use_counter' => '0'),
										'AliquotDetail' => array());
									$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
									customInsert($aliquot_data['AliquotDetail'], $sample_aliquot_controls['rna']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
									$aliquot_master_ids['RNA-'.$id] = $aliquot_data['AliquotDetail']['aliquot_master_id'];
								}
							}
							if(empty($aliquot_master_ids)) {
								$import_summary['Inventory - RNA']['@@WARNING@@']["No tube of RNA defined"][] = "RNA sample has been created but no tube volume is set. No aliquot has been created .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
							}
							//Bioanalyzer
							$qc_code_counter = 0;
							if($new_line_data['Analysé par bioanalyser'] || strlen($new_line_data["Date d'analyse"])) {
								$scores = array();
								$score = getDecimal($new_line_data, 'Valeur RIN', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['RIN'] = $score;
								$score = getDecimal($new_line_data, 'Ratio 28S/18S Bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['28/18'] = $score;
								if(empty($scores)) {
									$import_summary['Inventory - RNA']['@@WARNING@@']["Bioanalyzer test with no scrore"][] = "Please confirm .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									$scores[''] = '';
								}
								$qc_date = getDateAndAccuracy($new_line_data, "Date d'analyse", 'Inventory - RNA', $file_name, $line_counter);
								$qc_date['accuracy'] = str_replace('c','h',$qc_date['accuracy']);
								$tested_aliquot_master_id = null;
								if($new_line_data['Aliquot utilisé pour bioanalyser']) {
									if(array_key_exists($new_line_data['Aliquot utilisé pour bioanalyser'], $aliquot_master_ids)) {
										$tested_aliquot_master_id = $aliquot_master_ids[$new_line_data['Aliquot utilisé pour bioanalyser']];
									} else {
										$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer: Unable to define tested aliquot"][] = "The system is unable to link bioanalyzer test to the specific aliquot defined as  '".$new_line_data['Aliquot utilisé pour bioanalyser']."'. This one has not been created into the system. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									}
								}
								$new_line_data['Volume pris pour analyse  bioanalyser'] = str_replace(' ul', '', $new_line_data['Volume pris pour analyse  bioanalyser']);
								$used_volume = getDecimal($new_line_data, 'Volume pris pour analyse  bioanalyser', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if(is_null($tested_aliquot_master_id) && strlen($used_volume)) {
									$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer: Used volume but no tested aliquot"][] = "A 'Volume pris pour analyse  bioanalyser' is defined but no tested aliquot is defined. No volume will be migrated. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									$used_volume = '';
								}
								foreach($scores as $unit => $score) {
									$qc_code_counter++;
									$qc_data = array(
										'qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter,
										'sample_master_id' => $derivative_sample_master_id,
										'aliquot_master_id' => $tested_aliquot_master_id,
										'used_volume' => $used_volume,
										'type' => 'bioanalyzer',
										'procure_analysis_by' => $new_line_data["Centre d'analyse"],
										'date' => $qc_date['date'],
										'date_accuracy' => $qc_date['accuracy'],
										'score' => $score,
										'unit' => $unit,
										'procure_chuq_visual_quality' => $new_line_data["Qualité visuelle Bioanalyser"],
										'notes' => strlen($new_line_data['Chip comment'])? 'Chip note: '.$new_line_data['Chip comment'] : '');
									customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
									$used_volume = ''; //In case there are 2 scores no used wolume will be defined for the second one
								}
							} else if(strlen($new_line_data['Valeur RIN'].$new_line_data['Ratio 28S/18S Bioanalyser'])) {
								$import_summary['Inventory - RNA']['@@ERROR@@']["Bioanalyzer was defined as not executed but results exist"][] = "No bioanalyzer test will be migrated. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
							}
							//Nanodrop
							if(strlen($new_line_data["Nanodrop date analyse"])) {
								$scores = array();
								$score = getDecimal($new_line_data, 'Nanodrop A260', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['260'] = $score;
								$score = getDecimal($new_line_data, 'Nanodrop A280', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['280'] = $score;
								$score = getDecimal($new_line_data, 'Nanodrop 260/280', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['260/280'] = $score;
								$score = getDecimal($new_line_data, 'Nanodrop 260/230', 'Inventory - RNA', "$file_name ($worksheet)", $line_counter);
								if($score) $scores['260/230'] = $score;
								if(empty($scores)) {
									$import_summary['Inventory - RNA']['@@WARNING@@']["Nanodrop test with no scrore"][] = "Please confirm .See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
									$scores[''] = '';
								}
								$qc_date = getDateAndAccuracy($new_line_data, "Nanodrop date analyse", 'Inventory - RNA', $file_name, $line_counter);
								$qc_date['accuracy'] = str_replace('c','h',$qc_date['accuracy']);
								//Note: Volume pris pour analyse nanodrop: Not imported because no linked aliquot
								foreach($scores as $unit => $score) {
									$qc_code_counter++;
									$qc_data = array(
										'qc_code' => 'tmp'.$derivative_sample_master_id.'-'.$qc_code_counter,
										'sample_master_id' => $derivative_sample_master_id,
										'type' => 'nanodrop',
										'procure_analysis_by' => $new_line_data["Nanodrop centre analyse"],
										'date' => $qc_date['date'],
										'date_accuracy' => $qc_date['accuracy'],
										'score' => $score,
										'unit' => $unit);
									customInsert($qc_data, 'quality_ctrls', __FILE__, __LINE__, false);
								}
							} else if(strlen($new_line_data['Nanodrop A260'].$new_line_data['Nanodrop A280'].$new_line_data['Nanodrop 260/280'].$new_line_data['Nanodrop 260/230'])) {
								$import_summary['Inventory - RNA']['@@ERROR@@']["Nanodrop test was defined as not executed but results exist"][] = "No test will be migrated. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
							}							
							unset($paxgene_blood_tubes[$participant_identifier]);
						} else {
							$import_summary['Inventory - RNA']['@@ERROR@@']["No paxgene tube"][] = "RNA has been defined for patient $participant_identifier but no paxgene tube was previously created into the system. No RNA will be created. [file '$file_name' :: $worksheet - line: $line_counter";
						}
					}
				}
			}
		}
		//Update paxgen tube storage data
		$query = "UPDATE aliquot_masters SET in_stock = 'no', storage_master_id = null, storage_coord_x = null, storage_coord_y = null WHERE id IN ('".implode("','", $aliquot_master_ids_to_remove)."');";
		customQuery($query, __FILE__, __LINE__);
	}
}
function createSample($sample_data, $detail_tablename) {
	global $sample_code;

	$sample_data['SampleMaster']['sample_code'] = 'tmp'.($sample_code++);
	//Master
	$sample_master_id = customInsert($sample_data['SampleMaster'], 'sample_masters', __FILE__, __LINE__, false);
	//Specimen/Derivative
	if(array_key_exists('SpecimenDetail', $sample_data)) {
		$sample_data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
		customInsert($sample_data['SpecimenDetail'], 'specimen_details', __FILE__, __LINE__, true);
	} else {
		$sample_data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
		customInsert($sample_data['DerivativeDetail'], 'derivative_details', __FILE__, __LINE__, true);
	}
	//Detail
	$sample_data['SampleDetail']['sample_master_id'] = $sample_master_id;
	customInsert($sample_data['SampleDetail'], $detail_tablename, __FILE__, __LINE__, true);
	
	return$sample_master_id;
}

function getBoxStorageUniqueKey($excel_storage_label, $sample_type) {	
	if(!$excel_storage_label) {
		die('ERR 283ee234342.1');
	} else {
//TODO confirm avec claire		
		switch($sample_type) {
			case 'tissue':
				return 'tissue-'.$excel_storage_label;
			case 'serum':
			case 'plasma':
			case 'pbmc':
			case 'concentrated urine':
			case 'rna':
				return 'blood_and_urinec-'.$excel_storage_label;
			case 'whatman':
				return 'whatman-'.$excel_storage_label;
			case 'urine':
				return 'urine-'.$excel_storage_label;
			default:
				die('ERR 283ee234342.2');
		}
	}
}

function getStorageMasterId($participant_identifier, $excel_storage_label, $sample_type, $data_type, $file_name, $worksheet, $line_counter) {
	global $controls;
	global $storage_master_ids;
	global $sample_storage_types;
	global $last_storage_code;
	global $import_summary;
	
	$excel_storage_label = $excel_storage_label;
	if(empty($excel_storage_label)) {
		return null;
	} else {
		$box_storage_unique_key = getBoxStorageUniqueKey($excel_storage_label, $sample_type);
		if(array_key_exists($box_storage_unique_key, $storage_master_ids)) {
			return $storage_master_ids[$box_storage_unique_key]['storage_master_id'];
		} else {
			//Storage to create
			$rack_label = null;
			$box_label = null;
			if(!array_key_exists($sample_type, $sample_storage_types)) die('ERR 232 87 6287632.1');
			switch($sample_type) {
				case 'tissue':
				case 'serum':
				case 'plasma':
				case 'pbmc':
				case 'concentrated urine':
				case 'rna':
					if(preg_match('/^(R[0-9]+)(B[0-9]+)$/',$excel_storage_label, $matches)) {
						$rack_label = $matches[1];
						$box_label = $matches[2];
					} else {
						$import_summary[$data_type]['@@ERROR@@']["Unable to extract both rack and box labels"][] = "Unable to extract the rack and box labels for $sample_type box with value '$excel_storage_label'. Box label will be set to '$excel_storage_label' and no rack will be created. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter]";
						$box_label = $excel_storage_label;
					}
					break;
				case 'whatman':
				case 'urine':
					$box_label = $excel_storage_label;
					break;
				default:
					die('ERR 283728 7628762');
			}
			if(!$box_label) die('ERR 232 87 6287632.2');
			//create rack
			$parent_storage_master_id = null;
			if($rack_label) {
				$rack_storage_unique_key = 'rack'.$rack_label;
				if(array_key_exists($rack_storage_unique_key, $storage_master_ids)) {
					$parent_storage_master_id = $storage_master_ids[$rack_storage_unique_key]['storage_master_id'];
				} else {
					$storage_controls_data = $controls['storage_controls']['rack16'];
					$last_storage_code++;
					$storage_data = array(
						'StorageMaster' => array(
							"code" => 'tmp'.$last_storage_code,
							"short_label" => $rack_label,
							"selection_label" => $rack_label,
							"storage_control_id" => $storage_controls_data['storage_control_id'],
							"parent_id" => null),
						'StorageDetail' => array());
					$storage_data['StorageDetail']['storage_master_id'] = customInsert($storage_data['StorageMaster'], 'storage_masters', __FILE__, __LINE__, false);
					customInsert($storage_data['StorageDetail'],$storage_controls_data['detail_tablename'], __FILE__, __LINE__, true);
					$parent_storage_master_id = $storage_data['StorageDetail']['storage_master_id'];
					$storage_master_ids[$rack_storage_unique_key] = array('storage_master_id' => $parent_storage_master_id, 'storage_type' => 'rack16');
				}
			}
			//create box
			$storage_type = $sample_storage_types[$sample_type];
			if(!array_key_exists($storage_type, $controls['storage_controls'])) die('ERR2327627623');
			$storage_controls_data = $controls['storage_controls'][$storage_type];
			$last_storage_code++;
			$storage_data = array(
				'StorageMaster' => array(
					"code" => 'tmp'.$last_storage_code,
					"short_label" => $box_label,
					"selection_label" => ($rack_label? $rack_label.'-' : '').$box_label,
					"storage_control_id" => $storage_controls_data['storage_control_id'],
					"parent_id" => $parent_storage_master_id),
				'StorageDetail' => array());
			$storage_data['StorageDetail']['storage_master_id'] = customInsert($storage_data['StorageMaster'], 'storage_masters', __FILE__, __LINE__, false);
			customInsert($storage_data['StorageDetail'],$storage_controls_data['detail_tablename'], __FILE__, __LINE__, true);
			$storage_master_ids[$box_storage_unique_key] = array('storage_master_id' => $storage_data['StorageDetail']['storage_master_id'], 'storage_type' => $storage_type);
			return $storage_data['StorageDetail']['storage_master_id'];
		}
	}
}

function getPosition($participant_identifier, $excel_postions, $excel_storage_label, $sample_type, $data_type, $file_name, $worksheet, $line_counter) {
	global $storage_master_ids;
	global $controls;
	global $import_summary;
	$excel_postions = $excel_postions;
	$positions = array('x'=>null, 'y'=>null);
	if(empty($excel_postions)) {
		//Nothing to do
	} else if(empty($excel_storage_label)) {
		$import_summary[$data_type]['@@ERROR@@']["Storage position but no box label defined"][] = "No position will be set. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter]";
	} else {
		$box_storage_unique_key = getBoxStorageUniqueKey($excel_storage_label, $sample_type);
		if(!array_key_exists($box_storage_unique_key, $storage_master_ids))  die('ERR 2387 628763287.2');
		$storage_type = $storage_master_ids[$box_storage_unique_key]['storage_type'];
		switch($storage_type) {
			case 'box27 1A-9C':
				if(preg_match('/^([A-C])([1-9])$/', $excel_postions, $matches)) {
					$positions['x'] = $matches[2];
					$positions['y'] = $matches[1];
				}
				break;
			case 'box81':
				if(preg_match('/^(([1-9])|([1-7][0-9])|(8[0-1]))$/', $excel_postions)) $positions['x'] = $excel_postions;
				break;
			case 'box49 1A-7G':
				if(preg_match('/^([A-G])([1-7])$/', $excel_postions, $matches)) {
					$positions['x'] = $matches[2];
					$positions['y'] = $matches[1];
				}
				break;
			default:
				die('ERR327632767326 '.$storage_type);	
		}
		if(is_null($positions['x'])) $import_summary[$data_type]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box ($storage_type) is wrong. No position will be set. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter]";
	}
	return $positions;
}







?>