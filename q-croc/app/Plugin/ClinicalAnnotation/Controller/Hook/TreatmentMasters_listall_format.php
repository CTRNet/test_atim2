<?php 
	
	$this->Structures->set('treatmentmasters,qcroc_treatmentmasters_precision');
	$this->set('add_link_for_qcroc_forms',$this->Participant->buildAddLinkForQcrocForm($participant_id));
	