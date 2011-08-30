<?php

class ParticipantCustom extends Participant {

	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
							
			$identifier_model = AppModel::getInstance('Clinicalannotation', 'MiscIdentifier', true);
			$identifier_results = $identifier_model->find('first', array('conditions' => array(
				'MiscIdentifier.participant_id' => $variables['Participant.id'],
				'MiscIdentifierControl.misc_identifier_name LIKE' => 'ohri_bank_participant_id'))
			);
						
			//Add No Labs to description
			$bank_identifier = '';
			if(isset($identifier_results['MiscIdentifier']['identifier_value'])) {
				$bank_identifier = $identifier_results['MiscIdentifier']['identifier_value'];
			}
			
			$return = array(
					'menu'				=>	array( NULL, empty($bank_identifier)? __('unknown', true) : $bank_identifier ),
					'title'				=>	array( NULL, empty($bank_identifier)? __('unknown', true) : __('ohri_bank_participant_id', true).": ".$bank_identifier ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
}

?>