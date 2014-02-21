<?php
/*
 * Created on 2009-11-26
 * Author NL
 *
 * Offer an example of code override.
 */
	 
class EventMastersControllerCustom extends EventMastersController {
 
	function imageryReport( $participant_id ){
		$conditions = array('EventMaster.participant_id' => $participant_id, 
			'EventControl.flag_active' => '1',
			"EventControl.event_group LIKE 'imagery'");
		$this->request->data = $this->EventMaster->find('all', array('conditions' => $conditions, 'order' => 'EventMaster.event_date DESC'));
		$detail_link_parameters = array();
		foreach($this->request->data as $key => $record) {
			$this->request->data[$key]['EventMaster']['formated_event_date'] = $this->getFormatedDatetimeString($this->request->data[$key]['EventMaster']['event_date']);
		}	
		$this->Structures->set('empty');
		$atim_menu_variables['Participant.id'] = $participant_id;
		$this->set('atim_menu_variables', $atim_menu_variables);
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/EventMasters/imageryReport/%%Participant.id%%/'));
		
	}
}
	
?>
