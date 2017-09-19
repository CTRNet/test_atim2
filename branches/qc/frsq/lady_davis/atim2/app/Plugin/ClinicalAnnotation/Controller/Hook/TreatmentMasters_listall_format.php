<?php
if ($treatmentControlId && $treatmentControlId > 0) {
    $this->Structures->set($controlData['TreatmentControl']['form_alias'] . ',qc_lady_treatmentmasters_precisions');
} else {
    $this->Structures->set('treatmentmasters,qc_lady_treatmentmasters_precisions');
}

$this->StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
$this->Drug = AppModel::getInstance('Drug', 'Drug', true);
foreach ($this->request->data as &$newTreatment) {
    $newTreatment['Generated']['qc_lady_treatment_precisions'] = '';
    if ($newTreatment['TreatmentControl']['treatment_extend_control_id']) {
        $allNewTreatmentExtends = $this->TreatmentExtendMaster->find('all', array(
            'conditions' => array(
                'TreatmentExtendMaster.treatment_master_id' => $newTreatment['TreatmentMaster']['id']
            )
        ));
        $generatedNewTreatmentPrecisions = array();
        $isDrug = false;
        foreach ($allNewTreatmentExtends as $newTreatmentExtend) {
            $tmpPrecision = '';
            switch ($newTreatment['TreatmentControl']['tx_method']) {
                case 'biopsy':
                    $tmpPrecision = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Biopsy Procedure', $newTreatmentExtend['TreatmentExtendDetail']['biopsy_procedure']);
                    break;
                case 'radiation':
                    $tmpPrecision = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Radiation Procedure', $newTreatmentExtend['TreatmentExtendDetail']['radiation_procedure']);
                    break;
                case 'surgery':
                    $tmpPrecision = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Surgical Procedure', $newTreatmentExtend['TreatmentExtendDetail']['surgical_procedure']);
                    break;
                default:
                    if (array_key_exists('drug_id', $newTreatmentExtend['TreatmentExtendMaster'])) {
                        $isDrug = true;
                        $tmpPrecision = $newTreatmentExtend['TreatmentExtendMaster']['drug_id'];
                    }
            }
            if ($tmpPrecision) {
                $generatedNewTreatmentPrecisions[$tmpPrecision] = $tmpPrecision;
            }
        }
        if ($generatedNewTreatmentPrecisions) {
            if ($isDrug) {
                $generatedNewTreatmentPrecisions = $this->Drug->find('all', array(
                    'conditions' => array(
                        'Drug.id' => $generatedNewTreatmentPrecisions
                    ),
                    'fields' => array(
                        "GROUP_CONCAT(DISTINCT Drug.generic_name SEPARATOR ' & ') as all_drugs"
                    ),
                    'order' => 'Drug.generic_name'
                ));
                if ($generatedNewTreatmentPrecisions) {
                    $newTreatment['Generated']['qc_lady_treatment_precisions'] = $generatedNewTreatmentPrecisions[0][0]['all_drugs'];
                }
            } else {
                ksort($generatedNewTreatmentPrecisions);
                $newTreatment['Generated']['qc_lady_treatment_precisions'] = implode(' & ', $generatedNewTreatmentPrecisions);
            }
        }
    }
}