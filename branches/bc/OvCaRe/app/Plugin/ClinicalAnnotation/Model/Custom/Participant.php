<?php

class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	var $hasMany = array(
		'DiagnosisMaster' => array(
			'className'   => 'ClinicalAnnotation.DiagnosisMaster',
			 'foreignKey'  => 'participant_id')
	); 	

	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
			$voa_nbrs= $MiscIdentifier->find('all', array('conditions'=>array('MiscIdentifier.participant_id = Participant.id', 'MiscIdentifier.deleted <> 1', "MiscIdentifierControl.misc_identifier_name = 'VOA#'")));
			$title = __('VOA#').': ';
			if($voa_nbrs) {
				$all_voas = array();
				foreach($voa_nbrs as $new_voa) $all_voas[] = $new_voa['MiscIdentifier']['identifier_value'];
				$title .= implode('/', $all_voas);
			} else {
				$title .= '-';
			}
			$title .= ' ['.$result['Participant']['participant_identifier'].']';
			
			$return = array(
					'menu'				=>	array( NULL, ($title) ),
					'title'				=>	array( NULL, ($title) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}

}
?>