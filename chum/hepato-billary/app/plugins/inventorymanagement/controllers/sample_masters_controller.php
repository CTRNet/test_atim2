<?php

class SampleMastersController extends InventorymanagementAppController {

	var $components = array();

	var $uses = array(
		'Inventorymanagement.Collection',
		
		'Inventorymanagement.SampleControl',

		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.ViewSample',
		'Inventorymanagement.SampleDetail',
	 	'Inventorymanagement.SpecimenDetail',		
		'Inventorymanagement.DerivativeDetail',		
		
		'Inventorymanagement.ParentToDerivativeSampleControl',
		
		'Inventorymanagement.AliquotControl',
		'Inventorymanagement.AliquotMaster',
		
		'Inventorymanagement.SourceAliquot',
		'Inventorymanagement.QualityCtrl',
		'Inventorymanagement.SpecimenReviewMaster',
		
		'Inventorymanagement.Realiquoting',
	
		'ExternalLink');
	
	var $paginate = array(
		'SampleMaster' => array('limit' => pagination_amount, 'order' => 'SampleMaster.sample_code DESC'),
		'ViewSample' => array('limit' =>pagination_amount , 'order' => 'ViewSample.sample_code DESC'), 
		'AliquotMaster' => array('limit' =>pagination_amount , 'order' => 'AliquotMaster.barcode DESC'));

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/search'));
		
		$this->searchHandler($search_id, $this->ViewSample, 'view_sample_joined_to_collection', '/inventorymanagement/sample_masters/search');
		
		$help_url = $this->ExternalLink->find('first', array('conditions' => array('name' => 'inventory_elements_defintions')));
		$this->set("help_url", $help_url['ExternalLink']['link']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}
	
	function contentTreeView($collection_id, $sample_master_id = 0, $is_ajax = false){
		unset($_SESSION['InventoryManagement']['TemplateInit']);
		$this->Collection->redirectIfNonExistent($collection_id, __METHOD__, __LINE__, false);
		
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}else{
			$this->set("specimen_sample_controls_list", $this->SampleControl->getPermissibleSamplesArray(null));
			$template_model = AppModel::getInstance("Tools", "Template", true);
			$templates = $template_model->getAddFromTemplateMenu($collection_id);
			$this->set('templates', $templates);
		}
		$atim_structure['SampleMaster']		= $this->Structures->get('form','sample_masters_for_collection_tree_view');
		$atim_structure['AliquotMaster']	= $this->Structures->get('form','aliquot_masters_for_collection_tree_view');
		$this->set('atim_structure', $atim_structure);
		$this->set("collection_id", $collection_id);
		$this->set("is_ajax", $is_ajax);
		
		// Unbind models
		$this->SampleMaster->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')),false);
		$this->AliquotMaster->unbindModel(array('belongsTo' => array('Collection','SampleMaster'),'hasOne' => array('SpecimenDetail')),false);
		
		if($sample_master_id == 0){
			//fetch all
			$this->data = $this->SampleMaster->find('all', array('conditions' => array("SampleMaster.collection_id" => $collection_id, "SampleMaster.parent_id IS NULL"), 'recursive' => 0));
		}else{
			$this->data = $this->SampleMaster->find('all', array('conditions' => array("SampleMaster.collection_id" => $collection_id, "SampleMaster.parent_id" => $sample_master_id), 'recursive' => 0));
		}
		
		$ids = array();
		foreach($this->data as $unit){
			$ids[] = $unit['SampleMaster']['id'];
		}
		$ids = array_flip($this->SampleMaster->hasChild($ids));//array_key_exists is faster than in_array
		foreach($this->data as &$unit){
			$unit['children'] = array_key_exists($unit['SampleMaster']['id'], $ids);
		}
		if($sample_master_id != 0){
			//aliquots that are not realiquots
			$aliquot_ids = $this->AliquotMaster->find('list', array('fields' => array('AliquotMaster.id'), 'conditions' => array("AliquotMaster.collection_id" => $collection_id, "AliquotMaster.sample_master_id" => $sample_master_id), 'recursive' => -1));
			$aliquot_ids = array_diff($aliquot_ids, $this->Realiquoting->find('list', array('fields' => array('Realiquoting.child_aliquot_master_id'), 'conditions' => array("Realiquoting.child_aliquot_master_id" => $aliquot_ids), 'group' => array("Realiquoting.child_aliquot_master_id"))));
			$aliquot_ids_has_child = array_flip($this->AliquotMaster->hasChild($aliquot_ids));
			
			$aliquot_ids[] = 0;//counters Eventum 1353
			$aliquots = $this->AliquotMaster->find('all', array('conditions' => array("AliquotMaster.id" => $aliquot_ids), 'recursive' => 0));
			
			foreach($aliquots as &$aliquot){
				$aliquot['children'] = array_key_exists($aliquot['AliquotMaster']['id'], $aliquot_ids_has_child);
				$aliquot['css'][] = $aliquot['AliquotMaster']['in_stock'] == 'no' ? 'disabled' : '';
			}
			$this->data = array_merge($this->data, $aliquots);
		}

