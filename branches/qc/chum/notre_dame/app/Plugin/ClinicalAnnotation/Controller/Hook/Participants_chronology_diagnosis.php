<?php
if ($dx['DiagnosisControl']['category'] . '-' . $dx['DiagnosisControl']['controls_type'] == 'primary-sardo') {
    if (preg_match('/^([cC][0-9]{2})\./', $dx['DiagnosisMaster']['topography'], $matches)) {
        $chronolgyDataDiagnosis['chronology_details'] = $icdO3TopoCategories[strtoupper($matches[1])];
    }
} elseif ($dx['DiagnosisControl']['category'] . '-' . $dx['DiagnosisControl']['controls_type'] == 'progression - locoregional-sardo') {
    $chronolgyDataDiagnosis['chronology_details'] = $dx['DiagnosisDetail']['detail'];
}