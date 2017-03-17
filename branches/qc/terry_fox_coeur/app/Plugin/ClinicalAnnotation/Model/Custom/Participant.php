<?php

class ParticipantCustom extends Participant {
	
	var $useTable = 'participants';
	var $name = 'Participant';
	
	var $registered_view = array(
		'InventoryManagement.ViewCollection' => array('Participant.id'),
		'InventoryManagement.ViewSample' => array('Participant.id'),
		'InventoryManagement.ViewAliquot' => array('Participant.id')
	);
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$joins = array(array(
				'table' => 'banks',
				'alias'	=> 'Bank',
				'type'	=> 'LEFT',
				'conditions' => array('Bank.id = Participant.qc_tf_bank_id', 'Bank.deleted <> 1')
			));
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id']), 'joins' => $joins, 'fields' => 'Participant.*, Bank.*'));
			
			
			$title = $result['Participant']['participant_identifier'];
			if(AppController::getInstance()->Session->read('flag_show_confidential')) {
				$title =  $result['Bank']['name'].' #'.$result['Participant']['qc_tf_bank_identifier'].' ['. $result['Participant']['participant_identifier'].']';
			}
			
			$return = array(
					'menu'				=>	array( NULL, ($title) ),
					'title'				=>	array( NULL, ($title) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function beforeSave($options = array()) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
	function beforeFind($queryData){
		if(($_SESSION['Auth']['User']['group_id'] != '1')
				&& is_array($queryData['conditions'])
				&& AppModel::isFieldUsedAsCondition("Participant.qc_tf_bank_identifier", $queryData['conditions'])) {
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
			if(isset($results[0]['Participant']['qc_tf_bank_id']) || isset($results[0]['Participant']['qc_tf_bank_identifier'])) {
				foreach($results as &$result){
					if((!isset($result['Participant']['qc_tf_bank_id'])) || $result['Participant']['qc_tf_bank_id'] != $user_bank_id) {
						$result['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
						$result['Participant']['qc_tf_bank_identifier'] = CONFIDENTIAL_MARKER;
					}
				}
			} else if(isset($results['Participant'])){
				pr('TODO afterFind participants');
				pr($results);
				exit;
			}
		}
	
		return $results;
	}
	
}
