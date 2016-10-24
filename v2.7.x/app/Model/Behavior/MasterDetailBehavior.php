<?php

class MasterDetailBehavior extends ModelBehavior {

	public $settings = array();

/**
 * Setup function
 *
 * @param Model $model Model Object
 * @param array $config Custom config
 * @return void
 */
	public function setup(Model $model, $config = array()) {
		$default = array(
			'is_master_model'	=> false,
			'is_control_model'	=> false,
			'is_view'			=> strpos($model->alias, 'View') !== false
		);

		if (strpos($model->alias, 'Master')
			|| strpos($model->alias, 'Control')
			|| (isset($model->base_model) && strpos($model->base_model, 'Master'))
		) {
			$modelToUse = $model;
			if (isset($model->base_model)) {
				$modelToUse = AppModel::getInstance($model->base_plugin, $model->base_model);
			}

			$defaultClass = $modelToUse->alias;
			$defaultClass = str_replace('Master', '', $defaultClass);
			$defaultClass = str_replace('Control', '', $defaultClass);

			$masterClass = $defaultClass . 'Master';
			$masterForeign	= Inflector::singularize($modelToUse->table) . '_id';

			$controlClass = $defaultClass . 'Control';
			$controlForeign = str_replace('master', 'control', Inflector::singularize($modelToUse->table) . '_id');

			$detailClass = $defaultClass . 'Detail';
			$detailTablename = 'detail_tablename';
			$formAlias	= 'form_alias';

			$isMasterModel = $masterClass == $modelToUse->alias ? true : false;
			$isControlModel = $controlClass == $modelToUse->alias ? true : false;
			$isView = strpos($model->alias, 'View') !== false;

			$default = array(
				'master_class' => $masterClass,
				'master_foreign' =>	$masterForeign,

				'control_class' => $controlClass,
				'control_foreign' => $controlForeign,

				'detail_class' => $detailClass,
				'detail_field' => $detailTablename,
				'form_alias' => $formAlias,

				'is_master_model' => $isMasterModel,
				'is_control_model' => $isControlModel,
				'is_view' => $isView,

				'default_class' => $defaultClass
			);
			if ($isControlModel) {
				//for control models, add a virtual field with the full form alias
				$schema = $model->schema();
				if (isset($schema['detail_form_alias'])) {
					$aliasName = isset($model->master_form_alias)
						? 'CONCAT("' . $model->master_form_alias . ',",' . $model->alias . '.detail_form_alias)'
						: $model->alias . '.detail_form_alias';
					$model->virtualFields['form_alias'] = $aliasName;
				}
			}

		}

		if (!isset($this->settings[$model->alias])) {
			$this->settings[$model->alias] = $default;
		}
		$this->settings[$model->alias] = am($this->settings[$model->alias], is_array($config) ? $config : array());
	}

/**
 * AfterFind Callback
 *
 * @param Model $model Model Object
 * @param mixed $results Results
 * @param bool $primary If primary
 *
 * @return mixed
 */
	public function afterFind(Model $model, $results, $primary = false) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->settings[$model->alias]);
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
 * @param mixed $query
 * @return mixed
 */
	public function getSingleControlIdCondition(Model $model, $query){
	    extract($this->settings[$model->alias]);
	    if(is_array($query['conditions']) 
	    && array_key_exists($model->name.".".$control_foreign, $query['conditions']) 
	    && count($query['conditions'][$model->name.".".$control_foreign]) == 1){
	    	return $query['conditions'][$model->name.".".$control_foreign];
	    }
	    return false;
	}

/**
 * @param Model $model
 * @param $control_id
 * @param null $alternate_model_name
 *
 * @return array
 */
	public function getDetailJoin(Model $model, $control_id, $alternate_model_name=null){
	    extract($this->settings[$model->alias]);
	    assert($is_master_model) or die("getDetailJoin can only be called from master model");
	    if($alternate_model_name === null){
	        $model_name = $model->name;
	        $detail_name = $detail_class;
	    }else{
	        $model_name = $alternate_model_name;
	    	//Use preg_match to fix issue #3287
	    	if(preg_match('/Master/', $alternate_model_name)) {
	    		$detail_name = str_replace("Master", "Detail", $alternate_model_name);
	    	} else if(preg_match('/^([0-9]+_)/', $alternate_model_name, $matches)) {
	    		$detail_name = $matches[1].$detail_class;
	    	} else {
	    		$detail_name = $alternate_model_name.'Detail';
	    	}
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

/**
 * @param Model $model
 * @param array $query
 *
 * @return array|void
 */
	public function beforeFind(Model $model, $query) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->settings[$model->alias]);
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

/**
 * @param Model $model
 * @param bool $created
 * @param array $options
 *
 * @return bool|mixed
 */
	public function afterSave(Model $model, $created, $options = Array()) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->settings[$model->alias]);
		if ( !$is_view && ($is_master_model || $is_control_model )) {
			// get DETAIL table name and create DETAIL model object
			$associated = $model->find('first', array('conditions' => array($master_class.'.id' => $model->id, $master_class.'.deleted' => array('0', '1')), 'recursive' => 0));
			assert($associated) or die('MasterDetailBehavior afterSave failed to fetch control details');
			$table = $associated[$control_class][$detail_field];
			$detail_model = new AppModel( array('table' => $table, 'name' => $detail_class, 'alias' => $detail_class.'_'.$table, 'primaryKey' => $master_foreign) );
			$detail_model->writableDieldsMode = $model->writable_fields_mode;
			$detail_model->checkWritableFields = $model->check_writable_fields;
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
		extract($this->settings[$model->alias]);
		
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
		return isset($this->settings[$model->alias]['control_class']) ? $this->settings[$model->alias]['control_class'] : null;
	}
	
	function getControlForeign(Model $model){
		if(isset($model->base_model)){
			$model = AppModel::getInstance($model->base_plugin, $model->base_model, true);
		}
		return isset($this->settings[$model->alias]['control_foreign']) ? $this->settings[$model->alias]['control_foreign'] : null;
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
        extract($this->settings[$model->alias]);
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