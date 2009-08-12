<?php

class ProtocolMastersController extends ProtocolAppController {

	var $uses = array('Protocol.ProtocolControl', 'Protocol.ProtocolMaster');
	var $paginate = array('ProtocolMaster'=>array('limit'=>10,'order'=>'ProtocolMaster.name DESC'));
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
	}
	
	function search() {
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->ProtocolMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ProtocolMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/protocol/protocol_masters/search';
	}
	
	function listall() {
		
		$this->data = $this->paginate($this->ProtocolMaster, array());
		
		// find all PROTOCOLCONTROLS, for ADD form
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
	}
	
	function add($protocol_control_id=null) {
		$this->set( 'atim_menu_variables', array('ProtocolControl.id'=>$protocol_control_id)); 
		$this->set('atim_menu', $this->Menus->get('/protocol/protocol_masters/index/'));
		$this_data = $this->ProtocolControl->find('first',array('conditions'=>array('ProtocolControl.id'=>$protocol_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['ProtocolControl']['detail_form_alias']) );
		
		if ( !empty($this->data) ) {
			
			$this->data['ProtocolMaster']['protocol_control_id'] = $protocol_control_id;
			$this->data['ProtocolMaster']['type'] = $this_data['ProtocolControl']['type'];
			$this->data['ProtocolMaster']['tumour_group'] = $this_data['ProtocolControl']['tumour_group'];
			
			if ( $this->ProtocolMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/protocol/protocol_masters/detail/'.$this->ProtocolMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 
	}
	
	function detail($protocol_master_id=null) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_no_proto_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		$this->data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['ProtocolControl']['detail_form_alias']) );
	}

	function edit( $protocol_master_id=null ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_no_proto_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id) );
		$this_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['ProtocolControl']['detail_form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->ProtocolMaster->id = $protocol_master_id;
			if ( $this->ProtocolMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
			}
		} else {
			$this->data = $this_data;
		}
		
	}
	
	function delete( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_no_proto_id', NULL, TRUE ); }
		
		if( $this->ProtocolMaster->atim_delete( $protocol_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/protocol/protocol_masters/listall/');
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/protocol/protocol_masters/listall/');
		}
	}

}

?>