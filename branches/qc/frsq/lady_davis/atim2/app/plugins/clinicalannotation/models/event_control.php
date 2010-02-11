<?php

class EventControl extends ClinicalannotationAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['EventControl.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('EventControl.id'=>$variables['EventControl.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	array( NULL, __('annotation', TRUE) ),
					
					'description'	=>	array(
						__('event_group', TRUE)		=>	__($result['EventControl']['event_group'], TRUE),
						__('disease_site', TRUE)	=>	__($result['EventControl']['disease_site'], TRUE),
						__('event_type', TRUE)		=>	__($result['EventControl']['event_type'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}

}

?>