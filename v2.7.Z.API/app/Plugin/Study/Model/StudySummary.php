<?php

/**
 * Class StudySummary
 */
class StudySummary extends StudyAppModel
{

    public $name = 'StudySummary';

    public $useTable = 'study_summaries';

    public $studyTitlesAlreadyChecked = array();

    public $studyDataAndCodeForDisplayAlreadySet = array();

    /**
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['StudySummary.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'StudySummary.id' => $variables['StudySummary.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $result['StudySummary']['title'],
                    true
                ),
                'title' => array(
                    null,
                    $result['StudySummary']['title'],
                    true
                ),
                'data' => $result,
                'structure alias' => 'studysummaries'
            );
        }
        
        return $return;
    }

    /**
     * Get permissible values array gathering all existing studies.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getStudyPermissibleValues()
    {
        $result = array();
        
        foreach ($this->find('all', array(
            'order' => 'StudySummary.title ASC'
        )) as $newStudy) {
            $result[$newStudy['StudySummary']['id']] = $this->getStudyDataAndCodeForDisplay($newStudy);
        }
        asort($result);
        
        return $result;
    }

    /**
     * @param $studyData
     * @return mixed|string
     */
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
                $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']] = $studyData['StudySummary']['title'] . ' [' . $studyData['StudySummary']['id'] . ']';
            }
            $formattedData = $this->studyDataAndCodeForDisplayAlreadySet[$studyData['StudySummary']['id']];
        }
        return $formattedData;
    }

    /**
     * @param $studyDataAndCode
     * @return mixed
     */
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
                        "StudySummary.title LIKE '%" . trim($matches[1]) . "%'",
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

    /**
     * @return array
     */
    public function getStudyPermissibleValuesForView()
    {
        $result = $this->getStudyPermissibleValues();
        $result['-1'] = __('not applicable');
        return $result;
    }

    /**
     * @param int $studySummaryId
     * @return array
     */
    public function allowDeletion($studySummaryId)
    {
        $ctrlModel = AppModel::getInstance("Study", "StudyFunding", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'StudyFunding.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study funding is assigned to the study/project'
            );
        }
        
        $ctrlModel = AppModel::getInstance("Study", "StudyInvestigator", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'StudyInvestigator.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study investigator is assigned to the study/project'
            );
        }
        
        $ctrlModel = AppModel::getInstance("StorageLayout", "TmaSlide", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'TmaSlide.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a tma slide'
            );
        }
        
        $ctrlModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'MiscIdentifier.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a participant'
            );
        }
        
        $ctrlModel = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'ConsentMaster.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a consent'
            );
        }
        
        $ctrlModel = AppModel::getInstance("Order", "Order", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'Order.default_study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to an order'
            );
        }
        
        $orderLingModel = AppModel::getInstance("Order", "OrderLine", true);
        $returnedNbr = $orderLingModel->find('count', array(
            'conditions' => array(
                'OrderLine.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to an order line'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to an aliquot'
            );
        }
        
        $ctrlModel = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'AliquotInternalUse.study_summary_id' => $studySummaryId
            ),
            'recursive' => '-1'
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to an aliquot'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}