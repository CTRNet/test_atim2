<?php

class Drug extends DrugAppModel {
	
	var $name = 'Drug';
	var $useTable = 'drugs';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Drug.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Drug.id'=>$variables['Drug.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['Drug']['generic_name']),
					'title'			=>	array( NULL, $result['Drug']['generic_name']),
					
					'description'	=>	array(
						'type'		=>	$result['Drug']['type'],
						'description'   =>  $result['Drug']['description']
					)
				)
			);
		}
		
		return $return;
	}
	
 	/**
	 * Get permissible values array gathering all existing drugs.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'Drug.id', 'default' => (translated string describing drug))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('order' => array('Drug.generic_name'))) as $drug){
			$result[] = array("value" => $drug["Drug"]["id"], "default" => $drug["Drug"]["generic_name"]);
		}
		return $result;
	}
	
}

?>