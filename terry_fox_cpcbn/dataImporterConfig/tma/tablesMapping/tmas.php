<?php  

$pkey = "TMA name";

$child = array(
 	'core'
);
$fields = array(
	'storage_control_id'	=> '#storage_control_id',
	'qc_tf_tma_name' => $pkey,
	'short_label' => '#short_label',
	'selection_label' => '#selection_label',
	'lft' => '#lft',
	'rght' => '#rght'		
);

$detail_fields = array();

$model = new MasterDetailModel(0, $pkey, $child, false, 'storage_master_id', $pkey, 'storage_masters', $fields, 'std_tma_blocks', 'storage_master_id', $detail_fields);
$model->custom_data = array();

$model->post_read_function = 'postTmaRead';
$model->post_write_function = 'postTmaWrite';

Config::addModel($model, 'tma');

function postTmaRead(Model $m){	
	$m->values['storage_control_id'] = Config::$tma_control_id;
	Config::$last_storage_rght++; 
	$m->values['lft'] = Config::$last_storage_rght;
	Config::$last_storage_rght++;
	$m->values['rght'] = Config::$last_storage_rght;
	
	$m->values['short_label'] = '?';
	if(preg_match('/^([A-Za-z0-9]+)\-([A-Za-z0-9]+)\-([0-9]+)$/', $m->values['TMA name'], $matches)) {
		$m->values['short_label'] = $matches[3];
	}
	$m->values['short_label'] = 'TMA-'.$m->values['short_label'];
	$m->values['selection_label'] = $m->values['short_label'];
		
	return true;
}

function postTmaWrite(Model $m){
	$query = "UPDATE storage_masters SET code=id WHERE id=".$m->last_id;
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	mysqli_query(Config::$db_connection, str_replace('storage_masters','storage_masters_revs',$query)) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
}
