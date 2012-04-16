<?php  

class MasterDetailBehavior extends ModelBehavior {
	
	var $__settings = array(); 
	
	function setup(&$model, $settings = array()) { 
		
		if ( strpos($model->alias,'Master') || strpos($model->alias,'Control') || (isset($model->base_model) && strpos($model->base_model,'Master'))){
			$model_to_use = null;
			if(isset($model->base_model)){
				$model_to_use = AppModel::getInstance($model->base_plugin, $model->base_model);
			} else {
				$model_to_use = $model;
			}
			
			$default_class 	= $model_to_use->alias;
			$default_class 	= str_replace('Master','',$default_class);
			$default_class 	= str_replace('Control','',$default_class);
			
			$master_class		= $default_class.'Master';
			$master_foreign	= Inflector::singularize($model_to_use->table).'_id';
			
			$control_class		= $default_class.'Control';
			$control_foreign	= str_replace('master','control',Inflector::singularize($model_to_use->table).'_id');
			
			$detail_class		= $default_class.'Detail';
			$detail_tablename	= 'detail_tablename';
			$form_alias	= 'form_alias';
			
			$is_master_model	= $master_class == $model_to_use->alias ? true : false;
			$is_control_model	= $control_class == $model_to_use->alias ? true : false;
			
			$default = array(
				'master_class' 		=>	$master_class, 
				'master_foreign' 		=>	$master_foreign, 
				
				'control_class' 		=>	$control_class, 
				'control_foreign' 	=>	$control_foreign, 
				
				'detail_class' 		=>	$detail_class, 
				'detail_field' 		=>	$detail_tablename,
				'form_alias'			=> $form_alias,
				
				'is_master_model'		=> $is_master_model,
				'is_control_model'	=> $is_control_model
			); 
		
		} else {
			
			$default = array(
				'is_master_model'		=> false,
				'is_control_model'	=> false
			);
			
		}
			
		if (!isset($this->__settings[$model->alias])){
			$this->__settings[$model->alias] = $default;
		}
		$this->__settings[$model->alias] = am($this->__settings[$model->alias], is_array($settings) ? $settings : array());
	}
	
