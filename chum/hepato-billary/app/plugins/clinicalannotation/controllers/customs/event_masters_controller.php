<?php
/*
 * Created on 2009-11-26
 * Author NL
 *
 * Offer an example of code override.
 */
	 
class EventMastersControllerCustom extends EventMastersController {
 
	function imageryReport( $participant_id ){
		$this->data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventControl.form_alias LIKE "qc_hb_imaging%"')));
		foreach($this->data as $key => $record) {
			$this->data[$key]['EventMaster']['formated_event_date'] = $this->getFormatedDatetimeString($this->data[$key]['EventMaster']['event_date']);
		}
		
		$this->Structures->set('empty');
		$atim_menu_variables['Participant.id'] = $participant_id;
		$this->set('atim_menu_variables', $atim_menu_variables);
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/event_masters/imageryReport/%%Participant.id%%/'));
	}
}
	
?>
