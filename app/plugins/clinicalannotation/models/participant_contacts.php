<?php

class ParticipantContact extends ClinicalAnnotationAppModel
{
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['ParticipantContact.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('ParticipantContact.id'=>$variables['ParticipantContact.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['ParticipantContact']['name'] ),
					'title'			=>	array( NULL, $result['ParticipantContact']['name']),
					'participant_id' => array( NULL, $result['ParticipantContact']['participant_id'],
					'description'	=>	array(
						'facility'	=>	$result['ParticipantContact']['facility'],
						'type'		=>	$result['ParticipantContact']['contact_type'],
						'other_type'		=>	$result['ParticipantContact']['other_contact_type'],
						'effective_date'			=>	$result['ParticipantContact']['effective_date'],
						'expiry_date'						=>		$result['ParticipantContact']['expiry_date'],
						'memo'		=> $result['ParticipantContact']['memo'],
						'street'	=> $result['ParticipantContact']['street'],
						'city'		=> $result['ParticipantContact']['city'],
						'region'	=> $result['ParticipantContact']['region'],
						'country' 	=> $result['ParticipantContact']['country'],
						'mail_code' => $result['ParticipantContact']['mail_code'],
						'phone_num'	=>	$result['ParticipantContact']['phone'],
						'phone_type' => $result['ParticipantContact']['phone_type'],
						'phone_secondary_num' => $result['ParticipantContact']['phone_secondary'],
						'phone_secondary_type' => $result['ParticipantContact']['phone_secondary_type']
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>