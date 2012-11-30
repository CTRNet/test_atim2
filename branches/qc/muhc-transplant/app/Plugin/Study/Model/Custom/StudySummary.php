<?php

class StudySummaryCustom extends StudySummary
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';

	function getStudyPermissibleValues() {
		$result = array();
					
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$result[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'].' [IRB#'.$new_study['StudySummary']['muhc_irb_nbr'].']';
		}
		
		return $result;
	}
	
}
?>