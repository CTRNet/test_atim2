<?php
$pkey = "VOA Number";
$child = array();
$fields = array(
	"participant_id" => $pkey,
	"collection_id" => "#collection_id");


//see the Model class definition for more info
$model = new Model(1, $pkey, $child, false, "participant_id", $pkey, 'clinical_collection_links', $fields);

//we can then attach post read/write functions
$model->custom_data = array();

//adding this model to the config
Config::$models['Collection'] = $model;

$model->post_read_function = 'postCollectionRead';
$model->insert_condition_function = 'preCollectionWrite';

function postCollectionRead(Model $m){
	
//	excelDateFix($m);
//TODO 	tmp_storage_date_to_format
	return true;

}
function preCollectionWrite(Model $m){
	$m->values['collection_id'] = createCollection($m);
	
	return true;
}

function createCollection(Model $m) {
	global $connection;
	
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);

	// ** Create collection **
	$insert_arr = array(
		"bank_id" => "1", 
		"collection_notes" => "'".	Config::$notes_from_voa['collection_additional_notes'][Config::$current_voa_nbr]."'",
		"collection_property" => "'participant collection'"
	);
	$insert_arr = array_merge($insert_arr, $created);
	$query = "INSERT INTO collections (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($connection, $query) or die("collection creation [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$collection_id = mysqli_insert_id($connection);
	
	// ** Create Tissus Specimen 1 **
	
	$sample_master_id = null;
	if(!empty($m->values['Tissue Receipt::Specimen Type 1'])) {
		$insert_arr = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'], 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'tissue'", 
			"collection_id"					=> "'".$collection_id."'", 
			"parent_id"						=> "NULL",
			"notes"							=> "'".$m->values['Tissue Receipt::Specimen Type 1']."'" 
		);
		$insert_arr = array_merge($insert_arr, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=id WHERE sample_code='tmp_tissue'";
		mysqli_query($connection, $query) or die("sample code update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
		$tissue_source = 'other';
		if(preg_match('/(endometrial|endometrium|omentum|ovary)/', strtolower($m->values['Tissue Receipt::Specimen Type 1']), $matches)) {
			$tissue_source = $matches[1];
			if($tissue_source == 'endometrium') $tissue_source = 'endometrial';
		}
		
		$tissue_laterality = '';
		if(preg_match('/(left|right)/', strtolower($m->values['Tissue Receipt::Specimen Type 1']), $matches)) {
			$tissue_laterality = $matches[1];
//TODO add bilateral
		}
		
		$insert_arr = array(
			"sample_master_id"	=> $sample_master_id,
//TODO			"tissue_nature" => "'".$data['details']['type']."'",
			"tissue_source" => "'$tissue_source'",
			"tissue_laterality" => "'$tissue_laterality'"
		);
		$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
		$insert_arr = array(
			"sample_master_id"	=> $sample_master_id
		);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
	}
	
	// ** Create Tissus Specimen 2 **
//TODO
	
	// ** Create Tissus Vials Frozen **	

	if(!empty($m->values['Tissue Receipt::Vials Frozen'])) {
		if(!empty($sample_master_id)) createAliquot($collection_id, $sample_master_id, 'tissue', 'tube', $m->values['Tissue Receipt::Vials Frozen']);
//TODO Manage $sample_master_id null
	}
	
	// ** Create Tissus Paraffin Blocks **
	
	if(!empty($m->values['Tissue Receipt::Paraffin Blocks'])) {
		if(!empty($sample_master_id)) createAliquot($collection_id, $sample_master_id, 'tissue', 'block', $m->values['Tissue Receipt::Paraffin Blocks']);
	}
	
	return  $collection_id;
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
