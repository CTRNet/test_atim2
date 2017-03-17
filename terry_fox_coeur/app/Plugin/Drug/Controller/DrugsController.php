<?php

class DrugsController extends DrugAppController {

	var $uses = array(
		'Drug.Drug'
	);
		
	var $paginate = array('Drug'=>array('order'=>'Drug.generic_name ASC')); 

	function search($search_id = 0) {
		$this->searchHandler($search_id, $this->Drug, 'drugs', '/Drug/Drugs/search');

		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if(empty($search_id)){
			//index
			$this->render('index');
		}
	}

	function add() {	
		$this->set( 'atim_menu', $this->Menus->get('/Drug/Drugs/search/') );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if (empty($this->request->data) ) {
			$this->request->data = array(array());
			
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
		} else {
			
			$errors_tracking = array();
			
			// Validation
			
			$row_counter = 0;
			foreach($this->request->data as &$data_unit){
				$row_counter++;
				$this->Drug->id = null;
				$this->Drug->set($data_unit);
				if(!$this->Drug->validates()){
					foreach($this->Drug->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg)$errors_tracking[$field][$msg][] = $row_counter;
					}
				}
				$data_unit = $this->Drug->data;
			}
			unset($data_unit);
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
			
			// Launch Save Process
			
			if(empty($this->request->data)) {
				$this->Drug->validationErrors[][] = 'at least one record has to be created';
			} else if(empty($errors_tracking)){
				AppModel::acquireBatchViewsUpdateLock();
				//save all
				foreach($this->request->data as $new_data_to_save) {
					$this->Drug->id = null;
					$this->Drug->data = array();
					if(!$this->Drug->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
				}
				$hook_link = $this->hook('postsave_process_batch');
				if( $hook_link ) {
					require($hook_link);
				}
				AppModel::releaseBatchViewsUpdateLock();
				$this->atimFlash(__('your data has been updated'), '/Drug/Drugs/search/');
			} else {
				$this->Drug->validationErrors = array();
				foreach($errors_tracking as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->Drug->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
					}
				}
			}
		}
  	}
  
	function edit( $drug_id ) {
		$drug_data = $this->Drug->getOrRedirect($drug_id);
		
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
		
		if ( empty($this->request->data) ) {
			$this->request->data = $drug_data;
		} else { 			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {
				$this->Drug->id = $drug_id;
				if ( $this->Drug->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash(__('your data has been updated'),'/Drug/Drugs/detail/'.$drug_id );
				}
			}
		}
  	}
	
	function detail( $drug_id ) {
		$this->request->data = $this->Drug->getOrRedirect($drug_id);
			
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
  
	function delete( $drug_id ) {
		$drug_data = $this->Drug->getOrRedirect($drug_id);
		$arr_allow_deletion = $this->Drug->allowDeletion($drug_id);
			
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}		
				
		if($arr_allow_deletion['allow_deletion']) {
			$this->Drug->data = null;
			if( $this->Drug->atimDelete( $drug_id ) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash(__('your data has been deleted'), '/Drug/Drugs/search/');
			} else {
				$this->flash(__('error deleting data - contact administrator'), '/Drug/Drugs/search/');
			}	
		} else {
			$this->flash(__($arr_allow_deletion['msg']), '/Drug/Drugs/detail/'.$drug_id);
		}	
  	}
  	
  	function autocompleteDrug() {
  	
  		//-- NOTE ----------------------------------------------------------
  		//
  		// This function is linked to functions of the StorageMaster model
  		// called getDrugIdFromDrugDataAndCode() and
  		// getDrugDataAndCodeForDisplay().
  		//
  		// When you override the autocompleteDrug() function, check
  		// if you need to override these functions.
  		//
  		//------------------------------------------------------------------
  	
  		//layout = ajax to avoid printing layout
  		$this->layout = 'ajax';
  		//debug = 0 to avoid printing debug queries that would break the javascript array
  		Configure::write('debug', 0);
  	
  		//query the database
  		$term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
  		$terms = array();
  		foreach(explode(' ', $term) as $key_word) $terms[] = "Drug.generic_name LIKE '%".$key_word."%'";
  	
  		$conditions = array('AND' => $terms);
  		$fields = 'Drug.*';
  		$order = 'Drug.generic_name ASC';
  		$joins = array();
  	
  		$hook_link = $this->hook('query_args');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  	
  		$data = $this->Drug->find('all', array(
  				'conditions' => $conditions,
  				'fields' => $fields,
  				'order' => $order,
  				'joins' => $joins,
  				'limit' => 10));
  	
  		//build javascript textual array
  		$result = "";
  		foreach($data as $data_unit){
  			$result .= '"'.$this->Drug->getDrugDataAndCodeForDisplay($data_unit).'", ';
  		}
  		if(sizeof($result) > 0){
  			$result = substr($result, 0, -2);
  		}
  	
  		$hook_link = $this->hook('format');
  		if( $hook_link ) {
  			require($hook_link);
  		}
  	
  		$this->set('result', "[".$result."]");
  	}
}

?>