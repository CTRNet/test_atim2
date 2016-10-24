<?php

/**
 * This behavior updates view_storage_masters whenever a stored item is moved
 * from a storage to another one
 */
class StoredItemBehavior extends ModelBehavior {

	protected $_previousStorageMasterId = null;

/**
 * beforeSave Callback
 *
 * @param Model $model Model to be saved
 * @param array $options Config
 *
 * @return bool
 */
	public function beforeSave(Model $model, $options = Array()) {
		if ($model->id) {
			$prev_data = $model->find('first',
				array('conditions' => array($model->name . '.' . $model->primaryKey => $model->id)));
			$this->_previousStorageMasterId = $model->name == 'StorageMaster' ? $prev_data['StorageMaster']['parent_id'] : $prev_data[$model->name]['storage_master_id'];
		}
		return true;
	}

/**
 * afterSave Callback
 *
 * @param Model $model Model
 * @param bool $created if Create operation
 * @param array $options Config
 * @return void
 */
	public function afterSave(Model $model, $created, $options = Array()) {
		$viewStorageMasterModel = AppModel::getInstance('StorageLayout', 'ViewStorageMaster');
		$useKey = $model->name == 'StorageMaster' ? 'parent_id' : 'storage_master_id';
		$newStorageId = isset($model->data[$model->name][$useKey]) ? $model->data[$model->name][$useKey] : null;
		if ((isset($model->data[$model->name]['deleted']) && $model->data[$model->name]['deleted'])
				|| $this->_previousStorageMasterId != $newStorageId
		) {
			//deleted OR new != old
//			$query = 'REPLACE INTO view_storage_masters (' . $viewStorageMasterModel::$table_query . ')';
			if ($this->_previousStorageMasterId) {
				$model->manageViewUpdate('view_storage_masters', 'StorageMaster.id',
					array($this->_previousStorageMasterId), $viewStorageMasterModel::$table_query);
			}
			if ($newStorageId) {
				$model->manageViewUpdate('view_storage_masters', 'StorageMaster.id', array($newStorageId),
					$viewStorageMasterModel::$table_query);
			}
		}
	}
}