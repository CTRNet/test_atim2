<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ReproductiveHistories/add/' . $atimMenuVariables['Participant.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ReproductiveHistories/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);