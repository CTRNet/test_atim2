<?php

/**
 * Model developped to be able to list both:
 * - TMA blocks of a slides set.
 * - Storages that contains TMA slides.
 * See issue#3283 : Be able to search storages that contain TMA slide into the databrowser 
 */
class NonTmaBlockStorage extends StorageLayoutAppModel
{

    public $useTable = 'view_storage_masters';

    /**
     * @param array $queryData
     * @return array
     */
    public function beforeFind($queryData)
    {
        if (! is_array($queryData['conditions']))
            $queryData['conditions'] = array(
                $queryData['conditions']
            );
        $queryData['conditions'][] = "NonTmaBlockStorage.is_tma_block = '0'";
        return $queryData;
    }
}