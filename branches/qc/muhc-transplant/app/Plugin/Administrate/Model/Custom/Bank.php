<?php

class BankCustom extends Bank {	
	var $useTable = 'banks';
	var $name = "Bank";
			
	function getBankPermissibleValues(){
		$GroupModel = AppModel::getInstance("", "Group", true);
		$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
		$conditions = array();
/*		if($group_data['Group']['id'] != '1') {	//Not administrator
			$conditions = array('Bank.id' => $group_data['Group']['bank_id']);
		}*/
		$result = array();
		foreach($this->find('all', array('conditions' => $conditions, 'order' => 'Bank.name ASC')) as $bank){
			$result[$bank["Bank"]["id"]] = $bank["Bank"]["muhc_irb_nbr"].' ('.$bank["Bank"]["name"].')';
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
	
		$CollectionModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$data = $CollectionModel->find('first', array('conditions' => array('Participant.muhc_participant_bank_id' => $bank_id)));
		if($data) {
			return array('allow_deletion' => false, 'msg' => 'at least one participant is linked to that bank');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>
