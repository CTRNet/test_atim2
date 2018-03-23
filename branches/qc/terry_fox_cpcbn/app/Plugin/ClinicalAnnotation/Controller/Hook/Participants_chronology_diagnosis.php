<?php
$chronolgyDataDiagnosis['event'] = __($dx['DiagnosisControl']['category']) . ' - ' . __($dx['DiagnosisControl']['controls_type']);
switch ($dx['DiagnosisControl']['category'] . '-' . $dx['DiagnosisControl']['controls_type']) {
    case 'secondary - distant-other':
        $chronolgyDataDiagnosis['chronology_details'] = __($dx['DiagnosisDetail']['site']);
        break;
    case 'recurrence - locoregional-biochemical recurrence':
        if ($dx['DiagnosisDetail']['first_biochemical_recurrence']) {
            $chronolgyDataDiagnosis['chronology_details'] = __('first biochemical recurrence');
        }
        break;
}