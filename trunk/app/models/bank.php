<?php
class Bank extends AppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Bank.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Bank.id'=>$variables['Bank.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, __($result['Bank']['name'],TRUE) ),
					'title'			=>	array( NULL, __($result['Bank']['name'], TRUE) ),
					
					'description'	=>	array(
						__('created', TRUE)	=>	__($result['Bank']['created'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
	
}
?>