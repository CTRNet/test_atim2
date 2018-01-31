<?php
$atimMenu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
$atimMenu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atimMenu, $txMasterData['TreatmentControl']['detail_tablename']);
$this->set('atimMenu', $atimMenu);

$isChemoComplications = false;
if (in_array('chemo_complications', $this->passedArgs)) {
    $txExtendControlData = $this->TreatmentExtendControl->find('first', array(
        'conditions' => array(
            'TreatmentExtendControl.type' => 'chemotherapy complications'
        )
    ));
    $txMasterData['TreatmentControl']['treatment_extend_control_id'] = $txExtendControlData['TreatmentExtendControl']['id'];
    $this->Structures->set($txExtendControlData['TreatmentExtendControl']['form_alias']);
    $isChemoComplications = true;
}
$this->set('isChemoComplications', $isChemoComplications);