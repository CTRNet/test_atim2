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
 * Class RealiquotingControl
 */
class RealiquotingControl extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'ParentAliquotControl' => array(
            'className' => 'InventoryManagement.AliquotControl',
            'foreignKey' => 'parent_aliquot_control_id'
        ),
        'ChildAliquotControl' => array(
            'className' => 'InventoryManagement.AliquotControl',
            'foreignKey' => 'child_aliquot_control_id'
        )
    );

    /**
     *
     * @return An array of the form $data[parent_sample_control_id][parent_aliquot_control_id] = array(possible realiquots control id)
     */
    public function getPossiblities()
    {
        $realiquotDataRaw = $this->find('all', array(
            'recursive' => 2
        ));
        $realiquotData = array();
        foreach ($realiquotDataRaw as $data) {
            $realiquotData[$data['ParentAliquotControl']['sample_control_id']][$data['ParentAliquotControl']['id']][$data['ChildAliquotControl']['id']] = $data['ChildAliquotControl']['AliquotControl']['aliquot_type'];
        }
        return $realiquotData;
    }

    /**
     *
     * @param $sampleControlId
     * @param $parentAliquotControlId
     * @return array
     */
    public function getAllowedChildrenCtrlId($sampleControlId, $parentAliquotControlId)
    {
        $criteria = array(
            'ParentAliquotControl.sample_control_id' => $sampleControlId,
            'ParentAliquotControl.id' => $parentAliquotControlId,
            'ParentAliquotControl.flag_active' => '1',
            'RealiquotingControl.flag_active' => '1',
            'ChildAliquotControl.sample_control_id' => $sampleControlId,
            'ChildAliquotControl.flag_active' => '1'
        );
        $realiquotindControlData = $this->find('all', array(
            'conditions' => $criteria
        ));
        
        $allowedChildrenAliquotControlIds = array();
        foreach ($realiquotindControlData as $newRealiquotingControl) {
            $allowedChildrenAliquotControlIds[] = $newRealiquotingControl['ChildAliquotControl']['id'];
        }
        
        return $allowedChildrenAliquotControlIds;
    }

    /**
     *
     * @param $parentSampleCtrlId
     * @param $parentAliquotCtrlId
     * @param $childAliquotCtrlId
     * @return mixed
     */
    public function getLabBookCtrlId($parentSampleCtrlId, $parentAliquotCtrlId, $childAliquotCtrlId)
    {
        $criteria = array(
            'ParentAliquotControl.sample_control_id' => $parentSampleCtrlId,
            'ParentAliquotControl.id' => $parentAliquotCtrlId,
            'ParentAliquotControl.flag_active' => '1',
            'RealiquotingControl.flag_active' => '1',
            'ChildAliquotControl.sample_control_id' => $parentSampleCtrlId,
            'ChildAliquotControl.id' => $childAliquotCtrlId,
            'ChildAliquotControl.flag_active' => '1'
        );
        $realiquotingControlData = $this->find('first', array(
            'conditions' => $criteria
        ));
        
        return $realiquotingControlData['RealiquotingControl']['lab_book_control_id'];
    }
}