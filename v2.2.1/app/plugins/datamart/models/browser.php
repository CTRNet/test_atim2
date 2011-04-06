<?php
class Browser extends DatamartAppModel {
	var $useTable = false;
	
	public $checklist_data = array();
	public $checklist_header = array();
	public $checklist_model_name_to_search = null;
	public $checklist_use_key = null;
	public $checklist_result_structure = null;
	public $checklist_sub_models_id_filter = null;

	/**
	 * The action dropdown under browse will be hierarchical or not
	 * @var boolean
	 */
	static $hierarchical_dropdown = false;
	
	/**
	 * The character used to separate model ids in the url 
	 * @var string
	 */
	static $model_separator_str = "_";
	
	/**
	 * The character used to separate sub model id in the url
	 * @var string
	 */
	static $sub_model_separator_str = "-";
	
	/**
	 * @param int $starting_ctrl_id The control id to base the dropdown on. If zero, all will be displayed without export options
	 * @param int $node_id The current node id. 
	 * @param string $plugin_name The name of the plugin to use in export to csv link
	 * @param string $model_name The name of the model to use in export to csv link
	 * @param string $data_model
	 * @param string $model_pkey
	 * @param string $data_pkey
	 * @param string $structure_name The name of the structure to use in export to csv link
	 * @param array $sub_models_id_filter An array with ControlModel => array(ids) to filter the sub models id
	 * @return Returns an array representing the options to display in the action drop down 
	 */
	function getDropdownOptions($starting_ctrl_id, $node_id, $plugin_name, $model_name, $data_model, $model_pkey, $data_pkey, $structure_name, array $sub_models_id_filter = null){
		$app_controller = AppController::getInstance();
		$DatamartStructure = AppModel::atimNew("Datamart", "DatamartStructure", true);
		if($starting_ctrl_id != 0){
			if($plugin_name == null || $model_name == null || $data_model == null || $model_pkey == null || $data_pkey == null || $structure_name == null){
				$app_controller->redirect( '/pages/err_internal?p[]=missing parameter for getDropdownOptions', null, true);
			}
			//the query contains a useless CONCAT to counter a cakephp behavior
			$data = $this->query(
				"SELECT CONCAT(main_id, '') AS main_id, GROUP_CONCAT(to_id SEPARATOR ',') AS to_id FROM( "
				."SELECT id1 AS main_id, id2 AS to_id FROM `datamart_browsing_controls` AS dbc "
				."WHERE dbc.flag_active_1_to_2=1 "
				."UNION "
				."SELECT id2 AS main_id, id1 AS to_id FROM `datamart_browsing_controls` AS dbc "
				."WHERE dbc.flag_active_2_to_1=1 "
				.") AS data GROUP BY main_id ");
			$options = array();
			foreach($data as $data_unit){
				$options[$data_unit[0]['main_id']] = explode(",", $data_unit[0]['to_id']);
			}
			$active_structures_ids = $this->getActiveStructuresIds();
			$browsing_structures = $DatamartStructure->find('all', array('conditions' => array('DatamartStructure.id IN (0, '.implode(", ", $active_structures_ids).')')));
			$tmp_arr = array();
			foreach($browsing_structures as $unit){
				$tmp_arr[$unit['DatamartStructure']['id']] = $unit['DatamartStructure'];
			}
			$browsing_structures = $tmp_arr;
			$rez = Browser::buildBrowsableOptions($options, array(), $starting_ctrl_id, $browsing_structures, $sub_models_id_filter);
			$sorted_rez = array();
			if($rez != null){
				foreach($rez['children'] as $k => $v){
					$sorted_rez[$k] = $v['default'];
				}
				asort($sorted_rez, SORT_STRING);
				foreach($sorted_rez as $k => $foo){
					$sorted_rez[$k] = $rez['children'][$k];
				}
			}else{
				$sorted_rez[] = array(
					'default' => __('nothing to browse to', true),
					'class' => 'disabled',
					'value' => '',
				);
			}
			
			$result[] = array(
				'value' => '',
				'default' => __('browse', true),
				'children' => $sorted_rez
			);
			
			$result = array_merge($result, parent::getDropdownOptions($plugin_name, $model_name, $model_pkey, $structure_name, $data_model, $data_pkey));
			
		}else{
			
			$active_structures_ids = $this->getActiveStructuresIds();
			$data = $DatamartStructure->find('all', array('conditions' => array('DatamartStructure.id IN (0, '.implode(", ", $active_structures_ids).')')));
			$this->getActiveStructuresIds();
			$to_sort = array();
			foreach($data as $k => $v){
				$to_sort[$k] = __($v['DatamartStructure']['display_name'], true);
			}
			asort($to_sort, SORT_STRING);
			foreach($to_sort as $k => $foo){
				$data_unit = $data[$k];
				$tmp_result = array(
					'value' => $data_unit['DatamartStructure']['id'], 
					'default' => __($data_unit['DatamartStructure']['display_name'], true),
					'class' => $data_unit['DatamartStructure']['display_name'],
					'action' => 'datamart/browser/browse/'.$node_id.'/',
					);
					if(strlen($data_unit['DatamartStructure']['control_model']) > 0){
						$ids = isset($sub_models_id_filter[$data_unit['DatamartStructure']['control_model']]) ? $sub_models_id_filter[$data_unit['DatamartStructure']['control_model']] : array(); 
						$children = self::getSubModels($data_unit, $data_unit['DatamartStructure']['id'], $ids);
						if(!empty($children)){
							$tmp_result['children'] = $children;
						} 
					}
					
				$result[] = $tmp_result;
			}
		}
		return $result;
	}
	
