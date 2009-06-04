<?php  

class MasterDetailBehavior extends ModelBehavior {
	
	var $__settings = array(); 
	
	function setup(&$model, $settings = array()) { 
		
		$default_class = $model->alias;
		$default_class = str_replace('Master','',$default_class);
		$default_class = str_replace('Control','',$default_class);
		$default_class .= 'Detail';
		
		$default = array(
			'detail_class' =>	$default_class, 
			'detail_field' =>	'detail_tablename'
		);
		
		if (!isset($this->__settings[$model->alias]))  $this->__settings[$model->alias] = $default; 
		$this->__settings[$model->alias] = am($this->__settings[$model->alias], ife(is_array($settings), $settings, array()));
		
	}
	
	function afterFind (&$model, $results, $primary = false) {
		
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		// set DETAIL if more than ONE result
		if ($primary && isset($results[0][$model->alias][$detail_field]) && $model->recursive > 0) {
			foreach ($results as $key => $result) {
				
				$associated = array();
				
				$detail_model = new Model( false, $result[$model->alias][$detail_field] );
				
				$associated = $detail_model->find(array('id' => $result[$model->alias]['id']), null, null, -1);
				$results[$key][$detail_class] = $associated['Model'];
			}
		} 
		
		// set DETAIL if ONLY one result
		else if( isset($results[$model->alias][$detail_field]) ) {
			
			$associated = array();
			
			$detail_model = new Model( false, $results[$model->alias][$detail_field] );
			
			$associated = $detail_model->find(array('id' => $results[0][$model->alias]['id']), null, null, -1);
			$results[$detail_class] = $associated['Model'];
			
		}
		
		return $results;
		
	}
	
	function beforeValidate (&$model) {
		// placeholder for automagic validation...
	}
	
	function afterSave (&$model, $created) {
		
		// make all SETTINGS into individual VARIABLES, with the KEYS as names
		extract($this->__settings[$model->alias]);
		
		// get DETAIL table name and create DETAIL model object
		$associated = $model->find(array('id' => $model->id), null, null, -1);
		$detail_model = new Model( false, $associated[$model->alias][$detail_field] );
		
		// set ID (for edit, blank for add) and model object NAME/ALIAS for save
		if ( isset($model->id) ) $detail_model->id = $model->id;
		$detail_model->name = $detail_class;
		$detail_model->alias = $detail_class;
		
		// save detail DATA
		$result = $detail_model->save($model->data);
		
		return $result;
	}
	
}

?>