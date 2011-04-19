<?php
class BrowserController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.Browser',
		'Datamart.DatamartStructure',
		'Datamart.BrowsingResult',
		'Datamart.BrowsingControl',
		'Datamart.BrowsingIndex',
		'Datamart.BatchSet',
		'Datamart.BatchId'
		);
		
	function index(){
		$this->Structures->set("datamart_browsing_indexes");
		$this->data = $this->paginate($this->BrowsingIndex, array("BrowsingResult.user_id" => $_SESSION['Auth']['User']['id']));
	}
	
	function edit($index_id){
		$this->set("index_id", $index_id);
		$this->Structures->set("datamart_browsing_indexes");
		if(empty($this->data)){
			$this->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'])));
		}else{
			$this->BrowsingIndex->id = $index_id;
			unset($this->data['BrowsingIndex']['created']);
			$this->BrowsingIndex->save($this->data);
			$this->atimFlash('your data has been updated', "/datamart/browser/index");
		}
	}
	
	function delete($index_id){
		$this->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'])));
		if(!empty($this->data)){
			$this->BrowsingIndex->atim_delete($index_id);
			$this->BrowsingResult->atim_delete($this->data['BrowsingIndex']['root_node_id']);
			$this->atimFlash( 'your data has been deleted', '/datamart/browser/index/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/datamart/browser/index/');
		}
	}
	
		
	/**
	 * Core of the databrowser, handles all browsing requests. Searches, normal display, merged display and overflow display.
	 * @param int $node_id 0 if it's a new browsing, the node id to display or the parent node id when in a search form
	 * @param string $control_id The datamart structure control id. If there is a substructure, 
	 * the string will separate the structure id from the substructure id with an underscore. It will be of the form id_sub-id 
	 * @param int $merge_to If a merged display is required, the node id to merge to. The merge direction is always from node_id to merge_to
	 */
	function browse($node_id = 0, $control_id = 0, $merge_to = 0){
		$this->Structures->set("empty", "empty");
		$browsing = null;
		$check_list = false;
		$last_control_id = 0;
		if(empty($this->data)){
			if($node_id == 0){
				//new access
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($control_id, $node_id, null, null, null, null, null, null, array("AliquotControl" => array(0))));
				$this->Structures->set("datamart_browser_start");
				$this->set('type', "add");
				$this->set('top', "/datamart/browser/browse/0/");
			}else{
				//direct node access
				$this->set('node_id', $node_id);
				$browsing = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $node_id)));
				$check_list = true;
			}
		}else{
			// ->browsing access<- (search form or checklist)
			if(isset($this->data['Browser']['search_for'])){
				//search_for is taken from the dropdown
				if(strpos($this->data['Browser']['search_for'], "/") > 0){
					list($control_id, $check_list) = explode("/", $this->data['Browser']['search_for']);
				}else{ 
					$control_id = $this->data['Browser']['search_for'];
					$check_list = false;
				}
			}else if($control_id == 0){
				//error, the control_id should't be 0
				$this->redirect( '/pages/err_internal?p[]=control_id', NULL, TRUE );
			}else{
				$check_list = true;
			}
			
			$sub_structure_id = null;//control id for master/detail
			if(strpos($control_id, Browser::$sub_model_separator_str) !== false){
				list($control_id , $sub_structure_id) = explode(Browser::$sub_model_separator_str, $control_id);
			}
			//direct access array (if the user goes from 1 to 4 by going throuhg 2 and 3, the direct access are 2 and 3
			$direct_id_arr = explode(Browser::$model_separator_str, $control_id);
			
			$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $node_id)));
			if(isset($this->data[$parent['DatamartStructure']['model']]) && isset($this->data['Browser'])){
				//save selected subset if parent model found and from a checklist 
				$ids = array();
				if(count($this->data[$parent['DatamartStructure']['model']][$parent['DatamartStructure']['use_key']]) == 1 
				&& strpos($this->data[$parent['DatamartStructure']['model']][$parent['DatamartStructure']['use_key']], ",") !== false){
					//all ids in one field
					$ids = explode(",", $this->data[$parent['DatamartStructure']['model']][$parent['DatamartStructure']['use_key']]);
				}else{
					//ids in n fields
					foreach($this->data[$parent['DatamartStructure']['model']][$parent['DatamartStructure']['use_key']] as $id){
						if($id != 0){
							$ids[] = $id;
						}
					}
				}

				$id_csv = implode(",", array_unique($ids));
				if(!$parent['BrowsingResult']['raw']){
					//the parent is a drilldown, seek the next parent
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent['BrowsingResult']['parent_node_id'])));
					$node_id = $parent['BrowsingResult']['id'];
				}

				$save = array('BrowsingResult' => array(
					"user_id" => $_SESSION['Auth']['User']['id'],
					"parent_node_id" => $node_id,
					"browsing_structures_id" => $parent['BrowsingResult']['browsing_structures_id'],
					"browsing_structures_sub_id" => $parent['BrowsingResult']['browsing_structures_sub_id'],
					"id_csv" => $id_csv,
					"raw" => false
				));
				
				$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
				if(!empty($tmp)){
					//current set already exists, use it
					$node_id = $tmp['BrowsingResult']['id'];
				}else if($parent['BrowsingResult']['id_csv'] != $id_csv){
					//current set does not exists and no identical parent exists, save!
					$this->BrowsingResult->id = null;
					$this->BrowsingResult->save($save);
					$node_id = $this->BrowsingResult->id;
					$this->BrowsingResult->id = null;
				}
			}
			
			$last_control_id = $direct_id_arr[count($direct_id_arr) - 1];
			if(!$check_list){
				//going to a search screen, remove the last direct_id to avoid saving it as direct access
				array_pop($direct_id_arr);
			}
			$result_structure = null;
			$browsing = null;
			$model_name_to_search = null;
			$model_key_name = null;
			$use_sub_model = null;
			$first_iteration = true;
			//direct access, save nodes
			foreach($direct_id_arr as $control_id){
				$browsing = $this->DatamartStructure->find('first', array('conditions' => array('id' => $control_id)));
				if(isset($sub_structure_id)//there is a sub id 
				&& strlen($browsing['DatamartStructure']['control_model']) > 0//a sub model exists
				&& $direct_id_arr[count($direct_id_arr) - 1] == $control_id//this is the last element
				&& $check_list//this is a checklist
				){
					//sub structure
					$alternate_info = Browser::getAlternateStructureInfo($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['control_model'], $sub_structure_id);
					$alternate_alias = $alternate_info['form_alias'];
					$result_structure = $this->Structures->get('form', $alternate_alias);
					$model_to_import = $browsing['DatamartStructure']['control_master_model'];
					$model_name_to_search = $browsing['DatamartStructure']['control_master_model'];
					$model_key_name = "id";
					$use_sub_model = true;
				}else{
					$model_to_import = $browsing['DatamartStructure']['model'];
					$model_name_to_search = $browsing['DatamartStructure']['model'];
					$result_structure = $this->Structures->getFormById($browsing['DatamartStructure']['structure_id']);
					$model_key_name = $browsing['DatamartStructure']['use_key'];
					$use_sub_model = false;
				}
				
				$this->ModelToSearch = AppModel::atimNew($browsing['DatamartStructure']['plugin'], $model_to_import, true);
				$search_conditions = $this->Structures->parse_search_conditions($result_structure);
				$select_key = $model_to_import.".".$model_key_name;
				if($use_sub_model){
					//adding filtering search condition
					$search_conditions[$browsing['DatamartStructure']['control_master_model'].".".$browsing['DatamartStructure']['control_field']] = $sub_structure_id;
				}
				
				$org_search_conditions['search_conditions'] = $search_conditions;
				$org_search_conditions['exact_search'] = isset($this->data['exact_search']);
				if($node_id != 0){
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $node_id)));
					$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $parent['DatamartStructure']['id'], 'BrowsingControl.id2' => $browsing['DatamartStructure']['id'])));
					if(!empty($control_data)){
						//retreive the ids in the parent first
						$this->ParentModel = AppModel::atimNew($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['model'], true);
						$parent_data = $this->ParentModel->find('all', array('conditions' => array($parent['DatamartStructure']['model'].".".$parent['DatamartStructure']['use_key']." IN (".$parent['BrowsingResult']['id_csv'].")"), 'recursive' => 0));
						list($use_model, $use_field) = explode(".", $control_data['BrowsingControl']['use_field']);
						foreach($parent_data as $data_unit){
							$search_conditions[$select_key][] = $data_unit[$use_model][$use_field];
						}
					}else{
						//ids are already contained in the child
						$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing['DatamartStructure']['id'], 'BrowsingControl.id2' => $parent['DatamartStructure']['id'])));
						if($use_sub_model){
							//we need to load the ids from the main model then send them for the sub model
							$this->MainModel = AppModel::atimNew($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
							$tmp_data = $this->MainModel->find('all', 
								array("conditions" => array($control_data['BrowsingControl']['use_field']." IN (".$parent['BrowsingResult']['id_csv'].")"),
									"fields" => array($browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']),
									"recursive" => 0));
							$tmp_ids = array();
							foreach($tmp_data as $unit){
								$tmp_ids[] = $unit[$browsing['DatamartStructure']['model']][$browsing['DatamartStructure']['use_key']];
							}
							$key = $browsing['DatamartStructure']['control_master_model'].".id";
							$search_conditions[] = $key." IN (".implode(", ", $tmp_ids).")";
						}else{
							$key = $control_data['BrowsingControl']['use_field'];
							$search_conditions[] = $key." IN (".$parent['BrowsingResult']['id_csv'].")";
						}
					}
				}
				$save_ids = $this->ModelToSearch->find('all', array('conditions' => $search_conditions, 'fields' => array("CONCAT('', ".$select_key.") AS ids"), "recursive" => 0));
				$save_ids = implode(",", array_unique(array_map(create_function('$val', 'return $val[0]["ids"];'), $save_ids)));
				$save = array('BrowsingResult' => array(
					"user_id" => $_SESSION['Auth']['User']['id'],
					"parent_node_id" => $node_id,
					"browsing_structures_id" => $control_id,
					"browsing_structures_sub_id" => $use_sub_model ? $sub_structure_id : 0,
					"id_csv" => $save_ids,
					"raw" => true,
					"serialized_search_params" => serialize($org_search_conditions),
				));
				
				if(strlen($save_ids) == 0){
					//we have an empty set, bail out! (don't save empty result)
					if($control_id == $last_control_id){
						//go back 1 page
						$this->flash(__("no data matches your search parameters", true), "javascript:history.back();", 5);
					}else{
						//go to the last node
						$this->flash(sprintf(__("you cannot browse to the requested entities because there is no [%s] matching your request", true), $browsing['DatamartStructure']['display_name']), "/datamart/browser/browse/".$node_id."/", 5);
					}
					return ;	
				}
				
				$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
				if(empty($tmp)){
					//save fullset
					$save = $this->BrowsingResult->save($save);
					$save['BrowsingResult']['id'] = $this->BrowsingResult->id;
					if($node_id == 0){
						//save into index as well
						$this->BrowsingIndex->save(array("BrowsingIndex" => array("root_node_id" => $save['BrowsingResult']['id'])));	
					}
					$node_id = $this->BrowsingResult->id;
					$this->BrowsingResult->id = null;
				}else{
					$save = $tmp;
				}
				$this->BrowsingIndex->id = null;
				$node_id = $save['BrowsingResult']['id'];
				$first_iteration = false;
			}
			
			//all nodes saved, now load the proper form
			if($check_list){
				$node_id = $save['BrowsingResult']['id'];
				$browsing['BrowsingResult'] = $save['BrowsingResult'];
			}else{
				//search screen
				$browsing = $this->DatamartStructure->find('first', array('conditions' => array('id' => $last_control_id)));
			}
		}
		
		//handle display data
		if($check_list){
			$this->Browser->fetchChecklist($browsing, self::$display_limit);
			
			$this->set('top', "/datamart/browser/browse/".$node_id."/");
			$this->set('node_id', $node_id);
			$this->set('type', "checklist");
			$this->set('checklist_key', $this->Browser->checklist_model_name_to_search.".".$this->Browser->checklist_use_key);
			$this->set('checklist_key_name', $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']);
			$structure_alias = null;
			if(isset($this->Browser->checklist_result_structure['Structure']['alias'])){
				$structure_alias = $this->Browser->checklist_result_structure['Structure']['alias'];
			}else{
				$tmp = array();
				foreach($this->Browser->checklist_result_structure['Structure'] as $structure){
					$tmp[] = $structure['alias'];
				}
				$structure_alias = implode(",", $tmp);
			}
			$dropdown_options = $this->Browser->getDropdownOptions(
				$browsing['DatamartStructure']['id'], 
				$node_id, 
				$browsing['DatamartStructure']['plugin'], 
				$this->Browser->checklist_model_name_to_search,
				$browsing['DatamartStructure']['model'],
				$this->Browser->checklist_use_key,
				$browsing['DatamartStructure']['use_key'], 
				$structure_alias, 
				$this->Browser->checklist_sub_models_id_filter
			);
			foreach($dropdown_options as &$option){
				if(isset($option['action']) && strpos($option['action'], 'csv/csv') === 0){
					$option['action'] = 'datamart/browser/csv/'.$node_id."/".$merge_to."/";
					break;
				}
			}
			
			$this->set("dropdown_options", $dropdown_options);
			$this->Structures->set("datamart_browser_start");
			
			if($this->Browser->checklist_model_name_to_search != $browsing['DatamartStructure']['model']){
				$browsing['DatamartStructure']['index_link'] = str_replace(
					$browsing['DatamartStructure']['model'], 
					$this->Browser->checklist_model_name_to_search,
					str_replace(
						$browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key'], 
						$this->Browser->checklist_model_name_to_search.".".$this->Browser->checklist_use_key, 
						$browsing['DatamartStructure']['index_link']
					)
				);
			}
			$this->set('index', $browsing['DatamartStructure']['index_link']);
			if($merge_to == 0){
				$this->set("result_structure", $this->Browser->checklist_result_structure);
				$this->data = $this->Browser->checklist_data;
				$this->set("header", $this->Browser->checklist_header);
			}else{
				//!is_array($this->Browser->checklist_data)
				//merged display
				$start_id = NULL;
				$end_id = null;
				$this->data = $this->Browser->checklist_data;
				$this->Browser->fetchChecklist($browsing, 0);//get all ids in case of an overflow
				$overflow_data = $this->Browser->checklist_data;
				$overflow_header = $this->Browser->checklist_header;
				$overflow_structure = $this->Browser->checklist_result_structure;
				$descending = null;
				$previous_browsing = $browsing;
				$latest_struct_id = $browsing['BrowsingResult']['browsing_structures_id'];
				$result_structure = $this->Browser->checklist_result_structure;
				$header = $this->Browser->checklist_header;
				unset($result_structure['Structure']);
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
				$browsing_cache = array();
				$nodes_to_fetch = array();
				$datamart_structures_cache[$browsing['DatamartStructure']['id']] = $browsing['DatamartStructure'];
				while($start_id != $end_id){
					$nodes_to_fetch[] = $start_id;
					$browsing = $this->BrowsingResult->mergeStep($start_id, $nodes_to_fetch, $browsing_cache, $datamart_structures_cache);
					$start_id = $browsing['BrowsingResult']['parent_node_id'];
				}
				
				if($descending){
					array_shift($nodes_to_fetch);
					$nodes_to_fetch[] = $end_id;
					$this->BrowsingResult->mergeStep($end_id, $nodes_to_fetch, $browsing_cache, $datamart_structures_cache);
				}
				$this->set("merged_ids", $nodes_to_fetch);
				
				if($descending){
					//clear drilldown parents
					$remove = $previous_browsing['BrowsingResult']['raw'] == 0;
					foreach($nodes_to_fetch as $index => $node_to_fetch){
						if($remove){
							unset($nodes_to_fetch[$index]);
							$remove = false;
						}else{
							$remove = $browsing_cache[$node_to_fetch]['BrowsingResult']['raw'] == 0;
						}
					}
				}else{
					$nodes_to_fetch = array_reverse($nodes_to_fetch);
					//clear drilldowns
					foreach($nodes_to_fetch as $index => $node_to_fetch){
						if($browsing_cache[$node_to_fetch]['BrowsingResult']['raw'] == 0){
							unset($nodes_to_fetch[$index]);
						}
					}
				}

				$iteration_count = 1;
				if(is_array($this->data)){
					//we don't already have an overflow, move on
					foreach($nodes_to_fetch as $node_to_fetch){
						$browsing = $browsing_cache[$node_to_fetch];
						
						//id1 got the key to match on
						//data marge
						$browsing_control = $this->BrowsingControl->find('first', array('conditions' => array('id1' => $latest_struct_id, 'id2' => $browsing['BrowsingResult']['browsing_structures_id'])));
						$checklist_model = null;
						$checklist_field = null;
						$data_model = null;
						$data_field = null;
						if(empty($browsing_control)){
							$browsing_control = $this->BrowsingControl->find('first', array('conditions' => array('id2' => $latest_struct_id, 'id1' => $browsing['BrowsingResult']['browsing_structures_id'])));
							assert(!empty($browsing_control)) or die();
							
							$this->Browser->fetchChecklist($browsing, self::$display_limit);
							if(!is_array($this->Browser->checklist_data)){
								break;
							}
							
							list($checklist_model, $checklist_field) = explode(".", $browsing_control['BrowsingControl']['use_field']);
							if(!isset($this->Browser->checklist_data[0][$checklist_model])){
								//alternate
								$checklist_model = $datamart_structures_cache[$browsing['BrowsingResult']['browsing_structures_id']]['control_master_model'];
							}
							
							if(isset($this->data[0][$datamart_structures_cache[$latest_struct_id]['model']])){
								$data_model = $datamart_structures_cache[$latest_struct_id]['model'];
								$data_field = $datamart_structures_cache[$latest_struct_id]['use_key'];
							}else{
								$data_model = $datamart_structures_cache[$latest_struct_id]['control_master_model'];
								$data_field = "id";
							}
	
							$this->data = AppController::defineArrayKey($this->data, $data_model, $data_field);
							$to_remove = array();
							$tmp_data = array();
							foreach($this->Browser->checklist_data as $data_unit){
								if(isset($this->data[$data_unit[$checklist_model][$checklist_field]])){
									foreach($this->data[$data_unit[$checklist_model][$checklist_field]] as $sub_data_unit){
										if(isset($sub_data_unit[$checklist_model])){
											//remove "as many" relations. Eg.: SampleMaster returns an AliquotMaster array -> remove it
											unset($sub_data_unit[$checklist_model]);
										}
										$tmp_data[] = array_merge($data_unit, $sub_data_unit);
										$to_remove[$data_unit[$checklist_model][$checklist_field]] = null;
									}
								}
							}
	
							foreach(array_keys($to_remove) as $remove_id){
								unset($this->data[$remove_id]);
							}
							
							foreach($this->data as $data_unit){
								//merge parent w/o child back into the result set
								$tmp_data = array_merge($data_unit, $tmp_data);
							}
	
							$this->data = $tmp_data;
						}else{
							$model_name = isset($this->data[0][$previous_browsing['DatamartStructure']['model']]) ? $previous_browsing['DatamartStructure']['model'] : $previous_browsing['DatamartStructure']['control_master_model'];
							list($data_model, $data_field) = explode(".", $browsing_control['BrowsingControl']['use_field']);
							
							{
								//filter
								$filter_ids = array();
								foreach($this->data as $data_unit){
									$filter_ids[] = $data_unit[$model_name][$data_field];
								}
								$filter_ids = array_unique($filter_ids);
								$org_filter_ids = explode(",", $browsing['BrowsingResult']['id_csv']);
								$browsing['BrowsingResult']['id_csv'] = implode(", ", array_intersect($filter_ids, $org_filter_ids));//only going to load required ids rather than the entire set
							}
							
							$this->Browser->fetchChecklist($browsing, self::$display_limit);
							if(!is_array($this->Browser->checklist_data)){
								break;
							}
							
							if(!isset($this->data[0][$data_model])){
								//alternate
								$data_model = $datamart_structures_cache[$latest_struct_id]['control_master_model'];
							}
	
							$control_structure = $datamart_structures_cache[$browsing['BrowsingResult']['browsing_structures_id']];
							if(isset($this->Browser->checklist_data[0][$control_structure['model']])){
								$checklist_model = $control_structure['model'];
								$checklist_field = $control_structure['use_key']; 
							}else{
								//alternate
								$checklist_model = $control_structure['control_master_model'];
								$checklist_field = 'id';
							}
							$this->Browser->checklist_data = AppController::defineArrayKey($this->Browser->checklist_data, $checklist_model, $checklist_field);
							foreach($this->data as &$data_unit){
								$index = $data_unit[$data_model][$data_field];
								if(isset($this->Browser->checklist_data[$index])){
									$data_unit = array_merge($this->Browser->checklist_data[$index][0], $data_unit);
								}
							}
						}
						
						//structure merge, add 100 * iteration count to display column
						foreach($this->Browser->checklist_result_structure['Sfs'] as $sfs){
							$sfs['display_column'] += 100 * $iteration_count;
							$result_structure['Sfs'][] = $sfs;
						}
						
						//header merge
						$header['description'].= " - ".$this->Browser->checklist_header['description'];
						
						$latest_struct_id = $browsing['BrowsingResult']['browsing_structures_id'];
						++ $iteration_count;

						$previous_browsing = $browsing;
					}
					
				}
				
				if(is_array($this->Browser->checklist_data)){
					//all went well
					$this->set("header", $header);
					$this->set("result_structure", $result_structure);
				}else{
					//we've got an overflow at some point
					$this->set("result_structure", $overflow_structure);
					$this->data = $overflow_data;
					$this->set("header", $overflow_header);
				}
			}
		}else if($browsing != null){
			//search screen
			$this->set('type', "search");
			if(isset($sub_structure_id) && strlen($browsing['DatamartStructure']['control_model']) > 0){
				$alternate_info = Browser::getAlternateStructureInfo($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['control_model'], $sub_structure_id);
				$alternate_alias = $alternate_info['form_alias'];
				$this->Structures->set($alternate_alias);
				$last_control_id .= "-".$sub_structure_id;
				$this->set("header", array("title" => __("search", true), "description" => __($browsing['DatamartStructure']['display_name'], true)." > ".Browser::getTranslatedDatabrowserLabel($alternate_info['databrowser_label'])));
			}else{
				$this->set("atim_structure", $this->Structures->getFormById($browsing['DatamartStructure']['structure_id'])); 
				$this->set("header", array("title" => __("search", true), "description" => __($browsing['DatamartStructure']['display_name'], true)));
			}
			$this->set('top', "/datamart/browser/browse/".$node_id."/".$last_control_id."/");
			$this->set('node_id', $node_id);
		}
	}
	
	/**
	 * Used to generate the databrowser csv
	 * @param int $parent_id
	 * @param int $merge_to
	 */
	function csv($node_id, $merge_to){
		$browsing = $this->BrowsingResult->findById($node_id);
		$ids = array();
		
		if(is_array($this->data[$browsing['DatamartStructure']['model']][$browsing['DatamartStructure']['use_key']])){
			$ids = array_filter($this->data[$browsing['DatamartStructure']['model']][$browsing['DatamartStructure']['use_key']]);
		}else{
			$ids = explode(",", $this->data[$browsing['DatamartStructure']['model']][$browsing['DatamartStructure']['use_key']]);
		}
		$ids = array_flip($ids);
		$this->data = array();
		self::$display_limit = -1;//no limit
		$this->browse($node_id, 0, $merge_to);
		$tmp_data = array();
		foreach($this->data as $data){
			if(isset($ids[$data[$browsing['DatamartStructure']['model']][$browsing['DatamartStructure']['use_key']]])){
				$tmp_data[] = $data;
			}
		}
		$this->data = $tmp_data;
		Configure::write('debug', 0);
		$this->layout = false;
	}
}