	/**
	 * Builds the browsable part of the array for action menu
	 * @param array $from_to An array containing the possible destinations for each keys
	 * @param array $stack An array of the elements already fetched by the current recursion
	 * @param Int $current_id The current not control id
	 * @param array $browsing_structures An array containing data about all available browsing structures. Used to get the displayed value
	 * @param array $sub_models_id_filter An array with ControlModel => array(ids) to filter the sub models id 
	 * @return An array representing the browsable portion of the action menu
	 */
	function buildBrowsableOptions(array $from_to, array $stack, $current_id, array $browsing_structures, array $sub_models_id_filter = null){
		$result = null;
		if(isset($from_to[$current_id])){
			$result = array();
			array_push($stack, $current_id);
			$to_arr = array_diff($from_to[$current_id], $stack);
			$result['default'] = __($browsing_structures[$current_id]['display_name'], true);
			$result['class'] = $browsing_structures[$current_id]['display_name'];
			$tmp = array_shift($stack);
			$result['value'] = implode(self::$model_separator_str, $stack);
			array_unshift($stack, $tmp);
			if(count($stack) > 1){
				$result['children'] = array(
								array(
									'value' => $result['value'],
									'default' => __('filter', true)),
								array(
									'value' => $result['value']."/true/",
									'default' => __('no filter', true))
								);
				if(strlen($browsing_structures[$current_id]['control_model']) > 0){
					$id_filter = isset($sub_models_id_filter[$browsing_structures[$current_id]['control_model']]) ? $sub_models_id_filter[$browsing_structures[$current_id]['control_model']] : null;
					$result['children'] = array_merge($result['children'], self::getSubModels(array("DatamartStructure" => $browsing_structures[$current_id]), $result['value'], $id_filter));
				}
			}
			foreach($to_arr as $to){
				if(Browser::$hierarchical_dropdown){
					$tmp_result = $this->buildBrowsableOptions($from_to, $stack, $to, $browsing_structures, $sub_models_id_filter);
					if($tmp_result != null){
						$result['children'][] = $tmp_result;
					} 
				}else{
					$tmp_result = $this->buildBrowsableOptions($from_to, $stack, $to, $browsing_structures, $sub_models_id_filter);
					if($tmp_result != null){
						if(isset($tmp_result['children'])){
							foreach($tmp_result['children'] as $key => $child){
								if(isset($child['children'])){
									$result['children'][] = $child;
									unset($tmp_result['children'][$key]);
								}
							}
						}
						$result['children'][] = $tmp_result;
					}
				}
			}
			array_pop($stack); 
		}
		return $result;
	}
	
