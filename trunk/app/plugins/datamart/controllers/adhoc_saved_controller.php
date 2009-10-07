<?php

class AdhocSavedController extends DatamartAppController {
	
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
	
	function index( $type_of_list = 'all' ) {
		$this->redirect( '/datamart/adhocs/index/saved' );
		exit();
	}
	
	function add( $type_of_list='all', $adhoc_id=0  ) {
		
		$new_AdhocSaved_data = array(
			'AdhocSaved'	=> array(
				'adhoc_id'			=>	$adhoc_id,
				'user_id'			=>	$_SESSION['Auth']['User']['id'],
				'search_params'	=>	$_SESSION['ctrapp_core']['datamart']['search_criteria'],
				'description'		=>	'(unlabelled saved search set)'
			)
		);
		
		$this->AdhocSaved->save( $new_AdhocSaved_data );
		$this->flash( 'Your data has been saved.', '/datamart/adhocs/index/saved' );
		
	}
	
	function search( $adhoc_id=0, $saved_id=0 ) {
		$this->set( 'atim_menu', $this->Menus->get('/datamart/adhocs/index') );
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>'saved', 'Adhoc.id'=>$adhoc_id, 'AdhocSaved.id'=>$saved_id ) );
		$this->set( 'atim_structure_for_detail', $this->Structures->get( 'form', 'querytool_adhoc_saved' ) );
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
			// BIND models on the fly...
			$this->Adhoc->bindModel(
				  array('hasOne' => array(
							 'AdhocSaved'	=> array(
									'className'  	=> 'AdhocSaved',
									'conditions'	=> 'AdhocSaved.user_id="'.$_SESSION['Auth']['User']['id'].'" AND AdhocSaved.id="'.$saved_id.'"',
									'foreignKey'	=> 'adhoc_id',
									'dependent'		=> true
							 )
						)
				  )
			 );
		
		$conditions = array('Adhoc.id'=>$adhoc_id);	
		
		$this->data = $this->Adhoc->find( 'first', array('conditions'=>$conditions,'recursive'=>3) );
		
		$this->set( 'atim_structure_for_form', $this->Structures->get( 'form', $this->data['Adhoc']['form_alias_for_search'] ) );
		
	}
	
	function results( $adhoc_id=0, $saved_id=0 ) {
		$this->set( 'atim_menu', $this->Menus->get('/datamart/adhocs/index') );
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>'saved', 'Adhoc.id'=>$adhoc_id, 'AdhocSaved.id'=>$saved_id ) );
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
			
			// if SEARCH form data, parse and create conditions
			$criteria = array();
			
			if ( $adhoc['Adhoc']['sql_query_for_results'] ) {
				
				list( $sql_query_with_search_terms, $sql_query_without_search_terms ) = $this->Structures->parse_sql_conditions( $adhoc['Adhoc']['sql_query_for_results'] );
				
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
	
	function edit( $adhoc_id=0, $saved_id=0 ) {
		$this->set( 'atim_menu', $this->Menus->get('/datamart/adhocs/index') );
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>'saved', 'Adhoc.id'=>$adhoc_id, 'AdhocSaved.id'=>$saved_id ) );
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'querytool_adhoc_saved' ) );
		
		if ( !empty($this->data) ) {
			$this->AdhocSaved->id = $saved_id;
			if ( $this->AdhocSaved->save($this->data) ) $this->flash( 'Your data has been updated.','/datamart/adhoc_saved/search/'.$adhoc_id.'/'.$saved_id );
		} else {
			// BIND models on the fly...
			$this->AdhocSaved->bindModel(
				  array('belongsTo' => array(
							 'Adhoc'	=> array(
									'className'  	=> 'Adhoc',
									'foreignKey'	=> 'adhoc_id'
							 )
						)
				  )
			 );
			
			$this->data = $this->AdhocSaved->find('first',array('conditions'=>array('AdhocSaved.id'=>$saved_id)));
		}
	}
	
	// remove IDs from Lookup
	function delete( $adhoc_id=0, $saved_id=0 ) {
		$result = $this->AdhocSaved->query('DELETE FROM datamart_adhoc_saved WHERE id="'.$saved_id.'" AND adhoc_id="'.$adhoc_id.'" AND user_id="'.$_SESSION['Auth']['User']['id'].'"');
		$this->flash( 'Query is no longer one of your saved searches.', '/adhoc_saved/index/saved' );
		
	}
	
	/*
	function index( $type_of_list = 'all' ) {
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-2', NULL );
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-8', NULL );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('querytool_adhoc_saved') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build(0) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		$criteria = array();
		
		$criteria[] = 'AdhocSaved.user_id="'.$this->othAuth->user('id').'"';
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		
			// BIND models on the fly...
			$this->AdhocSaved->bindModel(
				  array('belongsTo' => array(
							 'Adhoc'	=> array(
									'className'  	=> 'Adhoc',
									'foreignKey'	=> 'adhoc_id'
							 )
						)
				  )
			 );
			 
		$result = $this->AdhocSaved->findAll( $criteria, NULL, $order, $limit, $page, 2 );
		
		// pr($result);
		// pr($ctrapp_form);
		// exit;
		
		// ERROR if no results
		if ( !is_array($result) || !count($result) ) { $result = array(array()); }
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'type_of_list', $type_of_list );
		$this->set( 'datamart_queries', $result );
		
	}
	
	function add( $adhoc_id=0 ) {
		
		if ( !$adhoc_id || !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { 
			$this->redirect('/pages/error'); exit;
		}
		
		$new_AdhocSaved_data = array(
			'AdhocSaved'	=> array(
				'adhoc_id'			=>	$adhoc_id,
				'user_id'			=>	$this->othAuth->user('id'),
				'search_params'	=>	$_SESSION['ctrapp_core']['datamart']['search_criteria'],
				'description'		=>	'(unlabelled saved search set)'
			)
		);
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->AdhocSaved->save( $new_AdhocSaved_data );
		$this->flash( 'Your data has been saved.', '/adhoc_saved/index/' );
		exit;
		
	}
	
	function edit( $adhoc_id=0, $saved_id=0 ) {
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		// setup MODEL(s) validation array(s) for displayed FORM 
		foreach ( $this->Forms->getValidateArray('querytool_adhoc_saved') as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-2', NULL );
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-8', NULL );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('querytool_adhoc_saved') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build(0) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'adhoc_id', $adhoc_id );
		$this->set( 'saved_id', $saved_id );
		
		if ( empty($this->data) ) {
			
			// get Adhoc for source info 
			$criteria = array();
			$criteria[] = 'AdhocSaved.id="'.$saved_id.'"';
			$criteria[] = 'AdhocSaved.user_id="'.$this->othAuth->user('id').'"';
			
			// BIND models on the fly...
			$this->AdhocSaved->bindModel(
				  array('belongsTo' => array(
							 'Adhoc'	=> array(
									'className'  	=> 'Adhoc',
									'foreignKey'	=> 'adhoc_id'
							 )
						)
				  )
			 );
			
			$this->data = $this->AdhocSaved->find( $criteria );
			
			// ERROR if no results
			if ( !is_array($this->data) || !count($this->data) ) { $this->redirect('/pages/error'); exit; }
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			$this->set( 'data', $this->data ); // set for display purposes...
			
		} else {
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			if ( $this->AdhocSaved->save( $this->data['AdhocSaved'] ) ) {
				$this->flash( 'Your data has been updated.', '/adhoc_saved/search/'.$adhoc_id.'/'.$saved_id );
			}
			
		}
		
	}
	
	// remove IDs from Lookup
	function delete( $adhoc_id=0, $saved_id=0 ) {
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$result = $this->Adhoc->query('DELETE FROM datamart_adhoc_saved WHERE id="'.$saved_id.'" AND adhoc_id="'.$adhoc_id.'" AND user_id="'.$this->othAuth->user('id').'"');
		$this->flash( 'Query is no longer one of your saved searches.', '/adhoc_saved/index' );
		
	}
	
	function search( $adhoc_id=0, $saved_id=0  ) {
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-1', 'qry-CAN-2', NULL );
		$ctrapp_menu[] = $this->Menus->tabs( 'qry-CAN-2', 'qry-CAN-8', NULL );
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
				  array('hasOne' => array(
							 'AdhocSaved'	=> array(
									'className'  	=> 'AdhocSaved',
									'conditions'	=> 'AdhocSaved.user_id="'.$this->othAuth->user('id').'" AND AdhocSaved.id="'.$saved_id.'"',
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
		
		$this->set( 'ctrapp_form_for_query', $this->Forms->getFormArray('querytool_adhoc_saved') );
	  	$this->set( 'adhoc', $ctrapp_form ); // set for display purposes...
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $ctrapp_form['Adhoc']['form_alias_for_search'] ) );
	   $this->set( 'type_of_list', 'saved' );
		
	}
	*/

}

?>