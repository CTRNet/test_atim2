<?php
	
	if($this->Session->read('flag_show_confidential')) {
		$this->Structures->set('participants,chus_participants_and_identifiers');
	}