<?php
$eocFlag = ($tx['TreatmentControl']['disease_site'] == 'EOC') ? ' [' . __('EOC') . ']' : '';

switch ($tx['TreatmentControl']['tx_method']) {
    case 'chemotherapy':
        // Set event
        $event = __($tx['TreatmentControl']['tx_method']);
        $chronolgyDataTreatmentStart['event'] = $event . $eocFlag . ' ' . $startSuffixMsg;
        if ($chronolgyDataTreatmentFinish) {
            $chronolgyDataTreatmentFinish['event'] = $event . $eocFlag . ' ' . $finishSuffixMsg;
        }
        // Set details
        $allLinkedDrugs = $this->TreatmentExtendMaster->find('all', array(
            'conditions' => array(
                'TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']
            )
        ));
        $drugs = array();
        foreach ($allLinkedDrugs as $newDrug) {
            if ($newDrug['TreatmentExtendMaster']['drug_id']) {
                $drugs[$newDrug['TreatmentExtendMaster']['drug_id']] = $newDrug['Drug']['generic_name'];
            }
        }
        if ($drugs) {
            $chronolgyDataTreatmentStart['chronology_details'] = implode(' + ', $drugs);
            if ($chronolgyDataTreatmentFinish) {
                if ($drugs)
                    $chronolgyDataTreatmentFinish['chronology_details'] = implode(' + ', $drugs);
            }
        }
        break;
    case 'radiotherapy':
    case 'surgery':
        // Set event
        $chronolgyDataTreatmentStart['event'] = __($tx['TreatmentControl']['tx_method']) . $eocFlag;
        break;
    case 'ovarectomy':
    case 'hormonal therapy':
        // Set event
        $chronolgyDataTreatmentStart['event'] = __($tx['TreatmentControl']['tx_method']);
        break;
}