<?php
		
	$user_lang = ($_SESSION['Config']['language'] == 'eng')? 'en' : 'fr';
	$custom_terms = array();
	foreach(explode(' ', $term) as $key_word) $custom_terms[] = "generated_title LIKE '%".$key_word."%'";
	$custom_conditions = $custom_terms? implode(' AND ', $custom_terms) : 'TRUE';
	$query = "SELECT GROUP_CONCAT(id SEPARATOR ',') AS ids
		FROM (
				SELECT StudySummary.id, 
				CONCAT(StudySummary.title, ' ',
				IF(InstitutionList.$user_lang = '', InstitutionList.value, InstitutionList.$user_lang), ' ',
				GROUP_CONCAT(DISTINCT IF(InvestigatorList.$user_lang = '', InvestigatorList.value, InvestigatorList.$user_lang) SEPARATOR ' ')) AS generated_title,
				StudySummary.qc_nd_institution,
				StudyInvestigator.last_name
				FROM study_summaries StudySummary
				INNER JOIN study_investigators StudyInvestigator ON StudySummary.id = StudyInvestigator.study_summary_id AND StudyInvestigator.deleted <> 1
				LEFT JOIN structure_permissible_values_customs InstitutionList ON InstitutionList.value = StudySummary.qc_nd_institution AND InstitutionList.control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories')
				LEFT JOIN structure_permissible_values_customs InvestigatorList ON InvestigatorList.value = StudyInvestigator.last_name AND InvestigatorList.control_id =(SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'researchers')
				WHERE StudySummary.deleted <> 1
				GROUP BY StudySummary.id
		) GroupRes
		WHERE $custom_conditions";
	$study_ids = $this->StudySummary->query($query);
	if($study_ids && $study_ids[0][0]['ids']) {
		$conditions = array('StudySummary.id' => explode(',', $study_ids[0][0]['ids']));
	}
	