<?php

class AppModel extends Model {
	
	var $actsAs = array('MasterDetail','Revision','SoftDeletable');

	//The values in this array can trigger magic actions when applied to a field settings
	private static $magic_coding_icd_trigger_array = array(
			"CodingIcd10Who" => "/codingicd/CodingIcd10s/tool/who", 
			"CodingIcd10Ca" => "/codingicd/CodingIcd10s/tool/ca", 
			"CodingIcdo3Morpho" => "/codingicd/CodingIcdo3s/tool/morpho", 
			"CodingIcdo3Topo" => "/codingicd/CodingIcd03s/tool/topo");
	
	/**
	 * Ensures that the "created_by" and "modified_by" user id columns are set automatically for all models. This requires
	 * adding in access to the session to the model.
	 * 
	 * Replace float decimal separator ',' by '.'.
	**/
	 
	function beforeSave(){
		if ( !isset($this->Session) || !$this->Session ){
			if( App::import('Model', 'CakeSession')) $this->Session = new CakeSession(); 
		}
		
		if ( $this->id && $this->Session ) {
			// editing an existing entry with an existing session
			unset($this->data[$this->name]['created_by']);
			$this->data[$this->name]['modified_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
		} 
		
		else if ($this->Session ) {
			// creating a new entry with an existing session
			$this->data[$this->name]['created_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
			$this->data[$this->name]['modified_by'] = $this->Session->check('Auth.User.id') ? $this->Session->read('Auth.User.id') : 0;
		} 
		
		else if ( $this->id ) {
			// editing an existing entry with no session
			unset($this->data[$this->name]['created_by']);
			$this->data[$this->name]['modified_by'] = 0;
		} 
		
		else {
			// creating a new entry with no session
			$this->data[$this->name]['created_by'] = 0;
			$this->data[$this->name]['modified_by'] = 0;
		}
		
		// Manage float record
		foreach($this->_schema as $field_name => $field_properties) {
			$tmp_type = $field_properties['type'];
			if($tmp_type == "float" || $tmp_type == "number" || $tmp_type == "float_positive"){
				if(isset($this->data[$this->name][$field_name])) {
					$this->data[$this->name][$field_name] = str_replace(",", ".", $this->data[$this->name][$field_name]);
					$this->data[$this->name][$field_name] = str_replace(" ", "", $this->data[$this->name][$field_name]);
					$this->data[$this->name][$field_name] = str_replace("+", "", $this->data[$this->name][$field_name]);
					if(is_numeric($this->data[$this->name][$field_name])) {
						if(strpos($this->data[$this->name][$field_name], ".") === 0) $this->data[$this->name][$field_name] = "0".$this->data[$this->name][$field_name];
						if(strpos($this->data[$this->name][$field_name], "-.") === 0) $this->data[$this->name][$field_name] = "-0".substr($this->data[$this->name][$field_name], 1);
					} 
				}
			}
		}

		return true;
	}
	
	/*
		ATiM 2.0 function
		used instead of Model->delete, because SoftDelete Behaviour will always return a FALSE
	*/
	
	function atim_delete( $model_id, $cascade=false ) {
		
		$this->id = $model_id;
		
		// delete DATA as normal
		$this->delete( $model_id, $cascade );
		
		// do a FIND of the same DATA, return FALSE if found or TRUE if not found
		if ( $this->read() ) { 
			return false; 
		} else { 
			return true; 
		}
		
	}
	
	/*
		ATiM 2.0 function
		acts like find('all') but returns array with ID values as arrays key values
	*/
	
	function atim_list( $options=array() ) {
		
		$return = false;
		
		$defaults = array(
			'conditions'	=> NULL,
			'fields'			=> NULL,
			'order'			=> NULL,
			'group'			=> NULL,
			'limit'			=> NULL,
			'page'			=> NULL,
			'recursive'		=> 1,
			'callbacks'		=> true
		);
		
		$options = array_merge( $defaults, $options );
		
		$results = $this->find( 'all', $options );
		
		if ( $results ) {
			$return = array();
			
			foreach ( $results as $key=>$result ) {
				$return[ $result[$this->name]['id'] ] = $result;
			}
		}
		
		return $return;
		
	}
	
	function find($conditions = null, $fields = array(), $order = null, $recursive = null) {
		return Model::find($conditions, $fields, $order, $recursive);
	}
	
	function paginate($conditions, $fields, $order, $limit, $page, $recursive, $extra){
		return $this->find('all', array('conditions' => $conditions, 'order' => $order, 'limit' => $limit, 'offset' => $limit * ($page > 0 ? $page - 1 : 0), 'recursive' => $recursive, 'extra' => $extra));
	}
	
	/**
	 * Replace the %%key_increment%% part of a string with the key increment value
	 * @param string $key - The key to seek in the database
	 * @param string $str - The string where to put the value. %%key_increment%% will be replaced by the value. 
	 * @return string The string with the replaced value or false when SQL error happens
	 */
	function getKeyIncrement($key, $str){
		$this->query('LOCK TABLE key_increments WRITE');
		$result = $this->query('SELECT key_value FROM key_increments WHERE key_name="'.$key.'"');
		if(empty($result)) return false;
		if($this->query('UPDATE key_increments set key_value = key_value + 1 WHERE key_name="'.$key.'"') === false) {
			$this->query('UNLOCK TABLES');
			return false; 
		}
		$this->query('UNLOCK TABLES');
		return str_replace("%%key_increment%%", $result[0]['key_increments']['key_value'], $str);
	}
	
	static function getMagicCodingIcdTriggerArray(){
		return self::$magic_coding_icd_trigger_array;
	}
}

?>