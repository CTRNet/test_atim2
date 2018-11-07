<?php
AppController::addInfoMsg(__('aliquots data') . ': ' . __('all changes will be applied to the all'));
AppController::addInfoMsg(__('aliquots data') . ': ' . __("keep the 'new value' field empty to not change data and use the 'erase/remove' checkbox to erase the data"));

$structureLinks = array(
    'top' => '/InventoryManagement/AliquotMasters/addInternalUseToManyAliquots/',
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'links' => $structureLinks,
    'extras' => $this->Form->text('aliquot_ids', array(
        "type" => "hidden",
        "id" => false,
        "value" => $aliquotIds
    )) . $this->Form->text('url_to_cancel', array(
        "type" => "hidden",
        "id" => false,
        "value" => $urlToCancel
    )),
    'settings' => array(
        'header' => array(
            'title' => __('use/event creation'),
            'description' => (isset($storageDescription) ? __('you are about to create an use/event for %s aliquot(s) contained into %s', substr_count($aliquotIds, ',') + 1, $storageDescription) : __('you are about to create an use/event for %d aliquot(s)', substr_count($aliquotIds, ',') + 1))
        ),
        'confirmation_msg' => __('batch_edit_confirmation_msg')
    )
);
if ($aliquotVolumeUnit)
    $finalOptions['override']['AliquotControl.volume_unit'] = $aliquotVolumeUnit;
    
    // CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);