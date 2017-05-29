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

    public $registered_view = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'SpecimenReviewMaster.id'
        )
    );

    function allowSpecimeReviewDeletion($specimen_review_id)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}