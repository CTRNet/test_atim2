<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'settings' => array(
        'pagination' => false,
        'form_inputs' => false,
        'header' => array(
            'title' => $title,
            'description' => __('select the identifiers you wish to delete permanently')
        ),
        'confirmation_msg' => __('core_are you sure you want to delete this data?')
    ),
    'links' => array(
        'bottom' => array(),
        'top' => '/Administrate/ReusableMiscIdentifiers/manage/' . $atimMenuVariables['MiscIdentifierControl.id'],
        'checklist' => array(
            'MiscIdentifier.selected_id][' => '%%MiscIdentifier.id%%'
        )
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);