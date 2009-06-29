<?php

class TreatmentMastersController extends ClinicalannotationAppController {

	var $uses = array('Clinicalannotation.TreatmentMaster', 'Clinicalannotation.TreatmentControl', 'Clinicalannotation.Diagnosis');
	var $paginate = array('TreatmentMaster'=>array('limit'=>10,'order'=>'TreatmentMaster.start_date DESC'));

	function listall($participant_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); }
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id'=>$participant_id));
		
		// find all TXCONTROLS, for ADD form
		$this->set('treatment_controls', $this->TreatmentControl->find('all'));		
	}
	
	function detail($participant_id=null, $tx_master_id=null) {
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		$this->data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['TreatmentMaster']['detail_form_alias']) );
	}
	
	function edit( $participant_id=null, $tx_master_id=null ) {
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id,'TreatmentMaster.id'=>$tx_master_id) );
		$this_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['TreatmentMaster']['detail_form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->TreatmentMaster->id = $tx_master_id;
			if ( $this->TreatmentMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id);
		} else {
			$this->data = $this_data;
		}
	}
	
	function add($participant_id=null, $treatment_control_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->TreatmentControl->find('first',array('conditions'=>array('TreatmentControl.id'=>$treatment_control_id)));
		
		if ( !empty($this->data) ) {
			
			$this->data['TreatmentMaster']['participant_id'] = $participant_id;
			$this->data['TreatmentMaster']['treatment_control_id'] = $treatment_control_id;
			$this->data['TreatmentMaster']['tx_group'] = $this_data['TreatmentControl']['tx_group'];
			$this->data['TreatmentMaster']['disease_site'] = $this_data['TreatmentControl']['disease_site'];
			
			if ( $this->TreatmentMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$this->TreatmentMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 	
	}
	
	function delete( $participant_id=null, $tx_master_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$tx_master_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->TreatmentMaster->del( $tx_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/treatment_masters/listall/'.$participant_id );
		}
	}
}

?>