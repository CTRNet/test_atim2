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
 * Class SopMaster
 */
class SopMaster extends SopAppModel
{

    public $name = 'SopMaster';

    public $useTable = 'sop_masters';

    public $belongsTo = array(
        'SopControl' => array(
            'className' => 'Sop.SopControl',
            'foreignKey' => 'sop_control_id'
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
        
        if (isset($variables['SopMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'SopMaster.id' => $variables['SopMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['SopMaster']['code'], true)
                ),
                'title' => array(
                    null,
                    __($result['SopMaster']['code'], true)
                ),
                'data' => $result,
                'structure alias' => 'sopmasters'
            );
        }
        
        return $return;
    }

    /**
     * Get permissible values array gathering all existing sops developped for collections.
     * To Develop
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getCollectionSopPermissibleValues()
    {
        return $this->getAllSopPermissibleValues();
    }

    /**
     * Get permissible values array gathering all existing sops developped for samples.
     * To Develop
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getSampleSopPermissibleValues()
    {
        return $this->getAllSopPermissibleValues();
    }

    /**
     * Get permissible values array gathering all existing sops developped for aliquots.
     * To Develop
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getAliquotSopPermissibleValues()
    {
        return $this->getAllSopPermissibleValues();
    }

    /**
     * Get permissible values array gathering all existing sops developped for TMA Block.
     * To Develop
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getTmaBlockSopPermissibleValues()
    {
        return $this->getAllSopPermissibleValues();
    }

    /**
     * Get permissible values array gathering all existing sops developped for TMA Block Slide.
     * To Develop
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getTmaSlideSopPermissibleValues()
    {
        return $this->getAllSopPermissibleValues();
    }

    /**
     *
     * @return array
     */
    public function getAllSopPermissibleValues()
    {
        $result = array();
        $resultInactif = array();
        
        $sops = $this->find('all', array(
            'order' => 'SopMaster.title',
            'conditions' => array(
                "OR" => array(
                    'expiry_date >' => date("Y-m-d"),
                    "expiry_date" => null),
                "status" => "activated"
        )));
        
        $sopsInactif = $this->find('all', array(
            'order' => 'SopMaster.title',
            'conditions' => array(
                "OR" => array(
                    'expiry_date <' => date("Y-m-d"),
                    "status" => "deactivated"),
        )));
        
        // Build tmp array to sort according translation
        foreach ($sops as $sop) {
            
            $result[$sop['SopMaster']['id']] = (empty($sop['SopMaster']['title']) ? __('unknown') : $sop['SopMaster']['title']) . ' [' . $sop['SopMaster']['code'] . ' - ' . $sop['SopMaster']['version'] . ']';
        }
        
        
        // Build tmp array to sort according translation
        foreach ($sopsInactif as $sop) {
            
            $resultInactif[$sop['SopMaster']['id']] = (empty($sop['SopMaster']['title']) ? __('unknown') : $sop['SopMaster']['title']) . ' [' . $sop['SopMaster']['code'] . ' - ' . $sop['SopMaster']['version'] . ']';
        }
        
        $result["defined"] = $result;
        $result["previously_defined"] = $resultInactif;
        
        return $result;
    }

    /**
     *
     * @param int $sopMasterId
     * @return array
     */
    public function allowDeletion($sopMasterId)
    {
        $ctrlModel = AppModel::getInstance("StorageLayout", "TmaSlide", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'TmaSlide.sop_master_id' => $sopMasterId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'sop is assigned to a slide'
            );
        }
        
        $storageDetail = AppModel::getInstance("StorageLayout", "StorageDetail", true);
        $blockModel = new StorageDetail(false, 'std_tma_blocks');
        $ctrlValue = $blockModel->find('count', array(
            'conditions' => array(
                'StorageDetail.sop_master_id' => $sopMasterId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'sop is assigned to a block'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'Collection.sop_master_id' => $sopMasterId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'sop is assigned to a collection'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'SampleMaster.sop_master_id' => $sopMasterId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'sop is assigned to a sample'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.sop_master_id' => $sopMasterId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'sop is assigned to an aliquot'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}