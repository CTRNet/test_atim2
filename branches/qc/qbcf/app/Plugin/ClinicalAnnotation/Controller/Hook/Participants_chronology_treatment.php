<?php
$event = __('treatment') . " - " . __($tx['TreatmentControl']['tx_method']);
$chronologyDetails = '';
switch ($tx['TreatmentControl']['tx_method']) {
    case 'chemotherapy':
    case 'hormonotherapy':
    case 'immunotherapy':
    case 'bone specific therapy':
        $allLinkedDrugs = $treatmentExtendModel->find('all', array(
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
        if ($drugs)
            $chronologyDetails = implode(' + ', $drugs);
        break;
    case 'other cancer':
        $chronologyDetails = $otherCancerTx[$tx['TreatmentDetail']['type']];
        break;
    case 'breast diagnostic event':
        $chronologyDetails = $beastDxIntervention[$tx['TreatmentDetail']['type_of_intervention']] . (strlen($tx['TreatmentDetail']['laterality']) ? ' - ' . $qbcfDxLaterality[$tx['TreatmentDetail']['laterality']] : '');
        break;
}

$chronolgyDataTreatmentStart['event'] = $event . " (" . __("start") . ")";
if ($chronologyDetails)
    $chronolgyDataTreatmentStart['chronology_details'] = $chronologyDetails;
if ($chronolgyDataTreatmentFinish) {
    $chronolgyDataTreatmentFinish['event'] = $event . " (" . __("end") . ")";
    $chronolgyDataTreatmentFinish['chronology_details'] = $chronologyDetails;
}