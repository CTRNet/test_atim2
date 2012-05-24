<?php
class SampleMastersController extends InventoryManagementAppController {

	var $components = array();

	var $uses = array(
		'InventoryManagement.Collection',
		
		'InventoryManagement.SampleControl',

		'InventoryManagement.SampleMaster',
		'InventoryManagement.ViewSample',
		'InventoryManagement.SampleDetail',
	 	'InventoryManagement.SpecimenDetail',		
		'InventoryManagement.DerivativeDetail',		
		
		'InventoryManagement.ParentToDerivativeSampleControl',
		
		'InventoryManagement.AliquotControl',
		'InventoryManagement.AliquotMaster',
		
		'InventoryManagement.SourceAliquot',
		'InventoryManagement.QualityCtrl',
		'InventoryManagement.SpecimenReviewMaster',
		
		'InventoryManagement.Realiquoting',
	
		'ExternalLink');
	
	var $paginate = array(
		'SampleMaster' => array('limit' => pagination_amount, 'order' => 'SampleMaster.sample_code DESC'),
		'ViewSample' => array('limit' =>pagination_amount , 'order' => 'ViewSample.sample_code DESC'), 
		'AliquotMaster' => array('limit' =>pagination_amount , 'order' => 'AliquotMaster.barcode DESC'));

	function search($search_id = 0) {
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/collections/search'));
		
		//lazy load
		$this->SampleControl;
		$this->AliquotControl;
		
		$this->searchHandler($search_id, $this->ViewSample, 'view_sample_joined_to_collection', '/InventoryManagement/SampleMasters/search');
		
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
		$this->Collection->getOrRedirect($collection_id);
		
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
			$this->request->data = $this->SampleMaster->find('all', array('conditions' => array("SampleMaster.collection_id" => $collection_id, "SampleMaster.parent_id IS NULL"), 'recursive' => 0));
		}else{
			$this->request->data = $this->SampleMaster->find('all', array('conditions' => array("SampleMaster.collection_id" => $collection_id, "SampleMaster.parent_id" => $sample_master_id), 'recursive' => 0));
		}
		
		$ids = array();
		foreach($this->request->data as $unit){
			$ids[] = $unit['SampleMaster']['id'];
		}
		$ids = array_flip($this->SampleMaster->hasChild($ids));//array_key_exists is faster than in_array
		foreach($this->request->data as &$unit){
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
			$this->request->data = array_merge($this->request->data, $aliquots);
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
		if((!$collection_id) || (!$specimen_sample_master_id)) { $this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); }

