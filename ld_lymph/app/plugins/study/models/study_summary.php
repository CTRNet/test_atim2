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
				'menu'			=>	array( NULL, $result['StudySummary']['title'], TRUE),
				'title'			=>	array( NULL, $result['StudySummary']['title'], TRUE),
				'data'			=> $result,
				'structure alias'=>'studysummaries'
			);
		}
		
		return $return;
	}
	
	/**
	 * Get permissible values array gathering all existing studies.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  
	function getStudyPermissibleValues() {
		$result = array();
					
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$result[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'] . ' (' . __($new_study['StudySummary']['disease_site'], true) . ' - ' .__($new_study['StudySummary']['study_type'], true) .')';
		}
		
		return $result;
	}
}
?>