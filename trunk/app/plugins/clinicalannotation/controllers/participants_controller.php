<?php

class ParticipantsController extends ClinicalannotationAppController {
	
	var $components = array(); 
		
	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.ParticipantContact',
		'Clinicalannotation.ParticipantMessage',
		'Clinicalannotation.EventMaster',
		'Clinicalannotation.DiagnosisMaster',
		'Clinicalannotation.FamilyHistory',
		'Clinicalannotation.MiscIdentifier',
		'Clinicalannotation.ClinicalCollectionLink',
		'Clinicalannotation.ReproductiveHistory',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.MiscIdentifierControl',
		'Codingicd.CodingIcd10Who',
		'Codingicd.CodingIcd10Ca'
	);
	var $paginate = array(
		'Participant'=>array('limit'=>pagination_amount,'order'=>'Participant.last_name ASC, Participant.first_name ASC'),
		'MiscIdentifier'=>array('limit'=>pagination_amount,'order'=>'MiscIdentifierControl.misc_identifier_name ASC')); 
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}
	
	function search() {
		// if SEARCH form data, parse and create conditions
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		// MANAGE DATA
		$this->data = $this->paginate($this->Participant, $_SESSION['ctrapp_core']['search']['criteria']);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participants/index') );		
				
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Participant']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/clinicalannotation/participants/search';
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
	}

	function profile( $participant_id ) {
		if (!$participant_id) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		$this->data = $participant_data;
		
		// Set data for identifier list
		$participant_identifiers_data = $this->paginate($this->MiscIdentifier, array('MiscIdentifier.participant_id'=>$participant_id));
		$this->set('participant_identifiers_data', $participant_identifiers_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		// Set form for identifier list
		
		$this->Structures->set('miscidentifiers', 'atim_structure_for_misc_identifiers');		
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add() {
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participants/index') );

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->Participant->patchIcd10NullValues($this->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }				
			
			if($submitted_data_validates) {
				if ( $this->Participant->save($this->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { require($hook_link); }
					
					$this->atimFlash('your data has been saved', '/clinicalannotation/participants/profile/'.$this->Participant->getLastInsertID());
				}
			}
		}
	}
	
	function edit( $participant_id ) {
		if (!$participant_id) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		if(empty($this->data)) {
			$this->data = $participant_data;
		} else {
			$this->Participant->patchIcd10NullValues($this->data);
			$submitted_data_validates = true;
			// ... special validations
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if($submitted_data_validates) {
				$this->Participant->id = $participant_id;
				if ( $this->Participant->save($this->data) ){
					$this->atimFlash('your data has been updated', '/clinicalannotation/participants/profile/'.$participant_id );		
				}
			}
		}
	}

	function delete( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		$this->data = $participant_data;

		$arr_allow_deletion = $this->Participant->allowDeletion($participant_id);
		
		// CUSTOM CODE	
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ( $this->Participant->atim_delete( $participant_id ) ) {
				$this->atimFlash('your data has been deleted', '/clinicalannotation/participants/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/participants/index/');
			}
		} else {
			$this->flash( $arr_allow_deletion['msg'], '/clinicalannotation/participants/profile/'.$participant_id.'/');
		}
	}

	function chronology($participant_id){
		$tmpArray = array();
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->Structures->set('chronology', 'chronology');

		//load every wanted information into the tmpArray
		$participant = $this->Participant->find('first', array('conditions' => array('Participant.id' => $participant_id)));
		$tmpArray[$participant['Participant']['date_of_birth']][] = array('event' => __('date of birth', true), 'link' => '');
		if(strlen($participant['Participant']['date_of_death']) > 0){
			$tmpArray[$participant['Participant']['date_of_death']][] = array('event' => __('date of death', true), 'link' => '');
		}
		
		$consents = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.participant_id' => $participant_id, 'ConsentMaster.consent_status' => 'obtained')));
		foreach($consents as $consent){
			$tmpArray[$consent['ConsentMaster']['consent_signed_date']][] = array('event' => __('consent', true), 'link' => $consent['ConsentMaster']['id']);
		}
		
		$dxs = $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id)));
		foreach($dxs as $dx){
			$tmpArray[$dx['DiagnosisMaster']['dx_date']][] = array('event' => __('diagnosis', true), 'link' => $dx['DiagnosisMaster']['id']);
		}
		
		$annotations = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id)));
		foreach($annotations as $annotation){
			$tmpArray[$annotation['EventMaster']['event_date']][] = array('event' => __($annotation['EventMaster']['event_type'], true), 'link' => $annotation['EventMaster']['id']);
		}
		
		$txs = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id)));
		foreach($txs as $tx){
			$tmpArray[$tx['TreatmentMaster']['start_date']][] = array('event' => __('treatment', true).", ".__($tx['TreatmentControl']['tx_method'], true)." (".__("start", true).")", 'link' => $tx['TreatmentMaster']['id']);
			$tmpArray[$tx['TreatmentMaster']['finish_date']][] = array('event' => __('treatment', true).", ".__($tx['TreatmentControl']['tx_method'], true)." (".__("end", true).")", 'link' => $tx['TreatmentMaster']['id']);
		}
		
		$ccls = $this->ClinicalCollectionLink->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id)));
		foreach($ccls as $ccl){
			$tmpArray[$ccl['Collection']['collection_datetime']][] = array('event' => __('collection', true)." (".$ccl['Collection']['acquisition_label'].")", 'link' => $ccl['Collection']['id']);
		}
		
		//sort the tmpArray by key (key = date)
		ksort($tmpArray);
		
		//transfer the tmpArray into $this->data
		$this->data = array();
		foreach($tmpArray as $key => $values){
			foreach($values as $value){
				$date = $key;
				$time = null;
				if(strpos($date, " ") > 0){
					list($date, $time) = explode(" ", $date);
				}
				$this->data[] = array('Generated' => array(
					'date' => $date,
					'time' => $time,
					'event' => $value['event']));
			}
		}
	}
	
	function batchEdit(){
		if(empty($this->data)){
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($this->data['Participant']['id']) && is_array($this->data['Participant']['id'])){
			//display
			$ids = array_filter($this->data['Participant']['id']);
			$this->data[0]['ids'] = implode(",", $ids);
			
		}else if(isset($this->data[0]['ids']) && strlen($this->data[0]['ids'])){
			//save
			$participants = $this->Participant->find('all', array('conditions' => array('Participant.id' => explode(",", $this->data[0]['ids']))));
			$this->Structures->set('participants');
			//fake participant to validate
			$this->Participant->set($this->data);
			if($this->Participant->validates()){
				$ids = explode(",", $this->data[0]['ids']);
				$this->Participant->updateAll(
					AppController::getUpdateAllValues(array("Participant" => $this->data['Participant'])),
					array('Participant.id' => $ids)
				);
				
				$_SESSION['ctrapp_core']['search']['criteria'] = array("Participant.id" => $ids);
				$this->atimFlash('your data has been updated', '/clinicalannotation/Participants/search/');
			}
			
		}else{
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
}

?>