	function afterFind($model, $results, $primary){
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		if($is_master_model){
			// set DETAIL if more than ONE result
			if ($primary && isset($results[0][$control_class][$detail_field]) && $model->recursive > 0) {
				$grouping = array();//group by ctrl ids
				foreach ($results as $key => &$result){
					if(!isset($results[$key][$detail_class])){//the detail model is already defined if it was a find on a specific control_id
						$detail_model_cache_key = $detail_class.".".$result[$control_class][$detail_field];
						if(!isset($grouping[$detail_model_cache_key])){
							//caching model (its rougly as fast as grouping queries by detail, see eventum 1120)
							$grouping[$detail_model_cache_key]['model'] = new AppModel(array('table' => $result[$control_class][$detail_field], 'name' => $detail_class, 'alias' => $detail_class, 'alias' => $detail_class.'_'.$result[$control_class][$detail_field]));
							$grouping[$detail_model_cache_key]['id_to_index'] = array();
						}
						$grouping[$detail_model_cache_key]['id_to_index'][$result[$model->alias][$model->primaryKey]] = $key;
					}
				}
				
				//data fetch and assoc
				foreach($grouping as $group){
					$id_to_index = $group['id_to_index'];
					$detail_data = $group['model']->find('all', array('conditions' => array($master_foreign => array_keys($id_to_index)), 'recursive' => -1));
					$detail_data_alias = $group['model']->name.'_'.$group['model']->table;
					foreach($detail_data as $detail_unit){
						$results[$id_to_index[$detail_unit[$detail_data_alias][$master_foreign]]][$detail_class] = $detail_unit[$detail_data_alias];
					}
				}
			}else if(isset($results[$control_class][$detail_field]) && !isset($results[$detail_class])){
				// set DETAIL if ONLY one result
				$associated = array();
				
				$detail_model = new AppModel( array('table'=>$results[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class, 'alias' => $detail_class) );
				
				$associated = $detail_model->find(array($master_foreign => $results[0][$model->alias]['id']), null, null, -1);
				$results[$detail_class] = $associated[$detail_class];
			}
			
			if($model->previous_model != null){
				//a detailed search occured, restore the original model in case it contained some variables that were not copied in the
				//model associated with details
				$model = $model->previous_model;
			}
		}
		
		return $results;
	}
	
	function beforeFind($model, $query){
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if($is_master_model){
			//this is a master/detail. See if the find is made on a specific control id. If so, join the detail table
			$base_name = str_replace("Master", "", $model->name);
			if(isset($query['conditions'][$model->name.".".strtolower($base_name)."_control_id"])){
				$detail_control_name = $model->belongsTo[$base_name."Control"]['className'];
				$plugin = '';
				if(strpos($detail_control_name, '.') !== false){
					list($plugin , $detail_control_name) = explode('.', $detail_control_name);
				}
				$detail_control = AppModel::getInstance($plugin, $detail_control_name, true);
				$detail_info = $detail_control->find('first', array('conditions' => array($detail_control->name.".id" => $query['conditions'][$model->name.".".strtolower($base_name)."_control_id"])));
				$model = new $model->name($model->id, $model->table, null, $base_name, $detail_info[$base_name."Control"]['detail_tablename'], $model);
			}
		}
		
		return true;
	}
	
	function afterSave ($model, $created) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		if ( $is_master_model || $is_control_model ) {
			// get DETAIL table name and create DETAIL model object
			$associated = $model->find('first', array('conditions' => array($master_class.'.id' => $model->id, $master_class.'.deleted' => array('0', '1')), 'recursive' => 0));
			assert($associated) or die('MasterDetailBehavior afterSave failed to fetch control details');
			$table = $associated[$control_class][$detail_field];
			$detail_model = new AppModel( array('table' => $table, 'name' => $detail_class, 'alias' => $detail_class, 'primaryKey' => $master_foreign) );
			$detail_model->writable_fields_mode = $model->writable_fields_mode;
			$detail_model->check_writable_fields = $model->check_writable_fields;
			$detail_model->primaryKey = $master_foreign;
			foreach($detail_model->actsAs as $key => $data){
				if ( is_array($data) ) {
					$behavior = $key;
					$config = $data;
				} else {
					$behavior = $data;
					$config = null;
				}
				$detail_model->Behaviors->load($behavior, $config);
				$detail_model->Behaviors->$behavior->setup($detail_model,$config);
			}
			
			foreach($detail_model->actsAs as $key => $data){
				if(is_array($data)){
					$behavior = $key;
					$config = $data;
				}else{
					$behavior = $data;
					$config = null;
				}
				$detail_model->Behaviors->attach($behavior, $config);
				$detail_model->Behaviors->$behavior->setup($detail_model,$config);
			}
			
			$detail_model->id = $model->id;
			$model->data[$detail_class][$master_foreign] = $model->id;
			$detail_model->version_id = $model->version_id;
			
			// save detail DATA
			if((isset($detail_model->id) && $detail_model->id && !$created) || $created){
				$result = $detail_model->save($model->data[$detail_class], false);//validation should have already been done
			}else{
				$result = true;
			}
			 
			return $result;
			
		}
	}
	
	function beforeDelete($model, $cascade = true){
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if ( $is_master_model ) {
			// get DETAIL table name and create DETAIL model object
			$prev_data  = $model->data;
			$associated = $model->read();
			$detail_model = new AppModel( array('table'=>$associated[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=> $detail_class) );
			$detail_model->Behaviors->Revision->setup($detail_model);
			// set ID (for edit, blank for add) and model object NAME/ALIAS for save
			if ( isset($associated[$detail_class]) && count($associated[$detail_class]) ) {
				$detail_model->id = $associated[$detail_class]['id'];
			}
			
			// delete detail DATA
			$result = $detail_model->atimDelete($detail_model->id);
			
			$model->data = $prev_data;
					
			return $result;
			
		}
		
		return true;
	}
	
	function getControlName(Model $model){
		if(isset($model->base_model)){
			$model = AppModel::getInstance($model->base_plugin, $model->base_model, true);
		}
		return isset($this->__settings[$model->alias]['control_class']) ? $this->__settings[$model->alias]['control_class'] : null;
	}
	
	function getControlForeign($model){
		if(isset($model->base_model)){
			$model = AppModel::getInstance($model->base_plugin, $model->base_model, true);
		}
		return isset($this->__settings[$model->alias]['control_foreign']) ? $this->__settings[$model->alias]['control_foreign'] : null;
	}
}

?>