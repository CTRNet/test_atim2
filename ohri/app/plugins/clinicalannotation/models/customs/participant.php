<?php

class ParticipantCustom extends Participant {

	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$has_many_details = array(
				'hasMany' => array('MiscIdentifier' => array(
					'className' => 'Clinicalannotation.MiscIdentifier',
					'foreignKey' => 'participant_id',
					'conditions' => array("MiscIdentifier.identifier_name LIKE 'ohri_bank_participant_id'"))));			
			
			$this->bindModel($has_many_details, false);			
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			$this->unbindModel(array('hasMany' => array('MiscIdentifier')), false);
			
			//Add No Labs to description
			$bank_identifier = '';
			if((!empty($result['MiscIdentifier'])) && ($result['MiscIdentifier'][0]['identifier_name'] == 'ohri_bank_participant_id')) {
				$bank_identifier = $result['MiscIdentifier'][0]['identifier_value'];
			}
			
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, (empty($bank_identifier)? $result['Participant']['participant_identifier'] : $bank_identifier) ),
					'title'			=>	array( NULL, (empty($bank_identifier)? $result['Participant']['participant_identifier'] : $bank_identifier) ),
					
					'description'		=>	array(
						__('ohri_bank_participant_id', true) => $bank_identifier,
						__('name', TRUE)					=>	($result['Participant']['first_name'].' '.$result['Participant']['last_name']),
						__('date of birth', TRUE)			=>	$result['Participant']['date_of_birth'],
						__('vital status', TRUE)			=>	array($result['Participant']['vital_status'], 'vital_status'), // select-option
						__('sex', TRUE)						=>	array($result['Participant']['sex'], 'sex')
					)
				)
			);
		}
		
		return $return;
	}
}

?>