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
 * Class AliquotControl
 */
class AliquotControl extends InventoryManagementAppModel
{

    public $masterFormAlias = 'aliquot_masters';

    /**
     * Get permissible values array gathering all existing aliquot types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getAliquotTypePermissibleValuesFromId()
    {
        return $this->getAliquotsTypePermissibleValues(true, null);
    }

    /**
     * Get permissible values array gathering all existing aliquot types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getAliquotTypePermissibleValues()
    {
        return $this->getAliquotsTypePermissibleValues(false, null);
    }

    /**
     *
     * @param $useId
     * @param $parentSampleControlId
     * @return array
     */
    public function getAliquotsTypePermissibleValues($useId, $parentSampleControlId)
    {
        $result = array();
        
        // Build tmp array to sort according translation
        $conditions = array(
            'AliquotControl.flag_active' => 1
        );
        if ($parentSampleControlId != null) {
            $conditions['AliquotControl.sample_control_id'] = $parentSampleControlId;
        }
        
        if ($useId) {
            $this->bindModel(array(
                'belongsTo' => array(
                    'SampleControl' => array(
                        'className' => 'InventoryManagement.SampleControl',
                        'foreignKey' => 'sample_control_id'
                    )
                )
            ));
            $aliquotControls = $this->find('all', array(
                'conditions' => $conditions
            ));
            foreach ($aliquotControls as $aliquotControl) {
                $result[$aliquotControl['AliquotControl']['id']] = __($aliquotControl['AliquotControl']['aliquot_type']);
                // $aliquotTypePrecision = $aliquotControl['AliquotControl']['aliquot_type_precision'];
                // $result[$aliquotControl['AliquotControl']['id']] = __($aliquotControl['AliquotControl']['aliquot_type'])
                // . ' ['.__($aliquotControl['SampleControl']['sample_type'])
                // . (empty($aliquotTypePrecision)? '' : ' - ' . __($aliquotTypePrecision)) . ']';
            }
        } else {
            $aliquotControls = $this->find('all', array(
                'conditions' => $conditions
            ));
            foreach ($aliquotControls as $aliquotControl) {
                $result[$aliquotControl['AliquotControl']['aliquot_type']] = __($aliquotControl['AliquotControl']['aliquot_type']);
            }
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @param $parentSampleControlId
     * @return array
     */
    public function getPermissibleAliquotsArray($parentSampleControlId)
    {
        $conditions = array(
            'AliquotControl.flag_active' => true,
            'AliquotControl.sample_control_id' => $parentSampleControlId
        );
        
        $controls = $this->find('all', array(
            'conditions' => $conditions
        ));
        $aliquotControlsList = array();
        foreach ($controls as $control) {
            $aliquotControlsList[$control['AliquotControl']['id']]['AliquotControl'] = $control['AliquotControl'];
        }
        return $aliquotControlsList;
    }

    /**
     * Get permissible values array gathering all existing sample aliquot types
     * (realtions existing between sample type and aliquot type).
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSampleAliquotTypesPermissibleValues()
    {
        // Get list of active sample type
        $conditions = array(
            'ParentToDerivativeSampleControl.flag_active' => true
        );
        
        $this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
        $controls = $this->ParentToDerivativeSampleControl->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'DerivativeControl.*'
            )
        ));
        
        $specimenSampleControlIdsList = array();
        foreach ($controls as $control) {
            $specimenSampleControlIdsList[] = $control['DerivativeControl']['id'];
        }
        
        // Build final list
        $this->bindModel(array(
            'belongsTo' => array(
                'SampleControl' => array(
                    'className' => 'InventoryManagement.SampleControl',
                    'foreignKey' => 'sample_control_id'
                )
            )
        ));
        $result = $this->find('all', array(
            'conditions' => array(
                'AliquotControl.flag_active' => '1',
                'AliquotControl.sample_control_id' => $specimenSampleControlIdsList
            ),
            'order' => array(
                'SampleControl.sample_type' => 'asc',
                'AliquotControl.aliquot_type' => 'asc'
            )
        ));
        
        $workingArray = array();
        $lastSampleType = '';
        foreach ($result as $newSampleAliquot) {
            $sampleControlId = $newSampleAliquot['SampleControl']['id'];
            $aliquotControlId = $newSampleAliquot['AliquotControl']['id'];
            
            $sampleType = $newSampleAliquot['SampleControl']['sample_type'];
            $aliquotType = $newSampleAliquot['AliquotControl']['aliquot_type'];
            
            // New Sample Type
            if ($lastSampleType != $sampleType) {
                // Add just sample type to the list
                $workingArray[$sampleControlId . '|'] = __($sampleType);
            }
            
            // New Sample-Aliquot
            $workingArray[$sampleControlId . '|' . $aliquotControlId] = __($sampleType) . ' - ' . __($aliquotType);
        }
        natcasesort($workingArray);
        
        return $workingArray;
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}