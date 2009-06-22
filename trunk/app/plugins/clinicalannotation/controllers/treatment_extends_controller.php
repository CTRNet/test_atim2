<?php

class TreatmentExtendsController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.TreatmentExtend',
		'Clinicalannotation.TreatmentMaster',
		'Clinicalannotation.TreatmentControl',
		'Drug.Drug');
	var $paginate = array('TreatmentMaster'=>array('limit'=>10,'order'=>'TreatmentMaster.start_date DESC'));
	
	function listall($participant_id=null, $tx_master_id=null) {
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		
		// Get treatment master row for extended data
		$tx_master_data = $this->TreatmentMaster->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		
		// Set form alias/tablename to use
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );
		$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );
		
		$this->data = $this->paginate($this->TreatmentExtend, array('TreatmentExtend.tx_master_id'=>$tx_master_id));
	
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

/*		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
	*/	
		$this->data = $this->TreatmentExtend->find('first',array('conditions'=>array('TreatmentExtend.id'=>$tx_master_id)));
	}

	function add($participant_id=null, $tx_master_id=null) {
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id'=>$tx_master_id));
		$this->data = $this->paginate($this->TreatmentMaster, array('TreatmentMaster.participant_id'=>$participant_id));
		
		// get Extend tablename and form_alias from Master row

			$this->TreatmentMaster->id = $tx_master_id;
			$tx_master_data = $this->TreatmentMaster->read();

			$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
			$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $use_form_alias ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_75', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_75', 'clin_CAN_80', $participant_id.'/'.$tx_master_id ); // based on TxMaster values
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $use_form_alias ) );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'tx_master_id', $tx_master_id );
		
		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
		
		if ( !empty($this->data) ) {

			// after DETAIL model is set and declared
			$this->cleanUpFields('TreatmentExtend');

			if ( $this->TreatmentExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );
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
/*		
		// Get all drug names for dropdown list
		$criteria = NULL;
		$fields = 'Drug.id, Drug.generic_name';
		$order = 'Drug.id ASC';
		$drug_id_findall_result = $this->Drug->findAll( $criteria, $fields, $order );
		$drug_id_findall = array();
		foreach ( $drug_id_findall_result as $record ) {
			$drug_id_findall[ $record['Drug']['id'] ] = $record['Drug']['generic_name'];
		}
		$this->set( 'drug_id_findall', $drug_id_findall );
*/
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
/*
		// get Extend tablename and form_alias from Master row

		$this->TreatmentMaster->id = $tx_master_id;
		$tx_master_data = $this->TreatmentMaster->read();

		$use_form_alias = $tx_master_data['TreatmentMaster']['extend_form_alias'];
		$this->TreatmentExtend = new TreatmentExtend( false, $tx_master_data['TreatmentMaster']['extend_tablename'] );

		$this->TreatmentExtend->del( $tx_extend_id );
		$this->flash( 'Your data has been deleted.', '/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id );
*/
	}
}

?>