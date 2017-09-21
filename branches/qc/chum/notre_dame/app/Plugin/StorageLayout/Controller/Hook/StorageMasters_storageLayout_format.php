<?php
if ($storage_data['StorageControl']['detail_tablename'] == 'std_tma_blocks') {
    // Get Tissue Core Natures
    $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
    $tissue_core_natures = $StructurePermissibleValuesCustom->getCustomDropdown(array(
        'Tissue Core Natures'
    ));
    $tissue_core_natures = array_replace($tissue_core_natures['defined'], $tissue_core_natures['previously_defined']);
    
    // Format Core Label For Display
    $formated_core_labels = array();
    $tmp_aliquot_data = $this->AliquotMaster->find('all', array(
        'conditions' => array(
            'AliquotMaster.storage_master_id' => $storage_master_id
        ),
        'recursive' => '0'
    ));
    foreach ($tmp_aliquot_data as $tmp_new_aliquot) {
        if ($tmp_new_aliquot['SampleControl']['sample_type'] == 'tissue' && $tmp_new_aliquot['AliquotControl']['aliquot_type'] == 'core') {
            $is_conrol = $tmp_new_aliquot['Collection']['acquisition_label'] == 'TMA Controls' ? true : false;
            $new_core_label = ($is_conrol ? 'Ctrl: ' : '') . $tmp_new_aliquot['AliquotMaster']['aliquot_label'] . ($is_conrol ? '' : ' [' . (array_key_exists($tmp_new_aliquot['AliquotDetail']['qc_nd_core_nature'], $tissue_core_natures) ? $tissue_core_natures[$tmp_new_aliquot['AliquotDetail']['qc_nd_core_nature']] : (empty($tmp_new_aliquot['AliquotDetail']['qc_nd_core_nature']) ? '?' : $tmp_new_aliquot['AliquotDetail']['qc_nd_core_nature'])) . ']');
            $formated_core_labels[$tmp_new_aliquot['AliquotMaster']['id']] = $new_core_label;
        }
    }
    
    // Replace the DisplayData.label for core
    foreach ($data['children'] as &$tmp_children) {
        if ($tmp_children['DisplayData']['type'] == 'AliquotMaster' && array_key_exists($tmp_children['AliquotMaster']['id'], $formated_core_labels)) {
            $tmp_children['DisplayData']['label'] = $formated_core_labels[$tmp_children['AliquotMaster']['id']];
        }
    }
}
	