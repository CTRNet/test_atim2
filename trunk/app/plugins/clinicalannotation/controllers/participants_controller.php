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
	
	function search($search_id = ''){
		$this->searchHandler($search_id, $this->Participant, 'participants', '/clinicalannotation/participants/search');
	
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
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participants/search') );

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->Participant->patchIcd10NullValues($this->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}				
			
			if($submitted_data_validates) {
				if ( $this->Participant->save($this->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
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
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {
				$this->Participant->id = $participant_id;
				if ( $this->Participant->save($this->data) ){
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
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
		$tmp_array = array();
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->Structures->set('chronology', 'chronology');

		//load every wanted information into the tmpArray
		$participant = $this->Participant->find('first', array('conditions' => array('Participant.id' => $participant_id)));
		$tmp_array[$participant['Participant']['date_of_birth']][] = array(
			'event' => __('date of birth', true), 
			'link' => '/clinicalannotation/participants/profile/'.$participant_id.'/', 
			'date_accuracy' => $participant['Participant']['date_of_birth_accuracy']
		);
		if(strlen($participant['Participant']['date_of_death']) > 0){
			$tmp_array[$participant['Participant']['date_of_death']][] = array(
				'event' => __('date of death', true), 
				'link' => '/clinicalannotation/participants/profile/'.$participant_id.'/', 
				'date_accuracy' => $participant['Participant']['date_of_death_accuracy']
			);
		}
		
		$consents = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.participant_id' => $participant_id, 'ConsentMaster.consent_status' => 'obtained')));
		foreach($consents as $consent){
			$tmp_array[$consent['ConsentMaster']['consent_signed_date']][] = array(
				'event' => __('consent', true), 
				'link' => '/clinicalannotation/consent_masters/detail/'.$participant_id.'/'.$consent['ConsentMaster']['id'],
				'date_accuracy' => isset($consent['ConsentMaster']['consent_signed_date_accuracy']) ? $consent['ConsentMaster']['consent_signed_date_accuracy'] : 'c'
			);
		}
		
		$dxs = $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id)));
		foreach($dxs as $dx){
			$tmp_array[$dx['DiagnosisMaster']['dx_date']][] = array(
				'event' => __('diagnosis', true), 
				'link' => '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$dx['DiagnosisMaster']['id'],
				'date_accuracy' => $dx['DiagnosisMaster']['dx_date_accuracy']
			);
		}
		
		$annotations = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id)));
		foreach($annotations as $annotation){
			$tmp_array[$annotation['EventMaster']['event_date']][] = array(
				'event' => __($annotation['EventControl']['event_type'], true), 
				'link' => '/clinicalannotation/event_masters/detail/'.$annotation['EventControl']['event_group'].'/'.$participant_id.'/'.$annotation['EventMaster']['id'],
				'date_accuracy' => isset($annotation['EventMaster']['event_date_accuracy']) ? $annotation['EventMaster']['event_date_accuracy'] : 'c'
			);
		}
		
		$txs = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id)));
		foreach($txs as $tx){
			$tmp_array[$tx['TreatmentMaster']['start_date']][] = array(
				'event' => __('treatment', true).", ".__($tx['TreatmentControl']['tx_method'], true)." (".__("start", true).")", 
				'link' => '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
				'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy']
			);
			if(!empty($tx['TreatmentMaster']['finish_date'])){
				$tmp_array[$tx['TreatmentMaster']['finish_date']][] = array(
					'event' => __('treatment', true).", ".__($tx['TreatmentControl']['tx_method'], true)." (".__("end", true).")", 
					'link' => '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx['TreatmentMaster']['id'],
					'date_accuracy' => $tx['TreatmentMaster']['finish_date_accuracy']
				);
			}
		}
		
		$ccls = $this->ClinicalCollectionLink->find('all', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id)));
		foreach($ccls as $ccl){
			$tmp_array[$ccl['Collection']['collection_datetime']][] = array(
				'event' => __('collection', true)." (".$ccl['Collection']['acquisition_label'].")", 
				'link' => '/inventorymanagement/collections/detail/'.$ccl['Collection']['id'],
				'date_accuracy' => $ccl['Collection']['collection_datetime_accuracy']	
			);
		}

		//sort the tmpArray by key (key = date)
		ksort($tmp_array);
		
		//transfer the tmpArray into $this->data
		$this->data = array();
		foreach($tmp_array as $key => $values){
			foreach($values as $value){
				$date = $key;
				$time = null;
				if(strpos($date, " ") > 0){
					list($date, $time) = explode(" ", $date);
				}
				$this->data[] = array('custom' => array(
					'date' => $date,
					'date_accuracy' => $value['date_accuracy'], 
					'time' => $time,
					'event' => $value['event'],
					'link' => isset($value['link']) ? $value['link'] : null));
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
			AppController::removeEmptyValues($this->data['Participant']);
			$this->Participant->set($this->data);
			if($this->Participant->validates()){
				$ids = explode(",", $this->data[0]['ids']);
				foreach($ids as $id){
					$this->Participant->id = $id;
					$this->Participant->save($this->data['Participant'], array('validate' => false, 'fieldList' => array_keys($this->data['Participant'])));
				}
				
				$_SESSION['ctrapp_core']['search'][$search_id]['criteria'] = array("Participant.id" => $ids);
				$this->atimFlash('your data has been updated', '/clinicalannotation/Participants/search/');
			}
			
		}else{
			$this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
}

?>