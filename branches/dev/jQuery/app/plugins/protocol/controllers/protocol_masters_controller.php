<?php

class ProtocolMastersController extends ProtocolAppController {

	var $uses = array('Protocol.ProtocolControl', 'Protocol.ProtocolMaster');
	var $paginate = array('ProtocolMaster'=>array('limit' => pagination_amount,'order'=>'ProtocolMaster.name DESC'));
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function search() {
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->ProtocolMaster, $_SESSION['ctrapp_core']['search']['criteria']);
		
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));	
		$this->set('atim_menu', $this->Menus->get("/protocol/protocol_masters/index/"));
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['ProtocolMaster']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/protocol/protocol_masters/search';
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function listall() {
		$this->data = $this->paginate($this->ProtocolMaster, array());
		
		// find all PROTOCOLCONTROLS, for ADD form
		$this->set('protocol_controls', $this->ProtocolControl->find('all'));

		$this->testAndHook('format');
	}
	
	function add($protocol_control_id=null) {
		$this->set( 'atim_menu_variables', array('ProtocolControl.id'=>$protocol_control_id)); 
		$this->set('atim_menu', $this->Menus->get('/protocol/protocol_masters/index/'));
		$this_data = $this->ProtocolControl->find('first',array('conditions'=>array('ProtocolControl.id'=>$protocol_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set($this_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			
			$this->data['ProtocolMaster']['protocol_control_id'] = $protocol_control_id;
			$this->data['ProtocolMaster']['type'] = $this_data['ProtocolControl']['type'];
			$this->data['ProtocolMaster']['tumour_group'] = $this_data['ProtocolControl']['tumour_group'];

			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->data) ){
				$this->flash( 'your data has been updated','/protocol/protocol_masters/detail/'.$this->ProtocolMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 
		$this->data['ProtocolMaster']['tumour_group'] = $this_data['ProtocolControl']['tumour_group'];
		$this->data['ProtocolMaster']['type'] = $this_data['ProtocolControl']['type'];
	}
	
	function detail($protocol_master_id=null) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		
		$this->data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function edit( $protocol_master_id=null ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id) );
		$this_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->ProtocolMaster->id = $protocol_master_id;
			
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->data) ) {
				$this->flash( 'your data has been updated','/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
			}
		} else {
			$this->data = $this_data;
		}
		
	}
	
	function delete( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }
		
		if( $this->ProtocolMaster->atim_delete( $protocol_master_id ) ) {
			$this->flash( 'your data has been deleted', '/protocol/protocol_masters/listall/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/protocol/protocol_masters/listall/');
		}
	}

}

?>