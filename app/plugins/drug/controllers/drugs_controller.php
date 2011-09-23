<?php

class DrugsController extends DrugAppController {

	var $uses = array(
		'Drug.Drug',
		'Protocol.ProtocolExtend',
		'Clinicalannotation.TreatmentExtend');
		
	var $paginate = array('Drug'=>array('limit' => pagination_amount,'order'=>'Drug.generic_name ASC')); 

	function search($search_id = 0) {
		$this->searchHandler($search_id, $this->Drug, 'drugs', '/drug/drugs/search');

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
		$this->set( 'atim_menu', $this->Menus->get('/drug/drugs/index/') );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
						
			if ( $submitted_data_validates && $this->Drug->save($this->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/drug/drugs/detail/'.$this->Drug->id );
			}
		}
  	}
  
	function edit( $drug_id ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$drug_data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		if(empty($drug_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }	
		
		if ( empty($this->data) ) {
			$this->data = $drug_data;
		} else { 			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {
				$this->Drug->id = $drug_id;
				if ( $this->Drug->save($this->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/drug/drugs/detail/'.$drug_id );
				}
			}
		}
  	}
	
	function detail( $drug_id ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		$drug_data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		if(empty($drug_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		$this->data = $drug_data;
			
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
  
	function delete( $drug_id ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		$drug_data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		if(empty($drug_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
				
		$arr_allow_deletion = $this->Drug->allowDeletion($drug_id);
			
		// CUSTOM CODE
		
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
				
		if($arr_allow_deletion['allow_deletion']) {	
			if( $this->Drug->atim_delete( $drug_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/drug/drugs/index/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/drug/drugs/index/');
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/drug/drugs/detail/'.$drug_id);
		}	
  	}
}

?>