<?php
/**
 * This behavior updates view_storage_masters whenever a stored item is moved
 * from a storage to another one
 */
class StoredItemBehavior extends ModelBehavior{
	
	private $previous_storage_master_id = null;
	
	public function beforeSave(Model $model){
		if($model->id){
			$prev_data = $model->find('first', array('conditions' => array($model->name.'.'.$model->primaryKey => $model->id)));
			$this->previous_storage_master_id = $model->name == 'StorageMaster' ? $prev_data['StorageMaster']['parent_id'] : $prev_data[$model->name]['storage_master_id'];
		}
		return true;
	}
	
	public function afterSave(Model $model, $created){
		$use_key = $model->name == 'StorageMaster' ? 'parent_id' : 'storage_master_id';
		if($created){
			$new_storage_id = isset($model->data[$model->name][$use_key]) ? $model->data[$model->name][$use_key] : null;
			if($new_storage_id){
				$query = sprintf('REPLACE INTO view_storage_masters (SELECT * FROM view_storage_masters_view WHERE id=%d)', $new_storage_id);
				$model->tryCatchQuery($query);				
			}
		}else{
			if((isset($model->data[$model->name]['deleted']) && $model->data[$model->name]['deleted'])
				|| (isset($model->data[$model->name][$use_key]) && $this->previous_storage_master_id != $model->data[$model->name][$use_key])
			){
				$query = sprintf('REPLACE INTO view_storage_masters (SELECT * FROM view_storage_masters_view WHERE id=%d)', $this->previous_storage_master_id);
				$model->tryCatchQuery($query);
			}
		}
	}
}