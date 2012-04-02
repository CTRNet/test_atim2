<?php
class BrowsingResult extends DatamartAppModel {
	var $useTable = 'datamart_browsing_results';
	
	var $belongsTo = array(       
		'DatamartStructure' => array(           
			'className'    => 'Datamart.DatamartStructure',            
			'foreignKey'    => 'browsing_structures_id')
	);
	
	var $actsAs = array('Tree');
	
	public function cacheAndGet($start_id, &$browsing_cache){
		$browsing = $this->find('first', array("conditions" => array('BrowsingResult.id' => $start_id)));

		assert(!empty($browsing)) or die();
		
		$browsing_cache[$start_id] = $browsing;
		
		return $browsing;
	}
	
	
	function getSingleLineMergeableNodes($starting_node_id){
		$starting_node = $this->getOrRedirect($starting_node_id);
		$required_fields = array('BrowsingResult.id', 'BrowsingResult.parent_id', 'BrowsingResult.browsing_structures_id');
		$parents_nodes = $this->getPath($starting_node_id, $required_fields);
		array_pop($parents_nodes);//the last element is the starting node
		
		$filtered_parents = array();
		
		$datamart_controls_model = AppModel::getInstance('Datamart', 'BrowsingControl');
		
		//filter parents
		$current_ctrl_id = $starting_node['BrowsingResult']['browsing_structures_id'];
		$encountered_ctrls = array();
		while ($parent = array_pop($parents_nodes)){
			if(in_array($parent['BrowsingResult']['browsing_structures_id'], $encountered_ctrls)){
				//already encoutered type, don't go futher up
				break;
			}
			if($datamart_controls_model->findNTo1($current_ctrl_id, $parent['BrowsingResult']['browsing_structures_id'])){ 
				//compatible node found
				$filtered_parents[] = $parent;
				$current_ctrl_id = $parent['BrowsingResult']['browsing_structures_id'];
				$encountered_ctrls[] = $current_ctrl_id;
			}else if($datamart_controls_model->find1ToN($current_ctrl_id, $parent['BrowsingResult']['browsing_structures_id'])){
				//compatible node found on a terminating node
				$filtered_parents[] = $parent;
				$current_ctrl_id = $parent['BrowsingResult']['browsing_structures_id'];
				break;
			}else{
				//incompatible node found, no need to go further up the tree
				break;
			}
		}
		unset($parents_nodes);
		
		$filtered_parents = array_reverse($filtered_parents);
		$filtered_parents = AppController::defineArrayKey($filtered_parents, 'BrowsingResult', 'id', true);
		
		//filter children
		$children_nodes = $this->children($starting_node_id, false, $required_fields);
		$flat_children_nodes = array();
		$this->makeTree($children_nodes);
		$next_level_children = array(array(
			'current_ctrl_id' => $current_ctrl_id = $starting_node['BrowsingResult']['browsing_structures_id'], 
			'nodes' => &$children_nodes, 
			'encountered_ctrls' => array()
		));
		while(!empty($next_level_children)){
			$current_nodes = $next_level_children;
			$next_level_children = array();
			foreach($current_nodes as &$child_node){
				//check all current level nodes. Put all curent level nodes' children into tmp_children
				//within the same line, no same ctrl id allowed
				$current_ctrl_id = $child_node['current_ctrl_id'];
				$encountered_ctrls = $child_node['encountered_ctrls'];
				foreach($child_node['nodes'] as $k => &$node){
					if(!in_array($node['BrowsingResult']['browsing_structures_id'], $encountered_ctrls)){
						if($datamart_controls_model->findNTo1($current_ctrl_id, $node['BrowsingResult']['browsing_structures_id'])){
							//compatible node found, leave it in the tree
							$flat_children_nodes[$node['BrowsingResult']['id']] = $node; 
							//add children to the next level to check
							if(isset($node['BrowsingResult']['children'])){
								$next_level_children[] = array(
										'current_ctrl_id' => $node['BrowsingResult']['browsing_structures_id'],
										'nodes'	=> &$node['BrowsingResult']['children'],
										'encountered_ctrls'	=> array_merge($encountered_ctrls, array($current_ctrl_id))
								);
							}
						}else if($datamart_controls_model->find1ToN($current_ctrl_id, $node['BrowsingResult']['browsing_structures_id'])){
							//compatible node found, leave it in the tree
							$flat_children_nodes[$node['BrowsingResult']['id']] = $node;
							//terminating 1 - n relationship
							unset($node['BrowsingResult']['children']);
						}else{
							//incompatible node found, remove it from the tree
							unset($child_node['nodes'][$k]);
						}
					}else{
						//incompatible node found, remove it from the tree
						unset($child_node['nodes'][$k]);
					}
				}
			}
		}
		return array(
			'parents'		=> $filtered_parents, 
			'children'		=> $children_nodes, 
			'flat_children' => $flat_children_nodes,
			'current_id'	=> $starting_node_id
		);
	}
	
	function getJoins($base_node_id, $target_node_id){
		$merge_on = array();
		$base_browsing_result = null;
		if($base_node_id < $target_node_id){
			$path = $this->getPath($target_node_id, null, 0);
			while($browsing_result = array_pop($path)){
				if($browsing_result['BrowsingResult']['id'] == $base_node_id){
					$base_browsing_result = $browsing_result;
					break;
				}
				$merge_on[$browsing_result['BrowsingResult']['id']] = $browsing_result;
			}
			$merge_on = array_reverse($merge_on);
		}else{
			$path = $this->getPath($base_node_id, null, 0);
			$base_browsing_result = array_pop($path);
			while($browsing_result = array_pop($path)){
				$merge_on[$browsing_result['BrowsingResult']['id']] = $browsing_result;
				if($browsing_result['BrowsingResult']['id'] == $target_node_id){
					break;
				}
			}
		}
		
		$browsing_control_model = AppModel::getInstance('Datamart', 'BrowsingControl', true);
		$current_structure_id = $base_browsing_result['DatamartStructure']['id'];
		$joins = array();
		foreach($merge_on as $merge_unit){
			$joins[] = $browsing_control_model->getInnerJoinArray($current_structure_id, $merge_unit['DatamartStructure']['id'], explode(',', $merge_unit['BrowsingResult']['id_csv']));
			$current_structure_id = $merge_unit['DatamartStructure']['id'];
		}
		
		return $joins;
	}
	
	function countMaxDuplicates($base_node_id, $target_node_id){
		$joins = $this->getJoins($base_node_id, $target_node_id);
		$base_browsing_result = $this->getOrRedirect($base_node_id);
		$target_browsing_result = $this->getOrRedirect($target_node_id);

		$base_model = AppModel::getInstance($base_browsing_result['DatamartStructure']['plugin'], $base_browsing_result['DatamartStructure']['model'], true);
		$final_model = AppModel::getInstance($target_browsing_result['DatamartStructure']['plugin'], $target_browsing_result['DatamartStructure']['model'], true);
		$data = $base_model->find('first', array(
			'fields'	=> array('COUNT('.$final_model->name.'.'.$final_model->primaryKey.') AS c'),
			'conditions'=> array(),
			'joins'		=> $joins,
			'group'		=> $base_model->name.'.'.$base_model->primaryKey,
			'order'		=> 'c DESC',
			'recursive'	=> -1
		));
		return $data[0]['c'];
	}
}