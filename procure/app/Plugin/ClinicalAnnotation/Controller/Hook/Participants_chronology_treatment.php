<?php
switch ($tx['TreatmentControl']['tx_method']) {
    case 'treatment':
        $treatmentType = $procureTreatmentTypesValues[$tx['TreatmentDetail']['treatment_type']];
        $treatmentDetailProperties = array(
            array(
                'TreatmentDetail',
                'treatment_precision',
                $procureTreatmentPrecisionValues
            ),
            array(
                'TreatmentDetail',
                'surgery_type',
                $procureSurgeryTypeValues
            ),
            array(
                'TreatmentDetail',
                'treatment_site',
                $procureTreatmentSiteValues
            ),
            array(
                'Drug',
                'generic_name',
                null
            )
        );
        $treatmentDetails = array();
        foreach ($treatmentDetailProperties as $newDetail) {
            list ($model, $field, $lists) = $newDetail;
            if ($lists) {
                $treatmentDetails[] = $lists[$tx[$model][$field]];
            } else {
                $treatmentDetails[] = $tx[$model][$field];
            }
        }
        $treatmentDetails = array_filter($treatmentDetails);
        $treatmentDetails = implode(' - ', $treatmentDetails);
        $chronolgyDataTreatmentStart['event'] = "$treatmentType $startSuffixMsg";
        $chronolgyDataTreatmentStart['chronology_details'] = $treatmentDetails;
        if (isset($tx['TreatmentDetail']['surgery_type']) && $tx['TreatmentDetail']['surgery_type'] == 'prostatectomy') {
            $tmpDate = strlen($chronolgyDataTreatmentStart['date']) ? substr($chronolgyDataTreatmentStart['date'], 0, ($chronolgyDataTreatmentStart['date_accuracy'] == 'c' ? 10 : ($chronolgyDataTreatmentStart['date_accuracy'] == 'd' ? 7 : 4))) : '?';
            $procureChronologyWarnings[$tmpDate][] = $tmpDate . ' - ' . __('prostatectomy');
        }
        if ($chronolgyDataTreatmentFinish) {
            $chronolgyDataTreatmentFinish['event'] = "$treatmentType $finishSuffixMsg";
            $chronolgyDataTreatmentFinish['chronology_details'] = $treatmentDetails;
        }
        break;
}