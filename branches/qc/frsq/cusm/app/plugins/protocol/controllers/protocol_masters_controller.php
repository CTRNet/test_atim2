<?php

class ProtocolMastersController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolControl', 
		'Protocol.ProtocolMaster', 
		'Protocol.ProtocolExtend',
		'Clinicalannotation.TreatmentMaster');
		
	var $paginate = array('ProtocolMaster'=>array('limit' => pagination_amount,'order'=>'ProtocolMaster.code DESC'));
	
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
	
	function add($protocol_control_id) {
		if ( !$protocol_control_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
				
		$protocol_control_data = $this->ProtocolControl->find('first',array('conditions'=>array('ProtocolControl.id'=>$protocol_control_id)));
		if (empty($protocol_control_data) ) { $this->redirect( '/pages/err_pro_system_error', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('ProtocolControl.id'=>$protocol_control_id)); 
		$this->set('atim_menu', $this->Menus->get('/protocol/protocol_masters/index/'));
		$this->Structures->set($protocol_control_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->data) ) {
			$this->data = array();
			$this->data['ProtocolMaster']['tumour_group'] = $protocol_control_data['ProtocolControl']['tumour_group'];
			$this->data['ProtocolMaster']['type'] = $protocol_control_data['ProtocolControl']['type'];
		} else {
			
			$this->data['ProtocolMaster']['protocol_control_id'] = $protocol_control_id;
			$this->data['ProtocolMaster']['type'] = $protocol_control_data['ProtocolControl']['type'];
			$this->data['ProtocolMaster']['tumour_group'] = $protocol_control_data['ProtocolControl']['tumour_group'];

			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->data) ){
				$this->flash( 'your data has been updated','/protocol/protocol_masters/detail/'.$this->ProtocolMaster->getLastInsertId());
			}
		} 
	}
	
	function detail($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }

		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/pages/err_pro_no_data', null, true ); }		
		$this->data = $protocol_data;
			
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));
		$this->Structures->set($protocol_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function edit( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
		
		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/pages/err_pro_no_data', null, true ); }			
		
		$this->set( 'atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id) );
		$this->Structures->set($protocol_data['ProtocolControl']['form_alias']);
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( empty($this->data) ) {
			$this->data = $protocol_data;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			$this->ProtocolMaster->id = $protocol_master_id;
			if ($submitted_data_validates && $this->ProtocolMaster->save($this->data) ) {
				$this->flash( 'your data has been updated','/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
			}
		}		
	}
	
	function delete( $protocol_master_id ) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
		
		$protocol_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_data)) { $this->redirect( '/pages/err_pro_no_data', null, true ); }	
			
		$arr_allow_deletion = $this->allowProtocolDeletion($protocol_master_id, $protocol_data['ProtocolControl']['extend_tablename']);
				
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->ProtocolMaster->atim_delete( $protocol_master_id ) ) {
				$this->flash( 'your data has been deleted', '/protocol/protocol_masters/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/protocol/protocol_masters/index/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/protocol/protocol_masters/detail/'.$protocol_master_id.'/');
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $protocol_master_id Id of the studied record.
	 * @param $protocol_extend_tablename
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2010-04-18
	 */
	 
	function allowProtocolDeletion($protocol_master_id, $protocol_extend_tablename){
		$nbr_trt_masters = $this->TreatmentMaster->find('count', array('conditions'=>array('TreatmentMaster.protocol_master_id'=>$protocol_master_id), 'recursive' => '-1'));
		if ($nbr_trt_masters > 0) { return array('allow_deletion' => false, 'msg' => 'protocol is defined as protocol of at least one participant treatment'); }
		
		$this->ProtocolExtend = new ProtocolExtend(false, $protocol_extend_tablename);
		$nbr_extends = $this->ProtocolExtend->find('count', array('conditions'=>array('ProtocolExtend.protocol_master_id'=>$protocol_master_id), 'recursive' => '-1'));
		if ($nbr_extends > 0) { return array('allow_deletion' => false, 'msg' => 'at least one drug is defined as protocol component'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}

}

?>