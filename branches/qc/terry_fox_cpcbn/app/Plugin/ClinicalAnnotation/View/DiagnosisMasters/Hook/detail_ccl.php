<?php
if (isset($diseaseFreeStartTrtId)) {
    $finalOptionsSurvivalEvent['settings']['header'] = __('disease free survival start event');
    $finalOptionsSurvivalEvent['settings']['actions'] = false;
    if ($diseaseFreeStartTrtId != '-1') {
        $finalOptionsSurvivalEvent['extras'] = $this->Structures->ajaxIndex('/ClinicalAnnotation/TreatmentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $diseaseFreeStartTrtId . '/noActions:/filterModel:DiagnosisMaster/filterId:' . $atimMenuVariables['DiagnosisMaster.id']);
        $finalOptions['links']['bottom']['disease free survival start event'] = '/ClinicalAnnotation/TreatmentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $diseaseFreeStartTrtId;
    }
    $this->Structures->build(array(), $finalOptionsSurvivalEvent);
}

if (isset($diseaseFreeEndBcrId)) {
    $finalOptionsSurvivalBcr['settings']['header'] = __('first biochemical recurrence');
    $finalOptionsSurvivalBcr['settings']['actions'] = false;
    if ($diseaseFreeEndBcrId != '-1') {
        $finalOptionsSurvivalBcr['extras'] = $this->Structures->ajaxIndex('/ClinicalAnnotation/DiagnosisMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $diseaseFreeEndBcrId . '/noActions:/filterModel:DiagnosisMaster/filterId:' . $atimMenuVariables['DiagnosisMaster.id']);
        $finalOptions['links']['bottom']['first biochemical recurrence'] = '/ClinicalAnnotation/DiagnosisMasters/detail/' . $atimMenuVariables['Participant.id'] . '/' . $diseaseFreeEndBcrId;
    }
    $this->Structures->build(array(), $finalOptionsSurvivalBcr);
}