<?php

class StudySummaryCustom extends StudySummary
{

    var $name = 'StudySummary';

    var $useTable = 'study_summaries';

    var $study_data_and_code_for_display_already_set = array();

    var $study_investigators_from_id = array();

    var $study_institutions_from_id = array();

    function beforeSave($options = array())
    {
        if (array_key_exists('StudySummary', $this->data) && array_key_exists('path_to_file', $this->data['StudySummary'])) {
            $this->data['StudySummary']['path_to_file'] = preg_replace('/[\\\]+/', '/', $this->data['StudySummary']['path_to_file']);
        }
        $ret_val = parent::beforeSave($options);
        return $ret_val;
    }

    function beforeFind($queryData)
    {
        if (isset($queryData['conditions']) && isset($queryData['conditions']['StudySummary.qc_nd_generated_study_investigators'])) {
            // Can not use joins model when user add an investigator twixe to a study else will generate 2 records
            $StudyInvestigator = AppModel::getInstance("Study", "StudyInvestigator", true);
            $linked_study_summary_ids = $StudyInvestigator->find('list', array(
                'conditions' => array(
                    'StudyInvestigator.last_name' => $queryData['conditions']['StudySummary.qc_nd_generated_study_investigators']
                ),
                'fields' => 'StudyInvestigator.study_summary_id'
            ));
            if ($linked_study_summary_ids) {
                $queryData['conditions']['StudySummary.id'] = array_merge((isset($queryData['conditions']['StudySummary.id']) ? $queryData['conditions']['StudySummary.id'] : array()), $linked_study_summary_ids);
            }
            unset($queryData['conditions']['StudySummary.qc_nd_generated_study_investigators']);
        }
        foreach ($queryData['order'] as $tmp_key => $tmp_order) {
            if (is_string($tmp_order) && preg_match("/StudySummary\.qc_nd_generated_study_investigators.((asc)|(desc)){0,1}/", $tmp_order, $matches)) {
                // Sort on this field generate an error.
                unset($queryData['order'][$tmp_key]);
            }
        }
        return $queryData;
    }

