<?php

class SummariesComponent extends Object {
	
	var $controller = true;
	var $components = array('Forms');
		
	function startup(&$controller) {
        // This method takes a reference to the controller which is loading it.
        // Perform controller initialization here.
	}
	
	// Build Tab Levels
	function build( $user_id=NULL ) {
		
		// set display vars 
		$display_summary = array();
		
		if ( $user_id ) {
			
			// set FORM arrays 
			$form = $this->Forms->getFormArray('users');
			
			// get Participant MODEL, and read RECORD 
			$this->User_for_Summary =& new User;
			$this->User_for_Summary->id = $user_id;
			$text_data = $this->User_for_Summary->read( 'User.first_name, User.last_name' );
			$desc_data = $this->User_for_Summary->read( 'User.username' );
				
				$display_summary = array(
					'text'=>array(
						'id'=>$user_id,
						'form'=>$form,
						'data'=>array( $text_data )
					),
					'desc'=>array(
						'id'=>$user_id,
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