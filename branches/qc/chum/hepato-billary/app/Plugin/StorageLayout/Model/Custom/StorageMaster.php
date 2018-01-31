<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        if ($typeKey == 'AliquotMaster')
            $labelKey = 'aliquot_label';
        return $childrenArray[$typeKey][$labelKey];
    }
}