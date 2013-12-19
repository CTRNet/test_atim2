<?php
class BrowserController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.Browser',
		'Datamart.DatamartStructure',
		'Datamart.BrowsingResult',
		'Datamart.BrowsingControl',
		'Datamart.BrowsingIndex',
		'Datamart.BatchSet',
		'Datamart.SavedBrowsingIndex',
		'ExternalLink'
	);
		
	function index(){
		$this->Structures->set("datamart_browsing_indexes");
		$tmp_browsing = $this->BrowsingIndex->find('all', array(
			'conditions' => array("BrowsingResult.user_id" => $this->Session->read('Auth.User.id'), 'BrowsingIndex.temporary' => true),
			'order'	=> array('BrowsingResult.created DESC'))
		);
			
		while(count($tmp_browsing) > $this->BrowsingIndex->tmp_browsing_limit){
			$unit = array_pop($tmp_browsing);
			$this->BrowsingIndex->check_writable_fields = false;
			$this->BrowsingResult->check_writable_fields = false;
			$this->BrowsingIndex->delete($unit['BrowsingIndex']['id']);
			$this->BrowsingResult->delete($unit['BrowsingResult']['id'], true);
		}
		
		$this->set('tmp_browsing', $tmp_browsing);
		$this->set('tmp_browsing_limit', $this->BrowsingIndex->tmp_browsing_limit);
		
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
			$this->BrowsingIndex->addWritableField(array('temporary'));
			$this->BrowsingIndex->save($this->request->data);
			$this->atimFlash('your data has been updated', "/Datamart/Browser/index");
		}
	}
	
	function delete($index_id){
		$this->BrowsingResult;//lazy load
		$this->request->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'))));
		if(!empty($this->request->data)){
			$this->BrowsingIndex->atimDelete($index_id);
			$this->BrowsingResult->atimDelete($this->request->data['BrowsingIndex']['root_node_id']);
			$this->atimFlash( 'your data has been deleted', '/Datamart/Browser/index/');
		} else {
			$this->flash(__('error deleting data - contact administrator'), '/Datamart/Browser/index/');
		}
	}
	
	private function getIdsAndParentChild($control_id){
		$sub_structure_id = null;
		$parent_child = null;
		if(strpos($control_id, Browser::$sub_model_separator_str) !== false){
			list($control_id , $sub_structure_id) = explode(Browser::$sub_model_separator_str, $control_id);
		}
		if(in_array(substr($control_id, -1), array('c', 'p'))){
			$parent_child = substr($control_id, -1);
			$control_id = substr($control_id, 0, -1);
		}
		return array($control_id, $sub_structure_id, $parent_child);
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
		$parent_child = false;
		$this->set('control_id', (int)$control_id); //cast as it might end with c(child) or p(parent)
		$this->set('merge_to', $merge_to);
		$this->Browser;//lazy laod
		$help_url = $this->ExternalLink->find('first', array('conditions' => array('name' => 'databrowser_help')));
		$this->set("help_url", $help_url['ExternalLink']['link']);
		
		//data handling will redirect to a straight page
		if($this->request->data){
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
			list($control_id, $sub_structure_id, $parent_child) = $this->getIdsAndParentChild($control_id);
			//direct access array (if the user goes from 1 to 4 by going throuhg 2 and 3, the direct access are 2 and 3
			$direct_id_arr = explode(Browser::$model_separator_str, $control_id);
			
			$this->Browser->buildDrillDownIfNeeded($this->request->data, $node_id);
				
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
						'last'					=> $last_control_id == $control_id,
						'parent_child'			=> $parent_child
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
				$this->redirect('/Datamart/Browser/browse/'.$node_id.'/');
			}
			
			if($sub_structure_id){
				$this->redirect('/Datamart/Browser/browse/'.$node_id.'/'.$last_control_id.$parent_child.Browser::$sub_model_separator_str.$sub_structure_id);
			}
			$this->redirect('/Datamart/Browser/browse/'.$node_id.'/'.$last_control_id.$parent_child);
			
			
		}else{
			if($node_id == 0){
				if($control_id){
					//search screen
					list($control_id, $sub_structure_id, $parent_child) = $this->getIdsAndParentChild($control_id);
					$browsing = $this->DatamartStructure->findById($control_id);
					$last_control_id = $control_id;
				}else{
					//new access
					$this->set("dropdown_options", $this->Browser->getBrowserDropdownOptions(0, $node_id, null, null, null, null, null, null));
					$this->Structures->set("empty");
					$this->set('type', "add");
					$this->set('top', "/Datamart/Browser/browse/0/");
				}
			}else{
				if($control_id){
					//search screen
					list($control_id, $sub_structure_id, $parent_child) = $this->getIdsAndParentChild($control_id);
					$browsing = $this->DatamartStructure->findById($control_id);
					$last_control_id = $control_id.$parent_child;
				}else{
					//direct node access
					$this->set('node_id', $node_id);
					$browsing = $this->BrowsingResult->getOrRedirect($node_id);
					if($browsing['BrowsingResult']['user_id'] != CakeSession::read('Auth.User.id')){
						$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
					}
					$check_list = true;
				}
			}
		}
		
		//handle display data
		$render = 'browse_checklist';
		if($check_list){
			$this->Browser->initDataLoad($browsing, $merge_to, explode(",", $browsing['BrowsingResult']['id_csv']));
			
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
			
			$dropdown_options = $this->Browser->getBrowserDropdownOptions(
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
				if(isset($option['value']) && strpos($option['value'], 'javascript:setCsvPopup(\'Datamart/Csv/csv') === 0){
					unset($dropdown_options[$key]);
				}
			}
			$action = 'javascript:setCsvPopup("Datamart/Browser/csv/%d/'.$node_id.'/'.$merge_to.'/");';
			$dropdown_options[] = array(
				'value' => '0',
				'label' => __('export as CSV file (comma-separated values)'),
				'value' => sprintf($action, 0)
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
				$this->request->data = 'all';
			}
			$this->set('merged_ids', $this->Browser->merged_ids);
			$this->set('unused_parent', $browsing['BrowsingResult']['parent_id'] && $browsing['BrowsingResult']['raw']);
			
			$csv_merge_data = $this->BrowsingResult->getSingleLineMergeableNodes($node_id);
			$this->set('csv_merge_data', $csv_merge_data);
			

		}else if($browsing){
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
			
			//determine which search counter to display
			$path = $this->BrowsingResult->getPath($node_id);
			$current_structure_id = $browsing['DatamartStructure']['id'];
			$counters_structure_fields = array();
			if($path){
				while($parent_node = array_pop($path)){
					if($this->BrowsingControl->find1ToN($current_structure_id, $parent_node['BrowsingResult']['browsing_structures_id'])){
						//valid parent
						$browsing_result = $this->BrowsingResult->findById($parent_node['BrowsingResult']['id']);
						$counters_structure_fields[] = array(
							'model'	=> '0',
							'field'	=> 'counter_'.$parent_node['BrowsingResult']['id'],
							'type'	=> 'integer_positive',
							'flag_search'	=> 1,
							'flag_search_readonly'	=> 0,
							'display_column'	=> 1,
							'display_order'	=> 1,
							'language_label'	=> $browsing_result['DatamartStructure']['display_name'],
							'language_heading'	=> '',
							'tablename'	=> '',
							'language_tag'	=> '',
							'language_help' => '',
							'setting' => '',
							'default' => '',
							'flag_confidential' => '',
							'flag_float' => '',
							'margin' => '',
							'StructureValidation' => array()
						);
						$current_structure_id = $parent_node['BrowsingResult']['browsing_structures_id'];
					}else{
						break;
					}
				}
			}
			
			if($counters_structure_fields){
				$this->set('counters_structure_fields', array('Structure' => array('alias' => 'custom'), 'Sfs' => $counters_structure_fields));
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
		$config = array_merge($this->request->data['Config'], $this->request->data[0]);
		
		unset($this->request->data[0]);
		unset($this->request->data['Config']);
		$this->configureCsv($config);
		
		
		$browsing = $this->BrowsingResult->findById($node_id);
		
		if(!AppController::checkLinkPermission($browsing['DatamartStructure']['index_link'])){
			$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
			return;
		}
		
		$ids = null;
		if($this->request->data){
			$ids = current(current($this->request->data));
		}else{
			$ids = explode(",", $browsing['BrowsingResult']['id_csv']);
		}
		
		$this->layout = false;
		Configure::write('debug', 0);
		AppController::atimSetCookie(false);
		if($config['redundancy'] == 'same' && isset($config['singleLineNodes']) && !empty($config['singleLineNodes'])){
			//check selected nodes
			$mergeable_nodes = $this->BrowsingResult->getSingleLineMergeableNodes($node_id);
			$valid_ids = array_merge(array_keys($mergeable_nodes['parents']), array_keys($mergeable_nodes['flat_children']));
			foreach($config['singleLineNodes'] as $k => $received_id){
				if(!in_array($received_id, $valid_ids)){
					unset($config['singleLineNodes'][$k]);
				}
			}
			
			//for each added nodes, count the max width
			$nodes_info = array($node_id => array('max_length' => 1));
			$total_max_length = 1;
			foreach($config['singleLineNodes'] as $received_id){
				$nodes_info[$received_id] = array(
					'max_length'	=> $this->BrowsingResult->countMaxDuplicates($node_id, $received_id)
				);
				$total_max_length += $nodes_info[$received_id]['max_length']; 
			}
			
			$base_fetch_limit = (int)(500 / $total_max_length);
			$offset = 0;
			
			//get all nodes structures
			$browsing_results = $this->BrowsingResult->find('all', array('conditions' => array('BrowsingResult.id' => array_merge(array($node_id), $config['singleLineNodes']))));
			$browsing_results = AppController::defineArrayKey($browsing_results, 'BrowsingResult', 'id', true);
			$structures_array = array();//structures[node_id] = structure to use
			$models = array();//models[node_id] = model
			$joins = array();//joins[node_id] = joins array
			AppModel::getInstance('Datamart', 'Browser');//for a static call
			foreach($browsing_results as $browsing_result){
				//permissions
				if(!AppController::checkLinkPermission($browsing_result['DatamartStructure']['index_link'])){
					$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
					return;
				}
				
				$info = $this->BrowsingResult->getModelAndStructureForNode($browsing_result);
				$structures_array[$browsing_result['BrowsingResult']['id']] = $info['structure'];
				$nodes_info[$browsing_result['BrowsingResult']['id']]['display_name'] = __($browsing_result['DatamartStructure']['display_name']).($info['header_sub_type'] ? ' - '.Browser::getTranslatedDatabrowserLabel($info['header_sub_type']) : '');
				$models[$browsing_result['BrowsingResult']['id']] = $info['model'];
				if($browsing_result['BrowsingResult']['id'] != $node_id){
					$joins[$browsing_result['BrowsingResult']['id']] = $this->BrowsingResult->getJoins($browsing_result['BrowsingResult']['id'], $node_id);
				}
			}
			
			$this->set('nodes_info', $nodes_info);
			$this->set('structures_array', $structures_array);
			$this->set('csv_header', true);
			
			while($primary_data = $models[$node_id]->find('all', array('conditions' => array($models[$node_id]->name.'.'.$models[$node_id]->primaryKey => $ids), 'limit' => $base_fetch_limit, 'offset' => $offset))){
				$primary_data = AppController::defineArrayKey($primary_data, $models[$node_id]->name, $models[$node_id]->primaryKey, true);
				$this->request->data = array();
				$this->request->data[$node_id] = AppController::defineArrayKey($primary_data, $models[$node_id]->name, $models[$node_id]->primaryKey);
				$base_model_condition = array($models[$node_id]->name.'.'.$models[$node_id]->primaryKey => array_keys($primary_data));
				foreach($nodes_info as $key => $node_info){
					if($key == $node_id){
						continue;//skip primary node
					}
					foreach($joins[$key] as $join){
						unset($models[$key]->belongsTo[$join['alias']]);
					}
					$models[$key]->find('first');
					$data = $models[$key]->find('all', array(
						'fields'	=> array('*'),
						'joins'	=> $joins[$key],
						'conditions'	=> array_merge($base_model_condition, array($models[$key]->name.'.'.$models[$key]->primaryKey.' IN ('.$browsing_results[$key]['BrowsingResult']['id_csv'].')'))
					));
					$this->request->data[$key] = AppController::defineArrayKey($data, $models[$node_id]->name, $models[$node_id]->primaryKey);
				}
				$offset += $base_fetch_limit;
				$this->render('../Csv/csv_same_line');
				$this->set('csv_header', false);
			}
			
		}else{
			$this->Browser->InitDataLoad($browsing, $config['redundancy'] == 'same' ? 0 : $merge_to, $ids);
			
			if(!$this->Browser->valid_permission){
				$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
				return;
			}
			
			$this->set("result_structure", $this->Browser->result_structure);
			
			$this->set('csv_header', true);
			while($this->request->data = $this->Browser->getDataChunk(300)){
				$this->render('../Csv/csv');
				$this->set('csv_header', false);
			}
		}
		
		$this->render(false);
	}
	
		
	/**
	 * If the model is found, creates a batchset based based on it and displays the first node. The ids must be in
	 * $this->request->data[$model][id]
	 * @param String $model
	 */
	function batchToDatabrowser($model, $source = 'batchset'){
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
			$this->redirect( '/Pages/err_internal?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
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
			"browsing_type"					=> 'initiated from '.$source
		));
		
		$tmp = $this->BrowsingResult->find('first', array('conditions' => Set::flatten($save)));
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
		$this->BrowsingResult;//lazy load
		$this->request->data = $this->BrowsingIndex->find('first', array('conditions' => array('BrowsingIndex.id' => $index_id, "BrowsingResult.user_id" => $this->Session->read('Auth.User.id'))));
		if(empty($this->request->data)){
			$this->redirect( '/Pages/err_internal?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		}else{
			$this->request->data['BrowsingIndex']['temporary'] = false;
			$this->BrowsingIndex->pkey_safeguard = false;
			$this->BrowsingIndex->check_writable_fields = false;
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
			$tmp = $this->BrowsingResult->find('first', array('conditions' => Set::flatten($save)));
			if(!empty($tmp)){
				//current set already exists, use it
				$return_id = $tmp['BrowsingResult']['id'];
			}else{
				$this->BrowsingResult->id = null;
				$this->BrowsingResult->check_writable_fields = false;
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
		
		$this->Browser->buildDrillDownIfNeeded($this->request->data, $starting_node_id);
		
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
					'adv_search_conditions'	=> isset($search_params['adv_search_conditions']) ? $search_params['adv_search_conditions'] : array(),
			        'parent_child'          => $step['parent_children']
			);
			if(!$created_node = $this->Browser->createNode($params)){
				//something went wrong. A flash screen has been called.
				return;
			}
			
			$node_id = $created_node['browsing']['BrowsingResult']['id'];
		}

		//done, render the proper node.
		$this->redirect('/Datamart/Browser/browse/'.$node_id.'/');
	}
}


