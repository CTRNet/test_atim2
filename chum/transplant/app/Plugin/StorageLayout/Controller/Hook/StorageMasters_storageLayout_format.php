<?php
if ($storageData['StorageControl']['detail_tablename'] == 'std_tma_blocks') {
    // Get Tissue Core Natures
    $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
    $tissueCoreNatures = $StructurePermissibleValuesCustom->getCustomDropdown(array(
        'Tissue Core Natures'
    ));
    $tissueCoreNatures = array_replace($tissueCoreNatures['defined'], $tissueCoreNatures['previously_defined']);
    
    // Format Core Label For Display
    $formatedCoreLabels = array();
    $tmpAliquotData = $this->AliquotMaster->find('all', array(
        'conditions' => array(
            'AliquotMaster.storage_master_id' => $storageMasterId
        ),
        'recursive' => 0
    ));
    foreach ($tmpAliquotData as $tmpNewAliquot) {
        if ($tmpNewAliquot['SampleControl']['sample_type'] == 'tissue' && $tmpNewAliquot['AliquotControl']['aliquot_type'] == 'core') {
            $isConrol = $tmpNewAliquot['Collection']['acquisition_label'] == 'TMA Controls' ? true : false;
            $newCoreLabel = ($isConrol ? 'Ctrl: ' : '') . $tmpNewAliquot['AliquotMaster']['aliquot_label'] . ($isConrol ? '' : ' [' . (array_key_exists($tmpNewAliquot['AliquotDetail']['qc_nd_core_nature'], $tissueCoreNatures) ? $tissueCoreNatures[$tmpNewAliquot['AliquotDetail']['qc_nd_core_nature']] : (empty($tmpNewAliquot['AliquotDetail']['qc_nd_core_nature']) ? '?' : $tmpNewAliquot['AliquotDetail']['qc_nd_core_nature'])) . ']');
            $formatedCoreLabels[$tmpNewAliquot['AliquotMaster']['id']] = $newCoreLabel;
        }
    }
    
    // Replace the DisplayData.label for core
    foreach ($data['children'] as &$tmpChildren) {
        if ($tmpChildren['DisplayData']['type'] == 'AliquotMaster' && array_key_exists($tmpChildren['AliquotMaster']['id'], $formatedCoreLabels)) {
            $tmpChildren['DisplayData']['label'] = $formatedCoreLabels[$tmpChildren['AliquotMaster']['id']];
        }
    }
}