<?php

// -------------------------------------------------------------------------------
// Generate block, slide and core aliquot label
// -------------------------------------------------------------------------------
$this->AliquotMaster->updateAliquotLabel(array(
    $collectionId
));

// -------------------------------------------------------------------------------
// Check duplicated patho id +block id
// -------------------------------------------------------------------------------
if ($aliquotData['AliquotControl']['aliquot_type'] == 'block' && isset($this->request->data['AliquotDetail']['patho_dpt_block_code'])) {
    $conditions = array(
        'AliquotMaster.aliquot_label' => $aliquotData['Collection']['qbcf_pathology_id'] . ' ' . $this->request->data['AliquotDetail']['patho_dpt_block_code'],
        'AliquotMaster.aliquot_control_id' => $aliquotData['AliquotControl']['id']
    );
    if ($this->AliquotMaster->find('count', array(
        'conditions' => $conditions,
        'recursive' => - 1
    )) > 1) {
        AppController::addWarningMsg(__('more than one block have the same aliquot label [%s] - please validate', $aliquotData['Collection']['qbcf_pathology_id'] . ' ' . $this->request->data['AliquotDetail']['patho_dpt_block_code']));
    }
}