    function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        $tmp_results = array();
        foreach ($results as &$new_study) {
            if (isset($new_study['StudySummary']['id'])) {
                $new_study['StudySummary']['qc_nd_generated_study_investigators'] = $this->getStudyInvestigatorsFromId($new_study['StudySummary']['id']);
            }
        }
        return $results;
    }

    function getStudyInvestigatorsFromId($study_summary_id)
    {
        if (! $this->study_investigators_from_id) {
            $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $investigators = $StructurePermissibleValuesCustom->getCustomDropdown(array(
                'researchers'
            ));
            $investigators = array_replace($investigators['defined'], $investigators['previously_defined']);
            $StudyInvestigator = AppModel::getInstance("Study", "StudyInvestigator", true);
            $this->study_investigators_from_id = array();
            foreach ($StudyInvestigator->find('all', array(
                'conditions' => array(),
                'fields' => 'StudyInvestigator.study_summary_id, StudyInvestigator.last_name'
            )) as $new_investigator) {
                $investiagtor_last_name = strlen($new_investigator['StudyInvestigator']['last_name']) ? $investigators[$new_investigator['StudyInvestigator']['last_name']] : '';
                $this->study_investigators_from_id[$new_investigator['StudyInvestigator']['study_summary_id']][$investiagtor_last_name] = $investiagtor_last_name;
            }
            foreach ($this->study_investigators_from_id as &$new_study_investigators) {
                ksort($new_study_investigators);
                $new_study_investigators = array_filter($new_study_investigators);
                $new_study_investigators = implode(' & ', $new_study_investigators);
            }
        }
        return isset($this->study_investigators_from_id[$study_summary_id]) ? $this->study_investigators_from_id[$study_summary_id] : '';
    }

    function getStudyInstitutionsFromId($study_summary_id)
    {
        if (! $this->study_institutions_from_id) {
            $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $institutions = $StructurePermissibleValuesCustom->getCustomDropdown(array(
                'Institutions & Laboratories'
            ));
            $institutions = array_replace($institutions['defined'], $institutions['previously_defined']);
            foreach ($this->find('all', array(
                'conditions' => array(),
                'fields' => 'StudySummary.id, StudySummary.qc_nd_institution'
            )) as $new_study) {
                $this->study_institutions_from_id[$new_study['StudySummary']['id']] = strlen($new_study['StudySummary']['qc_nd_institution']) ? $institutions[$new_study['StudySummary']['qc_nd_institution']] : '';
            }
        }
        return isset($this->study_institutions_from_id[$study_summary_id]) ? $this->study_institutions_from_id[$study_summary_id] : '';
    }

    function getStudyDataAndCodeForDisplay($study_data)
    {
        
        // -- NOTE ----------------------------------------------------------------
        //
        // This function is linked to a function of the StudySummary controller
        // called autocompleteStudy()
        // and to functions of the StudySummary model
        // getStudyIdFromStudyDataAndCode().
        //
        // When you override the getStudyDataAndCodeForDisplay() function,
        // check if you need to override these functions.
        //
        // ------------------------------------------------------------------------
        $formatted_data = '';
        if ((! empty($study_data)) && isset($study_data['StudySummary']['id']) && (! empty($study_data['StudySummary']['id']))) {
            if (! isset($this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']])) {
                if (! isset($study_data['StudySummary']['title'])) {
                    $study_data = $this->find('first', array(
                        'conditions' => array(
                            'StudySummary.id' => $study_data['StudySummary']['id']
                        )
                    ));
                }
                $study_complementary_information = array();
                $study_complementary_information[] = $this->getStudyInvestigatorsFromId($study_data['StudySummary']['id']);
                $study_complementary_information[] = $this->getStudyInstitutionsFromId($study_data['StudySummary']['id']);
                $study_complementary_information = array_filter($study_complementary_information);
                $study_complementary_information = implode(' - ', $study_complementary_information);
                $this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']] = $study_data['StudySummary']['title'] . (strlen($study_complementary_information) ? ' (' . $study_complementary_information . ')' : '') . ' [' . $study_data['StudySummary']['id'] . ']';
            }
            $formatted_data = $this->study_data_and_code_for_display_already_set[$study_data['StudySummary']['id']];
        }
        return $formatted_data;
    }

    function getStudyIdFromStudyDataAndCode($study_data_and_code)
    {
        
        // -- NOTE ----------------------------------------------------------------
        //
        // This function is linked to a function of the StudySummary controller
        // called autocompleteStudy()
        // and to function of the StudySummary model
        // getStudyDataAndCodeForDisplay().
        //
        // When you override the getStudyIdFromStudyDataAndCode() function,
        // check if you need to override these functions.
        //
        // ------------------------------------------------------------------------
        if (! isset($this->study_titles_already_checked[$study_data_and_code])) {
            $matches = array();
            $selected_studies = array();
            if (preg_match("/(.+)\[([0-9]+)\]/", $study_data_and_code, $matches) > 0) {
                // Auto complete tool has been used
                $selected_studies = $this->find('all', array(
                    'conditions' => array(
                        'StudySummary.id' => $matches[2]
                    )
                ));
            } else {
                // consider $study_data_and_code contains just study title
                $term = str_replace('_', '\_', str_replace('%', '\%', $study_data_and_code));
                $terms = array();
                foreach (explode(' ', $term) as $key_word)
                    $terms[] = "StudySummary.title LIKE '%" . $key_word . "%'";
                $conditions = array(
                    'AND' => $terms
                );
                $selected_studies = $this->find('all', array(
                    'conditions' => $conditions
                ));
            }
            if (sizeof($selected_studies) == 1) {
                $this->study_titles_already_checked[$study_data_and_code] = array(
                    'StudySummary' => $selected_studies[0]['StudySummary']
                );
            } elseif (sizeof($selected_studies) > 1) {
                $this->study_titles_already_checked[$study_data_and_code] = array(
                    'error' => str_replace('%s', $study_data_and_code, __('more than one study matches the following data [%s]'))
                );
            } else {
                $this->study_titles_already_checked[$study_data_and_code] = array(
                    'error' => str_replace('%s', $study_data_and_code, __('no study matches the following data [%s]'))
                );
            }
        }
        return $this->study_titles_already_checked[$study_data_and_code];
    }
}