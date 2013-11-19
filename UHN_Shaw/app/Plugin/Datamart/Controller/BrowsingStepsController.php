<?php
class BrowsingStepsController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.SavedBrowsingIndex',
		'Datamart.DatamartStructure',
		'Datamart.Browser'
	);
	
	function listall(){
		// Load datamart structure
		$tmp_datamart_structures = $this->DatamartStructure->find('all', array('conditions' => array()));
		$datamart_structures = array();
		foreach($tmp_datamart_structures as $new_datamart_structure) $datamart_structures[$new_datamart_structure['DatamartStructure']['id']] = $new_datamart_structure['DatamartStructure'];
		
		$this->request->data = $this->SavedBrowsingIndex->find('all', array('conditions' => $this->SavedBrowsingIndex->getOwnershipConditions(), 'order' => 'SavedBrowsingIndex.name'));
		foreach($this->request->data as &$data){
			//Translate display name
			$data['DatamartStructure']['display_name'] = __($data['DatamartStructure']['display_name']);
			//Get formatted step data
			$result = '';
			$step_counter = 0;
			foreach($data['SavedBrowsingStep'] as $new_step) {		
				$step_counter++;
				$new_step_datamart_structure = $datamart_structures[$new_step['datamart_structure_id']];			
				$new_step_model = AppModel::getInstance($new_step_datamart_structure['plugin'], $new_step_datamart_structure['model'], true);
				$step_title = "** $step_counter ** ".__($new_step_datamart_structure['display_name']);
				if($new_step['parent_children'] == 'c'){
					$step_title .= ' '.__('children');
				}else if($new_step['parent_children'] == 'p'){
					$step_title .= ' '.__('parent');
				}			
				$step_search_details = '';
				$search = $new_step['serialized_search_params'] ? unserialize($new_step['serialized_search_params']) : array();
				$adv_search = isset($search['adv_search_conditions']) ? $search['adv_search_conditions'] : array();							
				if((isset($search['search_conditions']) && count($search['search_conditions'])) || $adv_search || isset($search['counters'])){				
					$structure = null;
					if($new_step_model->getControlName() && $new_step['datamart_sub_structure_id'] > 0){									
						//alternate structure required
						$tmp_model = AppModel::getInstance($new_step_datamart_structure['plugin'], $new_step_datamart_structure['model'], true);
						AppModel::getInstance("Datamart", "Browser", true);
						$alternate_alias = Browser::getAlternateStructureInfo($new_step_datamart_structure['plugin'], $tmp_model->getControlName(), $new_step['datamart_sub_structure_id']);						
						$alternate_alias = $alternate_alias['form_alias'];
						$structure = StructuresComponent::$singleton->get('form', $alternate_alias);
						//unset the serialization on the sub model since it's already in the title
						unset($search['search_conditions'][$new_step_datamart_structure['control_master_model'].".".$tmp_model->getControlForeign()]);
						$tmp_model = AppModel::getInstance($new_step_datamart_structure['plugin'], $new_step_datamart_structure['control_master_model'], true);
						$tmp_data = $tmp_model->find('first', array('conditions' => array($tmp_model->getControlName().".id" => $new_step['datamart_sub_structure_id']), 'recursive' => 0));
						$step_title .= " > ".Browser::getTranslatedDatabrowserLabel($tmp_data[$tmp_model->getControlName()]['databrowser_label']);
					}else{		
						$structure = StructuresComponent::$singleton->getFormById($new_step_datamart_structure['structure_id']);
					}
						
					$addon_params = array();
					if(isset($search['counters'])){
						foreach($search['counters'] as $counter){	
							$browsing_structure = $datamart_structures[$counter['browsing_structures_id']];
							$addon_params[] = array('field' => __('counter').': '.__($browsing_structure['display_name']), 'condition' => $counter['condition']);
						}
					}
					if(count($search['search_conditions']) || $adv_search || $addon_params){//count might be zero if the only condition was the sub type
						$adv_structure = array();
						if($new_step_datamart_structure['adv_search_structure_alias']){
							$adv_structure = StructuresComponent::$singleton->get('form', $new_step_datamart_structure['adv_search_structure_alias']);				
						}
						
						$step_search_details .= $this->Browser->formatSearchToPrint(array(
							'search'		=> $search,
							'adv_search'	=> $adv_search,
							'structure'		=> $structure,
							'adv_structure'	=> $adv_structure,
							'model'			=> $new_step_model,
							'addon_params'	=> $addon_params
						), false);
					}
				}
				$result .= $step_title."\n".(empty($step_search_details)? __('no search criteria')."\n" : $step_search_details) ."\n";
			}			
			$data['Generated']['description'] = "$result";
		}
		$this->Structures->set('datamart_saved_browsing');
	}
	
	function save($node_id){
		Configure::write ('debug', 0);
		$this->set('node_id', $node_id);
		$this->Structures->set('datamart_saved_browsing');
	
		if(!empty($this->request->data)){
			$browsing_result_model = AppModel::getInstance('Datamart', 'BrowsingResult');
			$path = $browsing_result_model->getPath($node_id, null, 0);
			if(count($path) < 2){
				return;//error, shouldn't be called
			}
			$saved_browsing_step_model = AppModel::getInstance('Datamart', 'SavedBrowsingStep');
			$this->SavedBrowsingIndex->addWritableField(array('starting_datamart_structure_id', 'user_id', 'group_id'));
			$top_node = array_shift($path);
			$this->request->data['SavedBrowsingIndex']['starting_datamart_structure_id'] = $top_node['BrowsingResult']['browsing_structures_id'];
			$this->request->data['SavedBrowsingIndex']['user_id'] = $this->Session->read('Auth.User.id');
			$this->request->data['SavedBrowsingIndex']['group_id'] = $this->Session->read('Auth.User.group_id');
			$data_source = $this->SavedBrowsingIndex->getDataSource();
			$data_source->begin();
			if($this->SavedBrowsingIndex->save($this->request->data)){
				$index_id = $this->SavedBrowsingIndex->getInsertID();
				$browsing_steps = array();
				foreach($path as $path_node){
					if($path_node['BrowsingResult']['raw']){
						$browsing_steps[] = array(
								'datamart_saved_browsing_index_id' => $index_id,
								'datamart_structure_id'            => $path_node['BrowsingResult']['browsing_structures_id'],
								'datamart_sub_structure_id'        => $path_node['BrowsingResult']['browsing_structures_sub_id'],
								'serialized_search_params'         => $path_node['BrowsingResult']['serialized_search_params'],
						        'parent_children'                  => $path_node['BrowsingResult']['parent_children']
						);
					}
				}
				$saved_browsing_step_model->check_writable_fields = false;
				$saved_browsing_step_model->saveAll($browsing_steps);
				$data_source->commit();
				echo json_encode(array('type' => 'message', 'message' => __('data saved')));
				$this->render(false);
			}
		}
	}
	
	function edit($id){
		$this->Structures->set('datamart_saved_browsing');
		$browsing_index = $this->SavedBrowsingIndex->find('first', array('conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array('SavedBrowsingIndex.id' => $id))));
		if(!$browsing_index){
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		if(!empty($this->request->data)){
			$this->SavedBrowsingIndex->id = $id;
			if($this->SavedBrowsingIndex->save($this->request->data)){
				$this->atimFlash('your data has been saved', '/Datamart/BrowsingSteps/listall/');
			}
		}else{
			$this->request->data = $browsing_index;
			$this->request->data['DatamartStructure']['display_name'] = __($this->request->data['DatamartStructure']['display_name']);
		}
		$this->set( 'atim_menu_variables', array('SavedBrowsingIndex.id' => $id));
	}
	
	function delete($id){
		$browsing_index = $this->SavedBrowsingIndex->find('first', array('conditions' => array_merge($this->SavedBrowsingIndex->getOwnershipConditions(), array('SavedBrowsingIndex.id' => $id))));
		if(!$browsing_index){
			$this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->SavedBrowsingIndex->atimDelete($id);
		$this->atimFlash('your data has been deleted', '/Datamart/BrowsingSteps/listall/');
	}
}