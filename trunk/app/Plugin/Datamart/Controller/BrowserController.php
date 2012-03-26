<?php
class BrowserController extends DatamartAppController {
	
	static $tmp_browsing_limit = 5;
	
	var $uses = array(
		'Datamart.Adhoc',
		'Datamart.Browser',
		'Datamart.DatamartStructure',
		'Datamart.BrowsingResult',
		'Datamart.BrowsingControl',
		'Datamart.BrowsingIndex',
		'Datamart.BatchSet',
		'Datamart.SavedBrowsingIndex'
	);
		
	function index(){
		$this->Structures->set("datamart_browsing_indexes");
		$tmp_browsing = $this->BrowsingIndex->find('all', array(
			'conditions' => array("BrowsingResult.user_id" => $this->Session->read('Auth.User.id'), 'BrowsingIndex.temporary' => true),
			'order'	=> array('BrowsingResult.created DESC'))
		);
		
		while(count($tmp_browsing) > self::$tmp_browsing_limit){
			$unit = array_pop($tmp_browsing);
			$this->BrowsingIndex->atimDelete($unit['BrowsingIndex']['id']);
		}
		
		$this->set('tmp_browsing', $tmp_browsing);
		
		$this->request->data = $this->paginate($this->BrowsingIndex, 
			array("BrowsingResult.user_id" => $this->Session->read('Auth.User.id'), 'BrowsingIndex.temporary' => false));
	}
	
	function edit($index_id){
		$this->set("index_id", $index_id);
		$this->Structures->set("datamart_browsing_indexes");
		if(empty($this->request->data)){
			$this->request->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'))));
			if($this->request->data['BrowsingIndex']['temporary']){
				AppController::addWarningMsg(__('adding notes to a temporary browsing automatically moves it towards the saved browsing list'));
			}
		}else{
			$this->BrowsingIndex->id = $index_id;
			unset($this->request->data['BrowsingIndex']['created']);
			$this->request->data['BrowsingIndex']['temporary'] = false;
			$this->BrowsingIndex->save($this->request->data);
			$this->atimFlash('your data has been updated', "/Datamart/Browser/index");
		}
	}
	
