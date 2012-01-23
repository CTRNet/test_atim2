<?php
class ProductMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.Participant',
		'InventoryManagement.Collection',
	);
	
	function productsTreeView($participant_id) {
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		// Get participant collection ids
		$this->request->data =  $this->Collection->find('all', array('conditions' => 'Collection.participant_id='.$participant_id, 'order' => 'Collection.collection_datetime ASC', 'recursive' => 0));
		$ids = array();
		foreach($this->request->data as $unit){
			$ids[] = $unit['Collection']['id'];
		}
		$ids = array_flip($this->Collection->hasChild($ids));
		foreach($this->request->data as &$unit){
			$unit['children'] = array_key_exists($unit['Collection']['id'], $ids);
		}
		
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