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
 * This behavior updates view_storage_masters whenever a stored item is moved
 * from a storage to another one
 */
class StoredItemBehavior extends ModelBehavior
{

    private $previousStorageMasterId = null;

    /**
     *
     * @param Model $model
     * @param array $options
     * @return bool
     */
    public function beforeSave(Model $model, $options = array())
    {
        if ($model->id) {
            $prevData = $model->find('first', array(
                'conditions' => array(
                    $model->name . '.' . $model->primaryKey => $model->id
                )
            ));
            $this->previousStorageMasterId = $model->name == 'StorageMaster' ? $prevData['StorageMaster']['parent_id'] : $prevData[$model->name]['storage_master_id'];
        }
        return true;
    }

    /**
     *
     * @param Model $model
     * @param bool $created
     * @param array $options
     * @return bool|void
     */
    public function afterSave(Model $model, $created, $options = array())
    {
        $viewStorageMasterModel = AppModel::getInstance('StorageLayout', 'ViewStorageMaster');
        $useKey = $model->name == 'StorageMaster' ? 'parent_id' : 'storage_master_id';
        $newStorageId = isset($model->data[$model->name][$useKey]) ? $model->data[$model->name][$useKey] : null;
        if ((isset($model->data[$model->name]['deleted']) && $model->data[$model->name]['deleted']) || $this->previousStorageMasterId != $newStorageId) {
            // deleted OR new != old
            $query = 'REPLACE INTO view_storage_masters (' . $viewStorageMasterModel::$tableQuery . ')';
            if ($this->previousStorageMasterId) {
                $model->manageViewUpdate('view_storage_masters', 'StorageMaster.id', array(
                    $this->previousStorageMasterId
                ), $viewStorageMasterModel::$tableQuery);
            }
            if ($newStorageId) {
                $model->manageViewUpdate('view_storage_masters', 'StorageMaster.id', array(
                    $newStorageId
                ), $viewStorageMasterModel::$tableQuery);
            }
        }
    }
}