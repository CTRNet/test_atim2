<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        if ($typeKey == 'AliquotMaster') {
            $SampleModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
            $sampleData = $SampleModel->find('first', array(
                'conditions' => array(
                    'SampleMaster.id' => $childrenArray['AliquotMaster']['sample_master_id']
                ),
                'recursive' => 0
            ));
            return $childrenArray['AliquotMaster']['aliquot_label'] . ' [' . $childrenArray['AliquotMaster']['barcode'] . ' / ' . $sampleData['ViewSample']['qc_tf_bank_identifier'] . ']';
        }
        
        return $childrenArray[$typeKey][$labelKey];
    }
}