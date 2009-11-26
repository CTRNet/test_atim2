<?php

class FamilyHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'Clinicalannotation.FamilyHistory',
		'Clinicalannotation.Participant');
	
	var $paginate = array('FamilyHistory'=>array('limit'=>10,'order'=>'FamilyHistory.relation'));
	
	/* --------------------------------------------------------------------------
	 * DISPLAY FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
/* ==> Note: Create just 5 basic error pages per plugin as following lines:
 *   |-----------------------------|------------------------------|----------------------------------------------------------------|
 *   | id                          | language_title               | language_body                                                  |
 *   |-----------------------------|------------------------------|----------------------------------------------------------------|
 *   | err_..._deletion_err        | data deletion error          | the system is unable to delete correctly the data              |
 *   | err_..._funct_param_missing | parameter missing            | a paramater used by the executed function has not been set     |
 *   | err_..._no_data             | data not found               | no data exists for the specified id                            |
 *   | err_..._record_err          | data creation - update error | an error occured during the creation or the update of the data |
 *   | err_..._system_error        | system error                 | a system error has been detetced                               |
 *   |-----------------------------|------------------------------|----------------------------------------------------------------|
 * 
 * 	All errors that could occured should be managed by the code and generated an error page if required! */	
 
/* ==> Note: Reuse flash() messages as they are into this controller! */ 
		 
	function listall( $participant_id ) {
/* ==> Note: Always validate all required values are set */
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }			

		// MANAGE DATA

		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
/* ==> Note: Always validate data linked to the created record exists */
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
				
		$this->data = $this->paginate($this->FamilyHistory, array('FamilyHistory.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
/* ==> Note: Uncomment following lines to override default structure and menu */
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/clinicalannotation/family_histories/listall/%%Participant.id%%'));
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $family_history_id ) {
		if (( !$participant_id ) && ( !$family_history_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	
		
		// MANAGE DATA
		
		$family_history_data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id, 'FamilyHistory.participant_id'=>$participant_id)));
/* ==> Note: Always validate data exists */
		if(empty($family_history_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		$this->data = $family_history_data;

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/clinicalannotation/family_histories/listall/%%Participant.id%%'));		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/clinicalannotation/family_histories/listall/%%Participant.id%%'));		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
				
		if ( !empty($this->data) ) {
			
			// LAUNCH SAVE PROCESS
			// 1- SET ADDITIONAL DATA	
			
/* ==> Note: Set all data that are not set into the form and that should be recorded */		
			$this->data['FamilyHistory']['participant_id'] = $participant_id;
			
			// 2- LAUNCH SPECIAL VALIDATION PROCESS	
			
/* ==> Note: Here are validations that should be done before save function
 * 		- Validation done according specific business rules 
 * 		- Validation done before first save call in case many saves on many models will be done 
 * 			(Use of $this->{$model}->validates()) */
			$submitted_data_validates = true;
			
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {
				
				// 4- SAVE
				
				if ( $this->FamilyHistory->save($this->data) ) {
					$this->flash( 'your data has been saved','/clinicalannotation/family_histories/detail/'.$participant_id.'/'.$this->FamilyHistory->id );
				}				
			}
		}
	}
	
	function edit( $participant_id=null, $family_history_id=null) {
		if (( !$participant_id ) && ( !$family_history_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	
		
		// MANAGE DATA
		
		$family_history_data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id, 'FamilyHistory.participant_id'=>$participant_id)));
		if(empty($family_history_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/clinicalannotation/family_histories/listall/%%Participant.id%%'));		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
		
		if(empty($this->data)) {
			$this->data = $family_history_data;
		} else {
			
			// 1- SET ADDITIONAL DATA	
			
			//....
			
			// 2- LAUNCH SPECIAL VALIDATION PROCESS	
			
			$submitted_data_validates = true;
			
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {
				
				// 4- SAVE
				
				$this->FamilyHistory->id = $family_history_id;
				if ( $this->FamilyHistory->save($this->data) ) {
					$this->flash( 'your data has been updated','/clinicalannotation/family_histories/detail/'.$participant_id.'/'.$family_history_id );
				}				
			}
		}
	}
	
	function delete( $participant_id=null, $family_history_id=null ) {
		if (( !$participant_id ) && ( !$family_history_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }	
		
		// MANAGE DATA
		
		$family_history_data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id, 'FamilyHistory.participant_id'=>$participant_id)));
		if(empty($family_history_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$arr_allow_deletion = $this->allowFamilyHistoryDeletion($family_history_id);
		
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			
			// DELETE DATA
			
			$flash_link = '/clinicalannotation/family_histories/listall/'.$participant_id;
			if ($this->FamilyHistory->atim_delete($family_history_id)) {
				$this->flash( 'your data has been deleted', $flash_link );
			} else {
				$this->flash( 'error deleting data - contact administrator', $flash_link );
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/family_histories/detail/'.$participant_id.'/'.$family_history_id);
		}	
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $family_history_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowFamilyHistoryDeletion($family_history_id){
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}	
}

?>