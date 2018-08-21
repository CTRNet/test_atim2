<?php

// --------------------------------------------------------------------------------
// Regenerate default barcodes
// --------------------------------------------------------------------------------
$this->AliquotMaster->regenerateAliquotBarcode();

// -------------------------------------------------------------------------------
// Generate block, slide and core aliquot label
// -------------------------------------------------------------------------------
$linkedCollectionIds = array();
foreach ($this->request->data as $createdAliquots)
    $linkedCollectionIds[] = $createdAliquots['parent']['ViewSample']['collection_id'];
$this->AliquotMaster->updateAliquotLabel($linkedCollectionIds);

// -------------------------------------------------------------------------------
// Check duplicated patho id +block id
// -------------------------------------------------------------------------------
if ($aliquotControl['AliquotControl']['aliquot_type'] == 'block') {
    foreach ($this->request->data as $createdAliquots) {
        foreach ($createdAliquots['children'] as $newAliquot) {
            if (isset($newAliquot['AliquotDetail']['patho_dpt_block_code'])) {
                $conditions = array(
                    'AliquotMaster.aliquot_label' => $createdAliquots['parent']['ViewSample']['qbcf_pathology_id'] . ' ' . $newAliquot['AliquotDetail']['patho_dpt_block_code'],
                    'AliquotMaster.aliquot_control_id' => $aliquotControl['AliquotControl']['id']
                );
                if ($this->AliquotMaster->find('count', array(
                    'conditions' => $conditions,
                    'recursive' => - 1
                )) > 1) {
                    AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', $createdAliquots['parent']['ViewSample']['qbcf_pathology_id'] . ' ' . $newAliquot['AliquotDetail']['patho_dpt_block_code']));
                }
            }
        }
    }
}