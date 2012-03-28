<?php
//used by csv/csv and browser/csv

$this->Structures->build( $result_structure, array('type' => 'csv', 'settings' => array('csv_header' => $csv_header, 'all_fields' => AppController::getInstance()->csv_config['type'] == 'all')));
ob_flush();
