<?php

class StudyInvestigatorsControllerCustom extends StudyInvestigatorsController {
	
	function listall( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
    	$study_investigator_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_investigator_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
    	$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));

   		$this->request->data = $this->paginate($this->StudyInvestigator, array('StudyInvestigator.study_summary_id'=>$study_summary_id));
	}

	function add( $study_summary_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
       	$study_investigator_data= $this->StudySummary->find('first',array('conditions'=>array('StudySummary.id'=>$study_summary_id), 'recursive' => '-1'));
        if(empty($study_investigator_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
        $this->set( 'atim_menu', $this->Menus->get('/Study/StudySummaries/detail/') );
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id));
		
       	if ( !empty($this->request->data) ) {
			$this->request->data['StudyInvestigator']['study_summary_id'] = $study_summary_id;
			$this->StudyInvestigator->addWritableField(array('study_summary_id'));
			if ( $this->StudyInvestigator->save($this->request->data) ) {
				$this->atimFlash(__('your data has been saved'),'/Study/StudySummaries/detail/'.$study_summary_id.'/');
			}
		}
 	}
  
	function delete( $study_summary_id, $study_investigator_id ) {
		if ( !$study_summary_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		if ( !$study_investigator_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$study_investigator_data= $this->StudyInvestigator->find('first',array('conditions'=>array('StudyInvestigator.id'=>$study_investigator_id, 'StudyInvestigator.study_summary_id'=>$study_summary_id)));
		if(empty($study_investigator_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		if( $this->StudyInvestigator->atimDelete( $study_investigator_id ) ) {
			$this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/detail/'.$study_summary_id );
		} else {
			$this->flash(__('error deleting data - contact administrator.'), '/Study/StudySummaries/detail/'.$study_summary_id );
		}
	}
}

?>