	/**
	 * @param array $main_model_info A DatamartStructure model data array of the node to fetch the submodels of
	 * @param string $prepend_value A string to prepend to the value
	 * @param array ids_filter An array to filter the controls ids of the current sub model
	 * @return array The data about the submodels of the given model
	 */
	static function getSubModels(array $main_model_info, $prepend_value, array $ids_filter = null){
		//we need to fetch the controls
		$control_model = AppModel::atimNew($main_model_info['DatamartStructure']['plugin'], $main_model_info['DatamartStructure']['control_model'], true);
		$conditions = array();
		if($main_model_info['DatamartStructure']['control_model'] == "SampleControl"){
			//hardcoded SampleControl filtering
			$parentToDerivativeSampleControl = AppModel::atimNew("Inventorymanagement", "ParentToDerivativeSampleControl", true);
			$tmp_ids = $parentToDerivativeSampleControl->getActiveSamples();
			if($ids_filter == null){
				$ids_filter = $tmp_ids;
			}else{
				array_intersect($ids_filter, $tmp_ids);
			}
		}
		$ids_filter[] = 0;
		if($ids_filter != null){
			$conditions[] = $main_model_info['DatamartStructure']['control_model'].'.id IN('.implode(", ", $ids_filter).')';
		}
		if(isset($control_model->_schema['flag_active'])){
			$conditions[$main_model_info['DatamartStructure']['control_model'].'.flag_active'] = 1;
		}
		$children_data = $control_model->find('all', array('order' => $main_model_info['DatamartStructure']['control_model'].'.databrowser_label', 'conditions' => $conditions, 'recursive' => 0));
		$children_arr = array();
		foreach($children_data as $child_data){
			$label = self::getTranslatedDatabrowserLabel($child_data[$main_model_info['DatamartStructure']['control_model']]['databrowser_label']);
			$children_arr[] = array(
				'value' => $prepend_value.self::$sub_model_separator_str.$child_data[$main_model_info['DatamartStructure']['control_model']]['id'],
				'default' => $label
			);
		}
		return $children_arr;
	}
	
	/**
	 * Recursively builds a tree node by node.
	 * @param Int $node_id The node id to fetch
	 * @param Int $active_node The node to hihglight in the graph
	 * @param Array $merged_ids The merged nodes ids
	 * @param Array $linked_types_down Should be left blank when calling the function. Internally used to know when to stop to display the "merge" button
	 * @param Array $linked_types_up Should be left blank when calling the function. Internally used to know when to stop to display the "merge" button
	 * @return An array representing the search tree
	 */
	static function getTree($node_id, $active_node, $merged_ids, array &$linked_types_down = array(), array &$linked_types_up = array()){
		$BrowsingResult = new BrowsingResult();
		$result = $BrowsingResult->find('all', array('conditions' => 'BrowsingResult.id='.$node_id.' OR BrowsingResult.parent_node_id='.$node_id, 'order' => array('BrowsingResult.id'), 'recursive' => 1));
		$tree_node = NULL;
		if($tree_node = array_shift($result)){
			$tree_node['active'] = $node_id == $active_node;
			$tree_node['children'] = array();
			$children = array();
			while($node = array_shift($result)){
				$children[] = $node['BrowsingResult']['id'];
			}
			
			//going down the tree
			$drilldown_allow_merge = !$tree_node['BrowsingResult']['raw'] && in_array($tree_node['BrowsingResult']['browsing_structures_id'], $linked_types_down); 
			if($drilldown_allow_merge){
				//drilldown, remove the last entry to allow the current one to be flag as mergeable 
				array_pop($linked_types_down);
			}
			$merge = (count($linked_types_down) > 0 || $tree_node['active'] || $drilldown_allow_merge) && !in_array($tree_node['BrowsingResult']['browsing_structures_id'], $linked_types_down);
			if($merge){
				array_push($linked_types_down, $tree_node['BrowsingResult']['browsing_structures_id']);
				if($node_id != $active_node){
					$tree_node['merge'] = true;
				}
			}
			foreach($children as $child){
				if($merge){
					$child_node = Browser::getTree($child, $active_node, $merged_ids, $linked_types_down, $linked_types_up);
				}else{
					$child_node = Browser::getTree($child, $active_node, $merged_ids, $foo = array(), $linked_types_up);
				}
				$tree_node['children'][] = $child_node;
				$tree_node['active'] = $child_node['active'] || $tree_node['active'];
				if(!isset($tree_node['merge']) && (($child_node['merge'] && $node_id != $active_node) || $child_node['BrowsingResult']['id'] == $active_node)){
					array_push($linked_types_up, $child_node['BrowsingResult']['browsing_structures_id']);
					if(!in_array($tree_node['BrowsingResult']['browsing_structures_id'], $linked_types_up) || !$child_node['BrowsingResult']['raw']){
						$tree_node['merge'] = true;
					}
				}
			}
			if($merge && !$tree_node['active'] && !$drilldown_allow_merge){
				//moving back up to active node, we pop
				array_pop($linked_types_down);
			}
		}
		if(!isset($tree_node['merge'])){
			$tree_node['merge'] = false;
		}
		if(!empty($merged_ids) && (in_array($node_id, $merged_ids) || $node_id == $active_node)){
			$tree_node['paint_merged'] = true;
		}
		return $tree_node;
	}
	
