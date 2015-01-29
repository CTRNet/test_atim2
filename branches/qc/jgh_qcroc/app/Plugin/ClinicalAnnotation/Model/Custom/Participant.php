<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = "Participant";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			
			//custom code to add QCROC#----
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
				
			$identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
			$identifier_results = $identifier_model->find('all', array('conditions' => array(
				'MiscIdentifier.participant_id' => $variables['Participant.id'],
				'MiscIdentifierControl.misc_identifier_name LIKE' => 'QCROC-%'))
			);
			
			$title = __('participant identifier').' '.$result['Participant']['participant_identifier'];
			$result['Generated']['qcroc_nbrs'] = '';
			if(!empty($identifier_results)){
				$qcroc_nbrs = array();
				foreach($identifier_results as $qcroc_nbr) $qcroc_nbrs[str_replace('QCROC-', '', $qcroc_nbr['MiscIdentifierControl']['misc_identifier_name'])] = str_replace('QCROC-', '', $qcroc_nbr['MiscIdentifierControl']['misc_identifier_name']).'-'.$qcroc_nbr['MiscIdentifier']['identifier_value'];
				ksort($qcroc_nbrs);
				$result['Generated']['qcroc_nbrs'] = implode("\n", $qcroc_nbrs);
				$title .= ' ('.$result['Generated']['qcroc_nbrs'].')';
			}
			
			//------------------------------
			
			$return = array(
					'menu'				=>	array( NULL, $title ),
					'title'				=>	array( NULL, $title ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
}

?>