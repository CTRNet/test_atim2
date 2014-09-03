<?php 

	$query_to_update = "UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;";
	try{
		$this->Participant->query($query_to_update);
		$this->Participant->query(str_replace("participants", "participants_revs", $query_to_update));
	}catch(Exception $e){
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}	