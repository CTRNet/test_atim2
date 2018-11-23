<?php

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
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'order' => 'SopMaster.title'
        )) as $sop) {
            
            $result[$sop['SopMaster']['id']] = (empty($sop['SopMaster']['title']) ? __('unknown') : $sop['SopMaster']['title']) . ' [' . $sop['SopMaster']['code'] . ' - ' . $sop['SopMaster']['version'] . ']';
        }
        
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