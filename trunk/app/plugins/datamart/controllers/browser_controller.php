<?php
class BrowserController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.Browser',
		'Datamart.BrowsingStructure',
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
			$this->flash('your data has been updated', "/datamart/browser/index");
		}
	}
	
	function delete($index_id){
		$this->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'])));
		if(!empty($this->data)){
			$this->BrowsingIndex->atim_delete($index_id);
			$this->flash( 'your data has been deleted', '/datamart/browser/index/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/datamart/browser/index/');
		}
	}
	
		
	function browse($parent_node = 0, $control_id = 0){
		if(empty($this->data)){
			if($parent_node == 0){
				//new access
				$this->Structures->set("datamart_browser_start");
				$this->set('type', "add");
				$this->set('top', "/datamart/browser/browse/");
			}else{
				//direct node access
				$this->set('parent_node', $parent_node);
				$browsing = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
				$model_to_import = $browsing['BrowsingStructure']['plugin'].".".$browsing['BrowsingStructure']['model'];
				if(!App::import('Model', $model_to_import)){
	//				$this->flash("An error occured", "/datamart/browser/browse/");
					die("import of [".$model_to_import."] failed");
				}
				global $getDropdownOptions;
				$getDropdownOptions[] = $browsing['BrowsingStructure']['id'];
				$this->ModelToSearch = new $browsing['BrowsingStructure']['model'];
				$this->data = strlen($browsing['BrowsingResult']['id_csv']) > 0 ? $this->ModelToSearch->find('all', array('conditions' => $browsing['BrowsingStructure']['model'].".".$browsing['BrowsingStructure']['use_key']." IN (".$browsing['BrowsingResult']['id_csv'].")")) : array();
				$this->Structures->set($browsing['BrowsingStructure']['structure_alias']);
				$this->set('top', "/datamart/browser/browse/".$parent_node."/"); 
				$this->set('type', "checklist");
				$this->set('checklist_key', $browsing['BrowsingStructure']['model'].".".$browsing['BrowsingStructure']['use_key']);
				$result_structure = $this->Structures->get('form', $browsing['BrowsingStructure']['structure_alias']);
				$this->Structures->set("datamart_browser_start");
				$this->set("result_structure", $result_structure);
			}
		}else if(isset($this->data['Browser']['search_for'])){
			//display search form
			$node_for_url = $parent_node;
			$browsing = $this->BrowsingStructure->find('first', array('conditions' => array('id' => $this->data['Browser']['search_for'])));
			$this->set('type', "search");
			$this->Structures->set($browsing['BrowsingStructure']['structure_alias']);
			
			//save subset
			if(isset($this->data['model'])){
				
				$ids = array();
				foreach($this->data['model']['id'] as $id){
					if($id != 0){
						$ids[] = $id;
					}
				}
				$id_csv = implode(",", $ids);
				$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
				if(!$parent['BrowsingResult']['raw']){
					//the parent is a drilldown, seek the next parent
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent['BrowsingResult']['parent_node_id'])));
					$parent_node = $parent['BrowsingResult']['id'];
				}

				$save['BrowsingResult'] = array(
					"user_id" => $_SESSION['Auth']['User']['id'],
					"parent_node_id" => $parent_node,
					"browsing_structures_id" => $parent['BrowsingResult']['browsing_structures_id'],
					"id_csv" => $id_csv,
					"raw" => false
				);
				
				$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
				if(empty($tmp)){
					//current set does not exists, check for parent
					if($parent['BrowsingResult']['id_csv'] != $id_csv){
						//no identical parent exists, save!
						unset($this->BrowsingResult->id);
						$this->BrowsingResult->save($save);
						$node_for_url = $this->BrowsingResult->id;
					}
				}else{
					$node_for_url = $tmp['BrowsingResult']['id'];
				}
			}
			$this->set('top', "/datamart/browser/browse/".$node_for_url."/".$this->data['Browser']['search_for']."/");
			$this->set('parent_node', $node_for_url);
		}else if($control_id != 0){
			//display checklist
			global $getDropdownOptions;
			$getDropdownOptions[] = $control_id;
			$browsing = $this->BrowsingStructure->find('first', array('conditions' => array('id' => $control_id)));
			$this->set('checklist_key', $browsing['BrowsingStructure']['model'].".".$browsing['BrowsingStructure']['use_key']);
			
			$this->set('type', "checklist");
			
			$result_structure = $this->Structures->get('form', $browsing['BrowsingStructure']['structure_alias']);
			$this->Structures->set("datamart_browser_start");
			$this->set("result_structure", $result_structure);
			
			$model_to_import = $browsing['BrowsingStructure']['plugin'].".".$browsing['BrowsingStructure']['model'];
			if(!App::import('Model', $model_to_import)){
//				$this->flash("An error occured", "/datamart/browser/browse/");
				die("import of [".$model_to_import."] failed");
			}
			$this->ModelToSearch = new $browsing['BrowsingStructure']['model'];
			$search_conditions = $this->Structures->parse_search_conditions($result_structure);
			$org_search_conditions = $search_conditions;
			if($parent_node != 0){
				$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent_node)));
				$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $parent['BrowsingStructure']['id'], 'BrowsingControl.id2' => $browsing['BrowsingStructure']['id'])));
				if(!empty($control_data)){
					//retreive the ids in the parent first
					$model_to_import = $parent['BrowsingStructure']['plugin'].".".$parent['BrowsingStructure']['model'];
					if(!App::import('Model', $model_to_import)){
		//				$this->flash("An error occured", "/datamart/browser/browse/");
						die("import of [".$model_to_import."] failed");
					}
					$this->ParentModel = new $parent['BrowsingStructure']['model'];
					$parent_data = $this->ParentModel->find('all', array('conditions' => array($parent['BrowsingStructure']['model'].".".$parent['BrowsingStructure']['use_key']." IN (".$parent['BrowsingResult']['id_csv'].")")));
					list($use_model, $use_field) = explode(".", $control_data['BrowsingControl']['use_field']);
					foreach($parent_data as $data_unit){
						$search_conditions[$browsing['BrowsingStructure']['model'].".".$browsing['BrowsingStructure']['use_key']][] = $data_unit[$use_model][$use_field];
					}
				}else{
					//ids are already contained in the child
					$control_data = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $browsing['BrowsingStructure']['id'], 'BrowsingControl.id2' => $parent['BrowsingStructure']['id'])));
					$search_conditions[] = $control_data['BrowsingControl']['use_field']." IN (".$parent['BrowsingResult']['id_csv'].")";
				}
			}
			$this->data = $this->ModelToSearch->find('all', array('conditions' => $search_conditions));
			$save_ids = array();
			foreach($this->data as $data_unit){
				$save_ids[] = $data_unit[$browsing['BrowsingStructure']['model']][$browsing['BrowsingStructure']['use_key']];
			}
			$save['BrowsingResult'] = array(
				"user_id" => $_SESSION['Auth']['User']['id'],
				"parent_node_id" => $parent_node,
				"browsing_structures_id" => $control_id,
				"id_csv" => implode(",", $save_ids),
				"raw" => true,
				"serialized_search_params" => serialize($org_search_conditions)
			);
			$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
			if(empty($tmp)){
				//save fullset
				$save = $this->BrowsingResult->save($save);
				$save['BrowsingResult']['id'] = $this->BrowsingResult->id;
				if($parent_node == 0){
					//save into index as well
					$this->BrowsingIndex->save(array("BrowsingIndex" => array("root_node_id" => $save['BrowsingResult']['id'])));	
				}
			}else{
				$save = $tmp;
			}
			$this->set('top', "/datamart/browser/browse/".$save['BrowsingResult']['id']."/");
			$this->set('parent_node', $save['BrowsingResult']['id']);
		}else{
			$this->flash("An error occured", "/datamart/browser/browse/");
		}
	}
	
	function createBatchSet($node_id){
		$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $node_id)));
		$batch_set = array("BatchSet" => array(
			"user_id" => $_SESSION['Auth']['User']['id'],
			"plugin" => $browsing_result['BrowsingStructure']['plugin'],
			"model" => $browsing_result['BrowsingStructure']['model'],
			"lookup_key_name" => $browsing_result['BrowsingStructure']['use_key'],
			"form_alias_for_results" => $browsing_result['BrowsingStructure']['structure_alias'],
			"flag_use_query_results" => false
		));
		$this->BatchSet->save($batch_set);
		foreach($this->data['model']['id'] as $id){
			if($id != 0){
				$batch_id = array("BatchId" => array(
					"set_id" => $this->BatchSet->id,
					"lookup_id" => $id 
				));
				unset($this->BatchId->id);
				$this->BatchId->save($batch_id);
			}
		}
		$this->redirect("/datamart/batch_sets/listall/all/".$this->BatchSet->id, NULL, true);
	}
}