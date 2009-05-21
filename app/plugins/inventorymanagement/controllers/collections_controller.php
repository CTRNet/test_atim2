<?php

class CollectionsController extends InventoryManagementAppController {
	
	var $name = 'Collections';
	
	var $uses 
		= array('AliquotMaster',
			'ClinicalCollectionLink',
			'Collection',
			'PathCollectionReview',
			'ReviewMaster',
			'SampleMaster',
			'SopMaster');
	
	var $useDbConfig = 'default';
	
	var $components = array('Summaries');
	
	var $helpers = array('Summaries');
	
	function beforeFilter() {
		
		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility 
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();
		
		// CakePHP function to re-combine dat/time select fields 
		$this->cleanUpFields();
		
	}
	
	function index() {
		
		// clear SEARCH criteria, for pagination bug 
		$_SESSION['ctrapp_core']['inventory_management']['search_criteria'] = NULL;
		$_SESSION['ctrapp_core']['inventory_management']['sample_search_criteria'] = NULL;
		$_SESSION['ctrapp_core']['inventory_management']['aliquot_search_criteria'] = NULL; 		 

		// set MENU variable for echo on VIEW
		$this->set('ctrapp_menu', array());
		
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build());
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// set FORM variable, for HELPER call on VIEW 
		
		// 1- Create Collection Search Form		
		$this->set('ctrapp_form', $this->Forms->getFormArray('collections'));
		
		// 2- Create Sample Search Form
		$this->set('ctrapp_form_sample', $this->Forms->getFormArray('sample_masters'));
		
