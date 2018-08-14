<?php
if (! $treatmentControlId && isset($controlsForSubformDisplay)) {
    // Set procure add button
    $this->set('addLinkForProcureForms', $this->Participant->buildAddProcureFormsButton($participantId));
    // Separate treatment and medication
    $tmpTreatmentControl = array();
    foreach ($controlsForSubformDisplay as $tmpKey => $tmpControl) {
        if ($tmpControl['TreatmentControl']['tx_method'] == 'treatment') {
            $tmpTreatmentControl = $tmpControl;
            unset($controlsForSubformDisplay[$tmpKey]);
        }
    }
    $tmpTreatmentControl = array(
        $tmpTreatmentControl,
        $tmpTreatmentControl
    );
    $tmpTreatmentControl[0]['TreatmentControl']['id'] .= '/procure_treatment_key';
    $tmpTreatmentControl[1]['TreatmentControl']['tx_header'] = __('medication');
    $tmpTreatmentControl[1]['TreatmentControl']['id'] .= '/procure_medication_key';
    $this->set('controlsForSubformDisplay', array_merge($controlsForSubformDisplay, $tmpTreatmentControl));
} elseif ($treatmentControlId && $treatmentControlId != '-1') {
    if (in_array('procure_treatment_key', $this->passedArgs)) {
        $searchCriteria[] = "TreatmentDetail.treatment_type NOT LIKE '%medication%'";
    } elseif (in_array('procure_medication_key', $this->passedArgs)) {
        $searchCriteria[] = "TreatmentDetail.treatment_type LIKE '%medication%'";
    }
    $this->request->data = $this->paginate($this->TreatmentMaster, $searchCriteria);
}