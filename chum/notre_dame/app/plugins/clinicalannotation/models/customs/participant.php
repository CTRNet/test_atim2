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
					'conditions' => array("MiscIdentifier.identifier_name LIKE '%no lab'"))));
			$this->bindModel($has_many_details, false);			
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));

			$result[0]['identifiers'] = "";
			$temp_array = array();
			foreach($result['MiscIdentifier'] as $mi){
				$temp_array[__($mi['identifier_name'], true)] = $mi['identifier_value'];	
			}
			asort($temp_array);
			foreach($temp_array as $key => $value){
				$result[0]['identifiers'] .= $key." - ".$value."<br/>";
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
}

?>