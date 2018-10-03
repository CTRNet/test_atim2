<?php

class TreatmentControlCustom extends TreatmentControl
{

    var $useTable = 'treatment_controls';

    var $name = 'TreatmentControl';

    public function getAddLinks($participantId, $diagnosisMasterId = '')
    {
        $treatmentControls = $this->find('all', array(
            'conditions' => array(
                'TreatmentControl.flag_active' => 1
            )
        ));
        foreach ($treatmentControls as $treatmentControl) {
            $trtHeader = __($treatmentControl['TreatmentControl']['tx_method']);
            $addLinks[$trtHeader] = '/ClinicalAnnotation/TreatmentMasters/add/' . $participantId . '/' . $treatmentControl['TreatmentControl']['id'] . '/' . $diagnosisMasterId;
        }
        ksort($addLinks);
        return $addLinks;
    }
}