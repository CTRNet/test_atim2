<?php

// ===============================================================================
// Manage structure to record the initial weight of blood tube
// ===============================================================================
$procure_tube_weights_to_save = array();
if (isset($this->request->data['AliquotMaster']['ids'])) {
    // Initial Display
    $this->ViewAliquot = AppModel::getInstance("InventoryManagement", "ViewAliquot", true);
    $sample_aliquot_types = $this->ViewAliquot->find('all', array(
        'conditions' => array(
            'ViewAliquot.aliquot_master_id' => explode(",", $this->request->data['AliquotMaster']['ids'])
        ),
        'fields' => array(
            "DISTINCT CONCAT(ViewAliquot.sample_type, '-', ViewAliquot.aliquot_type) AS sample_aliquot_types"
        )
    ));
    if ($sample_aliquot_types && sizeof($sample_aliquot_types) == 1 && $sample_aliquot_types[0][0]['sample_aliquot_types'] == 'blood-tube') {
        // Blood tube: add initial tube weight for update
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume,procure_tube_weight_for_derivative_creation', 'aliquots_volume_structure');
    }
} else {
    $reset_aliquots_volume_structure = false;
    foreach ($this->request->data as $procure_key => &$procure_data) {
        if (array_key_exists('AliquotDetail', $procure_data) && array_key_exists('procure_tube_weight_gr', $procure_data['AliquotDetail'])) {
            // Blood tube, add tube weight for update
            $procure_tube_weights_to_save[$procure_key] = $procure_data['AliquotDetail']['procure_tube_weight_gr'];
            $reset_aliquots_volume_structure = true;
            unset($procure_data['AliquotDetail']['procure_tube_weight_gr']);
            if (empty($procure_data['AliquotDetail']))
                unset($procure_data['AliquotDetail']);
        }
    }
    if ($reset_aliquots_volume_structure)
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume,procure_tube_weight_for_derivative_creation', 'aliquots_volume_structure');
}

?>