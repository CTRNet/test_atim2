<?php
//$this->set('identifier_controls_list', $this->MiscIdentifierControl->find('all', array('conditions' => array('status' => 'active'))));
$mil = $this->MiscIdentifier->find('all', array('conditions' =>array('MiscIdentifier.participant_id' => $participant_id)));
$identifier_controls_list = $this->MiscIdentifierControl->find('all', array('conditions' => array('status' => 'active')));
foreach($identifier_controls_list as $mic_key => $mic){
	foreach($mil as $mi){
		if($mic['MiscIdentifierControl']['misc_identifier_name'] == $mi['MiscIdentifier']['identifier_name']){
			unset($identifier_controls_list[$mic_key]);
		}
	}
}
$this->set('identifier_controls_list', $identifier_controls_list);
?>