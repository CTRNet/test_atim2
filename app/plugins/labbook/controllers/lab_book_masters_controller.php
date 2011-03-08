<?php

class LabBookMastersController extends LabBookAppController {

	var $components = array();
	
	var $uses = array(
		'Labbook.LabBookMaster',
		'Labbook.LabBookControl',
		
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.Realiquoting'
	);
	
	var $paginate = array('LabBookMaster' => array('limit' => pagination_amount, 'order' => 'LabBookMaster.created ASC'));
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	 
	function index() {
		// clear SEARCH criteria
		$_SESSION['ctrapp_core']['search'] = null; 
		
		//find all lab book data control types to build add button
		$this->set('lab_book_controls_list', $this->LabBookControl->find('all', array('conditions' => array('LabBookControl.flag_active' => '1'))));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
		
	function search() {
		$this->set('atim_menu', $this->Menus->get('/labbook/lab_book_masters/index/'));
		
		if(!empty($this->data)){
			$_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		}
		
		$this->data = $this->paginate($this->LabBookMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		//find all lab_book data control types to build add button
		$this->set('lab_book_controls_list', $this->LabBookControl->find('all', array('conditions' => array('LabBookControl.flag_active' => '1'))));
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['LabBookMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/labbook/lab_book_masters/search';

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail($lab_book_master_id, $full_detail_screen = true) {		
		if(!$lab_book_master_id) { $this->redirect('/pages/err_lab_book_funct_param_missing?line='.__LINE__, null, true); }
		
		// MAIN FORM
			
		$lab_book = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id)));
		if(empty($lab_book)) { $this->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true); }		
		$this->data = $lab_book;
		
		$this->set('atim_menu', $this->Menus->get('/labbook/lab_book_masters/detail/%%LabBookMaster.id%%'));
		$this->set('atim_menu_variables', array('LabBookMaster.id' => $lab_book_master_id));
			
		$this->Structures->set($lab_book['LabBookControl']['form_alias']);
		
		$this->set('full_detail_screen', $full_detail_screen);
		
		if($full_detail_screen) {
			
			// DERIVATIVES

			$this->SampleMaster->unbindModel(array(
				'hasMany' => array('AliquotMaster'), 
				'hasOne' => array('SpecimenDetail'), 
				'belongsTo' => array('SampleControl')));
			$this->SampleMaster->bindModel(array(
				'belongsTo' => array('GeneratedParentSample' => array(
					'className' => 'Inventorymanagement.SampleMaster',
					'foreignKey' => 'parent_id'))));			
			$derivatives_list = $this->SampleMaster->find('all', array('conditions' => array('DerivativeDetail.lab_book_master_id' => $lab_book_master_id)));		
			$this->set('derivatives_list', $derivatives_list);
			$this->Structures->set('lab_book_derivatives_summary', 'lab_book_derivatives_summary');
			
			// REALIQUOTINGS

			$sample_master_ids = $this->Realiquoting->find('first', array(
				'conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id),
				'fields' => array('GROUP_CONCAT(AliquotMaster.sample_master_id) AS sample_master_ids')));
			$this->SampleMaster->unbindModel(array(
				'hasMany' => array('AliquotMaster'), 
				'hasOne' => array('SpecimenDetail','DerivativeDetail'), 
				'belongsTo' => array('SampleControl')));		
			$sample_master_from_ids = $this->SampleMaster->atim_list(array('conditions' => array('SampleMaster.id' => explode(',', $sample_master_ids[0]['sample_master_ids']))));		
			$realiquotings_list = $this->Realiquoting->find('all', array('conditions' => array('Realiquoting.lab_book_master_id' => $lab_book_master_id)));		
			foreach($realiquotings_list as $key => $realiquoting_data) {
				if(!isset($sample_master_from_ids[$realiquoting_data['AliquotMaster']['sample_master_id']])) $this->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true);
				$realiquotings_list[$key] = array_merge($sample_master_from_ids[$realiquoting_data['AliquotMaster']['sample_master_id']], $realiquoting_data);
			}
			$this->set('realiquotings_list', $realiquotings_list);
			$this->Structures->set('lab_book_realiquotings_summary', 'lab_book_realiquotings_summary');
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}	
	
