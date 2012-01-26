<?php

class ClinicalCollectionLinksController extends ClinicalAnnotationAppController {
	
	var $components = array();
	
	var $uses = array(
		'ClinicalAnnotation.Participant', 
		'ClinicalAnnotation.ConsentMaster',
		'ClinicalAnnotation.DiagnosisMaster',
		
		'InventoryManagement.Collection',
		
		'Codingicd.CodingIcd10Who',
		'Codingicd.CodingIcd10Ca',
		'Codingicd.CodingIcdo3Morpho',
		'Codingicd.CodingIcdo3Topo'
	);
	
	var $paginate = array('Collection' => array('limit' => pagination_amount,'order'=>'Collection.acquisition_label ASC'));	
	
	function listall( $participant_id ) {
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		// MANAGE DATA
		$this->paginate['Collection'] = array(
			'limit' => pagination_amount , 
			'order' => 'Collection.collection_datetime DESC',
			'fields' => array('*'),
			'joins' => array(
				DiagnosisMaster::joinOnDiagnosisDup('Collection.diagnosis_master_id'), 
				DiagnosisMaster::$join_diagnosis_control_on_dup,
				ConsentMaster::joinOnConsentDup('Collection.consent_master_id'), 
				ConsentMaster::$join_consent_control_on_dup));

		$this->request->data = $this->paginate($this->Collection, array('Collection.participant_id'=>$participant_id));

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

		// MANAGE DATA
		$diagnosis_data = $this->DiagnosisMaster->getRelatedDiagnosisEvents($collection_data['Collection']['diagnosis_master_id']);
		
		$this->set( 'collection_data', $collection_data );
		$this->set( 'diagnosis_data', $diagnosis_data );
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id' => $participant_id, 'Collection.id' => $collection_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add( $participant_id ) {
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		// Set collections list
		$collection_data = $this->Collection->find('all', array('conditions' => array('Collection.participant_id IS NULL', 'collection_property' => 'participant collection')));
		$this->set( 'collection_data', $collection_data );
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.participant_id' => $participant_id)));
		$this->set( 'consent_data', $consent_data );
	
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.participant_id' => $participant_id)));
		$this->set( 'diagnosis_data', $diagnosis_data );
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('view_diagnosis', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	
		
		if ( !empty($this->request->data) ) {
			// Launch Save Process
			$fields = array('participant_id', 'diagnosis_master_id', 'consent_master_id');
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
			$this->Collection->addWritableField(array('participant_id', 'consent_master_id', 'diagnosis_master_id', 'deleted'));
			
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
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ConsentMaster.participant_id' => $participant_id)));
		//because consent has a one to many relation with participant, we need to format it
		$consent_found = false;
		foreach($consent_data as &$consent){
			if($collection_data['Collection']['consent_master_id'] == $consent['ConsentMaster']['id']){
				//we found the one that interests us
				$consent['Collection'] = $collection_data['Collection'];
				$consent_found = true;
				break;
			}
		}
		
		$this->set('consent_data', $consent_data );
		$this->set('found_consent', $consent_found);
		
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id)));
		//because diagnosis has a one to many relation with participant, we need to format it
		$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, $collection_data['Collection']['diagnosis_master_id'], 'Collection');

		$this->set( 'diagnosis_data', $diagnosis_data );
		$this->set('found_dx', $found_dx);
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id' => $participant_id, 'Collection.id' => $collection_id) );
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
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
			
			$this->Collection->id = $collection_id;
			if ($submitted_data_validates && $this->Collection->save($this->request->data, true, array('consent_master_id', 'diagnosis_master_id'))) {
				
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

?>