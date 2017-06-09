<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/FamilyHistories/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['FamilyHistory.id'],
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/FamilyHistories/detail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['FamilyHistory.id']
    )
);

// Set form structure and option
/* ==> Note: Set both form structure and option into 2 variables to allow hooks to modify them */
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

?>