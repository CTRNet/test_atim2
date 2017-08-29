<?php
$addLinks = array();
foreach ($protocolControls as $protocolControl) {
    $addLinks[(empty($protocolControl['ProtocolControl']['tumour_group']) ? '' : __($protocolControl['ProtocolControl']['tumour_group']) . ' - ') . __($protocolControl['ProtocolControl']['type'])] = '/Protocol/ProtocolMasters/add/' . $protocolControl['ProtocolControl']['id'] . '/';
}

$structureLinks = array(
    'index' => array(
        'detail' => '/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%'
    ),
    'bottom' => array(
        'add' => $addLinks
    )
);

$settings = array(
    'return' => true
);
if (isset($isAjax)) {
    $settings['actions'] = false;
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$form = $this->Structures->build($finalAtimStructure, $finalOptions);
if (isset($isAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $form,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $form;
}