<?php
$structureLinks = array(
    'top' => null,
    'index' => array(
        'detail' => '/Study/StudyFundings/detail/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyFunding.id%%',
        'edit' => '/Study/StudyFundings/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyFunding.id%%',
        'delete' => '/Study/StudyFundings/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyFunding.id%%'
    ),
    'bottom' => array(
        'add' => '/Study/StudyFundings/add/' . $atimMenuVariables['StudySummary.id'] . '/'
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