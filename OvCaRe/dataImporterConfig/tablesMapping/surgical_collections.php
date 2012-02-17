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
	
//	excelDateFix($m);
//TODO 	tmp_storage_date_to_format
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
			
			$data_arr = array(
				"sample_code" 					=> "'tmp_".(Config::$sample_code_counter++)."'", 
				"sample_control_id"				=> Config::$sample_aliquot_controls['blood']['sample_control_id'], 
				"initial_specimen_sample_id"	=> "NULL", 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> "'".$collection_id."'", 
				"parent_id"						=> "NULL",
				"notes"							=> "''" 
			);
			$blood_sample_master_id = insertCollectionElement($data_arr, 'sample_masters');
		
			$data_arr = array(
				"sample_master_id"	=> $blood_sample_master_id,
			);
			insertCollectionElement($data_arr, 'sd_spe_bloods', true);
			insertCollectionElement($data_arr, 'specimen_details');
			
			break;
		case 'surgical':
			break;
		
		default:
			die("Collection Type Unknown (ERR993789120): ". $collection_type);		
	}

	return  $collection_id;	
	
//TODO continue
	
//	// ** Create Tissus Specimen 1 **
//	
//	$sample_master_id = null;
//	if(!empty($m->values['Tissue Receipt::Specimen Type 1'])) {
//		$insert_arr = array(
//			"sample_code" 					=> "'tmp_tissue'", 
//			"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'], 
//			"initial_specimen_sample_id"	=> "NULL", 
//			"initial_specimen_sample_type"	=> "'tissue'", 
//			"collection_id"					=> "'".$collection_id."'", 
//			"parent_id"						=> "NULL",
//			"notes"							=> "'".$m->values['Tissue Receipt::Specimen Type 1']."'" 
//		);
//		$insert_arr = array_merge($insert_arr, $created);
//		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$sample_master_id = mysqli_insert_id($connection);
//		$query = "UPDATE sample_masters SET sample_code=id WHERE sample_code='tmp_tissue'";
//		mysqli_query($connection, $query) or die("sample code update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	
//		$tissue_source = 'other';
//		if(preg_match('/(endometrial|endometrium|omentum|ovary)/', strtolower($m->values['Tissue Receipt::Specimen Type 1']), $matches)) {
//			$tissue_source = $matches[1];
//			if($tissue_source == 'endometrium') $tissue_source = 'endometrial';
//		}
//		
//		$tissue_laterality = '';
//		if(preg_match('/(left|right)/', strtolower($m->values['Tissue Receipt::Specimen Type 1']), $matches)) {
//			$tissue_laterality = $matches[1];
////TODO add bilateral
//		}
//		
//		$insert_arr = array(
//			"sample_master_id"	=> $sample_master_id,
////TODO			"tissue_nature" => "'".$data['details']['type']."'",
//			"tissue_source" => "'$tissue_source'",
//			"tissue_laterality" => "'$tissue_laterality'"
//		);
//		$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
//		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	
//		$insert_arr = array(
//			"sample_master_id"	=> $sample_master_id
//		);
//		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
//		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
//	}
//	
//	// ** Create Tissus Specimen 2 **
////TODO
//	
//	// ** Create Tissus Vials Frozen **	
//
//	if(!empty($m->values['Tissue Receipt::Vials Frozen'])) {
//		if(!empty($sample_master_id)) createAliquot($collection_id, $sample_master_id, 'tissue', 'tube', $m->values['Tissue Receipt::Vials Frozen']);
////TODO Manage $sample_master_id null
//	}
//	
//	// ** Create Tissus Paraffin Blocks **
//	
//	if(!empty($m->values['Tissue Receipt::Paraffin Blocks'])) {
//		if(!empty($sample_master_id)) createAliquot($collection_id, $sample_master_id, 'tissue', 'block', $m->values['Tissue Receipt::Paraffin Blocks']);
//	}
//	
//	return  $collection_id;
}
	
function createAliquot($collection_id, $sample_master_id, $sample_type, $aliquot_type, $nbr_of_aliquots) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	$nbr_of_aliquots = empty($nbr_of_aliquots)? 0 : $nbr_of_aliquots;
	if(!is_numeric($nbr_of_aliquots)) die('ERR998738: Nbr of Aliquot should be numeric'.$nbr_of_aliquots);
	
	$aliquot_control_id = Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['aliquot_control_id'];
	$detail_table = Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type]['detail_tablename'];
	
	while($nbr_of_aliquots) {
		$nbr_of_aliquots--;
		
		$master_insert = array(
			"aliquot_control_id" => $aliquot_control_id,
			"in_stock" => "'yes - available'",
			"collection_id" => $collection_id,
			"sample_master_id" => $sample_master_id,
			"aliquot_label" => "'n/a'"
		);    
		$detail_insert = array();
		if($detail_table == 'ad_blocks') $detail_insert['block_type'] = "'paraffin'";	
		
		$master_insert = array_merge($master_insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($master_insert)).") VALUES (".implode(", ", array_values($master_insert)).")";
		mysqli_query($connection, $query) or die("Aliquot Creation [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		
		$detail_insert['aliquot_master_id'] = $aliquot_master_id;
		$query = "INSERT INTO $detail_table (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
		mysqli_query($connection, $query) or die("Aliquot Creation [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
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
