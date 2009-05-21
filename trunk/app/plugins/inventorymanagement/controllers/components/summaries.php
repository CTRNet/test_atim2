<?php

class SummariesComponent extends Object {
	
	var $controller = true;
	var $components = array('Forms');
		
	function startup(&$controller) {
        // This method takes a reference to the controller which is loading it.
        // Perform controller initialization here.
	}
	
	// Build Tab Levels
	function build( $collection_id=NULL, $sample_master_id=NULL, $aliquot_master_id=NULL ) {
		
		// set display vars 
		$display_summary = array();
		
		if ( $collection_id ) {
			
			// 1- Text
			
			// set FORM arrays 
			$form_text = $this->Forms->getFormArray('collections');
			
			// get Participant MODEL, and read RECORD text
			$this->Collection_for_Summary =& new Collection;
			$this->Collection_for_Summary->id = $collection_id;
			$text_data = $this->Collection_for_Summary->read( 'Collection.acquisition_label');
			
			$display_summary = array();
			$display_summary['text'] 
				= array('id'=>$collection_id,
					'form'=>$form_text,
					'data'=>array( $text_data ));
					
			// 2- Desc			
			$display_summary['desc'] = array();			
			
			if(!empty($sample_master_id)) {
				 if(empty($aliquot_master_id)) {
				 	// set FORM arrays 
					$form_desc = $this->Forms->getFormArray('sample_masters_for_search_result');
			
					// get Participant MODEL, and read RECORD 
					$this->Sample_for_Summary =& new SampleMaster;
					$this->Sample_for_Summary->id = $sample_master_id;
					$desc_data = $this->Sample_for_Summary->read( 'SampleMaster.sample_code');

					$display_summary['desc'] 
						= array('id'=>$sample_master_id,
							'form'=>$form_desc,
							'data'=>array( $desc_data ));
										
				 } else {
				 	// set FORM arrays 
					$form_desc = $this->Forms->getFormArray('aliquot_masters_for_search_result');
			
					// get Participant MODEL, and read RECORD 
					$this->Aliquot_for_Summary =& new AliquotMaster;
					
					$belongs_array 
						= array('belongsTo' => 
							array(
								'SampleMaster' => array(
									'className' => 'SampleMaster',
									'conditions' => '',
									'order'      => '',
									'foreignKey' => 'sample_master_id')));
		
					$this->Aliquot_for_Summary->bindModel($belongs_array);	
						
					$this->Aliquot_for_Summary->id = $aliquot_master_id;
					$desc_data = $this->Aliquot_for_Summary->read( 'SampleMaster.sample_code, AliquotMaster.barcode');

					$display_summary['desc'] 
						= array('id'=>$sample_master_id,
							'form'=>$form_desc,
							'data'=>array( $desc_data ));
							
				 } 
			}

			
		}

		// pass vars for CONTROLLERS 
		return $display_summary;
		
	}
	
}

?>