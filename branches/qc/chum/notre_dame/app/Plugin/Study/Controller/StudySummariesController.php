<?php

class StudySummariesController extends StudyAppController {

	var $uses = array(
		'Study.StudySummary',	

		'ClinicalAnnotation.MiscIdentifier',
		'ClinicalAnnotation.MiscIdentifierControl',
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotInternalUse',
		'Order.Order',
		'Order.OrderLine');
	
	var $paginate = array(
		'StudySummary'=>array('limit' => 5, 'order'=>'StudySummary.title'),
		'Participant'=>array('limit' => 5, 'order'=>'Participant.last_name ASC, Participant.first_name ASC'),
		'MiscIdentifier'=>array('limit' => 5, 'order'=>'MiscIdentifier.study_summary_id ASC,MiscIdentifierControl.misc_identifier_name ASC'),
		'ConsentMaster'=>array('limit' => 5, 'order'=>'ConsentMaster.date_first_contact ASC'),
		'AliquotMaster'=>array('limit' => 5, 'order'=>'AliquotMaster.barcode ASC'),
		'Order'=>array('limit' => 5, 'order'=>'Order.date_order_placed DESC'), 
		'OrderLine'=>array('limit' => 5, 'order'=>'OrderLine.date_required DESC'),
		'TmaSlide' => array('limit' => 5, 'order' => 'TmaSlide.barcode DESC')
	);
	
	function search($search_id = ''){
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		$this->searchHandler($search_id, $this->StudySummary, 'studysummaries', '/Study/StudySummaries/search');
		
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

	function detail( $study_summary_id ) {
		// MANAGE DATA
		$this->request->data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		$this->Structures->set('empty', 'empty_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add() {
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/search'));
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	
		if ( !empty($this->request->data) ) {
			$submitted_data_validates = true;
			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}				
		
			if($submitted_data_validates) {
				if ( $this->StudySummary->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been saved'),'/Study/StudySummaries/detail/'.$this->StudySummary->id );
				}
			}
		}
  	}
  
	function edit( $study_summary_id ) {
		// MANAGE DATA
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}	
				
		if(empty($this->request->data)) {
			$this->request->data = $study_summary_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {	
				$this->StudySummary->id = $study_summary_id;
				if ( $this->StudySummary->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been updated'),'/Study/StudySummaries/detail/'.$study_summary_id );
				}		
			}
		}
  	}
	
	function delete( $study_summary_id ){
		// MANAGE DATA
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		$arr_allow_deletion = $this->StudySummary->allowDeletion($study_summary_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}	
		
		if($arr_allow_deletion['allow_deletion']) {
			// DELETE DATA
			if( $this->StudySummary->atimDelete( $study_summary_id ) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/search/');
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/Study/StudySummaries/search/');
			}	
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/Study/StudySummaries/detail/'.$study_summary_id);
		}	
  	}
  	
