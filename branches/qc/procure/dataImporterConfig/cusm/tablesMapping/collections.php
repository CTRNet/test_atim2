<?php

function loadCollections() {
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	Config::$participant_collections = array();
	Config::$next_sample_code = 0;
	
	// Load data from : Données clinico-pathologiques
	
	if(!array_key_exists(utf8_decode('Données clinico-pathologiques'), $sheets_nbr)) die("ERROR: Worksheet Tissus Disponible is missing!\n");
	
	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('Données clinico-pathologiques')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Code du Patient'];
			if(isset(Config::$participant_collections[$patient_identification])) die('ERR 890300239 Patient collections already set for patient '.$patient_identification);
			if(!strlen($new_line_data['Date de la chirurgie'])) {
				if(strlen($new_line_data['Chirurgien']) || strlen($new_line_data['Prostate::poids (g)'])) {
					Config::$summary_msg['Tissue V01 Patho']['@@WARNING@@']['No date but surgery data'][] = "Suregry data with no surgery date for partient '$patient_identification'. No tissue collection will be created. See line: $line_counter";
				}
			} else {
				$collection_datetime = "''";
				$collection_datetime_accuracy = "''";
				$collection_date_data = getDateAndAccuracy($new_line_data['Date de la chirurgie'], 'Tissue V01 Patho', 'Date de la chirurgie', $line_counter);
				if($collection_date_data) {
					$collection_datetime = $collection_date_data['date'];
					$collection_datetime_accuracy = str_replace('c','h',$collection_date_data['accuracy']);
				}
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime] = array(
					'Collection' => array(
						'participant_id' => '',
						'procure_visit' => 'V01',
						'procure_patient_identity_verified' => '1',
						'collection_datetime' => $collection_datetime,
						'collection_datetime_accuracy' => $collection_datetime_accuracy,
						'collection_notes' => $new_line_data['Commentaires du pathologiste']),
					'Specimens' => array(
						array(
							'***tmp_sample_type***' => 'tissue',
							'SampleMaster' => array(),
							'SampleDetail' => array('procure_surgeon_name' => $new_line_data['Chirurgien']),
							'SpecimenDetail' => array('reception_datetime' => $collection_datetime,	'reception_datetime_accuracy' => $collection_datetime_accuracy),
							'Derivatives' => array(),
							'Aliquots' => array()
						)
					)
				);
			}
		}
	}
	
	// Load data from : V01 F10 à F15
	
	if(!array_key_exists(utf8_decode('V01 F10 à F15'), $sheets_nbr)) die("ERROR: V01 F10 à F15!\n");
	
	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('V01 F10 à F15')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Identification'];
			if($new_line_data['Date de la visite'] != 'V01') die('ERR 8949944 Tissue collection visit error '.$patient_identification);
			if(strlen($new_line_data['Date de la chirurgie'])) {
				if(!isset(Config::$participant_collections[$patient_identification]['V01'])) die('ERR 89922228344 Patient not defined in patho data '.$patient_identification);
				$collection_datetime = "''";
				$collection_datetime_accuracy = "''";
				$collection_date_data = getDateAndAccuracy($new_line_data['Date de la chirurgie'], 'Tissue V01', 'Date de la visite', $line_counter);
				if($collection_date_data) {
					$collection_datetime = $collection_date_data['date'];
					$collection_datetime_accuracy = str_replace('c','h',$collection_date_data['accuracy']);
				}
				$tmp_keys = array_keys(Config::$participant_collections[$patient_identification]['V01']);
				$collection_datetime_from_previous_worksheet = $tmp_keys[0];
				if($collection_datetime_from_previous_worksheet != $collection_datetime) Config::$summary_msg['Tissue V01']['@@WARNING@@']['Tissue collection date conflict'][] = "Tissue collection date conflict between the 2 worksheets {'Données clinico-pathologiques' = $collection_datetime_from_previous_worksheet} & {'V01 F10 à F15' = $collection_datetime}. Migration will used $collection_datetime_from_previous_worksheet as tissue collection datetime. See patient '$patient_identification' line: $line_counter";
				$collection_datetime = $collection_datetime_from_previous_worksheet;
				$procure_number_of_slides_collected_for_procure = $new_line_data['Nombre de tranches prélevées pour PROCURE'];
				$time_spent_collection_to_freezing_end_mn = $new_line_data["Temps écoulé entre sortie de l'abdomen et congélation (min)"];
				if(!preg_match('/^([0-9]*)$/', $procure_number_of_slides_collected_for_procure)) {
					Config::$summary_msg['Tissue V01']['@@WARNING@@']['Nbr of collected slides'][] = "Number of slides collected for procure is not an integer. See patient '$patient_identification' line: $line_counter";
					$procure_number_of_slides_collected_for_procure = '';
				}
				if(!preg_match('/^([0-9]*)$/', $time_spent_collection_to_freezing_end_mn)) {
					Config::$summary_msg['Tissue V01']['@@WARNING@@']['Time spent : collection to freezing'][] = "Spent time from collection to freezing is not an integer. See patient '$patient_identification' line: $line_counter";
					$time_spent_collection_to_freezing_end_mn = '';
				}
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime]['Specimens'][0]['SampleDetail']['procure_number_of_slides_collected_for_procure'] = $procure_number_of_slides_collected_for_procure;
				$new_aliquots = array();
				for($slide_nbr=1;$slide_nbr<9;$slide_nbr++) {
					$procure_origin_of_slice = $new_line_data["FRZ$slide_nbr::Origine de la tranche"];
					if(!in_array($procure_origin_of_slice, array('RP','RA','LP','LA', ''))) {
						Config::$summary_msg['Tissue V01']['@@WARNING@@']['Origin of slice'][] = "Origin of slice '$procure_origin_of_slice' is not supported. See patient '$patient_identification' line: $line_counter";
						$procure_origin_of_slice = '';
					}
					$new_aliquots[] = array(
						'***aliquot_type***' => 'block',
						'AliquotMaster' => array(
							'barcode' => "$patient_identification V01 -FRZ$slide_nbr",
							'in_stock' => 'yes - available',
							'storage_datetime' => "''",
							'storage_datetime_accuracy'	=> "''"),
						'AliquotDetail' => array(
							'procure_dimensions' => $new_line_data["FRZ$slide_nbr::Dimensions (cm x cm x cm)"], 
							'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn,
//TODO							'procure_block_classification' => $procure_block_classification, $new_line_data["FRZ$slide_nbr::C, NC, ND"]
							'procure_origin_of_slice' => $procure_origin_of_slice
						)
					);
				}
				for($slide_nbr=1;$slide_nbr<9;$slide_nbr++) {
					$procure_origin_of_slice = $new_line_data["PAR$slide_nbr::Origine du bloc"];
					if(!in_array($procure_origin_of_slice, array('RP','RA','LP','LA', ''))) {
						Config::$summary_msg['Tissue V01']['@@WARNING@@']['Origin of slice'][] = "Origin of slice '$procure_origin_of_slice' is not supported. See patient '$patient_identification' line: $line_counter";
						$procure_origin_of_slice = '';
					}
					$new_aliquots[] = array(
							'***aliquot_type***' => 'block',
							'AliquotMaster' => array(
									'barcode' => "$patient_identification V01 -PAR$slide_nbr",
									'in_stock' => 'yes - available',
									'storage_datetime' => "''",
									'storage_datetime_accuracy'	=> "''"),
							'AliquotDetail' => array(
									'procure_dimensions' => $new_line_data["PAR$slide_nbr::Tranche congelée correspondante"],
									'time_spent_collection_to_freezing_end_mn' => $time_spent_collection_to_freezing_end_mn,
									//TODO							'procure_block_classification' => $procure_block_classification, $new_line_data["PAR$slide_nbr::C, NC, ND"]
									'procure_origin_of_slice' => $procure_origin_of_slice
							)
					);
				}				
				Config::$participant_collections[$patient_identification]['V01'][$collection_datetime]['Specimens'][0]['Aliquots'] = $new_aliquots;
			} else {
				Config::$summary_msg['Tissue V01']['@@MESSAGE@@']['No date'][] = "No suregry date for patient $patient_identification. No tissue collection will be created. See line: $line_counter";
				unset(Config::$participant_collections[$patient_identification]);
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	pr(Config::$summary_msg['Tissue V01 Patho']);
	pr(Config::$summary_msg['Tissue V01']);
	
	pr(Config::$participant_collections);
	exit;
}

