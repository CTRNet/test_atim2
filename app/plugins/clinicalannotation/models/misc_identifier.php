<?php

class MiscIdentifier extends ClinicalAnnotationAppModel {
	
	var $belongsTo = array(
		'Participant' => array(
			'className' => 'Clinicalannotation.Participant',
			'foreignKey' => 'participant_id'));	
	
    function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['MiscIdentifier.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('MiscIdentifier.id'=>$variables['MiscIdentifier.id'])));
			
			$return = array(
				'name'	=>	array( NULL, $result['MiscIdentifier']['name']),
				'participant_id' => array( NULL, $result['MiscIdentifier']['participant_id']),
				'data'			=> $result,
				'structure alias'=>'miscidentifiers'
			);
		}
		
		return $return;
	}
}

?>