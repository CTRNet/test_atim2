<?php

class SopMastersController extends SopAppController {

	var $uses = array('Sop.SopControl', 'Sop.SopMaster');
	var $paginate = array('SopMaster'=>array('limit'=>10,'order'=>'SopMaster.title DESC'));
	
	function listall() {
		$this->hook();
		
		$this->data = $this->paginate($this->SopMaster, array());
		
		// find all EVENTCONTROLS, for ADD form
		$this->set( 'sop_controls', $this->SopControl->find('all', array()) );
	}

	
	function add($sop_control_id=null) {
		$this->set('atim_menu', $this->Menus->get('/sop/sop_masters/index/'));
		$this->set( 'atim_menu_variables', array('SopControl.id'=>$sop_control_id)); 
		$this_data = $this->SopControl->find('first',array('conditions'=>array('SopControl.id'=>$sop_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set($this_data['SopControl']['detail_form_alias']);
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			
			$this->data['SopMaster']['sop_control_id'] = $sop_control_id;
			$this->data['SopMaster']['type'] = $this_data['SopControl']['type'];
			$this->data['SopMaster']['sop_group'] = $this_data['SopControl']['sop_group'];
			
			if ( $this->SopMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/sop/sop_masters/detail/'.$this->SopMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 
	}
	
	function detail($sop_master_id) {
		if ( !$sop_master_id ) { $this->redirect( '/pages/err_sop_funct_param_missing', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('SopMaster.id'=>$sop_master_id));
		
		$this->hook();
		
		$this->data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->data['SopControl']['detail_form_alias']);
	}

	function edit( $sop_master_id  ) {
		if ( !$sop_master_id ) { $this->redirect( '/pages/err_sop_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('SopMaster.id'=>$sop_master_id) );
		$this_data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this_data['SopControl']['detail_form_alias']);
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->SopMaster->id = $sop_master_id;
			if ( $this->SopMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/sop/sop_masters/detail/'.$sop_master_id.'/');
		} else {
			$this->data = $this_data;
		}
		
	}
	
	function delete( $sop_master_id ) {
		if ( !$sop_master_id ) { $this->redirect( '/pages/err_sop_funct_param_missing', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->SopMaster->atim_delete( $sop_master_id ) ) {
			$this->flash( 'Your data has been deleted.', '/sop/sop_masters/listall/');
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/sop/sop_masters/listall/');
		}
	}
}

?>
