<?php

//TODO Dans l'onglet v01 vérifier que le libellé 'urine concentrée' est bien ajoutée dans la ligne 2: 'urine concentrée vol. après conc.', 'urine concentrée ratio conc.'
//TODO: Supprimer le contenu de toute cellule = '¯'

function loadBlock(&$XlsReader, $files_path, $file_name) {	
	global $import_summary;
	$psp_nbr_to_blocks_data = array('blocks'=>array(), 'file_name' => $file_name);
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	$dublicated_aliquots_check = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//Load data
	foreach($XlsReader->sheets[$sheets_nbr['Taille des blocs']]['cells'] as $line_counter => $new_line) {
		//$line_counter++;
		if($line_counter == 8) {
			$headers = $new_line;
		} else if($line_counter > 8){
			$new_line_data = formatNewLineData($headers, $new_line);
			$patient_identifier = $new_line_data['# patient'];
			if($patient_identifier && preg_match('/^PS2P/', $patient_identifier)) {
				if(empty($new_line_data['label'])) {
					$import_summary['Inventory - Tissue']['@@WARNING@@']["No Aliquot Label"][] = "See patient '$patient_identifier' value. No block won't be created. [field 'label' - file '$file_name' - line $line_counter]";
				} else if(in_array(($patient_identifier.$new_line_data['label']), $dublicated_aliquots_check)){
					$import_summary['Inventory - Tissue']['@@ERROR@@']["Duplicated Aliquot Label"][] = "See patient '$patient_identifier' value '".$new_line_data['label']."'. The second block won't be created. [field 'label' - file '$file_name' - line $line_counter]";
				} else {
					$dublicated_aliquots_check[$patient_identifier.$new_line_data['label']] = $patient_identifier.$new_line_data['label'];
					//procure_freezing_type
					$procure_freezing_type = '';
					switch($new_line_data['i=iso  O=OCT']) {
						case 'i':
						case 'I':
							$procure_freezing_type = 'ISO';
							break;
						case 'o':
						case 'O':
							$procure_freezing_type = 'ISO+OCT';
							break;
						case '':
						case 'x':
							break;
						default:
							$import_summary['Inventory - Tissue']['@@WARNING@@']["Wrong 'ISO/OCT' value format"][] = "See patient '$patient_identifier' value [".$new_line_data['i=iso  O=OCT']."]. This value won't be migrated. [field 'i=iso  O=OCT' - file '$file_name' - line $line_counter]";
					}
					$new_line_data['i=iso  O=OCT'] = $procure_freezing_type;
					//procure_origin_of_slice
					$procure_origin_of_slice = '';
					switch($new_line_data['quadrants']) {
						case 'LA':
						case 'LP':
						case 'RA':
						case 'RP':
							$procure_origin_of_slice = $new_line_data['quadrants'];
							break;
						case 'x':
						case '':
							break;
						default:
							$import_summary['Inventory - Tissue']['@@WARNING@@']["Wrong 'quadrants' value format"][] = "See patient '$patient_identifier' value [".$new_line_data['quadrants']."]. This value won't be migrated. [field 'quadrants' - file '$file_name' - line $line_counter]";
					}
					$new_line_data['quadrants'] = $procure_origin_of_slice;
					//procure_dimensions
					$procure_dimensions = '';
					if(strlen($new_line_data['blocs (cm2)'])) $new_line_data['blocs (cm2)'] .= ' (cm2)';
					$new_line_data['excel_line'] = $line_counter;
					//set data
					$psp_nbr_to_blocks_data['blocks'][$new_line_data['# patient']][] = $new_line_data;
				}
			}
		}
	}
	return $psp_nbr_to_blocks_data;
}

