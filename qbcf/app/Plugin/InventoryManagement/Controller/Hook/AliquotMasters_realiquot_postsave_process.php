<?php

// --------------------------------------------------------------------------------
// Regenerate default barcodes
// --------------------------------------------------------------------------------
$this->AliquotMaster->regenerateAliquotBarcode();

// -------------------------------------------------------------------------------
// Generate block, slide and core aliquot label
// -------------------------------------------------------------------------------
$linkedCollectionIds = array();
$tmpCollectionIds = $this->AliquotMaster->find('all', array(
    'conditions' => array(
        'AliquotMaster.id' => explode(",", $parentAliquotsIds)
    ),
    'fields' => 'DISTINCT collection_id',
    'recursive' => - 1
));
foreach ($tmpCollectionIds as $aliquotsCollectionId)
    $linkedCollectionIds[] = $aliquotsCollectionId['AliquotMaster']['collection_id'];
$this->AliquotMaster->updateAliquotLabel($linkedCollectionIds);

// -------------------------------------------------------------------------------
// Check duplicated patho id +block id
// -------------------------------------------------------------------------------
if ($childAliquotCtrl['AliquotControl']['aliquot_type'] == 'block') {
    // Block to block
    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}