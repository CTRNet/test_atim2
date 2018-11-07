<?php
$structureLinks = array(
    'top' => '/Study/StudyEthicsBoards/edit/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyEthicsBoard.id'] . '/',
    'bottom' => array(
        'cancel' => '/Study/StudyEthicsBoards/detail/' . $atimMenuVariables['StudySummary.id'] . '/' . $atimMenuVariables['StudyEthicsBoard.id'] . '/'
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