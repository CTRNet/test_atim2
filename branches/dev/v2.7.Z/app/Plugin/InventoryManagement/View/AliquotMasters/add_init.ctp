<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'header' => __('aliquot creation batch process') . ' - ' . __('aliquot type selection'),
        'stretch' => false
    ),
    'links' => array(
        'top' => '/InventoryManagement/AliquotMasters/add/',
        'bottom' => array(
            'cancel' => $urlToCancel
        )
    ),
    'extras' => '
			<input type="hidden" name="data[0][ids]" value="' . $ids . '"/>
			<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>