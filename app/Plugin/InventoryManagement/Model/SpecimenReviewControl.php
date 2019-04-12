<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

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