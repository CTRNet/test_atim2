<?php
class Group extends AppModel {

	var $actsAs = array('Acl' => array('requester'));
	
	var $hasMany = array('User'); 
	
	function parentNode() {    
		return null;
	}
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Group.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Group.id'=>$variables['Group.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Group']['name'] ),
					'title'			=>	array( NULL, $result['Group']['name'] ),
					
					'description'	=>	array(
						'users'		=>	count($result['User']),
						'created'	=>	$result['Group']['created']
					)
				)
			);
		}
		
		return $return;
	}

}
?>