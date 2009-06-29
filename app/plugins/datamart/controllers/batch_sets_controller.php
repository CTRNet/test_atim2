<?php

class BatchSetsController extends DatamartAppController {
	
	var $uses = array('Datamart.BatchSet', 'Datamart.BatchId', 'Datamart.BatchSetProcess');
	var $paginate = array('BatchSet'=>array('limit'=>10,'order'=>'BatchSet.description ASC')); 
	
	function index( $group=NULL ) {
		
		if ( !isset($_SESSION['BatchSet_filter']) || !$group ) {
			$_SESSION['BatchSet_filter'] = array();
			$_SESSION['BatchSet_filter']['BatchSet.user_id'] = $_SESSION['Auth']['User']['id'];
		} else {
			$_SESSION['BatchSet_filter'] = array();
			$_SESSION['BatchSet_filter']['BatchSet.group_id'] = $_SESSION['Auth']['User']['group_id'];
		}
		
		$this->set( 'atim_menu_variables', array( 'Param.Group'=>$group ) );
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'querytool_batch_set' ) );
		
		$this->data = $this->paginate($this->BatchSet, $_SESSION['BatchSet_filter']);
		
	}
	
	
	/*
	function index( $group=NULL ) {
		
		// clear SESSION info
		$_SESSION['ctrapp_core']['datamart']['process'] = NULL;
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-3', NULL );
		$ctrapp_menu[] = $group ? $this->Menus->tabs( 'qry-CAN-3', 'qry-CAN-5', NULL ) : $this->Menus->tabs( 'qry-CAN-3', 'qry-CAN-4', NULL );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('querytool_batch_set') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build(0) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		$criteria = array();
		$criteria[] = $group ? 'BatchSet.group_id="'.$this->othAuth->group('id').'"' : 'BatchSet.user_id="'.$this->othAuth->user('id').'"';
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		
		$result = $this->BatchSet->findAll( $criteria, NULL, $order, $limit, $page, 2 );
		
		// ERROR if no results
		if ( !is_array($result) || !count($result) ) { 
			$result = array(array()); 
		} else {
			// add COUNT of IDS to array results, for form list 
			foreach ( $result as &$value) {
				$value['BatchSet']['count_of_BatchId'] = count($value['BatchId']);
			}
		}
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'group', $group );
		$this->set( 'batch_sets', $result );
		
	}
	
	function listall( $batch_set_id=0 ) {
		
		// clear SESSION info
		$_SESSION['ctrapp_core']['datamart']['process'] = NULL;
		
		// get Adhoc for source info 
		$criteria = array();
		$criteria[] = 'BatchSet.id="'.$batch_set_id.'"';
		$criteria[] = 'BatchSet.group_id="'.$this->othAuth->group('id').'" OR BatchSet.user_id="'.$this->othAuth->user('id').'"';
		$batch_set = $this->BatchSet->find( $criteria );
		
		$this->set( 'ctrapp_form_for_ids', $this->Forms->getFormArray( $batch_set['BatchSet']['form_alias_for_results'] ) );
	    
		// ERROR if no results
		if ( !is_array($batch_set) || !count($batch_set) ) { $this->redirect('/pages/error'); exit; }
		
			// add COUNT of IDS to array results, for form list 
			$batch_set['BatchSet']['count_of_BatchId'] = count($batch_set['BatchId']); 
		$this->set( 'batch_set', $batch_set ); // set for display purposes...
		
		$belong_to_this_user = $batch_set['BatchSet']['user_id']==$this->othAuth->user('id') ? TRUE : FALSE;
		$this->set( 'belong_to_this_user', $belong_to_this_user );
		
		$group = $batch_set['BatchSet']['group_id']==$this->othAuth->group('id') ? 'group' : '';
		$this->set( 'group', $group );
		
		// get any/all valid PROCESSES for SET's model
		$criteria = array();
		$criteria[] = 'model="'.$batch_set['BatchSet']['model'].'"';
		$batch_set_process_results = $this->BatchSetProcess->findall( $criteria, NULL, NULL, NULL, NULL, 3 );
		$this->set( 'batch_set_processes', $batch_set_process_results );
		
		// start new instance of QUERY's model, and search it using QUERY's parsed SQL 
		$this->ModelToSearch = new $batch_set['BatchSet']['model'];
		
		// parse resulting IDs from the SET to build FINDALL criteria for SET's true MODEL 
		$criteria = array();
		foreach ( $batch_set['BatchId'] as $fields ) {
			$criteria[] = $batch_set['BatchSet']['model'].'.id="'.$fields['lookup_id'].'"';
		}
		$criteria = implode( ' OR ', $criteria );
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-3', NULL );
		$ctrapp_menu[] = $group ? $this->Menus->tabs( 'qry-CAN-3', 'qry-CAN-5', NULL ) : $this->Menus->tabs( 'qry-CAN-3', 'qry-CAN-4', NULL );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form_for_set', $this->Forms->getFormArray('querytool_batch_set') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build(0) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
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
				if ( substr_count( $query_to_use, 'WHERE' )>=2 || substr_count( $query_to_use, 'WHERE TRUE AND' )>=1 ) {
					$query_to_use = str_replace( 'WHERE TRUE AND ', 'WHERE TRUE  AND ('.$criteria.') AND ', $query_to_use );
				} else {
					$query_to_use = str_replace( 'WHERE', 'WHERE ('.$criteria.') AND ', $query_to_use );
				}
				
				// add restrictions to QUERY, inserting BATCH SET IDs to WHERE statement (using PREG REPLACE to find a WHERE statement NOT inside a sub query)
				// $query_to_use = preg_replace( '^(?!\\(.*)WHERE(?!.*\\))^', 'WHERE ('.$criteria.') AND', $query_to_use );
				
				$results = $this->ModelToSearch->query( $query_to_use ); 
	    	
	    	} else {
				$results = $this->ModelToSearch->findall( $criteria, NULL, NULL, NULL, NULL, 3 );
			}
			
		// parse LINKS field in ADHOCS list for links in CHECKLIST
		
			$ctrapp_form_links = array();
			
			if ( $batch_set['BatchSet']['form_links_for_results'] ) {
				$batch_set['BatchSet']['form_links_for_results'] = explode( '|', $batch_set['BatchSet']['form_links_for_results'] );
				foreach ( $batch_set['BatchSet']['form_links_for_results'] as $exploded_form_links ) {
					$exploded_form_links = explode( '=>', $exploded_form_links );
					$ctrapp_form_links[ $exploded_form_links[0] ] = $exploded_form_links[1];
				}
			}
			
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'results', $results ); // set for display purposes...
		$this->set( 'ctrapp_form_links', $ctrapp_form_links ); // set for display purposes...
						
	}
	
	function add( $batch_set_id=0 ) {
		
		// if not an already existing Batch SET...
		if ( !$this->data['BatchSet']['id'] ) {
			
			// generate TEMP description for this SET
			$this->data['BatchSet']['description'] = '(unlabelled set generated on '.date('M d Y').')';
			
			// save hidden MODEL value as new BATCH SET
			$this->data['BatchSet']['user_id'] = $this->othAuth->user('id');
			$this->BatchSet->save( $this->data['BatchSet'] );
			
			// get new SET id, and save
			$this->data['BatchSet']['id'] = $this->BatchSet->getLastInsertId();
			
		}
		
		// get BatchSet for source info 
		$this->BatchSet->id = $this->data['BatchSet']['id'];
	   $batch_set = $this->BatchSet->read();
	    
		$batch_set_ids = array();
		
		// find compatible MODEL in DATA
	   	if ( isset($this->data[ $batch_set['BatchSet']['model'] ]) ) {
	    	
	   		// add existing set IDS to array
	    	foreach ( $batch_set['BatchId'] as $array ) {
	    		$batch_set_ids[] = $array['lookup_id'];
	    	
	    		// remove from SAVED batch set
	    		$this->BatchId->del( $array['id'] );
	    	}
	    
	   	 	// add existing set IDS to array
	    	foreach ( $this->data[ $batch_set['BatchSet']['model'] ]['id'] as $integer ) {
	    		$batch_set_ids[] = $integer;
	    	}
	    
			// clean up IDS, removing blanks and duplicates...
			$batch_set_ids = array_unique($batch_set_ids);
			$batch_set_ids = array_filter($batch_set_ids);
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
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
	    
	    $this->redirect( '/datamart/batch_sets/listall/'.$this->data['BatchSet']['id'] );
	    exit();
		
	}
	
	function edit( $batch_set_id=0 ) {
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('batch_set') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-3', NULL );
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-3', 'qry-CAN-4', NULL );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('querytool_batch_set') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build(0) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'batch_set_id', $batch_set_id );
		
		if ( empty($this->data) ) {
			
			// get Adhoc for source info 
			$criteria = array();
			$criteria[] = 'BatchSet.id="'.$batch_set_id.'"';	
			$criteria[] = 'BatchSet.user_id="'.$this->othAuth->user('id').'"';
			$this->data = $this->BatchSet->find( $criteria );
			
			// ERROR if no results
			if ( !is_array($this->data) || !count($this->data) ) { $this->redirect('/pages/error'); exit; }
			
			$this->data['BatchSet']['count_of_BatchId'] = count($this->data['BatchId']); // add COUNT of IDS to array results, for form list 
			$this->data['BatchSet']['share_set_with_group'] = $this->data['BatchSet']['group_id'] ? 'yes' : 'no';
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			$this->set( 'data', $this->data ); // set for display purposes...
			
		} else {
			
			if ( $this->data['BatchSet']['share_set_with_group']=='yes' ) {
				$this->data['BatchSet']['group_id'] = $this->othAuth->group('id');
			} else {
				$this->data['BatchSet']['group_id'] = 0;
			}
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			if ( $this->BatchSet->save( $this->data['BatchSet'] ) ) {
				$this->flash( 'Your data has been updated.', '/batch_sets/listall/'.$batch_set_id );
			}
			
		}
		
	}
	
	function remove( $batch_set_id=0 ) {
		
		// set function variables, makes script readable :)
		$batch_set_id = $_SESSION['ctrapp_core']['datamart']['process']['BatchSet']['id'];
		$batch_set_model = $_SESSION['ctrapp_core']['datamart']['process']['BatchSet']['model'];
		
		if ( isset( $_SESSION['ctrapp_core']['datamart']['process'][ $batch_set_model ] ) ) {
			$batch_id_array = $_SESSION['ctrapp_core']['datamart']['process'][ $batch_set_model ]['id'];
		} else {
			$batch_id_array = array();
		}
		
		if ( count( $batch_id_array ) ) {
			
			// START findall criteria
			$criteria = 'set_id="'.$batch_set_id.'"';
			
			// add SESSION id array to criteria
			$criteria .= 'AND ( lookup_id="'.implode( '" OR lookup_id="', $batch_id_array ).'" )';
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			// get BatchId ROWS
			$results = $this->BatchId->findall( $criteria );
			foreach ( $results as $id ) {
				// remove from SAVED batch set
				$this->BatchId->del( $id['BatchId']['id'] );
			}
			
		}
		
		// redirect back to list Batch SET
		$this->redirect( '/datamart/batch_sets/listall/'.$batch_set_id );
		exit();
		
	}
	
	function delete( $batch_set_id=0 ) {
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->BatchSet->del( $batch_set_id );
		$this->flash( 'Your data has been deleted.', '/batch_sets/index/' );
		
	}
	
	function process( $batch_set_id=0 ) {
		
		// clear SESSION info
		$_SESSION['ctrapp_core']['datamart']['process'] = $this->data;
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->redirect( $this->data['BatchSet']['process'] );
		exit();
	
	}
	
	function csv( $batch_set_id=0 ) {
		
		// set function variables, makes script readable :)
		$batch_set_id = $_SESSION['ctrapp_core']['datamart']['process']['BatchSet']['id'];
		$batch_set_model = $_SESSION['ctrapp_core']['datamart']['process']['BatchSet']['model'];
		
		if ( isset( $_SESSION['ctrapp_core']['datamart']['process'][ $batch_set_model ] ) ) {
			$batch_id_array = $_SESSION['ctrapp_core']['datamart']['process'][ $batch_set_model ]['id'];
		} else {
			$batch_id_array = array();
		}
		
		// get Adhoc for source info 
		$criteria = 'BatchSet.id="'.$batch_set_id.'"';	
		$batch_set = $this->BatchSet->find( $criteria );
		
		$this->set( 'ctrapp_form_for_ids', $this->Forms->getFormArray( $batch_set['BatchSet']['form_alias_for_results'] ) );
	    
	    // ERROR if no results
		if ( !is_array($batch_set) || !count($batch_set) ) { $this->redirect('/pages/error'); exit; }
			
			// add COUNT of IDS to array results, for form list 
			$batch_set['BatchSet']['count_of_BatchId'] = count($batch_set['BatchId']); 
		$this->set( 'batch_set', $batch_set ); // set for display purposes...
		
		// start new instance of QUERY's model, and search it using QUERY's parsed SQL 
		$this->ModelToSearch = new $batch_set['BatchSet']['model'];
		
			$criteria = array();
			
				if ( count($batch_id_array) ) {
				
					foreach ( $batch_id_array as $id ) {
						$criteria[] = $batch_set['BatchSet']['model'].'.id="'.$id.'"';
					}
				
				} else {
				
					// parse resulting IDs from the SET to build FINDALL criteria for SET's true MODEL 
					foreach ( $batch_set['BatchId'] as $fields ) {
						$criteria[] = $batch_set['BatchSet']['model'].'.id="'.$fields['lookup_id'].'"';
					}
					
				}
			
			$criteria = implode( ' OR ', $criteria );
		
		// make list of SEARCH RESULTS
	    	
	    	// add FAKE false to criteria if NO criteria/ids
			if ( !$criteria ) {
				$criteria = '1=2';
			} 
				
			if ( $batch_set['BatchSet']['flag_use_query_results'] ) {
	    	
	    		// update DATATABLE names to MODEL names for CTRAPP FORM framework
				$query_to_use = str_replace( '|', '"', $batch_set['BatchSet']['sql_query_for_results'] ); // due to QUOTES and HTML not playing well, PIPES saved to datatable rows instead
				
				// add restrictions to query, inserting BATCH SET IDs to WHERE statement
				if ( substr_count( $query_to_use, 'WHERE' )>=2 ) {
					$query_to_use = str_replace( 'WHERE TRUE AND ', 'WHERE TRUE  AND ('.$criteria.') AND ', $query_to_use );
				} else {
					$query_to_use = str_replace( 'WHERE', 'WHERE ('.$criteria.') AND ', $query_to_use );
				}
				
				// add restrictions to QUERY, inserting BATCH SET IDs to WHERE statement (using PREG REPLACE to find a WHERE statement NOT inside a sub query)
				// $query_to_use = preg_replace( '^(?!\\(.*)WHERE(?!.*\\))^', 'WHERE ('.$criteria.') AND', $query_to_use );
				
				$results = $this->ModelToSearch->query( $query_to_use ); 
	    	
	    	} else {
				$results = $this->ModelToSearch->findall( $criteria, NULL, NULL, NULL, NULL, 3 );
			}
			
			$this->set( 'results', $results ); // set for display purposes...
		
		// set DISPLAY vars, for CSV
		$this->layout = 'csv';
		$this->pageTitle = 'ctrapp_batch_set';
			
	}
	
	*/

}

?>