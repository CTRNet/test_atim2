<?php

class Bank extends AdministrateAppModel {
	
	var $registered_view = array(
			'InventoryManagement.ViewCollection' => array('Collection.bank_id'),
			'InventoryManagement.ViewSample' => array('Collection.bank_id'),
			'InventoryManagement.ViewAliquot' => array('Collection.bank_id')
	);
	
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
		$this->Group = AppModel::getInstance("Administrate", "Group", true);
		$data = $this->Group->find('first', array('conditions' => array('Group.bank_id' => $bank_id)));
		return !empty($data);
	}
}

?>
