<?php
assert(isset($updateCollectionSampleLabelsWith));

// --------------------------------------------------------------------------------
// Update participant collection sample labels
// --------------------------------------------------------------------------------

// Get Bank linked to this created identifier
$bankModel = AppModel::getInstance('Administrate', 'Bank', true);
$bank = $bankModel->find('first', array(
    'conditions' => array(
        'Bank.misc_identifier_control_id' => $miscIdentifierControlId
    )
));

if (! empty($bank)) {
    $bankId = $bank['Bank']['id'];
    
    // Launch sample labels upgrade process
    $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection', true);
    $collections = $collectionModel->find('all', array(
        'conditions' => array(
            'Collection.participant_id' => $participantId,
            'Collection.bank_id' => $bankId
        )
    ));
    
    foreach ($collections as $newLinkedCollection) {
        $collectionModel->updateCollectionSampleLabels($newLinkedCollection['Collection']['id'], $updateCollectionSampleLabelsWith);
    }
}