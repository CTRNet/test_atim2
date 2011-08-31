<?php 
class Template extends AppModel {
	
	var $useTable = 'templates';
	var $tree = null;

	function init($template_id){
		$template_node_model = AppModel::getInstance("Tools", "TemplateNode", true);
		$tree = $template_node_model->find('all', array('conditions' => array('TemplateNode.Template_id' => $template_id)));
		$result[''] = array(
					'id' => 0,
					'parent_id' => null,
					'control_id' => '0',
					'datamart_structure_id' => 2,
					'children' => array()
		);
		foreach($tree as &$node){
			$node = $node['TemplateNode'];
			$result[$node['id']] = $node;
			$result[$node['parent_id']]['children'][] = &$result[$node['id']];
		}
		
		return $result;
	}
	
	function getNode($number){
		$current = &$this->tree;
		$index = 0;
		$stack = array();
		$i = 0;
		$node_number = 0;
		while($current != null){
			if($index == 0 && $node_number ++ == $number){
				break;
			}
			if(isset($current['children'][$index])){
				array_push($stack, array('current' => $current, 'index' => $index));
				$current = $current['children'][$index];
				$index = 0;
			}else if($current != null){
				echo '[',$current['id'],']<br/>';
				$poped = array_pop($stack);
				$current = $poped['current'];
				$index = $poped['index'] + 1;
			}
			
			++ $i;
			if($i > 1000){
				die("loop err");
				break;
			}
		}
		
		return $current;
	}
}
