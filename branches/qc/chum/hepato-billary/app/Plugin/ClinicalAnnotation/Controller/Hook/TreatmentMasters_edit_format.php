<?php
$atimMenu = $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/preOperativeDetail/%%Participant.id%%/%%TreatmentMaster.id%%');
$atimMenu = $this->TreatmentMaster->inactivatePreOperativeDataMenu($atimMenu, $treatmentMasterData['TreatmentControl']['detail_tablename']);
$this->set('atimMenu', $atimMenu);