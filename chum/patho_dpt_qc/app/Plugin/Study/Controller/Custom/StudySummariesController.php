<?php

class StudySummariesControllerCustom extends StudySummariesController{

	
	//=========================================================================
	//Quality Control Criteria
	//=========================================================================
	
	function stdQcCriteriaDetail($study_summary_id) {
		$this->request->data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->Structures->set('chum_patho_study_quality_controls');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
	}
	
	function stdQcCriteriaEdit($study_summary_id, $action = null) {
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);

		$this->Structures->set('chum_patho_study_quality_controls');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		
		if($action == 'delete') {
			$this->request->data = array('StudySummary' => array(
				'chum_patho_signal' => '',
				'chum_patho_ctrl_pos' => '',
				'chum_patho_ctrl_neg' => '',
				'chum_patho_pictures' => '',
				'chum_patho_pathologist' => '',
				'chum_patho_performance_criteria' => '',
				'chum_patho_non_compliance_indicators' => ''));
			$this->StudySummary->check_writable_fields = false;
		}		
		
		if(empty($this->request->data)) {
			$this->request->data = $study_summary_data;
		} else {
			$this->StudySummary->id = $study_summary_id;
			if ( $this->StudySummary->save($this->request->data) ) {
				$this->atimFlash(__('your data has been updated'),'/Study/StudySummaries/stdQcCriteriaDetail/'.$study_summary_id );
			}
		}
  	}
	
	//=========================================================================
	//Quality Control Reports
	//=========================================================================
	
	function stdQcReportListall($study_summary_id) {
		$this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->StudyQualityControlReport = AppModel::getInstance('Study', 'StudyQualityControlReport', true);
		$this->request->data = $this->paginate($this->StudyQualityControlReport, array('StudyQualityControlReport.study_summary_id' => $study_summary_id));
		
		$this->Structures->set('chum_patho_study_quality_control_reports');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdQcCriteriaDetail/%%StudySummary.id%%/'));
	}
	
	function stdQcReportAdd($study_summary_id) {
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->StudyQualityControlReport = AppModel::getInstance('Study', 'StudyQualityControlReport', true);
		
		$this->Structures->set('chum_patho_study_quality_control_reports');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdQcCriteriaDetail/%%StudySummary.id%%/'));
	
		if (!empty($this->request->data) ) {
			$this->StudyQualityControlReport->addWritableField(array('study_summary_id'));
			$this->StudyQualityControlReport->writable_fields_mode = 'add';
			$this->request->data['StudyQualityControlReport']['study_summary_id'] = $study_summary_id;
			if ($this->StudyQualityControlReport->save($this->request->data) ) {
				$this->atimFlash(__('your data has been saved'),'/Study/StudySummaries/stdQcCriteriaDetail/'.$study_summary_id );
			}
		}
	}
	
	function stdQcReportEdit($study_quality_control_report_id) {
		$this->StudyQualityControlReport = AppModel::getInstance('Study', 'StudyQualityControlReport', true);
		$study_quality_control_report_data = $this->StudyQualityControlReport->getOrRedirect($study_quality_control_report_id);
		$study_summary_id = $study_quality_control_report_data['StudyQualityControlReport']['study_summary_id'] ;
		
		$this->Structures->set('chum_patho_study_quality_control_reports');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyQualityControlReport.id'=>$study_quality_control_report_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdQcCriteriaDetail/%%StudySummary.id%%/'));
		
		if(empty($this->request->data)) {
			$this->request->data = $study_quality_control_report_data;
		} else {
			$this->StudyQualityControlReport->id = $study_quality_control_report_id;
			if ( $this->StudyQualityControlReport->save($this->request->data) ) {
				$this->atimFlash(__('your data has been updated'),'/Study/StudySummaries/stdQcCriteriaDetail/'.$study_summary_id );
			}
		}
	}
	
	function stdQcReportDelete($study_quality_control_report_id) {
		$this->StudyQualityControlReport = AppModel::getInstance('Study', 'StudyQualityControlReport', true);
		$study_quality_control_report_data = $this->StudyQualityControlReport->getOrRedirect($study_quality_control_report_id);
		$study_summary_id = $study_quality_control_report_data['StudyQualityControlReport']['study_summary_id'] ;
		
		if( $this->StudyQualityControlReport->atimDelete( $study_quality_control_report_id ) ) {
			$this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/stdQcCriteriaDetail/'.$study_summary_id );
		} else {
			$this->flash(__('error deleting data - contact administrator'), '/Study/StudySummaries/stdQcCriteriaDetail/'.$study_summary_id );
		}
	}
	
	//=========================================================================
	//External Evaluations
	//=========================================================================
	
	function stdExtEvalListall($study_summary_id) {
		$this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->StudyExternalEvaluation = AppModel::getInstance('Study', 'StudyExternalEvaluation', true);
		$this->request->data = $this->paginate($this->StudyExternalEvaluation, array('StudyExternalEvaluation.study_summary_id' => $study_summary_id));
		
		$this->Structures->set('chum_patho_study_external_evaluations');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdExtEvalListall/%%StudySummary.id%%/'));
	}
	
	function stdExtEvalAdd($study_summary_id) {
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->StudyExternalEvaluation = AppModel::getInstance('Study', 'StudyExternalEvaluation', true);
		
		$this->Structures->set('chum_patho_study_external_evaluations');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdExtEvalListall/%%StudySummary.id%%/'));
		
		if (!empty($this->request->data) ) {
			$this->StudyExternalEvaluation->addWritableField(array('study_summary_id'));
			$this->StudyExternalEvaluation->writable_fields_mode = 'add';
			$this->request->data['StudyExternalEvaluation']['study_summary_id'] = $study_summary_id;
			if ($this->StudyExternalEvaluation->save($this->request->data) ) {
				$this->atimFlash(__('your data has been saved'),'/Study/StudySummaries/stdExtEvalListall/'.$study_summary_id );
			}
		}
	}
	
	function stdExtEvalEdit($study_external_evaluation_id) {
		$this->StudyExternalEvaluation = AppModel::getInstance('Study', 'StudyExternalEvaluation', true);
		$study_quality_control_report_data = $this->StudyExternalEvaluation->getOrRedirect($study_external_evaluation_id);
		$study_summary_id = $study_quality_control_report_data['StudyExternalEvaluation']['study_summary_id'] ;
		
		$this->Structures->set('chum_patho_study_external_evaluations');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyExternalEvaluation.id'=>$study_external_evaluation_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdExtEvalListall/%%StudySummary.id%%/'));
		
		if(empty($this->request->data)) {
			$this->request->data = $study_quality_control_report_data;
		} else {
			$this->StudyExternalEvaluation->id = $study_external_evaluation_id;
			if ( $this->StudyExternalEvaluation->save($this->request->data) ) {
				$this->atimFlash(__('your data has been updated'),'/Study/StudySummaries/stdExtEvalListall/'.$study_summary_id );
			}
		}
	}
	
	function stdExtEvalDelete($study_external_evaluation_id) {
		$this->StudyExternalEvaluation = AppModel::getInstance('Study', 'StudyExternalEvaluation', true);
		$study_quality_control_report_data = $this->StudyExternalEvaluation->getOrRedirect($study_external_evaluation_id);
		$study_summary_id = $study_quality_control_report_data['StudyExternalEvaluation']['study_summary_id'] ;
		
		if( $this->StudyExternalEvaluation->atimDelete( $study_external_evaluation_id ) ) {
			$this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/stdExtEvalListall/'.$study_summary_id );
		} else {
			$this->flash(__('error deleting data - contact administrator'), '/Study/StudySummaries/stdExtEvalListall/'.$study_summary_id );
		}
	}
	
	//=========================================================================
	//References
	//=========================================================================
	
	function stdRefListall($study_summary_id) {
		$this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->StudyReference = AppModel::getInstance('Study', 'StudyReference', true);
		$this->request->data = $this->paginate($this->StudyReference, array('StudyReference.study_summary_id' => $study_summary_id));
		
		$this->Structures->set('chum_patho_study_references');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdRefListall/%%StudySummary.id%%/'));
	}
	
	function stdRefAdd($study_summary_id) {
		$study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
		
		$this->StudyReference = AppModel::getInstance('Study', 'StudyReference', true);
		
		$this->Structures->set('chum_patho_study_references');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdRefListall/%%StudySummary.id%%/'));
		
		if (!empty($this->request->data) ) {
			$this->StudyReference->addWritableField(array('study_summary_id'));
			$this->StudyReference->writable_fields_mode = 'add';
			$this->request->data['StudyReference']['study_summary_id'] = $study_summary_id;
			if ($this->StudyReference->save($this->request->data) ) {
				$this->atimFlash(__('your data has been saved'),'/Study/StudySummaries/stdRefListall/'.$study_summary_id );
			}
		}
	}
	
	function stdRefEdit($study_reference_id) {
		$this->StudyReference = AppModel::getInstance('Study', 'StudyReference', true);
		$study_quality_control_report_data = $this->StudyReference->getOrRedirect($study_reference_id);
		$study_summary_id = $study_quality_control_report_data['StudyReference']['study_summary_id'] ;
		
		$this->Structures->set('chum_patho_study_references');
		$this->set( 'atim_menu_variables', array('StudySummary.id'=>$study_summary_id, 'StudyReference.id'=>$study_reference_id) );
		$this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/stdRefListall/%%StudySummary.id%%/'));
		
		if(empty($this->request->data)) {
			$this->request->data = $study_quality_control_report_data;
		} else {
			$this->StudyReference->id = $study_reference_id;
			if ( $this->StudyReference->save($this->request->data) ) {
				$this->atimFlash(__('your data has been updated'),'/Study/StudySummaries/stdRefListall/'.$study_summary_id );
			}
		}
	}
	
	function stdRefDelete($study_reference_id) {
		$this->StudyReference = AppModel::getInstance('Study', 'StudyReference', true);
		$study_quality_control_report_data = $this->StudyReference->getOrRedirect($study_reference_id);
		$study_summary_id = $study_quality_control_report_data['StudyReference']['study_summary_id'] ;
		
		if( $this->StudyReference->atimDelete( $study_reference_id ) ) {
			$this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/stdRefListall/'.$study_summary_id );
		} else {
			$this->flash(__('error deleting data - contact administrator'), '/Study/StudySummaries/stdRefListall/'.$study_summary_id );
		}	
	}
	
}

?>
