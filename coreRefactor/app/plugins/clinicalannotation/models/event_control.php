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
						__('event_form_type', TRUE)	=>	__($result['EventControl']['disease_site'], TRUE) . ' - ' . __($result['EventControl']['event_type'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}

	/**
	 * Get permissible values array gathering all existing event disease sites.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getEventDiseaseSitePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $event_control) {
			$result[$event_control['EventControl']['disease_site']] = __($event_control['EventControl']['disease_site'], true);
		}
		asort($result);
		
		return $result;
	}
	
	/**
	 * Get permissible values array gathering all existing event types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getEventTypePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $event_control) {
			$result[$event_control['EventControl']['event_type']] = __($event_control['EventControl']['event_type'], true);
		}
		asort($result);
		
		return $result;
	}
}

?>