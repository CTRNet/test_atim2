<?php
if ($isImagingEventControl) {
    $isImagingEventControl = false;
    foreach ($finalAtimStructure['Sfs'] as $sfsKey => &$sfsFieldData) {
        if (isset($sfsFieldData['StructureValueDomain']['domain_name']) && $sfsFieldData['StructureValueDomain']['domain_name'] == 'qc_lady_tumor_participant_diagnosis_selection') {
            $sfsFieldData['StructureValueDomain']['source'] .= "('" . $atimMenuVariables['Participant.id'] . "')";
            $finalOptions['settings']['actions'] = true;
            $finalOptions['settings']['form_bottom'] = true;
            $isImagingEventControl = true;
        }
    }
}