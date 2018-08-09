<?php

class BankCustom extends Bank {	
	var $useTable = 'banks';
	var $name = "Bank";
			
	public function getBankPermissibleValues(){
		$result = array();
		if($_SESSION['Auth']['User']['group_id'] == '1') {
			$result = parent::getBankPermissibleValues();
		} else {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);		
			$bankData = $this->find('first', array('conditions' => array('Bank.id' => $groupData['Group']['bank_id'])));		
			$result = array();
			if($bankData) {
				$result[$bankData["Bank"]["id"]] = $bankData["Bank"]["name"];
			}
		}
		return $result;
	}
	
	public function getBankPermissibleValuesForControls(){
		$finalResult = array();
		foreach(parent::getBankPermissibleValues() as $bankId => $bankName) {
			$finalResult[$bankId] = preg_match('/^(.*)\ #[0-9]+$/', $bankName, $matches)? $matches[1] : $bankName;
		}
		return $finalResult;
	}
	
	public function allowDeletion($bankId){
		$res = parent::allowDeletion($bankId);
		if(!$res['allow_deletion']) return $res;
		
		$ParticipantModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
		$data = $ParticipantModel->find('first', array('conditions' => array('Participant.qbcf_bank_id' => $bankId)));
		if($data) {
			return array('allow_deletion' => false, 'msg' => 'at least one participant is linked to that bank');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
}