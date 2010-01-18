<?php

class ConsentMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.ConsentDetail',
		'Clinicalannotation.ConsentControl',
		'Clinicalannotation.Participant',
		'Provider.Provider'
	);
	
	var $paginate = array('ConsentMaster'=>array('limit'=>10,'order'=>'ConsentMaster.date_first_contact ASC')); 

	function listall( $participant_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$this->data = $this->paginate($this->ConsentMaster, array('ConsentMaster.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->set('consent_controls_list', $this->ConsentControl->find('all', array('conditions' => array('ConsentControl.status' => 'active'))));
		$this->Structures->set('consent_masters');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}	

	function detail( $participant_id, $consent_master_id) {
		if (( !$participant_id ) && ( !$consent_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	
		
		// MANAGE DATA
		$consent_master_data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id, 'ConsentMaster.participant_id'=>$participant_id)));
		if(empty($consent_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		$this->data = $consent_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentMaster.id'=>$consent_master_id) );
		$consent_control_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $this->data['ConsentMaster']['consent_control_id'])));
		$this->Structures->set($consent_control_data['ConsentControl']['form_alias']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id=null, $consent_control_id=null ) {
		if (( !$participant_id ) && ( !$consent_control_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentControl.id' => $consent_control_id) );
		$consent_control_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $consent_control_id)));
		$this->Structures->set($consent_control_data['ConsentControl']['form_alias']);
		$this->Structures->set('empty', 'empty_structure');
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['ConsentMaster']['participant_id'] = $participant_id;
			$this->data['ConsentMaster']['consent_control_id'] = $consent_control_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
			
			if($submitted_data_validates) {
				if ( $this->ConsentMaster->save($this->data) ) {
					$this->flash( 'your data has been saved','/clinicalannotation/consent_masters/detail/'.$participant_id.'/'.$this->ConsentMaster->id );
				}
			}
		} 
	}

	function edit( $participant_id, $consent_master_id ) {
		if (( !$participant_id ) && ( !$consent_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	
		
		// MANAGE DATA
		$consent_master_data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id, 'ConsentMaster.participant_id'=>$participant_id)));
		if(empty($consent_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentMaster.id'=>$consent_master_id) );
		$consent_control_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $consent_master_data['ConsentMaster']['consent_control_id'])));
		$this->Structures->set($consent_control_data['ConsentControl']['form_alias']);		
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->data)) {
			$this->data = $consent_master_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
		
			if($submitted_data_validates) {
				$this->ConsentMaster->id = $consent_master_id;
				if ( $this->ConsentMaster->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/consent_masters/detail/'.$participant_id.'/'.$consent_master_id );
				}
			}
		}
	}

	function delete( $participant_id, $consent_master_id ) {
		if (( !$participant_id ) && ( !$consent_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$consent_master_data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id, 'ConsentMaster.participant_id'=>$participant_id)));
		if(empty($consent_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$arr_allow_deletion = $this->allowConsentDeletion($consent_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ($this->ConsentMaster->atim_delete( $consent_master_id )) {
				$this->flash( 'your data has been deleted', '/clinicalannotation/consent_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/consent_masters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/consent_masters/detail/'.$participant_id.'/'.$consent_master_id);
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $consent_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowConsentDeletion($consent_master_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}	
	
}

?>