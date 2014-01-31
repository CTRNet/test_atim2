<?php

class ParticipantContact extends ClinicalAnnotationAppModel {
	function beforeFind($queryData){
		if(!AppController::getInstance()->Session->read('flag_show_confidential')){
			$queryData['conditions'][] = 'ParticipantContact.confidential != 1';
		}
		return $queryData;
	}
}

?>