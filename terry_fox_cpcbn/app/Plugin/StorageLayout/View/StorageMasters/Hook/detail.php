<?php
if (isset($_SESSION['Auth']) && $_SESSION['Auth']['User']['group_id'] == '1' && array_key_exists('export as CSV file (comma-separated values)', $finalOptions['links']['bottom'])) {
    // Administartor: Allow export for TMA review
    $finalOptions['links']['bottom']['export as CSV file (comma-separated values)'] = array(
        'classical' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/" . $atimMenuVariables['StorageMaster.id'] . "/0/1/');", 0),
        'for review (participant_identifier+aliquot_label)' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/" . $atimMenuVariables['StorageMaster.id'] . "/0/2/');", 0),
        'for review (participant_identifier+aliquot_label+aliquot_barcode)' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/" . $atimMenuVariables['StorageMaster.id'] . "/0/3/');", 0),
        'for review (aliquot_label+aliquot_barcode)' => sprintf("javascript:setCsvPopup('/StorageLayout/StorageMasters/storageLayout/" . $atimMenuVariables['StorageMaster.id'] . "/0/4/');", 0)
    );
}