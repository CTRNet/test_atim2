<?php

class PermissionsController extends AdministrateAppController {
	
	var $uses = array('Aco','Aro'); 
	
	function index(){
		
	}
	
	function regenerate(){
		$this->PermissionManager->buildAcl();
		$this->set('log', $this->PermissionManager->log);
	}
	
	function update($aro_id, $aco_id, $state){
		
		$this->autoRender = false;
		
		$aro = $this->Aro->find('first', array('conditions' => 'Aro.id = "'.$aro_id.'"', 'order'=>'alias ASC', 'recursive' => -1));
		$this->updatePermission($aro_id,$aco_id,$state);
		
		list($type,$id) = split('::',$aro['Aro']['alias']);
		switch($type){
		case 'Group':
			$this->redirect('/administrate/permissions/tree/'.$id);
			break;
		case 'User':
			$parent = $this->Aro->find('first', array('conditions' => 'Aro.id = "'.$aro['Aro']['parent_id'].'"', 'order'=>'alias ASC', 'recursive' => -1));
			list($type,$gid) = split('::',$parent['Aro']['alias']);
			$this->redirect('/administrate/permissions/tree/'.$gid.'/'.$id);
			break;
		}
		exit();
	}
	
	private function updatePermission($aro_id, $aco_id, $state){
		
		if(intval($state) == 0 ){
			$sql = 'DELETE FROM aros_acos WHERE aro_id = "'.$aro_id.'" AND aco_id = "'.$aco_id.'"';
		}else{
			$sql = '
				INSERT INTO
					aros_acos
				(
					aro_id,
					aco_id,
					_create,
					_read,
					_update,
					_delete
				)
				VALUES(
					"'.$aro_id.'",
					"'.$aco_id.'",
					"'.$state.'",
					"'.$state.'",
					"'.$state.'",
					"'.$state.'"
				)
				ON DUPLICATE KEY UPDATE
					_create="'.$state.'",
					_read="'.$state.'",
					_update="'.$state.'",
					_delete="'.$state.'"
			';
		}
		$this->Aro->query($sql);
		
		// echo '<p>'.$state.': '.$sql.'</p>';
	}
	
	function tree($group_id=0, $user_id=0 ) {
		
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id,'User.id'=>$user_id) );
		$aro = $this->Aro->find('first', array('conditions' => 'Aro.alias = "Group::'.$group_id.'"', 'order'=>'alias ASC', 'recursive' => 1));
		$known_acos = array_combine(Set::extract('Aco.{n}.id',$aro), Set::extract('Aco.{n}.Permission',$aro));
		$this->set('aro', $aro );
		$this->set('known_acos',$known_acos);
		
		if($this->data){
			
			/*
			echo '<pre>';
			print_r($this->data);
			echo '</pre>';
			*/
			
			foreach($this->data as $i => $aco){
				$this->updatePermission( $aro['Aro']['id'], $aco[$i]['Aco']['id'], intval($aco[$i]['Aco']['state']) );
			}
			
			// exit;
			
			$this->redirect('/administrate/permissions/tree/'.$group_id.'/'.$user_id);
			break;
		}
		
		$depth = $this->Aco->query('
			SELECT node.id, (COUNT(parent.id) - 1) AS depth
			FROM acos AS node, acos AS parent
			WHERE node.lft BETWEEN parent.lft AND parent.rght
			GROUP BY node.id
			ORDER BY node.lft;
		');
		
		$depth = array_combine(Set::extract('{n}.node.id',$depth),Set::extract('{n}.0.depth',$depth));
		
		$this->set('depth',$depth);
		
		$this->set('acos', $this->Aco->find('all', array('recursive' => -1, 'order'=>'Aco.lft ASC, Aco.alias ASC')) );
		
		
		$this->Aco->unbindModel(
			array(
				'hasAndBelongsToMany' => array('Aro')
			)
		);
		
		$this->Aco->bindModel(
			array(
				'hasAndBelongsToMany' => array(
					'Aro'	=> array(
						'className'					=> 'Aro',
						'joinTable'					=> 'aros_acos',
						'foreignKey'				=> 'aco_id',
						'associationForeignKey'	=> 'aro_id',
						'conditions'				=> array('Aro.model'=>'Group', 'Aro.foreign_key'=>$group_id)
					)
				)
			)
		);
		
		$threaded_data = $this->Aco->find('threaded');
		$threaded_data = $this->addPermissionStateToThreadedData($threaded_data);
		
		$this->data = $threaded_data;
	}
	
	function addPermissionStateToThreadedData( $threaded_data=array() ) {
		foreach ( $threaded_data as $k=>$v ) {
			if ( isset($v['Aro'][0]) && isset($v['Aro'][0]['ArosAco']) && isset($v['Aro'][0]['ArosAco']['_create']) ) {
				$threaded_data[$k]['Aco']['state'] = $v['Aro'][0]['ArosAco']['_create'];
			}
			
			unset($threaded_data[$k]['Aro']);
			
			if ( isset($v['children']) && count($v['children']) ) {
				$threaded_data[$k]['children'] = $this->addPermissionStateToThreadedData($v['children']);
			}
		}
		
		return $threaded_data;
	}
	
}

?>