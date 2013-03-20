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
	
	function allowDeletion($bank_id){
		$GroupModel = AppModel::getInstance("", "Group", true);
		$data = $GroupModel->find('first', array('conditions' => array('Group.bank_id' => $bank_id)));
		if($data) {
			return array('allow_deletion' => false, 'msg' => 'at least one group is linked to that bank');
		}

		$CollectionModel = AppModel::getInstance('InventoryManagement', 'Collection', true);
		$data = $CollectionModel->find('first', array('conditions' => array('Collection.bank_id' => $bank_id)));
		if($data) {
			return array('allow_deletion' => false, 'msg' => 'at least one collection is linked to that bank');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>
