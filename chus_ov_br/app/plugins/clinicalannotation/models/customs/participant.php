<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));	

			$result['FunctionManagement']['frsq_br_nbr'] = '';
			$result['FunctionManagement']['frsq_ov_nbr'] = '';
			$misc_identifier_model = AppModel::getInstance('clinicalannotation', 'MiscIdentifier', true);
			$identifiers = $misc_identifier_model->find('all', array('conditions' => array('Participant.id' => $variables['Participant.id'])));
			foreach($identifiers as $identifier){
				switch($identifier['MiscIdentifierControl']['misc_identifier_name']) {
					case '#FRSQ BR':
						$result['FunctionManagement']['frsq_br_nbr'] .= (empty($result['FunctionManagement']['frsq_br_nbr'])? '' : ' ').$identifier['MiscIdentifier']['identifier_value'];
						break;
					case '#FRSQ OV':
						$result['FunctionManagement']['frsq_ov_nbr'] .= (empty($result['FunctionManagement']['frsq_ov_nbr'])? '' : ' ').$identifier['MiscIdentifier']['identifier_value'];
						break;
					default:	
				}
			}
				
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['first_name'] . ' ' . $result['Participant']['last_name']) ),
					'title'				=>	array( NULL, ($result['Participant']['first_name'] . ' ' . $result['Participant']['last_name']) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);	
		}
		
		return $return;
	}
}

?>