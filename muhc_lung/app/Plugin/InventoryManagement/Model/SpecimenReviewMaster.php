<?php

/**
 * Class SpecimenReviewMaster
 */
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

    /**
     *
     * @param $specimenReviewId
     * @return array
     */
    public function allowSpecimeReviewDeletion($specimenReviewId)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}