	/**
	 * Builds a representation of the tree within an array
	 * @param array $tree_node A node and its informations
	 * @param array &$tree An array with the current tree representation
	 * @param Int $x The current x location
	 * @param Int $y The current y location
	 */
	static function buildTree(array $tree_node, &$tree = array(), $x = 0, &$y = 0){
		if($tree_node['active'] && $tree != null){
			self::drawActiveLine($tree, $x, $y);
		}
		
		$tree[$y][$x] = $tree_node;
		if(count($tree_node['children'])){
			$looped = false;
			$last_arrow_x = NULL;
			$last_arrow_y = NULL;
			foreach($tree_node['children'] as $pos => $child){
				$merge = isset($tree_node['paint_merged']) && isset($child['paint_merged']) ? " merged" : "";
				$tree[$y][$x + 1] = "h-line".$merge;
				if($looped){
					$tree[$y][$x] = "arrow".$merge;
					$last_arrow_x = $x;
					$last_arrow_y = $y;
					$curr_y = $y - 1;
					while(!isset($tree[$curr_y][$x])){
						$tree[$curr_y][$x] = "v-line".$merge;
						$curr_y --;
					}
				}
				$active_x = null;
				$active_y = null;
				if(!$child['BrowsingResult']['raw'] || !$tree_node['BrowsingResult']['raw']){
					Browser::buildTree($child, $tree, $x + 2, $y);
				}else{
					$tree[$y][$x + 2] = "h-line".$merge;
					$tree[$y][$x + 3] = "h-line".$merge;
					Browser::buildTree($child, $tree, $x + 4, $y);
				}
				
				$y ++;
				$looped = true;
			}
			
			$y --;
			if($last_arrow_x !== NULL){
				$check_up_merge = false;
				$apply_merge = false;
				if($tree[$last_arrow_y][$last_arrow_x] == "arrow"){
					$tree[$last_arrow_y][$last_arrow_x] = "corner";
					$check_up_merge = true;
				}else if($tree[$last_arrow_y][$last_arrow_x] == "arrow merged"){
					$tree[$last_arrow_y][$last_arrow_x] = "corner merged";
					$check_up_merge = true;
					$apply_merge = true;
				}else if($tree[$last_arrow_y][$last_arrow_x] == "arrow active"){
					$tree[$last_arrow_y][$last_arrow_x] = "corner active";
				}else if($tree[$last_arrow_y][$last_arrow_x] == "arrow merged active"){
					$tree[$last_arrow_y][$last_arrow_x] = "corner merged active";
					$check_up_merge = true;
					$apply_merge = true;
				}
				
				if($check_up_merge){
					-- $last_arrow_y;
					while(is_string($tree[$last_arrow_y][$last_arrow_x])){
						if($apply_merge){
							if($tree[$last_arrow_y][$last_arrow_x] == "arrow"){
								$tree[$last_arrow_y][$last_arrow_x] .= " merged_straight";
							}else if($tree[$last_arrow_y][$last_arrow_x] == "v-line" || $tree[$last_arrow_y][$last_arrow_x] == "v-line active"){
								$tree[$last_arrow_y][$last_arrow_x] .= " merged";
							}else if($tree[$last_arrow_y][$last_arrow_x] == "arrow active_straight"){
								$tree[$last_arrow_y][$last_arrow_x] = "arrow active_straight merged";
							}
						}else if($tree[$last_arrow_y][$last_arrow_x] == "arrow merged" || $tree[$last_arrow_y][$last_arrow_x] == "arrow merged active"){
							$apply_merge = true;
						}
						-- $last_arrow_y;
					}
				}
			}
		}
	}
	
