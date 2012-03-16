<?php

class ParticipantsController extends ClinicalAnnotationAppController {
	
	var $components = array(); 
		
	var $uses = array(
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.ConsentMaster',
		'ClinicalAnnotation.ParticipantContact',
		'ClinicalAnnotation.ParticipantMessage',
		'ClinicalAnnotation.EventMaster',
		'ClinicalAnnotation.DiagnosisMaster',
		'ClinicalAnnotation.FamilyHistory',
		'ClinicalAnnotation.MiscIdentifier',
		'ClinicalAnnotation.ReproductiveHistory',
		'ClinicalAnnotation.TreatmentMaster',
		'ClinicalAnnotation.MiscIdentifierControl',
		'Codingicd.CodingIcd10Who',
		'Codingicd.CodingIcd10Ca',
	);
	var $paginate = array(
		'Participant'=>array('limit'=>pagination_amount,'order'=>'Participant.last_name ASC, Participant.first_name ASC'),
		'MiscIdentifier'=>array('limit'=>pagination_amount,'order'=>'MiscIdentifierControl.misc_identifier_name ASC')); 
	
	function search($search_id = ''){
		$this->searchHandler($search_id, $this->Participant, 'participants', '/ClinicalAnnotation/Participants/search');
	
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

	function profile($participant_id){
		// MANAGE DATA
		$this->request->data = $this->Participant->getOrRedirect($participant_id);
		
		// Set data for identifier list
		$participant_identifiers_data = $this->paginate($this->MiscIdentifier, array('MiscIdentifier.participant_id'=>$participant_id));
		$this->set('participant_identifiers_data', $participant_identifiers_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		// Set form for identifier list
		$this->Structures->set('miscidentifiers', 'atim_structure_for_misc_identifiers');

		
		$mi = $this->MiscIdentifier->find('all', array(
				'fields' => array('MiscIdentifierControl.id'),
				'conditions' => array('MiscIdentifier.deleted' => 1, 'MiscIdentifier.tmp_deleted' => 1),
				'group' => array('MiscIdentifierControl.id')
		));
		$reusable = array();
		foreach($mi as $mi_unit){
			$reusable[$mi_unit['MiscIdentifierControl']['id']] = null;
		}
		$conditions = array('flag_active' => '1');
		if(!$this->Session->read('flag_show_confidential')){
			$conditions["flag_confidential"] = 0;
		}
		$identifier_controls_list = $this->MiscIdentifierControl->find('all', array('conditions' => $conditions));
		foreach($identifier_controls_list as &$unit){
			if(!empty($unit['MiscIdentifierControl']['autoincrement_name']) && array_key_exists($unit['MiscIdentifierControl']['id'], $reusable)){
				$unit['reusable'] = true;
			}
		}
		$this->set('identifier_controls_list', $identifier_controls_list);
		$this->Structures->set('empty', 'empty_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function add() {
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/ClinicalAnnotation/Participants/search') );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->request->data) ) {
			$this->Participant->patchIcd10NullValues($this->request->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}				
			
			if($submitted_data_validates) {
				if ( $this->Participant->save($this->request->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash('your data has been saved', '/ClinicalAnnotation/Participants/profile/'.$this->Participant->getLastInsertID());
				}
			}
		}
	}
	
	function edit( $participant_id ) {
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		if(empty($this->request->data)) {
			$this->request->data = $participant_data;
		} else {
			$this->Participant->patchIcd10NullValues($this->request->data);
			$submitted_data_validates = true;
			// ... special validations
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {
				$this->Participant->id = $participant_id;
				$this->Participant->data = array();
				if ( $this->Participant->save($this->request->data) ){
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash('your data has been updated', '/ClinicalAnnotation/Participants/profile/'.$participant_id );		
				}
			}
		}
	}

	function delete( $participant_id ) {

		// MANAGE DATA
		$this->request->data = $this->Participant->getOrRedirect($participant_id);

		$arr_allow_deletion = $this->Participant->allowDeletion($participant_id);
		
		// CUSTOM CODE	
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ( $this->Participant->atimDelete( $participant_id ) ) {
				$this->atimFlash('your data has been deleted', '/ClinicalAnnotation/Participants/search/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/Participants/search/');
			}
		} else {
			$this->flash( $arr_allow_deletion['msg'], '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/');
		}
	}

	function chronology($participant_id){
		$tmp_array = array();
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->Structures->set('chronology', 'chronology');

		//load every wanted information into the tmpArray
		$participant = $this->Participant->find('first', array('conditions' => array('Participant.id' => $participant_id)));
		$tmp_array[$participant['Participant']['date_of_birth']][] = array(
			'event' => __('date of birth'), 
			'link' => '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/', 
			'date_accuracy' => $participant['Participant']['date_of_birth_accuracy']
		);
		if(strlen($participant['Participant']['date_of_death']) > 0){
			$tmp_array[$participant['Participant']['date_of_death']][] = array(
				'event' => __('date of death'), 
				'link' => '/ClinicalAnnotation/Participants/profile/'.$participant_id.'/', 
				'date_accuracy' => $participant['Participant']['date_of_death_accuracy']
			);
		}
		
		$consents = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.participant_id' => $participant_id, 'ConsentMaster.consent_status' => 'obtained')));
		foreach($consents as $consent){
			$tmp_array[$consent['ConsentMaster']['consent_signed_date']][] = array(
				'event' => __('consent'), 
				'link' => '/ClinicalAnnotation/ConsentMasters/detail/'.$participant_id.'/'.$consent['ConsentMaster']['id'],
				'date_accuracy' => isset($consent['ConsentMaster']['consent_signed_date_accuracy']) ? $consent['ConsentMaster']['consent_signed_date_accuracy'] : 'c'
			);
		}
		
		$dxs = $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id)));
		foreach($dxs as $dx){
			$tmp_array[$dx['DiagnosisMaster']['dx_date']][] = array(
				'event' => __('diagnosis'), 
				'link' => '/ClinicalAnnotation/DiagnosisMasters/detail/'.$participant_id.'/'.$dx['DiagnosisMaster']['id'],
				'date_accuracy' => $dx['DiagnosisMaster']['dx_date_accuracy']
			);
		}
		
