<?php

class Structure extends AppModel {

	var $name = 'Structure';

	var $hasMany = array('StructureFormat');
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Structure.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Structure.id'=>$variables['Structure.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Structure']['alias'] ),
					'title'			=>	array( NULL, $result['Structure']['alias'] ),
					
					'description'	=>	array(
						'id'			=>	$result['Structure']['id'],
						'title'		=>	$result['Structure']['language_title'],
						'help'		=>	$result['Structure']['language_help'],
						'created'	=>	$result['Structure']['created']
					)
				)
			);
		}
		
		return $return;
	}

}

?>