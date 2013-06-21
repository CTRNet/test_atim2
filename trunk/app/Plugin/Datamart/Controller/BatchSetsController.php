<?php

class BatchSetsController extends DatamartAppController {
	
	static $tmp_batch_set_limit = 5;
	
	var $uses = array(
		'Datamart.BatchSet', 
		'Datamart.BatchId', 
		'Datamart.BrowsingResult',
		'Datamart.DatamartStructure',
	
		'InventoryManagement.RealiquotingControl'
	);
	
	var $paginate = array(
		'BatchSet'=>array('limit'=>pagination_amount,'order'=>'BatchSet.created DESC')
	);

	function index($type_of_list='user'){
		
		//keep only the necessary tmp
		$tmp_batch = $this->BatchSet->find('all', array('conditions' => array('BatchSet.user_id' => $_SESSION['Auth']['User']['id'], 'BatchSet.flag_tmp' => true), 'order' => array('BatchSet.created DESC')));
		while(count($tmp_batch) > self::$tmp_batch_set_limit){
			$batch = array_pop($tmp_batch);
			$this->BatchSet->delete($batch['BatchSet']['id']);
		}
		$this->BatchSet->completeData($tmp_batch);
		$this->set('tmp_batch', $tmp_batch);
		
		
		$batch_set_filter = array();
		$filter_value = $type_of_list;
		switch($type_of_list){
			case 'user':
				$filter_value = 'my batch sets';
				$batch_set_filter['BatchSet.user_id'] = $_SESSION['Auth']['User']['id'];
				break;
			case 'group':
				$batch_set_filter['BatchSet.group_id'] = $_SESSION['Auth']['User']['group_id'];
				$batch_set_filter['BatchSet.sharing_status'] = array('group', 'all');
				break;
			case 'all':
				$batch_set_filter[] = array('OR' => array(
					array('BatchSet.user_id' => $_SESSION['Auth']['User']['id']),
					array('BatchSet.group_id' => $_SESSION['Auth']['User']['group_id'],
						'BatchSet.sharing_status' => 'group'),
					array('BatchSet.sharing_status' => 'all')));
				break;
			default:
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->set('filter_value', $filter_value);
		
		$this->Structures->set('querytool_batch_set');
		$this->request->data = $this->paginate($this->BatchSet, $batch_set_filter);
		$datamart_structures = array();
		$this->BatchSet->completeData($this->request->data);
	}
	
	function listall($batch_set_id){
		$this->Structures->set('querytool_batch_set', 'atim_structure_for_detail');
		$lookup_ids = array();
		$atim_menu_variables = array('BatchSet.id' => $batch_set_id);
		
		$batch_set = $this->BatchSet->getOrRedirect($batch_set_id);
		
		//check permissions
		$datamart_structure_data = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
		if(!AppController::checkLinkPermission($datamart_structure_data['DatamartStructure']['index_link'])){
			$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
			return;
		}
		
		if($batch_set['BatchSet']['flag_tmp']){
			$batch_set['BatchSet']['title'] = '<span class="red">'.strtoupper(__('temporary batch set')).'</span>';
			$atim_menu_variables['BatchSet.temporary_batchset'] = true;
		}
		
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, false)){
			return;
		}
		foreach ( $batch_set['BatchId'] as $fields ) {
			$lookup_ids[] = $fields['lookup_id'];
		}
			
		$this->set( 'atim_menu_variables',  $atim_menu_variables);
		
		// add COUNT of IDS to array results, for form list 
		$batch_set['BatchSet']['count_of_BatchId'] = count($lookup_ids);
		$lookup_ids[] = 0; 
		
		// set VAR to determine if this BATCHSET belongs to USER or to other user in GROUP
		$belong_to_this_user = $batch_set['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id'];
		$this->set( 'belong_to_this_user', $belong_to_this_user );
			
		$this->Structures->set( 'empty', 'atim_structure_for_process');
		
		// do search for RESULTS, using THIS->DATA if any
		$this->ModelToSearch = null;
		$atim_structure_for_results = null;
		$criteria = "";
		$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
		$batch_set['BatchSet']['plugin'] = $datamart_structure['DatamartStructure']['plugin'];
		$batch_set['BatchSet']['model'] = $datamart_structure['DatamartStructure']['model'];
		$atim_structure_for_results = $this->Structures->getFormById($datamart_structure['DatamartStructure']['structure_id']);
		$batch_set['BatchSet']['form_links_for_results'] = $datamart_structure['DatamartStructure']['index_link'];
		
