<?php
	
	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	if(!$this->Participant->save(array('Participant' => array('participant_identifier' => 'ATIMp-'.$this->Participant->id)))) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	// --------------------------------------------------------------------------------
	// Happy feature... :-)
	// -------------------------------------------------------------------------------- 
	
	if($this->Participant->id == '8000') {
		$this->addWarningMsg("Vous venez de créer le 8000ème participants dans ATiM!<br> 
			L'équipe IT sera heureuse d'offrir à votre banques des Natas et du champagne pour feter cela!<br>
			Pésentez vous à l'équipe IT avec le numéro #984362822_8000!", true);
	} else if(($this->Participant->id % 100) == '0') {
		$par_id = $this->Participant->id;
		$this->addWarningMsg("Vous venez de créer le ".$par_id."ème participants dans ATiM!<br> 
			L'équipe IT sera heureuse de vous offrir un croissant et un café demain matin pour feter cela!<br>
			Pésentez vous à l'équipe IT avec le numéro #9843".($par_id-365)."6802122_".$par_id."!", true);
	}
	
?>