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
		
		'Clinicalannotation.ClinicalCollectionLink',
	
		'ExternalLink');
	
	var $paginate = array(
		'Collection' => array('limit' => pagination_amount, 'order' => 'Collection.acquisition_label ASC'),
		'ViewCollection' => array('limit' => pagination_amount, 'order' => 'ViewCollection.acquisition_label ASC')); 
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function search($search_id = 0, $is_ccl_ajax = false){
		if(empty($search_id)){
			//index
			$this->unsetInventorySessionData();
		}
		
		if($is_ccl_ajax && $this->data){
			//custom result handling for ccl
			$view_collection = $this->Structures->get('form', 'view_collection');
			$this->set('atim_structure', $view_collection);
			$this->Structures->set('empty', 'empty_structure');
			$conditions = $this->Structures->parseSearchConditions($view_collection);
			$limit = 20;
			$conditions[] = "ViewCollection.participant_id IS NULL";
			$this->data = $this->ViewCollection->find('all', array('conditions' => $conditions, 'limit' => $limit + 1));
			if(count($this->data) > $limit){
				unset($this->data[$limit]);
				$this->set("overflow", true);
			}
		}else{
			$this->searchHandler($search_id, $this->ViewCollection, 'view_collection', '/inventorymanagement/collections/search');
		}
		
		$help_url = $this->ExternalLink->find('first', array('conditions' => array('name' => 'inventory_elements_defintions')));
		$this->set("help_url", $help_url['ExternalLink']['link']);
		if($is_ccl_ajax){
			$this->set('is_ccl_ajax', $is_ccl_ajax);
		}
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}
	
	function detail($collection_id, $is_from_tree_view = 0) {
		// $is_from_tree_view : 0-Normal, 1-Tree view
		
		if(!$collection_id) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE DATA
		
		$collection_data = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($collection_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		$this->data = $collection_data;
		
		// Set participant id
		$this->set('participant_id', $collection_data['ViewCollection']['participant_id']);
		
		// Get all sample control types to build the add to selected button
		$controls = $this->SampleControl->getPermissibleSamplesArray(null);
		foreach($controls as $control){
			$specimen_sample_controls_list[] = $control;	
		}
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		$this->Structures->set('view_collection');

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_from_tree_view', $is_from_tree_view);
		
		$template_model = AppModel::getInstance("Tools", "Template", true);
		$templates = $template_model->find('all');
		$this->set('templates', $templates);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
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
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {

				// 4- SAVE
				
				$collection_id = null;
				if($this->Collection->save($this->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
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
		if(!$collection_id) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
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
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash('your data has been updated', '/inventorymanagement/collections/detail/' . $collection_id);
				}
			}
		}
	}
	
	function delete($collection_id) {
		if(!$collection_id) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}

		// MANAGE DATA
				
		// Get collection data
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->Collection->allowDeletion($collection_id);
		
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
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
	
	function template($collection_id, $template_id){
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		$template_model = AppModel::getInstance("Tools", "Template", true);
		$template = $template_model->findById($template_id);
		$tree = $template_model->init($template_id);
		$this->set('tree_data', $tree['']);
		
		$sample_controls = $this->SampleControl->find('all');
		$sample_controls = AppController::defineArrayKey($sample_controls, 'SampleControl', 'id', true);
		AppController::applyTranslation($sample_controls, 'SampleControl', 'sample_type');
		
		$aliquot_control_model = AppModel::getInstance('inventorymanagement', 'AliquotControl', true);
		$aliquot_controls = $aliquot_control_model->find('all');
		$aliquot_controls = AppController::defineArrayKey($aliquot_controls, 'AliquotControl', 'id', true);
		AppController::applyTranslation($aliquot_controls, 'AliquotControl', 'aliquot_type');
		
		$parent_to_derivative_sample_control_model = AppModel::getInstance("Inventorymanagement", "ParentToDerivativeSampleControl", true);
		$samples_relations = $parent_to_derivative_sample_control_model->find('all', array('conditions' => array('flag_active' => 1), 'recusrive' => -1));
		foreach($samples_relations as &$sample_relation){
			unset($sample_relation['ParentSampleControl']);
			unset($sample_relation['DerivativeControl']);
		}
		unset($sample_relation);
		$samples_relations = AppController::defineArrayKey($samples_relations, 'ParentToDerivativeSampleControl', 'parent_sample_control_id');
		
		
		$js_data = array(
			'sample_controls' => $sample_controls,
			'samples_relations' => $samples_relations,
			'aliquot_controls' => AppController::defineArrayKey($aliquot_controls, 'AliquotControl', 'id', true),
			'aliquot_relations' => AppController::defineArrayKey($aliquot_controls, "AliquotControl", "sample_control_id")
		);
		$this->set('js_data', $js_data);
		$this->set('template_id', $template['Template']['id']);
		$this->set('controls', 0);
		$this->set('collection_id', $collection_id);
		$this->set('description', $template['Template']['name']);
		$this->set('flag_system', $template['Template']['flag_system']);
		$this->render('/../../tools/views/template/tree');
	}
	
	function templateInit($template_id){
		$template_model = AppModel::getInstance("Tools", "Template", true);
		$template = $template_model->findById($template_id);
		$template_model->init($template_id);
		$this->set('template', $template);
		$this->Structures->set('empty');
		if(!empty($this->data)){
			//validate and stuff
			$data_validates = true;
			//hook
			if($data_validates){
				$this->set('goToNext', true);
			}
		}
	}
}

?>