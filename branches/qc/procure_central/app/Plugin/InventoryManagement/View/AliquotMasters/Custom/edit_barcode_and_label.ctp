<?php
$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/editBarcodeAndLabel/',
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'extras' => $this->Form->input('url_to_cancel', array(
        'type' => 'hidden',
        'value' => $urlToCancel
    )) . $this->Form->input('aliquot_ids_to_update', array(
        'type' => 'hidden',
        'value' => $aliquotIdsToUpdate
    )),
    'settings' => array(
        'pagination' => false,
        'header' => __('aliquot barcode (and label) update')
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
?>

