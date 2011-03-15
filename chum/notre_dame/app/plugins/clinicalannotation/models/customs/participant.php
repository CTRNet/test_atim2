<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = "Participant";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			
			//custom code to add no labo----
			$has_many_details = array(
				'hasMany' => array('MiscIdentifier' => array(
					'className' => 'Clinicalannotation.MiscIdentifier',
					'foreignKey' => 'participant_id',
					'conditions' => array("MiscIdentifier.identifier_name LIKE '%no lab%'"))));
			$this->bindModel($has_many_details, false);			
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));

			$result[0]['identifiers'] = "";
			foreach($result['MiscIdentifier'] as $mi){
				$result[0]['identifiers'] .= __($mi['identifier_name'], true)." - ".$mi['identifier_value']."<br/>";
			}
			//------------------------------
			
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants,qc_nd_part_id_summary',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function summaryOld( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['Participant.id']) ) {
			
			$has_many_details = array(
				'hasMany' => array('MiscIdentifier' => array(
					'className' => 'Clinicalannotation.MiscIdentifier',
					'foreignKey' => 'participant_id',
					'conditions' => array("MiscIdentifier.identifier_name LIKE '%no lab%'"))));
			
			$this->bindModel($has_many_details, false);			
			$result = $this->find('first', array('conditions'=>array('ParticipantCustom.id'=>$variables['Participant.id'], )));
			$this->unbindModel(array('hasMany' => array('MiscIdentifier')), false);
						
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, ($result['ParticipantCustom']['first_name'].' - '.$result['ParticipantCustom']['last_name']) ),
					'title'			=>	array( NULL, __('participant', TRUE) . ': ' . ($result['ParticipantCustom']['first_name'].' - '.$result['ParticipantCustom']['last_name']) ),
					
					'description'		=>	array(
						__('participant identifier', TRUE)	=>	$result['ParticipantCustom']['participant_identifier'],
						__('date of birth', TRUE)			=>	$result['ParticipantCustom']['date_of_birth'],
						__('vital status', TRUE)			=>	array($result['ParticipantCustom']['vital_status'], 'vital_status'), // select-option
						__('sex', TRUE)						=>	array($result['ParticipantCustom']['sex'], 'sex') // select-option
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