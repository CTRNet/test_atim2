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
	function favourite( $type_of_list='all', $adhoc_id=null ) {
		$adhoc_data = $this->Adhoc->find('first', array('conditions'=>array('Adhoc.id'=>$adhoc_id)));
		if(empty($adhoc_data)) {
			$this->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		$adhoc_favourite_data = $this->AdhocFavourite->find('first', array('conditions'=>array('AdhocFavourite.adhoc_id'=>$adhoc_id, 'AdhocFavourite.user_id'=>$_SESSION['Auth']['User']['id'])));
		if(!empty($adhoc_favourite_data)) {
			$this->redirect('/pages/err_datamart_system_error', null, true);
		}		
		
		$data_to_save = array('AdhocFavourite' =>
			array('adhoc_id' => $adhoc_id,
				'user_id' => $_SESSION['Auth']['User']['id']));
		$this->AdhocFavourite->id = null;
		if(!$this->AdhocFavourite->save($data_to_save)) {
			$this->redirect('/pages/err_datamart_system_error', null, true);
		}
		
		$this->atimFlash( 'Query has been marked as one of your favourites.', '/datamart/adhocs/search/favourites/'.$adhoc_id );
	}
	
	// remove IDs from Lookup
	function unfavourite( $type_of_list='all', $adhoc_id=null ) {
		$adhoc_favourite_data = $this->AdhocFavourite->find('first', array('conditions'=>array('AdhocFavourite.adhoc_id'=>$adhoc_id, 'AdhocFavourite.user_id'=>$_SESSION['Auth']['User']['id'])));
		if(empty($adhoc_favourite_data)) {
			$this->redirect('/pages/err_datamart_system_error', null, true);
		}			
		if(!$this->AdhocFavourite->atim_delete( $adhoc_favourite_data['AdhocFavourite']['id'] )) {
			$this->redirect('/pages/err_datamart_system_error', null, true);
		}
		$this->atimFlash( 'Query is no longer one of your favourites.', '/datamart/adhocs/search/all/'.$adhoc_id );
	}
	
	function search( $type_of_list='all', $adhoc_id=0  ) {
		
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL;
		
		$this->set( 'atim_menu_variables', array( 'Param.Type_Of_List'=>$type_of_list, 'Adhoc.id'=>$adhoc_id ) );
		
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
			
		if(is_numeric($adhoc_id)){
			$adhoc = $this->Adhoc->find( 'first', array( 'conditions'=>array('Adhoc.id'=>$adhoc_id)));
		   	$this->set( 'data_for_detail', $adhoc );
			$this->set( 'atim_structure_for_results', $this->Structures->get( 'form', $adhoc['Adhoc']['form_alias_for_results']));
		}else{
			list($type_from, $type_to) = explode("_", $adhoc_id);
			list($plugin, $model) = explode(".", $type_to);
			$adhoc = array("Adhoc" => array("description" => "Browsing", "model" => $model, $plugin => $plugin));
			$this->set( 'data_for_detail', $adhoc);
			$this->set( 'atim_structure_for_results', $this->Structures->get( 'form', $type_to ));
		}
		$this->Structures->set('datamart_browser_start', 'atim_structure_for_add');
		
		// do search for RESULTS, using THIS->DATA if any
		
		// start new instance of QUERY's model, and search it using QUERY's parsed SQL 
		$this->ModelToSearch = AppModel::atimNew($adhoc['Adhoc']['plugin'] ? $adhoc['Adhoc']['plugin'] : '', $adhoc['Adhoc']['model'], true);
			
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
				$ctrapp_form_links[ $exploded_form_links[0] ]['link'] = $exploded_form_links[1];
				$exploded_link_name =  explode(" ", $exploded_form_links[0]);
				$ctrapp_form_links[ $exploded_form_links[0] ]['icon'] = $exploded_link_name[0];
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
		
		// save THIS->DATA (if any) for Saved Search
			
		$save_this_search_data = array();
		
		foreach ( $this->data as $model=>$subarray ) {
			if(is_array($subarray)){
				foreach ( $subarray as $field_name=>$field_value ) {
					if ( !is_array($field_value) && trim($field_value) ) {
						$save_this_search_data[] = $model.'.'.$field_name.'='.$field_value;
					}
				}
			}
		}
		
		$save_this_search_data = implode('|',$save_this_search_data);
		
		if ( !isset($_SESSION['ctrapp_core']['datamart']['search_criteria']) ) { $_SESSION['ctrapp_core']['datamart']['search_criteria'] = NULL; }
		$_SESSION['ctrapp_core']['datamart']['search_criteria'] = $save_this_search_data;
		// save for display

		$actions = $this->BatchSet->getDropdownOptions($adhoc['Adhoc']['plugin'], $adhoc['Adhoc']['model'], "id", $adhoc['Adhoc']['form_alias_for_results'], $adhoc['Adhoc']['model'], "id");
		$this->set( 'save_this_search_data', $save_this_search_data );
		$this->set('actions', $actions);
	}
	
	function process() {
		if ( !isset($this->data['Adhoc']['process']) || !$this->data['Adhoc']['process'] ) {
			$this->data['Adhoc']['process'] = '/datamart/batch_sets/add/'.$this->data['BatchSet']['id'];
		}

		$_SESSION['ctrapp_core']['datamart']['process'] = $this->data;
		if($this->data['BatchSet']['id'] == "csv"){
			$this->redirect("/datamart/adhocs/csv/");
		}else{
			$this->redirect($this->data['Adhoc']['process']);
		}
		exit();
		
	}
	
	function csv(){
		
		// set function variables, makes script readable :)
		$adhoc_id = $_SESSION['ctrapp_core']['datamart']['process']['Adhoc']['id'];
		
		// get BATCHSET for source info 
			
		$conditions = array('Adhoc.id' => $adhoc_id);
		$adhoc_result = $this->Adhoc->find('first', array('conditions' => $conditions)); 
			
		$this->Structures->set($adhoc_result['Adhoc']['form_alias_for_results']);
		
		
		// use adhoc MODEl info to find session IDs
		$adhoc_model = $adhoc_result['Adhoc']['model'];
		
		if(isset($_SESSION['ctrapp_core']['datamart']['process'][$adhoc_model])){
			$adhoc_id_array = $_SESSION['ctrapp_core']['datamart']['process'][ $adhoc_model ]['id'];
		} else {
			$adhoc_id_array = array();
		}
		
		// do search for RESULTS, using THIS->DATA if any
		$this->ModelToSearch = AppModel::atimNew($adhoc_result['Adhoc']['plugin'] ? $adhoc_result['Adhoc']['plugin'] : '', $adhoc_result['Adhoc']['model'], true);
			
		// parse resulting IDs from the SET to build FINDALL criteria for SET's true MODEL 
		$criteria = array(0);
		foreach ($adhoc_id_array as $field_id){
			if($field_id != 0){
				$criteria[] = $field_id;
			}
		}
		$criteria = $adhoc_model.'.id IN('.implode(', ', $criteria ).') ';
		// make list of SEARCH RESULTS
    	
		if(false && $adhoc_result['Adhoc']['flag_use_query_results']){
    		// update DATATABLE names to MODEL names for CTRAPP FORM framework
			$query_to_use = str_replace( '|', '"', $_SESSION['ctrapp_core']['datamart']['process']['Adhoc']['sql_query_for_results'] ); // due to QUOTES and HTML not playing well, PIPES saved to datatable rows instead
			
			// add restrictions to query, inserting BATCH SET IDs to WHERE statement
			if(substr_count($query_to_use, 'WHERE') >= 2 || substr_count($query_to_use, 'WHERE TRUE AND') >= 1){
				$query_to_use = str_replace( 'WHERE TRUE AND ', 'WHERE TRUE  AND ('.$criteria.') AND ', $query_to_use );
			}else{
				$query_to_use = str_replace('WHERE', 'WHERE ('.$criteria.') AND ', $query_to_use);
			}
			
			$results = $this->ModelToSearch->query($query_to_use);
    	}else{
			$results = $this->ModelToSearch->find('all', array('conditions' => $criteria, 'recursive' => 3));
		}
			
		$this->data = $results; // set for display purposes...
		$this->layout = false;
			
	}
}

?>