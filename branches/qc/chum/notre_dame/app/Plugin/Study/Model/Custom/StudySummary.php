<?php

class StudySummaryCustom extends StudySummary
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';

	function getStudyPermissibleValues() {
		$result = array();
				
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$institutions = $StructurePermissibleValuesCustom->getCustomDropdown(array('Institutions & Laboratories'));
		$institutions = array_replace($institutions['defined'], $institutions['previously_defined']);
		$researchers = $StructurePermissibleValuesCustom->getCustomDropdown(array('researchers'));
		$researchers = array_replace($researchers['defined'], $researchers['previously_defined']);
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$qc_nd_researcher = strlen($new_study['StudySummary']['qc_nd_researcher'])? (isset($researchers[$new_study['StudySummary']['qc_nd_researcher']])? $researchers[$new_study['StudySummary']['qc_nd_researcher']] : $new_study['StudySummary']['qc_nd_researcher']): '';
			$qc_nd_institution = strlen($new_study['StudySummary']['qc_nd_institution'])? (isset($researchers[$new_study['StudySummary']['qc_nd_institution']])? $researchers[$new_study['StudySummary']['qc_nd_institution']] : $new_study['StudySummary']['qc_nd_institution']): '';
			$prefix = array($qc_nd_researcher, $qc_nd_institution);
			$prefix = array_filter($prefix);
			$prefix = $prefix? implode (' - ', $prefix).' - ' : '';
			$result[$new_study['StudySummary']['id']] = $prefix.$new_study['StudySummary']['title'];
		}
		asort($result);
		
		return $result;
	}
}
?>