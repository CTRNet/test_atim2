<?php
$user_lang = ($_SESSION['Config']['language'] == 'eng') ? 'en' : 'fr';
$custom_terms = array();
foreach (explode(' ', $term) as $key_word)
    $custom_terms[] = "generated_title LIKE '%" . $key_word . "%'";
$custom_conditions = $custom_terms ? implode(' AND ', $custom_terms) : 'TRUE';
$query = "SELECT GROUP_CONCAT(id SEPARATOR ',') AS ids
    	FROM (
        	SELECT StudySummary.id, 
        	CONCAT(StudySummary.title, 
                ' ', 
                IF(IFNULL(InstitutionList.$user_lang, '') = '', IFNULL(InstitutionList.value, 'yyyy'), InstitutionList.$user_lang), 
                ' ', 
                IFNULL(GeneratedInvestigarors.investigators_last_name, 'wwwww')) AS generated_title
            FROM study_summaries StudySummary
            LEFT JOIN structure_permissible_values_customs InstitutionList ON InstitutionList.value = StudySummary.qc_nd_institution AND InstitutionList.control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories')
        	LEFT JOIN (
        	    SELECT StudyInvestigator.study_summary_id,
        	    GROUP_CONCAT(DISTINCT IF(InvestigatorList.$user_lang = '', InvestigatorList.value, InvestigatorList.$user_lang) SEPARATOR ' ') AS investigators_last_name
        	    FROM study_investigators StudyInvestigator
        	    LEFT JOIN structure_permissible_values_customs InvestigatorList ON InvestigatorList.value = StudyInvestigator.last_name AND InvestigatorList.control_id =(SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'researchers')
        	    WHERE StudyInvestigator.deleted <> 1
        	    GROUP BY StudyInvestigator.study_summary_id
        	) GeneratedInvestigarors ON GeneratedInvestigarors.study_summary_id = StudySummary.id
        	WHERE StudySummary.deleted <> 1
    	 )  GroupRes
    	 WHERE $custom_conditions";
$study_ids = $this->StudySummary->query($query);
if ($study_ids && $study_ids[0][0]['ids']) {
    $conditions = array(
        'StudySummary.id' => explode(',', $study_ids[0][0]['ids'])
    );
}