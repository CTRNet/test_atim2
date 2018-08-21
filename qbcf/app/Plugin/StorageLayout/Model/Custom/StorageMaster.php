<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function summary($variables = array())
    {}

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        if (isset($childrenArray[$typeKey]['qbcf_generated_label_for_display'])) {
            return $childrenArray[$typeKey]['qbcf_generated_label_for_display'];
        }
        return $childrenArray[$typeKey][$labelKey];
    }
}