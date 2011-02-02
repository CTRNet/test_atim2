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
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		$display_aliquots = true;
		$studied_specimen_sample_control_id = null;
		
		// MANAGE DATA
		
		// Manage filter data
		if(!is_null($filter_option)) {	
			$option_for_tree_view = explode("|", $filter_option);			
			if(sizeof($option_for_tree_view) != 2)  { $this->redirect('/pages/err_clin_system_error', null, true); }
			
			$display_aliquots = $option_for_tree_view[0];
			$studied_specimen_sample_control_id = empty($option_for_tree_view[1])? null : $option_for_tree_view[1];
		}
				
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// Get participant collection ids
		$participant_collections =  $this->Collection->find('all', array('conditions' => 'ClinicalCollectionLink.participant_id='.$participant_id, 'order' => 'Collection.collection_datetime ASC', 'recursive' => 0));
		
		$participant_collection_ids = array();
		$data_for_tree_view = array();
		
		foreach($participant_collections as $new_collection) {
			$participant_collection_ids[] = $new_collection['Collection']['id'];
			$new_collection_contents = $this->SampleMaster->buildCollectionContentForTreeView($new_collection['Collection']['id'], $display_aliquots, $studied_specimen_sample_control_id);
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
		$atim_structure['Collection']	= $this->Structures->get('form','collections_for_collection_tree_view');
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
		
		// Set filter value to build filter button
		$this->set('display_aliquots_filter_value', $display_aliquots);
		$this->set('studied_specimen_sample_control_id_filter_value', $studied_specimen_sample_control_id);
		
		// Set filter value
		$filter_value = '';
		if($studied_specimen_sample_control_id) {
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('id' => $studied_specimen_sample_control_id)));
			if(empty($sample_control_data)) { 
				unset($_SESSION['ClinicalAnnotation']['productsTreeView']['Filter']);
				$this->redirect('/pages/err_inv_system_error', null, true); 
			}
			$filter_value = __($sample_control_data['SampleControl']['sample_type'], true);
		}		
		if(!$display_aliquots) $filter_value .= (empty($filter_value)? '' : ' - ') . __('no aliquot displayed', true);
		$this->set('filter_value', (empty($filter_value)? 'no filter' : $filter_value));
		
		// Set menu variables
		$this->set('atim_menu_variables', array('Participant.id' => $participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}		
	
}