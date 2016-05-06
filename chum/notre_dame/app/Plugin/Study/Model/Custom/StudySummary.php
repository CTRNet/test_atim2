<?php

class StudySummaryCustom extends StudySummary
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';
	
	var $hasMany = array(
		'StudyInvestigator' => array(
			'className' => 'Study.StudyInvestigator',
			'foreignKey' => 'study_summary_id'));

	function getStudyPermissibleValues() {
		$result = array();
				
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		$institutions = $StructurePermissibleValuesCustom->getCustomDropdown(array('Institutions & Laboratories'));
		$institutions = array_replace($institutions['defined'], $institutions['previously_defined']);
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$qc_nd_investigators = $new_study['Generated']['qc_nd_study_investigators'];
			$qc_nd_institution = strlen($new_study['StudySummary']['qc_nd_institution'])? (isset($researchers[$new_study['StudySummary']['qc_nd_institution']])? $researchers[$new_study['StudySummary']['qc_nd_institution']] : $new_study['StudySummary']['qc_nd_institution']): '';
			$prefix = array($qc_nd_investigators, $qc_nd_institution);
			$prefix = array_filter($prefix);
			$prefix = $prefix? implode (' - ', $prefix).' - ' : '';
			$result[$new_study['StudySummary']['id']] = $prefix.$new_study['StudySummary']['title'];
		}
		asort($result);
		
		return $result;
	}
	
	function beforeFind($queryData){
		if(isset($queryData['conditions']) && isset($queryData['conditions']['StudyInvestigator.last_name'])) {
	 		$queryData['joins'][] = array(
	 				'table' => 'study_investigators',
	 				'alias'	=> 'StudyInvestigator',
	 				'type'	=> 'LEFT',
	 				'conditions' => array('StudyInvestigator.study_summary_id = StudySummary.id')
			);
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false) {
		$results = parent::afterFind($results, $primary);
		
		if(isset($results['0']['StudyInvestigator'])) {
			$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
			$researchers = $StructurePermissibleValuesCustom->getCustomDropdown(array('researchers'));
			$researchers = array_replace($researchers['defined'], $researchers['previously_defined']);
			foreach($results as &$new_study) {
				$all_investigators = array();
				foreach($new_study['StudyInvestigator'] as $new_investigator) {
					if($new_investigator['last_name']) isset($researchers[$new_investigator['last_name']])? 
						($all_investigators[$researchers[$new_investigator['last_name']]] = $researchers[$new_investigator['last_name']]) : 
						($all_investigators[$new_investigator['last_name']] = $new_investigator['last_name']);
				}
				ksort($all_investigators);
				$new_study['Generated']['qc_nd_study_investigators'] = implode(' & ', $all_investigators);
			}
		}
	
		return $results;
	}
	
}
?>