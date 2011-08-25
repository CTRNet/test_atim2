<?php
class Browser extends DatamartAppModel {
	var $useTable = false;
	
	public $checklist_header = array();
	public $checklist_model_name_to_search = null;
	public $checklist_use_key = null;
	public $checklist_sub_models_id_filter = null;
	public $result_structure = null;
	public $count = null;
	public $merged_ids = null;
	
	static private $browsing_control_model = null;
	static private $browsing_result_model = null;
	private $browsing_cache = array();
	private $merge_data = array();
	private $nodes = array();
	private $node_current_index = 0;
	private $rows_buffer = array();
	private $models_buffer = array();
	private $search_parameters = null;
	private $offset = 0;
	
	const NODE_ID = 0;
	const MODEL = 1;
	const IDS = 2;
	const USE_KEY = 3;
	const ANCESTOR_IS_CHILD = 4;
	const JOIN_FIELD = 5;

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
	 * @param array $sub_models_id_filter An array with ControlModel => array(ids) to filter the sub models id
	 * @return Returns an array representing the options to display in the action drop down 
	 */
	function getDropdownOptions($starting_ctrl_id, $node_id, $plugin_name, $model_name, $data_model, $model_pkey, $data_pkey, array $sub_models_id_filter = null){
		$app_controller = AppController::getInstance();
		$DatamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
		if($starting_ctrl_id != 0){
			if($plugin_name == null || $model_name == null || $data_model == null || $model_pkey == null || $data_pkey == null){
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
			
			//TODO: remove "foo" in 2.4.0
			$result = array_merge($result, parent::getDropdownOptions($plugin_name, $model_name, $model_pkey, "foo", $data_model, $data_pkey));
			
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
		$control_model = AppModel::getInstance($main_model_info['DatamartStructure']['plugin'], $main_model_info['DatamartStructure']['control_model'], true);
		$conditions = array();
		if($main_model_info['DatamartStructure']['control_model'] == "SampleControl"){
			//hardcoded SampleControl filtering
			$parentToDerivativeSampleControl = AppModel::getInstance("Inventorymanagement", "ParentToDerivativeSampleControl", true);
			$tmp_ids = $parentToDerivativeSampleControl->getActiveSamples();
			if($ids_filter == null){
				$ids_filter = $tmp_ids;
			}else{
				array_intersect($ids_filter, $tmp_ids);
			}
		}
		
		if($ids_filter != null){
			$ids_filter[] = 0;
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
			assert($br);
			$tmp_node = $br['BrowsingResult']['parent_node_id'];
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
							 	$tmp_model = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['control_master_model'], true);
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
						}else if($cell['BrowsingResult']['parent_node_id'] == 0 && empty($cell['BrowsingResult']['serialized_search_params'])){
							$info .= __("from batchset", true)." - ".$search_datetime;
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
		
		//preprocess to clena datetime accuracy
		foreach($params as $key => $value){
			if(is_array($value) && isset($value['OR'][0])){
				$tmp = current($value['OR'][0]);
				$params[key($value['OR'][0])] = $tmp;
				unset($params[$key]);
			}
		}

		$keys = array_keys($params);
		App::import('model', 'StructureFormat');
		$StructureFormat = new StructureFormat();
		$conditions = array();
		$conditions[] = "false";
		foreach($keys as $key){
			if(is_numeric($key)){
				//it's a textual field (model.field LIKE %foo1% OR model.field LIKE %foo2% ...) or an "OR"
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
		//value_element can be a string or an array
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
			$structure_value_domain_model = null;
			foreach($structure['Sfs'] as &$sf_unit){
				if($sf_unit['model'] == $model && $sf_unit['field'] == $field){
					$name = __($sf_unit['language_label'], true);
					
					if(!empty($sf_unit['StructureValueDomain'])){
						if(!isset($sf_unit['StructureValueDomain']['StructurePermissibleValue'])){
							if(isset($sf_unit['StructureValueDomain']['source']) && strlen($sf_unit['StructureValueDomain']['source']) > 0){
								$sf_unit['StructureValueDomain']['StructurePermissibleValue'] = StructuresComponent::getPulldownFromSource($sf_unit['StructureValueDomain']['source']);
							}else{
								if($structure_value_domain_model == null){
									App::import('model', "StructureValueDomain");
									$structure_value_domain_model = new StructureValueDomain();
								}
								$tmp_dropdown_result = $structure_value_domain_model->find('first', array(
											'recursive' => 2,
											'conditions' => 
												array('StructureValueDomain.id' => $sf_unit['StructureValueDomain']['id'])));
								$dropdown_values = array();
								foreach($tmp_dropdown_result['StructurePermissibleValue'] as $value_array){
									$dropdown_values[$value_array['value']] = $value_array['language_alias'];
								}
								$sf_unit['StructureValueDomain']['StructurePermissibleValue'] = $dropdown_values; 
							}
						}
						foreach($values as &$value){//foreach values
							foreach($sf_unit['StructureValueDomain']['StructurePermissibleValue'] as $p_key => $p_value){//find the match
								if($p_key == $value){//match found
									if(strlen($sf_unit['StructureValueDomain']['source']) > 0){
										//value comes from a source, it's already translated
										$value = $p_value;
									}else{
										$value = __($p_value, true);
									}
									break; 
								}
							}
						}
						break;
					}
				}
			}
			$result .= "<tr><th>".$name." ".$name_suffix."</th><td>".stripslashes(implode(", ", $values))."</td>\n";
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
		$model_to_use = AppModel::getInstance($plugin, $control_model, true);
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
			$sm = AppModel::getInstance("Inventorymanagement", "SampleMaster", true);
			$sm_data = $sm->find('all', array(
				'fields'		=> array('SampleMaster.sample_control_id'),
				'conditions'	=> array("SampleMaster.id" => explode(",", $browsing['BrowsingResult']['id_csv'])),
				'group'			=> array('SampleMaster.sample_control_id'),
				'recursive'		=> -1)
			);
			if(count($sm_data) == 1){
				$ac = AppModel::getInstance("Inventorymanagement", "AliquotControl", true);
				$data = $ac->find('all', array('conditions' => array("AliquotControl.sample_control_id" => $sm_data[0]['SampleMaster']['sample_control_id'], "AliquotControl.flag_active" => 1), 'fields' => 'AliquotControl.id', 'recursive' => -1));
				$ids = array();
				foreach($data as $unit){
					$ids[] = $unit['AliquotControl']['id'];
				}
				$sub_models_id_filter['AliquotControl'] = $ids;
			}else{
				$sub_models_id_filter['AliquotControl'][] = 0;
			}
		}else if($browsing['DatamartStructure']['id'] == 1){
			//aliquot->sample hardcoded part
			assert($browsing['DatamartStructure']['control_master_model'] == "AliquotMaster");//will print a warning if the id and field doesnt match anymore
			$am = AppModel::getInstance("Inventorymanagement", "AliquotMaster", true);
			$am_data = $am->find('all', array(
				'fields'		=> array('AliquotMaster.aliquot_control_id'),
				'conditions'	=> array('AliquotMaster.id' => explode(",", $browsing['BrowsingResult']['id_csv'])),
				'group'			=> array('AliquotMaster.aliquot_control_id'),
				'recursive'		=> -1)
			);
			$ctrl_ids = array();
			foreach($am_data as $data_part){
				$ctrl_ids[] = $data_part['AliquotMaster']['aliquot_control_id'];
			}
			$ac = AppModel::getInstance("Inventorymanagement", "AliquotControl", true);
			$data = $ac->find('all', array('conditions' => array("AliquotControl.id" => $ctrl_ids, "AliquotControl.flag_active" => 1), 'recursive' => -1));
			$ids = array();
			foreach($data as $unit){
				$ids[] = $unit['AliquotControl']['sample_control_id'];
			}
			$sub_models_id_filter['SampleControl'] = $ids;
		}else{
			//only sub filter aliquots if the user is on a sample node
			$sub_models_id_filter['AliquotControl'][] = 0;
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
		$BrowsingControl = AppModel::getInstance("Datamart", "BrowsingControl", true);
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
	 * Builds an ordered array of the nodes to merge
	 * @param array $browsing The browsing data of the first node
	 * @param int $merge_to The id of the final node
	 * @return An array of the nodes to merge
	 */
	private function getNodesToMerge($browsing, $merge_to){
		$nodes_to_fetch = array();
		$start_id = null;
		$end_id = null;
		$descending = null;
		$node_id = $browsing['BrowsingResult']['id'];
		$previous_browsing = $browsing;
		if($merge_to > $node_id){
			$start_id = $merge_to;
			$end_id = $node_id;
			$descending = false;
		}else{
			$start_id = $node_id;
			$end_id = $merge_to;
			$descending = true;
		}
		//fetch from highest id to lowest id
		while($start_id != $end_id){
			$nodes_to_fetch[] = $start_id;
			$browsing = self::$browsing_result_model->cacheAndGet($start_id, $this->browsing_cache);
			$start_id = $browsing['BrowsingResult']['parent_node_id'];
		}
			
		if($descending){
			array_shift($nodes_to_fetch);
			$nodes_to_fetch[] = $end_id;
			self::$browsing_result_model->cacheAndGet($end_id, $this->browsing_cache);
		}
		$this->merged_ids = $nodes_to_fetch;
		
		if($descending){
			//clear drilldown parents
			$remove = $previous_browsing['BrowsingResult']['raw'] == 0;
			foreach($nodes_to_fetch as $index => $node_to_fetch){
				if($remove){
					unset($nodes_to_fetch[$index]);
					$remove = false;
				}else{
					$remove = $this->browsing_cache[$node_to_fetch]['BrowsingResult']['raw'] == 0;
				}
			}
		}else{
			$nodes_to_fetch = array_reverse($nodes_to_fetch);
			//clear drilldowns
			foreach($nodes_to_fetch as $index => $node_to_fetch){
				if($this->browsing_cache[$node_to_fetch]['BrowsingResult']['raw'] == 0){
					unset($nodes_to_fetch[$index]);
				}
			}
		}
		
		return $nodes_to_fetch;
	}
	
	/**
	 * Builds the search parameters array
	 * @note: Hardcoded for collections
	 */
	private function buildBufferedSearchParameters(){
		$joins = array();
		$fields = array();
		$order = array();
		for($i = 1; $i < count($this->nodes); ++ $i){
			$node = $this->nodes[$i];
			$ancestor_node = $this->nodes[$i - 1];
			$condition = null;
			$alias = $node[self::MODEL]->name."Browser";
			$ancestor_alias = $i > 1 ? $ancestor_node[self::MODEL]->name."Browser" : $ancestor_node[self::MODEL]->name;
			if($node[self::ANCESTOR_IS_CHILD]){
				$condition = $alias.".".$node[self::USE_KEY]." = ".$ancestor_alias.".".$node[self::JOIN_FIELD];
			}else{
				$condition = $alias.".".$node[self::JOIN_FIELD]." = ".$ancestor_alias.".".$ancestor_node[self::USE_KEY];
			}
			$fields[] = 'CONCAT("", '.$alias.".".$node[self::USE_KEY].') AS '.$alias;
			$order[] = $alias;
			
			$joins[] = array(
				'table' => $node[self::MODEL]->table,
				'alias'	=> $alias,
				'type'	=> 'LEFT',
				'conditions' => array(
					$condition,
					$alias.".".$node[self::USE_KEY] => $node[self::IDS]
				)
			);
		}
		
		//HARDCODED PART FOR COLLECTIONS
		//when going through participants to reach view_collections, sql is slow. Override to go through ccl
		//the other direction (collections to participant) is not affected
		foreach($this->nodes as $index => $node){
			if($index > 0 && $node[self::MODEL]->name == 'ViewCollection' && $this->nodes[$index - 1][self::MODEL]->name == 'Participant'){
				//participant -> collection nodes. Alter it to become participant -> ccl -> collection. Update collection.
				//split the array
				$second_part = array_slice($joins, $index - 1);
				$collection_join = array_shift($second_part);
				$joins = array_slice($joins, 0, $index - 1);
				
				//insert ccls
				$joins[] = array(
					'table' => 'clinical_collection_links',
					'alias'	=> 'ClinicalCollectionLink',
					'type'	=> 'LEFT',
					'conditions' => array(
						($index == 1 ? 'Participant' : 'ParticipantBrowser').'.id = ClinicalCollectionLink.participant_id',
						'ClinicalCollectionLink.collection_id' => $collection_join['conditions']['ViewCollectionBrowser.collection_id'])
				);
				
				//update collection and put it back in the join array
				$collection_join['table'] = 'collections';
				$collection_join['alias'] = 'Collection';
				$new_conditions = array();
				$new_conditions[0] = 'Collection.id = ClinicalCollectionLink.collection_id';
				$new_conditions['Collection.id'] = $collection_join['conditions']['ViewCollectionBrowser.collection_id'];
				$collection_join['conditions'] = $new_conditions;
				$joins[] = $collection_join;
				$fields[$index - 1] = 'CONCAT("", Collection.id) AS Collection';
				$order[$index - 1] = 'Collection';
				
				if(!empty($second_part)){
					//update the next node to use the right collection key
					$next_node = array_shift($second_part);
					$new_conditions = array();
					foreach($next_node['conditions'] as $key => $condition){
						$key = str_replace('ViewCollectionBrowser.collection_id', 'Collection.id', $key);
						$condition = str_replace('ViewCollectionBrowser.collection_id', 'Collection.id', $condition);
						$new_conditions[$key] = $condition;
					}
					$next_node['conditions'] = $new_conditions;
					array_push($joins, $next_node);
					if(!empty($second_part)){
						$joins = array_merge($joins, $second_part);
					}
				}
				break;
			}
		}
		//END OF COLLECTION HARDCODED PART
		
		$node = $this->nodes[0];
		array_unshift($fields, 'CONCAT("", '.$node[self::MODEL]->name.".".$node[self::USE_KEY].') AS '.$node[self::MODEL]->name);
		array_unshift($order, $node[self::MODEL]->name);
		$this->search_parameters = array(
			'fields'		=> $fields,
			'joins'			=> $joins, 
			'conditions'	=> array($node[self::MODEL]->name.".".$node[self::USE_KEY] => $node[self::IDS]),
			'order'			=> $order,
			'recursive'		=> -1
		);
	}
	
	/**
	 * Init the browser model on the current required data display
	 * @param array $browsing Browsing data of the first node
	 * @param int $merge_to Node id of the target node to merge with
	 */
	public function initDataLoad($browsing, $merge_to){
		$result = array();
		$start_id = NULL;
		$end_id = null;
		$node_id = $browsing['BrowsingResult']['id'];
		$main_data = array();//$this->checklist_data;
		$descending = null;
		$result_structure = array();
		$header = array();
		$checklist_model_name = null;
		unset($result_structure['Structure']);
		self::$browsing_control_model = AppModel::getInstance("Datamart", "BrowsingControl", true);
		self::$browsing_result_model = AppModel::getInstance("Datamart", "BrowsingResult", true);
		$nodes_to_fetch = array();
		
		if($merge_to != 0){
			$nodes_to_fetch = $this->getNodesToMerge($browsing, $merge_to);
		}
		
		//prepare nodes_to_fetch_stack
		array_unshift($nodes_to_fetch, $node_id);
		$last_browsing = null;
		$iteration_count = 1;
		$structures_component = new StructuresComponent();
		
		//building the relationship logic between nodes
		foreach($nodes_to_fetch as $node){
			$current_browsing = self::$browsing_result_model->findById($node);
			$this->browsing_cache[$node_id] = $current_browsing;
			$current_model = AppModel::getInstance($current_browsing['DatamartStructure']['plugin'], $current_browsing['DatamartStructure']['model'], true);
			$ids = explode(",", $current_browsing['BrowsingResult']['id_csv']);
			$ids[] = 0;
			$use_key = null;
			
			$control_id = empty($current_browsing['DatamartStructure']['control_master_model']) ? false : $current_model->find('all', array(
				'fields' => array($current_browsing['DatamartStructure']['control_field']),
				'conditions' => array($current_browsing['DatamartStructure']['model'].".".$current_browsing['DatamartStructure']['use_key'] => $ids),
				'group' => array($current_browsing['DatamartStructure']['control_field']), 
				'limit' => 2));
			
			$structure = null;
			$header_sub_type = " ";
			if($control_id && count($control_id) == 1){
				//we can use the specific structure
				$current_model = AppModel::getInstance($current_browsing['DatamartStructure']['plugin'], $current_browsing['DatamartStructure']['control_master_model'], true);
				$use_key = 'id';
				
				//load the structure
				$control_model = AppModel::getInstance($current_browsing['DatamartStructure']['plugin'], $current_browsing['DatamartStructure']['control_model'], true);
				$control_model_data = $control_model->find('first', array(
					'fields' => array($control_model->name.'.form_alias', $control_model->name.'.databrowser_label'), 
					'conditions' => array($current_browsing['DatamartStructure']['control_model'].".id" => $control_id[0][$current_browsing['DatamartStructure']['model']][$current_browsing['DatamartStructure']['control_field']]))
				);
				$structure = $structures_component->get('form', $control_model_data[$current_browsing['DatamartStructure']['control_model']]['form_alias']);
				$header_sub_type = " > ".Browser::getTranslatedDatabrowserLabel($control_model_data[$control_model->name]['databrowser_label'])." ";
				
				if($checklist_model_name == null){
					$this->checklist_model_name_to_search = $current_browsing['DatamartStructure']['control_master_model'];
					$this->checklist_use_key = $use_key;
					$this->checklist_sub_models_id_filter = Browser::getDropdownSubFiltering($current_browsing);
				}
			}else{
				//must use the generic structure (or its empty...)
				$use_key = $current_browsing['DatamartStructure']['use_key'];
				$structure = $structures_component->getFormById($current_browsing['DatamartStructure']['structure_id']);
				if($checklist_model_name == null){
					$this->checklist_model_name_to_search = $current_browsing['DatamartStructure']['model'];
					$this->checklist_use_key = $use_key;
					//$this->checklist_sub_models_id_filter = array("AliquotControl" => array(0));//by default, no aliquot sub type
					$this->checklist_sub_models_id_filter = Browser::getDropdownSubFiltering($current_browsing);
				}
			}

			//structure merge, add 100 * iteration count to display column
			foreach($structure['Sfs'] as $sfs){
				$sfs['display_column'] += 100 * $iteration_count;
				$result_structure['Sfs'][] = $sfs;
			}
			
			$ancestor_is_child = false;
			$join_field = null;
			if($last_browsing != null){
				//determine wheter the current item is a parent or child of the previous one
				$browsing_control = self::$browsing_control_model->find('first', array('conditions' => array('id1' => $last_browsing['DatamartStructure']['id'], 'id2' => $current_browsing['DatamartStructure']['id'])));
				if(empty($browsing_control)){
					//direction parent -> child
					$browsing_control = self::$browsing_control_model->find('first', array('conditions' => array('id2' => $last_browsing['DatamartStructure']['id'], 'id1' => $current_browsing['DatamartStructure']['id'])));
					assert(!empty($browsing_control));
				}else{
					//direction child -> parent
					$ancestor_is_child = true;
				}
				list( , $join_field) = explode(".", $browsing_control['BrowsingControl']['use_field']);
			}
			
			//update header
			$count = $current_model->find('count', array('conditions' => array($current_model->name.".".$use_key => $ids)));
			$header[] = __($current_browsing['DatamartStructure']['display_name'], true).$header_sub_type."(".$count.")";

			$this->nodes[] = array(
				self::NODE_ID => $node, 
				self::IDS => $ids, 
				self::MODEL => $current_model, 
				self::USE_KEY => $use_key,
				self::ANCESTOR_IS_CHILD => $ancestor_is_child,
				self::JOIN_FIELD => $join_field
			);
			$last_browsing = $current_browsing;
			++ $iteration_count;
		}
		
		
		//prepare buffer conditions
		$this->buildBufferedSearchParameters();

		$this->count = $this->nodes[0][self::MODEL]->find('count', array('joins' => $this->search_parameters['joins'], 'conditions' => $this->search_parameters['conditions'], 'recursive' => 0));
		$this->checklist_header = implode(" - ", $header); 
		$this->result_structure = $result_structure;
	}
	
	private function fillBuffer($chunk_size){
		$this->search_parameters['limit'] = $chunk_size;
		$this->search_parameters['offset'] = $this->offset;
		
		$lines = $this->nodes[0][self::MODEL]->find('all', $this->search_parameters);
		$this->offset += $chunk_size;
		
		$this->rows_buffer = array();
		$this->models_buffer = array();
		foreach($lines as $line){
			$this->rows_buffer[] = array_values($line[0]);
			$i = 0;
			foreach($line[0] as $model_id){
				$this->models_buffer[$i ++][$model_id] = null; 
			}
		}
		
		foreach($this->models_buffer as &$models){
			$models = array_keys($models);
		}
	}
	
	/**
	 * @param unknown_type $chunk_size
	 * @return Returns an array of a portion of the data. Successive calls move the pointer forward.
	 */
	public function getDataChunk($chunk_size){
		$this->fillBuffer($chunk_size);
		if(empty($this->rows_buffer)){
			$chunk = array();
		}else{
			$chunk = array_fill(0, count($this->rows_buffer), array());
			$node = null;
			foreach($this->models_buffer as $model_index => $model_ids){
				$node = $this->nodes[$model_index];
				$model_data = $node[self::MODEL]->find('all', array('conditions' => array($node[self::MODEL]->name.".".$node[self::USE_KEY] => $model_ids), 'recursive' => 0));
				$model_data = AppController::defineArrayKey($model_data, $node[self::MODEL]->name, $node[self::USE_KEY]);
				foreach($this->rows_buffer as $row_index => $row_data){
					if(!empty($row_data[$model_index])){
						$chunk[$row_index] = array_merge($model_data[$row_data[$model_index]][0], $chunk[$row_index]);
					}
				}
			}
		}
		
		return $chunk;
	}
}

