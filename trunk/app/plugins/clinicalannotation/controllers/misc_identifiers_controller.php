<?php

class MiscIdentifiersController extends ClinicalannotationAppController {

	var $components = array(); 
		
	var $uses = array(
		'Clinicalannotation.MiscIdentifier',
		'Clinicalannotation.Participant',
		'Clinicalannotation.MiscIdentifierControl'
	);
	
	var $paginate = array('MiscIdentifier'=>array('limit' => pagination_amount,'order'=>'MiscIdentifierControl.misc_identifier_name ASC, MiscIdentifier.identifier_value ASC'));
	
	function index() {
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/participants/index'));
						
		$_SESSION['ctrapp_core']['search'] = null; // clear SEARCH criteria
		
		$this->Structures->set('miscidentifiers_for_participant_search');
				
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function search() {
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/participants/index'));
		$this->Structures->set('miscidentifiers_for_participant_search');
			
		if($this->data) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions($this->viewVars['atim_structure']);
							
		$this->data = $this->paginate($this->MiscIdentifier, $_SESSION['ctrapp_core']['search']['criteria']);

		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['MiscIdentifier']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/clinicalannotation/misc_identifiers/search';
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
		
	}
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		$this->data = $this->paginate($this->MiscIdentifier, array('MiscIdentifier.participant_id'=>$participant_id));
		$conditions = array('flag_active' => '1');
		if(!$_SESSION['Auth']['User']['flag_show_confidential']){
			$conditions["flag_confidential"] = 0;
		}
		$this->set('identifier_controls_list', $this->MiscIdentifierControl->find('all', array('conditions' => $conditions)));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $misc_identifier_id ) {
		if ( !$participant_id && !$misc_identifier_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id)));		
		if(empty($misc_identifier_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		$this->data = $misc_identifier_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function add( $participant_id, $misc_identifier_control_id ) {
		if ( ( !$participant_id ) || ( !$misc_identifier_control_id ) ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		$controls = $this->MiscIdentifierControl->find('first', array('conditions' => array('MiscIdentifierControl.id' => $misc_identifier_control_id)));
		if($controls['MiscIdentifierControl']['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
			AppController::getInstance()->redirect("/pages/err_confidential");
		}
		if(empty($controls)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		if($controls['MiscIdentifierControl']['flag_once_per_participant']) {
			// Check identifier has not already been created
			$already_exist = $this->MiscIdentifier->find('count', array('conditions' => array('misc_identifier_control_id' => $misc_identifier_control_id, 'participant_id' => $participant_id)));
			if($already_exist) {
				$this->flash( 'this identifier has already been created for this participant','/clinicalannotation/misc_identifiers/listall/'.$participant_id.'/' );
				return;
			}
		}
		
		$is_incremented_identifier = (empty($controls['MiscIdentifierControl']['autoincrement_name'])? false: true);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifierControl.id' => $misc_identifier_control_id));
		
		$form_alias = $is_incremented_identifier? 'incrementedmiscidentifiers' : 'miscidentifiers';
		$this->Structures->set($form_alias);
		
		// Following boolean created to allow hook to force the add form display when identifier is incremented 
		$display_add_form = true;
		if($is_incremented_identifier && empty($this->data)) $display_add_form = false;
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
				
		if ( empty($this->data) && $display_add_form) {	
			$this->data = array();			
			$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
			$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
			
		} else {
			// Launch Save Process
			
			// Set additional data
			$this->data['MiscIdentifier']['participant_id'] = $participant_id;
			$this->data['MiscIdentifier']['misc_identifier_control_id'] = $misc_identifier_control_id;
			$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name']; 
			$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
			
			// Launch validation
			$submitted_data_validates = true;
			// ... special validations
				
			$this->MiscIdentifier->set($this->data);
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
					if($new_identifier_value === false) { $this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true ); }
					$this->data['MiscIdentifier']['identifier_value'] = $new_identifier_value; 
				}
			
				// Save data
				if ( $this->MiscIdentifier->save($this->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash( 'your data has been saved','/clinicalannotation/misc_identifiers/listall/'.$participant_id.'/'.$this->MiscIdentifier->id );
				}
			}
		}
	}
	
	function edit( $participant_id, $misc_identifier_id) {
		if ( !$participant_id && !$misc_identifier_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		
		$belongs_to_details = array(
			'belongsTo' => array(
				'MiscIdentifierControl' => array(
					'className' => 'Clinicalannotation.MiscIdentifierControl',
					'foreignKey' => 'misc_identifier_control_id')));

		$this->MiscIdentifier->bindModel($belongs_to_details);						
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '0'));
		if($misc_identifier_data['MiscIdentifierControl']['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
			AppController::getInstance()->redirect("/pages/err_confidential");
		}		
		$this->MiscIdentifier->unbindModel(array('belongsTo' => array('MiscIdentifierControl')));

		if(empty($misc_identifier_data) || (!isset($misc_identifier_data['MiscIdentifierControl'])) || empty($misc_identifier_data['MiscIdentifierControl']['id'])) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$is_incremented_identifier = (empty($misc_identifier_data['MiscIdentifierControl']['autoincrement_name'])? false: true);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );

		$form_alias = $is_incremented_identifier? 'incrementedmiscidentifiers' : 'miscidentifiers';
		$this->Structures->set($form_alias);
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
		
		if(empty($this->data)) {
			$this->data = $misc_identifier_data;	
				
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
				if ( $this->MiscIdentifier->save($this->data) ) {
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					
					$this->atimFlash( 'your data has been updated','/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$misc_identifier_id );
				}
			}
		}
	}

	function delete( $participant_id, $misc_identifier_id ) {
		if ( !$participant_id && !$misc_identifier_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($misc_identifier_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$arr_allow_deletion = $this->MiscIdentifier->allowDeletion($misc_identifier_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if( $this->MiscIdentifier->atim_delete( $misc_identifier_id ) ) {
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { require($hook_link); }
				
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$misc_identifier_id);
		}	
	}
}

?>