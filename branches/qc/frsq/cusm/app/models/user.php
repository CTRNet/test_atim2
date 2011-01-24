<?php
class User extends AppModel {

	var $belongsTo = array('Group');
	
	var $actsAs = array('Acl' => array('requester')); 
	
	function parentNode() {    
		
		if (!$this->id && empty($this->data)) {        
			return null;    
		}    
		
		$data = $this->data;    
		
		if (empty($this->data)) {        
			$data = $this->read();    
		}    
		
		if (!$data['User']['group_id']) {        
			return null;    
		} else {        
			return array('Group' => array('id' => $data['User']['group_id']));    
		}
		
	}
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['User.id']) ) {
			$result = $this->find('first', array('conditions'=>array('User.id'=>$variables['User.id'])));
			
			$display_name = trim($result['User']['first_name'].' '.$result['User']['last_name']);
			$display_name = $display_name ? $display_name : $result['User']['username'];
			
			$return = array(
				'menu'			=>	array( NULL, $display_name ),
				'title'			=>	array( NULL, $display_name ),
				'data'			=> $result,
				'structure alias' => 'users'
			);
		}
		
		return $return;
	}
	
	
	function getUsersList() {
		$all_users_data = $this->find('all', array('recursive' => '-1'));
		$result = array();
		foreach($all_users_data as $data) {
			$result[$data['User']['id']] = $data['User']['first_name'] . ' ' . $data['User']['last_name']; 
		}
		return $result;
	}

}
?>