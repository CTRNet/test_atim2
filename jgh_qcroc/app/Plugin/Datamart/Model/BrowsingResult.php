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
	
	/**
	 * Return a model associated to a node (takes the detail model if the result set allows it)
	 * @param mixed $node Either a browsing result id or the data array related to it
	 */
	function getModelAndStructureForNode($browsing_result){
		if(is_integer($browsing_result)){
			$browsing_result = $this->getOrRedirect($browsing_result);
		}
		assert(is_array($browsing_result));
		
		$structures_component = AppController::getInstance()->Structures;
		$model = AppModel::getInstance($browsing_result['DatamartStructure']['plugin'], $browsing_result['DatamartStructure']['model']);
		$structure = $structures_component->getFormById($browsing_result['DatamartStructure']['structure_id']);
		$header_sub_type = null;
		$control_id = null;
		if($browsing_result['BrowsingResult']['browsing_structures_sub_id']){
			//specific
			$control_id = $browsing_result['BrowsingResult']['browsing_structures_sub_id'];
		}else if($browsing_result['DatamartStructure']['control_master_model']){
			$control_foreign = $model->getControlForeign();
			$data = $model->find('all', array(
				'fields'		=> array($model->name.'.'.$control_foreign),
				'conditions' 	=> array($model->name.'.'.$model->primaryKey.' IN('.$browsing_result['BrowsingResult']['id_csv'].')'),
				'group'		=> array($model->name.'.'.$control_foreign)
			));
			if(count($data) == 1){
				$control_id = $data[0][$model->name][$control_foreign];
			}
		}
		
		if($control_id){
			$model = AppModel::getInstance($browsing_result['DatamartStructure']['plugin'], $browsing_result['DatamartStructure']['control_master_model']);
			$control_model = AppModel::getInstance($browsing_result['DatamartStructure']['plugin'], $model->getControlName());
			$control_model_data = $control_model->find('first', array(
					'fields' => array($control_model->name.'.form_alias', $control_model->name.'.databrowser_label'),
					'conditions' => array($control_model->name.".id" => $control_id))
			);
			
			$header_sub_type = $control_model_data[$control_model->name]['databrowser_label'];
			
			//init base model
			$structure_alias = $structure['Structure']['alias'];
			
			AppController::buildDetailBinding(
					$model,
					array($model->name.'.'.$model->getControlForeign() => $control_id),
					$structure_alias
			);
			
			$structure = $structures_component->get('form', $structure_alias);
		}
		
		return array('specific' => $control_id != null, 'model' => $model, 'structure' => $structure, 'header_sub_type' => $header_sub_type);
	}
	
	
	function getSingleLineMergeableNodes($starting_node_id){
		$starting_node = $this->getOrRedirect($starting_node_id);
		$required_fields = array('BrowsingResult.id', 'BrowsingResult.parent_id', 'BrowsingResult.browsing_structures_id', 'BrowsingResult.browsing_type');
		$parents_nodes = $this->getPath($starting_node_id, $required_fields);
		$starting_node = array_pop($parents_nodes);//the last element is the starting node
		if($starting_node['BrowsingResult']['browsing_type'] == 'drilldown'){
			//starting node is a drilldown, flush the direct parent
			array_pop($parents_nodes);
		}
		
		$filtered_parents = array();
		
		$datamart_controls_model = AppModel::getInstance('Datamart', 'BrowsingControl');
		
		//filter parents
		$current_ctrl_id = $starting_node['BrowsingResult']['browsing_structures_id'];
		$encountered_ctrls = array();
		//drilldowns are automatically stop conditions caused by encountered_ctrls
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
					if($node['BrowsingResult']['browsing_type'] == 'drilldown'){
						//drilldown are automatically rejected
						unset($child_node['nodes'][$k]);
					}else if(!in_array($node['BrowsingResult']['browsing_structures_id'], $encountered_ctrls)){
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
		$current_model = $this->getModelAndStructureForNode($base_browsing_result);
		$current_model = $current_model['model']->name;
		$joins = array();
		foreach($merge_on as $merge_unit){
			$to_model = $this->getModelAndStructureForNode($merge_unit);
			$to_model = $to_model['model']->name;
			$joins[] = $browsing_control_model->getInnerJoinArray($current_model, $to_model, explode(',', $merge_unit['BrowsingResult']['id_csv']));
			$current_model = $to_model;
		}
		return $joins;
	}
	
	function countMaxDuplicates($base_node_id, $target_node_id){
		$joins = $this->getJoins($base_node_id, $target_node_id);

		$base_model = $this->getModelAndStructureForNode((int)$base_node_id);
		$base_model = $base_model['model'];
		$final_model = $this->getModelAndStructureForNode((int)$target_node_id);
		$final_model = $final_model['model'];
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