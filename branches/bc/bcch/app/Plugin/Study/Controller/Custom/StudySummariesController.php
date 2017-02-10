<?php

/* 
@author Stephen Fung
@since 2015-04-14
Eventum ID: 3214
Displaying consent forms linked to the project
*/

class StudySummariesControllerCustom extends StudySummariesController {
	
	
	var $uses = array(
		'Study.StudySummary',
		'Study.StudyContact',
		'Study.EthicsBoard',
		'Study.Investigator',
		
		'ClinicalAnnotation.MiscIdentifier',
		'ClinicalAnnotation.MiscIdentifierControl',
			
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotInternalUse',
		
		'Order.Order',
		'Order.OrderLine',
		
		'ClinicalAnnotation.ConsentMaster', 
		'ClinicalAnnotation.ConsentDetail');
		
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
	
	/*
	function listAllLinkedRecords( $study_summary_id ) {
		
  		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
  		
  		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
  		
  		$link_permissions = array('aliquot' => false, 'aliquot use' => false, 'order' => false, 'order line' => false, 'consent masters' => false);
		
  		if($this->checkLinkPermission('/InventoryManagement/AliquotMasters/detail/')) {
			$link_permissions['aliquot'] = true;
			$link_permissions['aliquot use'] = true;
		}
		
		if($this->checkLinkPermission('/Order/Orders/detail/')) {
			$link_permissions['order'] = true;
			$link_permissions['order line'] = true;
		}
		
		if($this->checkLinkPermission('/ClinicalAnnotation/ConsentMasters/detail/')) {
			$link_permissions['consent masters'] = true;
		}
		
		$this->set('link_permissions', $link_permissions);
 		
  		// CUSTOM CODE: FORMAT DISPLAY DATA
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  	}*/
	
	/* 
	@author Stephen Fung
	@since 2015-04-14
	@param ID of Study Summary
	Eventum ID: 3214
	Listing all consent forms linked to the project by study summary id
	Everytime a new consent form is added to ATIM, the table will have to be recognized by the function
	*/
	/*
	function listAllLinkedConsentForms( $study_summary_id ) {
		
		if(!$this->checkLinkPermission('/ClinicalAnnotation/ConsentMasters/detail/')) $this->redirect( '/Pages/err_plugin_system_error', NULL, TRUE );
		
		if(!$this->request->is('ajax')) {
	 		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/listAllLinkedRecords/%%StudySummary.id%%/'));
	 		$this->set('atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
  		}
		
		$this->request->data = $this->paginate($this->ConsentMaster, array('ConsentMaster.study_summary_id' => $study_summary_id));
		
 		$this->Structures->set('consent_masters');
		
		$hook_link = $this->hook('format');
 		if( $hook_link ) {
 			require($hook_link);
 		}
	}
	
	*/
	
}


