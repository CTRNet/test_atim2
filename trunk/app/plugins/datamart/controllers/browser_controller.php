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
			$this->atimFlash( 'your data has been deleted', '/datamart/browser/index/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/datamart/browser/index/');
		}
	}
	
		
	function browse($parent_node = 0, $control_id = 0){
		$this->Structures->set("empty", "empty");
		if(empty($this->data)){
			if($parent_node == 0){
				//new access
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($control_id, $parent_node));
				$this->Structures->set("datamart_browser_start");
				$this->set('type', "add");
				$this->set('top', "/datamart/browser/browse/0/");
			}else{
				//direct node access
				$this->set('parent_node', $parent_node);
				$browsing = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
				$model_to_import = $browsing['DatamartStructure']['plugin'].".".$browsing['DatamartStructure']['model'];
				if(!App::import('Model', $model_to_import)){
					$this->redirect( '/pages/err_model_import_failed?p[]='.$model_to_import, NULL, TRUE );
				}
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($browsing['DatamartStructure']['id'], $parent_node, $browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], $browsing['DatamartStructure']['use_key'], $browsing['DatamartStructure']['structure_id']));
				$this->ModelToSearch = new $browsing['DatamartStructure']['model'];
				$this->data = strlen($browsing['BrowsingResult']['id_csv']) > 0 ? $this->ModelToSearch->find('all', array('conditions' => $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']." IN (".$browsing['BrowsingResult']['id_csv'].")")) : array();
				$this->set("atim_structure", $this->Structures->getFormById($browsing['DatamartStructure']['structure_id']));
				$this->set('top', "/datamart/browser/browse/".$parent_node."/"); 
				$this->set('type', "checklist");
				$this->set('checklist_key', $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']);
				$this->set('checklist_key_name', $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']);
				$result_structure = $this->Structures->getFormById($browsing['DatamartStructure']['structure_id']);
				$this->Structures->set("datamart_browser_start");
				$this->set("result_structure", $result_structure);
			}
		}else{
			//browsing access (search form or checklist)
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
			//direct access array
			$direct_id_arr = explode("_", $control_id);
			
			//save selected subset
			$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
			if(isset($this->data[$parent['DatamartStructure']['model']])){
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
					"id_csv" => $id_csv,
					"raw" => false
				));
				
				$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
				if(empty($tmp)){
					//current set does not exists, check for parent
					if($parent['BrowsingResult']['id_csv'] != $id_csv){
						//no identical parent exists, save!
						$this->BrowsingResult->id = null;
						$this->BrowsingResult->save($save);
						$parent_node = $this->BrowsingResult->id;
						$this->BrowsingResult->id = null;
					}
				}else{
					$parent_node = $tmp['BrowsingResult']['id'];
				}
			}
			
			$last_control_id = $direct_id_arr[count($direct_id_arr) - 1];
			if(!$check_list){
				//going to a search screen, remove the last direct_id to avoid saving it as direct access
				array_pop($direct_id_arr);
			}
			$result_structure = null;
			$browsing = null;
			
			//direct access, save nodes
			foreach($direct_id_arr as $control_id){
				$browsing = $this->DatamartStructure->find('first', array('conditions' => array('id' => $control_id)));
				$result_structure = $this->Structures->getFormById($browsing['DatamartStructure']['structure_id']);
				
				$model_to_import = $browsing['DatamartStructure']['plugin'].".".$browsing['DatamartStructure']['model'];
				if(!App::import('Model', $model_to_import)){
					$this->redirect( '/pages/err_model_import_failed?p[]='.$model_to_import, NULL, TRUE );
				}
				$this->ModelToSearch = new $browsing['DatamartStructure']['model'];
				$search_conditions = $this->Structures->parse_search_conditions($result_structure);
				$org_search_conditions['search_conditions'] = $search_conditions;
				$org_search_conditions['exact_search'] = isset($this->data['exact_search']);
				if($parent_node != 0){
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
					$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $parent['DatamartStructure']['id'], 'BrowsingControl.id2' => $browsing['DatamartStructure']['id'])));
					if(!empty($control_data)){
						//retreive the ids in the parent first
						$model_to_import = $parent['DatamartStructure']['plugin'].".".$parent['DatamartStructure']['model'];
						if(!App::import('Model', $model_to_import)){
							$this->redirect( '/pages/err_model_import_failed?p[]='.$model_to_import, NULL, TRUE );
						}
						$this->ParentModel = new $parent['DatamartStructure']['model'];
						$parent_data = $this->ParentModel->find('all', array('conditions' => array($parent['DatamartStructure']['model'].".".$parent['DatamartStructure']['use_key']." IN (".$parent['BrowsingResult']['id_csv'].")")));
						list($use_model, $use_field) = explode(".", $control_data['BrowsingControl']['use_field']);
						foreach($parent_data as $data_unit){
							$search_conditions[$browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']][] = $data_unit[$use_model][$use_field];
						}
					}else{
						//ids are already contained in the child
						$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing['DatamartStructure']['id'], 'BrowsingControl.id2' => $parent['DatamartStructure']['id'])));
						$search_conditions[] = $control_data['BrowsingControl']['use_field']." IN (".$parent['BrowsingResult']['id_csv'].")";
					}
				}
				$this->data = $this->ModelToSearch->find('all', array('conditions' => $search_conditions));
				
				$save_ids = array();
				foreach($this->data as $data_unit){
					$save_ids[] = $data_unit[$browsing['DatamartStructure']['model']][$browsing['DatamartStructure']['use_key']];
				}
				$save = array('BrowsingResult' => array(
					"user_id" => $_SESSION['Auth']['User']['id'],
					"parent_node_id" => $parent_node,
					"browsing_structures_id" => $control_id,
					"id_csv" => implode(",", $save_ids),
					"raw" => true,
					"serialized_search_params" => serialize($org_search_conditions),
				));
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
				
				if(count($save_ids) == 0){
					//we have an empty set, bail out!
					$last_control_id = $control_id;
					$this->BrowsingIndex->validationErrors[] = __("you cannot browse to the requested entities because some intermediary elements do not exist", true);
					break;	
				}
			}
			
			//all nodes saved, now load the proper form
			if($check_list){
				//checkboxes
				$parent_node = $save['BrowsingResult']['id'];
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($last_control_id, $parent_node, $browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], $browsing['DatamartStructure']['use_key'], $browsing['DatamartStructure']['structure_id']));
				$this->set('checklist_key', $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']);
				$this->set('type', "checklist");
				$this->Structures->set("datamart_browser_start");
				$this->set("result_structure", $result_structure);
				$this->set('top', "/datamart/browser/browse/".$save['BrowsingResult']['id']."/");
				$this->set('parent_node', $parent_node);
			}else{
				//search screen
				$this->set('type', "search");
				$browsing = $this->DatamartStructure->find('first', array('conditions' => array('id' => $last_control_id)));
				$this->set("atim_structure", $this->Structures->getFormById($browsing['DatamartStructure']['structure_id'])); 
				$this->set('top', "/datamart/browser/browse/".$parent_node."/".$last_control_id."/");
				$this->set('parent_node', $parent_node);
			}
		}
	}
	
	function createBatchSet($node_id){
		$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $node_id)));
		$structure = $this->Structures->getFormById($browsing_result['DatamartStructure']['structure_id']);
		$batch_set = array("BatchSet" => array(
			"user_id" => $_SESSION['Auth']['User']['id'],
			"plugin" => $browsing_result['DatamartStructure']['plugin'],
			"model" => $browsing_result['DatamartStructure']['model'],
			"lookup_key_name" => $browsing_result['DatamartStructure']['use_key'],
			"form_alias_for_results" => $structure['Structure']['id'],
			"flag_use_query_results" => false
		));
		$this->BatchSet->save($batch_set);
		
		foreach($this->data[$browsing_result['DatamartStructure']['model']][$browsing_result['DatamartStructure']['use_key']] as $id){
			if($id != 0){
				$batch_id = array("BatchId" => array(
					"set_id" => $this->BatchSet->id,
					"lookup_id" => $id 
				));
				$this->BatchId->id = null;
				$this->BatchId->save($batch_id);
			}
		}
		$this->redirect("/datamart/batch_sets/listall/all/".$this->BatchSet->id, NULL, true);
	}
}