<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));	
			
			$bank_identfiers = CONFIDENTIAL_MARKER;
			if($result['Participant']['qc_tf_bank_participant_identifier'] != CONFIDENTIAL_MARKER) {	
				$bank_model = AppModel::getInstance('Administrate', 'Bank', true);
				$bank = $bank_model->find('first', array('conditions' => array('Bank.id' => $result['Participant']['qc_tf_bank_id'])));
				$bank_identfiers = (empty($bank['Bank']['name'])? '?' : $bank['Bank']['name']). ' : '. $result['Participant']['qc_tf_bank_participant_identifier'];
			}
			
			$label = $bank_identfiers . ' ['. $result['Participant']['participant_identifier'] .']';
			$return = array(
				'menu'				=>	array( NULL, $label ),
				'title'				=>	array( NULL, $label),
				'structure alias' 	=> 'participants',
				'data'				=> $result
			);	
		}
		
		return $return;
	}
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		if(array_key_exists('qc_tf_bank_id', $this->data['Participant'])) {
			$conditions = array(
				'Participant.qc_tf_bank_id'=> $this->data['Participant']['qc_tf_bank_id'], 
				'Participant.qc_tf_bank_participant_identifier'=> $this->data['Participant']['qc_tf_bank_participant_identifier']);
			if($this->id) $conditions[] = 'Participant.id != '.$this->id;
			
			$count = $this->find('count', array('conditions'=> $conditions));
			if($count) {
				$this->validationErrors['qc_tf_bank_participant_identifier'][] = 'this bank participant identifier has already been assigned to a patient of this bank';
				$result = false;
			}
		}
		
		return $result;
	}
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
		&& is_array($queryData['conditions'])
		&& AppModel::isFieldUsedAsCondition("Participant.qc_tf_bank_participant_identifier", $queryData['conditions'])) {	
			AppController::addWarningMsg(__('your search will be limited to your bank'));
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];
			$queryData['conditions'][] = array("Participant.qc_tf_bank_id" => $user_bank_id);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		if($_SESSION['Auth']['User']['group_id'] != '1') {
			$GroupModel = AppModel::getInstance("", "Group", true);
			$group_data = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
			$user_bank_id = $group_data['Group']['bank_id'];			
			if(isset($results[0]) && isset($results[0]['Participant'])){
				foreach($results as &$result){
					if($result['Participant']['qc_tf_bank_id'] != $user_bank_id) {
						$result['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
						$result['Participant']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results[0]['Participant'][0])){
				pr('TODO afterFind participants');
				pr($results);
				exit;
			} else if(isset($results['Participant'])){
				pr('TODO afterFind participants');
				pr($results);
				exit;
			}
		}

		return $results;
	}

}

?>