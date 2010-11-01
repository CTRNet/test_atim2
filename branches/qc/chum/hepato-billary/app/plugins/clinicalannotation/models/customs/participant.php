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
					'conditions' => array("MiscIdentifier.identifier_name LIKE 'hepato_bil_bank_participant_id'"))));			
			
			$this->bindModel($has_many_details, false);			
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'], )));
			$this->unbindModel(array('hasMany' => array('MiscIdentifier')), false);
						
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, ($result['Participant']['first_name'].' - '.$result['Participant']['last_name']) ),
					'title'			=>	array( NULL, __('participant', TRUE) . ': ' . ($result['Participant']['first_name'].' - '.$result['Participant']['last_name']) ),
					
					'description'		=>	array(
						__('participant code', TRUE)	=>	$result['Participant']['participant_identifier'],
						__('date of birth', TRUE)			=>	$result['Participant']['date_of_birth'],
						__('vital status', TRUE)			=>	array($result['Participant']['vital_status'], 'vital_status'), // select-option
						__('sex', TRUE)						=>	array($result['Participant']['sex'], 'sex') // select-option
					)
				)
			);
			
			//Add No Labs to description
			if(!empty($result['MiscIdentifier'])) $return['Summary']['description'][''] = '&nbsp;';
			foreach($result['MiscIdentifier'] as $new_no_lab) {
				$return['Summary']['description'][__($new_no_lab['identifier_name'], TRUE)] = $new_no_lab['identifier_value'];
			}		
		}
		
		return $return;
	}
}

?>