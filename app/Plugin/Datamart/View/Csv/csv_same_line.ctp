<?php
//used by browser

if($csv_header){
	//init
	$this->Csv->nodes_info = $nodes_info;
	$this->Csv->structures = $structures_array;
	$this->Structures->build( array(), array('type' => 'csv', 'settings' => array('csv_header' => $csv_header, 'all_fields' => AppController::getInstance()->csv_config['type'] == 'all')));
}

// $this->Structures->build( $result_structure, array('type' => 'csv', 'settings' => array('csv_header' => false, 'all_fields' => AppController::getInstance()->csv_config['type'] == 'all')));
ob_flush();
