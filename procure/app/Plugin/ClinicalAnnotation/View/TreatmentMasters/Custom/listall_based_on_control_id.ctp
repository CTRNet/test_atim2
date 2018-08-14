<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/%%TreatmentMaster.id%%/',
        'edit' => '/ClinicalAnnotation/TreatmentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%TreatmentMaster.id%%/'
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
	
	
	

