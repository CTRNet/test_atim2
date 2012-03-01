<?php
class BrowsingStepsController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.SavedBrowsingIndex'
	);
	
	function listall(){
		$this->request->data = $this->SavedBrowsingIndex->find('all', array('conditions' => $this->SavedBrowsingIndex->getOwnershipConditions(), 'order' => 'SavedBrowsingIndex.name'));
		foreach($this->request->data as &$data){
			$data['DatamartStructure']['display_name'] = __($data['DatamartStructure']['display_name']);
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
					$browsing_steps[] = array(
							'datamart_saved_browsing_index_id' => $index_id,
							'datamart_structure_id' => $path_node['BrowsingResult']['browsing_structures_id'],
							'serialized_search_params' => $path_node['BrowsingResult']['serialized_search_params'],
							'serialized_adv_search_params' => $path_node['BrowsingResult']['serialized_adv_search_params']
					);
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