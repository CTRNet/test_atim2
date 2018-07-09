<?php

/**
 * Class StorageCoordinate
 */
class StorageCoordinate extends StorageLayoutAppModel
{

    public $belongsTo = array(
        'StorageMaster' => array(
            'className' => 'StorageLayout.StorageMaster',
            'foreignKey' => 'storage_master_id'
        )
    );

    /**
     * Define if a storage coordinate can be deleted.
     *
     * @param $storageMasterId Id of the studied storage.
     * @param array|Storage $storageCoordinateData Storage
     *        coordinate data.
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     * @author N. Luc
     * @since 2008-02-04
     *        @updated A. Suggitt
     */
    public function allowDeletion($storageMasterId, $storageCoordinateData = array())
    {
        // Check storage contains no chlidren storage stored within this position
        $storageMasterModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
        $nbrChildrenStorages = $storageMasterModel->find('count', array(
            'conditions' => array(
                'StorageMaster.parent_id' => $storageMasterId,
                'StorageMaster.parent_storage_coord_x' => $storageCoordinateData['StorageCoordinate']['coordinate_value']
            ),
            'recursive' => - 1
        ));
        if ($nbrChildrenStorages > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'children storage is stored within the storage at this position'
            );
        }
        
        // Verify storage contains no aliquots
        $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $nbrStorageAliquots = $aliquotMasterModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.storage_master_id' => $storageMasterId,
                'AliquotMaster.storage_coord_x ' => $storageCoordinateData['StorageCoordinate']['coordinate_value']
            ),
            'recursive' => - 1
        ));
        if ($nbrStorageAliquots > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'aliquot is stored within the storage at this position'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Check the coordinate value does not already exists and set error if not.
     *
     * @param $storageMasterId Id of the studied storage.
     * @param $newCoordinateValue New coordinate value.
     *       
     * @return Return true if the storage coordinate has already been set.
     *        
     * @author N. Luc
     * @since 2008-02-04
     *        @updated A. Suggitt
     */
    public function isDuplicatedValue($storageMasterId, $newCoordinateValue)
    {
        $nbrCoordValues = $this->find('count', array(
            'conditions' => array(
                'StorageCoordinate.storage_master_id' => $storageMasterId,
                'StorageCoordinate.coordinate_value' => $newCoordinateValue
            ),
            'recursive' => - 1
        ));
        
        if ($nbrCoordValues == 0) {
            return false;
        }
        
        // The value already exists: Set the errors
        $this->validationErrors['coordinate_value'][] = 'coordinate must be unique for the storage';
        
        return true;
    }

    /**
     * Check the coordinate order does not already exists and set error if not.
     *
     * @param $storageMasterId Id of the studied storage.
     * @param $newCoordinateOrder New coordinate order.
     *       
     * @return Return true if the storage coordinate order has already been set.
     *        
     * @author N. Luc
     * @since 2008-02-04
     *        @updated A. Suggitt
     */
    public function isDuplicatedOrder($storageMasterId, $newCoordinateOrder)
    {
        $nbrCoordValues = $this->find('count', array(
            'conditions' => array(
                'StorageCoordinate.storage_master_id' => $storageMasterId,
                'StorageCoordinate.order' => $newCoordinateOrder
            ),
            'recursive' => - 1
        ));
        
        if ($nbrCoordValues == 0) {
            return false;
        }
        
        // The value already exists: Set the errors
        $this->validationErrors['order'][] = 'coordinate order must be unique for the storage';
        
        return true;
    }
}