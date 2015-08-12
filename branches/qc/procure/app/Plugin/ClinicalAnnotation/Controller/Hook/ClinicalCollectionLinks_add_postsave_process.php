<?php 
	
	if(!isset($this->request->data['Collection']['deleted'])) AppController::addWarningMsg("please validate that all aliquots identifications are consistent with the participant identification");
