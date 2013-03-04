<?php

class ProfilesController extends CustomizeAppController {
	
	var $name = 'Profiles';
	var $uses = array('User');
	
	function index() {
		$this->Structures->set('users' );
		
		$this->hook();
		
		$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
	}
	
	function edit() {
		$this->Structures->set('users' );
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			$this->request->data['User']['id'] = $_SESSION['Auth']['User']['id'];
			$this->request->data['User']['group_id'] = $_SESSION['Auth']['User']['group_id'];
			$this->request->data['Group']['id'] = $_SESSION['Auth']['User']['group_id'];
			
			$this->User->id = $_SESSION['Auth']['User']['id'];
			
			if ( $this->User->save($this->request->data) ) $this->atimFlash( 'your data has been updated','/Customize/profiles/index' );
		} else {
			$this->request->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
		}
	}

}

?>