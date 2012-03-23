<?php

class BatchSetsController extends DatamartAppController {
	
	static $tmp_batch_set_limit = 5;
	
	var $uses = array(
		'Datamart.Adhoc', 
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
		$this->set( 'atim_menu_variables',  array("Param.Type_Of_List" => $type_of_list));
		
		switch($type_of_list){
			case 'user':
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
		
		$this->Structures->set('querytool_batch_set');
		$this->Adhoc;//activate lazy loader
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
		if($batch_set['BatchSet']['datamart_adhoc_id']){
			$adhoc_data = $this->Adhoc->findById($batch_set['BatchSet']['datamart_adhoc_id']);
			if(empty($adhoc_data['AdhocPermission'])){
				$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
				return;
			}
		}else if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure_data = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			if(!AppController::checkLinkPermission($datamart_structure_data['DatamartStructure']['index_link'])){
				$this->flash(__("You are not authorized to access that location."), 'javascript:history.back()');
				return;
			}
			
			if($batch_set['BatchSet']['flag_tmp']){
				$batch_set['BatchSet']['title'] = '<span class="red">'.strtoupper(__('temporary batch set')).'</span>';
				$atim_menu_variables['BatchSet.temporary_batchset'] = true;
			}
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
		if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			$batch_set['BatchSet']['plugin'] = $datamart_structure['DatamartStructure']['plugin'];
			$batch_set['BatchSet']['model'] = $datamart_structure['DatamartStructure']['model'];
			$atim_structure_for_results = $this->Structures->getFormById($datamart_structure['DatamartStructure']['structure_id']);
			$batch_set['BatchSet']['form_links_for_results'] = $datamart_structure['DatamartStructure']['index_link'];
			
			$batch_set['DatamartStructure'] = $datamart_structure['DatamartStructure'];
		}else{
			$batch_set['BatchSet']['plugin'] = $batch_set['Adhoc']['plugin'];
			$batch_set['BatchSet']['model'] = $batch_set['Adhoc']['model'];
			$atim_structure_for_results = $this->Structures->get( 'form', $batch_set['Adhoc']['form_alias_for_results']);
		}
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
		if(isset($batch_set['BatchSet']['datamart_adhoc_id'])){
    		$batch_set['0']['query_type'] = __('custom');
			$results = array();
    		if($batch_set['Adhoc']['sql_query_for_results']){
				// add restrictions to query, inserting BATCH SET IDs to WHERE statement
	    		list( , $query_to_use) = $this->Structures->parse_sql_conditions( $batch_set['Adhoc']['sql_query_for_results'], array() );
				$query_to_use = str_replace( 'WHERE TRUE', 'WHERE ('.$criteria.')', $query_to_use );
				$results = $this->ModelToSearch->query( $query_to_use );
				
    		}else{
    			//function to call
    			require_once('customs/custom_adhoc_functions.php');
				$custom_adhoc_functions = new CustomAdhocFunctions();
				if(!method_exists($custom_adhoc_functions, $batch_set['Adhoc']['function_for_results'])){
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$function = $batch_set['Adhoc']['function_for_results'];
				$results = $custom_adhoc_functions->$function($this, $lookup_ids);
    		}
    		if(count($results) != count($batch_set['BatchId'])){
    			$msg = __("the batch set contains %d entries but only %d are returned by the query")." ".__("to see all elements, convert your batchset using the generic batch set options");
    			AppController::addWarningMsg(sprintf($msg, count($batch_set['BatchId']), count($results)));
    		}
    		$batch_set['BatchSet']['flag_use_query_results'] = 1;
    	}else{
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
			$batch_set['BatchSet']['flag_use_query_results'] = 0;
		}
		
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
					'value' => '/Datamart/BatchSets/remove/'.$batch_set_id.'/'
			));
			if(!is_numeric($batch_set['BatchSet']['datamart_structure_id'])){
				$tmp[1] = array(
					'label' => __('create generic batch set'),
					'value' => '/Datamart/BatchSets/add/-1'
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
		// parse LINKS field in ADHOCS list for links in CHECKLIST
		$ctrapp_form_links = array();
		
		if ( isset($batch_set['Adhoc']) && $batch_set['Adhoc']['form_links_for_results']) {
			$batch_set['Adhoc']['form_links_for_results'] = explode( '|', $batch_set['Adhoc']['form_links_for_results'] );
			foreach ( $batch_set['Adhoc']['form_links_for_results'] as $exploded_form_links ) {
				$exploded_form_links = explode( '=>', $exploded_form_links );
				$ctrapp_form_links[ $exploded_form_links[0] ]['link'] = $exploded_form_links[1];
				$exploded_link_name =  explode(" ", $exploded_form_links[0]);
				$ctrapp_form_links[ $exploded_form_links[0] ]['icon'] = $exploded_link_name[0];
			}
		}else{
			$ctrapp_form_links = $batch_set['BatchSet']['form_links_for_results'];
		}
		$this->set( 'ctrapp_form_links', $ctrapp_form_links ); // set for display purposes...
	}
	
	function add($target_batch_set_id = 0){
		// if not an already existing Batch SET...
		$is_generic = $target_batch_set_id == -1;
		if($is_generic){
			$target_batch_set_id = 0;
		}
		if(!$target_batch_set_id){
			// Create new batch set
			if(array_key_exists('Adhoc', $this->request->data)) {
				// use ADHOC id to get BATCHSET field values
				$adhoc_source = $this->Adhoc->find('first', array('conditions'=>'Adhoc.id="'.$this->request->data['Adhoc']['id'].'"'));
				
				$adhoc = $this->Adhoc->findById($this->request->data['Adhoc']['id']);
				if(!$adhoc['Adhoc']['flag_use_control_for_results']){
					//try to switch to a datamart_structure instead of adhoc
					$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('OR' => array('model' => $adhoc['Adhoc']['model'], 'control_master_model' => $adhoc['Adhoc']['model'])), 'fields' => array('id'), 'recursive' => -1));
					if(!empty($datamart_structure)){
						$this->request->data['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
					}else{
						$this->request->data['BatchSet']['datamart_adhoc_id'] = $this->request->data['Adhoc']['id'];						
					}
				}else{
					$this->request->data['BatchSet']['datamart_adhoc_id'] = $this->request->data['Adhoc']['id'];
				}
			
			}else if(array_key_exists('node', $this->request->data)) {
				// use databrowser node id to get BATCHSET field values
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
				$structure = $this->Structures->getFormById($browsing_result['DatamartStructure']['structure_id']);
				if(empty($browsing_result) || empty($structure)) {
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				$this->request->data['BatchSet']['datamart_structure_id'] = $browsing_result['DatamartStructure']['id'];
			}else if(array_key_exists('BatchSet', $this->request->data) && isset($this->request->data['BatchSet']['datamart_structure_id'])){
				$this->request->data['BatchSet']['datamart_structure_id'] = $this->request->data['BatchSet']['datamart_structure_id'];
			}else if(array_key_exists('BatchSet', $this->request->data)) {
				$batch_set_tmp = $this->BatchSet->find('first', array('conditions' => array('BatchSet.id' => $this->request->data['BatchSet']['id']), 'recursive' => 0));
				unset($this->request->data['BatchSet']['id']);
				if($batch_set_tmp['BatchSet']['datamart_adhoc_id']){
					if($is_generic){
						//convert a non generic batch set to a generic batch set
						$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('OR' => array('DatamartStructure.model' => $batch_set_tmp['Adhoc']['model'], 'DatamartStructure.control_master_model' => $batch_set_tmp['Adhoc']['model']))));
						if(empty($datamart_structure)){
							$this->flash(__('this batch set cannot be used to create a generic batch set'), 'javascript:history.back();', 5);
							return;
						}
						$this->request->data['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
					}else{
						//create a non generic batch set from a non generic batch set
						$this->request->data['BatchSet']['datamart_adhoc_id'] = $batch_set_tmp['BatchSet']['datamart_adhoc_id'];
					}
				}else{
					//create a generic from a generic
					$this->request->data['BatchSet']['datamart_structure_id'] = $batch_set_tmp['BatchSet']['datamart_structure_id'];
				}
			} else {
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
		if($batch_set['BatchSet']['datamart_structure_id']){
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
		}else{
			$model =  $batch_set['Adhoc']['model'];
			$lookup_key_name = "id";
			//try to switch to a datamart_structure instead of adhoc
			if(!$batch_set['Adhoc']['flag_use_control_for_results']){
				$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('control_master_model' => $batch_set['BatchSet']['model']), 'fields' => array('model'), 'recursive' => -1));
				if(!empty($datamart_structure) && isset($this->request->data[$datamart_structure['DatamartStructure']['model']])){
					$batch_set['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
					$batch_set['BatchSet']['datamart_adhoc_id'] = null;
				}
			}
		}
		

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
		if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			$batch_set_model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
		}else{
			$batch_set_model_instance = AppModel::getInstance($batch_set['Adhoc']['plugin'], $batch_set['Adhoc']['model'], true);
		}
		
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
	
	/**
	 * Cast a given batch set and redirects to it
	 * @param int $batch_set_id
	 * @param boolean $create_new If true, creates a new batch set, otherwise casts the existing batch set 
	 */
	function generic($batch_set_id, $create_new){
		//validate access
		$batch_set = $this->BatchSet->getOrRedirect($batch_set_id);
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, false)) {
			return;
		}
		
