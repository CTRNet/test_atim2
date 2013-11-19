<?php

class FamilyHistoriesController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'ClinicalAnnotation.FamilyHistory',
		'ClinicalAnnotation.Participant',
		'CodingIcd.CodingIcd10Who',
		'CodingIcd.CodingIcd10Ca');
	
	var $paginate = array('FamilyHistory'=>array('limit' => pagination_amount,'order'=>'FamilyHistory.relation'));
	
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

		// MANAGE DATA

/* ==> Note: Always validate data linked to the created record exists */
		$participant_data = $this->Participant->getOrRedirect($participant_id);
				
		$this->request->data = $this->paginate($this->FamilyHistory, array('FamilyHistory.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
/* ==> Note: Uncomment following lines to override default structure and menu */
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $family_history_id ) {
		// MANAGE DATA
		
		$family_history_data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id, 'FamilyHistory.participant_id'=>$participant_id)));
/* ==> Note: Always validate data exists */
		if(empty($family_history_data)) { 
			
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		$this->request->data = $family_history_data;

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add( $participant_id=null ) {
		// MANAGE DATA
		
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( empty($this->request->data) ) {
			$this->request->data[] = array();
				
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
				
		} else {
			
			// Save process
			
			$errors = array();
			$line_counter = 0;
			foreach($this->request->data as $key => &$new_row) {
				$this->FamilyHistory->patchIcd10NullValues($new_row);
				$line_counter++;
				$this->FamilyHistory->data = array(); // *** To guaranty no merge will be done with previous data ***
				$this->FamilyHistory->set($new_row);
				if(!$this->FamilyHistory->validates()){
					foreach($this->FamilyHistory->validationErrors as $field => $msgs) {	
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors[$field][$msg][] = $line_counter;
					}
				}				
			}
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if(empty($errors)) {
				$this->FamilyHistory->addWritableField('participant_id');
				$this->FamilyHistory->writable_fields_mode = 'addgrid';
				foreach($this->request->data as $new_data) {
					$new_data['FamilyHistory']['participant_id'] = $participant_id;				
					$this->FamilyHistory->id = null;
					$this->FamilyHistory->data = array(); // *** To guaranty no merge will be done with previous data ***
					if(!$this->FamilyHistory->save( $new_data , false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				$this->atimFlash( 'your data has been saved', '/ClinicalAnnotation/FamilyHistories/listall/'.$participant_id );

			} else  {
				$this->FamilyHistory->validationErrors = array();
				foreach($errors as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$msg = __($msg);
						$lines_strg = implode(",", array_unique($lines));
						if(!empty($lines_strg)) {
							$msg .= ' - ' . str_replace('%s', $lines_strg, __('see line %s'));
						}
						$this->FamilyHistory->validationErrors[$field][] = $msg;
					}
				}	
			}
		}
	}
	
	function edit( $participant_id, $family_history_id) {
		
		// MANAGE DATA
		
		$family_history_data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id, 'FamilyHistory.participant_id'=>$participant_id)));
		if(empty($family_history_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		// $this->set('atim_structure', $this->Structures->get('form', 'familyhistories'));		
		// $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
		
		if(empty($this->request->data)) {
			$this->request->data = $family_history_data;
		} else {
			$this->FamilyHistory->patchIcd10NullValues($this->request->data);
			// 1- SET ADDITIONAL DATA	
			
			//....
			
			// 2- LAUNCH SPECIAL VALIDATION PROCESS	
			
			$submitted_data_validates = true;
			
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {
				
				// 4- SAVE
				
				$this->FamilyHistory->id = $family_history_id;
				if ( $this->FamilyHistory->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/FamilyHistories/detail/'.$participant_id.'/'.$family_history_id );
				}				
			}
		}
	}
	
	function delete( $participant_id, $family_history_id ) {
		
		// MANAGE DATA
		
		$family_history_data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id, 'FamilyHistory.participant_id'=>$participant_id)));
		if(empty($family_history_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	

		$arr_allow_deletion = $this->FamilyHistory->allowDeletion($family_history_id);
		
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			
			// DELETE DATA
			
			$flash_link = '/ClinicalAnnotation/FamilyHistories/listall/'.$participant_id;
			if ($this->FamilyHistory->atimDelete($family_history_id)) {
				$this->atimFlash( 'your data has been deleted', $flash_link );
			} else {
				$this->flash( 'error deleting data - contact administrator', $flash_link );
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/FamilyHistories/detail/'.$participant_id.'/'.$family_history_id);
		}	
	}
}

?>