function customArrayCombineAndUtf8Encode($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

//=========================================================================================================
// Collections Creation
//=========================================================================================================

function addCollections() {
	//TODO Veut on créer des realiquotés pour les shipped?

	global $next_sample_code;
	global $next_aliquot_code;

	$query = "SELECT MAX(CAST(sample_code AS UNSIGNED)) AS last_sample_code from sample_masters;";
	$results = mysqli_query(Config::$db_connection, $query) or die("addCollections [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if(!isset($row['last_sample_code'])) die("ERR 889dadadad494094");
	$next_sample_code = $row['last_sample_code'] + 1;

	$query = "SELECT MAX(CAST(barcode AS UNSIGNED)) AS last_aliquot_code from aliquot_masters;";
	$results = mysqli_query(Config::$db_connection, $query) or die("addCollections [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
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
				$collection_date = customGetFormatedDate($line_data['Date collecte'], 'TISSU', $line_counter);
				$collection_date_accuracy = 'c';
			} else {
				Config::$summary_msg['TISSU']['@@WARNING@@']['Missing collection date'][] = "... [line: $line_counter]";
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
								'chus_collection_date' => "'$collection_date'",
								'chus_collection_date_accuracy' => "'$collection_date_accuracy'"),
						'inventory' => array());
			}
				
			// Tissue
				
			$line_data['Heure Réception'] = str_replace(array('ND','?',' ', '-'),array('','','',''),$line_data['Heure Réception']);
			if(!empty($line_data['Heure Réception']) && empty($collection_date)) {
				Config::$summary_msg['TISSU']['@@ERROR@@']['Reception time defined but no collection date'][] = "Reception date & time won't be imported! [line: $line_counter]";
				$line_data['Heure Réception'] = '';
			}
			if(!empty($line_data['Heure Réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure Réception'], $matches)) die('ERR  ['.$line_counter.'] fafasassa be sure cell custom format is h:mm ['.$line_data['Heure Réception'].']');
			$reception_datetime = (!empty($line_data['Heure Réception']))? $collection_date.' '.$line_data['Heure Réception'].':00' : (empty($collection_date)? '' : $collection_date.' 00:00:00');
			$reception_datetime_accuracy = (!empty($line_data['Heure Réception']))? 'c' : (empty($reception_datetime)? '' : 'h');
				
			$tissue_key = $reception_datetime.$line_data['Échantillon'];
			if(!isset($collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key])) {
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_masters'] = array('notes' => "''");
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['tissue'][$tissue_key]['specimen_details'] = array(
						'chus_collection_datetime' => empty($collection_date)? "''" : "'$collection_date 00:00:00'",
						'chus_collection_datetime_accuracy' =>  empty($collection_date)? "''" : "'h'",
						'reception_datetime' => "'$reception_datetime'",
						'reception_datetime_accuracy' => "'$reception_datetime_accuracy'");
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
				
			if(!empty($reception_datetime) && !empty($storage_datetime)) {
				$reception_datetime_tmp = str_replace(array(' ', ':', '-'), array('','',''), $reception_datetime);
				$storage_datetime_tmp = str_replace(array(' ', ':', '-'), array('','',''), $storage_datetime);
				if($storage_datetime_tmp < $reception_datetime_tmp) Config::$summary_msg['TISSU']['@@ERROR@@']['Collection & Storage Dates'][] = "Sotrage should be done after collection. Please check collection and storage date! [line: $line_counter]";
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
				$collection_date = customGetFormatedDate($line_data['Date Réception'], 'BLOOD', $line_counter);
				$collection_date_accuracy = 'c';
			}  else {
				Config::$summary_msg['BLOOD']['@@WARNING@@']['Missing collection date'][] = "... [line: $line_counter]";
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
								'chus_collection_date' => "'$collection_date'",
								'chus_collection_date_accuracy' => "'$collection_date_accuracy'"),
						'inventory' => array());
			}
				
			// Blood
				
			$line_data['Heure réception'] = str_replace(array('ND','?',' ', '-'),array('','','',''),$line_data['Heure réception']);
			if(!empty($line_data['Heure réception']) && empty($collection_date)) {
				Config::$summary_msg['BLOOD']['@@ERROR@@']['Reception time defined but no collection date'][] = "Reception date & time won't be imported! [line: $line_counter]";
				$line_data['Heure réception'] = '';
			}
			if(!empty($line_data['Heure réception']) && !preg_match('/^[0-9]{2}:[0-9]{2}$/', $line_data['Heure réception'], $matches)) die('ERR  ['.$line_counter.'] fafasassa be sure cell custom format is h:mm ['.$line_data['Heure réception'].']');
			$reception_datetime = (!empty($line_data['Heure réception']))? $collection_date.' '.$line_data['Heure réception'].':00' : (empty($collection_date)? '' : $collection_date.' 00:00:00');
			$reception_datetime_accuracy = (!empty($line_data['Heure réception']))? 'c' : (empty($reception_datetime)? '' : 'h');
				
			if(!isset($collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime])) {
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['sample_masters'] = array('notes' => "''");
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['sample_details'] = array();
				$collections_to_create[$collection_key]['inventory']['blood'][$reception_datetime]['specimen_details'] = array(
						'chus_collection_datetime' => empty($collection_date)? "''" : "'$collection_date 00:00:00'",
						'chus_collection_datetime_accuracy' =>  empty($collection_date)? "''" : "'h'",
						'reception_datetime' => "'$reception_datetime'",
						'reception_datetime_accuracy' => "'$reception_datetime_accuracy'");
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

			if(!empty($reception_datetime) && !empty($storage_datetime)) {
				$reception_datetime_tmp = str_replace(array(' ', ':', '-'), array('','',''), $reception_datetime);
				$storage_datetime_tmp = str_replace(array(' ', ':', '-'), array('','',''), $storage_datetime);
				if($storage_datetime_tmp < $reception_datetime_tmp) Config::$summary_msg['BLOOD']['@@ERROR@@']['Collection & Storage Dates'][] = "Sotrage should be done after collection. Please check collection and storage date! [line: $line_counter]";
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
									'initial_volume' => "'1'",
									'current_volume' => "'1'",
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

				$current_weight_per_aliquot = '';
				if(strlen($current_weight)) {
					$current_weight_per_aliquot = $current_weight/sizeof($aliquot_positions);
					if(sizeof($aliquot_positions) > 1) Config::$summary_msg['DNA']['@@MESSAGE@@']["Split current weight"][] = "Split current weight ($current_weight) in ".sizeof($aliquot_positions)." => ($current_weight_per_aliquot). Please confirm! [line: $line_counter]";
					if($current_weight_per_aliquot == '0.0') Config::$summary_msg['DNA']['@@ERROR@@']["Empty 'available' aliquot"][] = "The current weight of aliquot is equal to 0 but the status is still equal to 'yes - available'. Please confirm! [line: $line_counter]";
				}

				$current_volume_per_aliquot_ul = '';
				if(strlen($current_weight_per_aliquot) || strlen($concentration)) {
					if(!strlen($current_weight_per_aliquot) || !strlen($concentration)) {
						Config::$summary_msg['DNA']['@@ERROR@@']["Missing information to calculate volume"][] = "Either concentration or weight is missing to calculate volume! [line: $line_counter]";
					} else if(empty($concentration)) {
						die('ERR 789004 line '.$line_counter);
					} else {
						$current_volume_per_aliquot_ul = ($current_weight_per_aliquot/$concentration)*1000;
					}
				}

				foreach($aliquot_positions as $new_stored_aliquot) {
					$storage_master_id = getStorageId('dna', 'box100', $new_stored_aliquot['box_label']);
					$new_dna['aliquots'][] = array(
							'aliquot_masters' => array(
									'aliquot_label' => "'$aliquot_label'",
									'initial_volume' => "'$current_volume_per_aliquot_ul'",
									'current_volume' => "'$current_volume_per_aliquot_ul'",
									'in_stock' => "'yes - available'",
									'storage_master_id' => "'$storage_master_id'",
									'storage_datetime' => "''",
									'storage_datetime_accuracy' => "''",
									'storage_coord_x' => "'".$new_stored_aliquot['position']."'",
									'storage_coord_y' => "''"),
							'aliquot_details' => array(
									'chus_qc_ratio_260_280' => "'$ratio'",
									'concentration' => "'$concentration'",
									'concentration_unit' => (empty($concentration)? "''":"'ug/ml'"),
									'chum_current_weight_ug' => "'$current_weight_per_aliquot'"),
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

	$selection_label = str_replace(' ', '', $selection_label)."[BR/$aliquot_description]";
	if(strlen($selection_label) > 25) die('ERR 9949 9949 949 329 2 '.$selection_label);
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
		// treatment_master_id
		$tmp_date = $new_collection['collection']['chus_collection_date'];
		if(!empty($tmp_date) && isset(Config::$breast_surgery_id_from_participant_id[$new_collection['link']['participant_id']][$tmp_date])) {
			if(sizeof(Config::$breast_surgery_id_from_participant_id[$new_collection['link']['participant_id']][$tmp_date]) == 1) {
				$new_collection['link']['treatment_master_id'] = Config::$breast_surgery_id_from_participant_id[$new_collection['link']['participant_id']][$tmp_date][0];
			} else {
				Config::$summary_msg['COLLECTION']['@@WARNING@@']['2 surgeries same date'][] = "See participant_id = ".$new_collection['link']['participant_id'];
			}
		}


		// Create colleciton
		if(!isset($new_collection['collection'])) die('ERR 889940404023');
		if(!isset($new_collection['link'])) die('ERR 889940404023.3');
		$collection_id = customInsertChusRecord(array_merge($new_collection['collection'], $new_collection['link'], array('bank_id' => '1', 'collection_property' => "'participant collection'")), 'collections', false, true);

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









































	
function xxx(Model $m){
pr('postSurgeryRead : '.$m->values['Code du Patient']);	
	$data_to_record = false;
	$path_report_excel_fields = array(
		"Date de la chirurgie",
		"Chirurgien",
		"Prostate::poids (g)"
	);
	foreach($path_report_excel_fields as $field_to_test) {
		$field_to_test = utf8_decode($field_to_test);
		if(array_key_exists($field_to_test, $m->values) && strlen($m->values[$field_to_test])) {
			$data_to_record = true;
		}
	}	
	if(!$data_to_record) {
		Config::$summary_msg['Surgery']['@@MESSAGE@@']['No Surgery data recorded'][] = "For partient '".$m->values['Code du Patient']."'. See line: ".$m->line;
		return false;
	} 
	
	$m->values['Commentaires du pathologiste'] = utf8_encode($m->values['Commentaires du pathologiste']);
	
	$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("Date de la chirurgie")], 'Surgery', "Date de la chirurgie", $m->line);
	if($tmp_event_date) {
		$m->values['collection_datetime'] = $tmp_event_date['date'];
		$m->values['collection_datetime_accuracy'] = str_replace('c','h',$tmp_event_date['accuracy']);
	} else {
		$m->values['collection_datetime'] = "''";
		$m->values['collection_datetime_accuracy'] = "''";
	}	
		
	return true;
}

function yyy(Model $m){
	pr('addToCollection : '.$m->values['Code du Patient']);
return true;
}



function ttt(Model $m){
	Config::$next_sample_code++;
	
	$sample_master_data = array(
		'sample_code' => Config::$next_sample_code,
		'sample_control_id' => Config::$sample_aliquot_controls['tissue']['sample_control_id'],
		'collection_id' => $m->last_id,
		'initial_specimen_sample_type' => 'tissue');
	$sample_master_id = customInsertRecord($sample_master_data, 'sample_masters', false);
	
	$specimen_detail_data = array(
		'sample_master_id' => $sample_master_id,
		'reception_datetime' => $m->values['collection_datetime'],
		'reception_datetime_accuracy' => $m->values['collection_datetime_accuracy']);
	customInsertRecord($specimen_detail_data, 'specimen_details', true);
	
	$sample_detail_data = array(
		'sample_master_id' => $sample_master_id,
		'procure_surgeon_name' => utf8_encode($m->values['Chirurgien']));
	customInsertRecord($sample_detail_data, Config::$sample_aliquot_controls['tissue']['detail_tablename'], true);

}
