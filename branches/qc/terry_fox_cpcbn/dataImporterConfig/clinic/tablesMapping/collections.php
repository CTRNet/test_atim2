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
	$recorded_values = strtolower($values);
	
	if(!empty($recorded_values) && !in_array($recorded_values, Config::$collection_sites)) {
		$query = "INSERT INTO `structure_permissible_values_customs` (`value`, `en`, `fr`, `control_id`, `use_as_input`) VALUES ('$recorded_values','$values','$values', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen collection sites'), 1);";
		if(Config::$print_queries) echo $query.Config::$line_break_tag;
		mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		$last_id = Config::$db_connection->insert_id;
		$query = "INSERT INTO `structure_permissible_values_customs_revs` (id, `value`, `en`, `fr`, `control_id`, `use_as_input`) VALUES ('$last_id', '$recorded_values','$values','$values', (SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE 'specimen collection sites'), 1);";
		if(Config::$insert_revs) mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Config::$collection_sites[$recorded_values] = $recorded_values;
	}
	
	return $recorded_values;
}

function dxCollectionPostWrite(Model $m){
	return true;
}




