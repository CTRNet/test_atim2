<?php

class SummariesComponent extends Object {
	
	var $controller = true;
	var $components = array('Forms');
		
	function startup(&$controller) {
        // This method takes a reference to the controller which is loading it.
        // Perform controller initialization here.
	}
	
	// Build Tab Levels
	function build( $participant_id=NULL ) {
		
		// set display vars 
		$display_summary = array();
		
		/*
		if ( $participant_id ) {
			
			// set FORM arrays 
			$form = $this->Forms->getFormArray('participants');
			
			// get Participant MODEL, and read RECORD 
			$this->Participant_for_Summary =& new Participant;
			$this->Participant_for_Summary->id = $participant_id;
			$text_data = $this->Participant_for_Summary->read( 'Participant.salutation, Participant.first_name, Participant.last_name' );
			$desc_data = $this->Participant_for_Summary->read( 'Participant.date_of_birth, Participant.sex' );
			
				$display_summary = array(
					'text'=>array(
						'id'=>$participant_id,
						'form'=>$form,
						'data'=>array( $text_data )
					),
					'desc'=>array(
						'id'=>$participant_id,
						'form'=>$form,
						'data'=>array( $desc_data )
					)
				);
			
		}
		*/
		
		// pass vars for CONTROLLERS 
		return $display_summary;
		
	}
	
}

?>