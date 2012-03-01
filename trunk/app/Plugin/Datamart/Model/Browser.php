<?php
class Browser extends DatamartAppModel {
	var $useTable = false;
	
	public $checklist_header = array();
	public $checklist_model = null;
	public $checklist_use_key = null;
	public $checklist_sub_models_id_filter = null;
	public $result_structure = null;
	public $count = null;
	public $merged_ids = null;
	public $valid_permission = null;//set when initDataLoad is called.
	
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
	
	public static $cache = array();
	
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
				$app_controller->redirect( '/Pages/err_internal?p[]=missing parameter for getDropdownOptions', null, true);
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
				if(AppController::checkLinkPermission($unit['DatamartStructure']['index_link'])){
					//keep links without permission
					$tmp_arr[$unit['DatamartStructure']['id']] = $unit['DatamartStructure'];
				}
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
					'default' => __('nothing to browse to'),
					'class' => 'disabled',
					'value' => '',
				);
			}
			
			$result[] = array(
				'value' => '',
				'default' => __('browse'),
				'children' => $sorted_rez
			);
			
			$result = array_merge($result, parent::getDropdownOptions($plugin_name, $model_name, $model_pkey, null, $data_model, $data_pkey));
			
		}else{
			
			$active_structures_ids = $this->getActiveStructuresIds();
			$data = $DatamartStructure->find('all', array('conditions' => array('DatamartStructure.id IN (0, '.implode(", ", $active_structures_ids).')')));
			$this->getActiveStructuresIds();
			$to_sort = array();
			foreach($data as $k => $v){
				$to_sort[$k] = __($v['DatamartStructure']['display_name']);
			}
			asort($to_sort, SORT_STRING);
			foreach($to_sort as $k => $foo){
				$data_unit = $data[$k];
				$tmp_result = array(
					'value' => $data_unit['DatamartStructure']['id'], 
					'default' => __($data_unit['DatamartStructure']['display_name']),
					'class' => $data_unit['DatamartStructure']['display_name'],
					'action' => 'Datamart/Browser/browse/'.$node_id.'/',
					);
					$tmp_model = AppModel::getInstance($data_unit['DatamartStructure']['plugin'], $data_unit['DatamartStructure']['model'], true);
					if($ctrl_name = $tmp_model->getControlName()){
						$ids = isset($sub_models_id_filter[$ctrl_name]) ? $sub_models_id_filter[$ctrl_name] : array(); 
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
		if(isset($from_to[$current_id]) && isset($browsing_structures[$current_id])){
			$result = array();
			array_push($stack, $current_id);
			$to_arr = array_diff($from_to[$current_id], $stack);
			$result['default'] = __($browsing_structures[$current_id]['display_name']);
			$result['class'] = $browsing_structures[$current_id]['display_name'];
			$tmp = array_shift($stack);
			$result['value'] = implode(self::$model_separator_str, $stack);
			array_unshift($stack, $tmp);
			if(count($stack) > 1){
				$result['children'] = array(
								array(
									'value' => $result['value'],
									'default' => __('filter')),
								array(
									'value' => $result['value']."/true/",
									'default' => __('no filter'))
								);
				$browsing_model = AppModel::getInstance($browsing_structures[$current_id]['plugin'], $browsing_structures[$current_id]['model'], true);
				if($control_name = $browsing_model->getControlName()){
					$id_filter = isset($sub_models_id_filter[$control_name]) ? $sub_models_id_filter[$control_name] : null;
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
		$main_model = AppModel::getInstance($main_model_info['DatamartStructure']['plugin'], $main_model_info['DatamartStructure']['model'], true);
		$control_model = AppModel::getInstance($main_model_info['DatamartStructure']['plugin'], $main_model->getControlName(), true);
		$conditions = array();
		if($main_model->getControlName() == "SampleControl"){
			//hardcoded SampleControl filtering
			$parentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
			$tmp_ids = $parentToDerivativeSampleControl->getActiveSamples();
			if($ids_filter == null){
				$ids_filter = $tmp_ids;
			}else{
				array_intersect($ids_filter, $tmp_ids);
			}
		}
		
		if($ids_filter != null){
			$ids_filter[] = 0;
			$conditions[] = $control_model->name.'.id IN('.implode(", ", $ids_filter).')';
		}
		if(isset($control_model->_schema['flag_active'])){
			$conditions[$control_model->name.'.flag_active'] = 1;
		}
		$children_data = $control_model->find('all', array('order' => $control_model->name.'.databrowser_label', 'conditions' => $conditions, 'recursive' => 0));
		$children_arr = array();
		foreach($children_data as $child_data){
			$label = self::getTranslatedDatabrowserLabel($child_data[$control_model->name]['databrowser_label']);
			$children_arr[] = array(
				'value' => $prepend_value.self::$sub_model_separator_str.$child_data[$control_model->name]['id'],
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
		$result = $BrowsingResult->find('all', array('conditions' => 'BrowsingResult.id='.$node_id.' OR BrowsingResult.parent_id='.$node_id, 'order' => array('BrowsingResult.id'), 'recursive' => 1));
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
					$tree_node['merge'] = true;//for children
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
						$tree_node['merge'] = true;//for parent
						if(!$child_node['BrowsingResult']['raw'] && $child_node['BrowsingResult']['id'] == $active_node){
							$tree_node['hide_merge_icon'] = true;
						}
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
		if($node_id == $active_node){
			//remove the merge icon on the drilldown of the current node
			foreach($tree_node['children'] as &$child_node){
				if($child_node['DatamartStructure']['id'] == $tree_node['DatamartStructure']['id']){
					$child_node['merge'] = false;
				}
			}
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
			$tmp_node = $br['BrowsingResult']['parent_id'];
		}while($tmp_node);
		$fm = Browser::getTree($prev_node, $current_node, $merged_ids);
		Browser::buildTree($fm, $tree);
		$result .= "<table class='structure'><tr><td style='padding-left: 10px;'>".__("browsing")
			."<table class='databrowser'>\n";
		ksort($tree);
		$lang = AppController::getInstance()->Session->read('Auth.User.lang'); 
		
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
					$cell_model = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['model'], true);
					$class = '';
					if($cell['active']){
						$class .= " active ";
					}
					if(isset($cell['paint_merged'])){
						$class .= " merged";
					}
					$count = strlen($cell['BrowsingResult']['id_csv']) ? count(explode(",", $cell['BrowsingResult']['id_csv'])) : 0;
					$title = __($cell['DatamartStructure']['display_name']);
					$info = __($cell['BrowsingResult']['browsing_type']).' - '.AppController::getFormatedDatetimeString($cell['BrowsingResult']['created'], true, true);
					$cache_key = 'browsingNodeContent'.$lang.$cell['BrowsingResult']['id'];
					if(!$content = Cache::read($cache_key)){
						if($cell['BrowsingResult']['raw']){
							$search = $cell['BrowsingResult']['serialized_search_params'] ? unserialize($cell['BrowsingResult']['serialized_search_params']) : array();
							$adv_search = isset($search['adv_search_conditions']) ? $search['adv_search_conditions'] : array(); 
							if(count($search['search_conditions']) || $adv_search){
								$structure = null;
								if($cell_model->getControlName() && $cell['BrowsingResult']['browsing_structures_sub_id'] > 0){
									//alternate structure required
									$tmp_model = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['model'], true);
									$alternate_alias = self::getAlternateStructureInfo($cell['DatamartStructure']['plugin'], $tmp_model->getControlName(), $cell['BrowsingResult']['browsing_structures_sub_id']);
									$alternate_alias = $alternate_alias['form_alias'];
									$structure = StructuresComponent::$singleton->get('form', $alternate_alias);
								 	//unset the serialization on the sub model since it's already in the title
								 	unset($search['search_conditions'][$cell['DatamartStructure']['control_master_model'].".".$tmp_model->getControlForeign()]);
								 	$tmp_model = AppModel::getInstance($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['control_master_model'], true);
								 	$tmp_data = $tmp_model->find('first', array('conditions' => array($tmp_model->getControlName().".id" => $cell['BrowsingResult']['browsing_structures_sub_id']), 'recursive' => 0));
								 	$title .= " > ".self::getTranslatedDatabrowserLabel($tmp_data[$tmp_model->getControlName()]['databrowser_label']);
								}else{
									$structure = StructuresComponent::$singleton->getFormById($cell['DatamartStructure']['structure_id']);
								}
								if(count($search['search_conditions']) || $adv_search){//count might be zero if the only condition was the sub type
									$adv_structure = array();
									if($cell['DatamartStructure']['adv_search_structure_alias']){
										$adv_structure = StructuresComponent::$singleton->get('form', $cell['DatamartStructure']['adv_search_structure_alias']);
									}
									$info .= "<br/><br/>".Browser::formatSearchToPrint(array(
										'search'		=> $search, 
										'adv_search'	=> $adv_search, 
										'structure'		=> $structure, 
										'adv_structure'	=> $adv_structure,
										'model'			=> $cell_model
									));
								}
							}
						}
						$content = "<div class='content'><span class='title'>".$title."</span> (".$count.")<br/>\n".$info."</div>";
						Cache::Write($cache_key, $content);
					}
					$controls = "<div class='controls'>%s</div>";
					$link = $webroot_url."Datamart/Browser/browse/";
					if(isset($cell['merge']) && $cell['merge'] && !isset($cell['hide_merge_icon'])){
						$controls = sprintf($controls, "<a class='icon16 link' href='".$link.$current_node."/0/".$cell['BrowsingResult']['id']."' title='".__("link to current view")."'/>&nbsp;</a>");
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
					$result .= "<td class='node ".$class."'><div class='container'><a class='box20x20' href='".$link.$cell['BrowsingResult']['id']."/'><span class='icon16 ".$cell['DatamartStructure']['display_name']."'></span></a>".$box."</div></td>";
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
	 * @param array $params Both search parameters with both structures
	 * @return An html string of a table containing the search formated params
	 */
	static function formatSearchToPrint(array $params){
		$search_conditions = $params['search']['search_conditions'];
		
		//preprocess to clean datetime accuracy
		foreach($search_conditions as $key => $value){
			if(is_array($value) && isset($value['OR'][0])){
				$tmp = current($value['OR'][0]);
				$search_conditions[key($value['OR'][0])] = $tmp;
				unset($search_conditions[$key]);
			}
		}

		$keys = array_keys($search_conditions);
		App::Uses('StructureFormat', 'Model');
		$StructureFormat = new StructureFormat();
		$conditions = array();
		$conditions[] = "false";
		foreach($keys as $key){
			if(is_numeric($key)){
				//it's a textual field (model.field LIKE %foo1% OR model.field LIKE %foo2% ...) or an "OR"
				list($model_field) = explode(" ", $search_conditions[$key]);
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
		foreach($search_conditions as $key => $value_element){
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
			$last_label = '';
			foreach($params['structure']['Sfs'] as &$sf_unit){
				if($sf_unit['language_label']){
					$last_label = $sf_unit['language_label'];
				}
				if($sf_unit['model'] == $model && $sf_unit['field'] == $field){
					$name = __($sf_unit['language_label']) ?: __($last_label).' '.__($sf_unit['language_tag']); 
					if(!empty($sf_unit['StructureValueDomain'])){
						if(!isset($sf_unit['StructureValueDomain']['StructurePermissibleValue'])){
							if(isset($sf_unit['StructureValueDomain']['source']) && strlen($sf_unit['StructureValueDomain']['source']) > 0){
								$sf_unit['StructureValueDomain']['StructurePermissibleValue'] = StructuresComponent::getPulldownFromSource($sf_unit['StructureValueDomain']['source']);
							}else{
								if($structure_value_domain_model == null){
									App::uses("StructureValueDomain", 'Model');
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
										$value = __($p_value);
									}
									break; 
								}
							}
						}
						break;
					}
				}
			}
			$result .= "<tr><th>".$name." ".$name_suffix."</th><td>";
			if(count($values) > 6){
				$result .= '<span class="databrowserShort">'.stripslashes(implode(", ", array_slice($values, 0, 6))).'</span>'
					.'<span class="databrowserAll hidden">'.stripslashes(implode(", ", array_slice($values, 6))).'</span>'
					.'<br/><a href="#" class="databrowserMore">'.__('and %d more', count($values) - 6).'</a>';
			}else{
				$result .= stripslashes(implode(", ", $values));
			}
			$result .= "</td>\n";
		}
		
		$result .= "<tr><th>".__("exact search")."</th><td>".($params['search']['exact_search'] ? __("yes") : __('no'))."</td>\n";

		//advanced search fields
		$sfs_model = AppModel::getInstance('', 'Sfs', true);
		foreach($params['adv_search'] as $key => $value){
			if($key === 'browsing_filter'){
				continue;
			}
			foreach($params['adv_structure']['Sfs'] as $sfs){
				if($sfs['field'] == $key){
					$option = $params['model']->getBrowsingAdvSearchArray($key);
					$option = $option[$value];
					$dm_structure_model = AppModel::getInstance('Datamart', 'DatamartStructure', true);
					$dm_structure = $dm_structure_model->find('first', array('conditions' => array('DatamartStructure.model' => $option['model']))); 
					$sfs2 = $sfs_model->find('first', array('conditions' => array('model' => $option['model'], 'field' => $option['field']), 'recursive' => -1));
					$result .= sprintf("<tr><th>%s %s</th><td>%s %s</td>\n", __($sfs['language_label']), $option['relation'], __($dm_structure['DatamartStructure']['display_name']), __($sfs2['Sfs']['language_label']));
				}
			}
		}
		
		//filter
		if(isset($params['adv_search']['browsing_filter'])){
			$filter = $params['model']->getBrowsingAdvSearchArray('browsing_filter');
			$result .= "<tr><th>".__("filter")."</th><td>".__($filter[$params['adv_search']['browsing_filter']]['lang'])."</td>\n";
		}
		
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
			$sm = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
			$sm_data = $sm->find('all', array(
				'fields'		=> array('SampleMaster.sample_control_id'),
				'conditions'	=> array("SampleMaster.id" => explode(",", $browsing['BrowsingResult']['id_csv'])),
				'group'			=> array('SampleMaster.sample_control_id'),
				'recursive'		=> -1)
			);
			if(count($sm_data) == 1){
				$ac = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
				$data = $ac->find('all', array('conditions' => array("AliquotControl.sample_control_id" => $sm_data[0]['SampleMaster']['sample_control_id'], "AliquotControl.flag_active" => 1), 'fields' => 'AliquotControl.id', 'recursive' => -1));
				if(empty($data)){
					$sub_models_id_filter['AliquotControl'][] = 0;
				}else{
					$ids = array();
					foreach($data as $unit){
						$ids[] = $unit['AliquotControl']['id'];
					}
					$sub_models_id_filter['AliquotControl'] = $ids;
				}
			}else{
				$sub_models_id_filter['AliquotControl'][] = 0;
			}
		}else if($browsing['DatamartStructure']['id'] == 1){
			//aliquot->sample hardcoded part
			assert($browsing['DatamartStructure']['control_master_model'] == "AliquotMaster");//will print a warning if the id and field doesnt match anymore
			$am = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
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
			$ac = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
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
			$part = __($part);
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
			if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
				$this->valid_permission = false;
			}
			$start_id = $browsing['BrowsingResult']['parent_id'];
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
				if(!$this->browsing_cache[$node_to_fetch]['BrowsingResult']['raw']){
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
	private function buildBufferedSearchParameters($primary_node_ids){
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
		//TODO: Remove me if the performance looks good (now that CCL has been removed)
		//when going through participants to reach view_collections, sql is slow. Override to go through ccl
		//the other direction (collections to participant) is not affected
// 		foreach($this->nodes as $index => $node){
// 			if($index > 0 && $node[self::MODEL]->name == 'ViewCollection' && $this->nodes[$index - 1][self::MODEL]->name == 'Participant'){
// 				//participant -> collection nodes. Alter it to become participant -> ccl -> collection. Update collection.
// 				//split the array
// 				$second_part = array_slice($joins, $index - 1);
// 				$collection_join = array_shift($second_part);
// 				$joins = array_slice($joins, 0, $index - 1);
				
// 				//insert ccls
// 				$joins[] = array(
// 					'table' => 'clinical_collection_links',
// 					'alias'	=> 'ClinicalCollectionLink',
// 					'type'	=> 'LEFT',
// 					'conditions' => array(
// 						($index == 1 ? 'Participant' : 'ParticipantBrowser').'.id = ClinicalCollectionLink.participant_id',
// 						'ClinicalCollectionLink.collection_id' => $collection_join['conditions']['ViewCollectionBrowser.collection_id'])
// 				);
				
// 				//update collection and put it back in the join array
// 				$collection_join['table'] = 'collections';
// 				$collection_join['alias'] = 'Collection';
// 				$new_conditions = array();
// 				$new_conditions[0] = 'Collection.id = ClinicalCollectionLink.collection_id';
// 				$new_conditions['Collection.id'] = $collection_join['conditions']['ViewCollectionBrowser.collection_id'];
// 				$collection_join['conditions'] = $new_conditions;
// 				$joins[] = $collection_join;
// 				$fields[$index - 1] = 'CONCAT("", Collection.id) AS Collection';
// 				$order[$index - 1] = 'Collection';
				
// 				if(!empty($second_part)){
// 					//update the next node to use the right collection key
// 					$next_node = array_shift($second_part);
// 					$new_conditions = array();
// 					foreach($next_node['conditions'] as $key => $condition){
// 						$key = str_replace('ViewCollectionBrowser.collection_id', 'Collection.id', $key);
// 						$condition = str_replace('ViewCollectionBrowser.collection_id', 'Collection.id', $condition);
// 						$new_conditions[$key] = $condition;
// 					}
// 					$next_node['conditions'] = $new_conditions;
// 					array_push($joins, $next_node);
// 					if(!empty($second_part)){
// 						$joins = array_merge($joins, $second_part);
// 					}
// 				}
// 				break;
// 			}
// 		}
		//END OF COLLECTION HARDCODED PART
		
		$node = $this->nodes[0];
		array_unshift($fields, 'CONCAT("", '.$node[self::MODEL]->name.".".$node[self::USE_KEY].') AS '.$node[self::MODEL]->name);
		array_unshift($order, $node[self::MODEL]->name);
		$this->search_parameters = array(
			'fields'		=> $fields,
			'joins'			=> $joins, 
			'conditions'	=> array($node[self::MODEL]->name.".".$node[self::USE_KEY] => $primary_node_ids),
			'order'			=> $order,
			'recursive'		=> -1
		);
	}
	
	/**
	 * Init the browser model on the current required data display
	 * @param array $browsing Browsing data of the first node
	 * @param int $merge_to Node id of the target node to merge with
	 * @param array $primary_node_ids The ids of the primary node to use
	 */
	public function initDataLoad(array $browsing, $merge_to, array $primary_node_ids){
		$result = array();
		$start_id = NULL;
		$end_id = null;
		$node_id = $browsing['BrowsingResult']['id'];
		$main_data = array();//$this->checklist_data;
		$descending = null;
		$result_structure = array('Structure' => array(), 'Sfs' => array(), 'Accuracy' => array());
		$header = array();
		self::$browsing_control_model = AppModel::getInstance("Datamart", "BrowsingControl", true);
		self::$browsing_result_model = AppModel::getInstance("Datamart", "BrowsingResult", true);
		$nodes_to_fetch = array();
		
		
		if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
			$this->valid_permission = false;
		}else{
			$this->valid_permission = true;
			if($merge_to != 0){
				$nodes_to_fetch = $this->getNodesToMerge($browsing, $merge_to);
			}
		}
		
		//prepare nodes_to_fetch_stack
		array_unshift($nodes_to_fetch, $node_id);
		$last_browsing = null;
		$iteration_count = 1;
		$structures_component = AppController::getInstance()->Structures;
		
		//building the relationship logic between nodes
		foreach($nodes_to_fetch as $node){
			$current_browsing = self::$browsing_result_model->findById($node);
			$current_model = AppModel::getInstance($current_browsing['DatamartStructure']['plugin'], $current_browsing['DatamartStructure']['model'], true);
			$ids = explode(",", $current_browsing['BrowsingResult']['id_csv']);
			$ids[] = 0;
			
			$control_id = empty($current_browsing['DatamartStructure']['control_master_model']) ? false : $current_model->find('all', array(
				'fields' => array($current_model->getControlForeign()),
				'conditions' => array($current_browsing['DatamartStructure']['model'].".".$current_model->primaryKey => $ids),
				'group' => array($current_model->getControlForeign()), 
				'limit' => 2));
			
			$structure = null;
			$header_sub_type = " ";
			$structure = $structures_component->getFormById($current_browsing['DatamartStructure']['structure_id']);
			if($control_id && count($control_id) == 1){
				//we can use the specific structure
				
				//load the structure
				$control_id = $control_id[0][$current_browsing['DatamartStructure']['model']][$current_model->getControlForeign()]; 
				$control_model = AppModel::getInstance($current_browsing['DatamartStructure']['plugin'], $current_model->getControlName(), true);
				$control_model_data = $control_model->find('first', array(
					'fields' => array($control_model->name.'.form_alias', $control_model->name.'.databrowser_label'), 
					'conditions' => array($control_model->name.".id" => $control_id))
				);
				
				$header_sub_type = "/".Browser::getTranslatedDatabrowserLabel($control_model_data[$control_model->name]['databrowser_label'])." ";
				
				//init base model
				AppModel::getInstance($current_browsing['DatamartStructure']['plugin'], $current_browsing['DatamartStructure']['control_master_model'], true);
				$structure_alias = $structure['Structure']['alias'];
				AppController::buildDetailBinding(
					$current_model, 
					array($current_model->name.'.'.$current_model->getControlForeign() => $control_id), 
					&$structure_alias
				);
				
				$structure = $structures_component->get('form', $structure_alias);

			}else if(!empty($current_browsing['DatamartStructure']['control_master_model'])){
				//must use the generic structure (or its empty...)
				AppController::addInfoMsg(__("the results contain various data types, so the details are not displayed"));
			}
			
			if($this->checklist_model == null){
				$this->checklist_sub_models_id_filter = Browser::getDropdownSubFiltering($current_browsing);
				$this->checklist_use_key = $current_model->primaryKey;
				$this->checklist_model = $current_model;
			}

			//structure merge, add 100 * iteration count to display column
			foreach($structure['Sfs'] as $sfs){
				$sfs['display_column'] += 100 * $iteration_count;
				$result_structure['Sfs'][] = $sfs;
			}
			//copy accuracy settings
			foreach($structure['Accuracy'] as $model => $fields){
				if(isset($result_structure['Accuracy'][$model])){
					$result_structure['Accuracy'][$model] = array_merge($fields, $result_structure['Accuracy'][$model]);
				}else{
					$result_structure['Accuracy'][$model] = $fields;
				}
			}
			
			//arrange Structure to be able to print structure alias when in debug mode
			if(!array_key_exists(0, $structure['Structure'])){
				$structure['Structure'] = array($structure['Structure']);
			}
			$result_structure['Structure'] = array_merge($result_structure['Structure'], $structure['Structure']);
			
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
				$join_field = $browsing_control['BrowsingControl']['use_field'];
			}
			
			//update header
			$count = $current_model->find('count', array('conditions' => array($current_model->name.".".$current_model->primaryKey => $ids)));
			$header[] = __($current_browsing['DatamartStructure']['display_name']).$header_sub_type."(".$count.")";
			$this->nodes[] = array(
				self::NODE_ID => $node, 
				self::IDS => $ids, 
				self::MODEL => $current_model, 
				self::USE_KEY => $current_model->primaryKey,
				self::ANCESTOR_IS_CHILD => $ancestor_is_child,
				self::JOIN_FIELD => $join_field
			);
			$last_browsing = $current_browsing;
			++ $iteration_count;
		}
		
		
		//prepare buffer conditions
		$this->buildBufferedSearchParameters($primary_node_ids);
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
	
	/**
	 * When defining advanced search parameters (parameters based on previous nodes),
	 * updates the joins and conditions arrays.
	 * @param array $params
	 * @return null on success, a model display_name string if a parent node has not a 1:1 relation with it's descendant
	 */
	function buildAdvancedSearchParameters(array $params){
		$browsing_result_model = AppModel::getInstance('Datamart', 'BrowsingResult', true);
		$browsing_control_model = AppModel::getInstance('Datamart', 'BrowsingControl', true);
		$joined_models = array();
		$params['conditions_adv'] = array();
		foreach($params['joins'] as $join){
			$joined_models[$join['alias']] = null;
		}
		foreach($params['adv_struct']['Sfs'] as $field){
			if($field['field'] != 'browsing_filter' 
				&& isset($params['data'][$field['model']][$field['field']]) 
				&& $params['data'][$field['model']][$field['field']]
			){
				$curr_model = $params['browsing_model'];
				$adv_field = $curr_model->getBrowsingAdvSearchArray($field['field']);
				$option_key = $params['data'][$curr_model->name][$field['field']];
				if($adv_field && isset($adv_field[$params['data'][$curr_model->name][$field['field']]])){
					//the needed model is not already joined, join it
					$path = $browsing_result_model->getPath($params['node_id'], null, 0);
					$curr_id = $params['browsing']['DatamartStructure']['id'];
					$adv_field = $adv_field[$option_key];
					while($parent_browsing = array_pop($path)){
						if(!array_key_exists($parent_browsing['DatamartStructure']['model'], $joined_models)){
							$control = $browsing_control_model->find('first', array('conditions' => array('BrowsingControl.id1' => $curr_id, 'BrowsingControl.id2' => $parent_browsing['DatamartStructure']['id'])));
							$parent_browsing_model = AppModel::getInstance($parent_browsing['DatamartStructure']['plugin'], $parent_browsing['DatamartStructure']['control_master_model'] ?: $parent_browsing['DatamartStructure']['model'], true);
							
							if($parent_browsing_model->name == $adv_field['model'] && !$parent_browsing_model->schema($adv_field['field'])){
								//error, the field doesn't exist
								AppController::getInstance()->redirect( '/Pages/err_internal?p[]=model+field+not+found', NULL, TRUE );
							}
							
							
							$conditions = array();
							if($control){
								$conditions = array($curr_model->name.'.'.$control['BrowsingControl']['use_field'].' = '.$parent_browsing_model->name.'.'.$parent_browsing_model->primaryKey);
							}else{
								$control = $browsing_control_model->find('first', array('conditions' => array('BrowsingControl.id2' => $curr_id, 'BrowsingControl.id1' => $parent_browsing['DatamartStructure']['id'])));
								assert(!empty($control));
								
								//make sure parent relation to current node is 1:1
								$id_count = substr_count($parent_browsing['BrowsingResult']['id_csv'], ',') + 1;
								$parent_ref_key = $parent_browsing_model->name.'.'.$control['BrowsingControl']['use_field'];
								$distinct_count = $parent_browsing_model->find('first', array('conditions' => array($parent_ref_key => explode(',', $parent_browsing['BrowsingResult']['id_csv'])), 'fields' => array('COUNT(DISTINCT '.$parent_ref_key.') AS count')));
								if($distinct_count[0]['count'] != $id_count){
									return $parent_browsing['DatamartStructure']['display_name'];
								}
								
								$conditions = array($parent_ref_key.' = '.$curr_model->name.'.'.$curr_model->primaryKey);
								
							}
							
							$params['joins'][] = array(
									'table'		=> $parent_browsing_model->table,
									'alias'		=> $parent_browsing_model->name,
									'type'		=> 'INNER',
									'conditions'=> $conditions
							);
							$joined_models[$parent_browsing_model->name] = null;
							$curr_id = $parent_browsing['DatamartStructure']['id'];
							$curr_model = $parent_browsing_model;
						}
					}
				}
				$cond = sprintf('%s.%s %s %s.%s', $params['browsing_model']->name, $field['field'], $adv_field['relation'], $adv_field['model'], $adv_field['field']);
				$params['conditions'][] = $cond;
				$params['conditions_adv'][$field['field']] = $option_key;
			}
		}
		return null;
	}
	
	function createNode($params){
		$dm_structure_model = AppModel::getInstance('Datamart', 'DatamartStructure', true);
		$browsing_result_model = AppModel::getInstance('Datamart', 'BrowsingResult', true);
		$browsing_ctrl_model = AppModel::getInstance('Datamart', 'BrowsingControl', true);
		$browsing = $dm_structure_model->find('first', array('conditions' => array('id' => $params['struct_ctrl_id'])));
		$controller = AppController::getInstance();
		$node_id = $params['node_id'];
		$save = array(); 
		if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
			echo $browsing['DatamartStructure']['index_link'];
			$controller->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
			return false;
		}
		
		$model_to_search = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
		$use_sub_model = null;
		
		if($params['sub_struct_ctrl_id'] && $ctrl_model = $model_to_search->getControlName()){
			//sub structure
			$model_to_search = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['control_master_model'], true);
			$alternate_info = Browser::getAlternateStructureInfo($browsing['DatamartStructure']['plugin'], $ctrl_model, $params['sub_struct_ctrl_id']);
			$alternate_alias = $alternate_info['form_alias'];
			$result_structure = $controller->Structures->get('form', $alternate_alias);
			$model_to_import = $browsing['DatamartStructure']['control_master_model'];
			$use_sub_model = true;
				
			//add detail tablename to result_structure (use to parse search parameters) where needed
			$detail_model_name = str_replace('Master', 'Detail', $model_to_import);
			if($detail_model_name == $model_to_import){
				AppController::addWarningMsg('The replacement to get the detail model name failed');
			}else{
				foreach($result_structure['Sfs'] as &$field){
					if($field['model'] == $detail_model_name && $field['tablename'] != $alternate_info['detail_tablename']){
						if(Config::read('debug') > 0 && !empty($field['tablename']) && $field['tablename'] != $alternate_info['detail_tablename']){
							AppController::addWarningMsg('A loaded detail field has a different tablename ['.$field['tablename'].'] than what the control table states ['.$alternate_info['detail_tablename'].']');
						}
						$field['tablename'] = $alternate_info['detail_tablename'];
					}
				}
			}
		}else{
			$result_structure = $controller->Structures->getFormById($browsing['DatamartStructure']['structure_id']);
			$use_sub_model = false;
		}
		
		$advanced_data = null;
		$select_key = $model_to_search->name.".".$model_to_search->primaryKey;
		$search_conditions = null;
		if(isset($params['search_conditions'])){
			$org_search_conditions = array(
				'search_conditions' => $params['search_conditions'],
				'exact_search' => $params['exact_search'],
				'adv_search_conditions' => array()
			);
			$advanced_data = array($model_to_search->name => $params['adv_search_conditions']);
			$search_conditions = $params['search_conditions'];
		}else{
			$search_conditions = $controller->Structures->parseSearchConditions($result_structure);
			
			if($use_sub_model){
				//adding filtering search condition
				$search_conditions[$browsing['DatamartStructure']['control_master_model'].".".$model_to_search->getControlForeign()] = $params['sub_struct_ctrl_id'];
			}
		
			$org_search_conditions = array(
				'search_conditions' => $search_conditions,
				'exact_search' => isset($controller->request->data['exact_search']),
				'adv_search_conditions' => array()
			);
			$advanced_data = $controller->request->data;
		}

		$joins = array();
		
		if($params['node_id'] != 0){
			//this is not the first node, search based on parents
			$parent = $browsing_result_model->find('first', array('conditions' => array("BrowsingResult.id" => $params['node_id'])));
			$control_data = $browsing_ctrl_model->find('first', array('conditions' => array('BrowsingControl.id1' => $parent['DatamartStructure']['id'], 'BrowsingControl.id2' => $browsing['DatamartStructure']['id'])));
			$parent_model = AppModel::getInstance($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['control_master_model'] ?: $parent['DatamartStructure']['model'], true);
			if(!empty($control_data)){
				$joins[] = array(
						'table'		=> $parent_model->table,
						'alias'		=> $parent_model->name,
						'type'		=> 'INNER',
						'conditions'=> array($parent_model->name.'.'.$control_data['BrowsingControl']['use_field'].' = '.$select_key, $parent_model->name.'.'.$parent_model->primaryKey => explode(',', $parent['BrowsingResult']['id_csv']))
				);
			}else{
				//ids are already contained in the child
				$control_data = $browsing_ctrl_model->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing['DatamartStructure']['id'], 'BrowsingControl.id2' => $parent['DatamartStructure']['id'])));
				assert($control_data);
				$search_conditions[$model_to_search->name.'.'.$control_data['BrowsingControl']['use_field']] = explode(',', $parent['BrowsingResult']['id_csv']);
			}
		}
		$browsing_filter = array();
		
		if($browsing['DatamartStructure']['adv_search_structure_alias']){
			$advanced_structure = $controller->Structures->get('form', $browsing['DatamartStructure']['adv_search_structure_alias']);
			$adv_params = array(
					'adv_struct'	=> $advanced_structure,
					'data'			=> $advanced_data,
					'joins'			=> &$joins,
					'conditions'	=> &$search_conditions,
					'node_id'		=> $node_id,
					'browsing'		=> $browsing,
					'browsing_model'=> $model_to_search
			);
			$error_model_display_name = $this->buildAdvancedSearchParameters(&$adv_params);
			if($error_model_display_name != null){
				//example: If 3 tx are owned by the same participant, this error will be displayed.
				//we do it to make sure the result set is made with 1:1 relationship, thus clear.
				$controller->flash(__("a special parameter could not be applied because relations between %s and its children node are shared", __($error_model_display_name)), 'javascript:history.back()');
				return false;
			}
			$org_search_conditions['adv_search_conditions'] = $adv_params['conditions_adv'];
			if(isset($advanced_data[$model_to_search->name]['browsing_filter']) && !empty($advanced_data[$model_to_search->name]['browsing_filter'])){
				$browsing_filter = $model_to_search->getBrowsingAdvSearchArray('browsing_filter');
				$browsing_filter = $browsing_filter[$advanced_data[$model_to_search->name]['browsing_filter']];
			}
		}
		
		$save_ids = $model_to_search->find('all', array(
				'conditions'	=> $search_conditions,
				'fields'		=> array("CONCAT('', ".$select_key.") AS ids"),
				'recursive'		=> 0,
				'joins'			=> $joins,
				'order'			=> array($model_to_search->name.'.'.$model_to_search->primaryKey)
		));
		
		if($browsing_filter && $save_ids){
			$temporary_table = 'browsing_tmp_table';
			$select_field = null;
			if($model_to_search->schema($browsing_filter['field'].'_accuracy')){
				//construct a field function based on accuracy
				//we have to use \n and \t for accuracy when searching for max
				//because they're the rare entries that go before a space
				$select_field = sprintf(
						AppModel::ACCURACY_REPLACE_STR,
						$browsing_filter['field'],
						$browsing_filter['field'].'_accuracy',
						$browsing_filter['attribute'] == 'MAX' ? '"\n"' : '"A"',//non year
						$browsing_filter['attribute'] == 'MAX' ? '"\t"' : '"B"',//year
						$browsing_filter['attribute']
				);
			}else{
				$select_field = $browsing_filter['attribute'].'('.$browsing_filter['field'].')';
			}
			$save_ids = array_unique(array_map(create_function('$val', 'return $val[0]["ids"];'), $save_ids));
			$model_to_search->query('DROP TEMPORARY TABLE IF EXISTS '.$temporary_table);
			$query = sprintf('CREATE TEMPORARY TABLE %1$s (SELECT %2$s, %3$s AS order_field, " " AS accuracy FROM %4$s WHERE %5$s GROUP BY %2$s)',
					$temporary_table,
					$browsing_filter['group by'],
					$select_field,
					$model_to_search->table,
					$model_to_search->primaryKey.' IN('.implode(', ', $save_ids).')'
			);
			$model_to_search->query($query);
				
			if($model_to_search->schema($browsing_filter['field'].'_accuracy')){
				//update the table to restore values regarding accuracy
				$org_field_info = $model_to_search->schema($browsing_filter['field']);
				$query = 'UPDATE '.$temporary_table.' SET order_field=CONCAT(SUBSTR(order_field, 1, %1$d), "%2$s"), accuracy="%3$s" WHERE LENGTH(order_field)=%4$d';
				if($org_field_info['atim_type'] == 'date'){
					$model_to_search->query(sprintf($query, 4, '-01-01', 'y', 5).' AND INSTR(order_field, "'.($browsing_filter['attribute'] == 'MAX' ? '\t' : '9').'")!=0');
					$model_to_search->query(sprintf($query, 4, '-01-01', 'm', 5));
					$model_to_search->query(sprintf($query, 7, '-01', 'd', 8));
				}else{
					//datetime
					$model_to_search->query(sprintf($query, 4, '-01-01 00:00:00', 'y', 5).' AND INSTR(order_field, "'.($browsing_filter['attribute'] == 'MAX' ? '\t' : '9').'")!=0');
					$model_to_search->query(sprintf($query, 4, '-01-01 00:00:00', 'm', 5));
					$model_to_search->query(sprintf($query, 7, '-01 00:00:00', 'd', 8));
					$model_to_search->query(sprintf($query, 10, ' 00:00:00', 'h', 11));
					$model_to_search->query(sprintf($query, 13, '00:00', 'i', 14));
				}
				$model_to_search->query('UPDATE '.$temporary_table.' SET accuracy="c" WHERE accuracy=" "');
			}
				
			$joins = array(array(
				'table'	=> $temporary_table,
				'alias'	=> 'TmpTable',
				'type'	=> 'INNER',
				'conditions' => array(
					sprintf('TmpTable.order_field = %1$s.%2$s', $model_to_search->name, $browsing_filter['field']),
					sprintf('TmpTable.%2$s = %1$s.%2$s', $model_to_search->name, $browsing_filter['group by'])
				)
			));
			if($model_to_search->schema($browsing_filter['field'].'_accuracy')){
				$joins[0]['conditions'][] = sprintf('TmpTable.accuracy = %1$s.%2$s', $model_to_search->name, $browsing_filter['field'].'_accuracy');
			}
				
			$save_ids = $model_to_search->find('all', array(
					'conditions'	=> array($model_to_search->name.'.'.$model_to_search->primaryKey => $save_ids),
					'fields'		=> array("CONCAT('', ".$select_key.") AS ids"),
					'recursive'		=> 0,
					'joins'			=> $joins,
					'order'			=> array($model_to_search->name.'.'.$model_to_search->primaryKey)
			));
			$model_to_search->query('DROP TEMPORARY TABLE '.$temporary_table);
				
			$org_search_conditions['adv_search_conditions']['browsing_filter'] = $advanced_data[$model_to_search->name]['browsing_filter'];
		}
		
		$save_ids = implode(",", array_unique(array_map(create_function('$val', 'return $val[0]["ids"];'), $save_ids)));
		$browsing_type = null;
		if((!$org_search_conditions['search_conditions'] || (count($org_search_conditions['search_conditions']) == 1 && $params['sub_struct_ctrl_id']) && !$org_search_conditions['adv_search_conditions'])){
			$browsing_type = 'direct access';
		}else{
			$browsing_type = 'search';
		}
		$save = array('BrowsingResult' => array(
			'user_id'						=> $controller->Session->read('Auth.User.id'),
			'parent_id'						=> $node_id,
			'browsing_structures_id'		=> $params['struct_ctrl_id'],
			'browsing_structures_sub_id'	=> $use_sub_model ? $params['sub_struct_ctrl_id'] : 0,
			'id_csv'						=> $save_ids,
			'raw'							=> 1,
			'browsing_type'					=> $browsing_type,
			'serialized_search_params'		=> serialize($org_search_conditions)
		));

		if(strlen($save_ids) == 0){
			//we have an empty set, bail out! (don't save empty result)
			if($params['last']){
				//go back 1 page
				$controller->flash(__("no data matches your search parameters"), "javascript:history.back();", 5);
			}else{
				//go to the last node
				$controller->flash(__("you cannot browse to the requested entities because there is no [%s] matching your request", $browsing['DatamartStructure']['display_name']), "/Datamart/Browser/browse/".$node_id."/", 5);
			}
			return false;
		}
		
		$tmp = $browsing_result_model->find('first', array('conditions' => $controller->flattenArray($save)));
		if(empty($tmp)){
			//save fullset
			$save = $browsing_result_model->save($save);
			$save['BrowsingResult']['id'] = $browsing_result_model->id;
			if($node_id == 0){
				//save into index as well
				$browsing_index_model = AppModel::getInstance('Datamart', 'BrowsingIndex', true);
				$browsing_index_model->save(array("BrowsingIndex" => array("root_node_id" => $save['BrowsingResult']['id'])));
				$browsing_index_model->id = null;
			}
			$node_id = $browsing_result_model->id;
			$browsing_result_model->id = null;
		}else{
			$save = $tmp;
		}
		
		$browsing['BrowsingResult'] = $save['BrowsingResult'];

		return array(
			'result_struct'	=> $result_structure,
			'browsing'		=> $browsing
		);
	}
}

