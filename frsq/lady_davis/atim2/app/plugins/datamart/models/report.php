<?php
class Report extends DatamartAppModel {
	var $useTable = 'datamart_reports';
	
	function summary( $variables=array() ) {		
		$return = array();
			
		if ( isset($variables['Report.id']) && (!empty($variables['Report.id'])) ) {
			$report_data = $this->find('first', array('conditions'=>array('Report.id' => $variables['Report.id']), 'recursive' => '-1'));
					
			if(!empty($report_data)) {
				$return['menu'] = array($report_data['Report']['name']);
				$return['title'] = array(null, $report_data['Report']['name']);
				$return['data'] = $report_data;
				$return['structure alias'] = 'reports';
			}
		
		}
		
		return $return;
	}
	
}