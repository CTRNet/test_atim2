<?php
class ParticipantsControllerCustom extends ParticipantsController{
	var $uses = array(
		'ClinicalAnnotation.Participant'
	);
	
	function customControllerTest(){
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		echo 'Model: ', get_class($this->Participant), '<br/>';
		pr($this->Participant->getOne());
		die("Custom controller works");
	}
}