<?php
class Browser extends DatamartAppModel {
	var $useTable = false;
	
	function getDropdownOptions($getDropdownOptions){
		if($getDropdownOptions != 0){
			if(!App::import('Model', 'Datamart.BrowsingStructure')){
				$this->redirect( '/pages/err_model_import_failed?p[]=Datamart.BrowsingStructure', NULL, TRUE );
			}
			$BrowsingStructure = new BrowsingStructure();
			$browsing_structures = $BrowsingStructure->find('list', array('fields' => array('BrowsingStructure.display_name')));
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
				'value' => '',
				'default' => __('create batchset', true)
			);
			$result[] = array(
				'value' => '',
				'default' => __('export to csv', true)
			);
		}else{
			$data = $this->query("SELECT * FROM datamart_browsing_structures");
			foreach($data as $data_unit){
				$result[] = array(
					'value' => $data_unit['datamart_browsing_structures']['id'], 
					'default' => __($data_unit['datamart_browsing_structures']['display_name'], true),
					'children' => array(
							array(
								'value' => $data_unit['datamart_browsing_structures']['id'],
								'default' => __('search', true)),
							array(
								'value' => $data_unit['datamart_browsing_structures']['id']."/true/",
								'default' => __('direct', true)),
								));
			}
		}
		return $result;
	}
	
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
								'default' => __('search', true)),
							array(
								'value' => $result['value']."/true/",
								'default' => __('direct', true)),
								);
		}
		foreach($to_arr as $to){
			$result['children'][] = Browser::buildBrowsableOptions($from_to, $stack, $to, $browsing_structures);
		}
		array_pop($stack); 
		return $result;
	}
	
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
					$class = $cell['BrowsingStructure']['display_name'];
					if($cell['active']){
						$class .= " active ";
					}
					$count = strlen($cell['BrowsingResult']['id_csv']) ? count(explode(",", $cell['BrowsingResult']['id_csv'])) : 0;
					$info = "<span class='title'>".__($cell['BrowsingStructure']['display_name'], true)."</span> (".$count.")<br/>\n";
					if($cell['BrowsingResult']['raw']){
						$search = unserialize($cell['BrowsingResult']['serialized_search_params']);
						if(count($search)){
							$info .= __("search", true)."<br/><br/>".Browser::formatSearchToPrint($search, $cell['BrowsingStructure']['structure_alias']);
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
	static function formatSearchToPrint(array $params, $structure_alias){
		$keys = array_keys($params);
		App::import('model', 'StructureFormat');
		$StructureFormat = new StructureFormat();
		$conditions = array();
		foreach($keys as $key){
			if(is_numeric($key)){
				//it's a textual field model.field LIKE %foo%
				list($model_field) = explode(" ", $params[$key]);
				$model_field = substr($model_field, 1);
				list($model, $field) = explode(".", $model_field);
			}else{
				list($model, $field) = explode(".", $key);
			}
			$conditions[] = "StructureField.model='".$model."' AND StructureField.field='".$field."'";
		}
		$sf = $StructureFormat->customSearch("Structure.alias='".$structure_alias."' AND ".implode(" OR ", $conditions));
		$result = "<table align='center' width='100%'>";
		foreach($params as $name => $values){
			if(is_numeric($name)){
				//it's a textual field model.field LIKE %foo%
				list($model_field, , $value) = explode(" ", $params[$key]);
				$model_field = substr($model_field, 1);
				list($model, $field) = explode(".", $model_field);
				$values = array(substr($value, 2, -2));
			}else{
				list($model, $field) = explode(".", $name);
			}
			foreach($sf as $sf_unit){
				if($sf_unit['StructureField']['model'] == $model && $sf_unit['StructureField']['field'] == $field){
					$name = __($sf_unit['StructureFormat']['flag_override_label'] ? $sf_unit['StructureFormat']['language_label'] : $sf_unit['StructureField']['language_label'], true);
					break;
				}
			}
			foreach($values as &$value){
				$value = __($value, true);
			}
			$result .= "<tr><th>".$name."</th><td>".implode(", ", $values)."</td>\n";
		}
		$result .= "</table>";
		return $result;
	}
}
