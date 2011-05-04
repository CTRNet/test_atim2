<?php

class UserLogsController extends AdministrateAppController {
	
	var $uses = array('UserLog');
	var $paginate = array('UserLog'=>array('limit' => pagination_amount,'order'=>'UserLog.visited DESC')); 
	
	function index( $group_id, $user_id ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->UserLog, array('UserLog.user_id'=>$user_id));
	}
}
?>