<?php

class ProtocolExtendsController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolExtend',
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl');
		
	var $paginate = array('ProtocolExtend'=>array('limit' => pagination_amount,'order'=>'ProtocolExtend.id DESC'));

	function listall($protocol_master_id){
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }

		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_pro_no_data', null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}
				
		$this->ProtocolExtend = new ProtocolExtend(false, $protocol_master_data['ProtocolControl']['extend_tablename']);
		$this->data = $this->paginate($this->ProtocolExtend, array('ProtocolExtend.protocol_master_id'=>$protocol_master_id));

		$is_used = $this->ProtocolMaster->isLinkedToTreatment($protocol_master_id);
		if($is_used['is_used']){
			$this->ProtocolExtend->validationErrors[] = __('warning', true).": ".__($is_used['msg'], true).".";
		}
			
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias']);
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
	}

	function detail($protocol_master_id, $protocol_extend_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_id)) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_pro_no_data', null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}
		
		// Set tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		
		// Get extend data
		$prot_extend_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id,'ProtocolExtend.protocol_master_id'=>$protocol_master_id)));
		if(empty($prot_extend_data)) { $this->redirect( '/pages/err_pro_no_data', null, true ); }	
		$this->data = $prot_extend_data;
	  	
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id, 'ProtocolExtend.id'=>$protocol_extend_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add($protocol_master_id) {
		if ( !$protocol_master_id ) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }
		
		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_pro_no_data', null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}

		// Set tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias'] );
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if ( !empty($this->data) ) {
			$this->data['ProtocolExtend']['protocol_master_id'] = $protocol_master_id;
				
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
				
			if ($submitted_data_validates && $this->ProtocolExtend->save( $this->data ) ) {
				$this->flash( 'your data has been saved', '/protocol/protocol_extends/listall/'.$protocol_master_id );
			}
		}
	}

	function edit($protocol_master_id, $protocol_extend_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_id)) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_pro_no_data', null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}

		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		
		// Get extend data
		$prot_extend_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id,'ProtocolExtend.protocol_master_id'=>$protocol_master_id)));
		if(empty($prot_extend_data)) { $this->redirect( '/pages/err_pro_no_data', null, true ); }	
		
		$this->Structures->set($protocol_master_data['ProtocolControl']['extend_form_alias']);
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id,'ProtocolExtend.id'=>$protocol_extend_id));
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if (empty($this->data)) {
			$this->data = $prot_extend_data;
		} else {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			$this->ProtocolExtend->id = $protocol_extend_id;
			if ($submitted_data_validates && $this->ProtocolExtend->save($this->data)) {
				$this->flash( 'your data has been updated','/protocol/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id);
			}
		}
	}

	function delete($protocol_master_id, $protocol_extend_id) {
		if ((!$protocol_master_id) || (!$protocol_extend_id)) { $this->redirect( '/pages/err_pro_funct_param_missing', NULL, TRUE ); }		

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));
		if(empty($protocol_master_data)) { 
			$this->redirect( '/pages/err_pro_no_data', null, true ); 
		} else if(empty($protocol_master_data['ProtocolControl']['extend_tablename']) || empty($protocol_master_data['ProtocolControl']['extend_form_alias'])){
			$this->flash( 'no additional data has to be defined for this type of protocol', '/protocol/protocol_masters/detail/'.$protocol_master_id);
			return;
		}
		
		// Set extend data
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		$prot_extend_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id,'ProtocolExtend.protocol_master_id'=>$protocol_master_id)));
		if(empty($prot_extend_data)) { $this->redirect( '/pages/err_pro_no_data', null, true ); }	
		
		$arr_allow_deletion = $this->allowProtocolExtendDeletion($protocol_extend_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if( $this->ProtocolExtend->atim_delete( $protocol_extend_id ) ) {
				$this->flash( 'your data has been deleted', '/protocol/protocol_extends/listall/'.$protocol_master_id);
			} else {
				$this->flash( 'error deleting data - contact administrator', '/protocol/protocol_extends/listall/'.$protocol_master_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/protocol/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id);
		}
		
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $protocol_extend_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2010-04-18
	 */
	 
	function allowProtocolExtendDeletion($protocol_extend_id){		
		return array('allow_deletion' => true, 'msg' => '');
	}	
	
	
}

?>