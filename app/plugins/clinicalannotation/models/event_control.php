<?php

class EventControl extends ClinicalannotationAppModel {
	
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
	
	function getEventGroupPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $event_control) {
			$result[$event_control['EventControl']['event_group']] = __($event_control['EventControl']['event_group'], true);
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
	
	function buildAddLinks($event_ctrl_data, $participant_id, $event_group){
		$links = array();
		foreach($event_ctrl_data as $event_ctrl){
			$links[] = array(
					'order' => $event_ctrl['EventControl']['display_order'],
					'label' => __($event_ctrl['EventControl']['disease_site'], true).' - '.__($event_ctrl['EventControl']['event_type'], true),
					'link' => '/clinicalannotation/event_masters/add/'.$event_group.'/'.$participant_id.'/'.$event_ctrl['EventControl']['id']
			);
		}
		AppController::buildBottomMenuOptions($links);
		return $links;
	}
}

?>