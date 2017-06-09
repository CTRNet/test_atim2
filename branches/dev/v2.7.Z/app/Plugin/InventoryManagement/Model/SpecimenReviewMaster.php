<?php

class SpecimenReviewMaster extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'SpecimenReviewControl' => array(
            'className' => 'InventoryManagement.SpecimenReviewControl',
            'foreignKey' => 'specimen_review_control_id',
            'type' => 'INNER'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'SpecimenReviewMaster.id'
        )
    );

    function allowSpecimeReviewDeletion($specimenReviewId)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}