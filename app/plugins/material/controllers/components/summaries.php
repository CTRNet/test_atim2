<?php

class SummariesComponent extends Object {
	
	var $controller = true;
	var $components = array('Forms');
		
	function startup(&$controller) {
        // This method takes a reference to the controller which is loading it.
        // Perform controller initialization here.
	}
	
	// Build Tab Levels
	function build( $material_id=NULL ) {
		
		// set display vars 
		$display_summary = array();
		
		if ( $material_id ) {
			
			// set FORM arrays 
			$form = $this->Forms->getFormArray('materials');
			
			$this->Material_For_Summary =& new Material;
			$this->Material_For_Summary->id = $material_id;
			$text_data = $this->Material_For_Summary->read( 'Material.item_name' );
			$desc_data = $this->Material_For_Summary->read( 'Material.item_type' );
			
				$display_summary = array(
					'text'=>array(
						'id'=>$material_id,
						'form'=>$form,
						'data'=>array( $text_data )
					),
					'desc'=>array(
						'id'=>$material_id,
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