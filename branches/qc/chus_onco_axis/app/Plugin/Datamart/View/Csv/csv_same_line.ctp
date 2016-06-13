<?php
//used by browser

$csv = $this->Csv;

if($csv_header){
	$csv::$nodes_info = $nodes_info;
	$csv::$structures = $structures_array;
}
$this->Structures->build( array(), array('type' => 'csv', 'settings' => array('csv_header' => $csv_header, 'all_fields' => AppController::getInstance()->csv_config['type'] == 'all')));

ob_flush();
