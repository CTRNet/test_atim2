<?php

class CollectionsController extends InventorymanagementAppController {
	
	var $components = array(
		'Inventorymanagement.Collections',
		'Administrate.Administrates', 
		'Sop.Sops');
		
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.ViewCollection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.PathCollectionReview',
		'Inventorymanagement.ReviewMaster',
		
		'Clinicalannotation.ClinicalCollectionLink',
		
		'Administrate.Bank',
		'Sop.SopMaster');
	
	var $paginate = array(
		'Collection' => array('limit' => 10, 'order' => 'Collection.acquisition_label ASC'),
		'ViewCollection' => array('limit' => 10, 'order' => 'ViewCollection.acquisition_label ASC')); 
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
				
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
		
		$this->Structures->set('view_collection');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }			
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		$view_collection = $this->Structures->get('form', 'view_collection');
		$this->set('atim_structure', $view_collection);
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($view_collection);
		
		$this->set('collections_data', $this->paginate($this->ViewCollection, $_SESSION['ctrapp_core']['search']['criteria']));
		$this->data = array();
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ViewCollection']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/collections/search';
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail($collection_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		// MANAGE DATA
		
		$collection_data = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
		$this->data = $collection_data;
		
		// Set participant id
		$this->set('participant_id', $collection_data['ViewCollection']['participant_id']);
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('sop_list', $this->Collections->getCollectionSopList());	
		
		// Get all sample control types to build the add to selected button
		$specimen_sample_controls_list = $this->SampleControl->atim_list(array('conditions' => array('SampleControl.flag_active' => '1', 'SampleControl.sample_category' => 'specimen'), 'order' => 'SampleControl.sample_type ASC'));
		$this->set('specimen_sample_controls_list', $specimen_sample_controls_list);	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
		$this->Structures->set('view_collection');

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add($clinical_collection_link_id = 0) {
		if($clinical_collection_link_id > 0){
			$ccl_data = $this->ClinicalCollectionLink->find('first', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id, 'ClinicalCollectionLink.collection_id' => NULL, 'ClinicalCollectionLink.deleted' => 1), 'recursive' => '1'));
		}
			// MANAGE DATA
		
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('sop_list', $this->Collections->getCollectionSopList());

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if (!empty($this->data)) {
			
			// LAUNCH SAVE PROCESS
			// 1- SET ADDITIONAL DATA	
			
			// 2- LAUNCH SPECIAL VALIDATION PROCESS	
			
			$submitted_data_validates = true;
			
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {

				// 4- SAVE
				
				$collection_id = null;
				if($this->Collection->save($this->data)) {
					$collection_id = $this->Collection->getLastInsertId();
					
					// Create clinical collection link
					if(isset($ccl_data) && !empty($ccl_data)){
						$ccl_data['ClinicalCollectionLink']['deleted'] = 0;
						$ccl_data['ClinicalCollectionLink']['collection_id'] = $collection_id;
						if(!$this->ClinicalCollectionLink->save($ccl_data)) {
							$this->redirect('/pages/err_inv_record_err', null, true); 
						}
					}else if(!$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => array('collection_id' => $collection_id)))) {
						$this->redirect('/pages/err_inv_record_err', null, true); 
					}
					$this->flash('your data has been saved', '/inventorymanagement/collections/detail/' . $collection_id);
				}				
			}
		}

		if(!empty($ccl_data)){
			$this->Structures->set('linked_collections');
			$ccl_data = $this->ClinicalCollectionLink->find('first', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id, 'ClinicalCollectionLink.collection_id' => NULL, 'ClinicalCollectionLink.deleted' => 1), 'recursive' => '1'));
			$this->set('atim_variables', array('ClinicalCollectionLink.id' => $clinical_collection_link_id));
			$this->data['Generated']['field1'] = $ccl_data['Participant']['participant_identifier'];
			$this->data['Collection']['collection_property'] = 'participant collection';
		}else{
			$this->data['Generated']['field1'] = __('n/a', true);
		}
	}
	
	function edit($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }
		
		// MANAGE DATA
		
		$this->Collection->unbindModel(array('hasMany' => array('SampleMaster')));		
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }
				
		// Set list of banks
		$this->set('bank_list', $this->Collections->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('sop_list', $this->Collections->getCollectionSopList());		
		
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
					$this->flash('your data has been updated', '/inventorymanagement/collections/detail/' . $collection_id);
				}
			}
		}
	}
	
	function delete($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_funct_param_missing', null, true); }

		// MANAGE DATA
				
		// Get collection data
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_inv_no_data', null, true); }	
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowCollectionDeletion($collection_id);
		
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			// Delete collection			
			if($this->Collection->atim_delete($collection_id, true)) {
				$this->flash('your data has been deleted', '/inventorymanagement/collections/index/');
			} else {
				$this->flash('error deleting data - contact administrator', '/inventorymanagement/collections/index/');
			}		
		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/inventorymanagement/collections/detail/' . $collection_id);
		}		
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Check if a collection can be deleted.
	 * 
	 * @param $collection_id Id of the studied collection.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowCollectionDeletion($collection_id){
		// Check collection has no sample	
		$returned_nbr = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'sample exists within the deleted collection'); }
		
		// Check collection has no aliquot	
		$returned_nbr = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'aliquot exists within the deleted collection'); }

		// Check collection has not been linked to review	
		$returned_nbr = $this->PathCollectionReview->find('count', array('conditions' => array('PathCollectionReview.collection_id' => $collection_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted collection'); }

		$returned_nbr = $this->ReviewMaster->find('count', array('conditions' => array('ReviewMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'review exists for the deleted collection'); }
		
		// Check Collection has not been linked to a participant, consent or diagnosis
		$criteria = 'ClinicalCollectionLink.collection_id = "' . $collection_id . '" ';
		$criteria .= 'AND ClinicalCollectionLink.participant_id IS NOT NULL';		
		$returned_nbr = $this->ClinicalCollectionLink->find('count', array('conditions' => array($criteria), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'the deleted collection is linked to participant'); }

		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>