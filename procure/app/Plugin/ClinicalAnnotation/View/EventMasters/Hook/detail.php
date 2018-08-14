<?php
if (isset($addLinkForProcureForms)) {
    foreach ($addLinkForProcureForms as $buttonTitle => $links) {
        $finalOptions['links']['bottom'][$buttonTitle] = $links;
        $structureLinks['bottom'][$buttonTitle] = $links;
    }
}

if (isset($linkedEventsControlData)) {
    // Display clinical events and treatments lists of a follow-up worksheet
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // ------------------------------------------------------------------------------
    // Clinical Annotation
    // ------------------------------------------------------------------------------
    $mainHeader = 'clinical annotation';
    // linked clinical events
    foreach ($linkedEventsControlData as $newEventControl) {
        $finalAtimStructure = array();
        $eventControlId = $newEventControl['EventControl']['id'];
        $eventType = str_replace(array(
            'procure follow-up worksheet - ',
            'clinical event',
            'clinical note'
        ), array(
            '',
            'clinical events',
            'clinical notes'
        ), $newEventControl['EventControl']['event_type']);
        $finalOptions = array(
            'type' => 'detail',
            'links' => $structureLinks,
            'settings' => array(
                'header' => __($mainHeader, null),
                'language_heading' => __($eventType, null),
                'actions' => false
            ),
            'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listallBasedOnControlId/' . $atimMenuVariables['Participant.id'] . "/$eventControlId/$intervalStartDate/$intervalStartDateAccuracy/$intervalFinishDate/$intervalFinishDateAccuracy")
        );
        $this->Structures->build($finalAtimStructure, $finalOptions);
        $mainHeader = null;
    }
    // ------------------------------------------------------------------------------
    // Treatment
    // ------------------------------------------------------------------------------
    // linked treatments
    $mainHeader = 'treatment';
    foreach ($linkedTxControlData as $newTxControl) {
        $treatmentControlId = $newTxControl['TreatmentControl']['id'];
        $finalAtimStructure = array();
        $finalOptions = array(
            'type' => 'detail',
            'links' => $structureLinks,
            'settings' => array(
                'header' => __($mainHeader, null),
                'language_heading' => __('treatments', null),
                'actions' => false
            ),
            'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listallBasedOnControlId/' . $atimMenuVariables['Participant.id'] . "/$treatmentControlId/$intervalStartDate/$intervalStartDateAccuracy/$intervalFinishDate/$intervalFinishDateAccuracy")
        );
    }
}

// To not display Related Diagnosis Event and Linked Collections
$isAjax = true;
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;