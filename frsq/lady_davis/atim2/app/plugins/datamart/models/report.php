<?php
class Report extends DatamartAppModel {
	var $useTable = 'datamart_reports';
	
	function summary( $variables=array() ) {		
		$return = array(
			'Summary' => array(
				'menu' => array(null)));
			
		if ( isset($variables['Report.id']) && (!empty($variables['Report.id'])) ) {
			$report_data = $this->find('first', array('conditions'=>array('Report.id' => $variables['Report.id']), 'recursive' => '-1'));
					
			if(!empty($report_data)) {
				$return['Summary']['menu'] = array($report_data['Report']['name']);
				$return['Summary']['title'] = array(null, $report_data['Report']['name']);
				$return['Summary']['description'] = array(
					__('description', true) => $report_data['Report']['description']);	
			}
		
		}
		
		return $return;
	}
	
}