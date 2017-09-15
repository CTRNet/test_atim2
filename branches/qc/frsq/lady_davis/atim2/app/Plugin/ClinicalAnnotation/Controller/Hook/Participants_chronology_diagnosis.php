<?php
if (isset($dx['DiagnosisDetail']['qc_lady_tumor_site'])) {
    $chronolgyDataDiagnosis['chronology_details'] = isset($qcLadyTumorSite[$dx['DiagnosisDetail']['qc_lady_tumor_site']]) ? $qcLadyTumorSite[$dx['DiagnosisDetail']['qc_lady_tumor_site']] : $dx['DiagnosisDetail']['qc_lady_tumor_site'];
}