<?php 
class Template extends AppModel {
	
	var $useTable = 'templates';
	var $tree = null;

	static $sharing = array(
		'user'	=> 0,
		'bank'	=> 1,
		'all'	=> 2
	);
	
	function init(){
		$template_node_model = AppModel::getInstance("Tools", "TemplateNode", true);
		$tree = $template_node_model->find('all', array('conditions' => array('TemplateNode.Template_id' => $this->id)));
		$result[''] = array(
					'id' => 0,
					'parent_id' => null,
					'control_id' => '0',
					'datamart_structure_id' => 2,
					'quantity' => 1,
					'children' => array()
		);
		foreach($tree as &$node){
			$node = $node['TemplateNode'];
			$result[$node['id']] = $node;
			$result[$node['parent_id']]['children'][] = &$result[$node['id']];
		}
		
		return $result;
	}
	
	function findOwnedNodes(){
		$group_model = AppModel::getInstance("", "Group", true);
		$group_data = $group_model->findById($_SESSION['Auth']['User']['group_id']);
		return $this->find('all', array('conditions' => array(
			'OR' => array(
					array('Template.owner' => 'user', 'Template.owning_entity_id' => $_SESSION['Auth']['User']['id']),
					array('Template.owner' => 'bank', 'Template.owning_entity_id' => $group_data['Group']['bank_id']),
					array('Template.owner' => 'all')
			), 'Template.flag_system' => false
		)));
	}
	
	function findVisibleNodes(){
		$group_model = AppModel::getInstance("", "Group", true);
		$group_data = $group_model->findById($_SESSION['Auth']['User']['group_id']);
		return $this->find('all', array('conditions' => array(
			'OR' => array(
					array('Template.visibility' => 'user', 'Template.visible_entity_id' => $_SESSION['Auth']['User']['id']),
					array('Template.visibility' => 'bank', 'Template.visible_entity_id' => $group_data['Group']['bank_id']),
					array('Template.visibility' => 'all')
			)
		)));
	}
}
