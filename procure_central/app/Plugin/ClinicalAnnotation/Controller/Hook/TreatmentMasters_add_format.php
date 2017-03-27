<?php 
	
	// Clinical file update process
	if (empty($this->request->data)) $this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participant_id, $this->passedArgs);
	$this->Participant->addClinicalFileUpdateProcessInfo();
	