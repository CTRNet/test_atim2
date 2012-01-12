<?php

class MiscIdentifiersController extends ClinicalAnnotationAppController {

	var $components = array(); 
		
	var $uses = array(
		'ClinicalAnnotation.MiscIdentifier',
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.MiscIdentifierControl'
	);
	
	var $paginate = array('MiscIdentifier'=>array('limit' => pagination_amount,'order'=>'MiscIdentifierControl.misc_identifier_name ASC, MiscIdentifier.identifier_value ASC'));

	function search($search_id = '') {
		$this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
		
		$this->searchHandler($search_id, $this->MiscIdentifier, 'miscidentifiers_for_participant_search', '/ClinicalAnnotation/MiscIdentifiers/search');
				
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
		
	}
	
	function listall( $participant_id ) {
		$this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__);

		// MANAGE DATA
		$this->request->data = $this->paginate($this->MiscIdentifier, array('MiscIdentifier.participant_id'=>$participant_id));
		$conditions = array('flag_active' => '1');
		if(!$_SESSION['Auth']['User']['flag_show_confidential']){
			$conditions["flag_confidential"] = 0;
		}
		
		$mi = $this->MiscIdentifier->find('all', array(
			'fields' => array('MiscIdentifierControl.id'), 
			'conditions' => array('MiscIdentifier.deleted' => 1, 'MiscIdentifier.tmp_deleted' => 1),
			'group' => array('MiscIdentifierControl.id')
		));
		$reusable = array();
		foreach($mi as $mi_unit){
			$reusable[$mi_unit['MiscIdentifierControl']['id']] = null;
		}
		$identifier_controls_list = $this->MiscIdentifierControl->find('all', array('conditions' => $conditions));
		foreach($identifier_controls_list as &$unit){
			if(!empty($unit['MiscIdentifierControl']['autoincrement_name']) && array_key_exists($unit['MiscIdentifierControl']['id'], $reusable)){
				$unit['reusable'] = true;
			}
		} 
		$this->set('identifier_controls_list', $identifier_controls_list);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function detail( $participant_id, $misc_identifier_id ) {
		$this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__);
		$this->MiscIdentifier->redirectIfNonExistent($misc_identifier_id, __METHOD__, __LINE__);

		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id)));		
		if(empty($misc_identifier_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		$this->request->data = $misc_identifier_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function add( $participant_id, $misc_identifier_control_id) {
		$this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__);
		$this->MiscIdentifierControl->redirectIfNonExistent($misc_identifier_control_id, __METHOD__, __LINE__);

		// MANAGE DATA
		$controls = $this->MiscIdentifierControl->find('first', array('conditions' => array('MiscIdentifierControl.id' => $misc_identifier_control_id)));
		if($controls['MiscIdentifierControl']['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
			AppController::getInstance()->redirect("/Pages/err_confidential");
		}
		
		if($controls['MiscIdentifierControl']['flag_once_per_participant']) {
			// Check identifier has not already been created
			$already_exist = $this->MiscIdentifier->find('count', array('conditions' => array('misc_identifier_control_id' => $misc_identifier_control_id, 'participant_id' => $participant_id)));
			if($already_exist) {
				$this->flash( 'this identifier has already been created for this participant','/ClinicalAnnotation/MiscIdentifiers/listall/'.$participant_id.'/' );
				return;
			}
		}
		
		$is_incremented_identifier = !empty($controls['MiscIdentifierControl']['autoincrement_name']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifierControl.id' => $misc_identifier_control_id));
		
		$form_alias = $is_incremented_identifier? 'incrementedmiscidentifiers' : 'miscidentifiers';
		$this->Structures->set($form_alias);
		
		// Following boolean created to allow hook to force the add form display when identifier is incremented 
		$display_add_form = true;
		if($is_incremented_identifier && empty($this->request->data)) $display_add_form = false;
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}	
				
		if ( empty($this->request->data) && $display_add_form) {	
			$this->request->data = $controls;			
			
		} else {
			// Launch Save Process
			
			// Set additional data
			$this->request->data['MiscIdentifier']['participant_id'] = $participant_id;
			$this->request->data['MiscIdentifier']['misc_identifier_control_id'] = $misc_identifier_control_id;
			
			// Launch validation
			$submitted_data_validates = true;
			// ... special validations
				
			$this->MiscIdentifier->set($this->request->data);
			$submitted_data_validates = ($this->MiscIdentifier->validates())? $submitted_data_validates: false; 
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
			
			if($submitted_data_validates) {
				// Set incremented identifier if required
				if($is_incremented_identifier) {
					$new_identifier_value = $this->MiscIdentifierControl->getKeyIncrement($controls['MiscIdentifierControl']['autoincrement_name'], $controls['MiscIdentifierControl']['misc_identifier_format']);
					if($new_identifier_value === false) { $this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true ); }
					$this->request->data['MiscIdentifier']['identifier_value'] = $new_identifier_value; 
				}
			
				// Save data
				if ( $this->MiscIdentifier->save($this->request->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash( 'your data has been saved','/ClinicalAnnotation/MiscIdentifiers/listall/'.$participant_id.'/'.$this->MiscIdentifier->id );
				}
			}
		}
	}
	
	function edit( $participant_id, $misc_identifier_id) {
		$this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__);
		$this->MiscIdentifier->redirectIfNonExistent($misc_identifier_id, __METHOD__, __LINE__);
		
		// MANAGE DATA
		
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '0'));
		if($misc_identifier_data['MiscIdentifierControl']['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
			AppController::getInstance()->redirect("/Pages/err_confidential");
		}		
		
		if(empty($misc_identifier_data) || (!isset($misc_identifier_data['MiscIdentifierControl'])) || empty($misc_identifier_data['MiscIdentifierControl']['id'])) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$is_incremented_identifier = !empty($misc_identifier_data['MiscIdentifierControl']['autoincrement_name']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );

		$form_alias = $is_incremented_identifier? 'incrementedmiscidentifiers' : 'miscidentifiers';
		$this->Structures->set($form_alias);
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		if(empty($this->request->data)) {
			$this->request->data = $misc_identifier_data;	
				
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
			
			if($submitted_data_validates) {
				$this->MiscIdentifier->id = $misc_identifier_id;
				if ( $this->MiscIdentifier->save($this->request->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/MiscIdentifiers/detail/'.$participant_id.'/'.$misc_identifier_id );
				}
			}
		}
	}

	function delete( $participant_id, $misc_identifier_id ) {
		$this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__);
		$this->MiscIdentifier->redirectIfNonExistent($misc_identifier_id, __METHOD__, __LINE__);
		
		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array(
			'MiscIdentifier.id' => $misc_identifier_id, 
			'MiscIdentifier.participant_id' => $participant_id))
		);		
		if(empty($misc_identifier_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$arr_allow_deletion = $this->MiscIdentifier->allowDeletion($misc_identifier_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}		
		
		if($arr_allow_deletion['allow_deletion']) {
			$deletion_worked = false;
			if(empty($misc_identifier_data['MiscIdentifierControl']['autoincrement_name'])){
				//real delete
				$deletion_worked = $this->MiscIdentifier->atim_delete( $misc_identifier_id );

			}else{
				//tmp delete to be able to reuse it
				$mi = array("id" => $misc_identifier_id, 'participant_id' => null, 'tmp_deleted' => 1, 'deleted' => 1);
				$deletion_worked = $this->MiscIdentifier->save($mi);
			}
			
			if($deletion_worked){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/MiscIdentifiers/listall/'.$participant_id );
				
			}else{
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/MiscIdentifiers/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/MiscIdentifiers/detail/'.$participant_id.'/'.$misc_identifier_id);
		}	
	}
	
	function reuse($participant_id, $misc_identifier_ctrl_id, $submited = false){
		$this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__);
		$this->MiscIdentifierControl->redirectIfNonExistent($misc_identifier_ctrl_id, __METHOD__, __LINE__);
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifierControl.id'=>$misc_identifier_ctrl_id) );
		$this->Structures->set('misc_identifier_value');
		
		$mi_control = $this->MiscIdentifierControl->findById($misc_identifier_ctrl_id);
		if($mi_control['MiscIdentifierControl']['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
			AppController::getInstance()->redirect("/Pages/err_confidential");
		}
		
		$this->set('title', $mi_control['MiscIdentifierControl']['misc_identifier_name']);
		$data_to_display = $this->MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.participant_id' => null, 'MiscIdentifier.deleted' => 1, 'MiscIdentifier.tmp_deleted' => 1, 'MiscIdentifierControl.id' => $misc_identifier_ctrl_id), 'recursive' => 0));
		
		//LOCKING TABLE - Make sure to have unlock at all exit points
		$this->MiscIdentifier->query('LOCK TABLE misc_identifiers AS MiscIdentifier WRITE, participants AS Participant WRITE, misc_identifier_controls AS MiscIdentifierControl WRITE, misc_identifiers WRITE, misc_identifiers_revs WRITE');
		if($mi_control['MiscIdentifierControl']['flag_once_per_participant']){
			$count = $this->MiscIdentifier->find('count', array('conditions' => array('MiscIdentifier.participant_id' => $participant_id, 'MiscIdentifier.misc_identifier_control_id' => $misc_identifier_ctrl_id), 'recursive' => -1));
			if($count > 0){
				$this->MiscIdentifier->query('UNLOCK TABLES');
				$this->flash( 'this identifier has already been created for this participant','/ClinicalAnnotation/MiscIdentifiers/listall/'.$participant_id.'/' );
				return;
			}
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if($submited){
			if(isset($this->request->data['MiscIdentifier']['selected_id']) && is_numeric($this->request->data['MiscIdentifier']['selected_id'])){
				$submitted_data_validates = true;
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) {
					require($hook_link);
				}
					
				if($submitted_data_validates) {
					$mi = $this->MiscIdentifier->find('first', array('conditions' => array('MiscIdentifier.participant_id' => null, 'MiscIdentifier.deleted' => 1, 'MiscIdentifier.tmp_deleted' => 1, 'MiscIdentifier.misc_identifier_control_id' => $misc_identifier_ctrl_id, 'MiscIdentifier.id' => $this->request->data['MiscIdentifier']['selected_id']), 'recursive' => -1));
					
					if(!empty($mi)){
						$mi['MiscIdentifier']['tmp_deleted'] = 0;
						$mi['MiscIdentifier']['deleted'] = 0;
						$mi['MiscIdentifier']['participant_id'] = $participant_id;
						$this->MiscIdentifier->save($mi, array('fieldList' => array('tmp_deleted', 'deleted', 'participant_id')));
					}
					
					$this->MiscIdentifier->query('UNLOCK TABLES');
					
					$mi = $this->MiscIdentifier->find('first', array('conditions' => array('MiscIdentifier.participant_id' => $participant_id, 'MiscIdentifier.id' => $this->request->data['MiscIdentifier']['selected_id'])));
					if(empty($mi)){
						$this->MiscIdentifier->validationErrors[] = 'by the time you submited your selection, the identifier was either used or removed from the system';
					}else{
						$hook_link = $this->hook('postsave_process');
						if( $hook_link ) {
							require($hook_link);
						}
						$this->atimFlash( 'your data has been saved', '/ClinicalAnnotation/MiscIdentifiers/listall/'.$participant_id );
					}
				}
			}else{
				$this->MiscIdentifier->query('UNLOCK TABLES');
				$this->MiscIdentifier->validationErrors[] = 'you need to select an identifier value';
			}
		}
		$this->MiscIdentifier->query('UNLOCK TABLES');
		$this->request->data = $data_to_display;
		
		if(empty($this->request->data)){
			AppController::addWarningMsg(__('there are no unused identifiers left to reuse. hit cancel to return to the identifiers list.'));
		}
		
	}
}

?>