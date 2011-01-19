<?php

class Material extends AppModel
{
	var $name = 'Material';
	var $useTable = 'materials';

    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Material.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Material.id'=>$variables['Material.id'])));
			
			$return = array(
				'Summary' => array(
					'menu' => array(NULL, $result['Material']['item_name']),
					'title' => array(NULL, $result['Material']['item_name']),
					'description' => array(
						'item type'	=>	$result['Material']['item_type'],
						'description'	=>	$result['Material']['description']
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>