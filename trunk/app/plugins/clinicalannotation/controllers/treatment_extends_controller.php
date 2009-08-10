<?php

class TreatmentExtendsController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.TreatmentExtend',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.TreatmentControl',
		'Drug.Drug');
	var $paginate = array('TreatmentExtend'=>array('limit'=>10,'order'=>'TreatmentExtend.id ASC'));
	
	function listall($participant_id=null, $tx_master_id=null) {
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// Get treatment control data from associated master record
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));

		// Set form alias/tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentControl']['extend_tablename'] );
		$use_form_alias = $tx_master_data['TreatmentControl']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );
		
		$this->data = $this->paginate($this->TreatmentExtend, array('TreatmentExtend.tx_master_id'=>$tx_master_id));
	
		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
	
	}

	function detail($participant_id=null, $tx_master_id=null, $tx_extend_id=null) {
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// Get treatment master row for extended data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		
		// Set form alias/tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );
		$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );

	    $this->data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id)));
	    
		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
		
	}

	function add($participant_id=null, $tx_master_id=null) {
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// Get treatment master row for extended data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));

		// Set form alias/tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );
		$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );

		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
		
		if ( !empty($this->data) ) {
			$this->data['TreatmentExtend']['tx_master_id'] = $tx_master_data['TreatmentMaster']['id'];
			if ( $this->TreatmentExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );
			}
		} 
	}

	function edit($participant_id=null, $tx_master_id=null, $tx_extend_id=null) {
		
		$this->set('atim_menu_variables', array(
			'Participant.id'=>$participant_id,
			'TreatmentMaster.id'=>$tx_master_id,
			'TreatmentExtend.id'=>$tx_extend_id
		));
		
		// Get treatment master row for extended data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
				
		// Set form alias/tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );
		$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
	    $this->set('atim_structure', $this->Structures->get('form', $use_form_alias));

	    // Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('all', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		foreach ( $drug_list as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set('drug_id_findall', $drug_id_findall);
	    
	    $this_data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_extend_id)));

	    if (!empty($this->data)) {
			$this->TreatmentExtend->id = $tx_extend_id;
			if ($this->TreatmentExtend->save($this->data)) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/'.$tx_extend_id);
			}
		} else {
			$this->data = $this_data;
		}
	}

	function delete($participant_id=null, $tx_master_id=null, $tx_extend_id=null) {

		$this->TreatmentExtend->del( $tx_extend_id );
		$this->flash( 'Your data has been deleted.', '/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );

	}
}

?>