		// Set menu variables
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));		
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	/**
	 * List all derivatives samples of a specimen.
	 * 
	 * @param $collection_id ID of the collection
	 * @param $specimen_sample_id sample_master_id of the specimen
	 */
	function listAllDerivatives($collection_id, $specimen_sample_master_id) {
		if((!$collection_id) || (!$specimen_sample_master_id)) { $this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }

		$specimen_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $specimen_sample_master_id), 'recursive' => -1)); 
		if(empty($specimen_data)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$derivatives_data = array();
		$derivatives_data = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $specimen_sample_master_id, 'SampleMaster.initial_specimen_sample_id != SampleMaster.id'), 'recursive' => 0)); 
		
		if(empty($derivatives_data)) {
			$this->Structures->set('sample_masters,sd_undetailed_derivatives', 'no_data_structure');
			$this->data = array();
						
		} else {
			// Data
			$derivatives_data = AppController::defineArrayKey($derivatives_data, "SampleMaster", "sample_control_id", false);
			$this->set('derivatives_data', $derivatives_data);

			// Structures
			$derivatives_structures = array();
			foreach($derivatives_data as $sample_control_id => $derivatives){
				$derivatives_structures[$sample_control_id] = $this->Structures->get('form', $derivatives[0]['SampleControl']['form_alias']);
			}
			$this->set('derivatives_structures', $derivatives_structures);			
			
		}
		
		// Set menu variables
		$menu_link = '/inventorymanagement/sample_masters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%';
		$this->set('atim_menu', $this->Menus->get($menu_link));
		
		$atim_menu_variables = array('Collection.id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $specimen_sample_master_id);
		
		$this->set('atim_menu_variables', $atim_menu_variables);

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function detail($collection_id, $sample_master_id, $is_from_tree_view = 0) {
		// $is_from_tree_view : 0-Normal, 1-Tree view
		
		if((!$collection_id) || (!$sample_master_id)) { 
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		// MANAGE DATA

		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$is_specimen = true;
		switch($sample_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				$is_specimen = true;
				unset($sample_data['DerivativeDetail']);
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				$is_specimen = false;
				unset($sample_data['SpecimenDetail']);
				break;
				
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '0'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data));	
		$this->set('parent_sample_master_id', $parent_sample_master_id);	
	
		// Calulate spent time between:
		if($is_specimen){
			// -> specimen collection and specimen reception
			$sample_data['Generated']['coll_to_rec_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($sample_data['Collection']['collection_datetime'], $sample_data['SpecimenDetail']['reception_datetime']));
		} else {
			// -> specimen collection and derivative creation
			$sample_data['Generated']['coll_to_creation_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($sample_data['Collection']['collection_datetime'], $sample_data['DerivativeDetail']['creation_datetime']));
		}
		
		// Set sample data
		$this->set('sample_master_data', $sample_data);
		$this->data = array();
					
		// Set sample aliquot list
		$aliquots_data = array();
		if(!$is_from_tree_view) {
			$aliquots_data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id))); 
			$aliquots_data = AppController::defineArrayKey($aliquots_data, "AliquotMaster", "aliquot_control_id", false);
			$this->set('aliquots_data', $aliquots_data);
		}
		
		// Set Lab Book Id
		if(isset($sample_data['DerivativeDetail']['lab_book_master_id']) && !empty($sample_data['DerivativeDetail']['lab_book_master_id'])) $this->set('lab_book_master_id', $sample_data['DerivativeDetail']['lab_book_master_id']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS

		// Get the current menu object.
		$this->setBatchMenu($sample_data);
		
		// Set structure
		$structure_name = $sample_data['SampleControl']['form_alias'];
		if(!$is_specimen){
			$parent_data = $this->SampleMaster->find('first', array(
				'conditions' => array('SampleMaster.id' => $sample_data['SampleMaster']['parent_id']),
				'fields' => array('SampleControl.id'),
				'recursive' => 0)
			);
			$tmp_data = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => array(
				'ParentToDerivativeSampleControl.parent_sample_control_id' => $parent_data['SampleControl']['id'],
				'ParentToDerivativeSampleControl.derivative_sample_control_id' => $sample_data['SampleControl']['id']
			), 'recursive' => -1));
			if(!empty($tmp_data['ParentToDerivativeSampleControl']['lab_book_control_id'])){
				$structure_name .= ",derivative_lab_book";
			}
		}
		$this->Structures->set($structure_name);	
		if(!$is_from_tree_view) {
			//parse each group to load the required detailed aliquot structures 
			$aliquots_structures = array();
			foreach($aliquots_data as $aliquot_control_id => $aliquots){
				$aliquots_structures[$aliquot_control_id] = $this->Structures->get('form', $aliquots[0]['AliquotControl']['form_alias']);
			}
			$this->set('aliquots_structures', $aliquots_structures);
		}

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_from_tree_view', $is_from_tree_view);
		
		// Get all sample control types to build the add to selected button
		$this->set('allowed_derivative_type', $this->SampleControl->getPermissibleSamplesArray($sample_data['SampleControl']['id']));

		// Get all aliquot control types to build the add to selected button
		$this->set('allowed_aliquot_type', $this->AliquotControl->getPermissibleAliquotsArray($sample_data['SampleControl']['id']));

		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add($collection_id, $sample_control_id, $parent_sample_master_id = 0) {
		if((!$collection_id) || (!$sample_control_id)){
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		if($this->RequestHandler->isAjax()){
			$this->layout = 'ajax';
		}
		
		// MANAGE DATA
		$sample_control_data = array();
		$parent_sample_data = array();
		$parent_to_derivative_sample_control = null;
		
		$lab_book = null;
		$lab_book_ctrl_id = 0;
		$lab_book_fields = array();
		
		if($parent_sample_master_id == 0){
			// Created sample is a specimen
			$is_specimen = true;
			
			// Get Control Data
			$sample_control_data = $this->SampleControl->find('first', array('conditions' => array('SampleControl.id' => $sample_control_id)));
			if(empty($sample_control_data)) { 
				$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}	
			
			// Check collection id
			$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
			if(empty($collection_data)) { 
				$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}			
			
		} else {
			// Created sample is a derivative: Get parent sample information
			$is_specimen = false;
			
			// Get parent data
			$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => 0));
			if(empty($parent_sample_data)) { 
				$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			// Get Control Data
			$criteria = array(
				'ParentSampleControl.id' => $parent_sample_data['SampleMaster']['sample_control_id'],
				'ParentToDerivativeSampleControl.flag_active' => '1',
				'DerivativeControl.id' => $sample_control_id);
			$parent_to_derivative_sample_control = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => $criteria));
			if(empty($parent_to_derivative_sample_control)) { 
				$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			$sample_control_data['SampleControl'] = $parent_to_derivative_sample_control['DerivativeControl'];
			
			// Get Lab Book Ctrl Id & Fields
			$lab_book = AppModel::getInstance("labbook", "LabBookMaster", true);
			$lab_book_ctrl_id = $parent_to_derivative_sample_control['ParentToDerivativeSampleControl']['lab_book_control_id'];
			$lab_book_fields = $lab_book->getFields($lab_book_ctrl_id);
		}
		$this->set("lab_book_fields", $lab_book_fields);
		
		// Set parent data
		$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data));	
		$this->set('parent_sample_master_id', $parent_sample_master_id);
		
		// Set new sample control information
		$this->set('sample_control_data', $sample_control_data);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu_link = ($is_specimen? '/inventorymanagement/sample_masters/contentTreeView/%%Collection.id%%' : '/inventorymanagement/sample_masters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%');
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$atim_menu_variables = (empty($parent_sample_data)? array('Collection.id' => $collection_id) : array('Collection.id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $parent_sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		// set structure alias based on VALUE from CONTROL table
		$structure_name = $sample_control_data['SampleControl']['form_alias'];
		if($lab_book_ctrl_id != 0){
			$structure_name .= ",derivative_lab_book";
		}
		$this->Structures->set($structure_name);
				
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}	
		
		// MANAGE DATA RECORD
		
		if(empty($this->data)) {
			$this->data = array();
			$this->data['SampleControl']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];
			$this->data['SampleControl']['sample_category'] = $sample_control_data['SampleControl']['sample_category'];
	
			//Set default reception date
			if($is_specimen){
				$default_reception_datetime = null;
				$default_reception_datetime_accuracy = null;
				if($this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id))) == 0){
					$collection = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
					$default_reception_datetime = $collection['Collection']['collection_datetime'];
					$default_reception_datetime_accuracy = $collection['Collection']['collection_datetime_accuracy'];
				}else{
					$sample = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'order by' => array('SpecimenDetail.reception_datetime')));
					$default_reception_datetime = $sample['SpecimenDetail']['reception_datetime'];
					$default_reception_datetime_accuracy = $sample['SpecimenDetail']['reception_datetime_accuracy'];
				}
				$this->data['SpecimenDetail']['reception_datetime'] = $default_reception_datetime;
				$this->data['SpecimenDetail']['reception_datetime_accuracy'] = $default_reception_datetime_accuracy;
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}	
		
		} else {
			// Set additional data
			$this->data['SampleMaster']['collection_id'] = $collection_id;
			$this->data['SampleMaster']['sample_control_id'] = $sample_control_data['SampleControl']['id'];
			$this->data['SampleControl']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];			
			
			// Set either specimen or derivative additional data
			if($is_specimen){
				// The created sample is a specimen
				if(isset($this->data['SampleMaster']['parent_id'])) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				
				$this->data['SampleMaster']['initial_specimen_sample_type'] = $this->data['SampleControl']['sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id'] = null; 	// ID will be known after sample creation
			} else {
				// The created sample is a derivative
				$this->data['SampleMaster']['parent_sample_type'] = $parent_sample_data['SampleControl']['sample_type'];
				$this->data['SampleMaster']['parent_id'] = $parent_sample_data['SampleMaster']['id'];
				
				$this->data['SampleMaster']['initial_specimen_sample_type'] = $parent_sample_data['SampleMaster']['initial_specimen_sample_type'];
				$this->data['SampleMaster']['initial_specimen_sample_id'] = $parent_sample_data['SampleMaster']['initial_specimen_sample_id'];
			}
  	  			  	
			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->data);
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			//for error field highlight in detail
			$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
			
			if($is_specimen) { 
				$this->SpecimenDetail->set($this->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates: false;
				$this->data['SpecimenDetail'] = $this->SpecimenDetail->data['SpecimenDetail'];
			} else { 
				$this->DerivativeDetail->set($this->data);
				$submitted_data_validates = ($this->DerivativeDetail->validates())? $submitted_data_validates: false;
				$this->data['DerivativeDetail'] = $this->DerivativeDetail->data['DerivativeDetail'];

				//validate and sync lab book
				$msg = $this->SampleMaster->validateLabBook($this->data, $lab_book, $lab_book_ctrl_id, true);
				if(strlen($msg) > 0){
					$this->DerivativeDetail->validationErrors['lab_book_master_code'] = $msg;
					$submitted_data_validates = false;
				}
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if($submitted_data_validates) {
				// Save sample data
				$sample_master_id = null;
				if($this->SampleMaster->save($this->data, false)) {
					
					$sample_master_id = $this->SampleMaster->getLastInsertId();
				
					// Record additional sample data
					$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $sample_master_id;";
					if($is_specimen) $query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id, sample_masters.initial_specimen_sample_id = sample_masters.id WHERE sample_masters.id = $sample_master_id;";
					if(!$this->SampleMaster->query($query_to_update) 
					|| !$this->SampleMaster->query(str_replace("sample_masters", "sample_masters_revs", $query_to_update))) {
						$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
					}
					
					// Save either specimen or derivative detail
					if($is_specimen){
						// SpecimenDetail
						$this->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { 
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					} else {
						// DerivativeDetail
						$this->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'], false)) { 
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}						
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					if($this->RequestHandler->isAjax()){
						echo json_encode(array('goToNext' => true, 'display' => '', 'id' => $sample_master_id));
						exit;
					}else{
						$this->atimFlash('your data has been saved', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);
					}	
				}					
			}
		}
		
		$this->set('is_specimen', $is_specimen);		
		$this->set('is_ajax', $this->RequestHandler->isAjax());
	}
	
	function edit($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)){
			$this->redirect('/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE DATA

		// Get the sample data
		
		$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster')));		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		

		$is_specimen = true;
		switch($sample_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				$is_specimen = true;
				unset($sample_data['DerivativeDetail']);
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				$is_specimen = false;
				unset($sample_data['SpecimenDetail']);
				break;
				
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '0'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	

		$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data));	
		
		// Manage Lab Book
		
		$lab_book = null;
		$lab_book_ctrl_id = 0;
		$lab_book_fields = array();
		
		if(!$is_specimen){
			// Set Lab book data for display
			$lab_book = AppModel::getInstance("labbook", "LabBookMaster", true);
			$lab_book_ctrl_id = $this->ParentToDerivativeSampleControl->getLabBookControlId($parent_sample_data['SampleMaster']['sample_control_id'], $sample_data['SampleMaster']['sample_control_id']);
			$lab_book_fields = $lab_book->getFields($lab_book_ctrl_id);
			
			// Set lab book code for initial display
			if(empty($this->data) && !empty($sample_data['DerivativeDetail']['lab_book_master_id'])) {
				$previous_labook = $lab_book->find('first', array('conditions' => array('id'=>$sample_data['DerivativeDetail']['lab_book_master_id']), 'recursive'=>'-1'));
				if(empty($previous_labook)) { $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	
				$sample_data['DerivativeDetail']['lab_book_master_code'] = $previous_labook['LabBookMaster']['code'];
			}	
		}
		$this->set("lab_book_fields", $lab_book_fields);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Get the current menu object. Needed to disable menu options based on sample category
		$this->setBatchMenu($sample_data);
		
		// Set structure
		$structure_name = $sample_data['SampleControl']['form_alias'];
		if($lab_book_ctrl_id != 0){
			$structure_name .= ",derivative_lab_book";
		}
		$this->Structures->set($structure_name);
		
		// MANAGE DATA RECORD
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(empty($this->data)) {
			$this->data = $sample_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}

		} else {
			//Update data	
			if(isset($this->data['SampleMaster']['parent_id']) && ($sample_data['SampleMaster']['parent_id'] !== $this->data['SampleMaster']['parent_id'])) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }

			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->data);
			$this->SampleMaster->id = $sample_master_id;
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			//for error field highlight in detail
			$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
			
			if($is_specimen) { 
				$this->SpecimenDetail->set($this->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates: false;
				$this->data['SpecimenDetail'] = $this->SpecimenDetail->data['SpecimenDetail'];
			}else{
				$this->DerivativeDetail->set($this->data);
				$submitted_data_validates = ($this->DerivativeDetail->validates())? $submitted_data_validates: false;
				$this->data['DerivativeDetail'] = $this->DerivativeDetail->data['DerivativeDetail'];

				//validate and sync or not lab book
				if(array_key_exists('sync_with_lab_book_now', $this->data)){
					$msg = $this->SampleMaster->validateLabBook($this->data, $lab_book, $lab_book_ctrl_id, $this->data[0]['sync_with_lab_book_now']);
					if(strlen($msg) > 0){
						$this->DerivativeDetail->validationErrors['lab_book_master_code'] = $msg;
						$submitted_data_validates = false;
					}
				}
			}
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if($submitted_data_validates) {
				// Save sample data
				if($this->SampleMaster->save($this->data, false)) {				
					//Save either Specimen or Derivative Details
					if($is_specimen){
						// SpecimenDetail
						$this->SpecimenDetail->id = $sample_data['SpecimenDetail']['id'];
						if(!$this->SpecimenDetail->save($this->data['SpecimenDetail'], false)) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
					} else {
						// DerivativeDetail
						$this->DerivativeDetail->id = $sample_data['DerivativeDetail']['id'];
						if(!$this->DerivativeDetail->save($this->data['DerivativeDetail'], false)) { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
					}

					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash('your data has been updated', '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);		
				}				
			}
		}
	}
	
	function delete($collection_id, $sample_master_id) {
		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		
		$is_specimen = true;
		switch($sample_data['SampleControl']['sample_category']) {
			case 'specimen':
				// Displayed sample is a specimen
				$is_specimen = true;
				break;
				
			case 'derivative':
				// Displayed sample is a derivative
				$is_specimen = false;
				break;
				
			default:
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
				
		// Check deletion is allowed
		$arr_allow_deletion = $this->SampleMaster->allowDeletion($sample_master_id);
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			$deletion_done = true;
			
			if(!$this->SampleMaster->atim_delete($sample_master_id)) { $deletion_done = false; }
			
			if($deletion_done) {
				if($is_specimen) {
					if(!$this->SpecimenDetail->atim_delete($sample_data['SpecimenDetail']['id'])) { $deletion_done = false; }
				} else {
					if(!$this->DerivativeDetail->atim_delete($sample_data['DerivativeDetail']['id'])) { $deletion_done = false; }
				}	
			}
			
			if($deletion_done) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { require($hook_link); }
					
				$this->atimFlash('your data has been deleted', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
			
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/sample_masters/contentTreeView/' . $collection_id);
			}
			
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/sample_masters/detail/' . $collection_id . '/' . $sample_master_id);
		}		
	}
	
	function batchDerivativeInit($aliquot_master_id = null){
		// Get Data
		$model = null;
		$key = null;
		$url_to_cancel = null;
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$is_menu_already_set = false;
		if(isset($this->data['SampleMaster'])) {
			$model = 'SampleMaster';
			$key = 'id';
			
		} else if(isset($this->data['ViewSample'])) {
			$model = 'ViewSample';
			$key = 'sample_master_id';
			
		} else if($aliquot_master_id != null){
			$model = 'SampleMaster';
			$key = 'id';
			$aliquot_master = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($aliquot_master)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						
			$this->data['SampleMaster']['id'] = array($aliquot_master['SampleMaster']['id']);
			$this->set("aliquot_ids", $aliquot_master_id);
			$url_to_cancel = '/inventorymanagement/aliquot_masters/detail/'.$aliquot_master['SampleMaster']['collection_id'].'/'.$aliquot_master['SampleMaster']['id'].'/'.$aliquot_master_id;
			$is_menu_already_set = true;
			$this->setAliquotMenu($aliquot_master);
			
		}else if(isset($this->data['ViewAliquot']) || isset($this->data['AliquotMaster'])){
			//aliquot init case
			$aliquot_ids = array_filter(isset($this->data['ViewAliquot']) ? $this->data['ViewAliquot']['aliquot_master_id'] : $this->data['AliquotMaster']['id']);
			if(empty($aliquot_ids)){
				$this->flash(__("batch init no data", true), "javascript:history.back();", 5);
			}
			$aliquot_data = $this->AliquotMaster->find('all', array(
				'fields' => array('AliquotMaster.aliquot_control_id', 'AliquotMaster.sample_master_id'),
				'conditions' => array('AliquotMaster.id' => $aliquot_ids)));
			
			if(empty($aliquot_data)){
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$ids = array();
			$expected_ctrl_id = $aliquot_data[0]['AliquotMaster']['aliquot_control_id'];
			foreach($aliquot_data as $aliquot_unit){
				if($aliquot_unit['AliquotMaster']['aliquot_control_id'] != $expected_ctrl_id){
					$this->flash(__("you must select elements with a common type", true), "javascript:history.back();", 5);
				}
				$ids[] = $aliquot_unit['AliquotMaster']['sample_master_id'];
			}
			$this->data['SampleMaster'] = array('id' => $ids);
			$model = 'SampleMaster';
			$key = 'id';
			$this->set("aliquot_ids", implode(",", $aliquot_ids));
			
		} else {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Set url to redirect
		if($url_to_cancel == null){
			$this->setUrlToCancel();
		}else{
			$this->set('url_to_cancel', $url_to_cancel);
		}
		
		// Manage data	
		$init_data = $this->batchInit(
			$this->SampleMaster, 
			$model, 
			$key, 
			"sample_control_id", 
			$this->ParentToDerivativeSampleControl, 
			"parent_sample_control_id",
			"you cannot create derivatives for this sample type");
		if(array_key_exists('error', $init_data)) {
			$this->flash(__($init_data['error'], true), "javascript:history.back();", 5);
			return;
		}	
		
		// Manage structure and menus
		
		foreach($init_data['possibilities'] as $possibility){
			SampleMaster::$derivatives_dropdown[$possibility['DerivativeControl']['id']] = __($possibility['DerivativeControl']['sample_type'], true);
		}
		
		$this->set('ids', $init_data['ids']);
		
		$this->Structures->set('derivative_init');
		if(!$is_menu_already_set) $this->setBatchMenu(array('SampleMaster' => $init_data['ids']));
		$this->set('parent_sample_control_id', $init_data['control_id']);
		
		$this->set('skip_lab_book_selection_step', true);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function batchDerivativeInit2($aliquot_master_id = null){		
		if(!isset($this->data['SampleMaster']['ids']) 
		|| !isset($this->data['SampleMaster']['sample_control_id'])
		|| !isset($this->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($this->data['SampleMaster']['sample_control_id'] == ''){
			$this->flash(__("you must select a derivative type", true), "javascript:history.back();", 5);
			return;
		}
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$model = empty($this->data['SampleMaster']['ids']) ? 'AliquotMaster' : 'SampleMaster';
		if(is_null($aliquot_master_id)) {
			$this->setBatchMenu(array($model => $this->data[$model]['ids']));
		} else {
			$aliquot_master = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($aliquot_master)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$this->setAliquotMenu($aliquot_master);
		}
		$this->set('sample_master_ids', $this->data['SampleMaster']['ids']);
		$this->set('sample_master_control_id', $this->data['SampleMaster']['sample_control_id']);
		$this->set('parent_sample_control_id', $this->data['ParentToDerivativeSampleControl']['parent_sample_control_id']);
		$this->setUrlToCancel();
		if(isset($this->data['AliquotMaster']['ids'])){
			$this->set('aliquot_master_ids', $this->data['AliquotMaster']['ids']);
		}
		
		$tmp = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => array(
			'ParentToDerivativeSampleControl.parent_sample_control_id' => $this->data['ParentToDerivativeSampleControl']['parent_sample_control_id'],
			'ParentToDerivativeSampleControl.derivative_sample_control_id' => $this->data['SampleMaster']['sample_control_id']
			),
			'fields' => array('ParentToDerivativeSampleControl.lab_book_control_id'),
			'recursive' => -1)
		);
		
		if(is_numeric($tmp['ParentToDerivativeSampleControl']['lab_book_control_id'])){
			$this->set('lab_book_control_id', $tmp['ParentToDerivativeSampleControl']['lab_book_control_id']);
			$this->Structures->set('derivative_lab_book');
			AppController::addWarningMsg(__('if no lab book has to be defined for this process, keep fields empty and click submit to continue', true));
		}else{
			$this->Structures->set('empty');
			AppController::addWarningMsg(__('no lab book can be applied to the current item(s)', true).__('click submit to continue', true));
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function batchDerivative($aliquot_master_id = null){
		if(!isset($this->data['SampleMaster']['sample_control_id'])
			|| !isset($this->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])
		){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($this->data['SampleMaster']['sample_control_id'] == ''){
			$this->flash(__("you must select a derivative type", true), "javascript:history.back();", 5);
			return;
		}
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$lab_book_master_code = null;
		$sync_with_lab_book = null;
		$lab_book_fields = null;
		$lab_book_id = null;
		$parent_sample_control_id = $this->data['ParentToDerivativeSampleControl']['parent_sample_control_id'];
		unset($this->data['ParentToDerivativeSampleControl']);
		if(isset($this->data['DerivativeDetail']['lab_book_master_code']) && !empty($this->data['DerivativeDetail']['lab_book_master_code'])){
			$lab_book_master_code = $this->data['DerivativeDetail']['lab_book_master_code'];
			$sync_with_lab_book = $this->data['DerivativeDetail']['sync_with_lab_book'];
			$lab_book = AppModel::getInstance("labbook", "LabBookMaster", true);
			$lab_book_expected_ctrl_id = $this->ParentToDerivativeSampleControl->getLabBookControlId($parent_sample_control_id,$this->data['SampleMaster']['sample_control_id']); 
			$foo = array();
			$result = $lab_book->syncData($foo, array(), $lab_book_master_code, $lab_book_expected_ctrl_id);

			if(is_numeric($result)){
				$lab_book_id = $result;
			}else{
				$this->flash($result, "javascript:history.back()", 5);
				return;
			}
			$lab_book_data = $lab_book->findById($lab_book_id);
			$lab_book_fields = $lab_book->getFields($lab_book_data['LabBookControl']['id']);
		}
		$this->set('lab_book_master_code', $lab_book_master_code);
		$this->set('sync_with_lab_book', $sync_with_lab_book);
		$this->set('lab_book_fields', $lab_book_fields);
		unset($this->data['DerivativeDetail']);
		
		// Set structures and menu
		$ids = array_key_exists('ids', $this->data['SampleMaster']) ? $this->data['SampleMaster']['ids'] : $this->data['sample_master_ids'];
		$this->set('sample_master_ids', $ids);
		unset($this->data['sample_master_ids']);

		$unique_aliquot_master_data = null;
		if(is_null($aliquot_master_id)) {
			$this->setBatchMenu(array('SampleMaster' => $ids));
		} else {
			$unique_aliquot_master_data = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($unique_aliquot_master_data)){
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->setAliquotMenu($unique_aliquot_master_data);
		}
		
		$children_control_data = $this->SampleControl->findById($this->data['SampleMaster']['sample_control_id']);
		
		$this->Structures->set('view_sample_joined_to_collection', 'sample_info');
		$this->Structures->set(str_replace(",derivative_lab_book", "", $children_control_data['SampleControl']['form_alias']), 'derivative_structure');
		$this->Structures->set(str_replace(",derivative_lab_book", "", $children_control_data['SampleControl']['form_alias']).",sourcealiquots_volume_for_batchderivative", 'derivative_volume_structure');
		$this->Structures->set('used_aliq_in_stock_details', 'sourcealiquots');
		$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');

		$this->set('children_sample_control_id', $this->data['SampleMaster']['sample_control_id']);
		$this->set('created_sample_override_data', array(
			'SampleControl.sample_type'		=> $children_control_data['SampleControl']['sample_type'],
			'SampleControl.sample_category'	=> $children_control_data['SampleControl']['sample_category'],
			'DerivativeDetail.creation_datetime' => date('Y-m-d G:i')));
		$this->set('parent_sample_control_id', $parent_sample_control_id);
		
		$this->setUrlToCancel();
		unset($this->data['url_to_cancel']);
		
		$joins = array(array(
				'table' => 'view_samples',
				'alias' => 'ViewSample',
				'type' => 'INNER',
				'conditions' => array('AliquotMaster.sample_master_id = ViewSample.sample_master_id')
			)
		);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(isset($this->data['SampleMaster']['ids'])){
			//1- INITIAL DISPLAY
			if(!empty($this->data['AliquotMaster']['ids'])){
				$this->AliquotMaster->unbindModel(array('belongsTo' => array('SampleMaster')));
				$aliquots = $this->AliquotMaster->find('all', array(
					'conditions'	=> array('AliquotMaster.id' => explode(",", $this->data['AliquotMaster']['ids'])),
					'fields'		=> array('*'), 
					'recursive'		=> 0,
					'joins'			=> $joins)
				);
				$this->data = array();
				foreach($aliquots as $aliquot){
					$this->data[] = array('parent' => $aliquot, 'children' => array());
				}
			}else{
				$samples = $this->ViewSample->find('all', array('conditions' => array('ViewSample.sample_master_id' => explode(",", $this->data['SampleMaster']['ids'])), 'recursive' => -1));
				$this->data = array();
				foreach($samples as $sample){
					$this->data[] = array('parent' => $sample, 'children' => array());
				}
			}
						
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		}else{
				
			// 2- VALIDATE PROCESS
			
			unset($this->data['SampleMaster']);
			
			$errors = array();
			$prev_data = $this->data;
			$this->data = array();
			$record_counter = 0;
			$aliquots_data = array();
			$validation_iterations = array('SampleMaster', 'DerivativeDetail', 'SourceAliquot');
			$set_source_aliquot = false;
			foreach($prev_data as $parent_id => &$children){
				$parent = null;
				$record_counter++;
				if(isset($children['AliquotMaster'])){
					$set_source_aliquot = true;					
					$this->AliquotMaster->unbindModel(array('belongsTo' => array('SampleMaster')));
					$parent = $this->AliquotMaster->find('first', array(
						'conditions'	=> array('AliquotMaster.id' => $parent_id),
						'fields'		=> array('*'), 
						'recursive'		=> 0,
						'joins'			=> $joins)
					);
					$parent['AliquotMaster'] = array_merge($parent['AliquotMaster'], $children['AliquotMaster']);
					$parent['FunctionManagement'] = $children['FunctionManagement'];
					$children['AliquotMaster']['id'] = $parent_id;
					$aliquots_data[] = array('AliquotMaster' => $children['AliquotMaster'], 'FunctionManagement' => $children['FunctionManagement']);
					$this->AliquotMaster->data = array();
					unset($children['AliquotMaster']['storage_coord_x']);
					unset($children['AliquotMaster']['storage_coord_y']);
					$this->AliquotMaster->set($children['AliquotMaster']);
					$this->AliquotMaster->validates();
					foreach($this->AliquotMaster->validationErrors as $field => $msg) {
						$errors[$field][$msg][] = $record_counter;
					}
					
					unset($children['AliquotMaster'], $children['FunctionManagement'], $children['AliquotControl'], $children['StorageMaster']);
				}else{
					$parent = $this->ViewSample->find('first', array('conditions' => array('ViewSample.sample_master_id' => $parent_id), 'recursive' => -1));
				}
				unset($children['ViewSample']);
				
				$new_derivative_created = !empty($children);
				$sample_control_id = $children_control_data['SampleControl']['id'];
				foreach($children as &$child){
					$child['SampleMaster']['sample_control_id'] = $sample_control_id;
					$child['SampleMaster']['collection_id'] = $parent['ViewSample']['collection_id'];
					
					$child['SampleMaster']['initial_specimen_sample_id'] = $parent['ViewSample']['initial_specimen_sample_id'];
					$child['SampleMaster']['initial_specimen_sample_type'] = $parent['ViewSample']['initial_specimen_sample_type'];
					
					$child['SampleMaster']['parent_sample_type'] = $parent['ViewSample']['sample_type'];
					
					$child['DerivativeDetail']['sync_with_lab_book'] = $sync_with_lab_book;
					$child['DerivativeDetail']['lab_book_master_id'] = $lab_book_id;
					
					foreach($validation_iterations as $validation_model_name){
						if(array_key_exists($validation_model_name, $child)) {
							$validation_model = $this->{$validation_model_name}; 
							$validation_model->data = array();
							$validation_model->set($child);
							if(!$validation_model->validates()){
								foreach($validation_model->validationErrors as $field => $msg) {
									$errors[$field][$msg][] = $record_counter;
								}
							}
							$child = $validation_model->data;
						}					
					}
				}
				
				if($lab_book_id != null){
					$lab_book->syncData($children, array("DerivativeDetail"), $lab_book_master_code);
				}
				$this->data[] = array('parent' => $parent, 'children' => $children);//prep data in case validation fails
				if(!$new_derivative_created){
					$errors[]['at least one child has to be created'][] = $record_counter;
				}
			}
			$this->SourceAliquot->validationErrors = null;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}				
			
			// 3- SAVE PROCESS
			
			if(empty($errors)){
				unset($_SESSION['derivative_batch_process']);
				
				//save
				$child_ids = array();
				foreach($prev_data as $parent_id => &$children){
					unset($children['ViewSample']);
					unset($children['StorageMaster']);
					foreach($children as &$child){
						// save sample master
						$this->SampleMaster->id = null;
						if(!$this->SampleMaster->save($child, false)){ 
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						} 							
						$child_id = $this->SampleMaster->getLastInsertId();
						
						// Update sample code
						$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $child_id;";
						if(!$this->SampleMaster->query($query_to_update) 
						|| !$this->SampleMaster->query(str_replace("sample_masters", "sample_masters_revs", $query_to_update))) {
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}

						// Save derivative detail
						$this->DerivativeDetail->id = null;
						$child['DerivativeDetail']['sample_master_id'] = $child_id;
						if(!$this->DerivativeDetail->save($child, false)){ 
							$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}

						if($set_source_aliquot){
							//record aliquot use -> source_aliquots
							$this->SourceAliquot->id = null;
							$this->SourceAliquot->data = array();
							$this->SourceAliquot->save(array('SourceAliquot' => array(
								'sample_master_id'	=> $child_id,
								'aliquot_master_id'	=> $parent_id,
								'used_volume'		=> isset($child['SourceAliquot']['used_volume']) ? $child['SourceAliquot']['used_volume'] : null,
							)));
						}
													
						$child_ids[] = $child_id;
					}
				}
				
				foreach($aliquots_data as $aliquot){
					//update all used aliquots
					$this->AliquotMaster->data = array();
					if($aliquot['FunctionManagement']['remove_from_storage'] || ($aliquot['AliquotMaster']['in_stock'] == 'no')) {
						// Delete aliquot storage data
						$aliquot['AliquotMaster']['storage_master_id'] = null;
						$aliquot['AliquotMaster']['storage_coord_x'] = null;
						$aliquot['AliquotMaster']['storage_coord_y'] = null;
					}
					$this->AliquotMaster->save($aliquot, false);
					$this->AliquotMaster->updateAliquotUseAndVolume($aliquot['AliquotMaster']['id'], true, true, false);
				}

				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				if(is_null($unique_aliquot_master_data)) {
					$datamart_structure = AppModel::getInstance("datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('ViewSample'),
						'flag_tmp' => true
					));
					$batch_set_model->saveWithIds($batch_set_data, $child_ids);
					$this->flash('your data has been saved', '/datamart/batch_sets/listall/'.$batch_set_model->getLastInsertId());
				} else {
					if(!isset($unique_aliquot_master_data['AliquotMaster'])){
						$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$this->flash('your data has been saved','/inventorymanagement/aliquot_masters/detail/' .$unique_aliquot_master_data['AliquotMaster']['collection_id'] . '/' . $unique_aliquot_master_data['AliquotMaster']['sample_master_id']. '/' . $aliquot_master_id);					
				}
				
			}else{
				$this->SampleMaster->validationErrors = array();
				$this->DerivativeDetail->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->SampleMaster->validationErrors[$field][] = __($msg, true) . ' - ' . str_replace('%s', implode(",", $lines), __('see # %s',true));					
					} 
				}
			}
		}
		
		if(isset($this->data[0]['parent']['AliquotMaster']) && empty($this->data[0]['parent']['AliquotControl']['volume_unit'])){
			 $this->Structures->set('sourcealiquots', 'sourcealiquots');//overwrite, we do not need the volume
		}
	}
	
	function batchDerivativeFromAliquotsInit(){
		if(!isset($this->data['ViewAliquot']['aliquot_master_id'])){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$id = isset($this->data['BatchSet']['id']) ? $this->data['BatchSet']['id'] : 0;
		$this->set('url_to_cancel', isset($this->data['BatchSet'])?'/datamart/batch_sets/listall/' . $id : '/datamart/browser/browse/' . $this->data['node']['id']);
		
		$aliquot_ids = array_filter($this->data['ViewAliquot']['aliquot_master_id']);
		if(empty($aliquot_ids)){
			$this->flash(__("batch init no data", true), "javascript:history.back();", 5);
		}
		$aliquot_data = $this->AliquotMaster->find('all', array(
			'fields' => array('AliquotMaster.aliquot_control_id', 'AliquotMaster.sample_master_id'),
			'conditions' => array('AliquotMaster.id' => $aliquot_ids)));
		
		if(empty($aliquot_data)){
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$ids = array();
		$expected_ctrl_id = $aliquot_data[0]['AliquotMaster']['aliquot_control_id'];
		foreach($aliquot_data as $aliquot_unit){
			if($aliquot_unit['AliquotMaster']['aliquot_control_id'] != $expected_ctrl_id){
				$this->flash(__("you must select elements with a common type", true), "javascript:history.back();", 5);
			}
			$ids[] = $aliquot_unit['AliquotMaster']['sample_master_id'];
		}
		$this->data = array('SampleMaster' => array('id' => $ids));
		
		$init_data = $this->batchInit(
			$this->SampleMaster,
			'SampleMaster',
			'id',
			"sample_control_id", 
			$this->ParentToDerivativeSampleControl,
			"parent_sample_control_id",
			"you cannot create derivatives for this aliquot type");
		if(array_key_exists('error', $init_data)) {
			$this->flash(__($init_data['error'], true), "javascript:history.back();", 5);
			return;
		}
		
		foreach($init_data['possibilities'] as $possibility){
			SampleMaster::$derivatives_dropdown[$possibility['DerivativeControl']['id']] = __($possibility['DerivativeControl']['sample_type'], true);
		}
		
		$this->set('ids', $ids);
		
		$this->Structures->set('derivative_init');
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/'));
		$this->set('parent_sample_control_id', $init_data['control_id']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
}
	
?>