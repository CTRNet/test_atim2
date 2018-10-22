<?php
$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudyEthicsBoards/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyEthicsBoard.id%%/',
        'delete' => '/Study/StudyEthicsBoards/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyEthicsBoard.id%%/'
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