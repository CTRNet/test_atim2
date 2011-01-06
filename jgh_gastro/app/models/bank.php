<?php
class Bank extends AppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Bank.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Bank.id'=>$variables['Bank.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, $result['Bank']['name'] ),
				'title'			=>	array( NULL, $result['Bank']['name'] ),
				'data'			=> $result,
				'structure alias'=>'banks'
			);
		}
		
		return $return;
	}
	
}
?>