<?php
$tmpDate = strlen($chronolgyDataAnnotation['date']) ? substr($chronolgyDataAnnotation['date'], 0, ($chronolgyDataAnnotation['date_accuracy'] == 'c' ? 10 : ($chronolgyDataAnnotation['date_accuracy'] == 'd' ? 7 : 4))) : '?';

switch ($annotation['EventControl']['event_type']) {
    case 'questionnaire':
        $chronolgyDataAnnotation['date'] = $annotation['EventDetail']['recovery_date'];
        $chronolgyDataAnnotation['date_accuracy'] = $annotation['EventDetail']['recovery_date_accuracy'];
        $chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
        break;
    case 'prostate cancer - diagnosis':
        $chronolgyDataAnnotation['date'] = $annotation['EventDetail']['biopsy_pre_surgery_date'];
        $chronolgyDataAnnotation['date_accuracy'] = $annotation['EventDetail']['biopsy_pre_surgery_date_accuracy'];
        $chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
        break;
    case 'laboratory':
        $labData = array();
        if (strlen($annotation['EventDetail']['psa_total_ngml']) || $annotation['EventDetail']['biochemical_relapse'] == 'y') {
            $tmpAnnotation = $chronolgyDataAnnotation;
            $tmpAnnotation['event'] = __('psa') . ' ' . __('total ng/ml');
            $chronologyDetails = array();
            $chronologyDetails[] = strlen($annotation['EventDetail']['psa_total_ngml']) ? $annotation['EventDetail']['psa_total_ngml'] : '?';
            if ($annotation['EventDetail']['biochemical_relapse'] == 'y') {
                $chronologyDetails[] = '(' . __('biochemical relapse') . ')';
                $procureChronologyWarnings[$tmpDate][] = $tmpDate . ' - ' . __('biochemical relapse');
            }
            $tmpAnnotation['chronology_details'] = implode(' ', $chronologyDetails);
            $labData[] = $tmpAnnotation;
        }
        if (strlen($annotation['EventDetail']['testosterone_nmoll'])) {
            $tmpAnnotation = $chronolgyDataAnnotation;
            $tmpAnnotation['event'] = __('testosterone - nmol/l');
            $tmpAnnotation['chronology_details'] = $annotation['EventDetail']['testosterone_nmoll'];
            $labData[] = $tmpAnnotation;
        }
        while (sizeof($labData) > 1) {
            $addToTmpArray(array_shift($labData));
        }
        $chronolgyDataAnnotation = array_shift($labData);
        break;
    case 'clinical exam':
        $examData = array();
        // Add Exam
        $examType = $procureExamTypesValues[$annotation['EventDetail']['type']];
        $examPrecision = $clinicalExamSiteValues[$annotation['EventDetail']['site_precision']];
        $examResult = $procureExamResultsValues[$annotation['EventDetail']['results']];
        $chronolgyDataAnnotation['event'] = $examType . (strlen($examPrecision) ? ' - ' . $examPrecision : '');
        $chronolgyDataAnnotation['chronology_details'] = $examResult;
        $examData[] = $chronolgyDataAnnotation;
        // Add progression
        if (strlen($annotation['EventDetail']['progression_comorbidity']) || $annotation['EventDetail']['clinical_relapse'] == 'y') {
            $chronolgyDataAnnotation['event'] = __('progression / comorbidity');
            $chronolgyDataAnnotation['chronology_details'] = $procureProgressionsComorbiditiesValues[$annotation['EventDetail']['progression_comorbidity']];
            if ($annotation['EventDetail']['clinical_relapse'] == 'y') {
                $chronolgyDataAnnotation['event'] = __('clinical relapse');
                $procureChronologyWarnings[$tmpDate][] = $tmpDate . ' - ' . $chronolgyDataAnnotation['event'] . (strlen($chronolgyDataAnnotation['chronology_details']) ? ' - ' . $chronolgyDataAnnotation['chronology_details'] : '');
            }
            $examData[] = $chronolgyDataAnnotation;
        }
        while (sizeof($examData) > 1) {
            $addToTmpArray(array_shift($examData));
        }
        $chronolgyDataAnnotation = array_shift($examData);
        break;
    case 'other tumor diagnosis':
        $chronolgyDataAnnotation['event'] = __('other tumor - diagnosis');
        $chronolgyDataAnnotation['chronology_details'] = $procureOtherTumorSitesValues[$annotation['EventDetail']['tumor_site']];
        break;
    case 'clinical note':
        $chronolgyDataAnnotation['event'] = __('clinical notes');
        $chronolgyDataAnnotation['chronology_details'] = $procureEventNoteTypeValues[$annotation['EventDetail']['type']];
        if ($annotation['EventDetail']['type'] == 'CRPC') {
            $chronolgyDataAnnotation['event'] = $procureEventNoteTypeValues[$annotation['EventDetail']['type']];
            $chronolgyDataAnnotation['chronology_details'] = '';
            $procureChronologyWarnings[$tmpDate][] = $tmpDate . ' - ' . $procureEventNoteTypeValues[$annotation['EventDetail']['type']];
        }
        break;
    case 'procure pathology report':
        $chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
    case 'visit/contact':
        $chronolgyDataAnnotation['event'] = __($annotation['EventControl']['event_type']);
        break;
}