		$annotations = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id)));
		foreach($annotations as $annotation){
			$tmp_array[$annotation['EventMaster']['event_date']][] = array(
				'event' => __($annotation['EventControl']['event_type']), 
				'link' => '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$annotation['EventMaster']['id'],
				'date_accuracy' => isset($annotation['EventMaster']['event_date_accuracy']) ? $annotation['EventMaster']['event_date_accuracy'] : 'c'
			);
		}
		
		$txs = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id)));
		foreach($txs as $tx){
			$tmp_array[$tx['TreatmentMaster']['start_date']][] = array(
				'event' => __('treatment').", ".__($tx['TreatmentControl']['tx_method'])." (".__("start").")", 
				'link' => '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
				'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy']
			);
			if(!empty($tx['TreatmentMaster']['finish_date'])){
				$tmp_array[$tx['TreatmentMaster']['finish_date']][] = array(
					'event' => __('treatment').", ".__($tx['TreatmentControl']['tx_method'])." (".__("end").")", 
					'link' => '/ClinicalAnnotation/TreatmentMasters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
					'date_accuracy' => $tx['TreatmentMaster']['finish_date_accuracy']
				);
			}
		}
		
		$collection_model = AppModel::getInstance('InventoryManagement', 'Collection', true);
		$collections = $collection_model->find('all', array('conditions' => array('Collection.participant_id' => $participant_id), 'recursive' => -1));
		foreach($collections as $collection){
			$tmp_array[$collection['Collection']['collection_datetime']][] = array(
				'event' => __('collection')." (".$collection['Collection']['acquisition_label'].")", 
				'link' => '/InventoryManagement/Collections/detail/'.$collection['Collection']['id'],
				'date_accuracy' => $collection['Collection']['collection_datetime_accuracy']	
			);
		}

		//sort the tmpArray by key (key = date)
		ksort($tmp_array);
		
		//transfer the tmpArray into $this->request->data
		$this->request->data = array();
		foreach($tmp_array as $key => $values){
			foreach($values as $value){
				$date = $key;
				$time = null;
				if(strpos($date, " ") > 0){
					list($date, $time) = explode(" ", $date);
				}
				$this->request->data[] = array('custom' => array(
					'date' => $date,
					'date_accuracy' => $value['date_accuracy'], 
					'time' => $time,
					'event' => $value['event'],
					'link' => isset($value['link']) ? $value['link'] : null));
			}
		}
	}
	
	function batchEdit(){
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
		if(empty($this->request->data)){
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($this->request->data['Participant']['id']) && is_array($this->request->data['Participant']['id'])){
			//display
			$ids = array_filter($this->request->data['Participant']['id']);
			$this->request->data[0]['ids'] = implode(",", $ids);
			
		}else if(isset($this->request->data[0]['ids']) && strlen($this->request->data[0]['ids'])){
			//save
			$participants = $this->Participant->find('all', array('conditions' => array('Participant.id' => explode(",", $this->request->data[0]['ids']))));
			$this->Structures->set('participants');
			//fake participant to validate
			AppController::removeEmptyValues($this->request->data['Participant']);
			$this->Participant->set($this->request->data);
			if($this->Participant->validates()){
				$ids = explode(",", $this->request->data[0]['ids']);
				foreach($ids as $id){
					$this->Participant->id = $id;
					$this->Participant->save($this->request->data['Participant'], array('validate' => false, 'fieldList' => array_keys($this->request->data['Participant'])));
				}
				
				$_SESSION['ctrapp_core']['search'][$search_id]['criteria'] = array("Participant.id" => $ids);
				$this->atimFlash('your data has been updated', '/ClinicalAnnotation/Participants/search/');
			}
			
		}else{
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
}

?>