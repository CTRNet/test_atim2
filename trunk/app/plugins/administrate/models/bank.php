<?php

class Bank extends AdministrateAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		if ( isset($variables['Bank.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Bank.id'=>$variables['Bank.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, $result['Bank']['name']),
					'title'			=>	array( NULL, $result['Bank']['name']),
					'description'	=>	array(
						__('description', TRUE)		=>	__($result['Bank']['description'], TRUE)
					)
				)
			);
		}
		return $return;
	}
	
 	/**
	 * Get permissible values array gathering all existing banks.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getBankPermissibleValues(){
		$result = array();
		foreach($this->find('all', array('order' => 'Bank.name ASC')) as $bank){
			$result[$bank["Bank"]["id"]] = $bank["Bank"]["name"];
		}
		return $result;
	}
	
	function isBeingUsed($bank_id){
		App::import("Model", "Administrate.Group");
		$this->Group = new Group();
		$data = $this->Group->find('first', array('conditions' => array('Group.bank_id' => $bank_id)));
		return !empty($data);
	}
}

?>
