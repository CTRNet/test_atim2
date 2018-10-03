<?php
if (isset($this->request->data['DiagnosisMaster']['ohri_tumor_site']) && ($this->request->data['DiagnosisMaster']['ohri_tumor_site'] == "Female Genital-Ovary") && ($dxControlData['DiagnosisControl']['controls_type'] != 'ovary')) {
    $this->DiagnosisMaster->validationErrors['ohri_tumor_site'][] = "use diagnosis ohri - ovary diagnosis type to record ovarian tumor";
    $submittedDataValidates = false;
}

$this->DiagnosisMaster->addWritableField(array(
    'ohri_tumor_site'
));