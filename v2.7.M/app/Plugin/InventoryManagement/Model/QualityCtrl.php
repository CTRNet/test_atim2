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
 * Class QualityCtrl
 */
class QualityCtrl extends InventoryManagementAppModel
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

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'QualityCtrl.id'
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['QualityCtrl.id'])) {
            // Get specimen data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.id'],
                'QualityCtrl.id' => $variables['QualityCtrl.id']
            );
            
            $qcData = $this->find('first', array(
                'conditions' => $criteria
            ));
            
            // Set summary
            $return = array(
                'menu' => array(
                    __('quality control abbreviation'),
                    ' : ' . $qcData['QualityCtrl']['run_id']
                ),
                'title' => array(
                    null,
                    __('quality control abbreviation') . ' : ' . $qcData['QualityCtrl']['run_id']
                ),
                'data' => $qcData,
                'structure alias' => 'qualityctrls'
            );
        }
        
        return $return;
    }

    /**
     * Check if a quality control can be deleted.
     *
     * @param $qualityCtrlId Id of the studied quality control.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($qualityCtrlId)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Create code of a new quality control.
     *
     *
     * @param $qcId ID of the studied quality control.
     * @param $storageData
     * @param $qcData Data of the quality control.
     * @param $sampleData Data of the sample linked to this quality control.
     * @return The new code.
     *        
     * @author N. Luc
     * @since 2008-01-31
     * @deprecated
     *
     */
    public function createCode($qcId, $storageData, $qcData = null, $sampleData = null)
    {
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }

    public function generateQcCode()
    {
        $qcToUpdate = $this->find('all', array(
            'conditions' => array(
                'QualityCtrl.qc_code IS NULL'
            ),
            'fields' => array(
                'QualityCtrl.id'
            ),
            'recursive' => 1
        ));
        foreach ($qcToUpdate as $newQc) {
            $newQcId = $newQc['QualityCtrl']['id'];
            $qcData = array(
                'QualityCtrl' => array(
                    'qc_code' => 'QC - ' . $newQcId
                )
            );
            $this->id = $newQcId;
            $this->data = null;
            $this->addWritableField(array(
                'qc_code'
            ));
            $this->save($qcData, false);
        }
    }
}