	function add($control_id, $is_ajax = false) {
		if(!$control_id) { 
			$this->redirect('/pages/err_lab_book_system_error?line='.__LINE__, null, true); 
		}
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		$this->set('is_ajax', $is_ajax);
				
		// MANAGE DATA
		
		$control_data = $this->LabBookControl->find('first', array('conditions' => array('LabBookControl.id' => $control_id)));
		if(empty($control_data)) { 
			$this->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true); 
		}
		
		$initial_data = array();
		$initial_data['LabBookMaster']['lab_book_control_id'] = $control_id;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get(isset($_SESSION['batch_process_data']['lab_book_menu'])? $_SESSION['batch_process_data']['lab_book_menu']: '/labbook/lab_book_masters/index/');		
		$this->set('atim_menu', $atim_menu);
		
		$this->set('atim_menu_variables', array('LabBookControl.id' => $control_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($control_data['LabBookControl']['form_alias']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link); 
		}
			
		if(empty($this->data)){
			$this->data = $initial_data;
			
		}else{
			// Validates and set additional data
			$submitted_data_validates = true;
			
			$this->LabBookMaster->set($this->data);
			if(!$this->LabBookMaster->validates()){
				$submitted_data_validates = false;
			}
		
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){ 
				require($hook_link); 
			}		
						
			if($submitted_data_validates) {
				// Save lab_book data data
				$bool_save_done = true;

				$this->LabBookMaster->id = null;
				if($this->LabBookMaster->save($this->data, false)) {
					$url_to_redirect = '/labbook/lab_book_masters/detail/' . $this->LabBookMaster->id;
					if(isset($_SESSION['batch_process_data']['lab_book_next_step'])) {
						$url_to_redirect = $_SESSION['batch_process_data']['lab_book_next_step'];
					}
					if($is_ajax){
						echo $this->data['LabBookMaster']['code'];
						exit;
					}else{
						$this->atimFlash('your data has been saved', $url_to_redirect);
					}				
				}					
			}
		}		
	}
			
	function edit($lab_book_master_id){
		if(!$lab_book_master_id) { $this->redirect('/pages/err_lab_book_funct_param_missing?line='.__LINE__, null, true); }
		
		// MANAGE DATA

		// Get the lab_book data data
		$lab_book = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id)));
		if(empty($lab_book)) { $this->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$this->set('atim_menu', $this->Menus->get('/labbook/lab_book_masters/detail/%%LabBookMaster.id%%'));
		$this->set('atim_menu_variables', array('LabBookMaster.id' => $lab_book_master_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($lab_book['LabBookControl']['form_alias']);
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
					
		if(empty($this->data)) {
			$this->data = $lab_book;	
			
		} else {
			// Validates and set additional data
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }		
			
			if($submitted_data_validates) {
				$this->LabBookMaster->id = $lab_book_master_id;		
				if($this->LabBookMaster->save($this->data)) { 
					$this->atimFlash('your data has been updated', '/labbook/lab_book_masters/detail/' . $lab_book_master_id); 
				}	
			}
		}
	}
	
	function delete($lab_book_master_id) {
		if(!$lab_book_master_id) { $this->redirect('/pages/err_lab_book_funct_param_missing?line='.__LINE__, null, true); }
		
		$lab_book_data = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id), 'recursive' => '-1'));
		if(empty($lab_book_data)) { $this->redirect('/pages/err_lab_book_no_data?line='.__LINE__, null, true); }		

		// Check deletion is allowed
		$arr_allow_deletion = $this->LabBookMaster->allowLabBookDeletion($lab_book_master_id);

		// CUSTOM CODE
		
		$hook_link = $this->hook();
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {
			if($this->LabBookMaster->atim_delete($lab_book_master_id, true)){
				$this->atimFlash('your data has been deleted', '/labbook/lab_book_masters/index/');
			}else{
				$this->flash('error deleting data - contact administrator', '/labbook/lab_book_masters/index/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/labbook/lab_book_masters/detail/' . $lab_book_master_id);
		}		
	}
		
}
?>