<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        // USE THIS TO OVERRIDE THE DEFAULT LABEL
        if ($typeKey == 'AliquotMaster') {
            if (! empty($childrenArray['AliquotMaster']['aliquot_label'])) {
                return $childrenArray['AliquotMaster']['aliquot_label'] . ' (' . $childrenArray['AliquotMaster']['barcode'] . ')';
            } else {
                return $childrenArray['AliquotMaster']['barcode'];
            }
        }
        return parent::getLabel($childrenArray, $typeKey, $labelKey);
    }
}