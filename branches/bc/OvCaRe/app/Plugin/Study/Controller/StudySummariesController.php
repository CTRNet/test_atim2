<?php

class StudySummariesController extends StudyAppController {

	var $uses = array(
		'Study.StudySummary',	
			
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotInternalUse',
		'Order.Order',
		'Order.OrderLine');
	
	var $paginate = array('StudySummary'=>array('limit' => pagination_amount,'order'=>'StudySummary.title'));
	
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
				$this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/search/');
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/Study/StudySummaries/search/');
			}	
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/Study/StudySummaries/detail/'.$study_summary_id);
		}	
  	}
  	
  	function listAllLinkedRecords( $study_summary_id ) {
  		// MANAGE DATA
  		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
  		
  		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		
  		// 1- Aliquots
  		
  		$link_permissions = array('aliquot' => false, 'aliquot use' => false, 'order' => false, 'order line' => false);
  		if($this->checkLinkPermission('/InventoryManagement/AliquotMasters/detail/')) {
			$link_permissions['aliquot'] = true;
			$link_permissions['aliquot use'] = true;
		}
		if($this->checkLinkPermission('/Order/Orders/detail/')) {
			$link_permissions['order'] = true;
			$link_permissions['order line'] = true;
		}
		$this->set('link_permissions', $link_permissions);
 		
  		// CUSTOM CODE: FORMAT DISPLAY DATA
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  	}
  	
  	function listAllLinkedAliquots( $study_summary_id ) {		
  		if(!$this->checkLinkPermission('/InventoryManagement/AliquotMasters/detail/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE ); 
  		
  		if(!$this->request->is('ajax')) {
	 		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
	 		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		}
  		
  		$this->request->data = $this->paginate($this->AliquotMaster, array('AliquotMaster.study_summary_id' => $study_summary_id));		
  		$this->Structures->set('view_aliquot_joined_to_sample_and_collection');
  		
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  	}
  	
 	function listAllLinkedAliquotInternalUses( $study_summary_id ) {
 		if(!$this->checkLinkPermission('/InventoryManagement/AliquotMasters/detail/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );

 		if(!$this->request->is('ajax')) {
	 		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
	 		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		}
  		
  		$this->request->data = $this->paginate($this->AliquotInternalUse, array('AliquotInternalUse.study_summary_id' => $study_summary_id));
  		
 		$this->Structures->set('aliquotinternaluses');
 		
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
 	}
 	
 	function listAllLinkedOrders( $study_summary_id ) {
 		if(!$this->checkLinkPermission('/Order/Orders/detail/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
 		
 		if(!$this->request->is('ajax')) {
	 		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
	 		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		}
  		
  		$this->request->data = $this->paginate($this->Order, array('Order.default_study_summary_id' => $study_summary_id));
 		$this->Structures->set('orders');
  		
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
 	}
 	
 	function listAllLinkedOrderLines( $study_summary_id ) {
 		if(!$this->checkLinkPermission('/Order/Orders/detail/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
 		
 		if(!$this->request->is('ajax')) {
	 		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
	 		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		}
  		
  		$this->request->data = $this->paginate($this->OrderLine, array('OrderLine.study_summary_id' => $study_summary_id));
 		$this->Structures->set('orders,orderlines');
		
 		$hook_link = $this->hook('format');
 		if( $hook_link ) {
 			require($hook_link);
 		}
 	}
 	
}

?>
