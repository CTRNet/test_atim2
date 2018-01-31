<?php
$txControlData = $this->TreatmentControl->find('first', array(
    'conditions' => array(
        'TreatmentControl.id' => $txExtendData['TreatmentMaster']['treatment_control_id']
    )
));
$atimMenu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
$atimMenu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atimMenu, $txControlData['TreatmentControl']['detail_tablename']);
$this->set('atimMenu', $atimMenu);