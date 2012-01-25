<?php

class LabBookMastersController extends LabBookAppController {

	var $components = array();
	
	var $uses = array(
		'Labbook.LabBookMaster',
		'Labbook.LabBookControl',
		
		'InventoryManagement.SampleMaster',
		'InventoryManagement.Realiquoting',
		'InventoryManagement.DerivativeDetail'
	);
	
	var $paginate = array('LabBookMaster' => array('limit' => pagination_amount, 'order' => 'LabBookMaster.created ASC'));
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	 
	function search($search_id = 0){
		$this->set('atim_menu', $this->Menus->get('/labbook/LabBookMasters/search/'));
		$this->searchHandler($search_id, $this->LabBookMaster, 'labbookmasters', '/labbook/LabBookMasters/search');

		//find all lab_book data control types to build add button
		$this->set('lab_book_controls_list', $this->LabBookControl->find('all', array('conditions' => array('LabBookControl.flag_active' => '1'))));
		
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
	
	function detail($lab_book_master_id, $full_detail_screen = true) {		
		if(!$lab_book_master_id) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		} else if($lab_book_master_id == '-1') {
			$this->flash('no lab book is linked to this record', "javascript:history.back()", 5);
			return;
		}
		
		// MAIN FORM
			
		$lab_book = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id)));
		if(empty($lab_book)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
		$this->request->data = $lab_book;
		
		$this->set('atim_menu', $this->Menus->get('/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'));
		$this->set('atim_menu_variables', array('LabBookMaster.id' => $lab_book_master_id));
			
		$this->Structures->set($lab_book['LabBookControl']['form_alias']);
		
		$this->set('full_detail_screen', $full_detail_screen);
		
		if($full_detail_screen) {
			
			// DERIVATIVES
			$this->set('derivatives_list', $this->LabBookMaster->getLabBookDerivativesList($lab_book_master_id));
			$this->Structures->set('lab_book_derivatives_summary', 'lab_book_derivatives_summary');
			
			// REALIQUOTINGS
			$this->set('realiquotings_list', $this->LabBookMaster->getLabBookRealiquotingsList($lab_book_master_id));
			$this->Structures->set('lab_book_realiquotings_summary', 'lab_book_realiquotings_summary');
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link); 
		}
	}	
	
	function add($control_id, $is_ajax = false) {
		if(!$control_id) { 
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		$this->set('is_ajax', $is_ajax);
				
		// MANAGE DATA
		
		$control_data = $this->LabBookControl->find('first', array('conditions' => array('LabBookControl.id' => $control_id)));
		if(empty($control_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		$this->set('book_type', __($control_data['LabBookControl']['book_type']));
		$initial_data = array();
		$initial_data['LabBookMaster']['lab_book_control_id'] = $control_id;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$atim_menu = $this->Menus->get(isset($_SESSION['batch_process_data']['lab_book_menu'])? $_SESSION['batch_process_data']['lab_book_menu']: '/labbook/LabBookMasters/index/');		
		$this->set('atim_menu', $atim_menu);
		
		$this->set('atim_menu_variables', array('LabBookControl.id' => $control_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($control_data['LabBookControl']['form_alias']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link); 
		}
			
		if(empty($this->request->data)){
			$this->request->data = $initial_data;
			
		}else{
			// Validates and set additional data
			$submitted_data_validates = true;
			
			$this->LabBookMaster->set($this->request->data);
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
				if($this->LabBookMaster->save($this->request->data, false)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					$url_to_redirect = '/labbook/LabBookMasters/detail/' . $this->LabBookMaster->id;
					if(isset($_SESSION['batch_process_data']['lab_book_next_step'])) {
						$url_to_redirect = $_SESSION['batch_process_data']['lab_book_next_step'];
					}
					if($is_ajax){
						echo $this->request->data['LabBookMaster']['code'];
						exit;
					}else{
						$this->atimFlash('your data has been saved', $url_to_redirect);
					}				
				}					
			}
		}		
	}
			
	function edit($lab_book_master_id){
		if(!$lab_book_master_id) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE DATA

		// Get the lab_book data data
		$lab_book = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id)));
		if(empty($lab_book)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// Set menu
		$this->set('atim_menu', $this->Menus->get('/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'));
		$this->set('atim_menu_variables', array('LabBookMaster.id' => $lab_book_master_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($lab_book['LabBookControl']['form_alias']);
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
					
		if(empty($this->request->data)) {
			$this->request->data = $lab_book;	
			
		}else{
			// Validates and set additional data
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}		
			
			if($submitted_data_validates) {
				$this->LabBookMaster->id = $lab_book_master_id;		
				if($this->LabBookMaster->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					} 
					$this->LabBookMaster->synchLabbookRecords($lab_book_master_id, $this->request->data['LabBookDetail']);
					$this->atimFlash('your data has been updated', '/labbook/LabBookMasters/detail/' . $lab_book_master_id); 
				}	
			}
		}
	}

	function editSynchOptions($lab_book_master_id){
		if(!$lab_book_master_id) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		// MANAGE DATA

		// Get the lab_book data data
		$lab_book = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id)));
		if(empty($lab_book)) {
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		$this->Structures->set('lab_book_derivatives_summary', 'lab_book_derivatives_summary');
		$this->Structures->set('lab_book_realiquotings_summary', 'lab_book_realiquotings_summary');
		
		$this->set('atim_menu', $this->Menus->get('/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'));
		$this->set('atim_menu_variables', array('LabBookMaster.id' => $lab_book_master_id));
		
		// set structure alias based on VALUE from CONTROL table
		$this->Structures->set($lab_book['LabBookControl']['form_alias']);
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
					
		if(empty($this->request->data)) {
			$this->request->data = array(
				'derivative' => $this->LabBookMaster->getLabBookDerivativesList($lab_book_master_id),
				'realiquoting' => $this->LabBookMaster->getLabBookRealiquotingsList($lab_book_master_id));	
			
		} else {
			
			// Validates and set additional data
			$submitted_data_validates = true;

			if(isset($this->request->data['derivative'])) {
				foreach($this->request->data['derivative'] as $new_record) {
					$this->DerivativeDetail->set($new_record);
					if(!$this->DerivativeDetail->validates()) $submitted_data_validates = false;
				}
			}
			
			if(isset($this->request->data['realiquoting'])) {
				foreach($this->request->data['realiquoting'] as $new_record) {
					$this->Realiquoting->set($new_record);
					if(!$this->Realiquoting->validates()) $submitted_data_validates = false;
				}
			}
						
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link); 
			}		
			
			if($submitted_data_validates) {
				if(isset($this->request->data['derivative'])) {
					$hook_link_derivative = $this->hook('postsave_process_derivative');
					foreach($this->request->data['derivative'] as $new_record) {
						$this->DerivativeDetail->id = $new_record['DerivativeDetail']['id'];
						if(!$this->DerivativeDetail->save(array('DerivativeDetail' => $new_record['DerivativeDetail']), false)){
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						}
						if( $hook_link_derivative ) { 
							require($hook_link_derivative); 
						}				
					}
				}
				
				if(isset($this->request->data['realiquoting'])) {
					$hook_link_realiquoting = $this->hook('postsave_process_realiquoting');
					foreach($this->request->data['realiquoting'] as $new_record) {
						$this->Realiquoting->id = $new_record['Realiquoting']['id'];
						if(!$this->Realiquoting->save(array('Realiquoting' => $new_record['Realiquoting']), false)){
							$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
						}
						if( $hook_link_realiquoting ) { 
							require($hook_link_realiquoting); 
						}
					}
				}

				$this->LabBookMaster->synchLabbookRecords($lab_book_master_id, $lab_book['LabBookDetail']);
				
				$this->atimFlash('your data has been updated', '/labbook/LabBookMasters/detail/' . $lab_book_master_id); 	
			}
		}
	}
		
	function delete($lab_book_master_id) {
		if(!$lab_book_master_id) { 
			$this->redirect('/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
		
		$lab_book_data = $this->LabBookMaster->find('first', array('conditions' => array('LabBookMaster.id' => $lab_book_master_id), 'recursive' => '-1'));
		if(empty($lab_book_data)) { 
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		

		// Check deletion is allowed
		$arr_allow_deletion = $this->LabBookMaster->allowLabBookDeletion($lab_book_master_id);

		// CUSTOM CODE
		
		$hook_link = $this->hook();
		if( $hook_link ) { 
			require($hook_link); 
		}		
				
		if($arr_allow_deletion['allow_deletion']) {
			if($this->LabBookMaster->atimDelete($lab_book_master_id, true)){
				$this->atimFlash('your data has been deleted', '/labbook/LabBookMasters/index/');
			}else{
				$this->flash('error deleting data - contact administrator', '/labbook/LabBookMasters/index/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/labbook/LabBookMasters/detail/' . $lab_book_master_id);
		}		
	}
	
	function autocomplete(){
		//layout = ajax to avoid printing layout
		$this->layout = 'ajax';
		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
		$this->set('result', $this->LabBookMaster->find('list', 
				array(
					'fields'		=> array('LabBookMaster.code'), 
					'conditions'	=> array('LabBookMaster.code LIKE ' => $term.'%'),
					'limit'			=> 10))
		);
	}
		
}
?>