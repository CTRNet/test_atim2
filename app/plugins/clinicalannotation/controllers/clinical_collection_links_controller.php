<?php

class ClinicalCollectionLinksController extends ClinicalAnnotationAppController {
	var $uses = array('ClinicalCollectionLinks');
	var $paginate = array('ClinicalCollectionLinks'=>array('limit'=>10,'order'=>'ClinicalCollectionLinks.id ASC');	
	
	function listall( $participant_id ) {
		$this->data = $this->paginate($this->ClinicalCollectionLinks);
	}
	
	function detail( $participant_id, $clinical_collection_links_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_links_id) );
		$this->data = $this->ClinicalCollectionLinks->find('first',array('conditions'=>array('ClinicalCollectionLinks.id'=>$clinical_collection_links_id)));
	}
	
	function add( $participant_id ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/'.$particiant_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->ClinicalCollectionLinks->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.$this->ClinicalCollectionLinks->id );
		}
	}
	
	function edit( $participant_id, $clinical_collection_links_id) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_links_id) );
		
		if ( !empty($this->data) ) {
			$this->ClinicalCollectionLinks->id = $clinical_collection_links_id;
			if ( $this->ClinicalCollectionLinks->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.$clinical_collection_links_id );
		} else {
			$this->data = $this->ClinicalCollectionLinks->find('first',array('conditions'=>array('ClinicalCollectionLinks.id'=>$clinical_collection_links_id)));
		}
	}
