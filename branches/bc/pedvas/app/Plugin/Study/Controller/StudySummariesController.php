<?php

class StudySummariesController extends StudyAppController {

	var $uses = array('Study.StudySummary');
	var $paginate = array('StudySummary'=>array('limit' => pagination_amount,'order'=>'StudySummary.title'));
  
	function search($search_id = ''){
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		$this->searchHandler($search_id, $this->StudySummary, 'studysummaries', '/Study/StudySummaries/search');
		
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

	function detail( $study_summary_id ) {
		// MANAGE DATA
		$this->request->data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function add() {
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/search'));
	
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	
		if ( !empty($this->request->data) ) {
			$submitted_data_validates = true;
			// ... special validations

			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}				
		
			if($submitted_data_validates) {
				if ( $this->StudySummary->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been saved','/Study/StudySummaries/detail/'.$this->StudySummary->id );
				}
			}
		}
  	}
  
	function edit( $study_summary_id ) {
		// MANAGE DATA
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}	
		
		
		if(empty($this->request->data)) {
			$this->request->data = $study_summary_data;
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}

			if($submitted_data_validates) {	
				$this->StudySummary->id = $study_summary_id;
				if ( $this->StudySummary->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/Study/StudySummaries/detail/'.$study_summary_id );
				}		
			}
		}
  	}
	
	function delete( $study_summary_id ){
		// MANAGE DATA
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		$arr_allow_deletion = $this->StudySummary->allowDeletion($study_summary_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook('delete');
		if( $hook_link ) { 
			require($hook_link); 
		}	
		
		if($arr_allow_deletion['allow_deletion']) {
			// DELETE DATA
			if( $this->StudySummary->atimDelete( $study_summary_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/Study/StudySummaries/search/');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/Study/StudySummaries/search/');
			}	
		} else {
			$this->flash($arr_allow_deletion['msg'], '/Study/StudySummaries/detail/'.$study_summary_id);
		}	
  	}
}

?>