  	function listAllLinkedRecords( $study_summary_id, $specific_list_header = null ) {
  		if(!$this->request->is('ajax')) {
  			$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
  			$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		}
  		
  		//$linked_records_properties: Keep value to null or false if custom paginate has to be done
  		$linked_records_properties = array(
  			'participants' => array(
  				'ClinicalAnnotation.MiscIdentifier.study_summary_id', 
  				'/ClinicalAnnotation/MiscIdentifiers/listall/', 
  				'miscidentifiers_for_participant_search',
  				'/ClinicalAnnotation/Participants/profile/%%Participant.id%%'),
  			'consents' => array(
  				'ClinicalAnnotation.ConsentMaster.study_summary_id', 
  				'/ClinicalAnnotation/ConsentMasters/listall/', 
  				'consent_masters,consent_masters_study',
  				'/ClinicalAnnotation/ConsentMasters/detail/%%ConsentMaster.participant_id%%/%%ConsentMaster.id%%'),
  			'aliquots' => array(
  				'InventoryManagement.AliquotMaster.study_summary_id', 
  				'/InventoryManagement/AliquotMasters/detail/', 
  				'view_aliquot_joined_to_sample_and_collection',
  				'/InventoryManagement/AliquotMasters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%'),
  			'aliquot uses' => array(
  				'InventoryManagement.AliquotInternalUse.study_summary_id', 
  				'/InventoryManagement/AliquotMasters/detail/', 
  				'aliquotinternaluses',
  				'/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%'),
  			'orders' => array(
  				'Order.Order.default_study_summary_id', 
  				'/Order/Orders/detail/', 
  				'orders',
  				'/Order/Orders/detail/%%Order.id%%'),
  			'order lines' => array(
  				'Order.OrderLine.study_summary_id', 
  				'/Order/Orders/detail/', 
  				'orders,orderlines',
  				'/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%'),
  			'tma slides' => array(
  				'StorageLayout.TmaSlide.study_summary_id', 
  				'/StorageLayout/TmaSlides/detail/', 
  				'tma_slides,tma_blocks_for_slide_creation',
  				'/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%'),
  			'tma slide uses' => array(
  				'StorageLayout.TmaSlideUse.study_summary_id', 
  				'/StorageLayout/TmaSlideUses/listAll/', 
  				'tma_slide_uses,tma_slides_for_use_creation',
  				'/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%'));
  		
  		$hook_link = $this->hook('format_properties');
  		if( $hook_link ) {
  			require($hook_link);
  		}		
  		
 		if(!$specific_list_header) {
 			
  			// Manage All Lists Display
  			$this->set('linked_records_headers', array_keys($linked_records_properties));
  			
  		} else {
  			
  			// Manage Display Of A Specific List
  			if(!array_key_exists($specific_list_header, $linked_records_properties)) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
			if($linked_records_properties[$specific_list_header]) {
				list($plugin_model_foreign_key, $permission_link, $structure_alias, $details_url) = $linked_records_properties[$specific_list_header];		
				list($plugin, $model, $foreign_key) = explode('.',$plugin_model_foreign_key);
				if(!isset($this->{$model})) {
					$this->{$model} = AppModel::getInstance($plugin, $model, true);
				}
				$this->request->data = $this->paginate($this->{$model}, array("$model.$foreign_key" => $study_summary_id));
				$this->Structures->set($structure_alias);
				$this->set('details_url', $details_url);
				$this->set('permission_link', $permission_link);
  			} else {
  				//Manage custom display
  				$hook_link = $this->hook('format_custom_list_display');
  				if( $hook_link ) {
  					require($hook_link);
  				}
  			}
  			  				
  		}
  			
  		// CUSTOM CODE: FORMAT DISPLAY DATA
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  	}
  	
  	function autocompleteStudy() {
  		
  		//-- NOTE ----------------------------------------------------------
		//
		// This function is linked to functions of the StorageMaster model 
		// called getStudyIdFromStudyDataAndCode() and
		// getStudyDataAndCodeForDisplay().
		//
		// When you override the autocompleteStudy() function, check 
		// if you need to override these functions.
		//  
		//------------------------------------------------------------------
		
		//layout = ajax to avoid printing layout
  		$this->layout = 'ajax';
  		//debug = 0 to avoid printing debug queries that would break the javascript array
		Configure::write('debug', 0);
  		
  		//query the database
  		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
  		$terms = array();
  		foreach(explode(' ', $term) as $key_word) $terms[] = "StudySummary.title LIKE '%".$key_word."%'";
  		
  		$conditions = array('AND' => $terms);  		
  		$fields = 'StudySummary.*';
  		$order = 'StudySummary.title ASC';
  		$joins = array();
		
  		$hook_link = $this->hook('query_args');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  		
  		$data = $this->StudySummary->find('all', array(
 			'conditions' => $conditions,
 			'fields' => $fields,
  			'order' => $order,
  			'joins' => $joins,
  			'limit' => 10));
		
  		//build javascript textual array
  		$result = "";
  		foreach($data as $data_unit){
  			$result .= '"'.$this->StudySummary->getStudyDataAndCodeForDisplay($data_unit).'", ';
  		}
  		if(sizeof($result) > 0){
  			$result = substr($result, 0, -2);
  		}
		
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  		
  		$this->set('result', "[".$result."]");  		
  	}
 	
}

?>
