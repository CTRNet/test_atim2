<?php
class User extends AppModel {

	var $belongsTo = array('Group');
	
	var $actsAs = array('Acl' => array('requester'));

	const PASSWORD_MINIMAL_LENGTH = 6;
	
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
		$this->validatePassword($data, $error_flash_link);
		
		if($this->validationErrors){
			AppController::getInstance()->flash(__($this->validationErrors['password'][0]), $error_flash_link);
		}else{
	
			$this->read();
			
			//all good! save
			$data_to_save = array('User' => array(
				'group_id' => $this->data['User']['group_id'],
				'password' => Security::hash($data['User']['new_password'], null, true))
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
	function validatePassword(array $data){
		if ( !isset($data['User']['new_password'], $data['User']['confirm_password']) ) {
			//do nothing
			$this->validationErrors['password'][] = 'internal error';
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