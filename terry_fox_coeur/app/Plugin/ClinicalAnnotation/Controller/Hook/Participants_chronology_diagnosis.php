<?php
switch ($dx['DiagnosisControl']['controls_type']) {
    case 'EOC':
        $chronolgyDataDiagnosis['event'] = __('EOC') . ' ' . __('primary') . ' ' . __('diagnosis');
        $chronolgyDataDiagnosis['chronology_details'] = '';
        break;
    case 'other primary cancer':
        $chronolgyDataDiagnosis['event'] = __('other primary cancer');
        $chronolgyDataDiagnosis['chronology_details'] = $qcTfTumorSiteValues[$dx['DiagnosisMaster']['qc_tf_tumor_site']];
        break;
    case 'recurrence or metastasis':
        $chronolgyDataDiagnosis['event'] = __('recurrence or metastasis');
        $details = array();
        if ($dx['DiagnosisMaster']['qc_tf_tumor_site'] && $dx['DiagnosisMaster']['qc_tf_tumor_site'] != 'unknown') {
            $details[] = $qcTfTumorSiteValues[$dx['DiagnosisMaster']['qc_tf_tumor_site']];
        }
        if ($dx['DiagnosisMaster']['qc_tf_progression_detection_method'] && ! in_array($dx['DiagnosisMaster']['qc_tf_progression_detection_method'], array(
            'unknown',
            'not applicable'
        ))) {
            $details[] = __('method') . ' : ' . $qcTfProgressionDetectionMethodValues[$dx['DiagnosisMaster']['qc_tf_progression_detection_method']];
        }
        $chronolgyDataDiagnosis['chronology_details'] = implode(' || ', $details);
        break;
    default:
}