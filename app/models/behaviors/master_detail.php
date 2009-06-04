<?php  

class MasterDetailBehavior extends ModelBehavior {
	
	var $__settings = array(); 
	
	function setup(&$model, $settings = array()) { 
		
		$default_class = str_replace('Master','',$model->alias);
		$default_class = str_replace('Control','',$model->alias);
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
}

?>