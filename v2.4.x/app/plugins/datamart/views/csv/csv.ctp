<?php
//used by csv/csv and browser/csv

$structures->build( $result_structure, array('type' => 'csv', 'settings' => array('csv_header' => $csv_header, 'all_fields' => $all_fields)) );
ob_flush();

?>
