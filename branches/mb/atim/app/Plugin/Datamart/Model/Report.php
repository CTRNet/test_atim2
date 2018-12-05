<?php
class Report extends DatamartAppModel {
	var $useTable = 'datamart_reports';
	
	function summary( $variables=array() ) {		
		$return = array();
			
		if ( isset($variables['Report.id']) && (!empty($variables['Report.id'])) ) {
			$report_data = $this->find('first', array('conditions'=>array('Report.id' => $variables['Report.id']), 'recursive' => '-1'));
			$report_data['Report']['name'] = __($report_data['Report']['name'] );
			$report_data['Report']['description'] = __($report_data['Report']['description'] );
			if(!empty($report_data)) {
				$return = array(
						'menu'				=> array(null, $report_data['Report']['name']),
						'title'				=>	array(null, $report_data['Report']['name']),
						'structure alias' 	=> 'reports',
						'data'				=> $report_data
				);
			}
		}
		
		return $return;
	}
	
}