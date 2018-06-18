<?php

class StudySummaryCustom extends StudySummary
{

    var $name = 'StudySummary';

    var $useTable = 'study_summaries';

    var $studyDataAndCodeForDisplayAlreadySet = array();

    public function beforeSave($options = array())
    {
        if (array_key_exists('StudySummary', $this->data) && array_key_exists('path_to_file', $this->data['StudySummary'])) {
            $this->data['StudySummary']['path_to_file'] = preg_replace('/[\\\]+/', '/', $this->data['StudySummary']['path_to_file']);
        }
        $retVal = parent::beforeSave($options);
        return $retVal;
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
                            'StudySummary.id' => ($studyData['StudySummary']['id'])
                        )
                    ));
                }
                $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']] = $studyData['StudySummary']['title'] . ' [' . $studyData['StudySummary']['id'] . ']' . ' - ' . $studyData['StudySummary']['qc_hb_code'];
            }
            $formattedData = $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']];
        }
        return $formattedData;
    }
}