function loadInventory(&$XlsReader, $files_path, $file_name, $psp_nbr_to_blocks_data, &$psp_nbr_to_participant_id_and_patho) {
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
		$duplicated_participants_check = array();
		foreach($XlsReader->sheets[$sheets_nbr[$worksheet]]['cells'] as $line_counter => $new_line) {
			//$line_counter++;
			if($line_counter == 2) {
				$headers = $new_line;
			} else if($line_counter > 2){		
				$new_line_data = formatNewLineData($headers, $new_line);
				$participant_identifier = $new_line_data['# patient'];
				if(strlen($participant_identifier)) {
					if(preg_match('/^PS[0-9]P/', $participant_identifier)) {
						if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
							if(!in_array($participant_identifier, $duplicated_participants_check)) {
								$duplicated_participants_check[$participant_identifier] = $participant_identifier;
								$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
								//Load Tissue
								if($worksheet == 'V01') {
									loadTissue($participant_id, $participant_identifier, $psp_nbr_to_blocks_data, $psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#'], $file_name, $worksheet, $line_counter, $new_line_data);
									$psp_nbr_to_participant_id_and_patho[$participant_identifier]['prostate_weight_gr'] = getDecimal($new_line_data, 'poids de prostate entière (gramme)', 'Pathology Report', "$file_name ($worksheet)", $line_counter);
								}
								//Blood....
								loadBlood($participant_id, $participant_identifier, $file_name, $worksheet, $line_counter, $new_line_data);
								//Urine....
								loadUrine($participant_id, $participant_identifier, $file_name, $worksheet, $line_counter, $new_line_data);
							} else {
								$import_summary['Inventory - All']['@@ERROR@@']['Patient defined twice'][] = "The patient '$participant_identifier' has been listed twice for the same visit $worksheet. New line won't be migrated! [field '# patient' - file '$file_name' :: $worksheet - line: $line_counter]";		
							}
						} else {
							$import_summary['Inventory - All']['@@ERROR@@']['Patient Identification Unknown'][] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient inventory won't be migrated! [field '# patient' - file '$file_name' :: $worksheet - line: $line_counter]";
						}
					} else {
						$import_summary['Inventory - All']['@@WARNING@@']['No data to migrate'][] = "The line $line_counter seems to contain data that has not to be migrated! Data won't be migrated! [file '$file_name' :: $worksheet - line: $line_counter]";
					}
				}				
			}
		}
	}
	//Check unmigrated block data
	foreach($psp_nbr_to_blocks_data['blocks'] as $participant_identifier => $data) {
		$import_summary['Inventory - tissue']['@@ERROR@@']['Unmigrated blocks'][] = "The blocks of the patient '$participant_identifier' have not been migrated (patient defined into tisue file but not found into invenotry file). [file '$file_name' :: $worksheet - line: $line_counter && ".$psp_nbr_to_blocks_data['file_name']."]  ";
	}
}

