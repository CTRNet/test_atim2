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
	
		
	function browse($parent_node = 0, $control_id = 0){
		$this->Structures->set("empty", "empty");
		$browsing = null;
		$check_list = false;
		$last_control_id = 0;
		if(empty($this->data)){
			if($parent_node == 0){
				//new access
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($control_id, $parent_node, null, null, null, null, null, null, array("AliquotControl" => array(0))));
				$this->Structures->set("datamart_browser_start");
				$this->set('type', "add");
				$this->set('top', "/datamart/browser/browse/0/");
			}else{
				//direct node access
				$this->set('parent_node', $parent_node);
				$browsing = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
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
			
			$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
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
				$id_csv = implode(",", $ids);
				if(!$parent['BrowsingResult']['raw']){
					//the parent is a drilldown, seek the next parent
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent['BrowsingResult']['parent_node_id'])));
					$parent_node = $parent['BrowsingResult']['id'];
				}

				$save = array('BrowsingResult' => array(
					"user_id" => $_SESSION['Auth']['User']['id'],
					"parent_node_id" => $parent_node,
					"browsing_structures_id" => $parent['BrowsingResult']['browsing_structures_id'],
					"browsing_structures_sub_id" => $parent['BrowsingResult']['browsing_structures_sub_id'],
					"id_csv" => $id_csv,
					"raw" => false
				));
				
				$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
				if(!empty($tmp)){
					//current set already exists, use it
					$parent_node = $tmp['BrowsingResult']['id'];
				}else if($parent['BrowsingResult']['id_csv'] != $id_csv){
					//current set does not exists and no identical parent exists, save!
					$this->BrowsingResult->id = null;
					$this->BrowsingResult->save($save);
					$parent_node = $this->BrowsingResult->id;
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
				$key = $model_to_import.".".$model_key_name;
				if($use_sub_model){
					//adding filtering search condition
					$search_conditions[$browsing['DatamartStructure']['control_master_model'].".".$browsing['DatamartStructure']['control_field']] = $sub_structure_id;
				}
				
				$org_search_conditions['search_conditions'] = $search_conditions;
				$org_search_conditions['exact_search'] = isset($this->data['exact_search']);
				if($parent_node != 0){
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
					$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $parent['DatamartStructure']['id'], 'BrowsingControl.id2' => $browsing['DatamartStructure']['id'])));
					if(!empty($control_data)){
						//retreive the ids in the parent first
						$this->ParentModel = AppModel::atimNew($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['model'], true);
						$parent_data = $this->ParentModel->find('all', array('conditions' => array($parent['DatamartStructure']['model'].".".$parent['DatamartStructure']['use_key']." IN (".$parent['BrowsingResult']['id_csv'].")")));
						list($use_model, $use_field) = explode(".", $control_data['BrowsingControl']['use_field']);
						foreach($parent_data as $data_unit){
							$search_conditions[$key][] = $data_unit[$use_model][$use_field];
						}
					}else{
						//ids are already contained in the child
						$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing['DatamartStructure']['id'], 'BrowsingControl.id2' => $parent['DatamartStructure']['id'])));
						if($use_sub_model){
							//we need to load the ids from the main model then send them for the sub model
							$this->MainModel = AppModel::atimNew($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
							$tmp_data = $this->MainModel->find('all', 
								array("conditions" => array($control_data['BrowsingControl']['use_field']." IN (".$parent['BrowsingResult']['id_csv'].")"),
									"fields" => array($browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key'])));
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
				$save_ids = $this->ModelToSearch->find('all', array('conditions' => $search_conditions, 'fields' => array("GROUP_CONCAT(".$key.") AS ids"), 'GROUP BY NULL'));
				$save_ids = $save_ids[0][0]['ids'];
				$save = array('BrowsingResult' => array(
					"user_id" => $_SESSION['Auth']['User']['id'],
					"parent_node_id" => $parent_node,
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
						$this->flash(sprintf(__("you cannot browse to the requested entities because there is no [%s] matching your request", true), $browsing['DatamartStructure']['display_name']), "/datamart/browser/browse/".$parent_node."/", 5);
					}
					return ;	
				}
				
				$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
				if(empty($tmp)){
					//save fullset
					$save = $this->BrowsingResult->save($save);
					$save['BrowsingResult']['id'] = $this->BrowsingResult->id;
					if($parent_node == 0){
						//save into index as well
						$this->BrowsingIndex->save(array("BrowsingIndex" => array("root_node_id" => $save['BrowsingResult']['id'])));	
					}
					$parent_node = $this->BrowsingResult->id;
					$this->BrowsingResult->id = null;
				}else{
					$save = $tmp;
				}
				$this->BrowsingIndex->id = null;
				$parent_node = $save['BrowsingResult']['id'];
				$first_iteration = false;
			}
			
			//all nodes saved, now load the proper form
			if($check_list){
				$parent_node = $save['BrowsingResult']['id'];
				$browsing['BrowsingResult'] = $save['BrowsingResult'];
			}else{
				//search screen
				$browsing = $this->DatamartStructure->find('first', array('conditions' => array('id' => $last_control_id)));
			}
		}
		
		//handle display data
		if($check_list){
			$model_to_import = null;
			$model_name_to_search = null;
			$use_key = null;
			$result_structure = null;
			//check for detailed structure
			$sub_models_id_filter = array();
			if(strlen($browsing['DatamartStructure']['control_model']) > 0 && $browsing['BrowsingResult']['browsing_structures_sub_id'] > 0){
				$alternate_info = Browser::getAlternateStructureInfo(
					$browsing['DatamartStructure']['plugin'], 
					$browsing['DatamartStructure']['control_model'], 
					$browsing['BrowsingResult']['browsing_structures_sub_id']);
				$alternate_alias = $alternate_info['form_alias'];
				$result_structure = $this->Structures->get('form', $alternate_alias);
				$model_to_import = $browsing['DatamartStructure']['control_master_model'];
				$model_name_to_search = $browsing['DatamartStructure']['control_master_model'];
				$use_key = "id";
				$this->set("header", array("title" => __("result", true), "description" => __($browsing['DatamartStructure']['display_name'], true)." > ".Browser::getTranslatedDatabrowserLabel($alternate_info['databrowser_label'])));
				$sub_models_id_filter = Browser::getDropdownSubFiltering($browsing);
				$browsing['DatamartStructure']['index_link'] = Browser::updateIndexLink($browsing['DatamartStructure']['index_link'], $browsing['DatamartStructure']['model'], $browsing['DatamartStructure']['control_master_model'], $browsing['DatamartStructure']['use_key'], "id");
			}else{
				$result_structure = $this->Structures->getFormById($browsing['DatamartStructure']['structure_id']);
				$model_to_import = $browsing['DatamartStructure']['model'];
				$model_name_to_search = $browsing['DatamartStructure']['model'];
				$use_key = $browsing['DatamartStructure']['use_key'];
				$this->set("header", array("title" => __("result", true), "description" => __($browsing['DatamartStructure']['display_name'], true)));
				$sub_models_id_filter = array("AliquotControl" => array(0));//by default, no aliquot sub type
			}
			
			$this->ModelToSearch = AppModel::atimNew($browsing['DatamartStructure']['plugin'], $model_to_import, true);
			if(strlen($browsing['BrowsingResult']['id_csv']) > 0){
				$conditions = $model_name_to_search.".".$use_key." IN (".$browsing['BrowsingResult']['id_csv'].")";
				//fetch the count since deletions might make the set smaller than the count of ids
				$count = $this->ModelToSearch->find('count', array('conditions' => $conditions));
				if($count > self::$display_limit){
					$data = $this->ModelToSearch->find('all', array('conditions' => $conditions, 'fields' => array("GROUP_CONCAT(".$model_name_to_search.".".$use_key.") AS ids"), 'GROUP BY NULL'));
					$this->data = $data[0][0]['ids'];
				}else{
					$this->data = $this->ModelToSearch->find('all', array('conditions' => $conditions));
				}
			}else{
				$this->data = array();
			}
			$this->set('top', "/datamart/browser/browse/".$parent_node."/");
			$this->set('parent_node', $parent_node);
			$this->set('type', "checklist");
			$this->set('checklist_key', $model_name_to_search.".".$use_key);
			$this->set('checklist_key_name', $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']);
			$structure_alias = null;
			if(isset($result_structure['Structure']['alias'])){
				$structure_alias = $result_structure['Structure']['alias'];
			}else{
				$tmp = array();
				foreach($result_structure['Structure'] as $structure){
					$tmp[] = $structure['alias'];
				}
				$structure_alias = implode(",", $tmp);
			}
			$this->set("dropdown_options", 
				$this->Browser->getDropdownOptions(
					$browsing['DatamartStructure']['id'], 
					$parent_node, 
					$browsing['DatamartStructure']['plugin'], 
					$model_name_to_search,
					$browsing['DatamartStructure']['model'],
					$use_key,
					$browsing['DatamartStructure']['use_key'], 
					$structure_alias, 
					$sub_models_id_filter
				)
			);
			$this->Structures->set("datamart_browser_start");
			$this->set("result_structure", $result_structure);
			$this->set('index', $browsing['DatamartStructure']['index_link']);
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
			$this->set('top', "/datamart/browser/browse/".$parent_node."/".$last_control_id."/");
			$this->set('parent_node', $parent_node);
		}
	}
}