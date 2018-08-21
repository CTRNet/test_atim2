<?php

// ===============================================================================
// Manage structure to record the initial weight of blood tube
// ===============================================================================
$procureTubeWeightsToSave = array();
if (isset($this->request->data['AliquotMaster']['ids'])) {
    // Initial Display
    $this->ViewAliquot = AppModel::getInstance("InventoryManagement", "ViewAliquot", true);
    $sampleAliquotTypes = $this->ViewAliquot->find('all', array(
        'conditions' => array(
            'ViewAliquot.aliquot_master_id' => explode(",", $this->request->data['AliquotMaster']['ids'])
        ),
        'fields' => array(
            "DISTINCT CONCAT(ViewAliquot.sample_type, '-', ViewAliquot.aliquot_type) AS sample_aliquot_types"
        )
    ));
    if ($sampleAliquotTypes && sizeof($sampleAliquotTypes) == 1 && $sampleAliquotTypes[0][0]['sample_aliquot_types'] == 'blood-tube') {
        // Blood tube: add initial tube weight for update
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume,procure_tube_weight_for_derivative_creation', 'aliquots_volume_structure');
    }
} else {
    $resetAliquotsVolumeStructure = false;
    foreach ($this->request->data as $procureKey => &$procureData) {
        if (array_key_exists('AliquotDetail', $procureData) && array_key_exists('procure_tube_weight_gr', $procureData['AliquotDetail'])) {
            // Blood tube, add tube weight for update
            $procureTubeWeightsToSave[$procureKey] = $procureData['AliquotDetail']['procure_tube_weight_gr'];
            $resetAliquotsVolumeStructure = true;
            unset($procureData['AliquotDetail']['procure_tube_weight_gr']);
            if (empty($procureData['AliquotDetail']))
                unset($procureData['AliquotDetail']);
        }
    }
    if ($resetAliquotsVolumeStructure)
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume,procure_tube_weight_for_derivative_creation', 'aliquots_volume_structure');
}