<?php

class Correspondence extends ClinicalAnnotationAppModel
{

	function summary($variables=array()) {
		$return = false;

		if (isset($variables['Participant.id'])) {

			$result = $this->find('first', array('conditions'=>array('Correspondence.id'=>$variables['Correspondence.id'])));

			$return = array(
				'Summary' => array(
					'correspondence_datetime' =>	array(NULL, $result['Correspondence']['correspondence_datetime']),
					'ttr_staff'	     		  =>	array(NULL, $result['Correspondence']['ttr_staff']),
					'correspondence_type' 	  =>	array(NULL, $result['Correspondence']['correspondence_type']),
					'purpose'	     		  =>	array(NULL, $result['Correspondence']['purpose']),
					'location' 				  =>	array(NULL, $result['Correspondence']['location']),
					'notes'	     			  =>	array(NULL, $result['Correspondence']['notes']),
					'participant_id'		  =>    array(NULL, $result['Correspondence']['participant_id'])
			)
			);
		}
		return $return;
	}
}

?>