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
		
		$this->validatePassword($data, $error_flash_link);
		
		//all good! save
		$data['User']['password'] = Security::hash($data['User']['new_password'], null, true);

		unset($data['User']['new_password'], $data['User']['confirm_password']);
		
		$this->read();
		$data['User']['group_id'] = $this->data['User']['group_id'];//otherwise aros table is altered
		if ( $this->save( $data ) ) {
			AppController::getInstance()->atimFlash( 'your data has been updated', $success_flash_link );
		}
	}
	
	/**
	 * Will throw a flash message if the password is not valid
	 * @param array $data
	 */
	function validatePassword(array $data){
		if ( !isset($data['User']['new_password'], $data['User']['confirm_password']) ) {
			//do nothing

		}else{
			if ($data['User']['new_password'] !== $data['User']['confirm_password']){
				$this->validationErrors['password'][] = 'passwords do not match'; 
			}
			if( strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH){
				$this->validationErrors['password'][] = 'passwords minimal length';
			}
		}
	}

}
?>