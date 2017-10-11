<?php

class StudySummaryCustom extends StudySummary
{

    var $name = 'StudySummary';

    var $useTable = 'study_summaries';

    var $studyDataAndCodeForDisplayAlreadySet = array();

    var $studyInvestigatorsFromId = array();

    var $studyInstitutionsFromId = array();

    public function beforeSave($options = array())
    {
        if (array_key_exists('StudySummary', $this->data) && array_key_exists('path_to_file', $this->data['StudySummary'])) {
            $this->data['StudySummary']['path_to_file'] = preg_replace('/[\\\]+/', '/', $this->data['StudySummary']['path_to_file']);
        }
        $retVal = parent::beforeSave($options);
        return $retVal;
    }

    public function beforeFind($queryData)
    {
        if (isset($queryData['conditions']) && isset($queryData['conditions']['StudySummary.qc_nd_generated_study_investigators'])) {
            // Can not use joins model when user add an investigator twixe to a study else will generate 2 records
            $StudyInvestigator = AppModel::getInstance("Study", "StudyInvestigator", true);
            $linkedStudySummaryIds = $StudyInvestigator->find('list', array(
                'conditions' => array(
                    'StudyInvestigator.last_name' => $queryData['conditions']['StudySummary.qc_nd_generated_study_investigators']
                ),
                'fields' => 'StudyInvestigator.study_summary_id'
            ));
            if ($linkedStudySummaryIds) {
                $queryData['conditions']['StudySummary.id'] = array_merge((isset($queryData['conditions']['StudySummary.id']) ? $queryData['conditions']['StudySummary.id'] : array()), $linkedStudySummaryIds);
            }
            unset($queryData['conditions']['StudySummary.qc_nd_generated_study_investigators']);
        }
        foreach ($queryData['order'] as $tmpKey => $tmpOrder) {
            if (is_string($tmpOrder) && preg_match("/StudySummary\.qc_nd_generated_study_investigators.((asc)|(desc)){0,1}/", $tmpOrder, $matches)) {
                // Sort on this field generate an error.
                unset($queryData['order'][$tmpKey]);
            }
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        $tmpResults = array();
        foreach ($results as &$newStudy) {
            if (isset($newStudy['StudySummary']['id'])) {
                $newStudy['StudySummary']['qc_nd_generated_study_investigators'] = $this->getStudyInvestigatorsFromId($newStudy['StudySummary']['id']);
            }
        }
        return $results;
    }

    public function getStudyInvestigatorsFromId($studySummaryId)
    {
        if (! $this->studyInvestigatorsFromId) {
            $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $investigators = $StructurePermissibleValuesCustom->getCustomDropdown(array(
                'researchers'
            ));
            $investigators = array_replace($investigators['defined'], $investigators['previously_defined']);
            $StudyInvestigator = AppModel::getInstance("Study", "StudyInvestigator", true);
            $this->studyInvestigatorsFromId = array();
            foreach ($StudyInvestigator->find('all', array(
                'conditions' => array(),
                'fields' => 'StudyInvestigator.study_summary_id, StudyInvestigator.last_name'
            )) as $newInvestigator) {
                $investiagtorLastName = strlen($newInvestigator['StudyInvestigator']['last_name']) ? $investigators[$newInvestigator['StudyInvestigator']['last_name']] : '';
                $this->studyInvestigatorsFromId[$newInvestigator['StudyInvestigator']['study_summary_id']][$investiagtorLastName] = $investiagtorLastName;
            }
            foreach ($this->studyInvestigatorsFromId as &$newStudyInvestigators) {
                ksort($newStudyInvestigators);
                $newStudyInvestigators = array_filter($newStudyInvestigators);
                $newStudyInvestigators = implode(' & ', $newStudyInvestigators);
            }
        }
        return isset($this->studyInvestigatorsFromId[$studySummaryId]) ? $this->studyInvestigatorsFromId[$studySummaryId] : '';
    }

    public function getStudyInstitutionsFromId($studySummaryId)
    {
        if (! $this->studyInstitutionsFromId) {
            $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $institutions = $StructurePermissibleValuesCustom->getCustomDropdown(array(
                'Institutions & Laboratories'
            ));
            $institutions = array_replace($institutions['defined'], $institutions['previously_defined']);
            foreach ($this->find('all', array(
                'conditions' => array(),
                'fields' => 'StudySummary.id, StudySummary.qc_nd_institution'
            )) as $newStudy) {
                $this->studyInstitutionsFromId[$newStudy['StudySummary']['id']] = strlen($newStudy['StudySummary']['qc_nd_institution']) ? $institutions[$newStudy['StudySummary']['qc_nd_institution']] : '';
            }
        }
        return isset($this->studyInstitutionsFromId[$studySummaryId]) ? $this->studyInstitutionsFromId[$studySummaryId] : '';
    }

    public function getStudyDataAndCodeForDisplay($studyData)
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
        $formattedData = '';
        if ((! empty($studyData)) && isset($studyData['StudySummary']['id']) && (! empty($studyData['StudySummary']['id']))) {
            if (! isset($this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']])) {
                if (! isset($studyData['StudySummary']['title'])) {
                    $studyData = $this->find('first', array(
                        'conditions' => array(
                            'StudySummary.id' => $studyData['StudySummary']['id']
                        )
                    ));
                }
                $studyComplementaryInformation = array();
                $studyComplementaryInformation[] = $this->getStudyInvestigatorsFromId($studyData['StudySummary']['id']);
                $studyComplementaryInformation[] = $this->getStudyInstitutionsFromId($studyData['StudySummary']['id']);
                $studyComplementaryInformation = array_filter($studyComplementaryInformation);
                $studyComplementaryInformation = implode(' - ', $studyComplementaryInformation);
                $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']] = $studyData['StudySummary']['title'] . (strlen($studyComplementaryInformation) ? ' (' . $studyComplementaryInformation . ')' : '') . ' [' . $studyData['StudySummary']['id'] . ']';
            }
            $formattedData = $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']];
        }
        return $formattedData;
    }

    public function getStudyIdFromStudyDataAndCode($studyDataAndCode)
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
        if (! isset($this->studyTitlesAlreadyChecked[$studyDataAndCode])) {
            $matches = array();
            $selectedStudies = array();
            if (preg_match("/(.+)\[([0-9]+)\]/", $studyDataAndCode, $matches) > 0) {
                // Auto complete tool has been used
                $selectedStudies = $this->find('all', array(
                    'conditions' => array(
                        'StudySummary.id' => $matches[2]
                    )
                ));
            } else {
                // consider $studyDataAndCode contains just study title
                $term = str_replace('_', '\_', str_replace('%', '\%', $studyDataAndCode));
                $terms = array();
                foreach (explode(' ', $term) as $keyWord)
                    $terms[] = "StudySummary.title LIKE '%" . $keyWord . "%'";
                $conditions = array(
                    'AND' => $terms
                );
                $selectedStudies = $this->find('all', array(
                    'conditions' => $conditions
                ));
            }
            if (sizeof($selectedStudies) == 1) {
                $this->studyTitlesAlreadyChecked[$studyDataAndCode] = array(
                    'StudySummary' => $selectedStudies[0]['StudySummary']
                );
            } elseif (sizeof($selectedStudies) > 1) {
                $this->studyTitlesAlreadyChecked[$studyDataAndCode] = array(
                    'error' => str_replace('%s', $studyDataAndCode, __('more than one study matches the following data [%s]'))
                );
            } else {
                $this->studyTitlesAlreadyChecked[$studyDataAndCode] = array(
                    'error' => str_replace('%s', $studyDataAndCode, __('no study matches the following data [%s]'))
                );
            }
        }
        return $this->studyTitlesAlreadyChecked[$studyDataAndCode];
    }
}