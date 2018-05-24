<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        // USE THIS TO OVERRIDE THE DEFAULT LABEL
        if ($typeKey == 'AliquotMaster') {
            $labelKey = 'aliquot_label';
        }
        return parent::getLabel($childrenArray, $typeKey, $labelKey);
    }
}