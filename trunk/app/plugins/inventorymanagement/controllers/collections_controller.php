<?php

class CollectionsController extends InventorymanagementAppController {

	var $components = array('Administrate.Administrates', 'Sop.Sops');
	
	var $uses = array(
		'InventoryManagement.Collection',
		'InventoryManagement.SampleMaster',
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.PathCollectionReview',
		'InventoryManagement.ReviewMaster',
		
		'ClinicalAnnotation.ClinicalCollectionLink',
		
		'Administrates.Bank');
		
	var $paginate = array('Collection' => array('limit' => 10,'order' => 'Collection.acquisition_label ASC')); 

	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	 	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// Set list of banks
		$this->set('banks', $this->Administrates->getBankList());
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));
		
		if ($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Collection, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Collection']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/collections/search';
		
		// Set list of banks
		$this->set('banks', $this->Administrates->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->Sops->getSopList());
	}

	function detail($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', NULL, TRUE); }
		
		// MANAGE DATA

		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }
		$this->data = $collection_data;
		
		// Calulate spent time between collection and reception
		$arr_spent_time = $this->getSpentTime($this->data['Collection']['collection_datetime'], $this->data['Collection']['reception_datetime']);
		$this->set('col_to_rec_spent_time', $arr_spent_time);	
				
		// Set list of banks
		$this->set('banks', $this->Administrates->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->Sops->getSopList());		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));
	}
	
	function add() {
		// MANAGE DATA
		
		// Set list of banks
		$this->set('banks', $this->Administrates->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->Sops->getSopList());

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/inventorymanagement/collections/index'));

		// MANAGE DATA RECORD
				
		if (!empty($this->data)) {
			if ($this->Collection->save($this->data)) {
				$collection_id = $this->Collection->getLastInsertId();
				$this->flash('Your data has been saved.', '/inventorymanagement/collections/detail/' . $collection_id);
			}
		}
	}
	
	function edit($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', NULL, TRUE); }
		
		// MANAGE DATA

		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }
		
		// Set list of banks
		$this->set('banks', $this->Administrates->getBankList());
		
		// Set list of available SOPs to build collections
		$this->set('arr_collection_sops', $this->Sops->getSopList());		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu_variables', array('Collection.id' => $collection_id));		

		// MANAGE DATA RECORD

		if(empty($this->data)) {
				$this->data = $collection_data;	
		} else {
			//Update data
			$this->Collection->id = $collection_id;
			if ($this->Collection->save($this->data)) {
				$this->flash('Your data has been updated.', '/inventorymanagement/collections/detail/' . $collection_id);
			}
		}
	}
	
	function delete($collection_id) {
		if(!$collection_id) { $this->redirect('/pages/err_inv_coll_no_id', NULL, TRUE); }
		
		// Get collection data
		$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
		if(empty($collection_data)) { $this->redirect('/pages/err_sto_no_stor_data', NULL, TRUE); }	

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowCollectionDeletion($collection_id);
		
		if($arr_allow_deletion['allow_deletion']) {
			// Delete collection
			if($this->Collection->atim_delete($collection_id)) {
				$this->flash('Your data has been deleted.', '/inventorymanagement/collections/index/');
			} else {
				$this->flash('Error deleting data - Contact administrator.', '/inventorymanagement/collections/index/');
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
	 * 	['allow_deletion'] = TRUE/FALSE
	 * 	['msg'] = message to display when previous field equals FALSE
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowCollectionDeletion($collection_id){
		// Check collection has no sample	
		$returned_nbr = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => FALSE, 'msg' => 'sample exists within the deleted collection'); }
		
		// Check collection has no aliquot	
		$returned_nbr = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collection_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => FALSE, 'msg' => 'aliquot exists within the deleted collection'); }

		// Check collection has not been linked to review	
		$returned_nbr = $this->PathCollectionReview->find('count', array('conditions' => array('PathCollectionReview.collection_id' => $collection_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => FALSE, 'msg' => 'review exists for the deleted collection'); }

		$returned_nbr = $this->ReviewMaster->find('count', array('conditions' => array('ReviewMaster.collection_id' => $collection_id)));
		if($returned_nbr > 0) { return array('allow_deletion' => FALSE, 'msg' => 'review exists for the deleted collection'); }
		
		// Check Collection has not been linked to a participant, consent or diagnosis
		$criteria = 'ClinicalCollectionLink.collection_id = "'.$collection_id.'" ';
		$criteria .= 'AND (ClinicalCollectionLink.participant_id != 0 ';
		$criteria .= 'OR ClinicalCollectionLink.diagnosis_id != 0 ';
		$criteria .= 'OR ClinicalCollectionLink.consent_id != 0)';		
		$returned_nbr = $this->ClinicalCollectionLink->find('count', array('conditions' => array($criteria)));
		if($returned_nbr > 0) { return array('allow_deletion' => FALSE, 'msg' => 'the deleted collection is linked to participant'); }

		return array('allow_deletion' => TRUE, 'msg' => '');
	}

}

?>