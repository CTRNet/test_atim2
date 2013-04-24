<?php

class BatchSetsController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.Adhoc', 
		
		'Datamart.BatchSet', 
		'Datamart.BatchId', 
		'Datamart.BrowsingResult',
		'Datamart.DatamartStructure',
	
		'Inventorymanagement.RealiquotingControl'
	);
	
	var $paginate = array(
		'BatchSet'=>array('limit'=>pagination_amount,'order'=>'BatchSet.created DESC')
	);

	function index($type_of_list='user'){
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
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$this->Structures->set('querytool_batch_set');
		
		$this->data = $this->paginate($this->BatchSet, $batch_set_filter);
		$datamart_structures = array();
		$this->BatchSet->completeData($this->data);
	}
	
	function listall($batch_set_id){
		$this->Structures->set('querytool_batch_set', 'atim_structure_for_detail');
		$lookup_ids = array();
		$atim_menu_variables = array('BatchSet.id' => $batch_set_id);
		
		$batch_set = $this->BatchSet->redirectIfNonExistent($batch_set_id, __METHOD__, __LINE__, true);
		
		//check permissions
		if($batch_set['BatchSet']['datamart_adhoc_id']){
			$adhoc_data = $this->Adhoc->findById($batch_set['BatchSet']['datamart_adhoc_id']);
			if(empty($adhoc_data['AdhocPermission'])){
				$this->flash(__("You are not authorized to access that location.", true), 'javascript:history.back()');
				return;
			}
		}else if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure_data = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			if(!AppController::checkLinkPermission($datamart_structure_data['DatamartStructure']['index_link'])){
				$this->flash(__("You are not authorized to access that location.", true), 'javascript:history.back()');
				return;
			}
			
			if($batch_set['BatchSet']['flag_tmp']){
				$batch_set['BatchSet']['title'] = '<span class="red">'.strtoupper(__('temporary batch set', true)).'</span>';
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
			
		$this->Structures->set( 'datamart_browser_start', 'atim_structure_for_process');
		
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
			$batch_set['BatchSet']['lookup_key_name'] = $datamart_structure['DatamartStructure']['use_key'];
			$batch_set['DatamartStructure'] = $datamart_structure['DatamartStructure'];
		}else{
			$batch_set['BatchSet']['plugin'] = $batch_set['Adhoc']['plugin'];
			$batch_set['BatchSet']['model'] = $batch_set['Adhoc']['model'];
			$batch_set['BatchSet']['lookup_key_name'] = 'id';
			$atim_structure_for_results = $this->Structures->get( 'form', $batch_set['Adhoc']['form_alias_for_results']);
		}
		$this->ModelToSearch = AppModel::getInstance($batch_set['BatchSet']['plugin'], $batch_set['BatchSet']['model'], true);
		
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
    		$batch_set['0']['query_type'] = __('custom', true);
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
					$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$function = $batch_set['Adhoc']['function_for_results'];
				$results = $custom_adhoc_functions->$function($this, $lookup_ids);
    		}
    		if(count($results) != count($batch_set['BatchId'])){
    			$msg = __("the batch set contains %d entries but only %d are returned by the query", true)." ".__("to see all elements, convert your batchset using the generic batch set options", true);
    			AppController::addWarningMsg(sprintf($msg, count($batch_set['BatchId']), count($results)));
    		}
    		$batch_set['BatchSet']['flag_use_query_results'] = 1;
    	}else{
    		$batch_set['0']['query_type'] = __('generic', true);
    		if($batch_set['DatamartStructure']['control_master_model']){
    			$datamart_structure = $batch_set['DatamartStructure'];
				$results = $this->ModelToSearch->find( 'all', array('fields' => array($datamart_structure['control_field']), 'conditions'=>$criteria, 'recursive' => 0, 'group' => $datamart_structure['control_field']) );
				if(count($results) == 1){
					//unique control, load detailed version
					AppModel::getInstance("datamart", "Browser", true);
					$alternate_info = Browser::getAlternateStructureInfo($datamart_structure['plugin'], $datamart_structure['control_model'], $results[0][$datamart_structure['model']][$datamart_structure['control_field']]);

					$criteria = array($datamart_structure['control_master_model'].".id IN ('".implode("', '", $lookup_ids)."')");
					//add the control_id to the search conditions to benefit from direct inner join on detail
					$criteria[$datamart_structure['control_master_model'].".".$datamart_structure['control_field']] = $results[0][$datamart_structure['model']][$datamart_structure['control_field']];
					
					$batch_set['BatchSet']['model'] = $datamart_structure['control_master_model'];
					$this->ModelToSearch = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
					$atim_structure_for_results = $this->Structures->get('form', $alternate_info['form_alias']);
					$batch_set['BatchSet']['form_links_for_results'] = Browser::updateIndexLink($batch_set['BatchSet']['form_links_for_results'], $datamart_structure['model'], $datamart_structure['control_master_model'], $datamart_structure['use_key'], "id");
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
					'value' => '0',
					'default' => __('remove from batch set', true),
					'action' => '/datamart/batch_sets/remove/'.$batch_set_id.'/'
			));
			if(!is_numeric($batch_set['BatchSet']['datamart_structure_id'])){
				$tmp[1] = array(
					'value' => '0',
					'default' => __('create generic batch set', true),
					'action' => '/datamart/batch_sets/add/-1'
				);
			}	
			$actions[0]['children'] = array_merge(
				$tmp,
				$actions[0]['children']
			);

			if($this->DatamartStructure->getIdByModelName($batch_set['BatchSet']['model']) != null){
				$actions[] = array(
					"value"		=> 0,
					"default"	=> __("initiate browsing", true),
					"action"	=> "datamart/browser/batchToDatabrowser/".$batch_set['BatchSet']['model']."/"
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
			if(array_key_exists('Adhoc', $this->data)) {
				// use ADHOC id to get BATCHSET field values
				$adhoc_source = $this->Adhoc->find('first', array('conditions'=>'Adhoc.id="'.$this->data['Adhoc']['id'].'"'));
				
				$adhoc = $this->Adhoc->findById($this->data['Adhoc']['id']);
				if(!$adhoc['Adhoc']['flag_use_control_for_results']){
					//try to switch to a datamart_structure instead of adhoc
					$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('OR' => array('model' => $adhoc['Adhoc']['model'], 'control_master_model' => $adhoc['Adhoc']['model'])), 'fields' => array('id'), 'recursive' => -1));
					if(!empty($datamart_structure)){
						$this->data['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
					}else{
						$this->data['BatchSet']['datamart_adhoc_id'] = $this->data['Adhoc']['id'];						
					}
				}else{
					$this->data['BatchSet']['datamart_adhoc_id'] = $this->data['Adhoc']['id'];
				}
			
			}else if(array_key_exists('node', $this->data)) {
				// use databrowser node id to get BATCHSET field values
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->data['node']['id'])));
				$structure = $this->Structures->getFormById($browsing_result['DatamartStructure']['structure_id']);
				if(empty($browsing_result) || empty($structure)) {
					$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				
				$this->data['BatchSet']['datamart_structure_id'] = $browsing_result['DatamartStructure']['id'];
			}else if(array_key_exists('BatchSet', $this->data) && isset($this->data['BatchSet']['datamart_structure_id'])){
				$this->data['BatchSet']['datamart_structure_id'] = $this->data['BatchSet']['datamart_structure_id'];
			}else if(array_key_exists('BatchSet', $this->data)) {
				$batch_set_tmp = $this->BatchSet->find('first', array('conditions' => array('BatchSet.id' => $this->data['BatchSet']['id']), 'recursive' => 0));
				unset($this->data['BatchSet']['id']);
				if($batch_set_tmp['BatchSet']['datamart_adhoc_id']){
					if($is_generic){
						//convert a non generic batch set to a generic batch set
						$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('OR' => array('DatamartStructure.model' => $batch_set_tmp['Adhoc']['model'], 'DatamartStructure.control_master_model' => $batch_set_tmp['Adhoc']['model']))));
						if(empty($datamart_structure)){
							$this->flash(__('this batch set cannot be used to create a generic batch set', true), 'javascript:history.back();', 5);
							return;
						}
						$this->data['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
					}else{
						//create a non generic batch set from a non generic batch set
						$this->data['BatchSet']['datamart_adhoc_id'] = $batch_set_tmp['BatchSet']['datamart_adhoc_id'];
					}
				}else{
					//create a generic from a generic
					$this->data['BatchSet']['datamart_structure_id'] = $batch_set_tmp['BatchSet']['datamart_structure_id'];
				}
			} else {
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			// generate TEMP description for this SET
			if(empty($this->data['BatchSet']['title'])) {
				$this->data['BatchSet']['title'] = date('Y-m-d G:i');
			}
			
			// save hidden MODEL value as new BATCH SET
			$this->data['BatchSet']['user_id'] = $_SESSION['Auth']['User']['id'];
			$this->data['BatchSet']['group_id'] = $_SESSION['Auth']['User']['group_id'];
			$this->data['BatchSet']['sharing_status'] = 'user';
			$this->BatchSet->save( $this->data['BatchSet'] );
			
			// get new SET id, and save
			$target_batch_set_id = $this->BatchSet->getLastInsertId();
		}
		
		// get BatchSet for source info 
		$this->data['BatchSet']['id'] = $target_batch_set_id;
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
				if(isset($this->data[$datamart_structure['model']])){
					$model = $datamart_structure['model'];
					$lookup_key_name = $datamart_structure['use_key'];
				}else{
					$model = $datamart_structure['control_master_model'];
					$lookup_key_name = 'id';
				}
				
			}else{
				$batch_set['BatchSet']['model'] = $datamart_structure['model'];
				$lookup_key_name = $datamart_structure['use_key'];
			}
			$batch_set['BatchSet']['plugin'] = $batch_set['DatamartStructure']['plugin'];
		}else{
			$model =  $batch_set['Adhoc']['model'];
			$lookup_key_name = "id";
			//try to switch to a datamart_structure instead of adhoc
			if(!$batch_set['Adhoc']['flag_use_control_for_results']){
				$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('control_master_model' => $batch_set['BatchSet']['model']), 'fields' => array('model', 'use_key'), 'recursive' => -1));
				if(!empty($datamart_structure) && isset($this->data[$datamart_structure['DatamartStructure']['model']])){
					$batch_set['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
					$batch_set['BatchSet']['datamart_adhoc_id'] = null;
				}
			}
		}
		

	   	if(isset($this->data[$model])){
	   		//saving batch_set ids. To avoid dupes, load all existings ids, delete them, merge with the new ones, save.
			$batch_set_ids = array();

	    	//load and delete existing ids
	    	foreach($batch_set['BatchId'] as $array){
	    		$batch_set_ids[] = $array['lookup_id'];
	    	
	    		// remove from SAVED batch set
	    		$this->BatchId->delete( $array['id'] );
	    	}
	    
	   	 	//merging with the new ones
	   	 	if(is_array($this->data[ $model ][ $lookup_key_name ])){
	   	 		$batch_set_ids = array_merge($this->data[ $model ][ $lookup_key_name ], $batch_set_ids);
	   	 	}else{
	   	 		$batch_set_ids = array_merge(explode(",", $this->data[ $model ][ $lookup_key_name ]), $batch_set_ids);
	   	 	}
	    
			// clean up IDS, removing blanks and duplicates...
			$batch_set_ids = array_unique($batch_set_ids);
			$batch_set_ids = array_filter($batch_set_ids);
			
			foreach($batch_set_ids as $integer){
				// setup ARRAY for ADDING/SAVING
				$save_array[] = array(
					'set_id'=>$this->data['BatchSet']['id'],
					'lookup_id'=>$integer
				);
			}
			
			//saving
			$this->BatchId->saveAll($save_array);
	    	
	    }else{
	    	AppController::addWarningMsg(__("failed to add data to the batch set", true));
	    }
	   // clear SESSION after done...
		$_SESSION['ctrapp_core']['datamart']['process'] = array();
		
		$this->redirect( '/datamart/batch_sets/listall/'.$this->data['BatchSet']['id'] );
		
		exit();
	}
	
	function edit($batch_set_id=0 ) {
		$this->set( 'atim_menu_variables', array('BatchSet.id'=>$batch_set_id ) );
		$this->Structures->set('querytool_batch_set' );
		
		if ( !empty($this->data) ) {
			$this->BatchSet->id = $batch_set_id;
			$this->data['BatchSet']['flag_tmp'] = false;
			if ( $this->BatchSet->save($this->data) ){
				$this->atimFlash( 'your data has been updated','/datamart/batch_sets/listall/'.$batch_set_id );
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
			$this->data = $batch_set;
		}
	}
	
	function delete($batch_set_id=0){
		$batch_set = $this->BatchSet->find('first',array('conditions'=>array('BatchSet.id'=>$batch_set_id)));
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, true)) {
			return;
		}
		$this->BatchSet->delete( $batch_set_id );
		$this->atimFlash( 'your data has been deleted', '/datamart/batch_sets/index' );
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
		
		if(!empty($this->data)) {
			$deletion_done = false;
			foreach($this->data['BatchSet']['ids'] as $batch_set_id) {
				if(!empty($batch_set_id)) {
					if(!$this->BatchSet->delete( $batch_set_id )) {
						$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					$deletion_done = true;
				}
			}
			if($deletion_done) {
				$this->atimFlash( 'your data has been deleted', '/datamart/batch_sets/index/user' );
			} else {
				 $this->BatchSet->validationErrors[] = 'check at least one element from the batch set';
			}
		}
	}
	
	function remove($batch_set_id) {
		$batch_set = $this->BatchSet->redirectIfNonExistent($batch_set_id, __METHOD__, __LINE__, true);
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, true)){
			return;
		}
				
		// set function variables, makes script readable :)
		$batch_set_id = $batch_set['BatchSet']['id'];
		$batch_set_model = null;
		$lookup_key_name = null;
		if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			$batch_set_model = $datamart_structure['model'];
			$lookup_key_name = $datamart_structure['use_key'];
		}else{
			$batch_set_model = $batch_set['Adhoc']['model'];
			$lookup_key_name = 'id';
		}
		
		if (count($this->data[$batch_set_model][$lookup_key_name])) {
			// START findall criteria
			$criteria = 'set_id="'.$batch_set_id.'" '		
				.'AND ( lookup_id="'.implode( '" OR lookup_id="', $this->data[$batch_set_model][$lookup_key_name] ).'" )';
			
			// get BatchId ROWS and remove from SAVED batch set
			$results = $this->BatchId->find( 'all', array( 'conditions'=>$criteria ) );
			foreach ( $results as $id ) {
				$this->BatchId->delete( $id['BatchId']['id'] );
			}
		}
		
		// redirect back to list Batch SET
		$this->redirect( '/datamart/batch_sets/listall/'.$batch_set_id );
		exit();
		
	}
	
	/**
	 * Cast a given batch set and redirects to it
	 * @param int $batch_set_id
	 * @param boolean $create_new If true, creates a new batch set, otherwise casts the existing batch set 
	 */
	function generic($batch_set_id, $create_new){
		//validate access
		$batch_set = $this->BatchSet->redirectIfNonExistent($batch_set_id, __METHOD__, __LINE__, true);
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, false)) {
			return;
		}
		
		//find compatible datamart structure
		$datamart_structure_id = $this->BatchSet->getCompatibleDatamartStructureId($batch_set['Adhoc']['model']);
		if(!$datamart_structure_id){
			$this->flash(__('this batch set cannot be used to create a generic batch set', true), 'javascript:history.back();', 5);
			return;
		}
		$datamart_structure_data = $this->DatamartStructure->findById($datamart_structure_id);
		if(!AppController::checkLinkPermission($datamart_structure_data['DatamartStructure']['index_link'])){
			$this->flash(__('you are not allowed to use the generic version of that batch set.', true), 'javascript:history.back()');
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
			$this->atimFlash('your data has been updated','/datamart/batch_sets/listall/'.$this->BatchSet->id);
		}else{
			$batch_set['BatchSet']['datamart_adhoc_id'] = null;
			$batch_set['BatchSet']['datamart_structure_id'] = $datamart_structure_id;
			$this->BatchSet->set($batch_set);
			$this->BatchSet->save();
			$this->atimFlash('your data has been updated','/datamart/batch_sets/listall/'.$batch_set_id);
		}
	}
}

?>