<?php
$structureLinks = array(
    'top' => null,
    'index' => '/Study/StudyEthicsBoards/detail/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyEthicsBoard.id%%/',
    'bottom' => array(
        'add' => '/Study/StudyEthicsBoards/add/' . $atimMenuVariables['StudySummary.id'] . '/'
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