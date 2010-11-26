<?php
class Browser extends DatamartAppModel {
	var $useTable = false;

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
	 * @param string $structure_name The name of the structure to use in export to csv link
	 * @param array $sub_models_id_filter An array with ControlModel => array(ids) to filter the sub models id
	 * @return Returns an array representing the options to display in the action drop down 
	 */
	function getDropdownOptions($starting_ctrl_id, $node_id, $plugin_name = null, $model_name = null, $data_model = null, $model_pkey = null, $data_pkey = null, $structure_name = null, array $sub_models_id_filter = null){
		$app_controller = AppController::getInstance();
		if(!App::import('Model', 'Datamart.DatamartStructure')){
			$app_controller->redirect( '/pages/err_model_import_failed?p[]=Datamart.DatamartStructure', NULL, TRUE );
		}
		$DatamartStructure = new DatamartStructure();
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
			$result[] = array(
				'value' => '0',
				'default' => __('create batchset', true),
				'action' => 'datamart/batch_sets/add/'
			);
			$result[] = array(
				'value' => '0',
				'default' => __('export as CSV file (comma-separated values)', true),
				'action' => 'csv/csv/'.$plugin_name.'/'.$model_name.'/'.$model_pkey.'/'.$structure_name.'/'.$data_model.'/'.$data_pkey.'/'
			);
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
		if(!App::import('Model', $main_model_info['DatamartStructure']['plugin'].".".$main_model_info['DatamartStructure']['control_model'])){
			$app_controller->redirect( '/pages/err_model_import_failed?p[]='.$main_model_info['DatamartStructure']['plugin'].".".$main_model_info['DatamartStructure']['control_model'], NULL, TRUE );
		}
		$control_model = new $main_model_info['DatamartStructure']['control_model']();
		$conditions = array();
		if($main_model_info['DatamartStructure']['control_model'] == "SampleControl"){
			//hardcoded SampleControl filtering
			if(!App::import('Model', 'Inventorymanagement.ParentToDerivativeSampleControl')){
				$app_controller->redirect( '/pages/err_model_import_failed?p[]=Inventorymanagement.ParentToDerivativeSampleControl', NULL, TRUE );
			}
			$parentToDerivativeSampleControl = new ParentToDerivativeSampleControl();
			$tmp_ids = $parentToDerivativeSampleControl->getActiveSamples();
			if($ids_filter == null){
				$ids_filter = $tmp_ids;
			}else{
				array_intersect($ids_filter, $tmp_ids);
			}
		}
		if($ids_filter != null){
			$conditions[] = $main_model_info['DatamartStructure']['control_model'].'.id IN('.implode(", ", $ids_filter).')';
		}
		if(isset($control_model->_schema['flag_active'])){
			$conditions[$main_model_info['DatamartStructure']['control_model'].'.flag_active'] = 1;
		}
		$children_data = $control_model->find('all', array('order' => $main_model_info['DatamartStructure']['control_model'].'.databrowser_label', 'conditions' => $conditions));
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
	 * @return An array representing the search tree
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
	 * @param array &$tree An array with the current tree representation
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
	 * @param Int $current_node The id of the current node. Its path will be highlighted
	 * @param String $webroot_url The webroot of ATiM
	 * @return the html of the table search tree
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
					$title = __($cell['DatamartStructure']['display_name'], true);
					$info = "";
					if($cell['BrowsingResult']['raw']){
						$search = unserialize($cell['BrowsingResult']['serialized_search_params']);
						if(count($search['search_conditions'])){
							$structure_id_to_load = null;
							if(strlen($cell['DatamartStructure']['control_model']) > 0 && $cell['BrowsingResult']['browsing_structures_sub_id'] > 0){
								//alternate structure required
								$alternate_alias = self::getAlternateStructureInfo($cell['DatamartStructure']['plugin'], $cell['DatamartStructure']['control_model'], $cell['BrowsingResult']['browsing_structures_sub_id']);
								$alternate_alias = $alternate_alias['form_alias'];
								$alternate_structure = StructuresComponent::$singleton->get('form', $alternate_alias);
							 	$structure_id_to_load = $alternate_structure['Structure']['id'];
							 	//unset the serialization on the sub model since it's already in the title
							 	unset($search['search_conditions'][$cell['DatamartStructure']['control_master_model'].".".$cell['DatamartStructure']['control_field']]);
							 	if(!App::import("model", $cell['DatamartStructure']['plugin'].".".$cell['DatamartStructure']['control_master_model'])){
							 		AppController::getInstance()->redirect( '/pages/err_model_import_failed?p[]='.$cell['DatamartStructure']['plugin'].".".$cell['DatamartStructure']['control_master_model'], NULL, TRUE );
							 	}
							 	$tmp_model = new $cell['DatamartStructure']['control_model']();
							 	$tmp_data = $tmp_model->find('first', array('conditions' => array($cell['DatamartStructure']['control_model'].".id" => $cell['BrowsingResult']['browsing_structures_sub_id'])));
							 	$title .= " > ".self::getTranslatedDatabrowserLabel($tmp_data[$cell['DatamartStructure']['control_model']]['databrowser_label']);
							}else{
								$structure_id_to_load = $cell['DatamartStructure']['structure_id'];
							}
							if(count($search['search_conditions'])){//count might be zero if the only condition was the sub type
								$info .= __("search", true)."<br/><br/>".Browser::formatSearchToPrint($search, $structure_id_to_load);
							}else{
								$info .= __("direct access", true);
							}
						}else{
							$info .= __("direct access", true);
						}
					}else{
						$info .= __("drilldown", true);
					}
					$result .= "<td class='node ".$class."'><a href='".$webroot_url."datamart/browser/browse/".$cell['BrowsingResult']['id']."/'><div class='container'><div class='info ".($x < $half_width ? "right" : "left")."'><span class='title'>".$title."</span> (".$count.")<br/>\n".$info."</div></div></a></td>";
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
		$structures_component = StructuresComponent::$singleton;
		$sf = $structures_component->getFormById($structure_id);
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
			foreach($sf['Sfs'] as $sf_unit){
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
	 * @param string $model The name of the model to search on
	 * @param int $id The id of the alternate structure to retrieve
	 * @return string The info of the alternate structure
	 */
	static function getAlternateStructureInfo($plugin, $model, $id){
		if(!App::import('Model', $plugin.".".$model)){
			AppController::getInstance()->redirect( '/pages/err_model_import_failed?p[]='.$plugin.".".$model, NULL, TRUE );
		}
		$model_to_use = new $model();
		$data = $model_to_use->find('first', array('conditions' => array($model.".id" => $id)));
		return $data[$model];
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
			if(!App::import("model", "Inventorymanagement.SampleToAliquotControl")){
				AppController::getInstance()->redirect( '/pages/err_model_import_failed?p[]=Inventorymanagement.SampleToAliquotControl', NULL, TRUE );
			}
			$stac = new SampleToAliquotControl();
			$data = $stac->find('all', array('conditions' => array("SampleToAliquotControl.sample_control_id" => $browsing['BrowsingResult']['browsing_structures_sub_id'], "SampleToAliquotControl.flag_active" => 1), 'recursive' => -1));
			$ids = array();
			foreach($data as $unit){
				$ids[] = $unit['SampleToAliquotControl']['aliquot_control_id'];
			}
			$sub_models_id_filter['AliquotControl'] = $ids;
		}else if($browsing['DatamartStructure']['id'] == 1){
			//aliquot->sample hardcoded part
			assert($browsing['DatamartStructure']['control_master_model'] == "AliquotMaster");//will print a warning if the id and field doesnt match anymore
			if(!App::import("model", "Inventorymanagement.SampleToAliquotControl")){
				AppController::getInstance()->redirect( '/pages/err_model_import_failed?p[]=Inventorymanagement.SampleToAliquotControl', NULL, TRUE );
			}
			$stac = new SampleToAliquotControl();
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
		if(!App::import('Model', 'Datamart.BrowsingControl')){
			$app_controller->redirect( '/pages/err_model_import_failed?p[]=Datamart.DatamartStructure', NULL, TRUE );
		}
		$BrowsingControl = new BrowsingControl();
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
}
