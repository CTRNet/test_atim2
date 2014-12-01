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
			$title = __('participant identifier').': '.$result['Participant']['participant_identifier'];
			$return = array(
					'menu'				=>	array( NULL, ($title) ),
					'title'				=>	array( NULL, ($title) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	function updateParticipantVOANumbers($participant_id) {
		if($participant_id) {		
			$participant_data = $this->getOrRedirect($participant_id);
			$voa_updated_query = "SELECT GROUP_CONCAT(Collection.collection_voa_nbr  ORDER BY Collection.collection_voa_nbr ASC SEPARATOR ' - ') AS ovcare_voa_nbrs
				FROM collections Collection
				WHERE Collection.deleted <> 1 AND Collection.participant_id = $participant_id
				GROUP BY Collection.participant_id";
			$voas = $this->tryCatchQuery($voa_updated_query);
			$new_ovcare_voa_nbrs = isset($voas[0][0]['ovcare_voa_nbrs'])? $voas[0][0]['ovcare_voa_nbrs'] : 'n/a';
			if($new_ovcare_voa_nbrs != $participant_data['Participant']['ovcare_voa_nbrs']) {
				$this->data = array();
				$this->id = $participant_id;
				$this->check_writable_fields = false;
				$this->save(array('Participant' => array('ovcare_voa_nbrs' => $new_ovcare_voa_nbrs)), false);
			}	
		}
	}
}
?>