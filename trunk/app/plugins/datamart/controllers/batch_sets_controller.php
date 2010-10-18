<?php

class BatchSetsController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.Adhoc', 
		
		'Datamart.BatchSet', 
		'Datamart.BatchId', 
		'Datamart.BatchSetProcess',
		'Datamart.BrowsingResult',
	
		'Inventorymanagement.RealiquotingControl'
	);
	
	var $paginate = array(
		'BatchSet'=>array('limit'=>pagination_amount,'order'=>'BatchSet.created DESC')
	); 
	
	function index( $type_of_list='user' ) {
		$batch_set_filter = array();
		
		switch($type_of_list) {
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
				$this->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list ) );
		$this->Structures->set('querytool_batch_set' );
		
		$this->data = $this->paginate($this->BatchSet, $batch_set_filter);
		foreach($this->data as $key => $data) {
			$this->data[$key]['BatchSet']['count_of_BatchId'] = sizeof($data['BatchId']);
		}		
	}
	
	function listall( $type_of_list='all', $batch_set_id=0 ) {
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list, 'BatchSet.id'=>$batch_set_id ) );
		$this->set( 'atim_structure_for_detail', $this->Structures->get( 'form', 'querytool_batch_set' ) );
		$batch_set = $this->BatchSet->getBatchSet($batch_set_id);

		if(!$this->isUserAuthorizedToProcess($batch_set)) {
			$this->atimFlash('your are not allowed to work on this batchset', '/datamart/batch_sets/index/');
		}

		// add COUNT of IDS to array results, for form list 
		$batch_set['BatchSet']['count_of_BatchId'] = count($batch_set['BatchId']); 
		
		$this->set( 'data_for_detail', $batch_set );
		
		// set VAR to determine if this BATCHSET belongs to USER or to other user in GROUP
		$belong_to_this_user = $batch_set['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id'] ? TRUE : FALSE;
		$this->set( 'belong_to_this_user', $belong_to_this_user );
			
		$this->set( 'atim_structure_for_results', $this->Structures->get( 'form', $batch_set['BatchSet']['form_alias_for_results'] ) );
		$this->set( 'atim_structure_for_process', $this->Structures->get( 'form', 'querytool_batchset_to_processes' ) );
		
		// do search for RESULTS, using THIS->DATA if any
			
		$model_to_import = ( $batch_set['BatchSet']['plugin'] ? $batch_set['BatchSet']['plugin'].'.' : '' ).$batch_set['BatchSet']['model'];
		App::import('Model',$model_to_import);
		
		$this->ModelToSearch = new $batch_set['BatchSet']['model'];
			
		// parse resulting IDs from the SET to build FINDALL criteria for SET's true MODEL 
		$criteria = "";
		$lookup_key_name = $batch_set['BatchSet']['lookup_key_name'];
		$this->set("lookup_key_name", $lookup_key_name);
		$lookup_ids = array();
		foreach ( $batch_set['BatchId'] as $fields ) {
			$lookup_ids[] = $fields['lookup_id'];
		}
		if(count($lookup_ids) > 0){
			$criteria = $batch_set['BatchSet']['model'].'.'.$lookup_key_name." IN ('".implode("', '", $lookup_ids)."')";
		}
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'batch_set_id', $batch_set_id );
		
			// make list of SEARCH RESULTS
	    	
	    	// add FAKE false to criteria if NO criteria/ids
			if ( !$criteria ) {
				$criteria = '1=2';
			} 
				
			if ( $batch_set['BatchSet']['flag_use_query_results'] ) {
	    	
	    		// update DATATABLE names to MODEL names for CTRAPP FORM framework
				$query_to_use = str_replace( '|', '"', $batch_set['BatchSet']['sql_query_for_results'] ); // due to QUOTES and HTML not playing well, PIPES saved to datatable rows instead
				
				// add restrictions to query, inserting BATCH SET IDs to WHERE statement
				$query_to_use = str_replace( 'WHERE TRUE', 'WHERE ('.$criteria.')', $query_to_use );
				
				$results = $this->ModelToSearch->query( $query_to_use ); 
	    		if(count($results) != count($batch_set['BatchId'])){
	    			$msg = __("the batch set contains %d entries but only %d are returned by the query", true);
	    			AppController::addWarningMsg(sprintf($msg, count($batch_set['BatchId']), count($results)));
	    		}
	    	} else {
				$results = $this->ModelToSearch->find( 'all', array( 'conditions'=>$criteria, 'recursive'=>3 ) );
			}
		$this->set( 'results', $results ); // set for display purposes...

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
		
		// get any/all valid PROCESSES for SET's model
		$conditions = array();
		$conditions['BatchSetProcess.plugin'] = $batch_set['BatchSet']['plugin'];
		$conditions['BatchSetProcess.model'] = $batch_set['BatchSet']['model'];
		$batch_set_process_results = $this->BatchSetProcess->find( 'all', array( 'conditions'=>$conditions, 'recursive'=>3 ) );
		
		// add COUNT of IDS to array results, for form list 
		$batch_set_processes = array();
		$batch_set_processes['/datamart/batch_sets/remove/'.$batch_set_id."/"]	= __('remove from batch set', true);
		$batch_set_processes['/csv/csv/'.$batch_set['BatchSet']['plugin']."/".$batch_set['BatchSet']['model']."/".$batch_set['BatchSet']['lookup_key_name']."/".$batch_set['BatchSet']['form_alias_for_results']]		= __('export as CSV file (comma-separated values)', true);

