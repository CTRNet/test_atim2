<?php

class AdhocSavedController extends DatamartAppController {
	
	var $uses = array('Datamart.Adhoc', 'Datamart.AdhocSaved');
	var $paginate = array('AdhocSaved'=>array('limit'=>10,'order'=>'AdhocSaved.description ASC')); 
	
	function index( $type_of_list = 'all' ) {
		
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list ) );
		$this->set( 'atim_structure', $this->Structures->get( 'form', 'querytool_adhoc' ) );
		// $this->set( 'atim_menu', $this->Menus->get('') );
		
		$this->data = $this->paginate($this->Adhoc);
		// $this->data = $this->paginate($this->BatchSet, array('BatchSet.user_id'=>$_SESSION['Auth']['User']['id']));
		
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