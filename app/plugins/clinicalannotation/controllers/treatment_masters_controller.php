<?php

class TreatmentMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.TreatmentMaster', 
		'Clinicalannotation.TreatmentControl', 
		'Clinicalannotation.Diagnosis',
		'Protocol.ProtocolMaster'
	);
	var $paginate = array('TreatmentMaster'=>array('limit'=>10,'order'=>'TreatmentMaster.start_date DESC'));

	function listall($participant_id=null) {
		if ( !$participant_id ) {
			$this->redirect( '/pages/err_clin-ann_no_part_id' );
		}
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id'=>$participant_id));
		
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		$this->set('protocol_list', $protocol_list);

		// find all TXCONTROLS, for ADD form
		$this->set('treatment_controls', $this->TreatmentControl->find('all'));	
	}
	
	function detail($participant_id=null, $tx_master_id=null) {
		if( !$participant_id ) {
			$this->redirect( '/pages/err_clin-ann_no_part_id' );
	 	}
		if( !$tx_master_id ) {
			$this->redirect( '/pages/err_clin-ann_no_treament_id' );
		}
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		$this->data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$this->data['TreatmentMaster']['treatment_control_id'])));
		
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		$this->set('protocol_list', $protocol_list);

		// set structure alias based rom control data
		$this->set( 'atim_structure', $this->Structures->get('form', $tx_control_data['TreatmentControl']['form_alias']) );
	}
	
	function edit( $participant_id=null, $tx_master_id=null ) {
		if( !$participant_id ) {
			$this->redirect( '/pages/err_clin-ann_no_part_id' );
		}
		if( !$tx_master_id ) {
			$this->redirect( '/pages/err_clin-ann_no_treament_id' );
		}
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		$this_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$this_data['TreatmentMaster']['treatment_control_id'])));

		// set DIAGANOSES
		$this->set( 'data_for_checklist', $this->Diagnosis->find('all', array('conditions'=>array('Diagnosis.participant_id'=>$participant_id))) );
		$this->set( 'atim_structure_for_checklist', $this->Structures->get('form','diagnoses') );
				
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		$this->set('protocol_list', $protocol_list);
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form', $tx_control_data['TreatmentControl']['form_alias']) );
		
		if (!empty($this->data)) {
			$this->TreatmentMaster->id = $tx_master_id;
			if ($this->TreatmentMaster->save($this->data)) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
			} else {
				$this->flash ('Error updating data - Contact your administrator.','/clinicalannotation/treatment_masters/listall/'.$participant_id);
			}
		} else {
			$this->data = $this_data;
		}
	}
	
	function add($participant_id=null, $treatment_control_id=null) {
		if ( !$participant_id )	{
			$this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE );
		}
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentControl.id'=>$treatment_control_id));
		$tx_control_data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$treatment_control_id)));

		// set DIAGANOSES radio list form
		$this->set( 'data_for_checklist', $this->Diagnosis->find('all', array('conditions'=>array('Diagnosis.participant_id'=>$participant_id))) );
		$this->set( 'atim_structure_for_checklist', $this->Structures->get('form','diagnoses') );
		
		$this->set('atim_structure', $this->Structures->get('form', $tx_control_data['TreatmentControl']['form_alias']));
		
		$protocol_list = $this->ProtocolMaster->find('list', array('conditions'=>array('ProtocolMaster.deleted'=>'0')), array('fields' => array('ProtocolMaster.id', 'ProtocolMaster.name'), 'order' => array('ProtocolMaster.name')));
		$this->set('protocol_list', $protocol_list);
		
		if ( !empty($this->data) ) {
			$this->data['TreatmentMaster']['participant_id'] = $participant_id;
			$this->data['TreatmentMaster']['treatment_control_id'] = $treatment_control_id;
			
			if ( $this->TreatmentMaster->save($this->data) ) {
				$this->flash( 'Your data has been added.','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
			} else {
				$this->flash( 'Error adding record - Contact your administrator','/clinicalannotation/treatment_masters/listall/'.$participant_id);
			}
		} 	
	}

	function delete( $participant_id=null, $tx_master_id=null ) {
		if (!$participant_id) {
			$this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE );
		}
		if (!$tx_master_id) {
			$this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE );
		}
		// TODO: Update del function call with ATiM delete
		if( $this->TreatmentMaster->del( $tx_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
		}
	}
}

?>