<?php
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/EventMasters/detail/' . $atimMenuVariables['Participant.id'] . '/%%EventMaster.id%%',
        'edit' => '/ClinicalAnnotation/EventMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%EventMaster.id%%',
        'delete' => '/ClinicalAnnotation/EventMasters/delete/' . $atimMenuVariables['Participant.id'] . '/%%EventMaster.id%%'
    )
);
if (isset($addLinks))
    $structureLinks['bottom']['add'] = $addLinks;
$structureSettings = array();
$structureOverride = array();
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'index',
    'settings' => $structureSettings
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
        // No active control for this event_group => Display empty list
        $finalOptions['settings']['pagination'] = false;
        $this->Structures->build($atimStructure, $finalOptions);
    } else {
        $counter = 0;
        foreach ($controlsForSubformDisplay as $newControl) {
            $counter ++;
            $finalAtimStructure = array();
            $finalOptions['type'] = 'detail';
            $finalOptions['settings']['header'] = $newControl['EventControl']['ev_header'];
            $finalOptions['settings']['actions'] = $counter == sizeof($controlsForSubformDisplay);
            $finalOptions['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listall/' . $atimMenuVariables['EventMaster.event_group'] . '/' . $atimMenuVariables['Participant.id'] . '/' . $newControl['EventControl']['id']);
            
            $hookLink = $this->Structures->hook('subform');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->Structures->build($finalAtimStructure, $finalOptions);
        }
    }
}