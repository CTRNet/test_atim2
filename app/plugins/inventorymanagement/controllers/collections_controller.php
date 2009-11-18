<?php

class CollectionsController extends InventorymanagementAppController {
	
	var $uses = array(
		'Inventorymanagement.Collection',
		'Inventorymanagement.SampleMaster',
		'Inventorymanagement.AliquotMaster',
		'Inventorymanagement.PathCollectionReview',
		'Inventorymanagement.ReviewMaster',
		
		'Clinicalannotation.ClinicalCollectionLink');
	
	var $paginate = array('Collection' => array('limit' => 10, 'order' => 'Collection.acquisition_label ASC')); 
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	function index() {
		// MANAGE (FIRST) FORM TO DEFINE SEARCH TYPE 

		// Set structure 				
		$this->set('atim_structure_for_search_type', $this->Structures->get('form', 'collection_search_type'));
		
		// MANAGE INDEX FORM
		
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		$this->unsetInventorySessionData();
				
		// Set list of banks
		$this->set('banks', $this->getBankList());		
	}
	
	function search() {
		// MANAGE (FIRST) FORM TO DEFINE SEARCH TYPE 

		// Set structure 				
		$this->set('atim_structure_for_search_type', $this->Structures->get('form', 'collection_search_type'));
		
		// MANAGE INDEX FORM
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->hook();
		
		$this->data = $this->paginate($this->Collection, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Collection']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/collections/search';
		
		// Set list of banks
		$this->set('banks', $this->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->getCollectionSopList());
	}
	
	function detail($collection_id, $is_tree_view_detail_form = false, $is_inventory_plugin_form = true) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', null, true); }
		
		// MANAGE DATA

		$this->hook();
		
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', null, true); }
		$this->data = $collection_data;
		
		// Calulate spent time between collection and reception
		$arr_spent_time = $this->getSpentTime($this->data['Collection']['collection_datetime'], $this->data['Collection']['reception_datetime']);
		$this->set('col_to_rec_spent_time', $arr_spent_time);	
				
		// Set list of banks
		$this->set('banks', $this->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->getCollectionSopList());		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));

		// Define if this detail form is displayed into the collection content tree view
		$this->set('is_tree_view_detail_form', $is_tree_view_detail_form);
		$this->set('is_inventory_plugin_form', $is_inventory_plugin_form);
	}
	
	function add() {
		// MANAGE DATA
		
		// Set list of banks
		$this->set('banks', $this->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->getCollectionSopList());

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		// MANAGE DATA RECORD
		
		$this->hook();
		
		if (!empty($this->data)) {
			// Save collection
			$collection_id = null;
			if($this->Collection->save($this->data)) {
				$collection_id = $this->Collection->getLastInsertId();
				
				// Create clinical collection link
				if(!$this->ClinicalCollectionLink->save(array('ClinicalCollectionLink' => array('collection_id' => $collection_id)))) { $this->redirect('/pages/err_inv_coll_record_err', null, true); }
				
				$this->flash('Your data has been saved . ', '/inventorymanagement/collections/detail/' . $collection_id);
			}
		}
	}
	
	function edit($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', null, true); }
		
		// MANAGE DATA
		
		$this->Collection->unbindModel(array('hasMany' => array('SampleMaster')));		
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', null, true); }
				
		// Set list of banks
		$this->set('banks', $this->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->getCollectionSopList());		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));		
		
		if(!empty($collection_data['ClinicalCollectionLink']['participant_id'])) {
			// Linked collection: Set specific structure
			$this->set('atim_structure', $this->Structures->get('form', 'linked_collections'));
		}

		// MANAGE DATA RECORD

		$this->hook();
		
		if(empty($this->data)) {
				$this->data = $collection_data;	
		} else {
			//Update data
			$this->Collection->id = $collection_id;
			if ($this->Collection->save($this->data)) {
				$this->flash('Your data has been updated . ', '/inventorymanagement/collections/detail/' . $collection_id);
			}
		}
	}
	
	function delete($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', null, true); }
		
		// Get collection data
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_inv_coll_no_data', null, true); }	
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowCollectionDeletion($collection_id);
		
		if($arr_allow_deletion['allow_deletion']) {
			$this->hook();
			
			// Delete collection			
			if($this->ClinicalCollectionLink->atim_delete($collection_data['ClinicalCollectionLink']['id']) && $this->Collection->atim_delete($collection_id)) {
				$this->flash('Your data has been deleted . ', '/inventorymanagement/collections/index/');
			} else {
				$this->flash('Error deleting data - Contact administrator . ', '/inventorymanagement/collections/index/');
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
		$criteria .= 'AND (ClinicalCollectionLink.participant_id != NULL ';
		$criteria .= 'OR ClinicalCollectionLink.diagnosis_master_id != NULL ';
		$criteria .= 'OR ClinicalCollectionLink.consent_master_id != NULL)';		
		$returned_nbr = $this->ClinicalCollectionLink->find('count', array('conditions' => array($criteria), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'the deleted collection is linked to participant'); }

		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Get list of SOPs existing to build collection.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getCollectionSopList() {
		return $this->getSopList('collection');
	}

}

?>