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
		App::import("Model", "Datamart.BrowsingResult");
		$BrowsingResult = new BrowsingResult();
		$result = $BrowsingResult->find('all', array('conditions' => 'node_id='.$node_id.' OR parent_node_id='.$node_id, 'order' => array('node_id')));
		$tree_node = NULL;
		if($tree_node = array_shift($result)){
			$tree_node['active'] = $node_id == $active_node;
			$tree_node['children'] = array();
			$children = array();
			while($node = array_shift($result)){
				$children[] = $node['BrowsingResult']['node_id'];
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
		App::import("Model", "Datamart.BrowsingResult");
		$BrowsingResult = new BrowsingResult();
		$tmp_node = $current_node;
		$prev_node = NULL;
		do{
			$prev_node = $tmp_node;
			$br = $BrowsingResult->find('first', array('conditions' => array('node_id' => $tmp_node)));
			if(!empty($br)){
				$tmp_node = $br['BrowsingResult']['parent_node_id'];
			}
		}while($tmp_node);
		$fm = Browser::getTree($prev_node, $current_node);
		Browser::buildTree($fm, $tree);
		$result .= "<table class='structure'><tr><td align='center'>".__("browsing", true)
			."<table class='databrowser'>\n";
		ksort($tree);
		foreach($tree as $x => $line){
			$result .= '<tr>';
			$last_y = -1;
			ksort($line);
			foreach($line as $y => $cell){
				$pad = $y - $last_y - 1;
				$pad_pos = 0;
				while($pad > 0){
					$result .= '<td></td>';
					$pad --;
				}
				if(is_array($cell)){
					$class = "";
					if($cell['BrowsingStructure']['id'] == 1){
						$class = "aliquot";
					}else if($cell['BrowsingStructure']['id'] == 2){
						$class = "collection";
					}else if($cell['BrowsingStructure']['id'] == 3){
						$class = "storage";
					}else if($cell['BrowsingStructure']['id'] == 4){
						$class = "participant";
					}else if($cell['BrowsingStructure']['id'] == 5){
						$class = " sample";
					}
					if($cell['active']){
						$class .= " active ";
					}
					$info = "<span class='title'>".__($cell['BrowsingStructure']['display_name'], true)."</span><br/>\n";
					if($cell['BrowsingResult']['raw']){
						$search = unserialize($cell['BrowsingResult']['serialized_search_params']);
						if(count($search)){
							$info .= "Search<br/>".print_r($search, true);
						}else{
							$info .= "Direct access";
						}
					}else{
						$info .= "Drilldown";
					}
					$result .= "<td class='node ".$class."'><a href='".$webroot_url."/datamart/browser/index/".$cell['BrowsingResult']['node_id']."/'><div class='container'><div class='info'>".$info."</div></div></a></td>";
				}else{
					$result .= "<td class='".$cell."'></td>";
				}
				$last_y = $y;
			}
			$result .= "</tr>\n";
		}
		$result .= '</table></td></tr></table>';
		return $result;
	}
}
