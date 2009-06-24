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
					'menu'			=>	array( NULL, $result['StudySummary']['title']),
					'title'			=>	array( NULL, $result['StudySummary']['title']),
					
					'description'	=>	array(
						'disease site'	=>	$result['StudySummary']['disease_site'],
						'type'		=>	$result['StudySummary']['study_type'],
						'summary'   =>  $result['StudySummary']['summary']
					)
				)
			);
		}
		
		return $return;
	}
}
?>