<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/',
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/TreatmentMasters/preOperativeEdit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/'
    ),
    'index' => array(
        array(
            'link' => '/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%/',
            'icon' => 'detail'
        )
    )
);

// ************** EVENTS **************

$structureSettings = array(
    'form_top' => true,
    'form_bottom' => false,
    'form_inputs' => false,
    'actions' => false,
    'pagination' => false,
    'header' => null
);

$isFirst = true;
foreach ($surgeriesEventsData as $foreignKeyId => $newEventsList) {
    $structureSettings['form_top'] = $isFirst ? true : false;
    $structureSettings['header'] = $newEventsList['header'];
    
    $finalAtimStructure = $newEventsList['structure'];
    
    $finalOptions = array(
        'type' => 'index',
        'data' => $newEventsList['data'],
        'settings' => $structureSettings,
        'links' => $structureLinks
    );
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    $isFirst = false;
}

// ************** CIRRHOSIS **************

unset($structureLinks['top']);
unset($structureLinks['index']);

$structureSettings = array(
    'form_top' => false,
    'header' => __('cirrhosis data', true)
);

$finalAtimStructure = $atimStructure;

$finalOptions = array(
    'type' => 'detail',
    'data' => $this->data,
    'settings' => $structureSettings,
    'links' => $structureLinks
);

$this->Structures->build($finalAtimStructure, $finalOptions);