	/**
	 * Update the line to print it in blue between the given position and the parent node
	 * @param array $tree
	 * @param int $active_x The current active node x position
	 * @param int $active_y The current active node y position
	 */
	private static function drawActiveLine(array &$tree, $active_x, $active_y){
		//draw the active line
		$left_arr = array("h-line", "arrow", "corner", "h-line merged", "arrow merged", "corner merged");
		$counter = 0;
		while($active_x >= 0 && $active_y >= 0){
			//try left
			if(isset($tree[$active_y][$active_x - 1])){
				if(in_array($tree[$active_y][$active_x - 1], $left_arr)){
					$tree[$active_y][$active_x - 1] .= " active";
					-- $active_x;
				}else{
					//else it's a node
					break;
				}
			}else if(isset($tree[$active_y - 1][$active_x])){
				if($tree[$active_y - 1][$active_x] == "v-line" || $tree[$active_y - 1][$active_x] == "v-line merged"){
					$tree[$active_y - 1][$active_x] .= " active";
				}else if($tree[$active_y - 1][$active_x] == "arrow"){
					$tree[$active_y - 1][$active_x] .= " active_straight";
				}else if($tree[$active_y - 1][$active_x] == "arrow merged_straight"){
					$tree[$active_y - 1][$active_x] = "arrow active_straight merged";
				}else{
					//it's a node
					break;
				}
				-- $active_y;
			}else{
				break;
			}
			++ $counter;
			assert($counter < 100) or die("invalid loop");
		}
	}
	
