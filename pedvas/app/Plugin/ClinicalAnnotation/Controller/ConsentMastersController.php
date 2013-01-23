<?php

class ConsentMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.ConsentMaster',
		'ClinicalAnnotation.ConsentDetail',
		'ClinicalAnnotation.ConsentControl',
		'ClinicalAnnotation.Participant'
	);
	
	var $paginate = array('ConsentMaster'=>array('limit' => pagination_amount,'order'=>'ConsentMaster.date_first_contact ASC')); 

	function listall( $participant_id ) {
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$this->request->data = $this->paginate($this->ConsentMaster, array('ConsentMaster.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->set('consent_controls_list', $this->ConsentControl->find('all', array('conditions' => array('ConsentControl.flag_active' => '1'))));
		$this->Structures->set('consent_masters');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}	

	function detail( $participant_id, $consent_master_id) {
		
		// MANAGE DATA
		$consent_master_data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id, 'ConsentMaster.participant_id'=>$participant_id)));
		if(empty($consent_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->request->data = $consent_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentMaster.id'=>$consent_master_id) );
		$consent_control_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $this->request->data['ConsentMaster']['consent_control_id'])));
		$this->Structures->set($consent_control_data['ConsentControl']['form_alias']);
		
		$this->set('consent_type', $consent_control_data['ConsentControl']['controls_type']);
		$this->set('is_ajax', $this->request->is('ajax'));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add( $participant_id, $consent_control_id) {

		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentControl.id' => $consent_control_id) );
		$consent_control_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $consent_control_id)));
		$this->Structures->set($consent_control_data['ConsentControl']['form_alias']);
		$this->Structures->set('empty', 'empty_structure');
				
		$this->set('consent_type', $consent_control_data['ConsentControl']['controls_type']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->request->data) ) {
			$this->request->data['ConsentMaster']['participant_id'] = $participant_id;
			$this->request->data['ConsentMaster']['consent_control_id'] = $consent_control_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
			
			if($submitted_data_validates) {
				$this->ConsentMaster->addWritableField(array('participant_id', 'consent_control_id'));
				if ( $this->ConsentMaster->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved','/ClinicalAnnotation/ConsentMasters/detail/'.$participant_id.'/'.$this->ConsentMaster->id );
				}
			}
		} 
	}

	function edit( $participant_id, $consent_master_id ) {
		
		// MANAGE DATA
		$consent_master_data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id, 'ConsentMaster.participant_id'=>$participant_id)));
		if(empty($consent_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ConsentMaster.id'=>$consent_master_id) );
		$consent_control_data = $this->ConsentControl->find('first', array('conditions' => array('ConsentControl.id' => $consent_master_data['ConsentMaster']['consent_control_id'])));
		$this->Structures->set($consent_control_data['ConsentControl']['form_alias']);		
		
		$this->set('consent_type', $consent_control_data['ConsentControl']['controls_type']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}

		if(empty($this->request->data)) {
			$this->request->data = $consent_master_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
		
			if($submitted_data_validates) {
				$this->ConsentMaster->id = $consent_master_id;
				if ( $this->ConsentMaster->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/ConsentMasters/detail/'.$participant_id.'/'.$consent_master_id );
				}
			}
		}
	}

	function delete( $participant_id, $consent_master_id ) {
		// MANAGE DATA
		$consent_master_data = $this->ConsentMaster->find('first',array('conditions'=>array('ConsentMaster.id'=>$consent_master_id, 'ConsentMaster.participant_id'=>$participant_id)));
		if(empty($consent_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$arr_allow_deletion = $this->ConsentMaster->allowDeletion($consent_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ($this->ConsentMaster->atimDelete( $consent_master_id )) {
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/ConsentMasters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/ConsentMasters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/ConsentMasters/detail/'.$participant_id.'/'.$consent_master_id);
		}
	}
}

?>