function loadUrine($participant_id, $participant_identifier, $file_name, $worksheet, $line_counter, $new_line_data) {
	global $import_summary;
	global $controls;

	if($new_line_data['date prélèv. urine']) {
		//Collection
		$date_of_collection = getDateTimeAndAccuracy($new_line_data, 'date prélèv. urine', "hre de prélèvement urine", 'Inventory - Urine', "$file_name ($worksheet)", $line_counter);
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
		$storage_date = getDateTimeAndAccuracy($new_line_data, 'date prélèv. urine', "hre de congélation urine", 'Inventory - Urine', "$file_name ($worksheet)", $line_counter);
		$collection_aliquot_created = false;	
		//Urine
		$sample_data = array(
			'SampleMaster' => array(
				'collection_id' => $collection_id,
				'sample_control_id' => $controls['sample_aliquot_controls']['urine']['sample_control_id'],
				'initial_specimen_sample_type' => 'urine',
				'notes' => ''),
			'SpecimenDetail' => array(
				'reception_datetime' => $date_of_derivative_creation['datetime'],
				'reception_datetime_accuracy' => $date_of_derivative_creation['accuracy'],
				'procure_refrigeration_time' => getTime($new_line_data, 'hre de réfrigération urine', 'Inventory - Urine', "$file_name ($worksheet)", $line_counter)),
			'SampleDetail' => array());
		$urine_sample_master_id = createSample($sample_data, $controls['sample_aliquot_controls']['urine']['detail_tablename']);	
		//aliquot urine 'non clarifié'
		$initial_volume = getDecimal($new_line_data, 'vol URN-3 non clarifié', 'Inventory - Urine', "$file_name ($worksheet)", $line_counter);
		if($initial_volume) {
			//Storage data
			$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement URN-3'], 'urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
			$storage_coordinates = getPosition($participant_identifier, $new_line_data['position urn-3'], $new_line_data['bte rangement URN-3'], 'urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
			//Create aliquot
			$aliquot_data = array(
				'AliquotMaster' => array(
					'collection_id' => $collection_id,
					'sample_master_id' => $urine_sample_master_id,
					'aliquot_control_id' => $controls['sample_aliquot_controls']['urine']['aliquots']['cup']['aliquot_control_id'],
					'barcode' => "$participant_identifier $worksheet -URN3",
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
			customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['urine']['aliquots']['cup']['detail_tablename'], __FILE__, __LINE__, true);
			$collection_aliquot_created = true;
		} else if(str_replace('x','',$new_line_data['bte rangement URN-3']) || str_replace('x','',$new_line_data['position urn-3'])) {
			$import_summary['Inventory - Urine']['@@WARNING@@']["No clarified urine volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -URN3 is empty but a storage information is set (".$new_line_data['bte rangement URN-3']." : ".$new_line_data['position urn-3']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		//Centrifuged urine
		$urine_aspect = '';
		$procure_other_aspect_after_refrigeration = '';
		switch(str_replace('x', '', $new_line_data['urine trouble après frigo'])) {
			case 'oui':
				$urine_aspect = 'turbidity';
				break;
			case 'non':
			case 'nnon':
				$urine_aspect = 'clear';
				break;
			case '';
				break;
			default:
				$urine_aspect = 'other';
				$procure_other_aspect_after_refrigeration = $new_line_data['urine trouble après frigo'];
		}
		$procure_chuq_pellet = '';
		switch(str_replace('x', '', $new_line_data['urine culot'])) {
			case 'oui':
				$procure_chuq_pellet = 'y';
				break;
			case 'non':
			case 'nnon':
				$procure_chuq_pellet = 'n';
				break;
			case '';
				break;
			default:
				$import_summary['Inventory - Urine']['@@WARNING@@']["Unknown pellet value"][] = "Pellet value '".$new_line_data['urine culot']."' is not supported. Value won't be migrated. See $participant_identifier. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		$centrifuged_aliquots_created = false;
		//... && clarified aliquots
		if(strlen(str_replace('x','',$new_line_data['URN-1 vol. ml']))) {
			$sample_data = array(
				'SampleMaster' => array(
					'collection_id' => $collection_id,
					'sample_control_id' => $controls['sample_aliquot_controls']['centrifuged urine']['sample_control_id'],
					'initial_specimen_sample_type' => 'urine',
					'initial_specimen_sample_id' => $urine_sample_master_id,
					'parent_sample_type' => 'urine',
					'parent_id' => $urine_sample_master_id,
					'notes' => ''),
				'DerivativeDetail' => array(
					'creation_datetime' => $date_of_derivative_creation['datetime'],
					'creation_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
				'SampleDetail' => array(
					'procure_aspect_after_refrigeration' => $urine_aspect,
					'procure_other_aspect_after_refrigeration' => $procure_other_aspect_after_refrigeration,
					'procure_chuq_pellet' => $procure_chuq_pellet,
					'procure_chuq_concentrated' => 'n'));
			$derivative_sample_master_id = createSample($sample_data, $controls['sample_aliquot_controls']['centrifuged urine']['detail_tablename']);
			$created_aliquot = false;
			for($id=1;$id<3;$id++){
				$initial_volume = getDecimal($new_line_data, 'URN-'.$id.' vol. ml', 'Inventory - Urine', "$file_name ($worksheet)", $line_counter);
				if($initial_volume) {
					//Storage data
					$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement URN-'.$id], 'urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
					$storage_coordinates = getPosition($participant_identifier, $new_line_data['position urn-'.$id], $new_line_data['bte rangement URN-'.$id], 'urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
					//Create aliquot
					$aliquot_data = array(
						'AliquotMaster' => array(
							'collection_id' => $collection_id,
							'sample_master_id' => $derivative_sample_master_id,
							'aliquot_control_id' => $controls['sample_aliquot_controls']['centrifuged urine']['aliquots']['tube']['aliquot_control_id'],
							'barcode' => "$participant_identifier $worksheet -URN".$id,
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
					customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['centrifuged urine']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
					$created_aliquot = true;
					$centrifuged_aliquots_created = true;
					$collection_aliquot_created = true;
				} else if(str_replace('x','',$new_line_data['bte rangement URN-'.$id]) || str_replace('x','',$new_line_data['position urn-'.$id])) {
					$import_summary['Inventory - Urine']['@@WARNING@@']["No centrifuged & clarified urine volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -URN".$id." is empty but a storage information is set (".$new_line_data['bte rangement URN-'.$id]." : ".$new_line_data['position urn-'.$id]."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
				}
			}
			if(!$created_aliquot) {
				$import_summary['Inventory - Urine']['@@WARNING@@']["Created a centifugated & clarified urine sample with no aliquot"][] = "Please confirm. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
			}
		} else if(str_replace('x','',$new_line_data['bte rangement URN-1']) || str_replace('x','',$new_line_data['position urn-1'])) {
			$import_summary['Inventory - Urine']['@@WARNING@@']["No centrifuged & clarified urine volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -URN1 is empty but a storage information is set (".$new_line_data['bte rangement URN-1']." : ".$new_line_data['position urn-1']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		//... && concentrated aliquots
		if(strlen(str_replace('x','',$new_line_data['vol URC-1']))) {
			$sample_data = array(
				'SampleMaster' => array(
					'collection_id' => $collection_id,
					'sample_control_id' => $controls['sample_aliquot_controls']['centrifuged urine']['sample_control_id'],
					'initial_specimen_sample_type' => 'urine',
					'initial_specimen_sample_id' => $urine_sample_master_id,
					'parent_sample_type' => 'urine',
					'parent_id' => $urine_sample_master_id,
					'notes' => ''),
				'DerivativeDetail' => array(
					'creation_datetime' => $date_of_derivative_creation['datetime'],
					'creation_datetime_accuracy' => $date_of_derivative_creation['accuracy']),
				'SampleDetail' => array(
					'procure_aspect_after_refrigeration' => $urine_aspect,
					'procure_other_aspect_after_refrigeration' => $procure_other_aspect_after_refrigeration,
					'procure_chuq_pellet' => $procure_chuq_pellet,
					'procure_chuq_concentrated' => 'y',
					'procure_chuq_concentration_ratio' => preg_match('/^x$/', $new_line_data['urine concentrée ratio conc.'])? '' : $new_line_data['urine concentrée ratio conc.']));
			$derivative_sample_master_id = createSample($sample_data, $controls['sample_aliquot_controls']['centrifuged urine']['detail_tablename']);
			$initial_volume = getDecimal($new_line_data, 'vol URC-1', 'Inventory - Urine', "$file_name ($worksheet)", $line_counter);
			if($initial_volume) {
				//Storage data
				$storage_master_id = getStorageMasterId($participant_identifier, $new_line_data['bte rangement urine concentrée'], 'concentrated urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
				$storage_coordinates = getPosition($participant_identifier, $new_line_data['positio urine concentrée dans bte rangement'], $new_line_data['bte rangement urine concentrée'], 'concentrated urine', 'Inventory - Urine', $file_name, $worksheet, $line_counter);
				//Create aliquot
				$aliquot_data = array(
					'AliquotMaster' => array(
						'collection_id' => $collection_id,
						'sample_master_id' => $derivative_sample_master_id,
						'aliquot_control_id' => $controls['sample_aliquot_controls']['centrifuged urine']['aliquots']['tube']['aliquot_control_id'],
						'barcode' => "$participant_identifier $worksheet -URC1",
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
				customInsert($aliquot_data['AliquotDetail'], $controls['sample_aliquot_controls']['centrifuged urine']['aliquots']['tube']['detail_tablename'], __FILE__, __LINE__, true);
				$centrifuged_aliquots_created = true;
				$collection_aliquot_created = true;
			} else {
				if(str_replace('x','',$new_line_data['bte rangement urine concentrée']) || str_replace('x','',$new_line_data['positio urine concentrée dans bte rangement'])) {
					$import_summary['Inventory - Urine']['@@WARNING@@']["No concentrated urine volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -URC1 is empty but a storage information is set (".$new_line_data['bte rangement urine concentrée']." : ".$new_line_data['positio urine concentrée dans bte rangement']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
				}
				$import_summary['Inventory - Urine']['@@WARNING@@']["Created a centifugated & concentrated urine sample with no aliquot"][] = "Please confirm. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";	
			}
		} else {
			if(str_replace('x','',$new_line_data['bte rangement urine concentrée']) || str_replace('x','',$new_line_data['positio urine concentrée dans bte rangement'])) {
				$import_summary['Inventory - Urine']['@@WARNING@@']["No concentrated urine volume but storage data set"][] = "Volume of tube $participant_identifier $worksheet -URC1 is empty but a storage information is set (".$new_line_data['bte rangement urine concentrée']." : ".$new_line_data['positio urine concentrée dans bte rangement']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
			}
			if(strlen(str_replace('x','',$new_line_data['urine concentrée ratio conc.']))) {
				$import_summary['Inventory - Urine']['@@WARNING@@']["No concentrated urine volume but ratio set"][] = "Volume of tube $participant_identifier $worksheet -URC1 is empty but a ratio information is set (".$new_line_data['urine concentrée ratio conc.']."). Tube won't be created. Please confirm. [file '$file_name :: $worksheet', line : $line_counter']";
			}
		}
		// *** Final Control ***
		if(!$centrifuged_aliquots_created && strlen($urine_aspect.$procure_chuq_pellet)) {
			$import_summary['Inventory - Urine']['@@WARNING@@']["Centrifugated urine aspect and pellet data set but no aliquot created"][] = "Please confirm. See patient $participant_identifier. [file '$file_name :: $worksheet', line : $line_counter']";
		}
		if(!$collection_aliquot_created) {
			$import_summary['Inventory - Urine']['@@WARNING@@']["Collection date set but no aliquot created"][] = "See patient $participant_identifier. A collection was created (based on date) but no aliquot is defined into excel file. [file '$file_name :: $worksheet', line : $line_counter']";
		}
	}  else {
		if(str_replace('x','', $new_line_data['URN-1 vol. ml']) || str_replace('x','', $new_line_data['vol URN-3 non clarifié']) || str_replace('x','', $new_line_data['vol URC-1'])) {
			$import_summary['Inventory - Urine']['@@WARNING@@']["No collection date but urine samples defined"][] = "See patient '$participant_identifier'. No collection has been created but utine tubes seam to be banked. Please confirm and create missing collection and samples. [file '$file_name :: $worksheet', line : $line_counter']";
		}
	}
}

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
	
function loadTissue($participant_id, $participant_identifier, &$psp_nbr_to_blocks_data, $patho_nbr, $file_name, $worksheet, $line_counter, $new_line_data) {
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
	
	$patient_block_data = array();
	if(array_key_exists($participant_identifier, $psp_nbr_to_blocks_data['blocks'])) {
		$patient_block_data = $psp_nbr_to_blocks_data['blocks'][$participant_identifier];
		unset($psp_nbr_to_blocks_data['blocks'][$participant_identifier]);
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
		
		//*** TISSUE ALIQUOTS **
		
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
		//Create block based on tissue size excel file
		$block_created = false;
		//$duplicated_label_check = array();
		foreach($patient_block_data as $new_block) {
			//Note all value of $new_block from file 'tissue size' already checked in previous function loadBlock()
			$block_created = true;
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
			$storage_master_id = getStorageMasterId($participant_identifier, $new_block['boîte'], 'tissue', 'Inventory - Tissue', $psp_nbr_to_blocks_data['file_name'], '', $new_block['excel_line']);
			$storage_coordinates = getPosition($participant_identifier, $new_block['division'], $new_block['boîte'], 'tissue', 'Inventory - Tissue', $psp_nbr_to_blocks_data['file_name'], '', $new_block['excel_line']);
			//Create aliquot	
			$aliquot_data = array(
				'AliquotMaster' => array(
					'collection_id' => $collection_id,
					'sample_master_id' => $sample_master_id,
					'aliquot_control_id' => $tissue_sample_controls['aliquots']['block']['aliquot_control_id'],
					'barcode' => "$participant_identifier V01 -".$new_block['label'],
					'in_stock' => 'yes - available',
					'initial_volume' => null,
					'current_volume' => null,
					'use_counter' => '0',
					'storage_datetime' => $storage_date,
					'storage_datetime_accuracy' => $storage_date_accuracy,
					'storage_master_id' => $storage_master_id,
					'storage_coord_x' => $storage_coordinates['x'],
					'storage_coord_y' => $storage_coordinates['y']),
				'AliquotDetail' => array(
					'block_type' => 'frozen',
					'procure_freezing_type' => $new_block['i=iso  O=OCT'],
					'procure_origin_of_slice' => $new_block['quadrants'],
					'procure_dimensions' => $new_block['blocs (cm2)'],
					'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn));
			$aliquot_data['AliquotDetail']['aliquot_master_id'] = customInsert($aliquot_data['AliquotMaster'], 'aliquot_masters', __FILE__, __LINE__, false);
			customInsert($aliquot_data['AliquotDetail'], $tissue_sample_controls['aliquots']['block']['detail_tablename'], __FILE__, __LINE__, true);
		}
		if(!$block_created) {
			$import_summary['Inventory - Tissue']['@@WARNING@@']["No Block defined for a patient tissue collection"][] = "See patient '$participant_identifier'. A tissue sample has been created but no block is defined into tissue size file. No aliquot will be created. [file '".$psp_nbr_to_blocks_data['file_name']."']";
		}
	} else if(!empty($patient_block_data)) {
		$import_summary['Inventory - Tissue']['@@ERROR@@']["No collection created but tissue blocks defined in tissue size file"][] = "See patient '$participant_identifier'. No tissue collection has been created but blocks are defined into tissue size file. No aliquot,sample and collection will be created. [file '".$psp_nbr_to_blocks_data['file_name']."']";
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
		switch($sample_type) {
			case 'tissue':
				return 'tissue-'.$excel_storage_label;
			case 'serum':
			case 'plasma':
			case 'pbmc':
			case 'concentrated urine':
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
		/*
		if(!array_key_exists($storage_type, $controls['storage_controls']))  die('ERR 2387 628763287.3 ');
		$storage_controls_data = $controls['storage_controls'][$storage_type];
		if(!empty($storage_controls_data['coord_x_type']) && !empty($storage_controls_data['coord_y_type'])) {
			//Both X & Y
			if($storage_controls_data['coord_x_type'] == 'integer' && $storage_controls_data['coord_y_type'] == 'alphabetical') {
				if(preg_match('/^([A-Z]+)([0-9]+)$/', $excel_postions, $matches)) {
					$coord_x = $matches[2];
					$coord_y = $matches[1];
					if(!preg_match('/^[0-9]+$/', $coord_x) || $coord_x < 1 || $coord_x > $storage_controls_data['coord_x_size']) {
						$import_summary[$data_type]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box is wrong. No position will be set. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter] ERR#3 ";
						return array('x'=>null, 'y'=>null);
					} else if(!in_array($coord_y, array_slice(range('A', 'Z'), 0, $storage_controls_data['coord_y_size']))) {
						$import_summary[$data_type]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box is wrong. No position will be set. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter] ERR#4 ";
						return array('x'=>null, 'y'=>null);
					} else {
						return array('x'=>$coord_x, 'y'=>$coord_y);
					}
				} else {
					$import_summary[$data_type]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box is wrong. No position will be set. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter] ERR#1";
					return array('x'=>null, 'y'=>null);
				}
			} else {
				//Not supported
				die('ERR28738237w not supported');
			}
		} else if(!empty($storage_controls_data['coord_x_type']) && empty($storage_controls_data['coord_y_type'])) {
			//Just X
			if($storage_controls_data['coord_x_type'] == 'integer') {
				if(!preg_match('/^[0-9]+$/', $excel_postions) || $excel_postions < 1 || $excel_postions > $storage_controls_data['coord_x_size']) {
					$import_summary[$data_type]['@@ERROR@@']["Storage position format error"][] = "The format of the position [$excel_postions] for $sample_type box is wrong. No position will be set. See patient $participant_identifier. [file '$file_name' :: $worksheet - line: $line_counter] ERR#2 ";
					return array('x'=>null, 'y'=>null);
				} else {
					return array('x'=>$excel_postions, 'y'=>null);
				}					
			} else {
				//Not supported
				die('ERR28738237e not supported');
			}
		} else {
			//Not supported
			die('ERR287382378 not supported');
		}
		*/
	}
	return $positions;
}

?>