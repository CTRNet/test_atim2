<?php
$pkey = 'Patient # in biobank';
$fields = array(
	'bank_id'						=> 'bank_id',
	"collection_datetime" 			=> 'Date of Specimen Collection Date of Collection',
	"collection_datetime_accuracy"	=> array("Date of Specimen Collection Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
);

function postInventoryWrite(Model $m){
	global $connection;
	
	//sample_masters
	$query = 'INSERT INTO sample_masters (collection_id, sample_control_id, created, created_by, modified, modified_by, deleted) VALUES('.$m->last_id.', 3, NOW(), '.Config::$db_created_id.', NOW(), '.Config::$db_created_id.', 0)';
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$last_id = $connection->insert_id;
	$query = 'UPDATE sample_masters SET sample_code=id WHERE id='.$last_id;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	if(!$m->custom_data['specimen_type_value_domain']->isValidValue($m->values['Collected Specimen Type'])){
		echo 'WARNING: Invalid value ['.$m->values['Collected Specimen Type'].'] for Collected Specimen Type on line '.$m->line."\n";
	}
	
	//sd_spe_tissues
	$query = 'INSERT INTO sd_spe_tissues (sample_master_id, qc_tf_collected_specimen_type, deleted) VALUES('.$last_id.', "'.$m->values['Collected Specimen Type'].'", 0)';
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	//aliquot_masters
	$query = 'INSERT INTO aliquot_masters (sample_master_id, collection_id, aliquot_control_id, created, created_by, modified, modified_by, deleted) VALUES '
		.sprintf('(%d, %d, 33, NOW(), %d, NOW(), %d, 0)', $last_id, $m->last_id, Config::$db_created_id, Config::$db_created_id);
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$last_id = $connection->insert_id;
	
	//ad_tissue_cores
	$query = 'INSERT INTO ad_tissue_cores (aliquot_master_id, deleted) VALUES ('.$last_id.', 0)';
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}

$model = new Model(3, $pkey, array(), true, NULL, NULL, 'collections', $fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["collection_datetime"]					=> key($fields["collection_datetime_accuracy"])
	), 'specimen_type_value_domain' => new ValueDomain('qc_tf_sample_collected_type', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)
);

$model->post_read_function = 'excelDateFix';
$model->post_write_function = 'postInventoryWrite';

Config::addModel($model, 'inventory');
