<?php
//fetch the available identifiers
$identifier_controls_list = $this->MiscIdentifierControl->find('all', $this->MiscIdentifierControl->find('all', array('conditions' => array('flag_active' => true))));
$this->set('identifier_controls_list',$identifier_controls_list); 
$mil = $this->MiscIdentifier->find('all', array('conditions' =>array('MiscIdentifier.participant_id' => $participant_id)));

//hide identifiers that are already defined for that participant
foreach($identifier_controls_list as $mic_key => $mic){
	foreach($mil as $mi){
		if($mic['MiscIdentifierControl']['misc_identifier_name'] == $mi['MiscIdentifier']['identifier_name']){
			unset($identifier_controls_list[$mic_key]);
		}
	}
}
$this->set('identifier_controls_list', $identifier_controls_list);
?>