<?php

// ************** EVENTS **************
$structureLinks = array(
    'top' => '/ClinicalAnnotation/TreatmentMasters/preOperativeEdit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/'
);

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
    
    $structureLinks['radiolist'] = array(
        'TreatmentDetail.' . $newEventsList['event_foreign_key'] => '%%EventMaster.id%%'
    );
    
    $finalAtimStructure = $newEventsList['structure'];
    
    $finalOptions = array(
        'type' => 'index',
        'data' => $newEventsList['data'],
        'settings' => $structureSettings,
        'links' => $structureLinks,
        'extras' => array(
            'end' => '<input type="radio" name="data[TreatmentDetail][' . $newEventsList['event_foreign_key'] . ']" ' . ($newEventsList['selected_event_found'] ? '' : 'checked="checked"') . ' value=""/>' . __('n/a', true)
        )
    );
    
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    $isFirst = false;
}

// ************** CIRRHOSIS **************

$structureLinks = array(
    'top' => $structureLinks['top']
);
$structureLinks['bottom'] = array(
    'cancel' => '/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['TreatmentMaster.id'] . '/'
);

$structureSettings = array(
    'form_top' => false,
    'header' => __('cirrhosis data', true)
);

$finalAtimStructure = $atimStructure;

$finalOptions = array(
    'type' => 'edit',
    'data' => $this->data,
    'settings' => $structureSettings,
    'links' => $structureLinks
);

$this->Structures->build($finalAtimStructure, $finalOptions);
