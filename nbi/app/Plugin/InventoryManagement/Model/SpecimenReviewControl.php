<?php

/**
 * Class SpecimenReviewControl
 */
class SpecimenReviewControl extends InventoryManagementAppModel
{

    public $masterFormAlias = 'specimen_review_masters';

    public $belongsTo = array(
        'AliquotReviewControl' => array(
            'className' => 'InventoryManagement.AliquotReviewControl',
            'foreignKey' => 'aliquot_review_control_id'
        ),
        'SampleControl' => array(
            'className' => 'InventoryManagement.SampleControl',
            'foreignKey' => 'sample_control_id'
        )
    );

    /**
     * Get permissible values array gathering all existing specimen type of reviews.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSpecimenTypePermissibleValues()
    {
        $result = array();
        
        foreach ($this->find('all', array(
            'conditions' => array(
                'SpecimenReviewControl.flag_active' => 1
            )
        )) as $newControl) {
            $result[$newControl['SpecimenReviewControl']['sample_control_id']] = __($newControl['SampleControl']['sample_type']);
        }
        
        return $result;
    }

    /**
     * Get permissible values array gathering all existing specimen review type.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getReviewTypePermissibleValues()
    {
        $result = array();
        
        foreach ($this->find('all', array(
            'conditions' => array(
                'SpecimenReviewControl.flag_active' => 1
            )
        )) as $newControl) {
            $result[$newControl['SpecimenReviewControl']['review_type']] = __($newControl['SpecimenReviewControl']['review_type']);
        }
        
        return $result;
    }
}