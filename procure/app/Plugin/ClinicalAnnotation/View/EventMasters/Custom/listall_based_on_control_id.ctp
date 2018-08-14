<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/EventMasters/detail/' . $atimMenuVariables['Participant.id'] . '/%%EventMaster.id%%/',
        'edit' => '/ClinicalAnnotation/EventMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%EventMaster.id%%/'
    )
);
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'settings' => array(
        'pagination' => true,
        'actions' => false
    ),
    'links' => $structureLinks
);
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
