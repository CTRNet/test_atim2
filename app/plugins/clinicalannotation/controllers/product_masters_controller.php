<?php
class ProductMastersController extends ClinicalannotationAppController {

	var $components = array();
	
	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.ClinicalCollectionLink',
		
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.SampleControl'
	);
	
	function productsTreeView($participant_id, $filter_option = null) {
		if(!$participant_id){
			$this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); 
		}

		$display_aliquots = true;
		$studied_specimen_sample_control_id = null;
		
		// MANAGE DATA
				
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) {
			 $this->redirect( '/pages/err_clin_no_data', null, true ); 
		}
		
		// Get participant collection ids
		$this->data =  $this->Collection->find('all', array('conditions' => 'ClinicalCollectionLink.participant_id='.$participant_id, 'order' => 'Collection.collection_datetime ASC', 'recursive' => 0));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS	
			 	
		$atim_structure = array();
		$atim_structure['Collection']	= $this->Structures->get('form','collections_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);
		
		// Set menu variables
		$this->set('atim_menu_variables', array('Participant.id' => $participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if($hook_link){ 
			require($hook_link); 
		}
	}		
	
}