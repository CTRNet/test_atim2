<?php

class EventMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.EventMaster', 
		'Clinicalannotation.EventControl', 
		'Clinicalannotation.Diagnosis'
	);
	
	var $paginate = array(
		'EventMaster'=>array('limit'=>10,'order'=>'EventMaster.event_date DESC')
	);
	
	function listall( $event_group=NULL, $participant_id=null, $event_control_id=null ) {
		
		// set FILTER, used as this->data CONDITIONS
		
			if ( !isset($_SESSION['MasterDetail_filter']) || !$event_control_id ) {
				$_SESSION['MasterDetail_filter'] = array();
				
				$_SESSION['MasterDetail_filter']['EventMaster.participant_id'] = $participant_id;
				$_SESSION['MasterDetail_filter']['EventMaster.event_group'] = $event_group;
				
				$this->set( 'atim_structure', $this->Structures->get('form','eventmasters') );
			}
			
			else {
				$_SESSION['MasterDetail_filter']['EventMaster.event_control_id'] = $event_control_id;
				
				$filter_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
				$this->set( 'atim_structure', $this->Structures->get('form',$filter_data['EventControl']['form_alias']) );
			}
			
		
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id, 'EventControl.id'=>$event_control_id) );
		$this->data = $this->paginate($this->EventMaster, $_SESSION['MasterDetail_filter']);
		
		// find all EVENTCONTROLS, for ADD form
		$this->set( 'event_controls', $this->EventControl->find('all', array('conditions'=>array('event_group'=>$event_group))) );
				
	}
	
	function detail( $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id) );
		$this->data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['EventControl']['form_alias']) );
	}
	
	function add( $event_group=NULL, $participant_id=null, $event_control_id=null) {
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		// set DIAGANOSES
			$this->set( 'data_for_checklist', $this->Diagnosis->find('all', array('conditions'=>array('Diagnosis.participant_id'=>$participant_id))) );
			$this->set( 'atim_structure_for_checklist', $this->Structures->get('form','diagnoses') );
		
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		$this_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['EventControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			
			$this->data['EventMaster']['participant_id'] = $participant_id;
			$this->data['EventMaster']['event_control_id'] = $event_control_id;
			$this->data['EventMaster']['event_group'] = $event_group;
			$this->data['EventMaster']['event_type'] = $this_data['EventControl']['event_type'];
			$this->data['EventMaster']['disease_site'] = $this_data['EventControl']['disease_site'];
			
			if ( $this->EventMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$this->EventMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 		
	}
	
	function edit( $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		// set DIAGANOSES
			$this->set( 'data_for_checklist', $this->Diagnosis->find('all', array('conditions'=>array('Diagnosis.participant_id'=>$participant_id))) );
			$this->set( 'atim_structure_for_checklist', $this->Structures->get('form','diagnoses') );
		
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id) );
		$this_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['EventControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->EventMaster->id = $event_master_id;
			if ( $this->EventMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
		} else {
			$this->data = $this_data;
		}
		
	}

	function delete($menu_id=NULL, $event_group=NULL, $participant_id=null, $event_master_id=null) {
		if (!$participant_id) {
			$this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE );
		}

		// TODO: Update del function call with ATiM delete
		if( $this->EventMaster->Del( $event_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/event_masters/listall/'.$menu_id.'/'.$event_group.'/'.$participant_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/event_masters/listall/'.$menu_id.'/'.$event_group.'/'.$participant_id );
		}
	}
}
?>