<?php

class DrugsController extends DrugAppController {

	var $uses = array(
		'Drug.Drug',
		'Protocol.ProtocolExtend',
		'ClinicalAnnotation.TreatmentExtend'
	);
		
	var $paginate = array('Drug'=>array('limit' => pagination_amount,'order'=>'Drug.generic_name ASC')); 

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
		
		if ( !empty($this->request->data) ) {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
						
			if ( $submitted_data_validates && $this->Drug->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/Drug/Drugs/detail/'.$this->Drug->id );
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
					$this->atimFlash( 'your data has been updated','/Drug/Drugs/detail/'.$drug_id );
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
			if( $this->Drug->atimDelete( $drug_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/Drug/Drugs/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/Drug/Drugs/index/');
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/Drug/Drugs/detail/'.$drug_id);
		}	
  	}
}

?>