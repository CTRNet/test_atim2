<?php
if (! is_null($redefinedPrimaryControlId) && empty($this->request->data) && ($dxMasterData['DiagnosisControl']['controls_type'] == 'ovary') && empty($dxMasterData['DiagnosisMaster']['ohri_tumor_site'])) {
    $this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET ohri_tumor_site = 'Female Genital-Ovary' WHERE id = $diagnosisMasterId;");
    $dxMasterData['DiagnosisMaster']['ohri_tumor_site'] = "Female Genital-Ovary";
}