		$batch_set['DatamartStructure'] = $datamart_structure['DatamartStructure'];
		$this->ModelToSearch = AppModel::getInstance($batch_set['BatchSet']['plugin'], $batch_set['BatchSet']['model'], true);
		$batch_set['BatchSet']['lookup_key_name'] = $this->ModelToSearch->primaryKey;
		
		$lookup_model_name = $batch_set['BatchSet']['model'];
		$lookup_key_name = $batch_set['BatchSet']['lookup_key_name'];
		$this->set('lookup_model_name', $lookup_model_name);
		$this->set('lookup_key_name', $lookup_key_name);
			
		if(count($lookup_ids) > 0){
			$criteria = $batch_set['BatchSet']['model'].'.'.$batch_set['BatchSet']['lookup_key_name']." IN ('".implode("', '", $lookup_ids)."')";
		}
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'batch_set_id', $batch_set_id );
		
		// make list of SEARCH RESULTS

    	$batch_set['0']['query_type'] = __('generic');
    	if($batch_set['DatamartStructure']['control_master_model']){
    		$datamart_structure = $batch_set['DatamartStructure'];
			$results = $this->ModelToSearch->find( 'all', array('fields' => array($this->ModelToSearch->getControlForeign()), 'conditions'=>$criteria, 'recursive' => 0, 'group' => $this->ModelToSearch->getControlForeign()) );
			if(count($results) == 1){
				//unique control, load detailed version
				AppModel::getInstance("Datamart", "Browser", true);
				$alternate_info = Browser::getAlternateStructureInfo($datamart_structure['plugin'], $this->ModelToSearch->getControlName(), $results[0][$datamart_structure['model']][$this->ModelToSearch->getControlForeign()]);

				$criteria = array($datamart_structure['control_master_model'].".id IN ('".implode("', '", $lookup_ids)."')");
				//add the control_id to the search conditions to benefit from direct inner join on detail
				$criteria[$datamart_structure['control_master_model'].".".$this->ModelToSearch->getControlForeign()] = $results[0][$datamart_structure['model']][$this->ModelToSearch->getControlForeign()];
					
				$batch_set['BatchSet']['model'] = $datamart_structure['control_master_model'];
				$prev_pkey = $this->ModelToSearch->primaryKey; 
				$this->ModelToSearch = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
				$atim_structure_for_results = $this->Structures->get('form', $alternate_info['form_alias']);
				$batch_set['BatchSet']['form_links_for_results'] = Browser::updateIndexLink($batch_set['BatchSet']['form_links_for_results'], $datamart_structure['model'], $datamart_structure['control_master_model'], $prev_pkey, $this->ModelToSearch->primaryKey);
				$batch_set['BatchSet']['form_links_for_results'] = substr($batch_set['BatchSet']['form_links_for_results'], strpos($batch_set['BatchSet']['form_links_for_results'], '/'));
				$batch_set['BatchSet']['lookup_key_name'] = 'id';
			}
			$batch_set['BatchSet']['form_links_for_results'];
    	}
		$results = $this->ModelToSearch->find( 'all', array( 'conditions' => $criteria, 'recursive' => 0 ) );
		
		$this->set( 'results', AppModel::sortWithUrl($results, $this->passedArgs)); // set for display purposes...
		$this->set( 'data_for_detail', $batch_set );
		$this->set( 'atim_structure_for_results', $atim_structure_for_results);
		$tmp = array();
		if(isset($atim_structure_for_results['Structure']['alias'])){
			$batch_set['BatchSet']['structure_alias'] = $atim_structure_for_results['Structure']['alias'];
		}else{
			foreach($atim_structure_for_results['Structure'] as $struct){
				$tmp[] = $struct['alias'];
			}
			$batch_set['BatchSet']['structure_alias'] = implode(",", $tmp);
		}
		$actions = array();
		if(count($results)){
			$actions = $this->BatchSet->getDropdownOptions(
				$batch_set['BatchSet']['plugin'], 
				$batch_set['BatchSet']['model'], 
				$batch_set['BatchSet']['lookup_key_name'],
				$batch_set['BatchSet']['structure_alias'],
				$lookup_model_name,
				$lookup_key_name,
				$batch_set_id
			);
			
			$tmp = array(0 => array(
					'label' => __('remove from batch set'),
					'value' => 'Datamart/BatchSets/remove/'.$batch_set_id.'/'
			));
			if(!is_numeric($batch_set['BatchSet']['datamart_structure_id'])){
				$tmp[1] = array(
					'label' => __('create generic batch set'),
					'value' => 'Datamart/BatchSets/add/-1'
				);
			}	
			$actions[0]['children'] = array_merge(
				$tmp,
				$actions[0]['children']
			);

			if($this->DatamartStructure->getIdByModelName($batch_set['BatchSet']['model']) != null){
				$actions[] = array(
					'label'	=> __("initiate browsing"),
					'value'	=> "Datamart/Browser/batchToDatabrowser/".$batch_set['BatchSet']['model']."/"
				);
			}
		}

		$this->set('actions', $actions);
		
		$ctrapp_form_links = array();
		$ctrapp_form_links = $batch_set['BatchSet']['form_links_for_results'];
		$this->set( 'ctrapp_form_links', $ctrapp_form_links ); // set for display purposes...
		
		$this->set( 'display_unlock_button', $this->BatchSet->allowToUnlock($batch_set_id));
	}
	
	function add($target_batch_set_id = 0){
		// if not an already existing Batch SET...
		$is_generic = $target_batch_set_id == -1;
		if($is_generic){
			$target_batch_set_id = 0;
		}
		$browsing_result = null;
		if(!$target_batch_set_id){
			// Create new batch set
			if(array_key_exists('node', $this->request->data)) {
				// use databrowser node id to get BATCHSET field values
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$structure = $this->Structures->getFormById($browsing_result['DatamartStructure']['structure_id']);
				if(empty($browsing_result) || empty($structure)) {
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$this->request->data['BatchSet']['datamart_structure_id'] = $browsing_result['DatamartStructure']['id'];
			}else if(array_key_exists('BatchSet', $this->request->data) && isset($this->request->data['BatchSet']['datamart_structure_id'])){
				$this->request->data['BatchSet']['datamart_structure_id'] = $this->request->data['BatchSet']['datamart_structure_id'];
			}else if(array_key_exists('Report', $this->request->data) && isset($this->request->data['Report']['datamart_structure_id'])){
				$this->request->data['BatchSet']['datamart_structure_id'] = $this->request->data['Report']['datamart_structure_id'];
			}else if(array_key_exists('BatchSet', $this->request->data)) {
				$batch_set_tmp = $this->BatchSet->find('first', array('conditions' => array('BatchSet.id' => $this->request->data['BatchSet']['id']), 'recursive' => 0));
				unset($this->request->data['BatchSet']['id']);
				//create a generic from a generic
				$this->request->data['BatchSet']['datamart_structure_id'] = $batch_set_tmp['BatchSet']['datamart_structure_id'];
			}else if(isset($this->request->params['_data'])){
				//creation via the "add to tmp batchset button"
				$data = $this->request->params['_data'];
				$model_name = key($data[0]);
				$datamart_structure_id = $this->DatamartStructure->getIdByModelName($model_name);
				$model = $this->DatamartStructure->getModel($datamart_structure_id, $model_name);
				$data = AppController::defineArrayKey($data, $model->name, $model->primaryKey, true);
				$ids = array_keys($data);
				
				$this->request->data['BatchSet']['flag_tmp'] = true;
				$this->request->data['BatchSet']['datamart_structure_id'] = $datamart_structure_id;
				$this->request->data['BatchSet']['user_id'] = $this->Session->read('Auth.User.id');
				$this->request->data['BatchSet']['group_id'] = $this->Session->read('Auth.User.group_id');
				$this->request->data['BatchSet']['sharing_status'] = 'user';
				$this->BatchSet->addWritableField(array('title', 'user_id', 'group_id', 'sharing_status', 'datamart_structure_id', 'flag_tmp'));
				$this->BatchSet->save( $this->request->data['BatchSet'] );
					
				// get new SET id, and save
				$target_batch_set_id = $this->BatchSet->getLastInsertId();
				$ids = array_unique($ids);
				$ids = array_filter($ids);
				
				foreach($ids as $id){
					// setup ARRAY for ADDING/SAVING
					$save_array[] = array(
						'set_id'	=> $target_batch_set_id,
						'lookup_id'	=> $id
					);
				}
					
				//saving
				$this->BatchId->check_writable_fields = false;
				$this->BatchId->saveAll($save_array);
				
				//done
				$this->redirect('/Datamart/BatchSets/listall/'.$target_batch_set_id);
			}else{
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			// generate TEMP description for this SET
			if(empty($this->request->data['BatchSet']['title'])) {
				$this->request->data['BatchSet']['title'] = date('Y-m-d G:i');
			}
			
			// save hidden MODEL value as new BATCH SET
			$this->request->data['BatchSet']['user_id'] = $this->Session->read('Auth.User.id');
			$this->request->data['BatchSet']['group_id'] = $this->Session->read('Auth.User.group_id');
			$this->request->data['BatchSet']['sharing_status'] = 'user';
			$this->BatchSet->addWritableField(array('title', 'user_id', 'group_id', 'sharing_status', 'datamart_structure_id'));
			$this->BatchSet->save( $this->request->data['BatchSet'] );
			
			// get new SET id, and save
			$target_batch_set_id = $this->BatchSet->getLastInsertId();
		}
		
		// get BatchSet for source info 
		$this->request->data['BatchSet']['id'] = $target_batch_set_id;
		$this->BatchSet->id = $target_batch_set_id;
	   
		$batch_set = $this->BatchSet->read();
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, true)){
			return;
		}
		
	    
		$lookup_key_name = null;
		$model = null;
		$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
		$datamart_structure = $datamart_structure['DatamartStructure'];
		$model = $batch_set['DatamartStructure']['model'];
		if($datamart_structure['control_master_model']){
			$batch_set['BatchSet']['model'] = $datamart_structure['control_master_model'];
			if(isset($this->request->data[$datamart_structure['model']])){
				$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
				$model = $datamart_structure['model'];
				$lookup_key_name = $model_instance->primaryKey;
			}else{
				$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
				$model = $datamart_structure['control_master_model'];
				$lookup_key_name = $model_instance->primaryKey;
			}
			
		}else{
			$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
			$batch_set['BatchSet']['model'] = $datamart_structure['model'];
			$lookup_key_name = $model_instance->primaryKey;
		}
		$batch_set['BatchSet']['plugin'] = $batch_set['DatamartStructure']['plugin'];		

	   	if(isset($this->request->data[$model])){
	   		//saving batch_set ids. To avoid dupes, load all existings ids, delete them, merge with the new ones, save.
			$batch_set_ids = array();

	    	//load and delete existing ids
	    	foreach($batch_set['BatchId'] as $array){
	    		$batch_set_ids[] = $array['lookup_id'];
	    	
	    		// remove from SAVED batch set
	    		$this->BatchId->delete( $array['id'] );
	    	}
			
	   	 	//merging with the new ones
	   	 	if(is_array($this->request->data[ $model ][ $lookup_key_name ])){
	   	 		$batch_set_ids = array_merge($this->request->data[ $model ][ $lookup_key_name ], $batch_set_ids);
			} else if($this->request->data[ $model ][ $lookup_key_name ] == 'all' && array_key_exists('node', $this->request->data)) {	
				if(!$browsing_result) {
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				}					
				$batch_set_ids = array_merge(explode(",", $browsing_result['BrowsingResult']['id_csv']), $batch_set_ids);				
	   	 	}else{
	   	 		$batch_set_ids = array_merge(explode(",", $this->request->data[ $model ][ $lookup_key_name ]), $batch_set_ids);
	   	 	}
	    
			// clean up IDS, removing blanks and duplicates...
			$batch_set_ids = array_unique($batch_set_ids);
			$batch_set_ids = array_filter($batch_set_ids);
			
			foreach($batch_set_ids as $integer){
				// setup ARRAY for ADDING/SAVING
				$save_array[] = array(
					'set_id'=>$this->request->data['BatchSet']['id'],
					'lookup_id'=>$integer
				);
			}
			
			//saving
			$this->BatchId->check_writable_fields = false;
			$this->BatchId->saveAll($save_array);
	    	
	    }else{
	    	AppController::addWarningMsg(__("failed to add data to the batch set"));
	    }
	   // clear SESSION after done...
		$_SESSION['ctrapp_core']['datamart']['process'] = array();
		
		$this->redirect( '/Datamart/BatchSets/listall/'.$this->request->data['BatchSet']['id'] );
		
		exit();
	}
	
	function edit($batch_set_id=0 ) {
		$this->set( 'atim_menu_variables', array('BatchSet.id'=>$batch_set_id ) );
		$this->Structures->set('querytool_batch_set' );
		
		if ( !empty($this->request->data) ) {
			$this->BatchSet->id = $batch_set_id;
			$this->request->data['BatchSet']['flag_tmp'] = false;
			$this->BatchSet->addWritableField('flag_tmp');
			unset($this->request->data['BatchSet']['created_by']);
			if ( $this->BatchSet->save($this->request->data) ){
				$this->atimFlash( 'your data has been updated','/Datamart/BatchSets/listall/'.$batch_set_id );
			}
		} else {
			$batch_set = $this->BatchSet->find('first',array('conditions'=>array('BatchSet.id'=>$batch_set_id)));
			if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, true)){
				return;
			}
			if($batch_set['BatchSet']['datamart_structure_id']){
				$tmp = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
				$batch_set['BatchSet']['model'] = $tmp['DatamartStructure']['model'];
			}
			$this->request->data = $batch_set;
		}
	}
	
	function delete($batch_set_id=0){
		$batch_set = $this->BatchSet->getOrRedirect($batch_set_id);
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, true)) {
			return;
		}
		$this->BatchSet->delete( $batch_set_id );
		$this->atimFlash( 'your data has been deleted', '/Datamart/BatchSets/index' );
	}
	
	function deleteInBatch() {
		// Get all user batchset
		$available_batchsets_conditions = array('OR' =>array(
				'BatchSet.user_id' => $_SESSION['Auth']['User']['id'],
				array('BatchSet.group_id' => $_SESSION['Auth']['User']['group_id'], 'BatchSet.sharing_status' => 'group'),
				'BatchSet.sharing_status' => 'all'));					
		$user_batchsets = $this->BatchSet->find('all', array(
			'conditions' 	=> $available_batchsets_conditions, 
			'order'			=>'BatchSet.created DESC'
		));
		foreach($user_batchsets as $key => $tmp_data) {
			$user_batchsets[$key]['BatchSet']['count_of_BatchId'] = count($tmp_data['BatchId']); 
		}
		$this->BatchSet->completeData($user_batchsets);
		$this->set('user_batchsets', $user_batchsets);
		
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>'user' ) );
		$this->set('atim_menu', $this->Menus->get('/Datamart/BatchSets/index/'));
		$this->Structures->set('querytool_batch_set');
		
		if(!empty($this->request->data)) {
			$deletion_done = false;
			foreach($this->request->data['BatchSet']['ids'] as $batch_set_id) {
				if(!empty($batch_set_id)) {
					if(!$this->BatchSet->delete( $batch_set_id )) {
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$deletion_done = true;
				}
			}
			if($deletion_done) {
				$this->atimFlash( 'your data has been deleted', '/Datamart/BatchSets/index/user' );
			} else {
				 $this->BatchSet->validationErrors[] = 'check at least one element from the batch set';
			}
		}
	}
	
	function remove($batch_set_id) {
		$batch_set = $this->BatchSet->getOrRedirect($batch_set_id);
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, true)){
			return;
		}
				
		// set function variables, makes script readable :)
		$batch_set_id = $batch_set['BatchSet']['id'];
		$batch_set_model_instance = null;
		$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
		$datamart_structure = $datamart_structure['DatamartStructure'];
		$batch_set_model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
		
		if (count($this->request->data[$batch_set_model_instance->name][$batch_set_model_instance->primaryKey])) {
			// START findall criteria
			$criteria = 'set_id="'.$batch_set_id.'" '		
				.'AND ( lookup_id="'.implode( '" OR lookup_id="', $this->request->data[$batch_set_model_instance->name][$batch_set_model_instance->primaryKey] ).'" )';
			
			// get BatchId ROWS and remove from SAVED batch set
			$results = $this->BatchId->find( 'all', array( 'conditions'=>$criteria ) );
			foreach ( $results as $id ) {
				$this->BatchId->delete( $id['BatchId']['id'] );
			}
		}
		
		// redirect back to list Batch SET
		$this->redirect( '/Datamart/BatchSets/listall/'.$batch_set_id );
		exit();
		
	}
	
	function save($batch_id){
		$batch_set = $this->BatchSet->getOrRedirect($batch_id);
		if($batch_set['BatchSet']['user_id'] == $this->Session->read('Auth.User.id')){
			$this->BatchSet->check_writable_fields = false;
			$this->BatchSet->id = $batch_id;
			$this->BatchSet->save(array('flag_tmp' => 0));
			$this->atimFlash('your data has been updated', "/Datamart/BatchSets/index");
		}else{
			$this->redirect( '/Pages/err_internal?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		}
	}
	
	function unlock($batch_set_id) {
		$batch_set = $this->BatchSet->getOrRedirect($batch_set_id);
		if($this->BatchSet->allowToUnlock($batch_set_id)) {
			$this->BatchSet->check_writable_fields = false;
			$this->BatchSet->id = $batch_set_id;
			$this->BatchSet->save(array('locked' => 0));
			$this->atimFlash('your data has been updated', "/Datamart/BatchSets/listall/$batch_set_id");
		} else {
			$this->flash(__('you are not allowed to unlock this batchset'), "/Datamart/BatchSets/index/user");
		}
	}
}

?>