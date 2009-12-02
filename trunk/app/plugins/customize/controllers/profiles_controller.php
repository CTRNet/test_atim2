<?php

class ProfilesController extends CustomizeAppController {
	
	var $name = 'Profiles';
	var $uses = array('User');
	
	function index() {
		$this->Structures->set('users' );
		
		$this->hook();
		
		$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
	}
	
	function edit() {
		$this->Structures->set('users' );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->User->id = $_SESSION['Auth']['User']['id'];
			if ( $this->User->save($this->data) ) $this->flash( 'Your data has been updated.','/customize/profiles/index' );
		} else {
			$this->data = $this->User->find('first',array('conditions'=>array('User.id'=>$_SESSION['Auth']['User']['id'])));
		}
	}

}

?>