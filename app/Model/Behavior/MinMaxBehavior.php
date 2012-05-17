<?php
/**
 * This behavior is used to define a minimum on certain view fields when a max is defined.
 * It's usefull for spent time calculation because spentTime >= 0 means the value is
 * valid, but spentTime < 0 is an error code. When searching with only a max criterion
 * <= x, results < 0 (errors) must not be returned. This behavior is here to add the 
 * minimum >= 0 clause if the minimum is not specified.
 *
 */
class MinMaxBehavior extends ModelBehavior {
	
	function beforeFind(Model $model, $query){
		if(isset($query['conditions'])){
			$to_fix = array();//contains the model -> fields to fix.
			if(isset($model->registered_view)){
				//if views are attached, parse each of them
				foreach($model->registered_view as $plugin_model => $foo){
					list($plugin, $model_name) = explode('.', $plugin_model);
					$registered_model = AppModel::getInstance($plugin, $model_name);
					if(isset($registered_model::$min_value_fields)){
						$to_fix[$registered_model->name] = $registered_model::$min_value_fields; 
					}
				}
			}else if(isset($model::$min_value_fields)){
				//is a view itself
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