		// 3- Create Aliquot Search Form
		$this->set('ctrapp_form_aliquot', $this->Forms->getFormArray('aliquot_masters'));
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
	}
	
	function search() {
		
		// set MENU variable for echo on VIEW 
		$this->set('ctrapp_menu', array());
		
		// set FORM variable, for HELPER call on VIEW 
		$ctrapp_form = $this->Forms->getFormArray('collections');
		$this->set('ctrapp_form', $ctrapp_form);
		
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build());
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
		
		// if SEARCH form data, parse and create conditions 
		if ($this->data) {
			$criteria = $this->Forms->getSearchConditions($this->data, $ctrapp_form);	
			// save CRITERIA to session for pagination 
			$_SESSION['ctrapp_core']['inventory_management']['search_criteria'] = $criteria; 
		} else {
			// if no form data, use SESSION critera for PAGINATION bug 
			$criteria = $_SESSION['ctrapp_core']['inventory_management']['search_criteria']; 
		}

		// look for Collections
		$pagination_order = 'acquisition_label ASC';
		
		list($order, $limit, $page) = $this->Pagination->init($criteria);
		$collections_data = $this->Collection->findAll($criteria, NULL, $pagination_order, $limit, $page, 0);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		$this->set('collections', $collections_data);
		
	}
	
	function detail($collection_id=null) {
		
		// Verify Collection ID has been set
		if(empty($collection_id)) {
			$this->redirect('/pages/err_inv_coll_no_id'); 
			exit;
		}

		// set MENU variable for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_11', $collection_id);
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('collections'));
		
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// set DATA for echo on VIEW 
		$this->set('arr_sop_title_from_id', $this->getInventoryProductSopsArray('collection'));
		
		// set COLLECTION data
		$this->Collection->id = $collection_id;
		$collection_data = $this->Collection->read();
		
		if(empty($collection_data)) {
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
				
		// Calulate spent time between collection and reception
		$arr_spent_time = 
			$this->getSpentTime($collection_data['Collection']['collection_datetime'],
								$collection_data['Collection']['reception_datetime']);
								
		$this->set('coll_to_rec_spent_time_msg', $arr_spent_time['message']);
		$collection_data['Calculated']['coll_to_rec_spent_time_days'] = $arr_spent_time['days'];
		$collection_data['Calculated']['coll_to_rec_spent_time_hours'] = $arr_spent_time['hours'];
		$collection_data['Calculated']['coll_to_rec_spent_time_minutes'] = $arr_spent_time['minutes'];
			
		// Define if the collection can be deleted
		$bool_allow_deletion = $this->allowCollectionDeletion($collection_id);
		$this->set('bool_allow_deletion', $bool_allow_deletion);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		$this->set('data', $collection_data);
		
	}
	
	function add() {
		
		// set MENU variable for echo on VIEW 
		$this->set('ctrapp_menu', array());
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray('collections'));		
		
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build());
  		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// set DATA for echo on VIEW 
		$this->set('arr_sop_title_from_id', $this->getInventoryProductSopsArray('collection'));
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (!empty($this->data)) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray('collections') as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->Collection->validates($this->data)) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				// set a FLAG
				$bool_save_error = FALSE;
				
				if ($this->Collection->save($this->data)) {
				
					// Record ClinicalCollectionLink
					$collection_data = $this->data['Collection'];
					$clinical_collection_link_data = array();
					
					$clinical_collection_link_data['ClinicalCollectionLink']['created'] 
						= isset($collection_data['created'])? $collection_data['created']: NULL;
					$clinical_collection_link_data['ClinicalCollectionLink']['created_by'] 
						= isset($collection_data['created_by'])? $collection_data['created_by']: '';
					$clinical_collection_link_data['ClinicalCollectionLink']['modified'] 
						= isset($collection_data['modified'])? $collection_data['modified']: NULL;
					$clinical_collection_link_data['ClinicalCollectionLink']['modified_by'] 
						= isset($collection_data['modified_by'])? $collection_data['modified_by']: '';
					
					// set Collection ID  field in Link_Collection based on COLLECTION
					$new_collection_id = $this->Collection->getLastInsertId();
					$clinical_collection_link_data['ClinicalCollectionLink']['collection_id'] = $new_collection_id;
					
					// start new instance of ClinicalCollectionLink model
					$table_name = 'clinical_collection_links';
					$this->ClinicalCollectionLink = new ClinicalCollectionLink(false, $table_name);
					
					// save ClinicalCollectionLink data 
					if ($this->ClinicalCollectionLink->save($clinical_collection_link_data)) {
						$this->flash('Your data has been saved.', '/collections/detail/'.$new_collection_id);
					} else {
						$bool_save_error = TRUE;
					}
					
				} else {
					$bool_save_error = TRUE;
				}
				
				if($bool_save_error) {
					$this->redirect('/pages/err_inv_coll_record_err'); 
					exit;
				}
				
			}
			
		}
		
	}
	
	function edit($collection_id=null) {
			
		// ** Get the collection id **
		if(isset($this->data['Collection']['id'])) {
			//User clicked on the Submit button to modify the edited collection
			$collection_id = $this->data['Collection']['id'];
		}
		
		if (empty($collection_id)) {
			$this->redirect('/pages/err_inv_coll_no_id'); 
			exit;
		}
		
		// ** Load  Collection data **
		$this->Collection->id = $collection_id;
		$collection_data = $this->Collection->read();
		
		if(empty($collection_data)){
			$this->redirect('/pages/err_inv_coll_no_data');
			exit;
		}
		
		// Define if the form alias to use
		$criteria = 'ClinicalCollectionLink.collection_id = "'.$collection_id.'" ';		
		$clinical_collection_link_data = $this->ClinicalCollectionLink->findAll($criteria);
		
		if(sizeof($clinical_collection_link_data) != 1) {
			$this->redirect('/pages/err_inv_coll_part_link_err');
			exit;
		}
		
		$form_alias_to_use = 'collections';
		if($clinical_collection_link_data[0]['ClinicalCollectionLink']['participant_id'] != 0) {
			// collection is already linked to a participant: its property can not be modified
			$form_alias_to_use = 'linked_collections';			
		}
		
		// set MENU variable for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs('inv_CAN_00', 'inv_CAN_11', $collection_id); // inventorymanagement,  inventorymanagement/collections/detail
		$this->set('ctrapp_menu', $ctrapp_menu);
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set('ctrapp_form', $this->Forms->getFormArray($form_alias_to_use));	
		
		// set SUMMARY variable from plugin's COMPONENTS 
		$this->set('ctrapp_summary', $this->Summaries->build($collection_id));
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set('ctrapp_sidebar', 
			$this->Sidebars->getColsArray(
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action']));
				
		// set DATA for echo on VIEW 
		$this->set('arr_sop_title_from_id', $this->getInventoryProductSopsArray('collection'));

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if (empty($this->data)) {
			
			// set collection data to display
			$this->data = $collection_data;
			$this->set('data', $this->data);
			
		} else {
			
			// start collection modification update
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ($this->Forms->getValidateArray($form_alias_to_use) as $validate_model=>$validate_rules) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if (!$this->Collection->validates($this->data['Collection'])) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_validation.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
			
			// if data VALIDATE, then save data
			if ($submitted_data_validates) {
				
				if ($this->Collection->save($this->data['Collection'])) {
					$this->flash('Your data has been updated.', '/collections/detail/'.$collection_id);
				} else {
					$this->redirect('/pages/err_inv_coll_record_err'); 
					exit;
				}			
				
			}
						
		}
		
	}
	
	function delete($collection_id = null) {
		
		// Verify Collection ID has been set
		if(empty($collection_id)) {
			$this->redirect('/pages/err_inv_coll_no_id'); 
			exit;
		}
		
		// Verify Collection exists
		$this->Collection->id = $collection_id;
		$collection_master_data = $this->Collection->read();
		
		if(empty($collection_master_data)){
			$this->redirect('/pages/err_inv_coll_no_data'); 
			exit;
		}
		
		// Verify a clinical collection link record exists and get the id
		$criteria = 'ClinicalCollectionLink.collection_id = "'.$collection_id.'" ';		
		$clinical_collection_link_data = $this->ClinicalCollectionLink->findAll($criteria);
		
		if(sizeof($clinical_collection_link_data) != 1) {
			$this->redirect('/pages/err_inv_coll_part_link_err');
			exit;
		}
		
		$clinical_collection_id = $clinical_collection_link_data[0]['ClinicalCollectionLink']['id'];
		
		// Verify collection can be deleted
		if(!$this->allowCollectionDeletion($collection_id)){
			$this->redirect('/pages/err_inv_coll_del_forbid');
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// Delete collection
		
		// set flag
		$bool_delete_collection = TRUE;
		
		if(!$this->Collection->del($collection_id)) {
			$bool_delete_collection = FALSE;
		}
		
		if($bool_delete_collection) {
			// Delete Clinical_Collction_links record 
			// where collection_id is the same as previous id deleted
			if(!$this->ClinicalCollectionLink->del($clinical_collection_id)) {
				$bool_delete_collection = FALSE;
			}
		}
		
		if(!$bool_delete_collection){
			$this->redirect('/pages/err_inv_coll_del_err');
			exit;
		}
		
		$this->flash('Your data has been deleted.', '/collections');
		
	}
	
	/**
	 * Define if a collection can be deleted.
	 * 
	 * @param $collection_id Id of the studied collection.
	 * 
	 * @return Return TRUE if the collection can be deleted.
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowCollectionDeletion($collection_id){
		
		// Verify this collection has no sample	
		$criteria = 'SampleMaster.collection_id ="' .$collection_id.'"';			 
		$collection_sample_nbr = $this->SampleMaster->findCount($criteria);
		
		if($collection_sample_nbr > 0){
			return FALSE;
		}
		
		// Verify this collection has no aliquot
		$criteria = 'AliquotMaster.collection_id ="' .$collection_id.'"';		 
		$collection_aliquot_nbr = $this->AliquotMaster->findCount($criteria);
		
		if($collection_aliquot_nbr > 0){
			return FALSE;
		}
		
		// Verify there is no review attached to this collection
		$criteria = 'PathCollectionReview.collection_id ="' .$collection_id.'"';			 
		$path_review_nbr = $this->PathCollectionReview->findCount($criteria);

		if($path_review_nbr > 0){
			return FALSE;
		}
		
		$criteria = 'ReviewMaster.collection_id ="' .$collection_id.'"';			 
		$aliquot_review_nbr = $this->ReviewMaster->findCount($criteria);

		if($aliquot_review_nbr > 0){
			return FALSE;
		}
		
		// Verify Collection has not been linked to a participant, consent or diagnosis
		$criteria = 'ClinicalCollectionLink.collection_id = "'.$collection_id.'" ';
		$criteria .= 'AND (ClinicalCollectionLink.participant_id != 0 ';
		$criteria .= 'OR ClinicalCollectionLink.diagnosis_id != 0 ';
		$criteria .= 'OR ClinicalCollectionLink.consent_id != 0)';			
		$clinical_collection_link_nbr = $this->ClinicalCollectionLink->findCount($criteria);
		
		if($clinical_collection_link_nbr > 0){
			return FALSE;
		}
		
		return TRUE;
		
	}
	
}

?>
