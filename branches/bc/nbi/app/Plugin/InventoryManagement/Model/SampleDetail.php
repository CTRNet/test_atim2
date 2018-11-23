<?php

/**
 * Class SampleDetail
 */
class SampleDetail extends InventoryManagementAppModel
{

    public $useTable = false;

    /**
     *
     * @return array
     */
    public function getTissueSourcePermissibleValues()
    {
        return array();
    }
}