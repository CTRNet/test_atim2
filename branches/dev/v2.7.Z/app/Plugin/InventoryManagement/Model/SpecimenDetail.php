<?php

class SpecimenDetail extends InventoryManagementAppModel
{

    public $primaryKey = 'sample_master_id';

    public $registered_view = array(
        'InventoryManagement.ViewSample' => array(
            'SampleMaster.id',
            'ParentSampleMaster.id',
            'SpecimenSampleMaster.id'
        ),
        'InventoryManagement.ViewAliquot' => array(
            'AliquotMaster.sample_master_id'
        )
    );
}
