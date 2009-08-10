<?php
class Bank extends AppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Bank.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Bank.id'=>$variables['Bank.id'])));
			
			$return = array(
				__('Summary', TRUE) => array(
					__('menu', TRUE)		=>	array( NULL, __($result['Bank']['name'],TRUE) ),
					__('title', TRUE)		=>	array( NULL, __($result['Bank']['name'], TRUE) ),
					
					__('description', TRUE)	=>	array(
						__('created', TRUE)	=>	__($result['Bank']['created'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
	
}
?>