<?php
$userLang = ($_SESSION['Config']['language'] == 'eng') ? 'en' : 'fr';
$customTerms = array();
foreach (explode(' ', $term) as $keyWord)
    $customTerms[] = "generated_title LIKE '%" . $keyWord . "%'";
$customConditions = $customTerms ? implode(' AND ', $customTerms) : 'TRUE';
$query = "SELECT GROUP_CONCAT(id SEPARATOR ',') AS ids
    	FROM (
        	SELECT StudySummary.id, 
        	CONCAT(StudySummary.title, 
                ' ', 
                IF(IFNULL(InstitutionList.$userLang, '') = '', IFNULL(InstitutionList.value, 'yyyy'), InstitutionList.$userLang), 
                ' ', 
                IFNULL(GeneratedInvestigarors.investigators_last_name, 'wwwww')) AS generated_title
            FROM study_summaries StudySummary
            LEFT JOIN structure_permissible_values_customs InstitutionList ON InstitutionList.value = StudySummary.qc_nd_institution AND InstitutionList.control_id = (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Institutions & Laboratories')
        	LEFT JOIN (
        	    SELECT StudyInvestigator.study_summary_id,
        	    GROUP_CONCAT(DISTINCT IF(InvestigatorList.$userLang = '', InvestigatorList.value, InvestigatorList.$userLang) SEPARATOR ' ') AS investigators_last_name
        	    FROM study_investigators StudyInvestigator
        	    LEFT JOIN structure_permissible_values_customs InvestigatorList ON InvestigatorList.value = StudyInvestigator.last_name AND InvestigatorList.control_id =(SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'researchers')
        	    WHERE StudyInvestigator.deleted <> 1
        	    GROUP BY StudyInvestigator.study_summary_id
        	) GeneratedInvestigarors ON GeneratedInvestigarors.study_summary_id = StudySummary.id
        	WHERE StudySummary.deleted <> 1
    	 )  GroupRes
    	 WHERE $customConditions";
$studyIds = $this->StudySummary->query($query);
if ($studyIds && $studyIds[0][0]['ids']) {
    $conditions = array(
        'StudySummary.id' => explode(',', $studyIds[0][0]['ids'])
    );
}