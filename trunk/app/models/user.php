<?php
class User extends AppModel {

	var $belongsTo = array('Group');
	var $hasMany = array('Post');
	
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
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['User']['name'] ),
					'title'			=>	array( NULL, $result['User']['name'] ),
					
					'description'	=>	array(
						'username'		=>	$result['User']['username'],
						'email'		=>	$result['User']['email'],
						'created'	=>	$result['User']['created']
					)
				)
			);
		}
		
		return $return;
	}

}
?>