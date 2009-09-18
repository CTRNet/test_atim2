<?php

class PermissionsController extends AdministrateAppController {
	
	var $uses = array('Aco'); 
	
	function tree( $bank_id=0, $group_id=0, $user_id=0 ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		$this->data = $this->Aco->find('threaded', array('order'=>'alias ASC'));
	}

}

?>