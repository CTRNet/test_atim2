<?php

/* 
@author Stephen Fung
@since 2014-04-14
Eventum ID: 3214
Displaying consent forms linked to the project
*/

class StudySummariesControllerCustom extends StudySummariesController {
	
	
	var $uses = array(
		'Study.StudySummary',
		'Study.StudyContact',
		'Study.EthicsBoard',
		'Study.Investigator',
			
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotInternalUse',
		
		'Order.Order',
		'Order.OrderLine',
		
		'ClinicalAnnotation.ConsentMaster', 
		'ClinicalAnnotation.ConsentDetail');
	
	
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
  	}
	
	/* 
	@author Stephen Fung
	@since 2014-04-14
	@param ID of Study Summary
	Listing all consent forms linked to the project by study summary id
	Everytime a new consent form is added to ATIM, the table will have to be recognized by the function
	*/

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
	
}