		$specimen_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $specimen_sample_master_id), 'recursive' => -1)); 
		if(empty($specimen_data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$derivatives_data = array();
		$derivatives_data = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $specimen_sample_master_id, 'SampleMaster.initial_specimen_sample_id != SampleMaster.id'), 'recursive' => 0)); 
		
		if(empty($derivatives_data)) {
			$this->Structures->set('sample_masters,sd_undetailed_derivatives', 'no_data_structure');
			$this->request->data = array();
						
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
		$menu_link = '/InventoryManagement/SampleMasters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%';
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
		
		// MANAGE DATA

		// Get the sample data
		$sample_data = $this->ViewSample->find('first', array('conditions' => array('ViewSample.collection_id' => $collection_id, 'ViewSample.sample_master_id' => $sample_master_id)));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		$sample_data['SampleMaster']['coll_to_rec_spent_time_msg']  = $sample_data['ViewSample']['coll_to_rec_spent_time_msg'];
		$sample_data['SampleMaster']['coll_to_creation_spent_time_msg']  = $sample_data['ViewSample']['coll_to_creation_spent_time_msg'];
		 
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
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '0'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}	
		
		$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data));	
		$this->set('parent_sample_master_id', $parent_sample_master_id);	
		
		// Set sample data
		$this->set('sample_master_data', $sample_data);
		$this->request->data = array();
					
		// Set sample aliquot list
		$aliquots_data = array();
		if(!$is_from_tree_view) {
			$aliquots_data = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.collection_id' => $collection_id, 'AliquotMaster.sample_master_id' => $sample_master_id))); 
			$aliquots_data = AppController::defineArrayKey($aliquots_data, "AliquotMaster", "aliquot_control_id", false);
			$this->set('aliquots_data', $aliquots_data);
		}
		
		// Set Lab Book Id
		if(isset($sample_data['DerivativeDetail']['lab_book_master_id']) && !empty($sample_data['DerivativeDetail']['lab_book_master_id'])){
			$this->set('lab_book_master_id', $sample_data['DerivativeDetail']['lab_book_master_id']);
		}
		
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
		
		if(!$is_specimen){
			//derivative aliquot source
			
			$joins = array(array(
				'table' => 'source_aliquots',
				'alias' => 'SourceAliquot',
				'type' => 'INNER',
				'conditions' => array('AliquotMaster.id = SourceAliquot.aliquot_master_id', 'SourceAliquot.deleted != 1', 'SourceAliquot.sample_master_id' => $sample_master_id)
			));
			
			$aliquot_source = $this->AliquotMaster->find('all', array(
				'fields' => '*',
				'conditions' => array('AliquotMaster.collection_id'=>$collection_id),
				'joins'	=> $joins)
			);
			
			$this->set('aliquot_source', $aliquot_source);
			
			
			// Set structure
			$this->Structures->set('sourcealiquots,sourcealiquots_volume', 'aliquot_source_struct');
		}

		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add($collection_id, $sample_control_id, $parent_sample_master_id = 0) {
		if($this->request->is('ajax')){
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
			$sample_control_data = $this->SampleControl->getOrRedirect($sample_control_id);
			
			// Check collection id
			$collection_data = $this->Collection->getOrRedirect($collection_id);
			
		} else {
			// Created sample is a derivative: Get parent sample information
			$is_specimen = false;
			
			// Get parent data
			$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => 0));
			if(empty($parent_sample_data)) { 
				$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			
			// Get Control Data
			$criteria = array(
				'ParentSampleControl.id' => $parent_sample_data['SampleMaster']['sample_control_id'],
				'ParentToDerivativeSampleControl.flag_active' => '1',
				'DerivativeControl.id' => $sample_control_id);
			$parent_to_derivative_sample_control = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => $criteria));
			if(empty($parent_to_derivative_sample_control)) { 
				$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
			}
			$sample_control_data['SampleControl'] = $parent_to_derivative_sample_control['DerivativeControl'];
			
			// Get Lab Book Ctrl Id & Fields
			$lab_book = AppModel::getInstance("LabBook", "LabBookMaster", true);
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
		$atim_menu_link = ($is_specimen? '/InventoryManagement/Collections/detail/%%Collection.id%%' : '/InventoryManagement/SampleMasters/listAllDerivatives/%%Collection.id%%/%%SampleMaster.initial_specimen_sample_id%%');
		$this->set('atim_menu', $this->Menus->get($atim_menu_link));
		
		$atim_menu_variables = (empty($parent_sample_data)? array('Collection.id' => $collection_id) : array('Collection.id' => $collection_id, 'SampleMaster.initial_specimen_sample_id' => $parent_sample_data['SampleMaster']['initial_specimen_sample_id']));
		
		$this->set('atim_menu_variables', $atim_menu_variables);
		
		// set structure alias based on VALUE from CONTROL table
		$structure_name = $sample_control_data['SampleControl']['form_alias'];
		if($lab_book_ctrl_id != 0){
			$structure_name .= ",derivative_lab_book";
		}
		$this->Structures->set($structure_name, 'atim_structure', array('model_table_assoc' => array('SampleDetail' => $sample_control_data['SampleControl']['detail_tablename'])));
				
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}	
		
		// MANAGE DATA RECORD
		
		if(empty($this->request->data)) {
			$this->request->data = array();
			$this->request->data['SampleControl']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];
			$this->request->data['SampleControl']['sample_category'] = $sample_control_data['SampleControl']['sample_category'];
	
			//Set default reception date
			if($is_specimen && !isset(AppController::getInstance()->passedArgs['templateInitId'])){
				$default_reception_datetime = null;
				$default_reception_datetime_accuracy = null;
				if($this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id))) == 0){
					$collection = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
					$default_reception_datetime = $collection['Collection']['collection_datetime'];
					$default_reception_datetime_accuracy = $collection['Collection']['collection_datetime_accuracy'];
				}else{
					$sample = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'order' => array('SpecimenDetail.reception_datetime')));
					$default_reception_datetime = $sample['SpecimenDetail']['reception_datetime'];
					$default_reception_datetime_accuracy = $sample['SpecimenDetail']['reception_datetime_accuracy'];
				}
				if($default_reception_datetime){
					$this->request->data['SpecimenDetail']['reception_datetime'] = $default_reception_datetime;
					$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $default_reception_datetime_accuracy;
				}
			}
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}	
		
		} else {
			// Set additional data
			$this->request->data['SampleMaster']['collection_id'] = $collection_id;
			$this->request->data['SampleMaster']['sample_control_id'] = $sample_control_data['SampleControl']['id'];
			$this->request->data['SampleControl']['sample_type'] = $sample_control_data['SampleControl']['sample_type'];			
			
			// Set either specimen or derivative additional data
			if($is_specimen){
				// The created sample is a specimen
				if(isset($this->request->data['SampleMaster']['parent_id'])) { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
				
				$this->request->data['SampleMaster']['initial_specimen_sample_type'] = $this->request->data['SampleControl']['sample_type'];
				$this->request->data['SampleMaster']['initial_specimen_sample_id'] = null; 	// ID will be known after sample creation
			} else {
				// The created sample is a derivative
				$this->request->data['SampleMaster']['parent_sample_type'] = $parent_sample_data['SampleControl']['sample_type'];
				$this->request->data['SampleMaster']['parent_id'] = $parent_sample_data['SampleMaster']['id'];
				$this->SampleMaster->addWritableField(array('parent_id', 'parent_sample_type'));
				
				$this->request->data['SampleMaster']['initial_specimen_sample_type'] = $parent_sample_data['SampleMaster']['initial_specimen_sample_type'];
				$this->request->data['SampleMaster']['initial_specimen_sample_id'] = $parent_sample_data['SampleMaster']['initial_specimen_sample_id'];
			}
  	  			  	
			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->request->data);
			$submitted_data_validates = ($this->SampleMaster->validates()) ? $submitted_data_validates: false;
			
			//for error field highlight in detail
			$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
			
			if($is_specimen) { 
				$this->SpecimenDetail->set($this->request->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates : false;
				$this->request->data['SpecimenDetail'] = $this->SpecimenDetail->data['SpecimenDetail'];
			} else { 
				$this->DerivativeDetail->set($this->request->data);
				$submitted_data_validates = ($this->DerivativeDetail->validates())? $submitted_data_validates : false;
				$this->request->data['DerivativeDetail'] = $this->DerivativeDetail->data['DerivativeDetail'];

				//validate and sync lab book
				$msg = $this->SampleMaster->validateLabBook($this->request->data, $lab_book, $lab_book_ctrl_id, true);
				$this->DerivativeDetail->addWritableField('lab_book_master_id');
				
				if(strlen($msg) > 0){
					$this->DerivativeDetail->validationErrors['lab_book_master_code'] = $msg;
					$submitted_data_validates = false;
				}
			}
			
			$this->SampleMaster->addWritableField(array('collection_id', 'sample_control_id', 'initial_specimen_sample_type', 'initial_specimen_sample_id'));
			$this->SampleMaster->addWritableField(array('sample_master_id'), $sample_control_data['SampleControl']['detail_tablename']);
			$this->SampleMaster->addWritableField(array('sample_master_id'), $is_specimen ? 'specimen_details' : 'derivative_details');
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if($submitted_data_validates) {
				// Save sample data
				$sample_master_id = null;
				
				if($this->SampleMaster->save($this->request->data, false)) {
					
					$sample_master_id = $this->SampleMaster->getLastInsertId();
				
					// Record additional sample data
					$query_to_update = null;
					if($is_specimen){
						$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id, sample_masters.initial_specimen_sample_id = sample_masters.id WHERE sample_masters.id = $sample_master_id;";
					}else{
						$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $sample_master_id;";
					}

					try{
						$this->SampleMaster->query($query_to_update);
						$this->SampleMaster->query(str_replace("sample_masters", "sample_masters_revs", $query_to_update));
					}catch(Exception $e){
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					
					// Save either specimen or derivative detail
					if($is_specimen){
						// SpecimenDetail
						$this->request->data['SpecimenDetail']['sample_master_id'] = $sample_master_id;
						$this->SpecimenDetail->id = $sample_master_id;
						if(!$this->SpecimenDetail->save($this->request->data['SpecimenDetail'], false)) { 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					} else {
						// DerivativeDetail
						$this->request->data['DerivativeDetail']['sample_master_id'] = $sample_master_id;
						$this->DerivativeDetail->id = $sample_master_id;
						if(!$this->DerivativeDetail->save($this->request->data['DerivativeDetail'], false)) { 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}						
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					if($this->request->is('ajax')){
						echo json_encode(array('goToNext' => true, 'display' => '', 'id' => $sample_master_id));
						exit;
					}else{
						$this->atimFlash('your data has been saved', '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);
					}	
				}					
			}
		}
		
		$this->set('is_specimen', $is_specimen);		
		$this->set('is_ajax', $this->request->is('ajax'));
	}
	
	function edit($collection_id, $sample_master_id) {
		if((!$collection_id) || (!$sample_master_id)){
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE DATA

		// Get the sample data
		
		$this->SampleMaster->unbindModel(array('hasMany' => array('AliquotMaster')));		
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id)));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }		

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
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}

		// Get parent sample information
		$parent_sample_master_id = $sample_data['SampleMaster']['parent_id'];
		$parent_sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $parent_sample_master_id), 'recursive' => '0'));
		if(!empty($parent_sample_master_id) && empty($parent_sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); }	

		$this->set('parent_sample_data_for_display', $this->SampleMaster->formatParentSampleDataForDisplay($parent_sample_data));	
		
		// Manage Lab Book
		
		$lab_book = null;
		$lab_book_ctrl_id = 0;
		$lab_book_fields = array();
		
		if(!$is_specimen){
			// Set Lab book data for display
			$lab_book = AppModel::getInstance("LabBook", "LabBookMaster", true);
			$lab_book_ctrl_id = $this->ParentToDerivativeSampleControl->getLabBookControlId($parent_sample_data['SampleMaster']['sample_control_id'], $sample_data['SampleMaster']['sample_control_id']);
			$lab_book_fields = $lab_book->getFields($lab_book_ctrl_id);
			
			// Set lab book code for initial display
			if(empty($this->request->data) && !empty($sample_data['DerivativeDetail']['lab_book_master_id'])) {
				$previous_labook = $lab_book->find('first', array('conditions' => array('id'=>$sample_data['DerivativeDetail']['lab_book_master_id']), 'recursive'=>'-1'));
				if(empty($previous_labook)) {
					$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
				}	
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
		$this->Structures->set($structure_name, 'atim_structure', array('model_table_assoc' => array('SampleDetail' => $sample_data['SampleControl']['detail_tablename'])));
		
		// MANAGE DATA RECORD
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if(empty($this->request->data)) {
			$this->request->data = $sample_data;
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}

		} else {
			//Update data	
			if(isset($this->request->data['SampleMaster']['parent_id']) && ($sample_data['SampleMaster']['parent_id'] !== $this->request->data['SampleMaster']['parent_id'])) { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }

			// Validates data
			
			$submitted_data_validates = true;
			
			$this->SampleMaster->set($this->request->data);
			$this->SampleMaster->id = $sample_master_id;
			$submitted_data_validates = ($this->SampleMaster->validates())? $submitted_data_validates: false;
			
			//for error field highlight in detail
			$this->SampleDetail->validationErrors = $this->SampleMaster->validationErrors;
			
			if($is_specimen) { 
				$this->SpecimenDetail->set($this->request->data);
				$submitted_data_validates = ($this->SpecimenDetail->validates())? $submitted_data_validates: false;
				$this->request->data['SpecimenDetail'] = $this->SpecimenDetail->data['SpecimenDetail'];
			}else{
				$this->DerivativeDetail->set($this->request->data);
				$submitted_data_validates = ($this->DerivativeDetail->validates())? $submitted_data_validates: false;
				$this->request->data['DerivativeDetail'] = $this->DerivativeDetail->data['DerivativeDetail'];

				//validate and sync or not lab book
				if(array_key_exists('sync_with_lab_book_now', $this->request->data)){
					$msg = $this->SampleMaster->validateLabBook($this->request->data, $lab_book, $lab_book_ctrl_id, $this->request->data[0]['sync_with_lab_book_now']);
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
				$this->SampleMaster->id = $sample_master_id;
				if($this->SampleMaster->save($this->request->data, false)) {				
					//Save either Specimen or Derivative Details
					if($is_specimen){
						// SpecimenDetail
						$this->SpecimenDetail->id = $sample_master_id;
						if(!$this->SpecimenDetail->save($this->request->data['SpecimenDetail'], false)) { 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					} else {
						// DerivativeDetail
						$this->DerivativeDetail->id = $sample_master_id;
						if(!$this->DerivativeDetail->save($this->request->data['DerivativeDetail'], false)) { 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}
					}

					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash('your data has been updated', '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);		
				}				
			}
		}
	}
	
	function delete($collection_id, $sample_master_id) {
		// Get the sample data
		$sample_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.id' => $sample_master_id), 'recursive' => '0'));
		if(empty($sample_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
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
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
				
		// Check deletion is allowed
		$arr_allow_deletion = $this->SampleMaster->allowDeletion($sample_master_id);
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->SampleMaster->atimDelete($sample_master_id)){
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { require($hook_link); }
					
				$this->atimFlash('your data has been deleted', '/InventoryManagement/Collections/detail/' . $collection_id);
			
			} else {
				$this->flash('error deleting data - contact administrator', '/InventoryManagement/Collections/detail/' . $collection_id);
			}
			
		} else {
			$this->flash($arr_allow_deletion['msg'], '/InventoryManagement/SampleMasters/detail/' . $collection_id . '/' . $sample_master_id);
		}		
	}
	
	function batchDerivativeInit($aliquot_master_id = null){
		// Get Data
		$model = null;
		$key = null;
		$url_to_cancel = null;
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$is_menu_already_set = false;
		if(isset($this->request->data['SampleMaster'])) {
			$model = 'SampleMaster';
			$key = 'id';
			
		} else if(isset($this->request->data['ViewSample'])) {
			$model = 'ViewSample';
			$key = 'sample_master_id';
			
		} else if($aliquot_master_id != null){
			$model = 'SampleMaster';
			$key = 'id';
			$aliquot_master = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($aliquot_master)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						
			$this->request->data['SampleMaster']['id'] = array($aliquot_master['SampleMaster']['id']);
			$this->set("aliquot_ids", $aliquot_master_id);
			$url_to_cancel = '/InventoryManagement/AliquotMasters/detail/'.$aliquot_master['SampleMaster']['collection_id'].'/'.$aliquot_master['SampleMaster']['id'].'/'.$aliquot_master_id;
			$is_menu_already_set = true;
			$this->setAliquotMenu($aliquot_master);
			
		}else if(isset($this->request->data['ViewAliquot']) || isset($this->request->data['AliquotMaster'])){
			//aliquot init case
			$aliquot_ids = array_filter(isset($this->request->data['ViewAliquot']) ? $this->request->data['ViewAliquot']['aliquot_master_id'] : $this->request->data['AliquotMaster']['id']);
			if(empty($aliquot_ids)){
				$this->flash(__("batch init no data"), "javascript:history.back();", 5);
			}
			$aliquot_data = $this->AliquotMaster->find('all', array(
				'fields' => array('AliquotMaster.aliquot_control_id', 'AliquotMaster.sample_master_id'),
				'conditions' => array('AliquotMaster.id' => $aliquot_ids)));
			
			if(empty($aliquot_data)){
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			$ids = array();
			$expected_ctrl_id = $aliquot_data[0]['AliquotMaster']['aliquot_control_id'];
			foreach($aliquot_data as $aliquot_unit){
				if($aliquot_unit['AliquotMaster']['aliquot_control_id'] != $expected_ctrl_id){
					$this->flash(__("you must select elements with a common type"), "javascript:history.back();", 5);
				}
				$ids[] = $aliquot_unit['AliquotMaster']['sample_master_id'];
			}
			$this->request->data['SampleMaster'] = array('id' => $ids);
			$model = 'SampleMaster';
			$key = 'id';
			$this->set("aliquot_ids", implode(",", $aliquot_ids));
			
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
			$this->flash(__($init_data['error']), "javascript:history.back();", 5);
			return;
		}	
		
		// Manage structure and menus
		
		foreach($init_data['possibilities'] as $possibility){
			SampleMaster::$derivatives_dropdown[$possibility['DerivativeControl']['id']] = __($possibility['DerivativeControl']['sample_type']);
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
		if(!isset($this->request->data['SampleMaster']['ids']) 
		|| !isset($this->request->data['SampleMaster']['sample_control_id'])
		|| !isset($this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($this->request->data['SampleMaster']['sample_control_id'] == ''){
			$this->flash(__("you must select a derivative type"), "javascript:history.back();", 5);
			return;
		}
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$model = empty($this->request->data['SampleMaster']['ids']) ? 'AliquotMaster' : 'SampleMaster';
		if(is_null($aliquot_master_id)) {
			$this->setBatchMenu(array($model => $this->request->data[$model]['ids']));
		} else {
			$aliquot_master = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($aliquot_master)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$this->setAliquotMenu($aliquot_master);
		}
		$this->set('sample_master_ids', $this->request->data['SampleMaster']['ids']);
		$this->set('sample_master_control_id', $this->request->data['SampleMaster']['sample_control_id']);
		$this->set('parent_sample_control_id', $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id']);
		$this->setUrlToCancel();
		if(isset($this->request->data['AliquotMaster']['ids'])){
			$this->set('aliquot_master_ids', $this->request->data['AliquotMaster']['ids']);
		}
		
		$tmp = $this->ParentToDerivativeSampleControl->find('first', array('conditions' => array(
			'ParentToDerivativeSampleControl.parent_sample_control_id' => $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'],
			'ParentToDerivativeSampleControl.derivative_sample_control_id' => $this->request->data['SampleMaster']['sample_control_id']
			),
			'fields' => array('ParentToDerivativeSampleControl.lab_book_control_id'),
			'recursive' => -1)
		);
		
		if(is_numeric($tmp['ParentToDerivativeSampleControl']['lab_book_control_id'])){
			$this->set('lab_book_control_id', $tmp['ParentToDerivativeSampleControl']['lab_book_control_id']);
			$this->Structures->set('derivative_lab_book');
			AppController::addWarningMsg(__('if no lab book has to be defined for this process, keep fields empty and click submit to continue'));
		}else{
			$this->Structures->set('empty');
			AppController::addWarningMsg(__('no lab book can be applied to the current item(s)').__('click submit to continue'));
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function batchDerivative($aliquot_master_id = null){
		if(!isset($this->request->data['SampleMaster']['sample_control_id'])
			|| !isset($this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'])
		){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($this->request->data['SampleMaster']['sample_control_id'] == ''){
			$this->flash(__("you must select a derivative type"), "javascript:history.back();", 5);
			return;
		}
		
		$this->set('aliquot_master_id', $aliquot_master_id);
		
		$lab_book_master_code = null;
		$sync_with_lab_book = null;
		$lab_book_fields = null;
		$lab_book_id = null;
		$parent_sample_control_id = $this->request->data['ParentToDerivativeSampleControl']['parent_sample_control_id'];
		unset($this->request->data['ParentToDerivativeSampleControl']);
		if(isset($this->request->data['DerivativeDetail']['lab_book_master_code']) && !empty($this->request->data['DerivativeDetail']['lab_book_master_code'])){
			$lab_book_master_code = $this->request->data['DerivativeDetail']['lab_book_master_code'];
			$sync_with_lab_book = $this->request->data['DerivativeDetail']['sync_with_lab_book'];
			$lab_book = AppModel::getInstance("LabBook", "LabBookMaster", true);
			$lab_book_expected_ctrl_id = $this->ParentToDerivativeSampleControl->getLabBookControlId($parent_sample_control_id,$this->request->data['SampleMaster']['sample_control_id']); 
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
		unset($this->request->data['DerivativeDetail']);
		
		// Set structures and menu
		$ids = array_key_exists('ids', $this->request->data['SampleMaster']) ? $this->request->data['SampleMaster']['ids'] : $this->request->data['sample_master_ids'];
		$this->set('sample_master_ids', $ids);
		unset($this->request->data['sample_master_ids']);

		$unique_aliquot_master_data = null;
		if(is_null($aliquot_master_id)) {
			$this->setBatchMenu(array('SampleMaster' => $ids));
		} else {
			$unique_aliquot_master_data = $this->AliquotMaster->findById($aliquot_master_id);
			if(empty($unique_aliquot_master_data)){
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$this->setAliquotMenu($unique_aliquot_master_data);
		}
		
		$children_control_data = $this->SampleControl->findById($this->request->data['SampleMaster']['sample_control_id']);
		
		$this->Structures->set('view_sample_joined_to_collection', 'sample_info');
		$this->Structures->set(str_replace(",derivative_lab_book", "", $children_control_data['SampleControl']['form_alias']), 'derivative_structure', array('model_table_assoc' => array('SampleDetail' => $children_control_data['SampleControl']['detail_tablename'])));		
		$this->Structures->set(str_replace(",derivative_lab_book", "", $children_control_data['SampleControl']['form_alias']).",sourcealiquots_volume_for_batchderivative", 'derivative_volume_structure');
		$this->Structures->set('used_aliq_in_stock_details', 'sourcealiquots');
		$this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');

		$this->set('children_sample_control_id', $this->request->data['SampleMaster']['sample_control_id']);
		$this->set('created_sample_override_data', array(
			'SampleControl.sample_type'		=> $children_control_data['SampleControl']['sample_type'],
			'SampleControl.sample_category'	=> $children_control_data['SampleControl']['sample_category']
		));
		$this->set('parent_sample_control_id', $parent_sample_control_id);
		
		$this->setUrlToCancel();
		unset($this->request->data['url_to_cancel']);
		
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
		
		if(isset($this->request->data['SampleMaster']['ids'])){
			//1- INITIAL DISPLAY
			if(!empty($this->request->data['AliquotMaster']['ids'])){
				$this->AliquotMaster->unbindModel(array('belongsTo' => array('SampleMaster')));
				$aliquots = $this->AliquotMaster->find('all', array(
					'conditions'	=> array('AliquotMaster.id' => explode(",", $this->request->data['AliquotMaster']['ids'])),
					'fields'		=> array('*'), 
					'recursive'		=> 0,
					'joins'			=> $joins)
				);
				$this->request->data = array();
				foreach($aliquots as $aliquot){
					$this->request->data[] = array('parent' => $aliquot, 'children' => array());
				}
			}else{
				$samples = $this->ViewSample->find('all', array('conditions' => array('ViewSample.sample_master_id' => explode(",", $this->request->data['SampleMaster']['ids'])), 'recursive' => -1));
				$this->request->data = array();
				foreach($samples as $sample){
					$this->request->data[] = array('parent' => $sample, 'children' => array());
				}
			}
						
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		}else{
				
			// 2- VALIDATE PROCESS
			
			unset($this->request->data['SampleMaster']);
			
			$errors = array();
			$prev_data = $this->request->data;
			$this->request->data = array();
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
					foreach($this->AliquotMaster->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][] = $record_counter;
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
								foreach($validation_model->validationErrors as $field => $msgs) {
									$msgs = is_array($msgs)? $msgs : array($msgs);
									foreach($msgs as $msg) $errors[$field][$msg][] = $record_counter;
								}
							}
							$child = $validation_model->data;
						}					
					}
				}
				
				if($lab_book_id != null){
					$lab_book->syncData($children, array("DerivativeDetail"), $lab_book_master_code);
				}
				$this->request->data[] = array('parent' => $parent, 'children' => $children);//prep data in case validation fails
				if(!$new_derivative_created){
					$errors[]['at least one child has to be created'][] = $record_counter;
				}
			}
			$this->SourceAliquot->validationErrors = null;
			$this->AliquotMaster->addWritableField(array('storage_coord_x', 'storage_coord_y', 'current_volume', 'sample_master_id'));
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			// 3- SAVE PROCESS
			
			if(empty($errors)){
				unset($_SESSION['derivative_batch_process']);
				
				//save
				$child_ids = array();
				
				$this->SampleMaster->addWritableField(array('parent_id', 'sample_control_id', 'collection_id', 'initial_specimen_sample_id', 'initial_specimen_sample_type', 'parent_sample_type'));
				$this->SampleMaster->addWritableField(array('sample_master_id'), $children_control_data['SampleControl']['detail_tablename']);
				$this->SampleMaster->addWritableField(array('sample_master_id'), 'derivative_details');				
				$this->DerivativeDetail->addWritableField(array('sync_with_lab_book', 'lab_book_master_id', 'sample_master_id'));
				$this->SourceAliquot->addWritableField(array('sample_master_id', 'aliquot_master_id', 'used_volume'));
				
				foreach($prev_data as $parent_id => &$children){
					unset($children['ViewSample']);
					unset($children['StorageMaster']);
					foreach($children as &$child){
						// save sample master
						$this->SampleMaster->id = null;
						if(!$this->SampleMaster->save($child, false)){ 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						} 							
						$child_id = $this->SampleMaster->getLastInsertId();
						
						// Update sample code
						$query_to_update = "UPDATE sample_masters SET sample_masters.sample_code = sample_masters.id WHERE sample_masters.id = $child_id;";
						try{
							$this->SampleMaster->query($query_to_update); 
							$this->SampleMaster->query(str_replace("sample_masters", "sample_masters_revs", $query_to_update));
						}catch(Exception $e){
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
						}

						// Save derivative detail
						$this->DerivativeDetail->id = $child_id;
						$child['DerivativeDetail']['sample_master_id'] = $child_id;
						if(!$this->DerivativeDetail->save($child, false)){ 
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
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
					$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
					$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
					$batch_set_data = array('BatchSet' => array(
						'datamart_structure_id' => $datamart_structure->getIdByModelName('ViewSample'),
						'flag_tmp' => true
					));
					$batch_set_model->check_writable_fields = false;
					$batch_set_model->saveWithIds($batch_set_data, $child_ids);
					$this->flash('your data has been saved', '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
				} else {
					if(!isset($unique_aliquot_master_data['AliquotMaster'])){
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$this->flash('your data has been saved','/InventoryManagement/SampleMasters/detail/' .$unique_aliquot_master_data['AliquotMaster']['collection_id'] . '/' . $child_ids[0].'/');					
				}
				
			}else{
				$this->SampleMaster->validationErrors = array();				
				$this->SampleDetail->validationErrors = array();				
				$this->DerivativeDetail->validationErrors = array();				
				$this->AliquotMaster->validationErrors = array();				
				$this->SourceAliquot->validationErrors = array();				
				
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->SampleMaster->validationErrors[$field][] = __($msg) . ' - ' . str_replace('%s', implode(",", $lines), __('see # %s'));					
					} 
				}
			}
		}
		
		if(isset($this->request->data[0]['parent']['AliquotMaster']) && empty($this->request->data[0]['parent']['AliquotControl']['volume_unit'])){
			 $this->Structures->set('sourcealiquots', 'sourcealiquots');//overwrite, we do not need the volume
		}
	}
	
	function batchDerivativeFromAliquotsInit(){
		if(!isset($this->request->data['ViewAliquot']['aliquot_master_id'])){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$id = isset($this->request->data['BatchSet']['id']) ? $this->request->data['BatchSet']['id'] : 0;
		$this->set('url_to_cancel', isset($this->request->data['BatchSet'])?'/Datamart/BatchSets/listall/' . $id : '/Datamart/Browser/browse/' . $this->request->data['node']['id']);
		
		$aliquot_ids = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
		if(empty($aliquot_ids)){
			$this->flash(__("batch init no data"), "javascript:history.back();", 5);
		}
		$aliquot_data = $this->AliquotMaster->find('all', array(
			'fields' => array('AliquotMaster.aliquot_control_id', 'AliquotMaster.sample_master_id'),
			'conditions' => array('AliquotMaster.id' => $aliquot_ids)));
		
		if(empty($aliquot_data)){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$ids = array();
		$expected_ctrl_id = $aliquot_data[0]['AliquotMaster']['aliquot_control_id'];
		foreach($aliquot_data as $aliquot_unit){
			if($aliquot_unit['AliquotMaster']['aliquot_control_id'] != $expected_ctrl_id){
				$this->flash(__("you must select elements with a common type"), "javascript:history.back();", 5);
			}
			$ids[] = $aliquot_unit['AliquotMaster']['sample_master_id'];
		}
		$this->request->data = array('SampleMaster' => array('id' => $ids));
		
		$init_data = $this->batchInit(
			$this->SampleMaster,
			'SampleMaster',
			'id',
			"sample_control_id", 
			$this->ParentToDerivativeSampleControl,
			"parent_sample_control_id",
			"you cannot create derivatives for this aliquot type");
		if(array_key_exists('error', $init_data)) {
			$this->flash(__($init_data['error']), "javascript:history.back();", 5);
			return;
		}
		
		foreach($init_data['possibilities'] as $possibility){
			SampleMaster::$derivatives_dropdown[$possibility['DerivativeControl']['id']] = __($possibility['DerivativeControl']['sample_type']);
		}
		
		$this->set('ids', $ids);
		
		$this->Structures->set('derivative_init');
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
		$this->set('parent_sample_control_id', $init_data['control_id']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
}
	
