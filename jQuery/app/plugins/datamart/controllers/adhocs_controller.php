<?php

class AdhocsController extends DatamartAppController {
	
	var $uses = array(
		'Datamart.Adhoc', 
		'Datamart.AdhocFavourite',
		'Datamart.AdhocSaved', 
		
		'Datamart.BatchSet',
		'Datamart.BatchId'
	);
	
	var $paginate = array(
		'Adhoc'				=>array('limit'=>pagination_amount,'order'=>'Adhoc.description ASC'),
		'AdhocFavourite'	=>array('limit'=>pagination_amount,'order'=>'Adhoc.description ASC'),
		'AdhocSaved'		=>array('limit'=>pagination_amount,'order'=>'Adhoc.description ASC')
	); 
	
	function index( $type_of_list='all' ) {
		
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list ) );
		$this->Structures->set('querytool_adhoc' );
		
		if ( !$type_of_list || $type_of_list=='all' ) {
			$this->data = $this->paginate($this->Adhoc);
		} else if ( $type_of_list=='favourites' ) {
			$this->data = $this->paginate($this->AdhocFavourite, array('AdhocFavourite.user_id'=>$_SESSION['Auth']['User']['id']));
		} else if ( $type_of_list=='saved' ) {
			$this->data = $this->paginate($this->AdhocSaved, array('AdhocSaved.user_id'=>$_SESSION['Auth']['User']['id']));
		}
	}
	
	// save IDs to Lookup, avoid duplicates
	function favourite( $type_of_list='all', $adhoc_id=0 ) {
		$favourite_result = $this->Adhoc->query('DELETE FROM datamart_adhoc_favourites WHERE adhoc_id="'.$adhoc_id.'" AND user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$favourite_result = $this->Adhoc->query('INSERT INTO datamart_adhoc_favourites SET adhoc_id="'.$adhoc_id.'", user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$this->flash( 'Query has been marked as one of your favourites.', '/datamart/adhocs/search/favourites/'.$adhoc_id );
	}
	
	// remove IDs from Lookup
	function unfavourite( $type_of_list='all', $adhoc_id=0 ) {
		$favourite_result = $this->Adhoc->query('DELETE FROM datamart_adhoc_favourites WHERE adhoc_id="'.$adhoc_id.'" AND user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$this->flash( 'Query is no longer one of your favourites.', '/datamart/adhocs/search/all/'.$adhoc_id );
	}
	
	function search( $type_of_list='all', $adhoc_id=0  ) {
		
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list, 'Adhoc.id'=>$adhoc_id ) );
		$this->set( 'atim_structure_for_detail', $this->Structures->get( 'form', 'querytool_adhoc' ) );
		
		// BIND models on the fly...
		$this->Adhoc->bindModel(
			  array('hasMany' => array(
						 'AdhocFavourite'	=> array(
								'className'  	=> 'AdhocFavourite',
								'conditions'	=> 'AdhocFavourite.user_id="'.$_SESSION['Auth']['User']['id'].'"',
								'foreignKey'	=> 'adhoc_id',
								'dependent'		=> true
						 ),
						 'AdhocSaved'	=> array(
								'className'  	=> 'AdhocSaved',
								'conditions'	=> 'AdhocSaved.user_id="'.$_SESSION['Auth']['User']['id'].'"',
								'foreignKey'	=> 'adhoc_id',
								'dependent'		=> true
						 )
					)
			  )
		 );
		
		$data_for_detail = $this->Adhoc->find('first', array('conditions'=>array('Adhoc.id'=>$adhoc_id), 'limit'=>4));
		$this->set( 'data_for_detail', $data_for_detail );
		
		$this->set( 'atim_structure_for_form', $this->Structures->get( 'form', $data_for_detail['Adhoc']['form_alias_for_search'] ) );
		
	}
	
	function results( $type_of_list='all', $adhoc_id=0 ) {

		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list, 'Adhoc.id'=>$adhoc_id ) );
		$this->set( 'atim_structure_for_detail', $this->Structures->get( 'form', 'querytool_adhoc' ) );
		
		// $this->data = $this->Forms->clearUpDataArrayForSearches($this->data, array('clearBlankDates'=>false));
			
			// BIND models on the fly...
			$this->Adhoc->bindModel(
				  array('hasMany' => array(
							 'AdhocFavourite'	=> array(
									'className'  	=> 'AdhocFavourite',
									'conditions'	=> 'AdhocFavourite.user_id="'.$_SESSION['Auth']['User']['id'].'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 ),
							 'AdhocSaved'	=> array(
									'className'  	=> 'AdhocSaved',
									'conditions'	=> 'AdhocSaved.user_id="'.$_SESSION['Auth']['User']['id'].'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 )
						)
				  )
			 );
			
			$adhoc = $this->Adhoc->find( 'first', array( 'conditions'=>array('Adhoc.id'=>$adhoc_id) ) );
	   	$this->set( 'data_for_detail', $adhoc );
			// $this->set( 'adhoc', $adhoc ); // set for display purposes...
		
		$this->set( 'atim_structure_for_results', $this->Structures->get( 'form', $adhoc['Adhoc']['form_alias_for_results'] ) );
		
		$this->set( 'atim_structure_for_add', $this->Structures->get( 'form', 'querytool_adhoc_to_batchset' ) );
		
		
		
		
		
		
		// do search for RESULTS, using THIS->DATA if any
		
			// start new instance of QUERY's model, and search it using QUERY's parsed SQL 
			
			$model_to_import = ( $adhoc['Adhoc']['plugin']? $adhoc['Adhoc']['plugin'].'.' : '' ).$adhoc['Adhoc']['model'];
			App::import('Model',$model_to_import);
			
			$this->ModelToSearch = new $adhoc['Adhoc']['model'];
				
			// parse resulting IDs from the SQL to build FINDALL criteria for QUERY's true MODEL 
			$criteria = array();
			
			// parse FORM inputs to popultate QUERY's sql properly 
			$sql_query_with_search_terms = $adhoc['Adhoc']['sql_query_for_results'];
			$sql_query_without_search_terms = $adhoc['Adhoc']['sql_query_for_results'];
			
			$conditions = $this->Structures->parse_search_conditions($this->Structures->get('form', $adhoc['Adhoc']['form_alias_for_results']));
			//rename the keys to make them ready for parse_sql_conditions
			foreach($conditions as $key => $value){
				if(strpos($key, " >=") == strlen($key) - 3){
					$conditions[substr($key, 0, strlen($key) - 3)."_start"] = $value;
					unset($conditions[$key]);
				}else if(strpos($key, " <=") == strlen($key) - 3){
					$conditions[substr($key, 0, strlen($key) - 3)."_end"] = $value;
					unset($conditions[$key]);
				}else if(strpos($key, " LIKE") == strlen($key) - 3){
					$conditions[substr($key, 0, strlen($key) - 5)] = $value;
					unset($conditions[$key]);
				}
				
			}
			
			// if SEARCH form data, parse and create conditions
			$criteria = array();
			
			if ( $adhoc['Adhoc']['sql_query_for_results'] ) {
				list( $sql_query_with_search_terms, $sql_query_without_search_terms ) = $this->Structures->parse_sql_conditions( $adhoc['Adhoc']['sql_query_for_results'], $conditions );
				
				$ids = $this->ModelToSearch->query( $sql_query_with_search_terms );
				
				foreach ( $ids as $array ) {
					foreach ( $array as $id_model=>$id_fields ) {
						if ( $id_model==$adhoc['Adhoc']['model'] ) {
							$criteria[] = $adhoc['Adhoc']['model'].'.id="'.$id_fields['id'].'"';
						}
					}
				}
				
				$criteria = implode( ' OR ', $criteria );
				
				if ( !$criteria ) {
					$criteria = $adhoc['Adhoc']['model'].'.id="-1"';
				}
				
			} else if ( $this->data ) {
				
				$criteria = $this->Forms->getSearchConditions( $this->data, $ctrapp_form );
				
			}

		// make list of SEARCH RESULTS
			
			// due to QUOTES and HTML code, save as PIPES in datatable ROWS
			$sql_query_with_search_terms = str_replace( '"', '|', $sql_query_with_search_terms );
			$sql_query_without_search_terms = str_replace( '"', '|', $sql_query_without_search_terms );
			
			if ( $adhoc['Adhoc']['flag_use_query_results'] && $adhoc['Adhoc']['sql_query_for_results'] ) {
	    		$this->set( 'final_query', $sql_query_without_search_terms );
	    		$results = $ids;
			} else {
				$this->set('final_query', '');
				$results = $this->ModelToSearch->find( 'all', array('conditions'=>$criteria, 'recursive'=>3) );
				// $results = $this->ModelToSearch->findall( $criteria, NULL, NULL, NULL, NULL, 3 );
			}
			
			$this->set( 'results', $results ); // set for display purposes...
		
		// parse LINKS field in ADHOCS list for links in CHECKLIST
		
			$ctrapp_form_links = array();
			
			if ( $adhoc['Adhoc']['form_links_for_results'] ) {
				$adhoc['Adhoc']['form_links_for_results'] = explode( '|', $adhoc['Adhoc']['form_links_for_results'] );
				foreach ( $adhoc['Adhoc']['form_links_for_results'] as $exploded_form_links ) {
					$exploded_form_links = explode( '=>', $exploded_form_links );
					$ctrapp_form_links[ $exploded_form_links[0] ] = $exploded_form_links[1];
				}
			}
			
			$this->set( 'ctrapp_form_links', $ctrapp_form_links ); // set for display purposes...
			
		// get list of compatible BATCHES (matching model), for form PULLDOWN
			
			$criteria = array();
			
			if ( $adhoc['Adhoc']['flag_use_query_results'] ) {
				$criteria[] = 'flag_use_query_results = "1"';
				$criteria[] = 'model = "'.$adhoc['Adhoc']['model'].'"';
				$criteria[] = 'sql_query_for_results = "'.$sql_query_without_search_terms.'"';
			} else {
				$criteria[] = 'flag_use_query_results = "0"';
				$criteria[] = 'model = "'.$adhoc['Adhoc']['model'].'"';
			}
			
			$criteria[] = 'BatchSet.user_id="'.$_SESSION['Auth']['User']['id'].'"';
			$batch_set_results = $this->BatchSet->find( 'all', array('conditions'=>$criteria, 'recursive'=>2) );
			
			// add COUNT of IDS to array results, for form list 
			$batch_sets = array();
			
			$batch_sets['Add to a compatible Datamart batch...'] = array();
				$batch_sets['Add to a compatible Datamart batch...'][0] = 'new batch set';
				foreach ( $batch_set_results as &$value) {
					$batch_sets['Add to a compatible Datamart batch...'][ '/datamart/batch_sets/add/'.$value['BatchSet']['id'] ] = strlen( $value['BatchSet']['description'] )>60 ? substr( $value['BatchSet']['description'], 0, 60 ).'...' : $value['BatchSet']['description'];
				}
			$batch_sets['Pass to another process...'] = array();
				$batch_sets['Pass to another process...']['/datamart/adhocs/csv'] = 'export as comma-separated file';
			
		// save THIS->DATA (if any) for Saved Search
			
			$save_this_search_data = array();
			
			foreach ( $this->data as $model=>$subarray ) {
				foreach ( $subarray as $field_name=>$field_value ) {
					if ( !is_array($field_value) && trim($field_value) ) {
						$save_this_search_data[] = $model.'.'.$field_name.'='.$field_value;
					}
				}
			}
			
			$save_this_search_data = implode('|',$save_this_search_data);
			
			if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
			$_SESSION['ctrapp_core']['datamart']['search_criteria'] = $save_this_search_data;
		// save for display
			
			$this->set( 'save_this_search_data', $save_this_search_data );
			$this->set( 'batch_sets', $batch_sets );
	}
	
	function process() {
		
		if ( !isset($this->data['Adhoc']['process']) || !$this->data['Adhoc']['process'] ) {
			$this->data['Adhoc']['process'] = '/datamart/batch_sets/add';
		}
		
		$_SESSION['ctrapp_core']['datamart']['process'] = $this->data;
		
		$this->redirect( $this->data['Adhoc']['process'] );
		exit();
		
	}
	
	function csv() {
		
		// set function variables, makes script readable :)
		$adhoc_id = $_SESSION['ctrapp_core']['datamart']['process']['Adhoc']['id'];
		
		// get BATCHSET for source info 
			
			$conditions = array( 'Adhoc.id' => $adhoc_id );
			$adhoc_result = $this->Adhoc->find( 'first', array( 'conditions'=>$conditions ) ); 
			
		$this->Structures->set($adhoc_result['Adhoc']['form_alias_for_results'] );
		
		
		// use adhoc MODEl info to find session IDs
		$adhoc_model = $adhoc_result['Adhoc']['model'];
		
		if ( isset( $_SESSION['ctrapp_core']['datamart']['process'][ $adhoc_model ] ) ) {
			$adhoc_id_array = $_SESSION['ctrapp_core']['datamart']['process'][ $adhoc_model ]['id'];
		} else {
			$adhoc_id_array = array();
		}
		
		
		
		
		// do search for RESULTS, using THIS->DATA if any
			
			$model_to_import = ( $adhoc_result['Adhoc']['plugin'] ? $adhoc_result['Adhoc']['plugin'].'.' : '' ).$adhoc_result['Adhoc']['model'];
			App::import('Model',$model_to_import);
			
			$this->ModelToSearch = new $adhoc_model;
				
			// parse resulting IDs from the SET to build FINDALL criteria for SET's true MODEL 
			$criteria = array();
			foreach ( $adhoc_id_array as $field_id ) {
				$criteria[] = $adhoc_model.'.id="'.$field_id.'"';
			}
			$criteria = implode( ' OR ', $criteria );
			
				// make list of SEARCH RESULTS
		    	
		    	// add FAKE false to criteria if NO criteria/ids
				if ( !$criteria ) {
					$criteria = '1=2';
				} 
					
				if ( $adhoc_result['Adhoc']['flag_use_query_results'] ) {
		    	
		    		// update DATATABLE names to MODEL names for CTRAPP FORM framework
					$query_to_use = str_replace( '|', '"', $_SESSION['ctrapp_core']['datamart']['process']['Adhoc']['sql_query_for_results'] ); // due to QUOTES and HTML not playing well, PIPES saved to datatable rows instead
					
					// add restrictions to query, inserting BATCH SET IDs to WHERE statement
					if ( substr_count( $query_to_use, 'WHERE' )>=2 || substr_count( $query_to_use, 'WHERE TRUE AND' )>=1 ) {
						$query_to_use = str_replace( 'WHERE TRUE AND ', 'WHERE TRUE  AND ('.$criteria.') AND ', $query_to_use );
					} else {
						$query_to_use = str_replace( 'WHERE', 'WHERE ('.$criteria.') AND ', $query_to_use );
					}
					
					$results = $this->ModelToSearch->query( $query_to_use ); 
		    	
		    	} else {
					$results = $this->ModelToSearch->find( 'all', array( 'conditions'=>$criteria, 'recursive'=>3 ) );
				}
			
			$this->data = $results; // set for display purposes...
			
			$this->layout = false;
			
	}
	
	/*
	function index( $type_of_list = 'all' ) {
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-2', NULL );
			// change SUBmenu based on passed TYPE var
			if ( $type_of_list=='saved' ) {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-8', NULL );
			} else if ( $type_of_list=='favourites' ) {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-7', NULL );
			} else {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-6', NULL );
			}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('querytool_adhoc') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build(0) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		$criteria = array();
		
		// if Saved, then use lookup datatable to restrict set of Adhocs
			if ( $type_of_list=='saved' ) {
				$favourite_criteria = array('0');
				$favourite_result = $this->Adhoc->query('SELECT adhoc_id FROM datamart_adhoc_saved WHERE user_id="'.$_SESSION['Auth']['User']['id'].'"');
				
				foreach ( $favourite_result as $adhoc_id ) {
					$favourite_criteria[] = $adhoc_id['datamart_adhoc_saved']['adhoc_id'];
				}
				
				$criteria[] = 'Adhoc.id IN ('.implode(',',$favourite_criteria).')';
			}
			
		// if Favourites, then use lookup datatable to restrict set of Adhocs
			else if ( $type_of_list=='favourites' ) {
				$favourite_criteria = array('0');
				$favourite_result = $this->Adhoc->query('SELECT adhoc_id FROM datamart_adhoc_favourites WHERE user_id="'.$_SESSION['Auth']['User']['id'].'"');
				
				foreach ( $favourite_result as $adhoc_id ) {
					$favourite_criteria[] = $adhoc_id['datamart_adhoc_favourites']['adhoc_id'];
				}
				
				$criteria[] = 'Adhoc.id IN ('.implode(',',$favourite_criteria).')';
			}
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		
		$result = $this->Adhoc->findAll( $criteria, NULL, $order, $limit, $page, 2 );
		
		// ERROR if no results
		if ( !is_array($result) || !count($result) ) { $result = array(array()); }
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'type_of_list', $type_of_list );
		$this->set( 'datamart_queries', $result );
		
	}
	
	// save IDs to Lookup, avoid duplicates
	function favourite( $adhoc_id=0 ) {
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$favourite_result = $this->Adhoc->query('DELETE FROM datamart_adhoc_favourites WHERE adhoc_id="'.$adhoc_id.'" AND user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$favourite_result = $this->Adhoc->query('INSERT INTO datamart_adhoc_favourites SET adhoc_id="'.$adhoc_id.'", user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$this->flash( 'Query has been marked as one of your favourites.', '/adhocs/index/favourites' );
	}
	
	// remove IDs from Lookup
	function unfavourite( $adhoc_id=0 ) {
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$favourite_result = $this->Adhoc->query('DELETE FROM datamart_adhoc_favourites WHERE adhoc_id="'.$adhoc_id.'" AND user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$this->flash( 'Query is no longer one of your favourites.', '/adhocs/index/favourites' );
	}
	
	function search( $type_of_list = 'all', $adhoc_id=0  ) {
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-2', NULL );
			// change SUBmenu based on passed TYPE var
			if ( $type_of_list=='saved' ) {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-8', NULL );
			} else if ( $type_of_list=='favourites' ) {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-7', NULL );
			} else {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-6', NULL );
			}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('adhoc') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build($adhoc_id) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'adhoc_id', $adhoc_id );
			
			// BIND models on the fly...
			$this->Adhoc->bindModel(
				  array('hasMany' => array(
							 'AdhocFavourite'	=> array(
									'className'  	=> 'AdhocFavourite',
									'conditions'	=> 'AdhocFavourite.user_id="'.$_SESSION['Auth']['User']['id'].'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 ),
							 'AdhocSaved'	=> array(
									'className'  	=> 'AdhocSaved',
									'conditions'	=> 'AdhocSaved.user_id="'.$_SESSION['Auth']['User']['id'].'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 )
						)
				  )
			 );
		
		$criteria = array();
		$criteria = 'Adhoc.id="'.$adhoc_id.'"';	
		$fields = '*';
		$order = '';
		$limit = 4;
		$ctrapp_form = $this->Adhoc->find( $criteria, $fields, $order, $limit, NULL, 3 );
		
		// ERROR if no results
		if ( !is_array($ctrapp_form) || !count($ctrapp_form) ) { $this->redirect('/pages/error'); exit; }
		
		
	  // Build Datamart result FORM from DATAMART queries table and FormFields, instead of Form table
		
			// findall FORM info, recursive
			
			if ( !$ctrapp_form['Adhoc']['form_alias_for_search'] ) {
				$this->redirect( '/datamart/adhocs/results/'.$adhoc_id );
				exit();
			}
				
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'adhoc', $ctrapp_form ); // set for display purposes...
		$this->set( 'ctrapp_form_for_query', $this->Forms->getFormArray('querytool_adhoc') );
	   $this->set( 'ctrapp_form', $this->Forms->getFormArray( $ctrapp_form['Adhoc']['form_alias_for_search'] ) );
	   $this->set( 'type_of_list', $type_of_list );
		
	}
	
	function results( $type_of_list = 'all', $adhoc_id=0 ) {
	
			$this->data = $this->Forms->clearUpDataArrayForSearches($this->data, array('clearBlankDates'=>false));
			
			// BIND models on the fly...
			$this->Adhoc->bindModel(
				  array('hasMany' => array(
							 'AdhocFavourite'	=> array(
									'className'  	=> 'AdhocFavourite',
									'conditions'	=> 'AdhocFavourite.user_id="'.$_SESSION['Auth']['User']['id'].'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 ),
							 'AdhocSaved'	=> array(
									'className'  	=> 'AdhocSaved',
									'conditions'	=> 'AdhocSaved.user_id="'.$_SESSION['Auth']['User']['id'].'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 )
						)
				  )
			 );
		
		// get Adhoc for source info 
		$criteria = 'Adhoc.id="'.$adhoc_id.'"';	
		$adhoc = $this->Adhoc->find( $criteria );
	    
		// ERROR if no results
		if ( !is_array($adhoc) || !count($adhoc) ) { $this->redirect('/pages/error'); exit; }
		
		$this->set( 'adhoc', $adhoc ); // set for display purposes...
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-2', NULL );
			// change SUBmenu based on passed TYPE var
			if ( $type_of_list=='saved' ) {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-8', NULL );
			} else if ( $type_of_list=='favourites' ) {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-7', NULL );
			} else {
				$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-6', NULL );
			}
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build($adhoc_id) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'adhoc_id', $adhoc_id );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form_for_query', $this->Forms->getFormArray('querytool_adhoc') );
		
		$ctrapp_form = $this->Forms->getFormArray( $adhoc['Adhoc']['form_alias_for_results'] );
		$this->set( 'ctrapp_form', $ctrapp_form );
		
		// do search for RESULTS, using THIS->DATA if any
		
			// start new instance of QUERY's model, and search it using QUERY's parsed SQL 
			$this->ModelToSearch = new $adhoc['Adhoc']['model'];
				
			// parse resulting IDs from the SQL to build FINDALL criteria for QUERY's true MODEL 
			$criteria = array();
			
			// parse FORM inputs to popultate QUERY's sql properly 
			$sql_query_with_search_terms = $adhoc['Adhoc']['sql_query_for_results'];
			$sql_query_without_search_terms = $adhoc['Adhoc']['sql_query_for_results'];
			
		
	    	// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			// if SEARCH form data, parse and create conditions
			$criteria = array();
			
			if ( $adhoc['Adhoc']['sql_query_for_results'] ) {
				
				list( $sql_query_with_search_terms, $sql_query_without_search_terms ) = $this->Forms->getSearchConditions( $this->data, NULL, $adhoc['Adhoc']['sql_query_for_results'] );
				
				$ids = $this->ModelToSearch->query( $sql_query_with_search_terms );
				
				foreach ( $ids as $array ) {
					foreach ( $array as $id_model=>$id_fields ) {
						if ( $id_model==$adhoc['Adhoc']['model'] ) {
							$criteria[] = $adhoc['Adhoc']['model'].'.id="'.$id_fields['id'].'"';
						}
					}
				}
				
				$criteria = implode( ' OR ', $criteria );
				
				if ( !$criteria ) {
					$criteria = $adhoc['Adhoc']['model'].'.id="-1"';
				}
				
			} else if ( $this->data ) {
				
				$criteria = $this->Forms->getSearchConditions( $this->data, $ctrapp_form );
				
			}
		
		// make list of SEARCH RESULTS
			
			// due to QUOTES and HTML code, save as PIPES in datatable ROWS
			$sql_query_with_search_terms = str_replace( '"', '|', $sql_query_with_search_terms );
			$sql_query_without_search_terms = str_replace( '"', '|', $sql_query_without_search_terms );
			
			if ( $adhoc['Adhoc']['flag_use_query_results'] && $adhoc['Adhoc']['sql_query_for_results'] ) {
	    		$this->set( 'final_query', $sql_query_without_search_terms );
	    		$results = $ids;
			} else {
				$this->set('final_query', '');
				$results = $this->ModelToSearch->findall( $criteria, NULL, NULL, NULL, NULL, 3 );
			}
			
			$this->set( 'results', $results ); // set for display purposes...
		
		// parse LINKS field in ADHOCS list for links in CHECKLIST
		
			$ctrapp_form_links = array();
			
			if ( $adhoc['Adhoc']['form_links_for_results'] ) {
				$adhoc['Adhoc']['form_links_for_results'] = explode( '|', $adhoc['Adhoc']['form_links_for_results'] );
				foreach ( $adhoc['Adhoc']['form_links_for_results'] as $exploded_form_links ) {
					$exploded_form_links = explode( '=>', $exploded_form_links );
					$ctrapp_form_links[ $exploded_form_links[0] ] = $exploded_form_links[1];
				}
			}
			
			$this->set( 'ctrapp_form_links', $ctrapp_form_links ); // set for display purposes...
			
				// echo '<h3>with</h3>';
				// pr($sql_query_with_search_terms);
				// echo '<h3>without</h3>';
				// pr($sql_query_without_search_terms);
				// exit;

				
		// get list of compatible BATCHES (matching model), for form PULLDOWN
			
			$criteria = array();
			
			if ( $adhoc['Adhoc']['flag_use_query_results'] ) {
				$criteria[] = 'flag_use_query_results = "1"';
				$criteria[] = 'model = "'.$adhoc['Adhoc']['model'].'"';
				$criteria[] = 'sql_query_for_results = "'.$sql_query_without_search_terms.'"';
			} else {
				$criteria[] = 'flag_use_query_results = "0"';
				$criteria[] = 'model = "'.$adhoc['Adhoc']['model'].'"';
			}
			
			$criteria[] = 'BatchSet.user_id="'.$_SESSION['Auth']['User']['id'].'"';
			$batch_sets = $this->BatchSet->findAll( $criteria, NULL, NULL, NULL, NULL, 1, 2 );
			
			// add COUNT of IDS to array results, for form list 
			if ( is_array($batch_sets) ) {
				foreach ( $batch_sets as &$value) {
					$value['BatchSet']['count_of_BatchId'] = count($value['BatchId']);
				}
			} else {
				$batch_sets = array();
			}

		// save THIS->DATA (if any) for Saved Search
			
			$save_this_search_data = array();
			
			foreach ( $this->data as $model=>$subarray ) {
				foreach ( $subarray as $field_name=>$field_value ) {
					if ( trim($field_value) ) {
						$save_this_search_data[] = $model.'/'.$field_name.'='.$field_value;
					}
				}
			}
			
			$save_this_search_data = implode('|',$save_this_search_data);
			
			if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
			$_SESSION['ctrapp_core']['datamart']['search_criteria'] = $save_this_search_data;
			
		// save for display
			
			$this->set( 'save_this_search_data', $save_this_search_data );
			$this->set( 'batch_sets', $batch_sets );
			$this->set( 'type_of_list', $type_of_list );
	}
	
	*/

}

?>