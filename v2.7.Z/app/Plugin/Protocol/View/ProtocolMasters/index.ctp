<?php
$addLinks = array();
foreach ($protocolControls as $protocolControl) {
    $addLinks[(empty($protocolControl['ProtocolControl']['tumour_group']) ? '' : __($protocolControl['ProtocolControl']['tumour_group']) . ' - ') . __($protocolControl['ProtocolControl']['type'])] = '/Protocol/ProtocolMasters/add/' . $protocolControl['ProtocolControl']['id'] . '/';
}
ksort($addLinks);

$structureLinks = array(
    'bottom' => array(
        'add' => $addLinks
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => array(
            'search' => '/Protocol/ProtocolMasters/search/' . AppController::getNewSearchId()
        )
    ),
    'settings' => array(
        'actions' => false,
        'header' => __('search type', null) . ': ' . __('protocols', null)
    )
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => $structureLinks,
    'extras' => '<div class="ajax_search_results"></div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);
?>