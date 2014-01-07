<?php
/**
 * This behavior updates view_storage_masters whenever a stored item is moved
 * from a storage to another one
 */
class StoredItemBehavior extends ModelBehavior{
	
	private $previous_storage_master_id = null;
	
	public function beforeSave(Model $model, $options = Array()){
		if($model->id){
			$prev_data = $model->find('first', array('conditions' => array($model->name.'.'.$model->primaryKey => $model->id)));
			$this->previous_storage_master_id = $model->name == 'StorageMaster' ? $prev_data['StorageMaster']['parent_id'] : $prev_data[$model->name]['storage_master_id'];
		}
		return true;
	}
	
	public function afterSave(Model $model, $created, $options = Array()){
		$view_storage_master_model = AppModel::getInstance('StorageLayout', 'ViewStorageMaster');
		$use_key = $model->name == 'StorageMaster' ? 'parent_id' : 'storage_master_id';
		$new_storage_id = isset($model->data[$model->name][$use_key]) ? $model->data[$model->name][$use_key] : null;
		if((isset($model->data[$model->name]['deleted']) && $model->data[$model->name]['deleted'])
			|| $this->previous_storage_master_id != $new_storage_id
		){
			//deleted OR new != old
			$query = 'REPLACE INTO view_storage_masters ('.$view_storage_master_model::$table_query.')';
			if($this->previous_storage_master_id){
				$model->tryCatchQuery(str_replace('%%WHERE%%', 'AND StorageMaster.id='.$this->previous_storage_master_id, $query));
			}
			if($new_storage_id){
				$model->tryCatchQuery(str_replace('%%WHERE%%', 'AND StorageMaster.id='.$new_storage_id, $query));
			}
		}
	}
}