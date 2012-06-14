<?php
class Report extends DatamartAppModel {
	var $useTable = 'datamart_reports';
	
	function summary( $variables=array() ) {		
		$return = array();
			
		if ( isset($variables['Report.id']) && (!empty($variables['Report.id'])) ) {
			$report_data = $this->find('first', array('conditions'=>array('Report.id' => $variables['Report.id']), 'recursive' => '-1'));
					
			if(!empty($report_data)) {
				$return = array(
						'menu'				=> array(null, __($report_data['Report']['name'])),
						'title'				=>	array(null, __($report_data['Report']['name'])),
						'structure alias' 	=> 'reports',
						'data'				=> $report_data
				);
			}
		}
		
		return $return;
	}
	
}