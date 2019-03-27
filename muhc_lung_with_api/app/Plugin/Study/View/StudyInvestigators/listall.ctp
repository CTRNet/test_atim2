<?php
$structureLinks = array(
    'top' => null,
    'index' => array(
        'detail' => '/Study/StudyInvestigators/detail/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyInvestigator.id%%',
        'edit' => '/Study/StudyInvestigators/edit/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyInvestigator.id%%',
        'delete' => '/Study/StudyInvestigators/delete/' . $atimMenuVariables['StudySummary.id'] . '/%%StudyInvestigator.id%%'
    ),
    'bottom' => array(
        'add' => '/Study/StudyInvestigators/add/' . $atimMenuVariables['StudySummary.id'] . '/'
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