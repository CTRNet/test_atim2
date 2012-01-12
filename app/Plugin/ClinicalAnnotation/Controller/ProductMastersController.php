<?php
class ProductMastersController extends ClinicalAnnotationAppController {

	var $components = array();
	
	var $uses = array(
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.ClinicalCollectionLink',
		
		'InventoryManagement.Collection',
		'InventoryManagement.SampleMaster',
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.SampleControl'
	);
	
	function productsTreeView($participant_id, $filter_option = null) {
		if(!$participant_id){
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}

		$display_aliquots = true;
		$studied_specimen_sample_control_id = null;
		
		// MANAGE DATA
				
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) {
			 $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		// Get participant collection ids
		$this->request->data =  $this->Collection->find('all', array('conditions' => 'ClinicalCollectionLink.participant_id='.$participant_id, 'order' => 'Collection.collection_datetime ASC', 'recursive' => 0));
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