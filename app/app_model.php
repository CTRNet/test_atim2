<?php

class AppModel extends Model {
	
	var $actsAs = array('MasterDetail','Revision','SoftDeletable'); 
	
	/**
	 * Ensures that the "created_by" and "modified_by" user id columns are set automatically for all models. This requires
	 * adding in access to the session to the model.
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
		
		return true;
	}
	
	/*
		ATiM 2.0 function
		used instead of Model->delete, becaise softDelete will always return a FALSE
	*/
	
	function atim_delete( $model_id, $cascade=false ) {
		
		$this->id = $model_id;
		
		// delete DATA as normal
		$this->del( $model_id, $cascade );
		
		// do a FIND of the same DATA
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
	
}

?>