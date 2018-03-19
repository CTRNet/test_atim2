<?php
if ($txControlData['TreatmentControl']['tx_method'] == 'RP') {
    $participantRPs = $this->TreatmentMaster->find('count', array(
        'conditions' => array(
            'TreatmentMaster.participant_id' => $participantId,
            'TreatmentControl.id' => $txControlId
        )
    ));
    if ($participantRPs) {
        $this->atimFlashError(__('a RP can not be created twice for the same participant'), '/ClinicalAnnotation/TreatmentMasters/listall/' . $participantId);
        return;
    }
}