<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = "Participant";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			
			//custom code to add no labo----
			$this->bindModel(
				array('hasMany' => array(
					'MiscIdentifier'	=> array(
						'className'  	=> 'ClinicalAnnotation.MiscIdentifier',
						'foreignKey'	=> 'participant_id',
						'conditions' => array('misc_identifier_control_id' => 3)))));
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$title = $result['Participant']['first_name'].' '.$result['Participant']['last_name'];
			$title = strlen($title)? $title  : '?';
			if(!empty($result['MiscIdentifier'])){
				$temp_array = array();
				foreach($result['MiscIdentifier'] as $ir){
					$temp_array[] = $ir['identifier_value'];	
				}
				asort($temp_array);
				$title .= ' ['. implode(" - ", $temp_array).']';
			}else{
				$title .= ' [?]';
			}
			
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