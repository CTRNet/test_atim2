<?php
class MinMaxBehavior extends ModelBehavior {
	
	function beforeFind(Model $model, $query){
		if(isset($query['conditions'])){
			$to_fix = array();
			if(isset($model->registered_view)){
				foreach($model->registered_view as $plugin_model => $foo){
					list($plugin, $model_name) = explode('.', $plugin_model);
					$registered_model = AppModel::getInstance($plugin, $model_name);
					if(isset($registered_model::$min_value_fields)){
						$to_fix[$registered_model->name] = $registered_model::$min_value_fields; 
					}
				}
			}else if(isset($model::$min_value_fields)){
				$to_fix[$model->name] = $model::$min_value_fields;
			}
			
			$conditions = &$query['conditions'];
			foreach($to_fix as $model_name => $fields){
				foreach($fields as $field){
					$field_max = $model_name.'.'.$field.' <=';
					$field_min = $model_name.'.'.$field.' >=';
					if(isset($conditions[$field_max]) && !isset($conditions[$field_min]) && $conditions[$field_max] >= 0){
						$conditions[$field_min] = 0;
					}
				}
			}
		}
		return $query;
	}
}