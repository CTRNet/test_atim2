<?php
class BrowserController extends DatamartAppController {
	
	static protected $tmp_browsing_limit = 5;
	
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
		$tmp_browsing = $this->BrowsingIndex->find('all', array(
			'conditions' => array("BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'], 'BrowsingIndex.temporary' => true),
			'order'	=> array('BrowsingResult.created DESC'))
		);
		
		while(count($tmp_browsing) > self::$tmp_browsing_limit){
			$unit = array_pop($tmp_browsing);
			$this->BrowsingIndex->atim_delete($unit['BrowsingIndex']['id']);
		}
		
		$this->set('tmp_browsing', $tmp_browsing);
		
		$this->data = $this->paginate($this->BrowsingIndex, 
			array("BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'], 'BrowsingIndex.temporary' => false));
	}
	
	function edit($index_id){
		$this->set("index_id", $index_id);
		$this->Structures->set("datamart_browsing_indexes");
		if(empty($this->data)){
			$this->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'])));
			if($this->data['BrowsingIndex']['temporary']){
				AppController::addWarningMsg(__('adding notes to a temporary browsing automatically moves it towards the saved browsing list', true));
			}
		}else{
			$this->BrowsingIndex->id = $index_id;
			unset($this->data['BrowsingIndex']['created']);
			$this->data['BrowsingIndex']['temporary'] = false;
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
		$this->set('control_id', $control_id);
		$this->set('merge_to', $merge_to);
		if(empty($this->data)){
			if($node_id == 0){
				//new access
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($control_id, $node_id, null, null, null, null, null, array("AliquotControl" => array(0))));
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
				$ids = array_unique($ids);
				sort($ids);
				$id_csv = implode(",",  $ids);
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
				if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
					$this->flash(__("You are not authorized to access that location.", true), 'javascript:history.back()');
					return;
				}
				
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
				
				$this->ModelToSearch = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $model_to_import, true);
				$search_conditions = $this->Structures->parseSearchConditions($result_structure);
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
						$this->ParentModel = AppModel::getInstance($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['model'], true);
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
							$this->MainModel = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
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
				sort($save_ids);
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
			$result = $this->Browser->initDataLoad($browsing, $merge_to, explode(",", $browsing['BrowsingResult']['id_csv']));
			
			if(!$this->Browser->valid_permission){
				$this->flash(__("You are not authorized to access that location.", true), 'javascript:history.back()');
			}
			
			$this->set('top', "/datamart/browser/browse/".$node_id."/");
			$this->set('node_id', $node_id);
			$this->set('type', "checklist");
			$this->set('checklist_key', $this->Browser->checklist_model->name.".".$this->Browser->checklist_use_key);
			$this->set('checklist_key_name', $browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key']);
			
			$dropdown_options = $this->Browser->getDropdownOptions(
				$browsing['DatamartStructure']['id'], 
				$node_id, 
				$browsing['DatamartStructure']['plugin'], 
				$this->Browser->checklist_model->name,
				$browsing['DatamartStructure']['model'],
				$this->Browser->checklist_use_key,
				$browsing['DatamartStructure']['use_key'], 
				$this->Browser->checklist_sub_models_id_filter
			);
			foreach($dropdown_options as $key => $option){
				if(isset($option['action']) && strpos($option['action'], 'datamart/csv/csv') === 0){
					unset($dropdown_options[$key]);
				}
			}
			$action = 'datamart/browser/csv/%d/'.$node_id."/".$merge_to."/";
			$dropdown_options[] = array(
				'value' => '0',
				'default' => __('export as CSV file (comma-separated values)', true),
				'action' => sprintf($action, 0)
			);
			$dropdown_options[] = array(
				'value' => '0',
				'default' => __('full export as CSV file', true),
				'action' => sprintf($action, 1)
			);
			
			$this->set("dropdown_options", $dropdown_options);
			$this->Structures->set("datamart_browser_start");
			
			if($this->Browser->checklist_model->name != $browsing['DatamartStructure']['model']){
				$browsing['DatamartStructure']['index_link'] = str_replace(
					$browsing['DatamartStructure']['model'], 
					$this->Browser->checklist_model->name,
					str_replace(
						$browsing['DatamartStructure']['model'].".".$browsing['DatamartStructure']['use_key'], 
						$this->Browser->checklist_model->name.".".$this->Browser->checklist_use_key, 
						$browsing['DatamartStructure']['index_link']
					)
				);
			}
			$this->set('index', $browsing['DatamartStructure']['index_link']);
			if($this->Browser->count <= self::$display_limit){
				$this->set("result_structure", $this->Browser->result_structure);
				$this->data = $this->Browser->getDataChunk(self::$display_limit);
				$this->set("header", array('title' => __('result', true), 'description' => $this->Browser->checklist_header));
				if(is_array($this->data)){
					//sort this->data on URL
					$this->data = AppModel::sortWithUrl($this->data, $this->passedArgs);
				}
			}else{
				//overflow
				$this->data = $browsing['BrowsingResult']['id_csv'];
			}
			$this->set('merged_ids', $this->Browser->merged_ids);
			$this->set('unused_parent', $browsing['BrowsingResult']['parent_node_id'] && $browsing['BrowsingResult']['raw']);

		}else if($browsing != null){
			if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
				$this->flash(__("You are not authorized to access that location.", true), 'javascript:history.back()');
			}
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
	function csv($all_fields, $node_id, $merge_to){
		$browsing = $this->BrowsingResult->findById($node_id);
		$ids = current(current($this->data));
		if(is_string($ids)){
			$ids = explode(",", $ids);
		}
		$this->Browser->InitDataLoad($browsing, $merge_to, $ids);
		
		if(!$this->Browser->valid_permission){
			$this->flash(__("You are not authorized to access that location.", true), 'javascript:history.back()');
			return;
		}
		
		$this->set("result_structure", $this->Browser->result_structure);
		$this->layout = false;
		
		
		Configure::write('debug', 0);
		$this->set('csv_header', true);
		$this->set('all_fields', $all_fields);
		while($this->data = $this->Browser->getDataChunk(300)){
			$this->render('../csv/csv');
			$this->set('csv_header', false);
		}
		
		$this->render(false);
	}
	
		
	/**
	 * If the model is found, creates a batchset based based on it and displays the first node. The ids must be in
	 * $this->data[$model][id]
	 * @param String $model
	 */
	function batchToDatabrowser($model){
		$dm_structure = $this->DatamartStructure->find('first', array(
			'conditions' => array('OR' => array('DatamartStructure.model' => $model, 'DatamartStructure.control_master_model' => $model)),
			'recursive' => -1)
		);
		
		if($dm_structure == null){
			$this->redirect( '/pages/err_internal?p[]=model+not+found', NULL, TRUE );
		}
		
		$ids = array();
		if(array_key_exists($dm_structure['DatamartStructure']['model'], $this->data)){
			$ids = $this->data[$dm_structure['DatamartStructure']['model']][$dm_structure['DatamartStructure']['use_key']];
		}else if(array_key_exists($dm_structure['DatamartStructure']['control_master_model'], $this->data)){
			$ids = $this->data[$dm_structure['DatamartStructure']['control_master_model']]['id'];
		}else{
			$this->redirect( '/pages/err_internal?p[]=invalid+data', NULL, TRUE );
		}
		
		$ids = array_filter($ids);

		if(empty($ids)){
			$this->redirect( '/pages/err_internal?p[]=no+ids', NULL, TRUE );
		}
		
		sort($ids);
		
		$save = array('BrowsingResult' => array(
			"user_id" => $_SESSION['Auth']['User']['id'],
			"parent_node_id" => 0,
			"browsing_structures_id" => $dm_structure['DatamartStructure']['id'],
			"browsing_structures_sub_id" => 0,
			"id_csv" => implode(",", $ids),
			"raw" => true
		));
		
		$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
		$node_id = null;
		if(empty($tmp)){
			$this->BrowsingResult->save($save);
			$node_id = $this->BrowsingResult->id;
			$this->BrowsingIndex->save(array("BrowsingIndex" => array('root_node_id' => $node_id)));
		}else{
			//current set already exists, use it
			$node_id = $tmp['BrowsingResult']['id'];
		}
		
		$this->data = array();
		$this->browse($node_id);
	}
	
	function save($index_id){
		$this->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $_SESSION['Auth']['User']['id'])));
		if(empty($this->data)){
			$this->redirect( '/pages/err_internal?p[]=invalid+data', NULL, TRUE );
		}else{
			$this->data['BrowsingIndex']['temporary'] = false;
			$this->BrowsingIndex->save($this->data);
			$this->atimFlash('your data has been updated', "/datamart/browser/index");
		}
	}
	
