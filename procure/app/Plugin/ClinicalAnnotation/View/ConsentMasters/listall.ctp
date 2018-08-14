<?php
$addLinks = array();
foreach ($consentControlsList as $consentControl) {
    $addLinks[__($consentControl['ConsentControl']['controls_type'])] = '/ClinicalAnnotation/ConsentMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $consentControl['ConsentControl']['id'] . '/';
}
natcasesort($addLinks);

$structureLinks = array(
    'top' => null,
    'index' => array(
        'detail' => '/ClinicalAnnotation/ConsentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%',
        'edit' => '/ClinicalAnnotation/ConsentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%',
        'delete' => '/ClinicalAnnotation/ConsentMasters/delete/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%'
    ),
    'bottom' => array(
        'add' => $addLinks
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);