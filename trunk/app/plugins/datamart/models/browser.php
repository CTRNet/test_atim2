<?php
class Browser extends DatamartAppModel {
	var $useTable = false;
	
	function getDropdownOptions(){
		global $getDropdownOptions;
		$result = array();
		if(is_array($getDropdownOptions)){
			$data = $this->query("SELECT * FROM datamart_browsing_controls AS c "
				."LEFT JOIN datamart_browsing_structures AS s1 ON c.id1=s1.id " 
				."LEFT JOIN datamart_browsing_structures AS s2 ON c.id2=s2.id "
				."WHERE id1=".$getDropdownOptions[0]." OR id2=".$getDropdownOptions[0]);
			foreach($data as $data_unit){
				if($data_unit['c']['id1'] == $getDropdownOptions[0]){
					//use 2
					$result[] = array('value' => $data_unit['s2']['id'], 'default' => __($data_unit['s2']['display_name'], true));
				}else{
					//use 1
					$result[] = array('value' => $data_unit['s1']['id'], 'default' => __($data_unit['s1']['display_name'], true));
				}
			}
		}else{
			$data = $this->query("SELECT * FROM datamart_browsing_structures");
			foreach($data as $data_unit){
				$result[] = array('value' => $data_unit['datamart_browsing_structures']['id'], 'default' => __($data_unit['datamart_browsing_structures']['display_name'], true));
			}
		}
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
	
	static function buildTree(TreeNode $tree_node, &$tree = array(), $x = 0, &$y = 0){
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
					$result .= "<td class='node ".$class."'><a href='".$webroot_url."/datamart/browser/index/".$cell['BrowsingResult']['id']."/'><div class='container'><div class='info ".($x < $half_width ? "right" : "left")."'>".$info."</div></div></a></td>";
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
	static function formatSearchToPrint(array $params, String $structure_alias){
		$keys = array_keys($params);
		
		$StructureFormat = new StructureFormat();
		$conditions = array();
		foreach($keys as $key){
			if(is_numeric($key)){
				//it's a textual field model.field LIKE %foo%
				list($model_field) = explode(" ", $params[$key]);
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