		//find compatible datamart structure
		$datamart_structure_id = $this->BatchSet->getCompatibleDatamartStructureId($batch_set['Adhoc']['model']);
		if(!$datamart_structure_id){
			$this->flash(__('this batch set cannot be used to create a generic batch set'), 'javascript:history.back();', 5);
			return;
		}
		$datamart_structure_data = $this->DatamartStructure->findById($datamart_structure_id);
		if(!AppController::checkLinkPermission($datamart_structure_data['DatamartStructure']['index_link'])){
			$this->flash(__('you are not allowed to use the generic version of that batch set.'), 'javascript:history.back()');
			return;
		}

		$this->BatchSet->data = array();
		
		if($create_new){
			$new_batch_set['BatchSet']['user_id'] = $_SESSION['Auth']['User']['id'];
			$new_batch_set['BatchSet']['group_id'] = $_SESSION['Auth']['User']['group_id'];
			$new_batch_set['BatchSet']['title'] = now();
			$new_batch_set['BatchSet']['datamart_structure_id'] = $datamart_structure_id;
			$this->BatchSet->save($new_batch_set);
			$ids = array();
			foreach($batch_set['BatchId'] as $id){
				$ids[] = array("set_id" => $this->BatchSet->id, "lookup_id" => $id['lookup_id']);
			}
			$this->BatchId->saveAll($ids);
			$this->atimFlash('your data has been updated','/Datamart/BatchSets/listall/'.$this->BatchSet->id);
		}else{
			$batch_set['BatchSet']['datamart_adhoc_id'] = null;
			$batch_set['BatchSet']['datamart_structure_id'] = $datamart_structure_id;
			$this->BatchSet->set($batch_set);
			$this->BatchSet->save();
			$this->atimFlash('your data has been updated','/Datamart/BatchSets/listall/'.$batch_set_id);
		}
	}
	
	function save($batch_id){
		$batch_set = $this->BatchSet->getOrRedirect($batch_id);
		if($batch_set['BatchSet']['user_id'] == $this->Session->read('Auth.User.id')){
			$this->BatchSet->check_writable_fields = false;
			$this->BatchSet->id = $batch_id;
			$this->BatchSet->save(array('flag_tmp' => 0));
			$this->atimFlash('your data has been updated', "/Datamart/BatchSets/index");
		}else{
			$this->redirect( '/Pages/err_internal?p[]=invalid+data', NULL, TRUE );
		}
	}
}

?>