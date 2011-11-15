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
	
		'ExternalLink'
	);
	
	var $paginate = array(
		'Collection' 		=> array('limit' => pagination_amount, 'order' => 'Collection.acquisition_label ASC'),
		'ViewCollection'	=> array('limit' => pagination_amount, 'order' => 'ViewCollection.acquisition_label ASC')
	); 
	
	function search($search_id = 0, $is_ccl_ajax = false){
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
		
		unset($_SESSION['InventoryManagement']['TemplateInit']);
		
		// MANAGE DATA
		$this->data = $this->ViewCollection->redirectIfNonExistent($collection_id, __METHOD__, __LINE__, true);
		
		// Set participant id
		$this->set('participant_id', $this->data['ViewCollection']['participant_id']);
		
		// Get all sample control types to build the add to selected button
		$controls = $this->SampleControl->getPermissibleSamplesArray(null);
		$this->set('specimen_sample_controls_list', $controls);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		$this->Structures->set('view_collection');

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_from_tree_view', $is_from_tree_view);
		
		$template_model = AppModel::getInstance("Tools", "Template", true);
		$templates = $template_model->getAddFromTemplateMenu($collection_id);
		$this->set('templates', $templates);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add($clinical_collection_link_id = 0, $copy_source = 0) {
		if($clinical_collection_link_id > 0){
			$ccl_data = $this->ClinicalCollectionLink->find('first', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id, 'ClinicalCollectionLink.collection_id' => NULL, 'ClinicalCollectionLink.deleted' => 1), 'recursive' => '1'));
		}
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		if(!empty($ccl_data)){
			$this->Structures->set('linked_collections');
		}
		
		$this->set('atim_variables', array('ClinicalCollectionLink.id' => $clinical_collection_link_id));
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/search'));
		$this->set('copy_source', $copy_source);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$need_to_save = !empty($this->data);
		if(empty($this->data) || isset($this->data['FunctionManagement']['col_copy_binding_opt'])){
			if(!empty($copy_source)){
				if(empty($this->data)){
					$this->data = $this->Collection->redirectIfNonExistent($copy_source, __METHOD__, __LINE__, true);
				}
				if($this->data['Collection']['collection_property'] == 'participant collection'){
					$this->Structures->set('collections,col_copy_binding_opt');
				}
			}
			$this->data['Generated']['field1'] = (!empty($ccl_data))? $ccl_data['Participant']['participant_identifier'] : __('n/a', true);
				
		}
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if($need_to_save){
			
			$copy_src_data = null;
			if($copy_source){
				$copy_src_data = $this->Collection->redirectIfNonExistent($copy_source, __METHOD__, __LINE__, true);
			}
			
			// LAUNCH SAVE PROCESS
			$submitted_data_validates = true;
			
			// HOOK AND VALIDATION
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {

				//SAVE
				$collection_id = null;
				$this->Collection->id = null; 
				if($this->Collection->save($this->data)){
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
					}else{
						$classic_ccl_insert = true;
						$copy_links_option = isset($this->data['FunctionManagement']['col_copy_binding_opt']) ? (int)$this->data['FunctionManagement']['col_copy_binding_opt'] : 0;
						if($copy_source){
							if($copy_links_option > 0 && $this->data['Collection']['collection_property'] == 'independent collection'){
								AppController::addWarningMsg(__('links were not copied since the destination is an independant collection', true));
							}else{
								if($copy_links_option > 1 && $copy_links_option < 6){
									$classic_ccl_insert = false;
									$ccl_array = array(
										'collection_id' 		=> $collection_id, 
										'participant_id' 		=> $copy_src_data['ClinicalCollectionLink']['participant_id'],
										'consent_master_id' 	=> $copy_src_data['ClinicalCollectionLink']['consent_master_id'],
										'diagnosis_master_id'	=> $copy_src_data['ClinicalCollectionLink']['diagnosis_master_id']
									);
									if($copy_links_option == 3 || $copy_links_option == 2){
										unset($ccl_array['consent_master_id']);
									}
									if($copy_links_option == 4 || $copy_links_option == 2){
										unset($ccl_array['diagnosis_master_id']);
									}
	
									if(!$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => $ccl_array))){
										//copying links
										$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
									}
								}
							}
						}
						
						if($classic_ccl_insert && !$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => array('collection_id' => $collection_id)))){
							$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}
					$this->atimFlash('your data has been saved', '/inventorymanagement/collections/detail/' . $collection_id);
				}				
			}
		}
	}
	
	function edit($collection_id) {
		$this->Collection->unbindModel(array('hasMany' => array('SampleMaster')));		
		$collection_data = $this->Collection->redirectIfNonExistent($collection_id, __METHOD__, __LINE__, true);
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));		
		
		if(!empty($collection_data['ClinicalCollectionLink']['participant_id'])) {
			// Linked collection: Set specific structure
			$this->Structures->set('linked_collections');	
		}

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($this->data)) {
			$this->data = $collection_data;	

		}else{
			
			$submitted_data_validates = true;

			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {
				
				// 4- SAVE
				$this->Collection->id = $collection_id;
				if ($this->Collection->save($this->data)){
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
				$this->atimFlash('your data has been deleted', '/inventorymanagement/collections/search/');
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/collections/search/');
			}		
		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/collections/detail/' . $collection_id);
		}		
	}
	
	function template($collection_id, $template_id){
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		$template_model = AppModel::getInstance("Tools", "Template", true);
		$template_model->id = $template_id;
		$template = $template_model->read();
		$tree = $template_model->init();
		$this->set('tree_data', $tree['']);
		
		$sample_controls = $this->SampleControl->find('all');
		$sample_controls = AppController::defineArrayKey($sample_controls, 'SampleControl', 'id', true);
		AppController::applyTranslation($sample_controls, 'SampleControl', 'sample_type');
		
		$aliquot_control_model = AppModel::getInstance('inventorymanagement', 'AliquotControl', true);
		$aliquot_controls = $aliquot_control_model->find('all', array('fields' => array('id', 'sample_control_id', 'aliquot_type'), 'conditions' => array('flag_active' => 1), 'recursive' => -1));
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
		$this->set('flag_system', $template['Template']['flag_system']);
		$this->set('structure_header', array('title' => __('samples and aliquots creation from template', true), 'description' => __('collection template',true) .': '.__($template['Template']['name'],true)));
		$this->Structures->set('template');
		$this->data = $template;
		$this->render('/../../tools/views/template/tree');
	}
	
	function templateInit($collection_id, $template_id){
		$template = null;
		if($template_id != 0){
			$template_model = AppModel::getInstance("Tools", "Template", true);
			$template = $template_model->findById($template_id);
			$template_model->init($template_id);
		}
		$this->set('template', $template);
		$this->set('template_id', $template_id);
		
		$this->TemplateInit = new AppModel(array('id' => 'TemplateInit', 'table' => false, 'name' => 'TemplateInit'));
		$this->TemplateInit->_schema = array();
		$to_begin_msg = true;//can be overriden in hooks
		$this->Structures->set('empty', 'template_init_structure');
		
		$this->set('collection_id', $collection_id);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		foreach($this->Structures->controller->viewVars['template_init_structure']['Sfs'] as $new_field) {
			if(in_array($new_field['type'], array('datetime', 'timestamp', 'date', 'time'))) {
				$this->TemplateInit->_schema[$new_field['field']] = array('type' => $new_field['type']);
				//TODO Should we be able to manage accuracy?
			}
		}
		
		if(!empty($this->data)){
			//validate and stuff
			$data_validates = true;
			
			$this->TemplateInit->set($this->data);
			if(!$this->TemplateInit->validates()){
				$data_validates = false;						
			}	

			//hook
			$hook_link = $this->hook('validate_and_set');
			if( $hook_link ) { 
				require($hook_link); 
			}
		
			if($data_validates){
				$_SESSION['InventoryManagement']['TemplateInit'] = $this->data;
				$this->set('goToNext', true);
			}
		}
		
		if($to_begin_msg){
			AppController::addInfoMsg(__('to begin, click submit', true));
		}
	}
}

?>