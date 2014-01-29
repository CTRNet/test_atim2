<?php
class User extends AppModel {

	var $belongsTo = array('Group');
	
	var $actsAs = array('Acl' => array('requester'));

	const PASSWORD_MINIMAL_LENGTH = 8;
	
	function parentNode() {
		if(isset($this->data['User']['group_id'])){
			return array('Group' => array('id' => $this->data['User']['group_id']));
		}
		if(isset($this->data['User']['id'])){
			$this->id = $this->data['User']['id'];
		}
		if($this->id){
			$data = $this->find('first', array('conditions' => array('User.id' => $this->id, 'User.deleted' => array(0, 1))));
			$this->log(print_r($data, true), 'debug');
			return array('Group' => array('id' => $data['User']['group_id']));
		}
		throw new Exception('Insufficient data to determine parentNode');
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
		assert($this->id);
		$this->validatePassword($data);
		
		if($this->validationErrors){
			AppController::getInstance()->flash(__($this->validationErrors['password'][0]), $error_flash_link);
		}else{
	
			$this->read();
			
			//all good! save
			$data_to_save = array('User' => array(
				'group_id' => $this->data['User']['group_id'],
				'password' => Security::hash($data['User']['new_password'], null, true),
				'password_modified' => now())
			);
			
			$this->data = null;
			$this->check_writable_fields = false;
			if ( $this->save( $data_to_save ) ) {
				AppController::getInstance()->atimFlash(__('your data has been updated'), $success_flash_link );
			}
		}
	}
	
	/**
	 * Will throw a flash message if the password is not valid
	 * @param array $data
	 */
	function validatePassword(array $data, $created_user_name = null){
		if ( !isset($data['User']['new_password'], $data['User']['confirm_password']) ) {
			//do nothing
			$this->validationErrors['password'][] = 'internal error';
		}else if ($data['User']['new_password'] !== $data['User']['confirm_password']){
				$this->validationErrors['password'][] = 'passwords do not match'; 
		} else {
			if($created_user_name) {
				if($created_user_name == $data['User']['new_password']) $this->validationErrors['password'][] = 'password should be different than username'; 
			} else if($this->id) {
				if($this->find('count', array('conditions' =>array('User.id' => $this->id, 'User.username ' => $data['User']['new_password']))))$this->validationErrors['password'][] = 'password should be different than username'; 
				if($this->find('count', array('conditions' =>array('User.id' => $this->id, 'User.password ' => Security::hash($data['User']['new_password'], null, true)))))$this->validationErrors['password'][] = 'password should be different than the previous one';
			} else {
				$this->validationErrors['password'][] = 'internal error';
			}
			$password_security_level = in_array(Configure::read('password_security_level'), array(0,1,2,3,4))? Configure::read('password_security_level') : '4';
			$password_format_error = false;
			switch($password_security_level) {
				case '4':
					if(!preg_match('/\W+/', $data['User']['new_password'])) $password_format_error = true;
				case '3':
					if(!preg_match('/[A-Z]+/', $data['User']['new_password'])) $password_format_error = true;
				case '2':
					if(!preg_match('/[1-9]+/', $data['User']['new_password'])) $password_format_error = true;
				case '1':
					if( strlen($data['User']['new_password']) < self::PASSWORD_MINIMAL_LENGTH) $password_format_error = true;
					if(!preg_match('/[a-z]+/', $data['User']['new_password'])) $password_format_error = true;
				case '0':
				default:
			}
			if($password_format_error) $this->validationErrors['password'][] = 'password_format_error_msg_'.$password_security_level;
		}
	}

}
?>