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

	function listall( $participant_id, $parent_dx_id = null, $is_ajax = 0 ) {
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		if($is_ajax){
			$this->layout = 'ajax';
			Configure::write('debug', 0);
		}
		
		$tx_model = AppModel::getInstance("clinicalannotation", "TreatmentMaster", true);
		$event_master_model = AppModel::getInstance("clinicalannotation", "EventMaster", true);
		$this->data = array_merge($this->DiagnosisMaster->find('all', array(
				'conditions' => array('DiagnosisMaster.participant_id' => $participant_id, 'DiagnosisMaster.parent_id' => $parent_dx_id ),
				'order' => array('DiagnosisMaster.dx_date')
			)), $tx_model->find('all', array(
				'conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.diagnosis_master_id' => $parent_dx_id == null ? -1 : $parent_dx_id ),
				'order' => array('TreatmentMaster.start_date')
			)), $event_master_model->find('all', array(
				'conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.diagnosis_master_id' => $parent_dx_id == null ? -1 : $parent_dx_id),
				'order' => array('EventMaster.event_date')
			))
		);
		
		$ids = array();//ids already having child
		$can_have_child = $this->DiagnosisMaster->find('all', array(
			'fields' => array('DiagnosisMaster.id'),
			'conditions' => array('DiagnosisControl.category' => array('primary', 'secondary'), 'DiagnosisMaster.participant_id' => $participant_id),
			'recursive' => 0
		));
		$can_have_child = AppController::defineArrayKey($can_have_child, 'DiagnosisMaster', 'id', true);
		$can_have_child = array_keys($can_have_child);
		foreach($this->data as $data){
			if(array_key_exists('DiagnosisMaster', $data)){
				$ids[] = $data['DiagnosisMaster']['id'];
			}
		}

		$ids_having_child = $this->DiagnosisMaster->hasChild($ids);
		$ids_having_child = array_fill_keys($ids_having_child, null);
		foreach($this->data as &$data){
			if(array_key_exists('DiagnosisMaster', $data)){
				$data['children'] = array_key_exists($data['DiagnosisMaster']['id'], $ids_having_child);
			}
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->set('diagnosis_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array('DiagnosisControl.flag_active' => 1))));
		$this->set('is_ajax', $is_ajax);
		$atim_structure['DiagnosisMaster'] = $this->Structures->get('form', 'diagnosismasters'); 
		$atim_structure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters'); 
		$atim_structure['EventMaster'] = $this->Structures->get('form', 'eventmasters'); 
		$this->set('atim_structure', $atim_structure);
		$this->set('can_have_child', $can_have_child);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}			
	}

	function detail( $participant_id, $diagnosis_master_id ) {
		// MANAGE DATA
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}		
		$this->data = $dx_master_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->setDiagnosisMenu($dx_master_data);
		if(($dx_master_data['DiagnosisControl']['category'] == 'primary') && ($dx_master_data['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown')) {
			$this->set('primary_ctrl_to_redefine_unknown', $this->DiagnosisControl->find('all', array('conditions' => array('NOT' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisControl']['id'], 'DiagnosisControl.controls_type' => 'primary diagnosis unknown'), 'DiagnosisControl.category' => 'primary', 'DiagnosisControl.flag_active' => 1)))); 
		}
		
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_master_data['DiagnosisMaster']['diagnosis_control_id'])));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias']);
		
		//check for dates warning
		if(
			is_numeric($dx_master_data['DiagnosisMaster']['parent_id']) && 
			!empty($dx_master_data['DiagnosisMaster']['dx_date']) &&
			$dx_master_data['DiagnosisMaster']['dx_date_accuracy'] == 'c'
		){
			$parent_dx = $this->DiagnosisMaster->findById($dx_master_data['DiagnosisMaster']['parent_id']);
			if(
				!empty($parent_dx['DiagnosisMaster']['dx_date']) &&
				$parent_dx['DiagnosisMaster']['dx_date_accuracy'] == 'c' &&
				(strtotime($dx_master_data['DiagnosisMaster']['dx_date']) - strtotime($parent_dx['DiagnosisMaster']['dx_date']) < 0)
			){
				AppController::addWarningMsg(__('the current diagnosis date is before the parent diagnosis date', true));
			}
		}
		
		// available child ctrl_id for creation
		
		if($dx_master_data['DiagnosisControl']['category'] == 'primary') {
			$this->set('child_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array("DiagnosisControl.category NOT IN ('primary')", 'DiagnosisControl.flag_active' => 1))));		
		} else if($dx_master_data['DiagnosisControl']['category'] == 'secondary') {
			$this->set('child_controls_list', $this->DiagnosisControl->find('all', array('conditions' => array("DiagnosisControl.category NOT IN ('primary', 'secondary')", 'DiagnosisControl.flag_active' => 1))));		
		}
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		$events_data = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.diagnosis_master_id' => $diagnosis_master_id)));
		foreach($events_data as $event_data){
			EventMaster::generateDxCompatWarnings($this->data, $event_data);
		}
	}

	function add( $participant_id, $parent_id, $dx_control_id){
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		$dx_ctrl = $this->DiagnosisControl->redirectIfNonExistent($dx_control_id, __METHOD__, __LINE__, true);
		if(empty($participant_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
						
		$parent_dx = null;
		if($parent_id == 0){
			if($dx_ctrl['DiagnosisControl']['category'] != 'primary'){
				//is not a primary but has no parent
				$this->flash('invalid control id', 'javascript:history.back();');
			}
		}else{
			$parent_dx = $this->DiagnosisMaster->find('first', array('conditions' => array('DiagnosisMaster.id' => $parent_id, 'DiagnosisMaster.participant_id' => $participant_id)));
			if(empty($parent_dx)){
				$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );				
			}
			if(($dx_ctrl['DiagnosisControl']['category'] == 'primary') || ($dx_ctrl['DiagnosisControl']['category'] == 'secondary') &&  ($parent_dx['DiagnosisControl']['category'] == 'secondary')) {
				$this->flash('invalid control id', 'javascript:history.back();');
			}
		}

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, "tableId"=>$dx_control_id, 'DiagnosisMaster.parent_id' => $parent_id));
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/diagnosis_masters/listall/') );
		$this->set('origin', $parent_id == 0 ? 'primary' : 'secondary');
		$dx_control_data = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $dx_control_id)));
		$this->Structures->set($dx_control_data['DiagnosisControl']['form_alias'].",".($parent_id == 0 ? "dx_origin_primary" : "dx_origin_wo_primary"));
		$this->Structures->set('empty', 'empty_structure');

		$this->set( 'dx_ctrl', $dx_ctrl);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->data) ) {
			$this->DiagnosisMaster->patchIcd10NullValues($this->data);
			$this->data['DiagnosisMaster']['participant_id'] = $participant_id;
			$this->data['DiagnosisMaster']['diagnosis_control_id'] = $dx_control_id;
			
			$this->data['DiagnosisMaster']['parent_id'] = $parent_id == 0 ? null : $parent_id;
			$this->data['DiagnosisMaster']['primary_id'] = $parent_id == 0 ? null : (empty($parent_dx['DiagnosisMaster']['primary_id'])? $parent_dx['DiagnosisMaster']['id'] : $parent_dx['DiagnosisMaster']['primary_id']);
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {				
				if ( $this->DiagnosisMaster->save( $this->data )) {
					$diagnosis_master_id = $this->DiagnosisMaster->getLastInsertId();
				
					if($parent_id == 0){
						// Set primary_id of a Primary
						$data_to_update = array();
						$data_to_update['DiagnosisMaster']['primary_id'] = $diagnosis_master_id;
						$this->DiagnosisMaster->id = $diagnosis_master_id;					
						if(!$this->DiagnosisMaster->save($data_to_update, false)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);	
					}
					
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					
					$this->atimFlash( 'your data has been saved', '/clinicalannotation/diagnosis_masters/detail/'.$participant_id.'/'.$diagnosis_master_id.'/' );
				}
			}
		}
	}
	
	function edit( $participant_id, $diagnosis_master_id, $redefined_primary_control_id = null ) {
		
		// MANAGE DATA
		
		$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if(empty($dx_master_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		
		if(!is_null($redefined_primary_control_id)) {
			
			// UNKNOWN PRIMARY REDEFINITION
			// User expected to change an unknown primary to a specific diagnosis
			
			$new_primary_ctrl = $this->DiagnosisControl->find('first', array('conditions' => array('DiagnosisControl.id' => $redefined_primary_control_id)));
			if(empty($new_primary_ctrl) 
			|| ($dx_master_data['DiagnosisControl']['category'] != 'primary')
			|| ($dx_master_data['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown')
			|| ($new_primary_ctrl['DiagnosisControl']['category'] != 'primary')
			|| ($new_primary_ctrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown')) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			
			if($dx_master_data['DiagnosisControl']['detail_tablename'] != $new_primary_ctrl['DiagnosisControl']['detail_tablename']) {
				if(!$this->DiagnosisMaster->atim_delete($diagnosis_master_id)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				$this->DiagnosisMaster->query("INSERT INTO ".$new_primary_ctrl['DiagnosisControl']['detail_tablename']." (`diagnosis_master_id`) VALUES ($diagnosis_master_id);");
			}
			$this->DiagnosisMaster->query("UPDATE diagnosis_masters SET diagnosis_control_id = $redefined_primary_control_id, deleted = 0 WHERE id = $diagnosis_master_id;");
			
			$dx_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
			if(empty($dx_master_data)) $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
		
			$this->addWarningMsg(__('unknown primary has been redefined. complete primary data.', true));
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->setDiagnosisMenu($dx_master_data);
		
		$this->Structures->set($dx_master_data['DiagnosisControl']['form_alias']);
		
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
			if( $hook_link ) { 
				require($hook_link); 
			}
			
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
		if (( !$participant_id ) && ( !$diagnosis_master_id )) { 
			$this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); 
		}
	
		// MANAGE DATA
		$diagnosis_master_data = $this->DiagnosisMaster->find('first',array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id, 'DiagnosisMaster.participant_id'=>$participant_id)));
		if (empty($diagnosis_master_data)) {
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

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
	
	function setDiagnosisMenu($dx_master_data) {
		if(!isset($dx_master_data['DiagnosisMaster']['id'])) $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		
		$primary_id = null;
		$progression_1_id = null;
		$progression_2_id = null;
		if($dx_master_data['DiagnosisMaster']['primary_id'] == $dx_master_data['DiagnosisMaster']['id']) {
			//Primary Display
			$primary_id = $dx_master_data['DiagnosisMaster']['id'];
			$menu_link = '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.primary_id%%';
			
		} else if($dx_master_data['DiagnosisMaster']['primary_id'] == $dx_master_data['DiagnosisMaster']['parent_id']) {
			// Secondary or primary progression display
			$primary_id = $dx_master_data['DiagnosisMaster']['primary_id'];
			$progression_1_id = $dx_master_data['DiagnosisMaster']['id'];
			$menu_link = '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_1_id%%'	;
			
		} else {
			// Secondary progression display
			$primary_id = $dx_master_data['DiagnosisMaster']['primary_id'];
			$progression_1_id = $dx_master_data['DiagnosisMaster']['parent_id'];
			$progression_2_id = $dx_master_data['DiagnosisMaster']['id'];
			$menu_link = '/clinicalannotation/diagnosis_masters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_2_id%%'	;
		}
		
		$this->set( 'atim_menu', $this->Menus->get($menu_link));
		$this->set( 'atim_menu_variables', array(
			'Participant.id'=>$dx_master_data['DiagnosisMaster']['participant_id'], 
			'DiagnosisMaster.id'=>$dx_master_data['DiagnosisMaster']['id'], 
			
			'DiagnosisMaster.primary_id'=>$primary_id,
			'DiagnosisMaster.progression_1_id'=>$progression_1_id,
			'DiagnosisMaster.progression_2_id'=>$progression_2_id 
		));
	}
}

?>