/*
	var $name = 'ClinicalCollectionLinks';
	
	var $uses 
		= array('ClinicalCollectionLink', 
			'Collection', 
			'Consent',
			'Diagnosis', 
			'Participant');

	var $components = array('Summaries');
	
	var $helpers = array('Summaries', 'MoreForm');

	function beforeFilter() {

		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();

		// CakePHP function to re-combine dat/time select fields
		$this->cleanUpFields();

	}

	function index() {
		// nothing...
	}

	/**
	 * List all collection of a participant
	 * 
	 * @param $participant_id Id of the participant
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
	 
	function listall( $participant_id=null ) {

		// ** Parameters check: Verify parameters have been set **
		if(empty($participant_id)) {
			$this->redirect('/pages/err_clin_funct_param_missing'); 
			exit;
		}
		
		// Verify participant exists
		$criteria = 'Participant.id="'.$participant_id.'"';
		$participant_data = $this->Participant->find($criteria);
		
		if(empty($participant_data)) {
			$this->redirect('/pages/err_clin_no_part_data'); 
			exit;			
		}

		// ** set MENU varible for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_67', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// ** set FORM variable, for HELPER call on VIEW **
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('clinical_collection_links') );

		// ** set DATA for echo on VIEW ** 
		$this->set( 'participant_id', $participant_id );

		// ** set SUMMARY varible from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// ** set SIDEBAR variable, for HELPER call on VIEW **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );

		// ** Look for all participant collection link **
		$criteria = array();
		$criteria['ClinicalCollectionLink.participant_id'] = $participant_id;
		$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$clinical_collection_list = $this->ClinicalCollectionLink->findAll( $criteria, NULL, $order, $limit, $page );
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Set Data **
		$this->set( 'clinical_collection_links', $clinical_collection_list );
		
	}

	/**
	 * Detail a participant collection link (including collection data plus
	 * diagnosis data plus consent data).
	 * 
	 * @param $participant_id Id of the participant
	 * @param $clinical_collection_link_id Id of the link
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
	 
	function detail( $participant_id=null, $clinical_collection_link_id=null ) {
		
		// ** Parameters check: Verify parameters have been set **
		if(empty($participant_id) || empty($clinical_collection_link_id)) {
			$this->redirect('/pages/err_clin_funct_param_missing'); 
			exit;
		}
		
		// ** set MENU variable for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_67', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// ** set FORM variable, for HELPER call on VIEW **
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('clinical_collection_links') );

		// ** set SUMMARY varible from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// ** set SIDEBAR variable, for HELPER call on VIEW **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );

		// ** Look for data Data **		
		$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
		$clinical_coll_link_data = $this->ClinicalCollectionLink->read();

		if(empty($clinical_coll_link_data)){
			$this->redirect('/pages/err_clin_no_link_data'); 
			exit;	
		}				
				
		if(strcmp($clinical_coll_link_data['ClinicalCollectionLink']['participant_id'], $participant_id)) {
			$this->redirect('/pages/err_clin_link_no_participant_id_map'); 
			exit;	
		}
		
		// ** set Data to display on view or create link **
		$this->set( 'participant_id', $participant_id );
		$this->set( 'allow_deletion', $this->allowClinicalCollectionLinkDeletion($clinical_collection_link_id));

		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		// ** Set Clinical Collection link Data **	
		$this->set( 'data', $clinical_coll_link_data );
		
	}

	/**
	 * Add a participant collection link.
	 * 
	 * @param $participant_id Id of the participant
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
	
	function add( $participant_id=null ) {

		// ** Parameters check: Verify parameters have been set **
		if(empty($participant_id)) {
			$this->redirect('/pages/err_clin_funct_param_missing'); 
			exit;
		}
		
		// Verify participant exists
		$criteria = 'Participant.id="'.$participant_id.'"';
		$participant_data = $this->Participant->find($criteria);
		
		if(empty($participant_data)) {
			$this->redirect('/pages/err_clin_no_part_data'); 
			exit;			
		}		
		
		// ** set MENU varible for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_67', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// ** set FORM variable, for HELPER call on VIEW **
		// 1- collections
		$this->set( 'ctrapp_collections_form', $this->Forms->getFormArray('collections') );
		// 2- diagnoses
		$this->set( 'ctrapp_dx_form', $this->Forms->getFormArray('diagnoses') );
		// 3- consents
		$this->set( 'ctrapp_consents_form', $this->Forms->getFormArray('consents') );		

		// ** set SUMMARY varible from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// ** set SIDEBAR variable, for HELPER call on VIEW **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );

		// ** set FORM variable, for HELPER call on VIEW **
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('clinical_collection_links') );

		// ** set data to display on view or create link **
		$this->set( 'participant_id', $participant_id );

		// ** Set Data **
		
		// a- Collection: 
		// get all UNLINKED Collection rows for linking to a collection - AARON needs to be implemented
		$criteria = 'ClinicalCollectionLink.participant_id="0" ' .
				'AND Collection.collection_property = "participant collection"';
		$order = 'Collection.acquisition_label ASC, Collection.collection_datetime ASC';
		$this->set( 'collection_listall', 
			$this->ClinicalCollectionLink->findAll( $criteria, NULL, $order ) );

		// b- Diagnosis: 
		// get all DX rows for linking to a collection - AARON
		$criteria = 'Diagnosis.participant_id="'.$participant_id.'"';
		$order = 'Diagnosis.case_number ASC, Diagnosis.dx_date ASC';
		$this->set( 'dx_listall', 
			$this->Diagnosis->findAll( $criteria, NULL, $order ) );

		
		// c- Constent: 
		// get all Consent rows for linking to a collection - AARON
		$criteria = 'Consent.participant_id="'.$participant_id.'"';
		$order = 'Consent.date ASC';
		$this->set( 'consent_listall', 
			$this->Consent->findAll( $criteria, NULL, $order ) );
		
		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if ( !empty($this->data) ) {
			
			// ** SAVE DATA **
			
			// setup MODEL(s) validation array(s) for displayed FORM
			foreach ( $this->Forms->getValidateArray('clinical_collection_links') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set collection id	
			$this->data['ClinicalCollectionLink']['collection_id'] = '';
			if(isset($this->data['ClinicalCollectionLink']['id'])){
				// Collection has been selected, set field 'collection_id to allow system to validate data
				// (collection id should not be empty)
				
				// Set the selected collection_id
				$field = 'collection_id';
				$criteria = 'ClinicalCollectionLink.id="'.$this->data['ClinicalCollectionLink']['id'].'"';
				$selected_collection_id 
					= $this->ClinicalCollectionLink->field( $field, $criteria);
					
				$this->data['ClinicalCollectionLink']['collection_id'] = $selected_collection_id;
					
			}
			
			// set a FLAG
			$submitted_data_validates = TRUE;
			
			// VALIDATE submitted data
			if(!$this->ClinicalCollectionLink->validates($this->data['ClinicalCollectionLink'])){
				$submitted_data_validates = FALSE;
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
			if($submitted_data_validates){

				if ( $this->ClinicalCollectionLink->save( $this->data['ClinicalCollectionLink'] ) ) {
					$this->flash( 'Your data has been saved.', '/clinical_collection_links/listall/'.$participant_id );
				} else {
					$this->redirect('/pages/err_clin_link_record_err'); 
					exit;
				}
				
			}

		}

	}

	/**
	 * Edit a participant collection link.
	 * 
	 * @param $participant_id Id of the participant
	 * @param $clinical_collection_link_id Id of the link
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
	function edit( $participant_id=null, $clinical_collection_link_id=null ) {

		// ** Parameters check: Verify parameters have been set **
		if(empty($participant_id) || empty($clinical_collection_link_id)) {
			$this->redirect('/pages/err_clin_funct_param_missing'); 
			exit;
		}
		
		// ** set MENU varible for echo on VIEW **
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_67', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// ** set FORM variable, for HELPER call on VIEW **
		// 1- clinical_collection_links
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('clinical_collection_links') );
		// 2- diagnoses
		$this->set( 'ctrapp_dx_form', $this->Forms->getFormArray('diagnoses') );
		// 3- consents
		$this->set( 'ctrapp_consents_form', $this->Forms->getFormArray('consents') );		

		// ** set SUMMARY varible from plugin's COMPONENTS **
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// ** set SIDEBAR variable, for HELPER call on VIEW **
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string 
		// that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', 
			$this->Sidebars->getColsArray( 
				$this->params['plugin'].'_'.
				$this->params['controller'].'_'.
				$this->params['action'] ) );
		
		// ** set DATA **
		
		// a- Consent: 
		// get all Consent rows for linking
		$criteria = 'participant_id="'.$participant_id.'"';
		$order = 'date ASC';
		$consent_listall =  $this->Consent->findAll( $criteria, NULL, $order );
		$this->set( 'consent_listall', $consent_listall );

		// b- Diagnoses:
		// get all DX rows for linking
		$criteria = 'participant_id="'.$participant_id.'"';
		$order = 'case_number ASC, dx_date ASC';
		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );			
		
		// ** Search Collection Link Data **
		$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
		$clinical_collection_data = $this->ClinicalCollectionLink->read();	
		
		if(empty($clinical_collection_data)){
			$this->redirect('/pages/err_clin_no_link_data'); 
			exit;	
		}				
				
		if(strcmp($clinical_collection_data['ClinicalCollectionLink']['participant_id'], $participant_id)) {
			$this->redirect('/pages/err_clin_link_no_participant_id_map'); 
			exit;	
		}
		
		// ** set data to display on view or create link **		
		$this->set( 'participant_id', $participant_id );
		
		$data_for_collection_label = array();
		$data_for_collection_label['acquisition_label'] 
			= $clinical_collection_data['Collection']['acquisition_label'];
		$data_for_collection_label['collection_datetime'] 
			= $clinical_collection_data['Collection']['collection_datetime'];
		if(isset($clinical_collection_data['Collection']['bank'])) {
			$data_for_collection_label['bank'] 
				= $clinical_collection_data['Collection']['bank'];			
		}
						
		$this->set( 'data_for_collection_label', $data_for_collection_label);

		// ** look for CUSTOM HOOKS, "format" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}

		if ( empty($this->data) ) {

			$this->data = $clinical_collection_data;
			$this->set( 'data', $this->data );
			
		} else {

			// ** SAVE DATA **
			
			// setup MODEL(s) validation array(s) for displayed FORM
			foreach ( $this->Forms->getValidateArray('clinical_collection_links') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}

			// set a FLAG
			$submitted_data_validates = TRUE;	
			
			// VALIDATE submitted data
			if(!$this->ClinicalCollectionLink->validates($this->data['ClinicalCollectionLink'])){
				$submitted_data_validates = FALSE;
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
			if($submitted_data_validates){
				if ( $this->ClinicalCollectionLink->save( $this->data['ClinicalCollectionLink'] ) ) {
					$this->flash( 'Your data has been updated.','/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id );
				} else {
					$this->redirect('/pages/err_clin_link_record_err'); 
					exit;					
				}
			}

		}

	}

	/**
	 * Delete a participant collection link.
	 * 
	 * @param $participant_id Id of the participant
	 * @param $clinical_collection_link_id Id of the link
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
*/
	function delete( $participant_id=null, $clinical_collection_link_id=null ) {
/*	
		// ** Parameters check: Verify parameters have been set **
		if(empty($participant_id) || empty($clinical_collection_link_id)) {
			$this->redirect('/pages/err_clin_funct_param_missing'); 
			exit;
		}
		
		// ** Search Collection Link Data **
		$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
		$clinical_collection_data = $this->ClinicalCollectionLink->read();	
		
		if(empty($clinical_collection_data)){
			$this->redirect('/pages/err_clin_no_link_data'); 
			exit;	
		}				
				
		if(strcmp($clinical_collection_data['ClinicalCollectionLink']['participant_id'], $participant_id)) {
			$this->redirect('/pages/err_clin_link_no_participant_id_map'); 
			exit;	
		}

		// ** Verify link can be deleted **
		if(!$this->allowClinicalCollectionLinkDeletion($clinical_collection_link_id)){
			$this->redirect('/pages/err_clin_link_del_forbid'); 
			exit;
		}
		
		// ** look for CUSTOM HOOKS, "validation" **
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_validation.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		// ** Launch deletion **
		// simply disassociate it from this participant, DX, and consent forms
		$unlink_collection = array(
			'ClinicalCollectionLink' => array(
					'participant_id' => '0',
					'diagnosis_id' => '0',
					'consent_id' => '0',
					'id' => $clinical_collection_link_id,
					'modified_by' => $this->othAuth->user('id')));

		$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
		
		if($this->ClinicalCollectionLink->save( $unlink_collection['ClinicalCollectionLink'] )) {
			$this->flash( 'Your data has been deleted.', '/clinical_collection_links/listall/'.$participant_id );		
		} else {
			$this->redirect('/pages/err_clin_link_del_err'); 
			exit;			
		}

	}
	
	/**
	 * Define if a collection could be separated from the participant.
	 * 
	 * @param $clinical_collection_link_id Id of the link
	 * 
	 * @author N. Luc
	 * @since 2008-03-04
	 */
	function allowClinicalCollectionLinkDeletion($clinical_collection_link_id){
/*		
		//TODO Add test?
		
		return TRUE;
	}
*/
}

?>