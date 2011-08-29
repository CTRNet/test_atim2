<?php

class DiagnosisMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.DiagnosisMaster', 
		'Clinicalannotation.DiagnosisDetail',
		'Clinicalannotation.DiagnosisControl',
		'Clinicalannotation.Participant',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.EventMaster',
		'Clinicalannotation.ClinicalCollectionLink',
		'codingicd.CodingIcd10Who',
		'codingicd.CodingIcd10Ca',
		'codingicd.CodingIcdo3Topo',//required by model
		'codingicd.CodingIcdo3Morpho'//required by model
	);
	var $paginate = array('DiagnosisMaster'=>array('limit' => pagination_amount,'order'=>'DiagnosisMaster.dx_date'));

	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		$this->data = $this->paginate($this->DiagnosisMaster, array('DiagnosisMaster.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.flag_active' => 'active'))));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }			
	}

	function detail( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		$this->data = $dx_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.diagnosis_control_id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id']) );
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add( $participant_id=null, $dx_control_id=null ) {
		if (( !$participant_id ) && ( !$dx_control_id )) { 
			$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		$this->set('existing_dx', $this->DiagnosisMaster->getExistingDx($participant_id));
		
		$this->set('initial_display', (empty($this->data)? true : false));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, "tableId"=>$dx_control_id));
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/diagnosis_masters/listall/') );
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_control_id)));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosismasters');
		$this->Structures->set('empty', 'empty_structure');

		$this->set( 'dx_type', $dx_control_data['DiagnosisControl']['controls_type']);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->data) ) {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$this->data['DiagnosisMaster']['participant_id'] = $participant_id;
			$this->data['DiagnosisMaster']['diagnosis_control_id'] = $dx_control_id;
			$this->data['DiagnosisMaster']['type'] = $dx_control_data['DiagnosisControl']['controls_type']; 

			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				if ( $this->DiagnosisMaster->save( $this->data )) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved', '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$this->DiagnosisMaster->id.'/' );
				}
			}
		}
	}

	function edit( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { 
			$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}	

		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		$this->set('existing_dx', $this->DiagnosisMaster->getExistingDx($participant_id, $diagnosis_master_id, $dx_master_data['DiagnosisMaster']['primary_number']));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.diagnosis_control_id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id']));
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
		
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set('diagnosismasters', 'diagnosismasters');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($this->data)) {
			$this->data = $dx_master_data;
		} else {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				$this->DiagnosisMaster->id = $diagnosis_master_id;
				if ( $this->DiagnosisMaster->save($this->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id );
				}
			}
		}
		
	}

	function delete( $participant_id, $diagnosis_master_id ) {
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		// MANAGE DATA
		$diagnosis_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if (empty($diagnosis_master_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$arr_allow_deletion = $this->DiagnosisMaster->allowDeletion($diagnosis_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->DiagnosisMaster->atim_delete( $diagnosis_master_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/diagnosis_masters/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id);
		}		
	}
}

?>