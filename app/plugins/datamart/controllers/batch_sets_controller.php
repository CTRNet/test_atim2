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
		foreach($this->data as $key => &$data) {
			$data['BatchSet']['count_of_BatchId'] = sizeof($data['BatchId']);
			if($data['BatchSet']['datamart_structure_id']){
				$id = $data['BatchSet']['datamart_structure_id'];
				if(!isset($datamart_structures[$id])){
					$tmp = $this->DatamartStructure->findById($id);
					$datamart_structures[$id] = $tmp['DatamartStructure']['model']; 
				}
				$this->data[$key]['BatchSet']['model'] = $datamart_structures[$id];
			}
			
			$data['0']['query_type'] = __($data['BatchSet']['flag_use_query_results'] ? 'custom' : 'generic' , true);
		}
	}
	
	function listall($batch_set_id = 0){
		$atim_menu_variables = array('BatchSet.id'=>$batch_set_id, 'BatchSet.temporary_batchset' => false);
		$this->Structures->set('querytool_batch_set', 'atim_structure_for_detail');
		$lookup_ids = array();
		
		if($batch_set_id > 0){
			$batch_set = $this->BatchSet->getBatchSet($batch_set_id);
			if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, false)) {
				return;
			}
			foreach ( $batch_set['BatchId'] as $fields ) {
				$lookup_ids[] = $fields['lookup_id'];
			}
		}else if(isset($_SESSION['tmp_batch_set'])){
			$batch_set['BatchSet'] = array(
				'user_id'				=> $_SESSION['Auth']['User']['id'],
				'datamart_structure_id'	=> $_SESSION['tmp_batch_set']['datamart_structure_id'],
				'title'					=> '<span class="red">'.strtoupper(__('temporary batch set', true)).'</span>',
				'description'			=> '',
				'sharing_status'		=> '',
				'created_by'			=> '',
				'created'				=> AppController::getFormatedDatetimeString(date("Y-m-d H:i")),
				'flag_use_query_results'=> false,
				'locked'				=> false
			);
			$atim_menu_variables['BatchSet.temporary_batchset'] = true;
			$lookup_ids = array_merge($lookup_ids, $_SESSION['tmp_batch_set']['BatchId']);
			$this->set('datamart_structure_id', $_SESSION['tmp_batch_set']['datamart_structure_id']);
		}else{
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		$this->set( 'atim_menu_variables',  $atim_menu_variables);
		
		// add COUNT of IDS to array results, for form list 
		$batch_set['BatchSet']['count_of_BatchId'] = count($lookup_ids);
		$lookup_ids[] = 0; 
		
		// set VAR to determine if this BATCHSET belongs to USER or to other user in GROUP
		$belong_to_this_user = $batch_set['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id'] ? TRUE : FALSE;
		$this->set( 'belong_to_this_user', $belong_to_this_user );
			
		$this->Structures->set( 'datamart_browser_start', 'atim_structure_for_process');
		
		// do search for RESULTS, using THIS->DATA if any
		$this->ModelToSearch = null;
		$datamart_structure = null;
		$atim_structure_for_results = null;
		$criteria = "";
		if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			$batch_set['BatchSet']['model'] = $datamart_structure['model'];
			$batch_set['BatchSet']['plugin'] = $datamart_structure['plugin'];
			$this->ModelToSearch = AppModel::atimNew($datamart_structure['plugin'], $datamart_structure['model'], true);
			$atim_structure_for_results = $this->Structures->getFormById($datamart_structure['structure_id']);
			$batch_set['BatchSet']['form_links_for_results'] = 'detail=>'.$datamart_structure['index_link'];
			$batch_set['BatchSet']['lookup_key_name'] = $datamart_structure['use_key'];
		}else{
			$this->ModelToSearch = AppModel::atimNew($batch_set['BatchSet']['plugin'] ? $batch_set['BatchSet']['plugin'] : '', $batch_set['BatchSet']['model'], true);
			$atim_structure_for_results = $this->Structures->get( 'form', $batch_set['BatchSet']['form_alias_for_results']);
		}
		$batch_set['BatchSet']['checklist_model'] = $batch_set['BatchSet']['model'];
		$batch_set['BatchSet']['checklist_data_key'] = $batch_set['BatchSet']['lookup_key_name'];
			
		// parse resulting IDs from the SET to build FINDALL criteria for SET's true MODEL 
		
		$lookup_key_name = $batch_set['BatchSet']['lookup_key_name'];
		$this->set("lookup_key_name", $lookup_key_name);
		
		if(count($lookup_ids) > 0){
			$criteria = $batch_set['BatchSet']['model'].'.'.$lookup_key_name." IN ('".implode("', '", $lookup_ids)."')";
		}
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'batch_set_id', $batch_set_id );
		
		// make list of SEARCH RESULTS
		$dropdown['model'] = $batch_set['BatchSet']['model'];
		$dropdown['key'] = $batch_set['BatchSet']['lookup_key_name'];
		if($batch_set['BatchSet']['flag_use_query_results']){
    		$batch_set['0']['query_type'] = __('custom', true);
    		// update DATATABLE names to MODEL names for CTRAPP FORM framework
			$query_to_use = str_replace( '|', '"', $batch_set['BatchSet']['sql_query_for_results'] ); // due to QUOTES and HTML not playing well, PIPES saved to datatable rows instead
			
			// add restrictions to query, inserting BATCH SET IDs to WHERE statement
			$query_to_use = str_replace( 'WHERE TRUE', 'WHERE ('.$criteria.')', $query_to_use );
			
			$results = $this->ModelToSearch->query( $query_to_use ); 
    		if(count($results) != count($batch_set['BatchId'])){
    			$msg = __("the batch set contains %d entries but only %d are returned by the query", true)." ".__("to see all elements, convert your batchset using the generic batch set options", true);
    			AppController::addWarningMsg(sprintf($msg, count($batch_set['BatchId']), count($results)));
    		}
    	}else{
    		$batch_set['0']['query_type'] = __('generic', true);
    		if($datamart_structure != null && $datamart_structure['control_master_model']){
				$results = $this->ModelToSearch->find( 'all', array('fields' => array($datamart_structure['control_field']), 'conditions'=>$criteria, 'recursive' => 0, 'group' => $datamart_structure['control_field']) );
				if(count($results) == 1){
					//unique control, load detailed version
					AppModel::atimNew("datamart", "Browser", true);
					$alternate_info = Browser::getAlternateStructureInfo($datamart_structure['plugin'], $datamart_structure['control_model'], $results[0][$datamart_structure['model']][$datamart_structure['control_field']]);

					$criteria = array($datamart_structure['control_master_model'].".id IN ('".implode("', '", $lookup_ids)."')");
					//add the control_id to the search conditions to benefit from direct inner join on detail
					$criteria[$datamart_structure['control_master_model'].".".$datamart_structure['control_field']] = $results[0][$datamart_structure['model']][$datamart_structure['control_field']];
					
					$batch_set['BatchSet']['model'] = $datamart_structure['control_master_model'];
					$this->ModelToSearch = AppModel::atimNew($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
					$atim_structure_for_results = $this->Structures->get('form', $alternate_info['form_alias']);
					$batch_set['BatchSet']['form_links_for_results'] = Browser::updateIndexLink($batch_set['BatchSet']['form_links_for_results'], $datamart_structure['model'], $datamart_structure['control_master_model'], $datamart_structure['use_key'], "id");
					$batch_set['BatchSet']['lookup_key_name'] = 'id';
				}
    		}
			$results = $this->ModelToSearch->find( 'all', array( 'conditions' => $criteria, 'recursive' => 0 ) );
		}
		$this->set( 'results', AppModel::sortWithUrl($results, $this->passedArgs)); // set for display purposes...
		$this->set( 'data_for_detail', $batch_set );
		$this->set( 'atim_structure_for_results', $atim_structure_for_results);
		if(isset($atim_structure_for_results['Structure']['alias'])){
			$batch_set['BatchSet']['structure_alias'] = $atim_structure_for_results['Structure']['alias'];
		}else{
			$tmp = array();
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
				$dropdown['model'], 
				$dropdown['key'],
				$batch_set_id
			);
			if($batch_set_id != 0){
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
			}	
		}

		$this->set('actions', $actions);
		// parse LINKS field in ADHOCS list for links in CHECKLIST
		$ctrapp_form_links = array();
		
		if ( $batch_set['BatchSet']['form_links_for_results'] ) {
			$batch_set['BatchSet']['form_links_for_results'] = explode( '|', $batch_set['BatchSet']['form_links_for_results'] );
			foreach ( $batch_set['BatchSet']['form_links_for_results'] as $exploded_form_links ) {
				$exploded_form_links = explode( '=>', $exploded_form_links );
				$ctrapp_form_links[ $exploded_form_links[0] ]['link'] = $exploded_form_links[1];
				$exploded_link_name =  explode(" ", $exploded_form_links[0]);
				$ctrapp_form_links[ $exploded_form_links[0] ]['icon'] = $exploded_link_name[0];
			}
		}
		
		$this->set( 'ctrapp_form_links', $ctrapp_form_links ); // set for display purposes...
	}
	
	function add( $target_batch_set_id=0 ) {
		// if not an already existing Batch SET...
		$is_generic = $target_batch_set_id == -1;
		if($is_generic){
			$target_batch_set_id = 0;
		}
		if ( !$target_batch_set_id ) {
			// Create new batch set
			if(array_key_exists('Adhoc', $this->data)) {
				// use ADHOC id to get BATCHSET field values
				$adhoc_source = $this->Adhoc->find('first', array('conditions'=>'Adhoc.id="'.$this->data['Adhoc']['id'].'"'));
				
				$this->data['BatchSet']['plugin'] = $adhoc_source['Adhoc']['plugin'];
				$this->data['BatchSet']['model'] = $adhoc_source['Adhoc']['model'];
				$this->data['BatchSet']['lookup_key_name'] = 'id';
				$this->data['BatchSet']['form_alias_for_results'] = $adhoc_source['Adhoc']['form_alias_for_results'];
				$this->data['BatchSet']['form_links_for_results'] = $adhoc_source['Adhoc']['form_links_for_results'] == null ? '' : $adhoc_source['Adhoc']['form_links_for_results']; 
				$this->data['BatchSet']['flag_use_query_results'] = $adhoc_source['Adhoc']['flag_use_query_results'];
				$this->data['BatchSet']['sql_query_for_results'] = $this->data['Adhoc']['sql_query_for_results'];
			
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
				$batch_set_tmp = $this->BatchSet->find('first', array('conditions' => array('BatchSet.id' => $this->data['BatchSet']['id']), 'recursive' => -1));
				unset($this->data['BatchSet']['id']);
				if($is_generic){
					$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('OR' => array('DatamartStructure.model' => $batch_set_tmp['BatchSet']['model'], 'DatamartStructure.control_master_model' => $batch_set_tmp['BatchSet']['model']))));
					if(empty($datamart_structure)){
						$this->flash(__('this batch set cannot be used to create a generic batch set', true), 'javascript:history.back();', 5);
						return;
					}
					$this->data['BatchSet']['datamart_structure_id'] = $datamart_structure['DatamartStructure']['id'];
				}else{
					$to_copy = array('plugin', 'model', 'lookup_key_name', 'form_alias_for_results', 'form_links_for_results', 'flag_use_query_results', 'sql_query_for_results', 'datamart_structure_id');
					foreach($to_copy as $key){
						$this->data['BatchSet'][$key] = $batch_set_tmp['BatchSet'][$key];
					}
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
		
	    
		if($batch_set['BatchSet']['datamart_structure_id']){
			$datamart_structure = $this->DatamartStructure->findById($batch_set['BatchSet']['datamart_structure_id']);
			$datamart_structure = $datamart_structure['DatamartStructure'];
			if($datamart_structure['control_master_model']){
				$batch_set['BatchSet']['model'] = $datamart_structure['control_master_model'];
				if(isset($this->data[$datamart_structure['model']])){
					$tmp = $this->data[$datamart_structure['model']];
					$batch_set['BatchSet']['lookup_key_name'] = $datamart_structure['use_key'];
				}else{
					$tmp = $this->data[$datamart_structure['control_master_model']];
					$batch_set['BatchSet']['lookup_key_name'] = 'id';
				}
				unset($this->data[$datamart_structure['model']]);
				$this->data[$datamart_structure['control_master_model']] = $tmp;
				
			}else{
				$batch_set['BatchSet']['model'] = $datamart_structure['model'];
			}
			$batch_set['BatchSet']['plugin'] = $batch_set['BatchSet']['plugin'];
		}else{
			$datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array('control_master_model' => $batch_set['BatchSet']['model']), 'fields' => array('model', 'use_key'), 'recursive' => -1));
			if(!empty($datamart_structure) && isset($this->data[$datamart_structure['DatamartStructure']['model']])){
				//convert to current model (eg.: ViewSample -> SampleMaster)
				$batch_set['BatchSet']['model'] = $datamart_structure['DatamartStructure']['model'];
				$batch_set['BatchSet']['lookup_key_name'] = $datamart_structure['DatamartStructure']['use_key'];
			}
		}
		
		$batch_set_ids = array();
		// find compatible MODEL in DATA
	   	if ( isset($this->data[ $batch_set['BatchSet']['model'] ]) ) {
	    	
	   		// add existing set IDS to array
	    	foreach ( $batch_set['BatchId'] as $array ) {
	    		$batch_set_ids[] = $array['lookup_id'];
	    	
	    		// remove from SAVED batch set
	    		$this->BatchId->delete( $array['id'] );
	    	}
	    
	   	 	// add existing set IDS to array
	   	 	if(is_array($this->data[ $batch_set['BatchSet']['model'] ][ $batch_set['BatchSet']['lookup_key_name'] ])){
	   	 		$batch_set_ids = array_merge($this->data[ $batch_set['BatchSet']['model'] ][ $batch_set['BatchSet']['lookup_key_name'] ], $batch_set_ids);
	   	 	}else{
	   	 		$batch_set_ids = array_merge(explode(",", $this->data[ $batch_set['BatchSet']['model'] ][ $batch_set['BatchSet']['lookup_key_name'] ]), $batch_set_ids);
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
				
				// save ID to MODEL
				
			}
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
		$user_batchsets = $this->BatchSet->find('all', array('conditions' => $available_batchsets_conditions, 'order'=>'BatchSet.created DESC'));
		foreach($user_batchsets as $key => $tmp_data) {
			$user_batchsets[$key]['BatchSet']['count_of_BatchId'] = count($tmp_data['BatchId']); 
		}
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
		$batch_set = $this->BatchSet->getBatchSet($batch_set_id);
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
			$batch_set_model = $batch_set['BatchSet']['model'];
			$lookup_key_name = $batch_set['BatchSet']['lookup_key_name'];
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
		$batch_set = $this->BatchSet->getBatchSet($batch_set_id);
		if(!$this->BatchSet->isUserAuthorizedToRw($batch_set, false)) {
			return;
		}
		
		//find compatible datamart structure
		$datamart_structure_id = $this->BatchSet->getCompatibleDatamartStructureId($batch_set['BatchSet']['model']);
		if(!$datamart_structure_id){
			$this->flash(__('this batch set cannot be used to create a generic batch set', true), 'javascript:history.back();', 5);
			return;
		}
		$batch_set['BatchSet']['datamart_structure_id'] = $datamart_structure_id;
		
		//clearand unset fields
		foreach(array('sql_query_for_results', 'form_alias_for_results', 'form_links_for_results') as $clear_key){
			$batch_set['BatchSet'][$clear_key] = "";
		}
		foreach(array('created', 'created_by', 'modified', 'modified_by') as $unset_key){
			unset($batch_set['BatchSet'][$unset_key]);
		}
		$batch_set['BatchSet']['flag_use_query_results'] = false;
		
		if($create_new){
			unset($batch_set['BatchSet']['id']);
			$this->BatchSet->set($batch_set);
			$this->BatchSet->save();
			$ids = array();
			foreach($batch_set['BatchId'] as $id){
				$ids[] = array("set_id" => $this->BatchSet->id, "lookup_id" => $id['lookup_id']);
			}
			$this->BatchId->saveAll($ids);
			$this->atimFlash('your data has been updated','/datamart/batch_sets/listall/'.$this->BatchSet->id);
		}else{
			$this->BatchSet->set($batch_set);
			$this->BatchSet->save();
			$this->atimFlash('your data has been updated','/datamart/batch_sets/listall/'.$batch_set_id);
		}
	}
}

?>