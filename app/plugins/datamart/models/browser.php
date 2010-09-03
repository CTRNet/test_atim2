<?php
class Browser extends DatamartAppModel {
	var $useTable = false;

	/**
	 * The action dropdown under browse will be hierarchical or not
	 * @var boolean
	 */
	static $hierarchical_dropdown = false;
	
	/**
	 * Returns an array representing the options to display in the action drop down
	 * @param The initial control_id
	 */
	function getDropdownOptions($getDropdownOptions, $node_id, $plugin_name = null, $model_name = null, $model_pkey = null, $structure_name = null){
		if(!App::import('Model', 'Datamart.DatamartStructure')){
			$this->redirect( '/pages/err_model_import_failed?p[]=Datamart.DatamartStructure', NULL, TRUE );
		}
		$DatamartStructure = new DatamartStructure();
		if($getDropdownOptions != 0){
			if($plugin_name == null || $model_name == null || $model_pkey == null || $structure_name == null){
				$app_controller = AppController::getInstance();
				$app_controller->redirect( '/pages/err_internal?p[]=missing parameter for getDropdownOptions', null, true);
			}
			$browsing_structures = $DatamartStructure->find('list', array('fields' => array('DatamartStructure.display_name')));
			//the query contains a useless CONCAT to counter a cakephp behavior
			$data = $this->query(
				"SELECT CONCAT(main_id, '') AS main_id, GROUP_CONCAT(to_id SEPARATOR ',') AS to_id FROM( "
				."SELECT id1 AS main_id, id2 AS to_id FROM `datamart_browsing_controls` "
				."UNION "
				."SELECT id2 AS main_id, id1 AS to_id FROM `datamart_browsing_controls` ) AS data GROUP BY main_id ");
			$options = array();
			foreach($data as $data_unit){
				$options[$data_unit[0]['main_id']] = explode(",", $data_unit[0]['to_id']);
			}
			$rez = Browser::buildBrowsableOptions($options, array(), $getDropdownOptions, $browsing_structures);
			$result[] = array(
				'value' => '',
				'default' => __('browse', true),
				'children' => $rez['children']
			);
			$result[] = array(
				'value' => '0',
				'default' => __('create batchset', true),
				'action' => 'datamart/browser/createBatchSet/'.$node_id.'/'
			);
			$result[] = array(
				'value' => '0',
				'default' => __('export as CSV file (comma-separated values)', true),
				'action' => 'csv/csv/'.$plugin_name.'/'.$model_name.'/'.$model_pkey.'/'.$structure_name.'/'
			);
		}else{
			$data = $DatamartStructure->find('all');
			foreach($data as $data_unit){
				$result[] = array(
					'value' => $data_unit['DatamartStructure']['id'], 
					'default' => __($data_unit['DatamartStructure']['display_name'], true),
					'action' => 'datamart/browser/browse/'.$node_id.'/',
					'children' => array(
							array(
								'value' => $data_unit['DatamartStructure']['id'],
								'default' => __('filter', true)),
							array(
								'value' => $data_unit['DatamartStructure']['id']."/true/",
								'default' => __('no filter', true))
								));
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
	 * @return An array representing the browsable portion of the action menu
	 */
	static function buildBrowsableOptions(array $from_to, array $stack, $current_id, array $browsing_structures){
		$result = array();
		array_push($stack, $current_id);
		$to_arr = array_diff($from_to[$current_id], $stack);
		$result['default'] = __($browsing_structures[$current_id], true);
		$tmp = array_shift($stack);
		$result['value'] = implode("_", $stack);
		array_unshift($stack, $tmp);
		if(count($stack) > 1){
		$result['children'] = array(
							array(
								'value' => $result['value'],
								'default' => __('filter', true)),
							array(
								'value' => $result['value']."/true/",
								'default' => __('no filter', true)),
								);
		}
		foreach($to_arr as $to){
			if(Browser::$hierarchical_dropdown){
				$result['children'][] = Browser::buildBrowsableOptions($from_to, $stack, $to, $browsing_structures);
			}else{
				$tmp_result = Browser::buildBrowsableOptions($from_to, $stack, $to, $browsing_structures);
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
		array_pop($stack); 
		return $result;
	}
	
	/**
	 * Recursively builds a tree node by node.
	 * @param Int $node_id The node id to fetch
	 * @param Int $active_node The node to hihglight in the graph
	 */
	static function getTree($node_id, $active_node){
		$BrowsingResult = new BrowsingResult();
		$result = $BrowsingResult->find('all', array('conditions' => 'BrowsingResult.id='.$node_id.' OR BrowsingResult.parent_node_id='.$node_id, 'order' => array('BrowsingResult.id')));
		$tree_node = NULL;
		if($tree_node = array_shift($result)){
			$tree_node['active'] = $node_id == $active_node;
			$tree_node['children'] = array();
			$children = array();
			while($node = array_shift($result)){
				$children[] = $node['BrowsingResult']['id'];
			}
			foreach($children as $child){
				$child_node = Browser::getTree($child, $active_node);
				$tree_node['children'][] = $child_node;
				$tree_node['active'] = $child_node['active'] || $tree_node['active'];
			}
		}
		return $tree_node;
	}
	
	/**
	 * Builds a representation of the tree within an array
	 * @param array $tree_node A node and its informations
	 * @param array $tree An array with the current tree representation
	 * @param Int $x The current x location
	 * @param Int $y The current y location
	 */
	static function buildTree(array $tree_node, &$tree = array(), $x = 0, &$y = 0){
		$tree[$y][$x] = $tree_node;
		if(count($tree_node['children'])){
			$looped = false;
			$last_arrow_x = NULL;
			$last_arrow_y = NULL;
			foreach($tree_node['children'] as $pos => $child){
				$active = $child['active'] ? " active " : ""; 
				$tree[$y][$x + 1] = "h-line".$active;
				if($looped){
					$tree[$y][$x] = "arrow".$active;
					if(strlen($active) > 0 && isset($tree[$y - 1][$x])){
						$i = 1;
						while(true){
							if($tree[$y - $i][$x] == "arrow"){
								$tree[$y - $i][$x] = "arrow active_straight";
							}else if($tree[$y - $i][$x] == "v-line"){
								$tree[$y - $i][$x] = "v-line active"; 
							}else{
								break;
							}
							$i ++;
						}
					}
					$last_arrow_x = $x;
					$last_arrow_y = $y;
					$curr_y = $y - 1;
					while(!isset($tree[$curr_y][$x])){
						$tree[$curr_y][$x] = "v-line".$active;
						$curr_y --;
					}
				}
				if(!$child['BrowsingResult']['raw'] || !$tree_node['BrowsingResult']['raw']){
					Browser::buildTree($child, $tree, $x + 2, $y);
				}else{
					$tree[$y][$x + 2] = "h-line".$active;
					$tree[$y][$x + 3] = "h-line".$active;
					Browser::buildTree($child, $tree, $x + 4, $y);
				}
				$y ++;
				$looped = true;
			}
			$y --;
			if($last_arrow_x !== NULL){
				$tree[$last_arrow_y][$last_arrow_x] = $tree[$last_arrow_y][$last_arrow_x] == "arrow" ? "corner" : "corner active";
			}
		}
	}
	
	/**
	 * Builds an html tree based in a table
	 * @param Int $current_node The id of the current node. Its path will be highlighted
	 * @param String $webroot_url The webroot of ATiM
	 */
	static function getPrintableTree($current_node, $webroot_url){
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
		$fm = Browser::getTree($prev_node, $current_node);
		Browser::buildTree($fm, $tree);
		$result .= "<table class='structure'><tr><td align='center'>".__("browsing", true)
			."<table class='databrowser'>\n";
		ksort($tree);
		
		//find longest line
		$max = 0;
		foreach($tree as $y => $line){
			$max = max($max, count($line));
		}
		$half_width = $max / 2;
		foreach($tree as $y => $line){
			$result .= '<tr>';
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
					$count = strlen($cell['BrowsingResult']['id_csv']) ? count(explode(",", $cell['BrowsingResult']['id_csv'])) : 0;
					$info = "<span class='title'>".__($cell['DatamartStructure']['display_name'], true)."</span> (".$count.")<br/>\n";
					if($cell['BrowsingResult']['raw']){
						$search = unserialize($cell['BrowsingResult']['serialized_search_params']);
						if(count($search)){
							$info .= __("search", true)."<br/><br/>".Browser::formatSearchToPrint($search, $cell['DatamartStructure']['structure_id']);
						}else{
							$info .= __("direct access", true);
						}
					}else{
						$info .= __("drilldown", true);
					}
					$result .= "<td class='node ".$class."'><a href='".$webroot_url."/datamart/browser/browse/".$cell['BrowsingResult']['id']."/'><div class='container'><div class='info ".($x < $half_width ? "right" : "left")."'>".$info."</div></div></a></td>";
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
	 * @param The search params array
	 */
	static function formatSearchToPrint(array $search_params, $structure_id){
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
		$sf = $StructureFormat->customSearch("Structure.id='".$structure_id."' AND ".implode(" OR ", $conditions));
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
				foreach($value_element as &$value){
					$values[] = __($value, true);
				}
				list($model, $field) = explode(".", $key);
			}else{
				//it's a range
				//key = field >= 
				//value = value_str
				$values[] = strpos($value_element, "-") ? AppController::getFormatedDatetimeString($value_element) : $value_element;
				list($key, $name_suffix) = explode(" ", $key);
				list($model, $field) = explode(".", $key);
			}
			foreach($sf as $sf_unit){
				if($sf_unit['StructureField']['model'] == $model && $sf_unit['StructureField']['field'] == $field){
					$name = __($sf_unit['StructureFormat']['flag_override_label'] ? $sf_unit['StructureFormat']['language_label'] : $sf_unit['StructureField']['language_label'], true);
					break;
				}
			}
			$result .= "<tr><th>".$name." ".$name_suffix."</th><td>".implode(", ", $values)."</td>\n";
		}
		$result .= "<tr><th>".__("exact search", true)."</th><td>".($search_params['exact_search'] ? __("yes", true) : __('no', true))."</td>\n";
		$result .= "</table>";
		return $result;
	}
}
