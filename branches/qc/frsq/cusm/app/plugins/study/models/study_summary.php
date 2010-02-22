<?php

class StudySummary extends StudyAppModel
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['StudySummary.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('StudySummary.id'=>$variables['StudySummary.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, __($result['StudySummary']['title'], TRUE)),
					'title'			=>	array( NULL, __($result['StudySummary']['title'], TRUE)),
					
					'description'	=>	array(
						__('disease site', TRUE)	=>	__($result['StudySummary']['disease_site'], TRUE),
						__('type', TRUE)			=>	__($result['StudySummary']['study_type'], TRUE),
						__('summary', TRUE)		    =>  __($result['StudySummary']['summary'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}
?>