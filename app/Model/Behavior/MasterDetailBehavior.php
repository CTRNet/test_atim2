<?php  

class MasterDetailBehavior extends ModelBehavior {
	
	var $__settings = array(); 
	
	public function setup(Model $model, $config = array()) {
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
			$is_view			= strpos($model->alias, 'View') !== false;
			
			$default = array(
				'master_class' 		=>	$master_class, 
				'master_foreign' 		=>	$master_foreign, 
				
				'control_class' 		=>	$control_class, 
				'control_foreign' 	=>	$control_foreign, 
				
				'detail_class' 		=>	$detail_class, 
				'detail_field' 		=>	$detail_tablename,
				'form_alias'			=> $form_alias,
				
				'is_master_model'		=> $is_master_model,
				'is_control_model'	=> $is_control_model,
				'is_view'			=> $is_view,
			    
			    'default_class'     => $default_class
			); 
			if($is_control_model){
				//for control models, add a virtual field with the full form alias
				$schema = $model->schema();
				if(isset($schema['detail_form_alias'])){
					$model->virtualFields['form_alias'] = isset($model->master_form_alias) ?  'CONCAT("'.$model->master_form_alias.',",'.$model->alias.'.detail_form_alias)' : $model->alias.'.detail_form_alias';
				}
			}
		
		} else {
			
			$default = array(
				'is_master_model'	=> false,
				'is_control_model'	=> false,
				'is_view'			=> strpos($model->alias, 'View') !== false
			);
			
		}
			
		if (!isset($this->__settings[$model->alias])){
			$this->__settings[$model->alias] = $default;
		}
		$this->__settings[$model->alias] = am($this->__settings[$model->alias], is_array($config) ? $config : array());
	}
	
	public function afterFind(Model $model, $results, $primary = false) {
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
							$grouping[$detail_model_cache_key]['model'] = new AppModel(array('table' => $result[$control_class][$detail_field], 'name' => $detail_class, 'alias' => $detail_class.'_'.$result[$control_class][$detail_field]));
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
	
	/**
	 * If there is a single control id condition, returns the id, otherwise 
	 * false
	 * @param Model $model
	 * @param unknown $query
	 * @return mixed
	 */
	public function getSingleControlIdCondition(Model $model, $query){
	    extract($this->__settings[$model->alias]);
	    if(isset($query['conditions'][$model->name.".".$control_foreign])
                && count($query['conditions'][$model->name.".".$control_foreign]) == 1){
	        return $query['conditions'][$model->name.".".$control_foreign];
	    }
	    return false;
	}
	
	public function getDetailJoin(Model $model, $control_id, $alternate_model_name=null){
	    extract($this->__settings[$model->alias]);
	    assert($is_master_model) or die("getDetailJoin can only be called from master model");
	    if($alternate_model_name === null){
	        $model_name = $model->name;
	        $detail_name = $detail_class;
	    }else{
	        $model_name = $alternate_model_name;
	        $detail_name = str_replace("Master", "Detail", $alternate_model_name);
	    }
	    $detail_control_name = $model->belongsTo[$default_class."Control"]['className'];
	    $plugin = '';
	    if(strpos($detail_control_name, '.') !== false){
	        list($plugin , $detail_control_name) = explode('.', $detail_control_name);
	    }
	    $detail_control = AppModel::getInstance($plugin, $detail_control_name, true);
	    $detail_info = $detail_control->find('first', array('conditions' => array($detail_control->name.".id" => $control_id)));
	    assert($detail_info) or die("detail_info is empty");
	    $detail_info = $detail_info[$detail_control_name];
	    return array(
            'table' => $detail_info['detail_tablename'],
            'alias'	=> $detail_name,
            'type'	=> 'LEFT',
            'conditions' => array(
                    $model_name.".".$model->primaryKey." = ".$detail_name.".".$master_foreign
            )
	    );
	}

	public function beforeFind(Model $model, $query) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		if($is_master_model){
		    if(isset($model->$detail_class) && isset($model->$detail_class->table)) {
		        // binding already done via AppController::buildDetailBinding
		        return;
		    }
			//this is a master/detail. See if the find is made on a specific control id. If so, join the detail table
			$control_id = $model->getSingleControlIdCondition($query); 
			if($control_id !== false && empty($query['joins'])){
			    $query['joins'][] = $model->getDetailJoin($control_id);
			}
		}
		return $query;
	}
	
	public function afterSave(Model $model, $created, $options = Array()) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		if ( !$is_view && ($is_master_model || $is_control_model )) {
			// get DETAIL table name and create DETAIL model object
			$associated = $model->find('first', array('conditions' => array($master_class.'.id' => $model->id, $master_class.'.deleted' => array('0', '1')), 'recursive' => 0));
			assert($associated) or die('MasterDetailBehavior afterSave failed to fetch control details');
			$table = $associated[$control_class][$detail_field];
			$detail_model = new AppModel( array('table' => $table, 'name' => $detail_class, 'alias' => $detail_class.'_'.$table, 'primaryKey' => $master_foreign) );
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
			
		}else{
			
		}
	}
	
	public function beforeDelete(Model $model, $cascade = true) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if ( $is_master_model && !isset($model->base_model)) {
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
	
	function getControlForeign(Model $model){
		if(isset($model->base_model)){
			$model = AppModel::getInstance($model->base_plugin, $model->base_model, true);
		}
		return isset($this->__settings[$model->alias]['control_foreign']) ? $this->__settings[$model->alias]['control_foreign'] : null;
	}
	
	/**
	 * Meant to counter the fact that behavior afterFind is NOT called for non primary models
	 * and to manually add the form_alias since virutalFields do not work for associated
	 * models.
	 * @param Model $model
	 * @param unknown_type $results
	 * @param unknown_type $primary
	 */
	function applyMasterFormAlias(Model $model, $results, $primary){
		if(!$primary && isset($results[0][$model->alias]['detail_form_alias'])){
			foreach($results as &$row){
				$row[$model->alias]['form_alias'] = $model->master_form_alias.','.$row[$model->alias]['detail_form_alias'];
			}
		}
		return $results;
	}
	
	function getDetailModel($model, $control_id){
        extract($this->__settings[$model->alias]);
        if(!$is_master_model){
           throw new Exception("Must be called from master model");
        }
        
        $detail_control_name = $model->belongsTo[$default_class."Control"]['className'];
        $plugin = '';
        if(strpos($detail_control_name, '.') !== false){
           list($plugin , $detail_control_name) = explode('.', $detail_control_name);
        }
        $detail_control = AppModel::getInstance($plugin, $detail_control_name, true);
        $detail_info = $detail_control->find('first', array('conditions' => 
        array($detail_control->name.".id" => $control_id)));
        return new AppModel(array(
            'table' => $detail_info[$detail_control->name]['detail_tablename'],
            'name'=>$detail_class,
            'alias'=> $detail_class));
	}
}