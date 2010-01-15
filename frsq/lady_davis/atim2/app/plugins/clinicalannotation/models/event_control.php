<?php

class EventControl extends ClinicalannotationAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['EventControl.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('EventControl.id'=>$variables['EventControl.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, $result['EventControl']['disease_site'].' - '.$result['EventControl']['event_type'] ),
					'title'			=>	array( NULL, 'Annotation' ),
					
					'description'	=>	array(
						'disease_site'	=>	$result['EventControl']['disease_site'],
						'event_group'	=>	$result['EventControl']['event_group'],
						'event_type'	=>	$result['EventControl']['event_type']
					)
				)
			);
		}
		
		return $return;
	}

}

?>