<?php 

	$queryToUpdate = "UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;";
	try{
		$this->Participant->query($queryToUpdate);
		$this->Participant->query(str_replace("participants", "participants_revs", $queryToUpdate));
	}catch(Exception $e){
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}