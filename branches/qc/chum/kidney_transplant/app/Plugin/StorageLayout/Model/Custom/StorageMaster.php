<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        // USE THIS TO OVERRIDE THE DEFAULT LABEL
        if ($typeKey == 'AliquotMaster' && $childrenArray[$typeKey]['aliquot_label']) {
            return $childrenArray[$typeKey]['aliquot_label'] . (strlen($childrenArray[$typeKey]['chum_kidney_transp_aliquot_nbr'])? ' ' . $childrenArray[$typeKey]['chum_kidney_transp_aliquot_nbr'] : '');
        }
        return parent::getLabel($childrenArray, $typeKey, $labelKey);
    }
}