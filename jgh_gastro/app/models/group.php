<?php
class Group extends AppModel {

	var $actsAs = array('Acl' => array('requester'));
	
	var $hasMany = array('User'); 
	
	function parentNode() {    
		return null;
	}
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Group.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Group.id'=>$variables['Group.id'])));
			$return = array(
				'menu'				=> array( NULL, $result['Group']['name'] ),
				'title'				=> array( NULL, $result['Group']['name'] ),
				'data'				=> $result,
				'structure alias'	=> 'groups' 
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
	
	/**
	 * Checks if at least one permission for that group is granted
	 * @param $group_id
	 */
	function hasPermissions($group_id){
		$query = "SELECT count(*) AS c FROM groups "
			."INNER JOIN aros ON groups.id=aros.foreign_key AND model='Group' "
			."INNER JOIN aros_acos ON aros.id=aros_acos.aro_id "
			."WHERE groups.id=".$group_id." AND (aros_acos._create != -1 OR aros_acos._read != -1 OR aros_acos._update != -1 OR aros_acos._delete != -1)";
		$data = $this->query($query);
		return $data[0][0]['c'] > 0;
	}
}
?>