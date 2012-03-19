<?php

class ClinicalCollectionLinksController extends ClinicalAnnotationAppController {
	
	var $components = array();
	
	var $uses = array(
		'ClinicalAnnotation.Participant', 
		'ClinicalAnnotation.ConsentMaster',
		'ClinicalAnnotation.DiagnosisMaster',
		'ClinicalAnnotation.TreatmentMaster',
		'ClinicalAnnotation.EventMaster',
		
		'InventoryManagement.Collection',
		
		'Codingicd.CodingIcd10Who',
		'Codingicd.CodingIcd10Ca',
		'Codingicd.CodingIcdo3Morpho',
		'Codingicd.CodingIcdo3Topo'
	);
	
	function beforeFilter(){
		parent::beforeFilter();
		
		//permissions on collections, consent, dx, tx and event are required
		$error = array();
		$check = array(
			'collection'	=> '/InventoryManagement/Collections/detail/',
			'consent'		=> '/ClinicalAnnotation/ConsentMasters/detail/',
			'diagnosis'		=> '/ClinicalAnnotation/DiagnosisMasters/detail/',
			'treatment'		=> '/ClinicalAnnotation/TreatmentMasters/detail/',
			'event'			=> '/ClinicalAnnotation/EventMasters/detail/'
		);
		foreach($check as $name => $link){
			if(!AppController::checkLinkPermission($link)){
				$error[] = __($name);
			}
		}
		if($error){
			if($this->request->is('ajax')){
				die(__('You are not authorized to access that location.'));
			}
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
	}
	
	//var $paginate = array('Collection' => array('limit' => pagination_amount,'order'=>'Collection.acquisition_label ASC'));	
	
	function listall( $participant_id ) {
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		$conditions = array('Collection.participant_id' => $participant_id);
		if(isset($this->passedArgs['filterModel']) && isset($this->passedArgs['filterId'])){
			$filter_model = $this->passedArgs['filterModel'];
			if(isset($this->$filter_model)){
				$conditions[$this->$filter_model->name.'.id'] = $this->passedArgs['filterId'];
			}
		}
		
		// MANAGE DATA
		$this->request->data = $this->Collection->find('all', array(
			'conditions' => $conditions,
			'order' => 'Collection.acquisition_label ASC',
			'limit' => pagination_amount,
			'joins' => array(
				DiagnosisMaster::joinOnDiagnosisDup('Collection.diagnosis_master_id'), 
				DiagnosisMaster::$join_diagnosis_control_on_dup,
				ConsentMaster::joinOnConsentDup('Collection.consent_master_id'), 
				ConsentMaster::$join_consent_control_on_dup,
				array('table' => 'treatment_masters', 'alias' => 'treatment_masters_dup', 'type' => 'LEFT', 'conditions' => array('Collection.treatment_master_id = treatment_masters_dup.id')),
				array('table' => 'treatment_controls', 'alias' => 'TreatmentControl', 'type' => 'LEFT', 'conditions' => array('treatment_masters_dup.treatment_control_id = TreatmentControl.id')),
				array('table' => 'event_masters', 'alias' => 'event_masters_dup', 'type' => 'LEFT', 'conditions' => array('Collection.event_master_id = event_masters_dup.id')),
				array('table' => 'event_controls', 'alias' => 'EventControl', 'type' => 'LEFT', 'conditions' => array('event_masters_dup.event_control_id = EventControl.id'))
			), 'fields' => array('*')
		));
		

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function detail( $participant_id, $collection_id ) {
		$collection_data = $this->Collection->getOrRedirect($collection_id);
		if($collection_data['Collection']['participant_id'] != $participant_id){
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		if($collection_data['Collection']['treatment_master_id']){
			$collection_data['TreatmentMaster'] = $this->TreatmentMaster->getOrRedirect($collection_data['Collection']['treatment_master_id']);
		}
		if($collection_data['Collection']['event_master_id']){
			$collection_data['EventMaster'] = $this->EventMaster->getOrRedirect($collection_data['Collection']['event_master_id']);
		}

		// MANAGE DATA
		$diagnosis_data = $this->DiagnosisMaster->getRelatedDiagnosisEvents($collection_data['Collection']['diagnosis_master_id']);
		
		$this->set( 'collection_data', $collection_data );
		$this->set( 'diagnosis_data', $diagnosis_data );
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id' => $participant_id, 'Collection.id' => $collection_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'atim_structure_diagnosis_detail');
		$this->Structures->set('treatmentmasters', 'atim_structure_tx');
		$this->Structures->set('eventmasters', 'atim_structure_event');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add( $participant_id ) {
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		// Set collections list
		$this->set( 'collection_id', isset($this->request->data['Collection']['id']) ? $this->request->data['Collection']['id'] : null );
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.participant_id' => $participant_id)));
		$consent_found = false;
		if(isset($this->request->data['Collection']['consent_master_id'])){
			$consent_found = $this->setForRadiolist($consent_data, 'ConsentMaster', 'id', $this->request->data, 'Collection', 'consent_master_id');
		}
		$this->set( 'consent_found', $consent_found);
		$this->set( 'consent_data', $consent_data);
	
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id)));
		$found_dx = false;
		if(isset($this->request->data['Collection']['diagnosis_master_id'])){
			$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, $this->request->data['Collection']['diagnosis_master_id'], 'Collection');
		}
		$this->set( 'diagnosis_data', $diagnosis_data );
		$this->set( 'found_dx', $found_dx );
		
		//set tx list
		$this->TreatmentMaster->virtualFields['tx_or_event_id'] = 'CONCAT("tx_", TreatmentMaster.id)';
		$tx_data = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentControl.flag_use_for_ccl' => true)));
		$tx_or_event_found = false;
		$tx_or_event = null;
		$tx_or_event_id = null;
		if(isset($this->request->data['Collection']['tx_or_event_id']) && $this->request->data['Collection']['tx_or_event_id']){
			list($tx_or_event, $tx_or_event_id) = explode('_', $this->request->data['Collection']['tx_or_event_id']);
		}
		if($tx_or_event == 'tx'){
			$tx_or_event_found = $this->setForRadiolist($tx_data, 'TreatmentMaster', 'tx_or_event_id', $this->request->data, 'Collection', 'tx_or_event_id');
		}
		$this->set('tx_data', $tx_data);
		
		//set event list
		$this->EventMaster->virtualFields['tx_or_event_id'] = 'CONCAT("ev_", EventMaster.id)';
		$event_data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventControl.flag_use_for_ccl' => true)));
		if($tx_or_event == 'ev'){
			$tx_or_event_found = $this->setForRadiolist($event_data, 'EventMaster', 'tx_or_event_id', $this->request->data, 'Collection', 'tx_or_event_id');
		}
		$this->set('event_data', $event_data);
		$this->set('tx_or_event_found', $tx_or_event_found);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('view_diagnosis', 'atim_structure_diagnosis_detail');
		$this->Structures->set('treatmentmasters', 'atim_structure_tx');
		$this->Structures->set('eventmasters', 'atim_structure_event');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	
		if ( !empty($this->request->data) ) {
			// Launch Save Process
			$fields = array('participant_id', 'diagnosis_master_id', 'consent_master_id', 'treatment_master_id', 'event_master_id');
			if($this->request->data['Collection']['id']){
				//test if the collection exists and is available
				$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.participant_id IS NULL', 'Collection.collection_property' => 'participant collection', 'Collection.id' => $this->request->data['Collection']['id'])));
				if(empty($collection_data)){
					$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
				}
			}else{
				$this->request->data['Collection']['deleted'] = 1;
				$fields[] = 'deleted';
			}
			$this->request->data['Collection']['participant_id'] = $participant_id;
			$this->Collection->id = $this->request->data['Collection']['id'] ?: null;
			unset($this->request->data['Collection']['id']); 
			
			$this->request->data['Collection']['treatment_master_id'] = null;
			$this->request->data['Collection']['event_master_id'] = null;
			if($tx_or_event == 'tx'){
				$this->request->data['Collection']['treatment_master_id'] = $tx_or_event_id; 
			}else if($tx_or_event == 'ev'){
				$this->request->data['Collection']['event_master_id'] = $tx_or_event_id;
			}
			$this->Collection->addWritableField($fields);
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if ( $submitted_data_validates && $this->Collection->save($this->request->data, true, $fields)){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
			
				if(isset($this->request->data['Collection']['deleted'])){
					$this->redirect('/InventoryManagement/Collections/add/'.$this->Collection->getLastInsertId());
				}else{
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$participant_id.'/'.$this->Collection->id );
				}
				return;
			}
		}
	}
	
	function edit( $participant_id, $collection_id) {
		$collection_data = $this->Collection->getOrRedirect($collection_id);
		if($collection_data['Collection']['participant_id'] != $participant_id) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	
		
		$this->set( 'collection_data', $collection_data );
		
		if($collection_data['Collection']['treatment_master_id']){
			$collection_data['Collection']['tx_or_event_id'] = 'tx_'.$collection_data['Collection']['treatment_master_id'];
		}else if($collection_data['Collection']['event_master_id']){
			$collection_data['Collection']['tx_or_event_id'] = 'ev_'.$collection_data['Collection']['event_master_id'];
		}
		$data_for_form = $this->request->data ? $this->request->data : $collection_data;
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ConsentMaster.participant_id' => $participant_id)));
		//because consent has a one to many relation with participant, we need to format it
		$consent_found = $this->setForRadiolist($consent_data, 'ConsentMaster', 'id', $data_for_form, 'Collection', 'consent_master_id');
		$this->set('consent_data', $consent_data );
		$this->set('consent_found', $consent_found);
		
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id)));
		//because diagnosis has a one to many relation with participant, we need to format it
		$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, $data_for_form['Collection']['diagnosis_master_id'], 'Collection');

		$this->set( 'diagnosis_data', $diagnosis_data );
		$this->set('found_dx', $found_dx);
		
		//set tx list
		$this->TreatmentMaster->virtualFields['tx_or_event_id'] = 'CONCAT("tx_", TreatmentMaster.id)';
		$tx_data = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentControl.flag_use_for_ccl' => true)));
		$tx_or_event_found = false;
		$tx_or_event = null;
		$tx_or_event_id = null;
		if(isset($data_for_form['Collection']['tx_or_event_id']) && $data_for_form['Collection']['tx_or_event_id']){
			list($tx_or_event, $tx_or_event_id) = explode('_', $data_for_form['Collection']['tx_or_event_id']);
		}
		if($tx_or_event == 'tx'){
			$tx_or_event_found = $this->setForRadiolist($tx_data, 'TreatmentMaster', 'tx_or_event_id', $data_for_form, 'Collection', 'tx_or_event_id');
		}
		$this->set('tx_data', $tx_data);
		
		//set event list
		$this->EventMaster->virtualFields['tx_or_event_id'] = 'CONCAT("ev_", EventMaster.id)';
		$event_data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventControl.flag_use_for_ccl' => true)));
		if($tx_or_event == 'ev'){
			$tx_or_event_found = $this->setForRadiolist($event_data, 'EventMaster', 'tx_or_event_id', $data_for_form, 'Collection', 'tx_or_event_id');
		}
		$this->set('event_data', $event_data);
		$this->set('tx_or_event_found', $tx_or_event_found);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id' => $participant_id, 'Collection.id' => $collection_id) );
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
		$this->Structures->set('treatmentmasters', 'atim_structure_tx');
		$this->Structures->set('eventmasters', 'atim_structure_event');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		// MANAGE DATA RECORD
		
		if ( !empty($this->request->data) ) {
			// Launch Save Process
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			$this->request->data['Collection']['treatment_master_id'] = null;
			$this->request->data['Collection']['event_master_id'] = null;
			if($tx_or_event == 'tx'){
				$this->request->data['Collection']['treatment_master_id'] = $tx_or_event_id;
			}else if($tx_or_event == 'ev'){
				$this->request->data['Collection']['event_master_id'] = $tx_or_event_id;
			}
			
			$this->Collection->id = $collection_id;
			$this->Collection->check_writable_fields = false;//checked with the filter array in the save command
			if ($submitted_data_validates && $this->Collection->save($this->request->data, true, array('consent_master_id', 'diagnosis_master_id', 'treatment_master_id', 'event_master_id'))) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$participant_id.'/'.$collection_id );
				return;
			}
		} else {
			// Launch Initial Display Process
			$this->request->data = $collection_data;
		}
	}

	function delete( $participant_id, $collection_id ) {
		$collection_data = $this->Collection->getOrRedirect($collection_id);
		if($collection_data['Collection']['participant_id'] != $participant_id) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$arr_allow_deletion = $this->Collection->allowLinkDeletion($collection_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if($arr_allow_deletion['allow_deletion']) {
			$this->request->data = array('Collection' => array(
				'participant_id' => null,
				'diagnosis_master_id' => null,
				'consent_master_id' => null)
			);
				
			$this->Collection->id = $collection_id;
			if($this->Collection->save($this->request->data)){
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				$this->atimFlash( 'your data has been deleted' , '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$participant_id.'/');
			}else{
				$this->flash( 'error deleting data - contact administrator','/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$participant_id.'/'.$collection_id.'/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$participant_id.'/'.$collection_id);
		}
	}
}
