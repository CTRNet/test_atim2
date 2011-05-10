<?php
class User extends AppModel {

	var $belongsTo = array('Group');
	
	var $actsAs = array('Acl' => array('requester'));

	const PASSWORD_MINIMAL_LENGTH = 6;
	
	function parentNode() {    
		
		if (!$this->id && empty($this->data)) {        
			return null;    
		}
		
		$data = $this->data;    
		
		if (empty($this->data)) {        
			$data = $this->read();    
		}    
		
		if (!isset($data['User']['group_id']) || !$data['User']['group_id']) {        
			return null;    
		} else {        
			return array('Group' => array('id' => $data['User']['group_id']));    
		}
		
	}
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['User.id']) ) {
			$result = $this->find('first', array('conditions'=>array('User.id'=>$variables['User.id'])));
			
			$display_name = trim($result['User']['first_name'].' '.$result['User']['last_name']);
			$display_name = $display_name ? $display_name : $result['User']['username'];
			
			$return = array(
				'menu'			=>	array( NULL, $display_name ),
				'title'			=>	array( NULL, $display_name ),
				'data'			=> $result,
				'structure alias' => 'users'
			);
		}
		
		return $return;
	}
	
	
	function getUsersList() {
		$all_users_data = $this->find('all', array('recursive' => '-1'));
		$result = array();
		foreach($all_users_data as $data) {
			$result[$data['User']['id']] = $data['User']['first_name'] . ' ' . $data['User']['last_name']; 
		}
		return $result;
	}
	
	function savePassword(array $data, $error_flash_link, $success_flash_link){
		if ( !isset($data['User']['new_password'], $data['User']['confirm_password']) ) {
			//do nothing

		}else if ( $data['User']['new_password'] !== $data['User']['confirm_password'] ) {
			AppController::getInstance()->flash( 'Sorry, new password was not entered correctly.', $error_flash_link );

		}else if( strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH){
			AppController::getInstance()->flash( 'passwords minimal length', $error_flash_link );
		}else{
			//all good! save
			$data['User']['password'] = Security::hash($data['User']['new_password'], null, true);

			unset($data['User']['new_password'], $data['User']['confirm_password']);
			
			$data['User']['group_id'] = $_SESSION['Auth']['User']['group_id'];
			if ( $this->save( $data ) ) {
				AppController::getInstance()->atimFlash( 'your data has been updated', $success_flash_link );
			}
		}
	}

}
?>