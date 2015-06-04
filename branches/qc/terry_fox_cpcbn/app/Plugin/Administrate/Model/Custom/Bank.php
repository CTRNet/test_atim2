<?php

class BankCustom extends Bank {	
	var $useTable = 'banks';
	var $name = "Bank";
			
	function getBankPermissibleValues(){
		$result = array();
		if($_SESSION['Auth']['User']['group_id'] == '1') {
			$result = parent::getBankPermissibleValues();
		} else {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);		
			$bank_data = $this->find('first', array('conditions' => array('Bank.id' => $group_data['Group']['bank_id'])));		
			$result = array();
			if($bank_data) {
				$result[$bank_data["Bank"]["id"]] = $bank_data["Bank"]["name"];
			}
		}
		return $result;
	}
	
	function getBankPermissibleValuesForControls(){
		$final_result = array();
		foreach(parent::getBankPermissibleValues() as $bank_id => $bank_name) {
			$final_result[$bank_id] = preg_match('/^(.*)\ #[0-9]+$/', $bank_name, $matches)? $matches[1] : $bank_name;
		}
		return $final_result;
	}
	
	function allowDeletion($bank_id){
		$res = parent::allowDeletion($bank_id);
		if(!$res['allow_deletion']) return $res;

		$ParticipantModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$data = $ParticipantModel->find('first', array('conditions' => array('Participant.qc_tf_bank_id' => $bank_id)));
		if($data) {
			return array('allow_deletion' => false, 'msg' => 'at least one participant is linked to that bank');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>
