<?php
// used by csv/csv and browser/csv
$this->Structures->build($resultStructure, array(
    'type' => 'csv',
    'settings' => array(
        'csv_header' => $csvHeader,
        'all_fields' => AppController::getInstance()->csvConfig['type'] == 'all'
    )
));
ob_flush();