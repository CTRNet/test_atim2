<?php  

class MasterDetailBehavior extends ModelBehavior {
	
	var $__settings = array(); 
	
	function setup(&$model, $settings = array()) { 
		
		if ( strpos($model->alias,'Master') || strpos($model->alias,'Control') ) {
			
			$default_class 	= $model->alias;
			$default_class 	= str_replace('Master','',$default_class);
			$default_class 	= str_replace('Control','',$default_class);
			
			$master_class		= $default_class.'Master';
			$master_foreign	= Inflector::singularize($model->table).'_id';
			
			$control_class		= $default_class.'Control';
			$control_foreign	= str_replace('master','control',Inflector::singularize($model->table).'_id');
			
			$detail_class		= $default_class.'Detail';
			$detail_tablename	= 'detail_tablename';
			$form_alias	= 'form_alias';
			
			$is_master_model	= $master_class==$model->alias ? true : false;
			$is_control_model	= $control_class==$model->alias ? true : false;
			
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
			
		if (!isset($this->__settings[$model->alias]))  $this->__settings[$model->alias] = $default;
		$this->__settings[$model->alias] = am($this->__settings[$model->alias], ife(is_array($settings), $settings, array()));
		
	}
	
	function afterFind(&$model, $results, $primary = false){
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		if($is_master_model){
			// set DETAIL if more than ONE result
			if ($primary && isset($results[0][$control_class][$detail_field]) && $model->recursive > 0) {
				$detail_model_cache = array();
				foreach ($results as $key => $result){
					if(!isset($results[$key][$detail_class])){//the detail model is already defined if it was a find on a specific control_id
						$associated = array();
						if(!isset($detail_model_cache[$detail_class])){
							//caching model (its rougly as fast as grouping queries by detail, see eventum 1120)
							$detail_model_cache[$detail_class] = new AppModel(array('table'=>$result[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class));
						}
						
						$associated = $detail_model_cache[$detail_class]->find(array($master_foreign => $result[$model->alias]['id']), null, null, -1);
						$results[$key][$detail_class] = $associated[$detail_class];
					}
				}
			}else if(isset($results[$control_class][$detail_field]) && !isset($results[$detail_class])){
				// set DETAIL if ONLY one result
				$associated = array();
				
				$detail_model = new AppModel( array('table'=>$results[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class) );
				
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
	
	function beforeFind(&$model, $query){
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if($is_master_model){
			//this is a master/detail. See if the find is made on a specific control id. If so, join the detail table
			$base_name = str_replace("Master", "", $model->name);
			if(isset($query['conditions'][$model->name.".".strtolower($base_name)."_control_id"])){
				$detail_control = new $model->belongsTo[$base_name."Control"]['className']();
				$detail_info = $detail_control->find('first', array('conditions' => array($detail_control->name.".id" => $query['conditions'][$model->name.".".strtolower($base_name)."_control_id"])));
				$model = new $model->name($model->id, $model->table, null, $base_name, $detail_info[$base_name."Control"]['detail_tablename'], $model);
			}
		}
	}
	
	function afterSave (&$model, $created) {
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
			
		if ( $is_master_model || $is_control_model ) {
			
			// get DETAIL table name and create DETAIL model object
			$associated = $model->find(array($master_class.'.id' => $model->id), null, null, 1);
			$detail_model = new AppModel( array('table'=>$associated[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class) );
			foreach($detail_model->actsAs as $key => $data){
				if ( is_array($data) ) {
					$behavior = $key;
					$config = $data;
				} else {
					$behavior = $data;
					$config = null;
				}
				$detail_model->Behaviors->attach($behavior, $config);
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
			
			// set ID (for edit, blank for add) and model object NAME/ALIAS for save
			if(isset($associated[$detail_class]) && count($associated[$detail_class])){
				$detail_model->id = $associated[$detail_class]['id'];
			}
			
			$model->data[$detail_class][$master_foreign] = $model->id;
			
			// save detail DATA
			if((isset($detail_model->id) && $detail_model->id && !$created) || $created){
				$result = $detail_model->save($model->data);
			}else{
				$result = true;
			}
			 
			return $result;
			
		}
	}
	
	function beforeDelete(&$model){
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if ( $is_master_model ) {
			
			// get DETAIL table name and create DETAIL model object
			$associated = $model->find(array($master_class.'.id' => $model->id), null, null, 1);
			$detail_model = new AppModel( array('table'=>$associated[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class) );
			
			// set ID (for edit, blank for add) and model object NAME/ALIAS for save
			if ( isset($associated[$detail_class]) && count($associated[$detail_class]) ) {
				$detail_model->id = $associated[$detail_class]['id'];
			}
			
			// delete detail DATA
			$result = $detail_model->atim_delete($detail_model->id);
			
			return $result;
			
		}
	}
}

?>