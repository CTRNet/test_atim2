<?php

class ClinicalCollectionLinksController extends ClinicalannotationAppController {
	
	var $components = array();
	
	var $uses = array(
		'Clinicalannotation.Participant', 
		'Clinicalannotation.ClinicalCollectionLink', 
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.DiagnosisMaster',
		
		'Inventorymanagement.Collection',
		
		'Codingicd.CodingIcd10Who',
		'Codingicd.CodingIcd10Ca',
		'Codingicd.CodingIcdo3Morpho',
		'Codingicd.CodingIcdo3Topo'
	);
	
	var $paginate = array('ClinicalCollectionLink'=>array('limit' => pagination_amount,'order'=>'Collection.acquisition_label ASC'));	
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	

		$this->paginate['ClinicalCollectionLink'] = array(
			'limit' => pagination_amount , 
			'order' => 'Collection.collection_datetime DESC',
			'fields' => array('*'),
			'joins' => array(
				DiagnosisMaster::joinOnDiagnosisDup('ClinicalCollectionLink.diagnosis_master_id'), 
				DiagnosisMaster::$join_diagnosis_control_on_dup,
				ConsentMaster::joinOnConsentDup('ClinicalCollectionLink.consent_master_id'), 
				ConsentMaster::$join_consent_control_on_dup));