//TODO realiquot in batch process should be defined into datamart_batch_processes
//		if($batch_set['BatchSet']['model'] == "AliquotMaster"){
//			$realiquot_link = '/inventorymanagement/aliquot_masters/realiquot/'.$batch_set_id."/";
//			$this->set("realiquot_link", $realiquot_link);
//			$batch_set_processes[$realiquot_link]		= __('realiquot', true);
//
//			//realiquot into possibilities
//			$realiquot_data_raw = $this->RealiquotingControl->find('all', array('recursive' => 2)); 
//			$realiquot_data = array();
//			foreach($realiquot_data_raw as $data){
//				$realiquot_data[$data['ParentSampleToAliquotControl']['SampleControl']['sample_type']][$data['ParentSampleToAliquotControl']['AliquotControl']['aliquot_type']][$data['ChildSampleToAliquotControl']['AliquotControl']['id']] = $data['ChildSampleToAliquotControl']['AliquotControl']['aliquot_type'];
//
//			}
//			$this->set('realiquot_data', $realiquot_data);
//		}
				
		
		foreach ( $batch_set_process_results as &$value) {
			$batch_set_processes[ $value['BatchSetProcess']['url'] ] = strlen( $value['BatchSetProcess']['name'] ) > 60 ? substr( $value['BatchSetProcess']['name'], 0, 60 ).'...' : __($value['BatchSetProcess']['name'], true);
		}
		$this->set( 'batch_set_processes', $batch_set_processes );
	}
	
	function add( $target_batch_set_id=0 ) {
		
		// check SESSION for adhoc-rpocess data...
		if ( isset($_SESSION['ctrapp_core']) && isset($_SESSION['ctrapp_core']['datamart']) && isset($_SESSION['ctrapp_core']['datamart']['process']) && is_array($_SESSION['ctrapp_core']['datamart']['process']) && count($_SESSION['ctrapp_core']['datamart']['process']) ) {
			$this->data = $_SESSION['ctrapp_core']['datamart']['process'];
		}
		
		// if not an already existing Batch SET...
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
			
			} else if(array_key_exists('node', $this->data)) {
				// use databrowser node id to get BATCHSET field values
				$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->data['node']['id'])));
				$structure = $this->Structures->getFormById($browsing_result['DatamartStructure']['structure_id']);
				if(empty($browsing_result) || empty($structure)) {
					$this->redirect('/pages/err_datamart_system_error', null, true);
				}
				
				$this->data['BatchSet']['plugin'] = $browsing_result['DatamartStructure']['plugin'];
				$this->data['BatchSet']['model'] = $browsing_result['DatamartStructure']['model'];
				$this->data['BatchSet']['lookup_key_name'] = $browsing_result['DatamartStructure']['use_key'];
				$this->data['BatchSet']['form_alias_for_results'] = $structure['Structure']['alias'];
				$this->data['BatchSet']['form_links_for_results'] = ''; 
				$this->data['BatchSet']['flag_use_query_results'] = false;
				$this->data['BatchSet']['sql_query_for_results'] = '';
				
			} else {
				$this->redirect('/pages/err_datamart_system_error', null, true);
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
		if(!$this->isUserAuthorizedToProcess($batch_set)) {
			$this->atimFlash('your are not allowed to work on this batchset', '/datamart/batch_sets/index/');
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
	    	foreach ( $this->data[ $batch_set['BatchSet']['model'] ][ $batch_set['BatchSet']['lookup_key_name'] ] as $integer ) {
	    		$batch_set_ids[] = $integer;
	    	}
	    
			// clean up IDS, removing blanks and duplicates...
			$batch_set_ids = array_unique($batch_set_ids);
			$batch_set_ids = array_filter($batch_set_ids);
			
			foreach ( $batch_set_ids as $integer ) {
				
				// setup ARRAY for ADDING/SAVING
				$save_array = array(
					'id'=>'',
					'set_id'=>$this->data['BatchSet']['id'],
					'lookup_id'=>$integer
				);
				
				// save ID to MODEL
				$this->BatchId->save( $save_array );
				
			}
	    	
	    }
	   
	   // clear SESSION after done...
		$_SESSION['ctrapp_core']['datamart']['process'] = array();
		
		$this->redirect( '/datamart/batch_sets/listall/all/'.$this->data['BatchSet']['id'] );
		exit();
		
	}
	
	function edit( $type_of_list='all', $batch_set_id=0 ) {
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list, 'BatchSet.id'=>$batch_set_id ) );
		$this->Structures->set('querytool_batch_set' );
		
		if ( !empty($this->data) ) {
			$this->BatchSet->id = $batch_set_id;
			if ( $this->BatchSet->save($this->data) ) $this->atimFlash( 'your data has been updated','/datamart/batch_sets/listall/'.$type_of_list.'/'.$batch_set_id );
		} else {
			$batch_set = $this->BatchSet->find('first',array('conditions'=>array('BatchSet.id'=>$batch_set_id)));
			if(!$this->isUserAuthorizedToProcess($batch_set)) {
				$this->atimFlash('your are not allowed to work on this batchset', '/datamart/batch_sets/index/');
			}
			$this->data = $batch_set;
		}
	}
	
	function delete( $type_of_list='all', $batch_set_id=0 ) {
		$batch_set = $this->BatchSet->find('first',array('conditions'=>array('BatchSet.id'=>$batch_set_id)));
		if(!$this->isUserAuthorizedToProcess($batch_set)) {
			$this->atimFlash('your are not allowed to work on this batchset', '/datamart/batch_sets/index/');
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
						$this->redirect('/pages/err_datamart_system_error', null, true);
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
		if(!$this->isUserAuthorizedToProcess($batch_set)) {
			$this->atimFlash('your are not allowed to work on this batchset', '/datamart/batch_sets/index/');
		}
				
		// set function variables, makes script readable :)
		$batch_set_id = $batch_set['BatchSet']['id'];
		$batch_set_model = $batch_set['BatchSet']['model'];
		$lookup_key_name = $batch_set['BatchSet']['lookup_key_name'];
		
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
		$this->redirect( '/datamart/batch_sets/listall/all/'.$batch_set_id );
		exit();
		
	}
	
	function isUserAuthorizedToProcess($batch_set_data) {
		if(empty($batch_set_data) 
		|| (!(array_key_exists('user_id', $batch_set_data['BatchSet'])
		&& array_key_exists('group_id', $batch_set_data['BatchSet'])
		&& array_key_exists('sharing_status', $batch_set_data['BatchSet'])))) {
			$this->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		switch($batch_set_data['BatchSet']['sharing_status']) {
			case 'user' :
				if($batch_set_data['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id']) {
					return true;
				}
				break;
			case 'group' :
				if($batch_set_data['BatchSet']['group_id'] == $_SESSION['Auth']['User']['group_id']) {
					return true;
				}
				break;
			case 'all' :
				return true;
				break;
			default:
				$this->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		return false;
	}	
	
}

?>