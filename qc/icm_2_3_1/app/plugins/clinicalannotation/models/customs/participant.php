<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = "Participant";
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			
			//custom code to add no labo----
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
				
			$identifier_model = AppModel::getInstance('Clinicalannotation', 'MiscIdentifier', true);
			$identifier_results = $identifier_model->find('all', array('conditions' => array(
				'MiscIdentifier.participant_id' => $variables['Participant.id'],
				'MiscIdentifierControl.misc_identifier_name LIKE' => '%no lab'))
			);
			
			$title = null;
			if(!empty($identifier_results)){
				$result['Participant'] = $identifier_results[0]['Participant'];
				$result[0]['identifiers'] = "";
				$temp_array = array();
				foreach($identifier_results as $ir){
					$temp_array[__($ir['MiscIdentifierControl']['misc_identifier_name'], true)] = $ir['MiscIdentifier']['identifier_value'];	
				}
				asort($temp_array);
				foreach($temp_array as $key => $value){
					$result[0]['identifiers'] .= $key." - ".$value."<br/>";
				}
				
				$title = implode(" ", $temp_array);
			}else{
				$result = $this->findById($variables['Participant.id']);
				$title = __('n/a', true);
			}
			
			//------------------------------
			
			$return = array(
					'menu'				=>	array( NULL, $title ),
					'title'				=>	array( NULL, $title ),
					'structure alias' 	=> 'participants,qc_nd_part_id_summary',
					'data'				=> $result
			);
		}
		
		return $return;
	}
}

?>