	function delete($index_id){
		$this->request->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'))));
		if(!empty($this->request->data)){
			$this->BrowsingIndex->atimDelete($index_id);
			$this->BrowsingResult->atimDelete($this->request->data['BrowsingIndex']['root_node_id']);
			$this->atimFlash( 'your data has been deleted', '/Datamart/Browser/index/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/Datamart/Browser/index/');
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
		$this->BrowsingResult->check_writable_fields = false;
		$this->BrowsingIndex->check_writable_fields = false;
		$this->Structures->set("empty", "empty");
		$browsing = null;
		$check_list = false;
		$last_control_id = 0;
		$this->set('control_id', $control_id);
		$this->set('merge_to', $merge_to);
		if(empty($this->request->data)){
			if($node_id == 0){
				//new access
				$this->set("dropdown_options", $this->Browser->getDropdownOptions($control_id, $node_id, null, null, null, null, null, array("AliquotControl" => array(0))));
				$this->Structures->set("empty");
				$this->set('type', "add");
				$this->set('top', "/Datamart/Browser/browse/0/");
			}else{
				//direct node access
				$this->set('node_id', $node_id);
				$browsing = $this->BrowsingResult->getOrRedirect($node_id);
				if($browsing['BrowsingResult']['user_id'] != CakeSession::read('Auth.User.id')){
					$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
				}
				$check_list = true;
			}
		}else{
			// ->browsing access<- (search form or checklist)
			if(isset($this->request->data['Browser']['search_for'])){
				//search_for is taken from the dropdown
				if(strpos($this->request->data['Browser']['search_for'], "/") > 0){
					list($control_id, $check_list) = explode("/", $this->request->data['Browser']['search_for']);
				}else{ 
					$control_id = $this->request->data['Browser']['search_for'];
					$check_list = false;
				}
			}else if($control_id == 0){
				//error, the control_id should't be 0
				$this->redirect( '/Pages/err_internal?p[]=control_id', NULL, TRUE );
			}else{
				$check_list = true;
			}
			$this->Browser;//trigger lazy load
			$sub_structure_id = null;//control id for master/detail
			if(strpos($control_id, Browser::$sub_model_separator_str) !== false){
				list($control_id , $sub_structure_id) = explode(Browser::$sub_model_separator_str, $control_id);
			}
			//direct access array (if the user goes from 1 to 4 by going throuhg 2 and 3, the direct access are 2 and 3
			$direct_id_arr = explode(Browser::$model_separator_str, $control_id);

			$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $node_id)));
			if(isset($this->request->data[$parent['DatamartStructure']['model']]) && isset($this->request->data['Browser'])){
				$parent_model = AppModel::getInstance($parent['DatamartStructure']['plugin'], $parent['DatamartStructure']['model'], true);
				//save selected subset if parent model found and from a checklist 
				$ids = array();
				if(count($this->request->data[$parent['DatamartStructure']['model']][$parent_model->primaryKey]) == 1 
					&& strpos($this->request->data[$parent['DatamartStructure']['model']][$parent_model->primaryKey], ",") !== false
				){
					//all ids in one field
					$ids = explode(",", $this->request->data[$parent['DatamartStructure']['model']][$parent_model->primaryKey]);
				}else{
					//ids in n fields
					foreach($this->request->data[$parent['DatamartStructure']['model']][$parent_model->primaryKey] as $id){
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
					$parent = $this->BrowsingResult->find('first', array('conditions' => array("BrowsingResult.id" => $parent['BrowsingResult']['parent_id'])));
					$node_id = $parent['BrowsingResult']['id'];
				}

				$save = array('BrowsingResult' => array(
					"user_id"						=> $this->Session->read('Auth.User.id'),
					"parent_id"						=> $node_id,
					"browsing_structures_id"		=> $parent['BrowsingResult']['browsing_structures_id'],
					"browsing_structures_sub_id"	=> $parent['BrowsingResult']['browsing_structures_sub_id'],
					"id_csv"						=> $id_csv,
					'raw'							=> 0,
					"browsing_type"					=> 'drilldown'
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
			
			$created_node = null;
			//save nodes (direct and indirect)
			foreach($direct_id_arr as $control_id){
				$sub_struct_ctrl_id = null;
				if(isset($sub_structure_id)//there is a sub id
					&& $direct_id_arr[count($direct_id_arr) - 1] == $control_id//this is the last element
					&& $check_list//this is a checklist
				){
					$sub_struct_ctrl_id = $sub_structure_id;
				}
				
				$params = array(
					'struct_ctrl_id'		=> $control_id,
					'sub_struct_ctrl_id'	=> $sub_struct_ctrl_id,
					'node_id'				=> $node_id,
					'last'					=> $last_control_id == $control_id
				);
				if(!$created_node = $this->Browser->createNode($params)){
					//something went wrong. A flash screen has been called.
					return;
				}
				
				$node_id = $created_node['browsing']['BrowsingResult']['id'];
			}
			
			if($created_node){
				$result_structure = $created_node['result_struct'];
				$browsing = $created_node['browsing'];
				unset($created_node);
			}
			
			//all nodes saved, now load the proper form
			if($check_list){
				$node_id = $browsing['BrowsingResult']['id'];
			}else{
				//search screen
				$browsing = $this->DatamartStructure->find('first', array('conditions' => array('id' => $last_control_id)));
			}
			 
		}
		
		//handle display data
		$render = 'browse_checklist';
		if($check_list){
			$result = $this->Browser->initDataLoad($browsing, $merge_to, explode(",", $browsing['BrowsingResult']['id_csv']));
			
			if(!$this->Browser->valid_permission){
				$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
			}
			
			$browsing_model = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
			
			$this->set('top', "/Datamart/Browser/browse/".$node_id."/");
			$this->set('node_id', $node_id);
			$this->set('type', "checklist");
			$this->set('checklist_key', $this->Browser->checklist_model->name.".".$this->Browser->checklist_use_key);
			$this->set('checklist_key_name', $browsing['DatamartStructure']['model'].".".$browsing_model->primaryKey);
			$this->set('is_root', $browsing['BrowsingResult']['parent_id'] == 0);
			
			$dropdown_options = $this->Browser->getDropdownOptions(
				$browsing['DatamartStructure']['id'], 
				$node_id, 
				$browsing['DatamartStructure']['plugin'], 
				$this->Browser->checklist_model->name,
				$browsing['DatamartStructure']['model'],
				$this->Browser->checklist_use_key,
				$browsing_model->primaryKey, 
				$this->Browser->checklist_sub_models_id_filter
			);
			foreach($dropdown_options as $key => $option){
				if(isset($option['value']) && strpos($option['value'], 'Datamart/csv/csv') === 0){
					unset($dropdown_options[$key]);
				}
			}
			$action = 'Datamart/Browser/csv/%d/'.$node_id."/".$merge_to."/";
			$dropdown_options[] = array(
				'value' => '0',
				'label' => __('export as CSV file (comma-separated values)'),
				'value' => sprintf($action, 0)
			);
			$dropdown_options[] = array(
				'value' => '0',
				'label' => __('full export as CSV file'),
				'value' => sprintf($action, 1)
			);
			
			$this->set("dropdown_options", $dropdown_options);
			$this->Structures->set("empty");
			
			if($this->Browser->checklist_model->name != $browsing['DatamartStructure']['model']){
				$browsing['DatamartStructure']['index_link'] = str_replace(
					$browsing['DatamartStructure']['model'], 
					$this->Browser->checklist_model->name,
					str_replace(
						$browsing['DatamartStructure']['model'].".".$browsing_model->primaryKey, 
						$this->Browser->checklist_model->name.".".$this->Browser->checklist_use_key, 
						$browsing['DatamartStructure']['index_link']
					)
				);
			}
			$this->set('index', $browsing['DatamartStructure']['index_link']);
			if($this->Browser->count <= self::$display_limit){
				$this->set("result_structure", $this->Browser->result_structure);
				$this->request->data = $this->Browser->getDataChunk(self::$display_limit);
				$this->set("header", array('title' => __('result'), 'description' => $this->Browser->checklist_header));
				if(is_array($this->request->data)){
					//sort this->data on URL
					$this->request->data = AppModel::sortWithUrl($this->request->data, $this->passedArgs);
				}
			}else{
				//overflow
				$this->request->data = $browsing['BrowsingResult']['id_csv'];
			}
			$this->set('merged_ids', $this->Browser->merged_ids);
			$this->set('unused_parent', $browsing['BrowsingResult']['parent_id'] && $browsing['BrowsingResult']['raw']);
			
			$saved_browsing_index = $this->SavedBrowsingIndex->find('all', array('conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array('SavedBrowsingIndex.starting_datamart_structure_id' => $browsing['DatamartStructure']['id'])), 'order' => 'SavedBrowsingIndex.name'));
			$this->set('saved_browsing_index', $saved_browsing_index);

		}else if($browsing != null){
			if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
				$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
			}
			//search screen
			$tmp_model = AppModel::getInstance($browsing['DatamartStructure']['plugin'], $browsing['DatamartStructure']['model'], true);
			if(isset($sub_structure_id) && $ctrl_name = $tmp_model->getControlName()){
				$alternate_info = Browser::getAlternateStructureInfo($browsing['DatamartStructure']['plugin'], $ctrl_name, $sub_structure_id);
				$alternate_alias = $alternate_info['form_alias'];
				
				//get the structure and remove fields from the control table
				$structure = $this->Structures->get('form', $alternate_alias);
				foreach($structure['Sfs'] as $key => $field){
						if($field['model'] == $ctrl_name){
							unset($structure['Sfs'][$key]);
						}
				}
				$this->set('atim_structure', $structure);
				
				$last_control_id .= "-".$sub_structure_id;
				$this->set("header", array("title" => __("search"), "description" => __($browsing['DatamartStructure']['display_name'])." > ".Browser::getTranslatedDatabrowserLabel($alternate_info['databrowser_label'])));
			}else{
				$this->set("atim_structure", $this->Structures->getFormById($browsing['DatamartStructure']['structure_id'])); 
				$this->set("header", array("title" => __("search"), "description" => __($browsing['DatamartStructure']['display_name'])));
			}
			$this->set('top', "/Datamart/Browser/browse/".$node_id."/".$last_control_id."/");
			$this->set('node_id', $node_id);
			if($browsing['DatamartStructure']['adv_search_structure_alias']){
				Browser::$cache['current_node_id'] = $node_id;
				$advanced_structure = $this->Structures->get('form', $browsing['DatamartStructure']['adv_search_structure_alias']);
				$this->set('advanced_structure', $advanced_structure);
			}
			$render = 'browse_search';
		}
		$this->render($render);
	}
	
	/**
	 * Used to generate the databrowser csv
	 * @param int $parent_id
	 * @param int $merge_to
	 */
	function csv($all_fields, $node_id, $merge_to){
		$browsing = $this->BrowsingResult->findById($node_id);
		$ids = current(current($this->request->data));
		if(is_string($ids)){
			$ids = explode(",", $ids);
		}
		$this->Browser->InitDataLoad($browsing, $merge_to, $ids);
		
		if(!$this->Browser->valid_permission){
			$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
			return;
		}
		
		$this->set("result_structure", $this->Browser->result_structure);
		$this->layout = false;
		
		
		Configure::write('debug', 0);
		$this->set('csv_header', true);
		$this->set('all_fields', $all_fields);
		while($this->request->data = $this->Browser->getDataChunk(300)){
			$this->render('../csv/csv');
			$this->set('csv_header', false);
		}
		
		$this->render(false);
	}
	
		
	/**
	 * If the model is found, creates a batchset based based on it and displays the first node. The ids must be in
	 * $this->request->data[$model][id]
	 * @param String $model
	 */
	function batchToDatabrowser($model){
		$dm_structure = $this->DatamartStructure->find('first', array(
			'conditions' => array('OR' => array('DatamartStructure.model' => $model, 'DatamartStructure.control_master_model' => $model)),
			'recursive' => -1)
		);
		
		if($dm_structure == null){
			$this->redirect( '/Pages/err_internal?p[]=model+not+found', NULL, TRUE );
		}
		
		$model = null;
		if(array_key_exists($dm_structure['DatamartStructure']['model'], $this->request->data)){
			$model = AppModel::getInstance($dm_structure['DatamartStructure']['plugin'], $dm_structure['DatamartStructure']['model'], true);
		}else if(array_key_exists($dm_structure['DatamartStructure']['control_master_model'], $this->request->data)){
			$model = AppModel::getInstance($dm_structure['DatamartStructure']['plugin'], $dm_structure['DatamartStructure']['control_master_model'], true);
		}else{
			$this->redirect( '/Pages/err_internal?p[]=invalid+data', NULL, TRUE );
		}
		$ids = $this->request->data[$model->name][$model->primaryKey];
		$ids = array_filter($ids);

		if(empty($ids)){
			$this->redirect( '/Pages/err_internal?p[]=no+ids', NULL, TRUE );
		}
		
		sort($ids);
		
		$save = array('BrowsingResult' => array(
			"user_id"						=> $this->Session->read('Auth.User.id'),
			"parent_id"						=> 0,
			"browsing_structures_id"		=> $dm_structure['DatamartStructure']['id'],
			"browsing_structures_sub_id"	=> 0,
			"id_csv"						=> implode(",", $ids),
			'raw'							=> 1,
			"browsing_type"					=> 'search'
		));
		
		$tmp = $this->BrowsingResult->find('first', array('conditions' => $this->flattenArray($save)));
		$node_id = null;
		if(empty($tmp)){
			$this->BrowsingResult->check_writable_fields = false;
			$this->BrowsingResult->save($save);
			$node_id = $this->BrowsingResult->id;
			$this->BrowsingIndex->check_writable_fields = false;
			$this->BrowsingIndex->save(array("BrowsingIndex" => array('root_node_id' => $node_id)));
		}else{
			//current set already exists, use it
			$node_id = $tmp['BrowsingResult']['id'];
		}
		
		$this->redirect('/Datamart/Browser/browse/'.$node_id);
	}
	
	function save($index_id){
		$this->request->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'))));
		if(empty($this->request->data)){
			$this->redirect( '/Pages/err_internal?p[]=invalid+data', NULL, TRUE );
		}else{
			$this->request->data['BrowsingIndex']['temporary'] = false;
			$this->BrowsingIndex->save($this->request->data);
			$this->atimFlash('your data has been updated', "/Datamart/Browser/index");
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
		if(!$child_data['BrowsingResult']['parent_id']){
			echo json_encode(array('redirect' => '/Pages/err_internal?p[]=no+parent', 'msg' => ''));
		}
		$parent_data = $this->BrowsingResult->findById($child_data['BrowsingResult']['parent_id']);
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
				'fields' => array($parent_model->name.'.'.$parent_model->primaryKey),
				'conditions' => array($parent_model->name.'.'.$control['BrowsingControl']['use_field'] => explode(',', $child_data['BrowsingResult']['id_csv']))
			));
		}else{
			//load the child model
			$datamart_structure = $this->DatamartStructure->findById($control['BrowsingControl']['id1']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			$child_model = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
			
			//fetch the used parent keys
			$parent_key_used_data = $child_model->find('all', array(
				'fields' => array($child_model->name.'.'.$control['BrowsingControl']['use_field']),
				'conditions' => array($child_model->name.'.'.$child_model->primaryKey => explode(',', $child_data['BrowsingResult']['id_csv'])) 
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
		$parent_id = null;
		$browsing_result = $this->BrowsingResult->findById($child_data['BrowsingResult']['parent_id']);
		if($browsing_result['BrowsingResult']['raw']){
			$parent_id = $child_data['BrowsingResult']['parent_id'];
		}else{
			$parent_id = $browsing_result['BrowsingResult']['parent_id'];
		}
		$save = array('BrowsingResult' => array(
			"user_id"						=> $this->Session->read('Auth.User.id'),
			"parent_id"						=> $parent_id,
			"browsing_structures_id"		=> $parent_data['DatamartStructure']['id'],
			"browsing_structures_sub_id"	=> $parent_data['BrowsingResult']['browsing_structures_sub_id'],
			"id_csv"						=> $id_csv,
			'raw'							=> 0,
			"browsing_type"					=> 'unused parents'
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
					$this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$return_id = $this->BrowsingResult->id;
			}
		}
		
		if($return_id){
			$this->redirect('/Datamart/Browser/browse/'.$return_id);
		}else{
			AppController::addWarningMsg(__('there are no unused parent items'));
			$this->redirect('/Datamart/Browser/browse/'.$node_id);
		}
		exit;
	}
	
	function applyBrowsingSteps($starting_node_id, $browsing_step_index_id){
		$this->BrowsingResult->check_writable_fields = false;
		$browsing_steps = $this->SavedBrowsingIndex->find('first', array('conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array('SavedBrowsingIndex.id' => $browsing_step_index_id))));
		if(!$browsing_steps){
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$node_id = $starting_node_id;
		foreach($browsing_steps['SavedBrowsingStep'] as $step){
			$search_params = unserialize($step['serialized_search_params']);
			$params = array(
					'struct_ctrl_id'		=> $step['datamart_structure_id'],
					'sub_struct_ctrl_id'	=> $step['datamart_sub_structure_id'],
					'node_id'				=> $node_id,
					'last'					=> false,
					'search_conditions'		=> $search_params['search_conditions'],
					'exact_search'			=> $search_params['exact_search'],
					'adv_search_conditions'	=> isset($search_params['adv_search_conditions']) ? $search_params['adv_search_conditions'] : array() 
			);
			if(!$created_node = $this->Browser->createNode($params)){
				//something went wrong. A flash screen has been called.
				return;
			}
			
			$node_id = $created_node['browsing']['BrowsingResult']['id'];
		}

		//done, render the proper node.
		$this->browse($node_id);
		$this->render('browse_checklist');
	}
}


