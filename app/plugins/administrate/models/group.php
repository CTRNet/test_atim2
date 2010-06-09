<?php
class Group extends AdministrateAppModel {
	var $hasMany = array("User" => array(
			'className' => "Administrate.User",
			'foreignKey' => "group_id"
		));
		
	function summary( $variables=array() ) {
		$return = false;
		if ( isset($variables['Group.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Group.id'=>$variables['Group.id'])));
			$return = array(
				'Summary'	 => array(
					'menu'			=>	array( NULL, $result['Group']['name']),
					'title'			=>	array( NULL, $result['Group']['name']),
					'description'	=>	array(
						__('users', true) 		=> count($result['User']),
						__('created', TRUE)		=>	__($result['Group']['created'], TRUE)
					)
				)
			);
		}
		return $return;
	}
	
	function bindToPermissions(){
		$this->bindModel(array('hasOne' => array(
			'Aro' => array(
				'className' => 'Aro',
				'foreignKey' => 'foreign_key',
				'conditions' => 'Aro.model="Group"'
			)
		)));
		
		$this->Aro->unbindModel(
			array('hasAndBelongsToMany' => array('Aco'))
		);
		
		$this->Aro->bindModel(
			array('hasMany' => array(
				'Permission' => array(
					'className' => 'Permission',
					'foreign_key'	=>'aco_id'
					)
				)
			)
		);
	}
}
?>