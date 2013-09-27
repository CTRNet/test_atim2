<?php
$pkey = "TMA name";

$child = array();

$fields = array(
	'storage_master_id' => $pkey,
	'aliquot_label' => '#aliquot_label',
	'aliquot_control_id' => '#aliquot_control_id',
	'collection_id' => '#collection_id',
	'sample_master_id' => '#sample_master_id',
	'in_stock' => '@yes - available',
	'storage_coord_x' => 'Position X',
	'storage_coord_y' => 'Position Y'
);

$detail_fields = array(
);

$model = new MasterDetailModel(1, $pkey, $child, false, 'storage_master_id', $pkey, 'aliquot_masters', $fields, 'ad_tissue_cores', 'aliquot_master_id', $detail_fields);
$model->custom_data = array();

$model->post_read_function = 'postCoreRead';
$model->post_write_function = 'postCoreWrite';
Config::addModel($model, 'core');

function postCoreRead(Model $m){
	if(!strlen($m->values['biobank patient#']) || $m->values['biobank patient#'] == '.') return false;
	
	$m->values['Diagnostic'] = strtolower($m->values['Diagnostic']);
	$m->values['Diagnostic'] = str_replace(array('tumor','normal adjacent','cancer'), array('tumoral','normal','tumoral'), $m->values['Diagnostic']);

	$tissue_nature_precision = '';
	if(!strlen($m->values['Diagnostic']) || in_array($m->values['Diagnostic'], array('.','?'))) {
		$m->values['Diagnostic'] = 'unknown';
		Config::$summary_msg['Core']['@@WARNING@@']['Core Diagnostic empty'][] = "Core diagnostic value is not defined. Set to unknown with no precision. Set tissue nature to 'unknown'. See line ".$m->line.".";
	} else if(!in_array($m->values['Diagnostic'], array('benin','normal','tumoral','unknown'))) {
		Config::$summary_msg['Core']['@@WARNING@@']['Core Diagnostic unknown'][] = "Core diagnostic value [".$m->values['Diagnostic']."] is not supported. Set tissue nature to 'unknown' and added value to tissue precision. See line ".$m->line.".";
		$tissue_nature_precision = $m->values['Diagnostic'];
		$m->values['Diagnostic'] = 'unknown';
	}
	
	$m->values['collection_id'] = getCollectionId($m->values['BANK'], $m->values['biobank patient#'], $m->line);
	if(empty($m->values['collection_id'])) {
		Config::$summary_msg['Core']['@@ERROR@@']['Unknown collection'][$m->values['biobank patient#'].$m->values['biobank patient#']] = "No collection was created for patient '".$m->values['biobank patient#']."' of bank '".$m->values['BANK']."'.";
		return false;
	}
	
	$m->values['sample_master_id'] = getSampleMasterId($m->values['collection_id'], $m->values['Diagnostic'], $tissue_nature_precision, $m->values['biobank patient#'], $m->line);
	
	foreach(array('Position X','Position Y') as $pos_field) {
		if(!preg_match('/^[1-9]|1[0-9]|2[0-3]$/',$m->values[$pos_field])) {
			Config::$summary_msg['Core']['@@ERROR@@']['Core Position Error'][] = "TMA postion [".$m->values[$pos_field]."] for field '$pos_field' is not supported. See line ".$m->line.".";
			$m->values[$pos_field] = '';
		}
	}
	$tmp_arr_az = range('A', 'Z');
	$m->values['Position X'] = $tmp_arr_az[($m->values['Position X']-1)];
	
	$m->values['aliquot_control_id'] = Config::$sample_aliquot_controls['tissue']['aliquots']['core']['aliquot_control_id'];
	
	//$m->values['aliquot_label'] = $m->values['biobank patient#'].' ('.$m->values['Core #'].') ['.$m->values['BANK'].']';
	$m->values['aliquot_label'] = $m->values['biobank patient#'].' '.(str_replace(array('normal','benin','tumoral','unknown'), array('N','B','T','U'), $m->values['Diagnostic'])).' ['.$m->values['BANK'].']';
	
	return true;
}

function postCoreWrite(Model $m){
	$query = "UPDATE aliquot_masters SET barcode=id WHERE id=".$m->last_id;
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	mysqli_query(Config::$db_connection, str_replace('aliquot_masters','aliquot_masters_revs',$query)) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	return true;
}

function getCollectionId($bank_name, $qc_tf_bank_participant_identifier, $line) {
	$collection_id = null;
	
	if(isset(Config::$collection_ids[$bank_name][$qc_tf_bank_participant_identifier])) {
		$collection_id = Config::$collection_ids[$bank_name][$qc_tf_bank_participant_identifier];
	} else {
		if(!array_key_exists($bank_name, Config::$banks)) die("Bank [$bank_name] is unknown [line: $line].");
		$query = "SELECT collection_id FROM view_collections WHERE qc_tf_bank_participant_identifier = '$qc_tf_bank_participant_identifier' AND bank_id = '".Config::$banks[$bank_name]."'";	
		$results = mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
		$counter = 0;
		$row = array();
		while($row = $results->fetch_assoc()) {
			$collection_id = $row['collection_id'];
			$counter++;
		}
		if($counter > 1) Config::$summary_msg['Core']['@@WARNING@@']['Many Collections'][] = "More than one collection were linked to patient '$qc_tf_bank_participant_identifier' of bank '$bank_name'. See line $line.";
		Config::$collection_ids[$bank_name][$qc_tf_bank_participant_identifier] = $collection_id;
	}
	
	return $collection_id;
}

function getSampleMasterId($collection_id, $qc_tf_collected_specimen_nature, $tissue_nature_precision, $qc_tf_bank_participant_identifier, $line) {
	$sample_master_id = null;
	
	$created = array(
		"created"		=> "NOW()",
		"created_by"	=> Config::$db_created_id,
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
	);
	$insert = array(
		"sample_code" 					=> "'tmp_tissue'",
		"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'],
		"initial_specimen_sample_id"	=> "NULL",
		"initial_specimen_sample_type"	=> "'tissue'",
		"collection_id"					=> "'$collection_id'",
		"parent_id"						=> "NULL"
	);
	$insert = array_merge($insert, $created);
	$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query(Config::$db_connection, $query) or  die("[$query] ".__FUNCTION__." ".__LINE__);
	$sample_master_id = mysqli_insert_id(Config::$db_connection);
	$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE id=".$sample_master_id;
	mysqli_query(Config::$db_connection, $query) or  die("[$query] ".__FUNCTION__." ".__LINE__);
	Database::insertRev('sample_masters', $sample_master_id);
	
	$insert = array(
		"sample_master_id"						=> $sample_master_id,
		"qc_tf_collected_specimen_nature"		=> "'$qc_tf_collected_specimen_nature'",
		"qc_tf_collected_specimen_nature_precision"		=> "'$tissue_nature_precision'"
	);
	$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	Database::insertRev('sd_spe_tissues', $sample_master_id, 'sample_master_id');			
	
	$insert = array("sample_master_id" => $sample_master_id);
	$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	Database::insertRev('specimen_details', $sample_master_id, 'sample_master_id');

	return $sample_master_id;	
}
