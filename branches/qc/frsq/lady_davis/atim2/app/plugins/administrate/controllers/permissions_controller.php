<?php

class PermissionsController extends AdministrateAppController {
	
	var $uses = array('Aco','Aro'); 
	
	function tree( $bank_id=0, $group_id=0, $user_id=0 ) {
		if($this->data){
			foreach($this->data['Permission'] as $i => $perm){
				if(intval($perm['state']) == 0 ){
					$sql = 'DELETE FROM aros_acos WHERE aro_id = "'.$perm['aro_id'].'" AND aco_id = "'.$perm['aco_id'].'"';
				}else if(isset($perm['id']) && $perm['id']){
					$sql = '
						UPDATE
							aros_acos
						SET
							aro_id="'.$perm['aro_id'].'",
							aco_id="'.$perm['aco_id'].'",
							_create="'.$perm['state'].'",
							_read="'.$perm['state'].'",
							_update="'.$perm['state'].'",
							_delete="'.$perm['state'].'"
						WHERE
							id = "'.$perm['id'].'"
					';
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
							"'.$perm['aro_id'].'",
							"'.$perm['aco_id'].'",
							"'.$perm['state'].'",
							"'.$perm['state'].'",
							"'.$perm['state'].'",
							"'.$perm['state'].'"
						)
						ON DUPLICATE KEY UPDATE
							_create="'.$perm['state'].'",
							_read="'.$perm['state'].'",
							_update="'.$perm['state'].'",
							_delete="'.$perm['state'].'"
					';
				}
				$this->Aro->query($sql);
			}
			echo 'Saved '.count($this->data['Permission']).' permissions.<br />';
		}
		
		
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id,'Group.id'=>$group_id,'User.id'=>$user_id) );
		$aro = $this->Aro->find('first', array('conditions' => 'Aro.alias = "Group::'.$group_id.'"', 'order'=>'alias ASC', 'recursive' => 1));
		$known_acos = array_combine(Set::extract('Aco.{n}.id',$aro), Set::extract('Aco.{n}.Permission',$aro));
		$this->set('aro', $aro );
		$this->set('known_acos',$known_acos);
		
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
	}
	
}

?>