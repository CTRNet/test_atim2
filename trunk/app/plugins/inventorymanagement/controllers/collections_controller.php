<?php

class CollectionsController extends InventorymanagementAppController {
	
	var $components = array();
		
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.ViewCollection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.SpecimenReviewMaster',
		'Inventorymanagement.ParentToDerivativeSampleControl',
		
		'Clinicalannotation.ClinicalCollectionLink');
	
	var $paginate = array(
		'Collection' => array('limit' => pagination_amount, 'order' => 'Collection.acquisition_label ASC'),
		'ViewCollection' => array('limit' => pagination_amount, 'order' => 'ViewCollection.acquisition_label ASC')); 
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function index($is_ccl_ajax = false) {
		if($is_ccl_ajax){
			//layout = ajax to avoid printing layout
			$this->layout = 'ajax';
			//debug = 0 to avoid printing debug queries that would break the javascript array
			Configure::write('debug', 0);
			$this->set("is_ccl_ajax", $is_ccl_ajax);
		}
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
				
		$this->Structures->set('view_collection');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }			
	}
	
	function search($is_ccl_ajax = false) {
		if($is_ccl_ajax){
			//layout = ajax to avoid printing layout
			$this->layout = 'ajax';
			//debug = 0 to avoid printing debug queries that would break the javascript array
			Configure::write('debug', 0);
			$this->set("is_ccl_ajax", $is_ccl_ajax);
		}
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		$view_collection = $this->Structures->get('form', 'view_collection');
		$this->set('atim_structure', $view_collection);
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($view_collection);
		
		if($is_ccl_ajax){
			$limit = 20;
			$_SESSION['ctrapp_core']['search']['criteria'][] = "ViewCollection.participant_id IS NULL";
			$this->data = $this->ViewCollection->find('all', array('conditions' => $_SESSION['ctrapp_core']['search']['criteria'], 'limit' => $limit + 1));
			if(count($this->data) > $limit){
				unset($this->data[$limit]);
				$this->set("overflow", true);
			}
			$this->set('collections_data', $this->data);
		}else{
			$this->set('collections_data', $this->paginate($this->ViewCollection, $_SESSION['ctrapp_core']['search']['criteria']));
		}
		$this->data = array();
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ViewCollection']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/collections/search';
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail($collection_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if(!$collection_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// MANAGE DATA
		
		$collection_data = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }
		$this->data = $collection_data;
		
		// Set participant id
		$this->set('participant_id', $collection_data['ViewCollection']['participant_id']);
		
		// Get all sample control types to build the add to selected button
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => array('ParentToDerivativeSampleControl.parent_sample_control_id IS NULL', 'ParentToDerivativeSampleControl.flag_active' => true), 'fields' => array('DerivativeControl.*')));
		foreach($controls as $control){
			$specimen_sample_controls_list[]['SampleControl'] = $control['DerivativeControl'];	
		}
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		$this->Structures->set('view_collection');

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add($clinical_collection_link_id = 0) {
		if($clinical_collection_link_id > 0){
			$ccl_data = $this->ClinicalCollectionLink->find('first', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id, 'ClinicalCollectionLink.collection_id' => NULL, 'ClinicalCollectionLink.deleted' => 1), 'recursive' => '1'));
		}
		// MANAGE DATA
		
		$initial_data = array();
		if(empty($this->data)) {
			$initial_data['Collection']['collection_property'] = 'participant collection';
			$initial_data['Generated']['field1'] = (!empty($ccl_data))? $ccl_data['Participant']['participant_identifier'] : __('n/a', true);
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		if(!empty($ccl_data)){
			$this->set('atim_variables', array('ClinicalCollectionLink.id' => $clinical_collection_link_id));
			$this->Structures->set('linked_collections');
		}
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
			$this->data = $initial_data;
			
		} else {
			
			// LAUNCH SAVE PROCESS
			// 1- SET ADDITIONAL DATA	
			
			// 2- LAUNCH SPECIAL VALIDATION PROCESS	
			
			$submitted_data_validates = true;
			
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {

				// 4- SAVE
				
				$collection_id = null;
				if($this->Collection->save($this->data)) {
					$collection_id = $this->Collection->getLastInsertId();
					
					// Create clinical collection link
					if(isset($ccl_data) && !empty($ccl_data)){
						$ccl_data['ClinicalCollectionLink']['deleted'] = 0;
						$ccl_data['ClinicalCollectionLink']['collection_id'] = $collection_id;
						if(!$this->ClinicalCollectionLink->save($ccl_data)) {
							$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}else if(!$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => array('collection_id' => $collection_id)))) {
						$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					$this->atimFlash('your data has been saved', '/inventorymanagement/collections/detail/' . $collection_id);
				}				
			}
		}
	}
	
	function edit($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }
		
		// MANAGE DATA
		
		$this->Collection->unbindModel(array('hasMany' => array('SampleMaster')));		
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));		
		
		if(!empty($collection_data['ClinicalCollectionLink']['participant_id'])) {
			// Linked collection: Set specific structure
			$this->Structures->set('linked_collections');	
		}

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
				$this->data = $collection_data;	

		} else {
			
			// 1- SET ADDITIONAL DATA	
			
			//....
			
			// 2- LAUNCH SPECIAL VALIDATION PROCESS	
			
			$submitted_data_validates = true;
			
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {
				
				// 4- SAVE
			
				$this->Collection->id = $collection_id;
				if ($this->Collection->save($this->data)) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { require($hook_link); }
					
					$this->atimFlash('your data has been updated', '/inventorymanagement/collections/detail/' . $collection_id);
				}
			}
		}
	}
	
	function delete($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }

		// MANAGE DATA
				
		// Get collection data
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->Collection->allowDeletion($collection_id);
		
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			// Delete collection			
			if($this->Collection->atim_delete($collection_id, true)) {
				$this->atimFlash('your data has been deleted', '/inventorymanagement/collections/index/');
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/collections/index/');
			}		
		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/collections/detail/' . $collection_id);
		}		
	}
}

?>