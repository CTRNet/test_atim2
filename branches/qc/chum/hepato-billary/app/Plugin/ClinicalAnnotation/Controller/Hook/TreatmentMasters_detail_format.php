<?php
$atimMenu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
$atimMenu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atimMenu, $treatmentMasterData['TreatmentControl']['detail_tablename']);
$this->set('atimMenu', $atimMenu);

$addChemoComplication = false;
if (in_array($treatmentMasterData['TreatmentControl']['tx_method'], array(
    'chemo-embolization',
    'chemotherapy'
))) {
    $addChemoComplication = true;
    $txExtendControlData = $this->TreatmentExtendControl->find('first', array(
        'conditions' => array(
            'TreatmentExtendControl.type' => 'chemotherapy complications'
        )
    ));
    $this->set('txExtendData2', $this->TreatmentExtendMaster->find('all', array(
        'conditions' => array(
            'TreatmentExtendMaster.treatment_master_id' => $txMasterId,
            'TreatmentExtendMaster.treatment_extend_control_id' => $txExtendControlData['TreatmentExtendControl']['id']
        )
    )));
    $this->Structures->set($txExtendControlData['TreatmentExtendControl']['form_alias'], 'extend_form_alias_2');
}
$this->set('addChemoComplication', $addChemoComplication);