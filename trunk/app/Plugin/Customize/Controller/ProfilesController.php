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
		$user_data = $this->User->getOrRedirect($_SESSION['Auth']['User']['id']);
	
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			$this->request->data['User']['id'] = $_SESSION['Auth']['User']['id'];
			$this->request->data['User']['group_id'] = $_SESSION['Auth']['User']['group_id'];
			$this->request->data['Group']['id'] = $_SESSION['Auth']['User']['group_id'];
			
			$this->User->id = $_SESSION['Auth']['User']['id'];
			
			$submitted_data_validates	= true;
			
			if($this->request->data['User']['username'] != $user_data['User']['username']) {
				$this->User->validationErrors['username'][] = __('a user name can not be changed');
				$submitted_data_validates	= false;
			}
			
			if(!$this->request->data['User']['flag_active']){
				unset($this->request->data['User']['flag_active']);
				$this->User->validationErrors[][] = __('you cannot deactivate yourself');
				$submitted_data_validates	= false;
			}
			
			unset($this->request->data['User']['username']);

			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
							
			if ($submitted_data_validates && $this->User->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/Customize/Profiles/index' );
				return;
			}
			
			//Reset username
			$this->request->data['User']['username'] = $user_data['User']['username'];
			
		} else {
			$this->request->data = $user_data;
		}
	}

}

?>