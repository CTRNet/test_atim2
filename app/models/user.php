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
				'Summary' => array(
					'menu'			=>	array( NULL, $display_name ),
					'title'			=>	array( NULL, $display_name ),
					
					'description'	=>	array(
						'username'	=>	$result['User']['username'],
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