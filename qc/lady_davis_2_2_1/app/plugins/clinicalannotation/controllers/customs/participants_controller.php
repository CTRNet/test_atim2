<?php
class ParticipantsControllerCustom extends ParticipantsController{
	function add(){
		//copy pasted from the org controller
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/participants/index'));

		if(!empty($this->data)){
			$this->Participant->patchIcd10NullValues($this->data);
			if ($this->Participant->save($this->data)){
				
				$key = $this->Participant->getKeyIncrement('main_participant_id', "%%key_increment%%"); //TODO: In ATiM 2.1.1+ replace with atimNew misc ident controls
				$this->MiscIdentifier->save(array("MiscIdentifier" => array(
					"identifier_value"				=> $key,
					"misc_identifier_control_id"	=> 9,//TODO: remove hardcode
					"identifier_name"				=> "collection",//TODO: remove hardcode
					"participant_id"				=> $this->Participant->getLastInsertId()
				)));
				$this->atimFlash('your data has been saved', '/clinicalannotation/participants/profile/'.$this->Participant->getLastInsertID());
			}
		}
	}
}