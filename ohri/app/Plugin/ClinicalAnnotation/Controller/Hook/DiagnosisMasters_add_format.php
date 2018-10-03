<?php

// --------------------------------------------------------------------------------
// Set default value
// --------------------------------------------------------------------------------
if (empty($this->request->data) && ($dxControlData['DiagnosisControl']['controls_type'] == 'ovary'))
    $this->set('defaultOhriTumorSite', 'Female Genital-Ovary');