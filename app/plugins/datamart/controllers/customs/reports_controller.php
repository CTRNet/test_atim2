<?php
class ReportsControllerCustom extends ReportsController{
	function finchy(){
		App::import('Model', 'Clinicalannotation.Participant');
		$this->Participant = new Participant();
		$this->data = $this->Participant->find('first', array('fields' => array ('MIN(date_of_death) AS min_date_of_death')));
		$this->Structures->set("custom_participant");
	}
}