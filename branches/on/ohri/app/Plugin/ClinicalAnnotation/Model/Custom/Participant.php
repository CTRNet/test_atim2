<?php

class ParticipantCustom extends Participant {

	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
							
			$identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
			$identifier_results = $identifier_model->find('first', array('conditions' => array(
				'MiscIdentifier.participant_id' => $variables['Participant.id'],
				'MiscIdentifierControl.misc_identifier_name LIKE' => 'ohri_bank_participant_id'))
			);
						
			//Add No Labs to description
			$title = (isset($identifier_results['MiscIdentifier']['identifier_value'])? __('ohri_bank_participant_id').' '.$identifier_results['MiscIdentifier']['identifier_value'] : __('no ohri_bank_participant_id')).' ['.$result['Participant']['participant_identifier'].']';
			
			$return = array(
				'menu'				=>	array( NULL, $title),
				'title'				=>	array( NULL, $title),
				'structure alias' 	=> 'participants',
				'data'				=> $result
			);
		}
		
		return $return;
	}
}

?>