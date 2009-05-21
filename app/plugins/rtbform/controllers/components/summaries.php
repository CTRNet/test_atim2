<?php

class SummariesComponent extends Object {
	
	var $controller = true;
	var $components = array('Forms');
		
	function startup(&$controller) {
        // This method takes a reference to the controller which is loading it.
        // Perform controller initialization here.
	}
	
	// Build Tab Levels
	function build( $summary_id=NULL ) {
		
		// set display vars 
		$display_summary = array();
		
		if ( $summary_id ) {
			
			// set FORM arrays 
			$form = $this->Forms->getFormArray('rtbforms');
			
			// get SOP MODEL, and read RECORD 
			$this->Model_For_Summary =& new Rtbform;
			$this->Model_For_Summary->id = $summary_id;
			$text_data = $this->Model_For_Summary->read( 'Rtbform.frmTitle' );
			$desc_data = $this->Model_For_Summary->read( 'Rtbform.frmCategory' );
			
				$display_summary = array(
					'text'=>array(
						'id'=>$summary_id,
						'form'=>$form,
						'data'=>array( $text_data )
					),
					'desc'=>array(
						'id'=>$summary_id,
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