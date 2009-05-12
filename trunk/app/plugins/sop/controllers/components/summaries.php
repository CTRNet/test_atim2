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
		
		if ( $participant_id ) {
			
			// set FORM arrays 
			$form = $this->Forms->getFormArray('sopd_general_all');
			
			// get Participant MODEL, and read RECORD 
			$this->Model_For_Summary =& new SopMaster;
			$this->Model_For_Summary->id = $participant_id;
			$text_data = $this->Model_For_Summary->read( 'SopMaster.code' );
			$desc_data = $this->Model_For_Summary->read( 'SopMaster.version' );
			
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
		
		// pass vars for CONTROLLERS 
		return $display_summary;
		
	}
	
}

?>