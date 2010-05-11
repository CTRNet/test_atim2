<?php

class ParticipantsControllerCustom extends ParticipantsController {

 	// --------------------------------------------------------------------------------
	// NEW FORMS
	// --------------------------------------------------------------------------------
 
  	// --------------------------------------------------------------------------------
	// FUNCTIONS
	// --------------------------------------------------------------------------------
 	
	/**
	 * Create a new Participant Identifier 
	 * 
	 * @return Return a new Participant Identifier.
	 * 
	 * @author N. Luc
	 * @since 2008-02-20
	 */
	function createParticipantIdentifier() {
		$last_pariticpant = $this->Participant->find('first', array('order' => 'Participant.id DESC'));
		$next_pariticpant_id = empty($last_pariticpant)? '1': ($last_pariticpant['Participant']['id'] + 1);

		return "Ap-" . $next_pariticpant_id;;
	}
}

?>