	/**
	 * Creates a drilldown of the parent node based on the non matched parent
	 * row of the current set. Echoes the new node id, if any.
	 * @param int $node_id
	 */
	function unusedParent($node_id){
		Configure::write('debug', 0);
		$child_data = $this->BrowsingResult->findById($node_id);
		if(!$child_data['BrowsingResult']['parent_node_id']){
			echo json_encode(array('redirect' => '/pages/err_internal?p[]=no+parent', 'msg' => ''));
		}
		$parent_data = $this->BrowsingResult->findById($child_data['BrowsingResult']['parent_node_id']);
		$control = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id1' => $child_data['DatamartStructure']['id'], 'BrowsingControl.id2' => $parent_data['DatamartStructure']['id'])));
		$parent_key_used_data = null;
		if(empty($control)){
			$control = $this->BrowsingControl->find('first', array('conditions' => array('BrowsingControl.id2' => $child_data['DatamartStructure']['id'], 'BrowsingControl.id1' => $parent_data['DatamartStructure']['id'])));
			assert(!empty($control));
			
			//load the child model
			$datamart_structure = $this->DatamartStructure->findById($control['BrowsingControl']['id1']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			$parent_model = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
			
			//fetch the used parent keys
			$parent_key_used_data = $parent_model->find('all', array(
				'fields' => array($parent_model->name.'.'.$datamart_structure['use_key']),
				'conditions' => array($control['BrowsingControl']['use_field'] => explode(',', $child_data['BrowsingResult']['id_csv']))
			));

		}else{
			//load the child model
			$datamart_structure = $this->DatamartStructure->findById($control['BrowsingControl']['id1']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			$child_model = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
			
			//fetch the used parent keys
			$parent_key_used_data = $child_model->find('all', array(
				'fields' => array($control['BrowsingControl']['use_field']),
				'conditions' => array($child_model->name.'.'.$datamart_structure['use_key'] => explode(',', $child_data['BrowsingResult']['id_csv'])) 
			));
		}
		
		$parent_key_used = array();
		foreach($parent_key_used_data as $data){
			$parent_key_used[] = current(current($data));
		}
		$parent_key_used = array_unique($parent_key_used);
		sort($parent_key_used);
		$parent_key_used = array_diff(explode(',', $parent_data['BrowsingResult']['id_csv']), $parent_key_used);
		$id_csv = implode(",",  $parent_key_used);
		
		//build the save array
		$parent_node_id = null;
		$browsing_result = $this->BrowsingResult->findById($child_data['BrowsingResult']['parent_node_id']);
		if($browsing_result['BrowsingResult']['raw']){
			$parent_node_id = $child_data['BrowsingResult']['parent_node_id'];
		}else{
			$parent_node_id = $browsing_result['BrowsingResult']['parent_node_id'];
		}
		$save = array('BrowsingResult' => array(
			"user_id" => $_SESSION['Auth']['User']['id'],
			"parent_node_id" => $parent_node_id,
			"browsing_structures_id" => $parent_data['DatamartStructure']['id'],
			"browsing_structures_sub_id" => $parent_data['BrowsingResult']['browsing_structures_sub_id'],
			"id_csv" => $id_csv,
			"raw" => false
		));

		$return_id = null;
		if(!empty($save['BrowsingResult']['id_csv'])){
			$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
			if(!empty($tmp)){
				//current set already exists, use it
				$return_id = $tmp['BrowsingResult']['id'];
			}else{
				$this->BrowsingResult->id = null;
				if(!$this->BrowsingResult->save($save)){
					$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$return_id = $this->BrowsingResult->id;
			}
		}
		
		if($return_id){
			$this->redirect('/datamart/browser/browse/'.$return_id);
		}else{
			AppController::addWarningMsg(__('there are no unused parent items', true));
			$this->redirect('/datamart/browser/browse/'.$node_id);
		}
		exit;
	}
}