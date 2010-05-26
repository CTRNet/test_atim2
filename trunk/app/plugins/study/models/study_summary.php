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
	
	/**
	 * Get permissible values array gathering all existing studies.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'StudySummary.id', 'default' => (translated string describing study))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  
	function getStudyPermissibleValues() {
		$result = array();
					
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$result[] = array(
				'value' => $new_study['StudySummary']['id'], 
				'default' => $new_study['StudySummary']['title'] . ' (' . __($new_study['StudySummary']['disease_site'], true) . ' - ' .__($new_study['StudySummary']['study_type'], true) .')');
		}
		
		return $result;
	}
}
?>