<?php

/**
 * Class Realiquoting
 */
class Realiquoting extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'parent_aliquot_master_id'
        ),
        'AliquotMasterChildren' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'child_aliquot_master_id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'Realiquoting.id'
        )
    );
}