	/**
	 * @param Int $current_node The id of the current node. Its path will be highlighted
	 * @param array $merged_ids The id of the merged node
	 * @param String $webroot_url The webroot of ATiM
	 * @return the html of the table search tree
	 */
	static function getPrintableTree($current_node, array $merged_ids, $webroot_url){
		$result = "";
		$BrowsingResult = new BrowsingResult();
		$tmp_node = $current_node;
		$prev_node = NULL;
		do{
			$prev_node = $tmp_node;
			$br = $BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $tmp_node)));
			if(!empty($br)){
				$tmp_node = $br['BrowsingResult']['parent_node_id'];
			}
		}while($tmp_node);
		$fm = Browser::getTree($prev_node, $current_node, $merged_ids);
		Browser::buildTree($fm, $tree);
		$result .= "<table class='structure'><tr><td style='padding-left: 10px;'>".__("browsing", true)
			."<table class='databrowser'>\n";
		ksort($tree);
		
		foreach($tree as $y => $line){
			$result .= '<tr><td></td>';//print a first empty column, css will print an highlighted h-line in the top left cell
			$last_x = -1;
			ksort($line);
			foreach($line as $x => $cell){
				$pad = $x - $last_x - 1;
				$pad_pos = 0;
				while($pad > 0){
					$result .= '<td></td>';
					$pad --;
				}
				if(is_array($cell)){
					$class = $cell['DatamartStructure']['display_name'];
					if($cell['active']){
						$class .= " active ";
					}
					if(isset($cell['paint_merged'])){
						$class .= " merged";
					}
					$count = strlen($cell['BrowsingResult']['id_csv']) ? count(explode(",", $cell['BrowsingResult']['id_csv'])) : 0;
					$title = __($cell['DatamartStructure']['display_name'], true);
					$info = "";
					$search_datetime = AppController::getFormatedDatetimeString($cell['BrowsingResult']['created'], true, true);
					if($cell['BrowsingResult']['raw']){
						$search = unserialize($cell['BrowsingResult']['serialized_search_params']);
						if(count($search['search_conditions'])){
							$structure = null;
							if(strlen($cell['DatamartStructure']['control_model']) > 0 && $cell['BrowsingResult']['browsing_structures_sub_id'] > 0){
								//alternate structure required
								$alternate_alias = self::getAlternateStructureInfo($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['control_model'], $cell['BrowsingResult']['browsing_structures_sub_id']);
								$alternate_alias = $alternate_alias['form_alias'];
								$structure = StructuresComponent::$singleton->get('form', $alternate_alias);
							 	//unset the serialization on the sub model since it's already in the title
							 	unset($search['search_conditions'][$cell['DatamartStructure']['control_master_model'].".".$cell['DatamartStructure']['control_field']]);
							 	$tmp_model = AppModel::atimNew($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['control_master_model'], true);
							 	$tmp_data = $tmp_model->find('first', array('conditions' => array($cell['DatamartStructure']['control_model'].".id" => $cell['BrowsingResult']['browsing_structures_sub_id']), 'recursive' => 0));
							 	$title .= " > ".self::getTranslatedDatabrowserLabel($tmp_data[$cell['DatamartStructure']['control_model']]['databrowser_label']);
							}else{
								$structure = StructuresComponent::$singleton->getFormById($cell['DatamartStructure']['structure_id']);
							}
							if(count($search['search_conditions'])){//count might be zero if the only condition was the sub type
								$info .= __("search", true)." - ".$search_datetime."<br/><br/>".Browser::formatSearchToPrint($search, $structure);
							}else{
								$info .= __("direct access", true)." - ".$search_datetime;
							}
						}else{
							$info .= __("direct access", true)." - ".$search_datetime;
						}
					}else{
						$info .= __("drilldown", true)." - ".$search_datetime;
					}
					$content = "<div class='content'><span class='title'>".$title."</span> (".$count.")<br/>\n".$info."</div>";
					$controls = "<div class='controls'>%s</div>";
					$link = $webroot_url."datamart/browser/browse/";
					if(isset($cell['merge']) && $cell['merge']){
						$controls = sprintf($controls, "<a class='link' href='".$link.$current_node."/0/".$cell['BrowsingResult']['id']."' title='".__("link to current view", true)."'/>&nbsp;</a>");
					}else{
						$controls = sprintf($controls, "");
					}
					$box = "<div class='info %s'>%s%s</div>";
					if($x < 16){
						//right
						$box = sprintf($box, "right", $controls, $content);
					}else{
						//left
						$box = sprintf($box, "left", $content, $controls);
					}
					$result .= "<td class='node ".$class."'><div class='container'><a class='box20x20' href='".$link.$cell['BrowsingResult']['id']."/'></a>".$box."</div></td>";
				}else{
					$result .= "<td class='".$cell."'></td>";
				}
				$last_x = $x;
			}
			$result .= "</tr>\n";
		}
		$result .= '</table></td></tr></table>';
		return $result;
	}
	
	
	/**
	 * Formats the search params array and returns it into a table
	 * @param array $search_params The search params array
	 * @param Int $structure_id The structure id to base the search params on
	 * @return An html string of a table containing the search formated params
	 */
	static function formatSearchToPrint(array $search_params, array $structure){
		$params = $search_params['search_conditions'];
		$keys = array_keys($params);
		App::import('model', 'StructureFormat');
		$StructureFormat = new StructureFormat();
		$conditions = array();
		$conditions[] = "false";
		foreach($keys as $key){
			if(is_numeric($key)){
				//it's a textual field (model.field LIKE %foo1% OR model.field LIKE %foo2% ...)
				list($model_field) = explode(" ", $params[$key]);
				$model_field = substr($model_field, 1);
				list($model, $field) = explode(".", $model_field);
			}else{
				//it's a range or a dropdown
				//key = field[ >=] 
				$parts = explode(" ", $key);
				list($model, $field) = explode(".", $parts[0]);
			}
			$conditions[] = "StructureField.model='".$model."' AND StructureField.field='".$field."'";
		}
		$result = "<table align='center' width='100%' class='browserBubble'>";
		//value_element can ben a string or an array
		foreach($params as $key => $value_element){
			$values = array();
			$name = "";
			$name_suffix = "";
			if(is_numeric($key)){
				//it's a textual field (model.field LIKE %foo1% OR model.field LIKE %foo2% ...)
				$values = array();
				$parts = explode(" OR ", substr($value_element, 1, -1));//strip first and last parenthesis
				foreach($parts as $part){
					list($model_field, , $value) = explode(" ", $part);
					list($model, $field) = explode(".", $model_field);
					$values[] = substr($value, 2, -2);
				}
			}else if(is_array($value_element)){
				//it's coming from a dropdown
				$values = $value_element;
				list($model, $field) = explode(".", $key);
			}else{
				//it's a range
				//key = field with possibly a comparison (field >=, field <=), if no comparison, it's = 
				//value = value_str
				if(strpos($value_element, "-")){
					list($year, $month, $day) = explode("-", $value_element);
					$values[] = AppController::getFormatedDateString($year, $month, $day);
				}else{
					$values[] = $value_element;
				}
				if(strpos($key, " ") !== false){
					list($key, $name_suffix) = explode(" ", $key);
				}
				list($model, $field) = explode(".", $key);
			}
			foreach($structure['Sfs'] as $sf_unit){
				if($sf_unit['model'] == $model && $sf_unit['field'] == $field){
					$name = __($sf_unit['language_label'], true);
					if(isset($sf_unit['StructureValueDomain']['StructurePermissibleValue'])){
						//field with permissible values, take the values from there
						foreach($values as &$value){//foreach values
							foreach($sf_unit['StructureValueDomain']['StructurePermissibleValue'] as $p_value){//find the match
								if($p_value['value'] == $value){//match found
									if(strlen($sf_unit['StructureValueDomain']['source']) > 0){
										//value comes from a source, it's already translated
										$value = $p_value['default'];
									}else{
										$value = __($p_value['language_alias'], true);
									}
									break; 
								}
							}
						}
					}
					break;
				}
			}
			$result .= "<tr><th>".$name." ".$name_suffix."</th><td>".implode(", ", $values)."</td>\n";
		}
		$result .= "<tr><th>".__("exact search", true)."</th><td>".($search_params['exact_search'] ? __("yes", true) : __('no', true))."</td>\n";
		$result .= "</table>";
		return $result;
	}
	
	/**
	 * @param string $plugin The name of the plugin to search on
	 * @param string $control_model The name of the control model to search on
	 * @param int $id The id of the alternate structure to retrieve
	 * @return string The info of the alternate structure
	 */
	static function getAlternateStructureInfo($plugin, $control_model, $id){
		$model_to_use = AppModel::atimNew($plugin, $control_model, true);
		$data = $model_to_use->find('first', array('conditions' => array($control_model.".id" => $id)));
		return $data[$control_model];
	}
	
	/**
	 * Updates an index link
	 * @param string $link
	 * @param string $prev_model
	 * @param string $new_model
	 * @param string $prev_pkey
	 * @param string $new_pkey
	 */
	static function updateIndexLink($link, $prev_model, $new_model, $prev_pkey, $new_pkey){
		return str_replace("%%".$prev_model.".",  "%%".$new_model.".",
			str_replace("%%".$prev_model.".".$prev_pkey."%%", "%%".$new_model.".".$new_pkey."%%", $link));
	}
	
	/**
	 * @desc Filters the required sub models controls ids based on the current sub control id. NOTE: This
	 * function is hardcoded for Storage and Aliquots using some specific db id.</p>
	 * @param array $browsing The DatamartStructure and BrowsingResult data to base the filtering on.
	 * @return An array with the ControlModel => array(ids to filter with)
	 */
	static function getDropdownSubFiltering(array $browsing){
		$sub_models_id_filter = array();
		if($browsing['DatamartStructure']['id'] == 5){
			//sample->aliquot hardcoded part
			assert($browsing['DatamartStructure']['control_master_model'] == "SampleMaster");//will print a warning if the id and field dont match anymore
			$stac = AppModel::atimNew("Inventorymanagement", "SampleToAliquotControl", true);
			$data = $stac->find('all', array('conditions' => array("SampleToAliquotControl.sample_control_id" => $browsing['BrowsingResult']['browsing_structures_sub_id'], "SampleToAliquotControl.flag_active" => 1), 'recursive' => -1));
			$ids = array();
			foreach($data as $unit){
				$ids[] = $unit['SampleToAliquotControl']['aliquot_control_id'];
			}
			$sub_models_id_filter['AliquotControl'] = $ids;
		}else if($browsing['DatamartStructure']['id'] == 1){
			//aliquot->sample hardcoded part
			assert($browsing['DatamartStructure']['control_master_model'] == "AliquotMaster");//will print a warning if the id and field doesnt match anymore
			$stac = AppModel::atimNew("Inventorymanagement", "SampleToAliquotControl", true);
			$data = $stac->find('all', array('conditions' => array("SampleToAliquotControl.aliquot_control_id" => $browsing['BrowsingResult']['browsing_structures_sub_id'], "SampleToAliquotControl.flag_active" => 1), 'recursive' => -1));
			$ids = array();
			foreach($data as $unit){
				$ids[] = $unit['SampleToAliquotControl']['sample_control_id'];
			}
			$sub_models_id_filter['SampleControl'] = $ids;
		}
		return $sub_models_id_filter;
	}
	
	
	/**
	 * @desc Databrowser lables are string that can be separated by |. Translation will occur on each subsection and replace the pipes by " - "
	 * @param string $label The label to translate
	 * @return string The translated label
	 */
	static function getTranslatedDatabrowserLabel($label){
		$parts = explode("|", $label);
		foreach($parts as &$part){
			$part = __($part, true);
		}
		return implode(" - ", $parts);
	}
	
	private function getActiveStructuresIds(){
		$BrowsingControl = AppModel::atimNew("Datamart", "BrowsingControl", true);
		$data =  $BrowsingControl->find('all');
		$result = array();
		foreach($data as $unit){
			if($unit['BrowsingControl']['flag_active_1_to_2']){
				$result[$unit['BrowsingControl']['id2']] = null;
			}
			if($unit['BrowsingControl']['flag_active_2_to_1']){
				$result[$unit['BrowsingControl']['id1']] = null;
			}
		}
		
		return array_keys($result);
	}
	
	/**
	 * Fetches all checklist related data and stores it in the object
	 * @param array $browsing
	 * @param int $display_limit
	 */
	public function fetchCheckList(array $browsing, $display_limit){
		$model_to_import = null;
		$this->checklist_model_name_to_search = null;
		$this->checklist_use_key = null;
		$this->checklist_result_structure = null;
		//check for detailed structure
		$this->checklist_sub_models_id_filter = array();
		App::import("Model", "StructuresComponent", true);
		$structures = new StructuresComponent();
		if(strlen($browsing['DatamartStructure']['control_model']) > 0 && $browsing['BrowsingResult']['browsing_structures_sub_id'] > 0){
			$alternate_info = Browser::getAlternateStructureInfo(
				$browsing['DatamartStructure']['plugin'], 
				$browsing['DatamartStructure']['control_model'], 
				$browsing['BrowsingResult']['browsing_structures_sub_id']);
			$alternate_alias = $alternate_info['form_alias'];
			$this->checklist_result_structure = $structures->get('form', $alternate_alias);
			$model_to_import = $browsing['DatamartStructure']['control_master_model'];
			$this->checklist_model_name_to_search = $browsing['DatamartStructure']['control_master_model'];
			$this->checklist_use_key = "id";
			$this->checklist_header = array("title" => __("result", true), "description" => __($browsing['DatamartStructure']['display_name'], true)." > ".Browser::getTranslatedDatabrowserLabel($alternate_info['databrowser_label']));
			$this->checklist_sub_models_id_filter = Browser::getDropdownSubFiltering($browsing);
			$browsing['DatamartStructure']['index_link'] = Browser::updateIndexLink($browsing['DatamartStructure']['index_link'], $browsing['DatamartStructure']['model'], $browsing['DatamartStructure']['control_master_model'], $browsing['DatamartStructure']['use_key'], "id");
		}else{
			$this->checklist_result_structure = $structures->getFormById($browsing['DatamartStructure']['structure_id']);
			$model_to_import = $browsing['DatamartStructure']['model'];
			$this->checklist_model_name_to_search = $browsing['DatamartStructure']['model'];
			$this->checklist_use_key = $browsing['DatamartStructure']['use_key'];
			$this->checklist_header = array("title" => __("result", true), "description" => __($browsing['DatamartStructure']['display_name'], true));
			$this->checklist_sub_models_id_filter = array("AliquotControl" => array(0));//by default, no aliquot sub type
		}
		
		$this->ModelToSearch = AppModel::atimNew($browsing['DatamartStructure']['plugin'], $model_to_import, true);
		if(strlen($browsing['BrowsingResult']['id_csv']) > 0){
			$conditions[$this->checklist_model_name_to_search.".".$this->checklist_use_key] = explode(",", $browsing['BrowsingResult']['id_csv']);
			
			//fetch the count since deletions might make the set smaller than the count of ids
			$count = $this->ModelToSearch->find('count', array('conditions' => $conditions));
			if($count > $display_limit){
				$data = $this->ModelToSearch->find('all', array('conditions' => $conditions, 'fields' => array("CONCAT('', ".$this->checklist_model_name_to_search.".".$this->checklist_use_key.") AS ids"), 'recursive' => -1));
				$this->checklist_data = implode(",", array_map(create_function('$val', 'return $val[0]["ids"];'), $data));
			}else{
				if($browsing['BrowsingResult']['browsing_structures_sub_id'] > 0){
					//add the control_id to the search conditions to benefit from direct inner join on detail
					$conditions[$browsing['DatamartStructure']['control_master_model'].".".$browsing['DatamartStructure']['control_field']] = $browsing['BrowsingResult']['browsing_structures_sub_id'];
				}
				$this->checklist_data = $this->ModelToSearch->find('all', array('conditions' => $conditions, 'recursive' => 0));
			}
		}else{
			$this->data = array();
		}
	}
	
}
