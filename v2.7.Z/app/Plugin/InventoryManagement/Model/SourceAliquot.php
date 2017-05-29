<?php

class SourceAliquot extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'SampleMaster' => array(
            'className' => 'InventoryManagement.SampleMaster',
            'foreignKey' => 'sample_master_id'
        ),
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'aliquot_master_id'
        )
    );

    public $registered_view = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'SourceAliquot.id'
        )
    );
}