<?php
class ProductMastersController extends ClinicalannotationAppController {

	var $components = array('Inventorymanagement.Samples');
	
	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.ClinicalCollectionLink',
		
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.SampleControl'
	);
	
	function productsTreeView($participant_id, $studied_specimen_sample_control_id = null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// Get participant collection ids
		$participant_collections =  $this->Collection->find('all', array('conditions' => 'ClinicalCollectionLink.participant_id='.$participant_id, 'order' => 'Collection.collection_datetime ASC', 'recursive' => 0));
		
		$participant_collection_ids = array();
		$data_for_tree_view = array();
		
		foreach($participant_collections as $new_collection) {
			$participant_collection_ids[] = $new_collection['Collection']['id'];
			$new_collection_contents = $this->Samples->buildCollectionContentForTreeView($new_collection['Collection']['id'], $studied_specimen_sample_control_id);
			if(is_null($studied_specimen_sample_control_id)) {
				// Add collection data
				$data_for_tree_view[] = array('Collection' => $new_collection['Collection'], 'children' => $new_collection_contents);
			} else {
				foreach($new_collection_contents as $data) {
					$data_for_tree_view[] = $data;
				}
			}
		}
		
		$this->data = $data_for_tree_view;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS	
			 	
		$atim_structure = array();
		$atim_structure['Collection']	= $this->Structures->get('form','collection_tree_view');
		$atim_structure['SampleMaster']	= $this->Structures->get('form','sample_masters_for_collection_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);
		
		// Get all collections specimen types list to build the filter button
		$specimen_type_list = array();
		$specimen_type_list_temp = $this->SampleMaster->find('all', array('fields' => 'DISTINCT SampleMaster.sample_type, SampleMaster.sample_control_id', 'conditions' => array('SampleMaster.collection_id' => $participant_collection_ids, 'SampleMaster.sample_category' => 'specimen'), 'order' => 'SampleMaster.sample_type ASC', 'recursive' => '-1'));
		foreach($specimen_type_list_temp as $new_specimen_type) {
			$sample_control_id = $new_specimen_type['SampleMaster']['sample_control_id'];
			$sample_type = $new_specimen_type['SampleMaster']['sample_type'];
			$specimen_type_list[$sample_type] = $sample_control_id;
		}
		$this->set('specimen_type_list', $specimen_type_list);
		
		// Set filter value
		$filter_value = 'no filter';
		if($studied_specimen_sample_control_id) {
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('id' => $studied_specimen_sample_control_id)));
			if(empty($sample_control_data)) { 
				unset($_SESSION['ClinicalAnnotation']['productsTreeView']['Filter']);
				$this->redirect('/pages/err_inv_system_error', null, true); 
			}
			$filter_value = $sample_control_data['SampleControl']['sample_type'];
		}		
		$this->set('filter_value', $filter_value);
		
		// Set menu variables
		$this->set('atim_menu_variables', array('Participant.id' => $participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}		
	
}