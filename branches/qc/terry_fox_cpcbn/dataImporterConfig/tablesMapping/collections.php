<?php

$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'diagnosis_master_id'			=> $pkey,
	'participant_id'				=> '#participant_id',
//	'treatment_master_id'			=> '#treatment_master_id',
		
	'collection_property' 			=> '@participant collection',
	'collection_site'				=> '#collection_site',	
	'collection_datetime'			=> 'Date of Specimen Collection Date of collection',	
	'collection_datetime_accuracy'	=> array('Date of Specimen Collection Accuracy' => array("c" => "h", "y" => "m", "m" => "d", "" => "")),
		
	'qc_tf_collection_type'			=> array('Collected Specimen Type' => new ValueDomain("qc_tf_collection_type", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

$model = new Model(3, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'collections', $fields);

$model->custom_data = array(
	'date_fields' => array(
		$fields["collection_datetime"]		=> key($fields['collection_datetime_accuracy'])
	)
);

$model->post_read_function = 'dxCollectionPostRead';
$model->insert_condition_function = 'dxCollectionInsertCondition';
$model->post_write_function = 'dxCollectionPostWrite';

Config::addModel($model, 'collection');

function dxCollectionPostRead(Model $m){
	if(empty($m->values['Date of Specimen Collection Date of collection'])) {
		Config::$summary_msg['collection']['@@ERROR@@']['No collection date'][] = "Colelction won't be created. See line ".$m->line.".";
		return false;
	}
	excelDateFix($m);
	
	return true;
}

function dxCollectionInsertCondition(Model $m){
	$m->values['collection_site'] = getCollectionSite($m->values['Site of collection']);
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}

function getCollectionSite($values) {
	global $connection;
	
	$recorded_values = strtolower($values);
	
	if(!empty($recorded_values) && !in_array($recorded_values, Config::$collection_sites)) {
		$query = "INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `control_id`, `use_as_input`) VALUES ('$recorded_values','$values','$values', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen collection sites'), 1);";
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$last_id = $connection->insert_id;
		$query = "INSERT INTO `structure_permissible_values_customs_revs` (id, `value`, `en`, `fr`, `control_id`, `use_as_input`) VALUES ('$last_id', '$recorded_values','$values','$values', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen collection sites'), 1);";
		mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		Config::$collection_sites[$recorded_values] = $recorded_values;
	}
	
	return $recorded_values;
}

function dxCollectionPostWrite(Model $m){
	createTissue($m->last_id, 'normal', $m->values['Sample ID number']);
	createTissue($m->last_id, 'tumoral',  $m->values['Sample ID number']);
	return true;
}
	
function createTissue($collection_id, $tissue_nature, $aliquot_label) {
	global $connection;
	
	$sample_conttrol_id = Config::$sample_aliquot_controls['tissue']['sample_control_id'];
	$user_id = Config::$db_created_id;
	
	//sample_masters
	$query = "INSERT INTO sample_masters (collection_id, sample_control_id, initial_specimen_sample_type, sample_code, created, created_by, modified, modified_by, deleted) VALUES($collection_id, $sample_conttrol_id, 'tissue', 'tmp_$collection_id', NOW(), $user_id, NOW(), $user_id, 0)";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$sample_master_id = $connection->insert_id;
	$query = 'UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE id='.$sample_master_id;
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	Database::insertRevForLastRow('sample_masters');
	
	//sd_spe_tissues
	$query = "INSERT INTO sd_spe_tissues (sample_master_id, qc_tf_collected_specimen_nature) VALUES('.$sample_master_id.', '$tissue_nature')";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	Database::insertRevForLastRow('sd_spe_tissues');
	
	//sd_spe_tissues
	$query = "INSERT INTO specimen_details (sample_master_id) VALUES('.$sample_master_id.')";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	Database::insertRevForLastRow('specimen_details');
	
	return;
	
	//aliquot_masters
	$query = 'INSERT INTO aliquot_masters (sample_master_id, collection_id, aliquot_control_id, created, created_by, modified, modified_by, deleted) VALUES '
	.sprintf('(%d, %d, 33, NOW(), %d, NOW(), %d, 0)', $sample_master_id, $m->last_id, Config::$db_created_id, Config::$db_created_id);
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$last_id = $connection->insert_id;
	Database::insertRevForLastRow('aliquot_masters');
	
	//ad_tissue_cores
	$query = 'INSERT INTO ad_tissue_cores (aliquot_master_id, deleted) VALUES ('.$last_id.', 0)';
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	Database::insertRevForLastRow('ad_tissue_cores');	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}




