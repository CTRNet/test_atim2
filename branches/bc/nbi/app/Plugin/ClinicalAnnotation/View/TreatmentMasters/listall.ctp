<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/%%TreatmentMaster.id%%/',
        'edit' => '/ClinicalAnnotation/TreatmentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%TreatmentMaster.id%%/',
        'delete' => '/ClinicalAnnotation/TreatmentMasters/delete/' . $atimMenuVariables['Participant.id'] . '/%%TreatmentMaster.id%%/'
    ),
    'bottom' => array(
        'add' => $addLinks
    )
);

$structureOverride = array();

$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'override' => $structureOverride
);
$finalAtimStructure = $atimStructure;

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

if (! isset($controlsForSubformDisplay)) {
    // Subform display
    $this->Structures->build($atimStructure, $finalOptions);
} else {
    // Main form display
    if (empty($controlsForSubformDisplay)) {
        // No active control for this treatment type => Display empty list
        $finalOptions['settings']['pagination'] = false;
        $this->Structures->build($atimStructure, $finalOptions);
    } else {
        $counter = 0;
        foreach ($controlsForSubformDisplay as $newControl) {
            $counter ++;
            $finalAtimStructure = array();
            $finalOptions['type'] = 'detail';
            $finalOptions['settings']['header'] = $newControl['TreatmentControl']['tx_header'];
            $finalOptions['settings']['actions'] = $counter == sizeof($controlsForSubformDisplay);
            $finalOptions['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listall/' . $atimMenuVariables['Participant.id'] . '/' . $newControl['TreatmentControl']['id']);
            
            $hookLink = $this->Structures->hook('subform');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->Structures->build($finalAtimStructure, $finalOptions);
        }
    }
}