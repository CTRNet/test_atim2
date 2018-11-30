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