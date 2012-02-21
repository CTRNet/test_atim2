<?php
$pkey = "VOA Number";
$child = array();
$fields = array(
	"participant_id" => $pkey,
	"collection_id" => "#collection_id",
	"diagnosis_master_id" => "#diagnosis_master_id",
	"consent_master_id" => "#consent_master_id");

//see the Model class definition for more info
$model = new Model(1, $pkey, $child, false, "participant_id", $pkey, 'clinical_collection_links', $fields);

//we can then attach post read/write functions
$model->custom_data = array();

//adding this model to the config
Config::$models['SurgicalCollection'] = $model;

$model->post_read_function = 'postSurgicalCollectionRead';
$model->insert_condition_function = 'preSurgicalCollectionWrite';

function postSurgicalCollectionRead(Model $m){
	if(empty($m->values['Tissue Receipt::Paraffin Blocks']) && 
	empty($m->values['Tissue Receipt::Specimen Type 1']) && 
	empty($m->values['Tissue Receipt::Specimen Type 2']) && 
	empty($m->values['Tissue Receipt::Vials Frozen'])) {
		if(!empty($m->values['Tissue Receipt::Comments'])) {
			Config::$summary_msg['@@WARNING@@']['Tissue Receipt Comments #2'][] = 'Only Tissue Receipt::Comments is set. [line: '.$m->line.']';
		}
		return false;
	}
	
	return true;

}
function preSurgicalCollectionWrite(Model $m){
	$m->values['collection_id'] = createCollection($m, 'surgical');
	$m->values['diagnosis_master_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['collection_diagnosis_id'];;
	$m->values['consent_master_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['consent_id'];
	
	return true;
}

function createCollection(Model $m, $collection_type) {
		
	$initial_storage_date = null;
	if(!empty($m->values['Tissue Receipt::Final Storage Date'])) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$initial_storage_date = date("Y-m-d", $php_offset + (($m->values['Tissue Receipt::Final Storage Date'] - $xls_offset) * 86400));
	}
	
	// ** COLLECTION **
	
	$data_arr = array(
		"bank_id" => "1", 
		"ovcare_collection_type" => "'$collection_type'",
		"collection_notes" => "'".	Config::$current_patient_session_data['collection_additional_notes']."'",
		"collection_property" => "'participant collection'"
	);
	$collection_id = insertCollectionElement($data_arr, 'collections');
	
	switch($collection_type) {
		case 'pre-surgical':
		case 'post-surgical':
			
			// BLOOD
			
			$data_arr = array(
				"sample_code" 					=> "'tmp_".(Config::$sample_code_counter++)."'", 
				"sample_control_id"				=> Config::$sample_aliquot_controls['blood']['sample_control_id'], 
				"initial_specimen_sample_id"	=> "NULL", 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> $collection_id, 
				"parent_id"						=> "NULL",
				"notes"							=> "''" 
			);
			$blood_sample_master_id = insertCollectionElement($data_arr, 'sample_masters');
		
			$data_arr = array(
				"sample_master_id"	=> $blood_sample_master_id,
			);
			insertCollectionElement($data_arr, Config::$sample_aliquot_controls['blood']['detail_tablename'], true);
			insertCollectionElement($data_arr, 'specimen_details');
						
			// BLOOD Derivative
			
			$blood_derivatives = array();
			if(!empty($m->values['Tissue Receipt::Buffy Coat'])) $blood_derivatives[] = array('type' => 'blood cell', 'aliquot_nbr' => $m->values['Tissue Receipt::Buffy Coat']);
			if(!empty($m->values['Tissue Receipt::PreSurgical Serum'])) $blood_derivatives[] = array('type' => 'serum', 'aliquot_nbr' => $m->values['Tissue Receipt::PreSurgical Serum']);
			if(!empty($m->values['Tissue Receipt::PreSurgical Plasma'])) $blood_derivatives[] = array('type' => 'plasma', 'aliquot_nbr' => $m->values['Tissue Receipt::PreSurgical Plasma']);
			if(!empty($m->values['Tissue Receipt::PostSurgical Serum'])) $blood_derivatives[] = array('type' => 'serum', 'aliquot_nbr' => $m->values['Tissue Receipt::PostSurgical Serum']);

			$master_data_arr = array(
				"initial_specimen_sample_id"	=> $blood_sample_master_id, 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> $collection_id, 
				"parent_id"						=> $blood_sample_master_id,
				"parent_sample_type"			=> "'blood'"
			);
	
			if(!empty($blood_derivatives)) {
				foreach($blood_derivatives as $new_der) {
					if(preg_match('/^([0-9]+)$/', $new_der['aliquot_nbr'], $matches)) {
						$derivative_sample_master_id = insertCollectionElement(array_merge($master_data_arr, array('sample_code' => "'tmp_".(Config::$sample_code_counter++)."'", 'sample_control_id' => Config::$sample_aliquot_controls[$new_der['type']]['sample_control_id'])), 'sample_masters');
						insertCollectionElement(array("sample_master_id" => $derivative_sample_master_id), Config::$sample_aliquot_controls[$new_der['type']]['detail_tablename'], true);
						insertCollectionElement(array("sample_master_id" => $derivative_sample_master_id), 'derivative_details');
						createAliquot($collection_id, $derivative_sample_master_id, $new_der['type'], 'tube', $new_der['aliquot_nbr'], $initial_storage_date);
					} else {
						Config::$summary_msg['@@ERROR@@']['Blood Derivative #1'][] = 'The '.$new_der['type'].' is not a numerical value ('.$new_der['aliquot_nbr'].'). [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
					}
				}			
			} else {
				Config::$summary_msg['@@ERROR@@']['Blood Derivative #2'][] = 'No blood derivative has been created (check numerical value for buffy coat, serum and plasma). [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
			}
			
			break;
			
		case 'surgical':
			
			// TISSUE & ASCITE
			
			$specimens = array();
			if(!empty($m->values['Tissue Receipt::Specimen Type 1'])) $specimens[] = getTissueSourceAndLaterality($m->values['Tissue Receipt::Specimen Type 1']);
			if(!empty($m->values['Tissue Receipt::Specimen Type 2'])) $specimens[] = getTissueSourceAndLaterality($m->values['Tissue Receipt::Specimen Type 2']);
			if(empty($specimens)) $specimens[] = getTissueSourceAndLaterality();
			
			$comments = utf8_encode($m->values['Tissue Receipt::Comments']);
			$blocks_nbr = empty($m->values['Tissue Receipt::Paraffin Blocks'])? 0 : $m->values['Tissue Receipt::Paraffin Blocks'];
			$vials_nbr = empty($m->values['Tissue Receipt::Vials Frozen'])? 0 : $m->values['Tissue Receipt::Vials Frozen'];
			if(!preg_match('/^([0-9]*)$/', $blocks_nbr, $matches)) Config::$summary_msg['@@ERROR@@']['Blocks Nbr #1'][] = 'The number of blocks '.$blocks_nbr.' is not a numerical value. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
			if(!preg_match('/^([0-9]*)$/', $vials_nbr, $matches)) Config::$summary_msg['@@ERROR@@']['Vials Nbr #1'][] = 'The number of vials '.$vials_nbr.' is not a numerical value. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
			
			$sample_notes = '';
			if(sizeof($specimens) == 2) {
				Config::$summary_msg['@@WARNING@@']['Aliquot Creation #1'][] = 'Both Specimens 1 & 2 have been defined ['.$m->values['Tissue Receipt::Specimen Type 1'].' / '.$m->values['Tissue Receipt::Specimen Type 2'].']. The aliquots creation by migration process is too complexe. Information will be added to sample notes. Migration completion has to be done manually. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
				if(!empty($blocks_nbr)) $sample_notes .= "[Nbr of blocks = $blocks_nbr] ";
				if(!empty($vials_nbr)) $sample_notes .= "[Nbr of vials = $vials_nbr] ";
				$blocks_nbr = 0;
				$vials_nbr = 0;
			} else if($blocks_nbr+$vials_nbr == 0) {
				Config::$summary_msg['@@MESSAGE@@']['Aliquot Creation #2'][] = 'Sample has been created but no aliquot has been defined into file. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
			}
			$sample_notes .= $comments;
			
			foreach($specimens as $new_specimen) {
				switch($new_specimen['sample_type']) {
					case 'ascite':
						$data_arr = array(
							"sample_code" 					=> "'tmp_".(Config::$sample_code_counter++)."'", 
							"sample_control_id"				=> Config::$sample_aliquot_controls['ascite']['sample_control_id'], 
							"initial_specimen_sample_id"	=> "NULL", 
							"initial_specimen_sample_type"	=> "'ascite'",
							"collection_id"					=> $collection_id, 
							"parent_id"						=> "NULL",
							"notes"							=> (($new_specimen['source_precision'] == '***cell***')? "''" :"'$sample_notes'")
						);
						$ascite_sample_master_id = insertCollectionElement($data_arr, 'sample_masters');
						insertCollectionElement(array("sample_master_id"	=> $ascite_sample_master_id), Config::$sample_aliquot_controls['ascite']['detail_tablename'], true);
						insertCollectionElement(array("sample_master_id"	=> $ascite_sample_master_id), 'specimen_details');
						
						$aliquot_sample_master_id = $ascite_sample_master_id;
						$aliquot_sample_type = 'ascite';
						if($new_specimen['source_precision'] == '***cell***') {
							$master_data_arr = array(
								"sample_code" 					=> "'tmp_".(Config::$sample_code_counter++)."'", 
								"sample_control_id"				=> Config::$sample_aliquot_controls['ascite cell']['sample_control_id'], 
								"initial_specimen_sample_id"	=> $ascite_sample_master_id, 
								"initial_specimen_sample_type"	=> "'ascite'",
								"collection_id"					=> $collection_id, 
								"parent_id"						=> $ascite_sample_master_id,
								"parent_sample_type"			=> "'ascite'",
								"notes"							=> "'$sample_notes'" 
							);
	
							$ascite_cell_sample_master_id = insertCollectionElement($master_data_arr, 'sample_masters');
							insertCollectionElement(array("sample_master_id" => $ascite_cell_sample_master_id), Config::$sample_aliquot_controls['ascite cell']['detail_tablename'], true);
							insertCollectionElement(array("sample_master_id" => $ascite_cell_sample_master_id), 'derivative_details');
							
							$aliquot_sample_master_id = $ascite_cell_sample_master_id;
							$aliquot_sample_type = 'ascite cell';
							
							Config::$summary_msg['@@WARNING@@']['Special Derivative Creation #1'][] = 'An Ascite cell derivative has been created for ['.$m->values['Tissue Receipt::Specimen Type 1'].' / '.$m->values['Tissue Receipt::Specimen Type 2'].'].  [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
						} 
										
						createAliquot($collection_id, $aliquot_sample_master_id, $aliquot_sample_type, 'block', $blocks_nbr, $initial_storage_date);
						createAliquot($collection_id, $aliquot_sample_master_id, $aliquot_sample_type, 'tube', $vials_nbr, $initial_storage_date);
						
						break;
						
					case 'tissue':
						$data_arr = array(
							"sample_code" 					=> "'tmp_".(Config::$sample_code_counter++)."'", 
							"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'], 
							"initial_specimen_sample_id"	=> "NULL", 
							"initial_specimen_sample_type"	=> "'tissue'",
							"collection_id"					=> $collection_id, 
							"parent_id"						=> "NULL",
							"notes"							=> (($new_specimen['source_precision'] == '***culture***')? "''" : "'$sample_notes'") 
						);
						$tissue_sample_master_id = insertCollectionElement($data_arr, 'sample_masters');
						$data_arr = array(
							"sample_master_id"	=> $tissue_sample_master_id,
							"tissue_source" => "'".$new_specimen['source']."'",
							"ovcare_tissue_source_precision" => (($new_specimen['source_precision'] == '***culture***')? "''" : "'".$new_specimen['source_precision']."'"),
							"tissue_laterality" => "'".$new_specimen['laterality']."'"
						);
						insertCollectionElement($data_arr, Config::$sample_aliquot_controls['tissue']['detail_tablename'], true);
						insertCollectionElement(array("sample_master_id"	=> $tissue_sample_master_id), 'specimen_details');
						
						if($new_specimen['source_precision'] != '***culture***') {
							createAliquot($collection_id, $tissue_sample_master_id, 'tissue', 'block', $blocks_nbr, $initial_storage_date);
							createAliquot($collection_id, $tissue_sample_master_id, 'tissue', 'tube', $vials_nbr, $initial_storage_date);
						
						} else {
							$master_data_arr = array(
								"sample_code" 					=> "'tmp_".(Config::$sample_code_counter++)."'", 
								"sample_control_id"				=> Config::$sample_aliquot_controls['cell culture']['sample_control_id'], 
								"initial_specimen_sample_id"	=> $tissue_sample_master_id, 
								"initial_specimen_sample_type"	=> "'tissue'",
								"collection_id"					=> $collection_id, 
								"parent_id"						=> $tissue_sample_master_id,
								"parent_sample_type"			=> "'tissue'",
								"notes"							=> "'$sample_notes'" 
							);
	
							$cell_culture_sample_master_id = insertCollectionElement($master_data_arr, 'sample_masters');
							insertCollectionElement(array("sample_master_id" => $cell_culture_sample_master_id), Config::$sample_aliquot_controls['cell culture']['detail_tablename'], true);
							insertCollectionElement(array("sample_master_id" => $cell_culture_sample_master_id), 'derivative_details');
							
							Config::$summary_msg['@@WARNING@@']['Special Derivative Creation #1'][] = 'An Tissue cell culture derivative has been created for ['.$m->values['Tissue Receipt::Specimen Type 1'].' / '.$m->values['Tissue Receipt::Specimen Type 2'].'].  [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
						}
												
						break;
						
					default:
						die('ERR:9947893');
				}
			}

			break;
		
		default:
			die("Collection Type Unknown (ERR993789120): ". $collection_type);		
	}

	return  $collection_id;
}
	
function getTissueSourceAndLaterality($specimen_type = '') {
	$specimen_type_lowercase = strtolower($specimen_type);
	$specimen_type_lowercase = str_replace('eight ovary','right ovary',$specimen_type_lowercase);

	$specimen_data = array('sample_type' => 'tissue',
			'source' => '', 
			'source_precision' => $specimen_type, 
			'laterality' => '');
	
	$laterality_counter = 0;
	if(preg_match('/(right)/', $specimen_type_lowercase, $matches)) $laterality_counter += 1;
	if(preg_match('/(left)/', $specimen_type_lowercase, $matches)) $laterality_counter += 2;
	if(preg_match('/(bilateral)/', $specimen_type_lowercase, $matches)) $laterality_counter += 3;
	$specimen_data['laterality'] = str_replace(array('0', '1', '2', '3', '4', '5', '6'), array('','right','left', 'bilateral', 'bilateral', 'bilateral', 'bilateral'), $laterality_counter);
	
	if(empty($specimen_type_lowercase)) return $specimen_data;
	
	switch($specimen_type_lowercase) {
		case 'ascites cells':
		case 'acites':
		case 'ascites':
			$specimen_data['sample_type'] = 'ascite';	
			$specimen_data['source'] = 'ascite';
			$specimen_data['source_precision'] = ($specimen_type_lowercase == 'ascites cells')? '***cell***':'';
			break;
			
		case 'endomertrium':
		case 'endometrioid':
		case 'endometrium':
		case 'endomtrium':
		case 'normal endometrium':
			$specimen_data['source'] = 'endometrium';	
			break;
			
		case 'omental biopsy':
		case 'omentum':
		case 'ommentum':
			$specimen_data['source'] = 'omentum';	
			break;
			
		case 'right pelvic mass':
		case 'pelvic mass':
		case 'pelvic tumour':
			$specimen_data['source'] = 'pelvic mass';	
			break;
			
		case 'ovarian cyst':
		case 'ovarian mass':
		case 'ovarian scapings':
		case 'ovarian scrapings':
		case 'ovary':
		case 'ovary (large)':
		case 'ovary (non-specific)':
		case 'ovary (small)':
		case 'presumed left ovary':
		case 'recuurent ovarian tumour':
		case 'right & left ovaries':
		case 'right ovarian cyst':
		case 'right ovarian tumour':
		case 'right ovary':
		case 'right ovary & left ovary':
		case 'right ovcary':
		case 'bilateral ovaries':
		case 'bilateral ovary':
		case 'right ovary':
		case 'left & right ovary':
		case 'left ovarian mass':
		case 'left ovary':
			$specimen_data['source'] = 'ovary';	
			break;
			
		case 'right fallopian tube':
		case 'right fallopin tube':
		case 'fallopian tube':
		case 'fallopin tube':
		case 'left fallopian tube':
		case 'left fallopin tube':
			$specimen_data['source'] = 'fallopian tube';	
			break;
			
		case 'right fallopian tube-culture':
			$specimen_data['sample_type'] = 'tissue';	
			$specimen_data['source'] = 'fallopian tube';
			$specimen_data['source_precision'] = '***culture***';
			break;
			
		case 'uterine fibroid':
		case 'uterine mass':
		case 'uterus':
			$specimen_data['source'] = 'uterus';	
			break;
		
		case 'left ovary & fallopian tube':
		case 'right ovary and tube':
		case 'right ovary & fallopian tube':
		case 'ovary & tube':
		case 'pelvic mass - ovary':
		case 'ovary / pelvic mass':
		case 'omentum/pelvic mass':
			$specimen_data['source'] = 'other';
			break;
			
		default:
			$specimen_data['source'] = 'other';
			break;
	}		
	
	//Precision clean up
	
	$source_precision = $specimen_data['source_precision'];
	$source_precision = preg_replace("/".$specimen_data['source']."/i", '', $source_precision);
	$source_precision = preg_replace("/".$specimen_data['laterality']."/i", '', $source_precision);
	$source_precision = str_replace(' ', '', $source_precision);
	if(empty($source_precision)) $specimen_data['source_precision'] = '';
	
	Config::$tissue_source_and_laterality[$specimen_type_lowercase] = $specimen_data;
				
	return $specimen_data;		
}

function createAliquot($collection_id, $sample_master_id, $sample_type, $aliquot_type, $nbr_of_aliquots, $initial_storage_date = null) {
	if(empty($nbr_of_aliquots)) return;
	if(!is_numeric($nbr_of_aliquots)) die('ERR998738: Nbr of Aliquot should be numeric'.$nbr_of_aliquots);
	if(!isset(Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type])) {
		pr(Config::$sample_aliquot_controls);
		die('Missing Aliquot Control : '.$sample_type.' - '.$aliquot_type);
	}
	$aliquot_control_id = Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['aliquot_control_id'];
	$detail_table = Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['detail_tablename'];
	
	$master_insert = array(
		"aliquot_control_id" => $aliquot_control_id,
		"in_stock" => "'yes - available'",
		"collection_id" => $collection_id,
		"sample_master_id" => $sample_master_id,
		"aliquot_label" => "'n/a'"
	);   
	if($initial_storage_date) { 
		$master_insert['storage_datetime'] = "'".$initial_storage_date."'";
		$master_insert['storage_datetime_accuracy'] = "'h'";
	}
	$detail_insert = array('aliquot_master_id' => null);
	if($detail_table == 'ad_blocks') $detail_insert['block_type'] = "'paraffin'";	
		
	while($nbr_of_aliquots) {
		$nbr_of_aliquots--;
		
		$aliquot_master_id = insertCollectionElement($master_insert, 'aliquot_masters');
		$detail_insert['aliquot_master_id'] = $aliquot_master_id;
		insertCollectionElement($detail_insert, $detail_table, true);
	}
}

function insertCollectionElement($data_arr, $table_name, $is_detail_table = false) {
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
