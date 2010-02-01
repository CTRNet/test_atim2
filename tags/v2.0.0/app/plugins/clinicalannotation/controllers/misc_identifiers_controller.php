<?php

class MiscIdentifiersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.MiscIdentifier',
		'Clinicalannotation.Participant',
		'Clinicalannotation.MiscIdentifierControl'
	);
	var $paginate = array('MiscIdentifier'=>array('limit'=>10,'order'=>'MiscIdentifier.identifier_name ASC'));
	
	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		$this->data = $this->paginate($this->MiscIdentifier, array('MiscIdentifier.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('add_options', $this->MiscIdentifierControl->find('all'));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $misc_identifier_id ) {
		if ( !$participant_id && !$misc_identifier_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($misc_identifier_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		$this->data = $misc_identifier_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function add( $participant_id=null, $control_id ) {
		$must_save = !empty($this->data);
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
	
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		$controls = $this->MiscIdentifierControl->find('first', array('conditions' => array('MiscIdentifierControl.id' => $control_id)));
		$this->data['MiscIdentifier']['identifier_name'] = $controls['MiscIdentifierControl']['misc_identifier_name'];
		$this->data['MiscIdentifier']['identifier_abrv'] = $controls['MiscIdentifierControl']['misc_identifier_name_abbrev'];
		$this->data['MiscIdentifier']['identifier_value'] = $controls['MiscIdentifierControl']['misc_identifier_value'];
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('control_id', $control_id);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( $must_save ) {
			$this->data['MiscIdentifier']['participant_id'] = $participant_id;
			$this->data['MiscIdentifier']['identifier_value'] = $this->MiscIdentifierControl->getKeyIncrement($controls['MiscIdentifierControl']['autoincrement_name'], $controls['MiscIdentifierControl']['misc_identifier_value']); 
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
			
			if($submitted_data_validates) {
				if ( $this->MiscIdentifier->save($this->data) ) {
					$this->flash( 'your data has been saved','/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$this->MiscIdentifier->id );
				}
			}
		}
		
	}
	
	function edit( $participant_id, $misc_identifier_id) {
		if ( !$participant_id && !$misc_identifier_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($misc_identifier_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'MiscIdentifier.id'=>$misc_identifier_id) );
		
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
			if( $hook_link ) { require($hook_link); }	
			
			if($submitted_data_validates) {
				$this->MiscIdentifier->id = $misc_identifier_id;
				if ( $this->MiscIdentifier->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$misc_identifier_id );
				}
			}
		}
	}

	function delete( $participant_id, $misc_identifier_id ) {
		if ( !$participant_id && !$misc_identifier_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$misc_identifier_data = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.id'=>$misc_identifier_id, 'MiscIdentifier.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($misc_identifier_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$arr_allow_deletion = $this->allowMiscIdentifierDeletion($misc_identifier_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if( $this->MiscIdentifier->atim_delete( $misc_identifier_id ) ) {
				$this->flash( 'your data has been deleted', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/misc_identifiers/listall/'.$participant_id );
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/misc_identifiers/detail/'.$participant_id.'/'.$misc_identifier_id);
		}	
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $misc_identifier_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */	
	 
	function allowMiscIdentifierDeletion( $misc_identifier_id ) {
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }
		return array('allow_deletion' => true, 'msg' => '');
	}	
}

?>