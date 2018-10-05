<?php
$lastStorageMasterUsed = $this->AliquotMaster->find('first', array(
    'conditions' => array(
        'AliquotMaster.storage_master_id IS NOT NULL'
    ),
    'order' => array(
        'AliquotMaster.created desc'
    ),
    'recursive' => 0
));
$recordedStorageSelectionLabel = null;
if ($lastStorageMasterUsed) {
    $recordedStorageSelectionLabel = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array(
        'StorageMaster' => $lastStorageMasterUsed['StorageMaster']
    ));
}
foreach ($this->request->data as &$newSampleRecord) {
    if (isset($defaultAliquotLabels[$newSampleRecord['parent']['ViewSample']['sample_master_id']])) {
        $labelNbrPrefix = $defaultAliquotLabels[$newSampleRecord['parent']['ViewSample']['sample_master_id']]['label_nbr_prefix'];
        $nbrOfAliquots = sizeof($newSampleRecord['children']);
        $aliquotCounter = 0;
        foreach ($newSampleRecord['children'] as &$newAliquotRecord) {
            $aliquotCounter ++;
            $newAliquotRecord['AliquotMaster']['chum_kidney_transp_aliquot_nbr'] = (strlen($labelNbrPrefix) ? "$labelNbrPrefix " : "") . "$aliquotCounter/$nbrOfAliquots";
        }
    }
    if ($recordedStorageSelectionLabel) {
        $newAliquotRecord['FunctionManagement']['recorded_storage_selection_label'] = $recordedStorageSelectionLabel;
    }
}