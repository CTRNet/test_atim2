<?php

class TreatmentMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster', 
		'Clinicalannotation.TreatmentExtend',
		'Clinicalannotation.TreatmentControl', 
		'Clinicalannotation.DiagnosisMaster',
		'Protocol.ProtocolMaster'
	);
	
	var $paginate = array('TreatmentMaster'=>array('limit' => pagination_amount,'order'=>'TreatmentMaster.start_date DESC'));

	function listall($participant_id, $trt_control_id = null) {
		// set FILTER, used as this->data CONDITIONS
		if ( !isset($_SESSION['TrtMaster_filter']) || !$trt_control_id ) {
			$_SESSION['TrtMaster_filter'] = array();
			$_SESSION['TrtMaster_filter']['TreatmentMaster.participant_id'] = $participant_id;
			
			$this->Structures->set('treatmentmasters');
		} else {
			$_SESSION['TrtMaster_filter']['TreatmentMaster.treatment_control_id'] = $trt_control_id;
			
			$filter_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$trt_control_id)));
			if(empty($filter_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
			$this->Structures->set($filter_data['TreatmentControl']['form_alias']);
		}
				
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		$this->data = $this->paginate($this->TreatmentMaster, $_SESSION['TrtMaster_filter']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// find all TXCONTROLS, for ADD form
		$this->set('treatment_controls', $this->TreatmentControl->find('all', array('conditions' => array('TreatmentControl.flag_active' => "1"))));

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function detail($participant_id, $tx_master_id, $is_ajax = 0){
		if (( !$participant_id ) && ( !$tx_master_id )) { 
			$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->data = $treatment_master_data;

		$this->set('diagnosis_data', $this->DiagnosisMaster->getRelatedDiagnosisEvents($this->data['TreatmentMaster']['diagnosis_master_id']));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id));
		
		// set structure alias based on control data
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'diagnosis_structure');
		$this->set('is_ajax', $is_ajax);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}		
	}
	
	function edit( $participant_id, $tx_master_id ) {
		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		

		if(!empty($treatment_master_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			ProtocolMaster::$protocol_dropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($treatment_master_data['TreatmentControl']['applied_protocol_control_id']);
		}
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		$dx_id = isset($this->data['TreatmentMaster']['diagnosis_master_id']) ? $this->data['TreatmentMaster']['diagnosis_master_id'] : $treatment_master_data['TreatmentMaster']['diagnosis_master_id'];
		$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $dx_id, 'TreatmentMaster');
		
		$this->set('radio_checked', $dx_id > 0);
		$this->set('data_for_checklist', $dx_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($treatment_master_data['TreatmentControl']['form_alias']);
		$this->Structures->Set('empty', 'empty_structure');
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->data)) {
			$this->data = $treatment_master_data;
		} else {
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
						
			if($submitted_data_validates) {
				$this->TreatmentMaster->id = $tx_master_id;
				if ($this->TreatmentMaster->save($this->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
				}
			}
		}
	}
	
	function add($participant_id, $tx_control_id) {
		// MANAGE DATA
		$participant_data = $this->Participant->redirectIfNonExistent($participant_id, __METHOD__, __LINE__, true);
		
		$tx_control_data = $this->TreatmentControl->redirectIfNonExistent($tx_control_id, __METHOD__, __LINE__, true);

		if(!empty($tx_control_data['TreatmentControl']['applied_protocol_control_id'])) {
			$available_protocols = array();
			ProtocolMaster::$protocol_dropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($tx_control_data['TreatmentControl']['applied_protocol_control_id']);
		}

		$this->set('initial_display', (empty($this->data)? true : false));
			
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		if(isset($this->data['TreatmentMaster']['diagnosis_master_id'])){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $this->data['TreatmentMaster']['diagnosis_master_id'], 'TreatmentMaster');
		}
		
		$this->set('data_for_checklist', $dx_data);					
				
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$tx_control_id));
		
		// Override generated menu to prevent selection of Administration menu item on ADD action
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/treatment_masters/listall/%%Participant.id%%'));
		
		// Set trt header
		$this->set('tx_header', __($tx_control_data['TreatmentControl']['disease_site'], true) . ' - ' . __($tx_control_data['TreatmentControl']['tx_method'], true));
		
		// set DIAGANOSES radio list form
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		$this->Structures->set($tx_control_data['TreatmentControl']['form_alias']); 			
		$this->Structures->Set('empty', 'empty_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->data) ) {
			$this->data['TreatmentMaster']['participant_id'] = $participant_id;
			$this->data['TreatmentMaster']['treatment_control_id'] = $tx_control_id;
			
			// LAUNCH SPECIAL VALIDATION PROCESS	
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {
				if ( $this->TreatmentMaster->save($this->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
				}
			}
		 }
	}

	function delete( $participant_id, $tx_master_id ) {

		// MANAGE DATA
		$treatment_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($treatment_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		
		$this->TreatmentMaster->set($treatment_master_data);
		$arr_allow_deletion = $this->TreatmentMaster->allowDeletion($tx_master_id);
						
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->TreatmentMaster->atim_delete( $tx_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
		}
	}
}

?>