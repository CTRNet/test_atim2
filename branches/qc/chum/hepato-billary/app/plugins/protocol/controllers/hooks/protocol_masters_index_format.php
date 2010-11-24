<?php 
		
	// To fix a missing criteria in the core
	$this->set('protocol_controls', $this->ProtocolControl->find('all', array('conditions' => array('ProtocolControl.flag_active' => '1'))));	
	
?>