		$this->data = $this->paginate($this->ClinicalCollectionLink, array('ClinicalCollectionLink.participant_id'=>$participant_id));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $clinical_collection_link_id ) {
		if (( !$participant_id ) || ( !$clinical_collection_link_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		
		$clinical_collection_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_link_id,'ClinicalCollectionLink.participant_id'=>$participant_id)));
		if(empty($clinical_collection_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		$collection_data = $this->Collection->find('all', array('conditions' => array('Collection.id' => $clinical_collection_data['ClinicalCollectionLink']['collection_id']), 'recursive' => '-1'));
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.id' => $clinical_collection_data['ClinicalCollectionLink']['consent_master_id'])));
		$diagnosis_data = $this->DiagnosisMaster->getRelatedDiagnosisEvents($clinical_collection_data['ClinicalCollectionLink']['diagnosis_master_id']);
		
		$this->set( 'collection_data', $collection_data );
		$this->set( 'consent_data', $consent_data );				
		$this->set( 'diagnosis_data', $diagnosis_data );
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLink.id'=>$clinical_collection_link_id) );
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// Set collections list
		$collection_data = $this->Collection->find('all', array('conditions' => array('Collection.deleted' => '0', 'ClinicalCollectionLink.participant_id IS NULL', 'collection_property' => 'participant collection')));
		$this->set( 'collection_data', $collection_data );
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ConsentMaster.participant_id' => $participant_id)));
		$this->set( 'consent_data', $consent_data );
	
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id)));
		$this->set( 'diagnosis_data', $diagnosis_data );
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('view_diagnosis', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		// MANAGE DATA RECORD
		
		if ( !empty($this->data) ) {
			// Launch Save Process
			
			$this->data['ClinicalCollectionLink']['participant_id'] = $participant_id;
			$tmp_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.collection_id' => $this->data['ClinicalCollectionLink']['collection_id'])));
			$this->ClinicalCollectionLink->id = $tmp_data['ClinicalCollectionLink']['id'];
			if(strlen($this->ClinicalCollectionLink->id) == 0){
				$this->data['ClinicalCollectionLink']['deleted'] = 1;
			} 
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ( $submitted_data_validates && $this->ClinicalCollectionLink->save($this->data) ) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
			
				if(isset($this->data['ClinicalCollectionLink']['deleted'])){
					$this->redirect('/inventorymanagement/collections/add/'.$this->ClinicalCollectionLink->getLastInsertId());
				}else{
					$this->atimFlash( 'your data has been updated','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$this->ClinicalCollectionLink->id );
				}
				return;
			}
		}
	}
	
	function edit( $participant_id, $clinical_collection_link_id) {
		// MANAGE DATA
	
		$clinical_collection_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_link_id,'ClinicalCollectionLink.participant_id'=>$participant_id)));
		if(empty($clinical_collection_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	
		
		// Set collection data	
		$collection_data = $this->Collection->find('all', array('conditions' => array('ClinicalCollectionLink.id' => $clinical_collection_link_id)));
		$this->set( 'collection_data', $collection_data );
		
		// Set consents list
		$consent_data = $this->ConsentMaster->find('all', array('conditions' => array('ConsentMaster.deleted' => '0', 'ConsentMaster.participant_id' => $participant_id)));
		//because consent has a one to many relation with participant, we need to format it
		$consent_found = false;
		foreach($consent_data as &$consent){
			foreach($consent['ClinicalCollectionLink'] as $unit){
				if($unit['id'] == $clinical_collection_link_id){
					//we found the one that interests us
					$consent['ClinicalCollectionLink'] = $unit;
					$consent_found = true;
					goto consent_end;
				}
			}
		}
		consent_end:
		
		$this->set('consent_data', $consent_data );
		$this->set('found_consent', $consent_found);
		
		// Set diagnoses list
		$diagnosis_data = $this->DiagnosisMaster->find('threaded', array('conditions' => array('DiagnosisMaster.deleted' => '0', 'DiagnosisMaster.participant_id' => $participant_id)));
		//because diagnosis has a one to many relation with participant, we need to format it
		$found_dx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosis_data, $clinical_collection_data['ClinicalCollectionLink']['diagnosis_master_id'], 'ClinicalCollectionLink');

		$this->set( 'diagnosis_data', $diagnosis_data );
		$this->set('found_dx', $found_dx);
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/clinical_collection_links/listall/') );
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ClinicalCollectionLinks.id'=>$clinical_collection_link_id) );
		
		$this->Structures->set('collections', 'atim_structure_collection_detail');
		$this->Structures->set('consent_masters', 'atim_structure_consent_detail');
		$this->Structures->set('diagnosismasters', 'atim_structure_diagnosis_detail');
		$this->Structures->set('empty', 'empty_structure');
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
			
		// MANAGE DATA RECORD
		
		if ( !empty($this->data) ) {
			// Launch Save Process
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
			if ($submitted_data_validates && $this->ClinicalCollectionLink->save($this->data) ) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				$this->atimFlash( 'your data has been updated','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id );
				return;
			}
		} else {
			// Launch Initial Display Process
			$this->data = $clinical_collection_data;
		}
	}

	function delete( $participant_id, $clinical_collection_link_id ) {
		if (( !$participant_id ) || ( !$clinical_collection_link_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA		
		
		$clinical_collection_data = $this->ClinicalCollectionLink->find('first',array('conditions'=>array('ClinicalCollectionLink.id'=>$clinical_collection_link_id,'ClinicalCollectionLink.participant_id'=>$participant_id)));
		if(empty($clinical_collection_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		$arr_allow_deletion = $this->ClinicalCollectionLink->allowDeletion($clinical_collection_link_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if($arr_allow_deletion['allow_deletion']) {
			$this->data = array('ClinicalCollectionLink' => array(
				'collection_id' => $clinical_collection_data['ClinicalCollectionLink']['collection_id'],
				'participant_id' => null,
				'diagnosis_master_id' => null,
				'consent_master_id' => null));
				
			$this->ClinicalCollectionLink->id = $clinical_collection_link_id;
			if ($this->ClinicalCollectionLink->save($this->data)){
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				
				$this->atimFlash( 'your data has been deleted' , '/clinicalannotation/clinical_collection_links/listall/'.$participant_id.'/');
			}else{
				$this->flash( 'error deleting data - contact administrator','/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id.'/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/clinical_collection_links/detail/'.$participant_id.'/'.$clinical_collection_link_id);
		}
	}
}

?>