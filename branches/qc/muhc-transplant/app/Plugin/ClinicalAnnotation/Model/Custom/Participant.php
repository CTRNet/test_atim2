<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = "Participant";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$joins = array(
				array(
					'table'	=> 'banks',
					'alias'	=> 'Bank',
					'type'	=> 'INNER',
					'conditions' => 'Bank.id = Participant.muhc_participant_bank_id'));
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id']), 'joins' => $joins, 'fields' => array('Bank.*, Participant.*'),));	
			$result[0]['coded_identifiers'] = "";
			$title = $result['Bank']['muhc_irb_nbr'].' #? ('.$result['Participant']['participant_identifier'].')';
				
			$identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
			$identifier_results = $identifier_model->find('all', array('conditions' => array(
					'MiscIdentifier.participant_id' => $variables['Participant.id'],
					'MiscIdentifierControl.misc_identifier_name' => 'participant coded identifier'))
			);
			if(!empty($identifier_results)){
				$first_id = '';
				foreach($identifier_results as $ir){
					if(!$first_id) $first_id = $ir['MiscIdentifier']['identifier_value'];
					$result[0]['coded_identifiers'] .= $ir['MiscIdentifier']['identifier_value']."\n";
				}
				$title = $result['Bank']['muhc_irb_nbr'].' #'.$first_id.((sizeof($identifier_results) > 1)?',etc':'');
			}
			
			$return = array(
					'menu'				=>	array( NULL, $title),
					'title'				=>	array( NULL, $title),
					'structure alias' 	=> 'participants,muhc_coded_identifiers_summary',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function validates($options = array()){
		$result = parent::validates($options);
	
		if(array_key_exists('Participant', $this->data) && array_key_exists('muhc_precautions_other', $this->data['Participant'])) {
			$test = ($this->data['Participant']['muhc_precautions_other'] == 'y')? 1 : 0;
			$test += strlen($this->data['Participant']['muhc_precautions_other_specify'])? 1 : 0;
			if($test == 1) {
				$this->validationErrors['muhc_precautions_other'][] = 'when other precaution exists, both other check box and specify text box should be completed';
				$result = false;
			}
		}
		
		return $result;
	}
	
	
	
}

?>