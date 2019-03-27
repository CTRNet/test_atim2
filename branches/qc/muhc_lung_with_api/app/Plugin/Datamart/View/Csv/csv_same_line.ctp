<?php
// used by browser
header('Content-Type: application/csv');
$csv = $this->Csv;

if ($csvHeader) {
    $csv::$nodesInfo = $nodesInfo;
    $csv::$structures = $structuresArray;
}
$this->Structures->build(array(), array(
    'type' => 'csv',
    'settings' => array(
        'csv_header' => $csvHeader,
        'all_fields' => AppController::getInstance()->csvConfig['type'] == 'all'
    )
));

ob_flush();