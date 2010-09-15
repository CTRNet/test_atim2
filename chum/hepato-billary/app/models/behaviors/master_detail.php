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
	
	function afterFind (&$model, $results, $primary = false) { 
		
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if ( $is_master_model ) {
			
			// set DETAIL if more than ONE result
			if ($primary && isset($results[0][$control_class][$detail_field]) && $model->recursive > 0) {
				foreach ($results as $key => $result) {
					
					$associated = array();
					
					$detail_model = new AppModel( array('table'=>$result[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class) );
					
					$associated = $detail_model->find(array($master_foreign => $result[$model->alias]['id']), null, null, -1);
					$results[$key][$detail_class] = $associated[$detail_class];
				}
			} 
			
			// set DETAIL if ONLY one result
			else if( isset($results[$control_class][$detail_field]) ) {
				
				$associated = array();
				
				$detail_model = new AppModel( array('table'=>$results[$control_class][$detail_field], 'name'=>$detail_class, 'alias'=>$detail_class) );
				
				$associated = $detail_model->find(array($master_foreign => $results[0][$model->alias]['id']), null, null, -1);
				$results[$detail_class] = $associated[$detail_class];
				
			}
			
		}
		
		return $results;
	}
	
	function beforeSave (&$model) {
		return $this->beforeValidateAndSave($model);
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
			
			// set ID (for edit, blank for add) and model object NAME/ALIAS for save
			if ( isset($associated[$detail_class]) && count($associated[$detail_class]) ) {
				$detail_model->id = $associated[$detail_class]['id'];
			}
			
			$model->data[$detail_class][$master_foreign] = $model->id;
			
			// save detail DATA
			if ( (isset($detail_model->id) && $detail_model->id && !$created) || $created ) {
				$result = $detail_model->save($model->data);
			} else {
				$result = true;
			}
			 
			return $result;
			
		}
	}
	
	function beforeDelete (&$model) {
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
	function beforeValidate(&$model){
		return $this->beforeValidateAndSave($model);
	}
	
	private function beforeValidateAndSave(&$model){
	// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		if ( $is_master_model ) {
			
			$use_form_alias = NULL;
			$use_table_name = NULL;
			
			if ( isset($model->data[$master_class][$control_foreign]) && $model->data[$master_class][$control_foreign] ) {
				// use CONTROL_ID to get control row
				$associated = $model->$control_class->find('first',array('conditions' => array($control_class.'.id' => $model->data[$master_class][$control_foreign])));
			} else {
				// else, if EDIT, use MODEL.ID to get row and find CONTROL_ID that way...
				$associated = $model->find('first',array($master_class.'.id' => $model->id));
			}
			
			$use_form_alias = $associated[$control_class][$form_alias];
			$use_table_name = $associated[$control_class][$detail_field];
			
			if ( $use_form_alias ) {
				$detail_class_instance = new AppModel( array('table'=>$use_table_name, 'name'=>$detail_class, 'alias'=>$detail_class) );
				if(isset(AppController::getInstance()->{$detail_class})){
					$detail_class_instance->validate = AppController::getInstance()->{$detail_class}->validate;
					$detail_class_instance->set($model->data);
					$valid_detail_class = $detail_class_instance->validates();
					if ( !$valid_detail_class ){
						$model->validationErrors = array_merge($model->validationErrors, $detail_class_instance->validationErrors);
					}
				}
			}
		}
		//always continue. Even if errors exists in detail, we need to validate master
		return true;
	}
	
}

?>