<?php
if (empty($permissionDenied)){
    $structureOverride = array(
        'Config.config_language' => $_SESSION['Config']['language'],
        'Config.define_csv_separator' => CSV_SEPARATOR,
        'Config.define_csv_encoding' => CSV_ENCODING
    );
    $this->Structures->build($atimStructure, array(
        'type' => 'add',
        'links' => array(
            'top' => 'Datamart/Csv/csv/'
        ),
        'override' => $structureOverride,
        'settings' => array(
            'actions' => false
        )
    ));
}