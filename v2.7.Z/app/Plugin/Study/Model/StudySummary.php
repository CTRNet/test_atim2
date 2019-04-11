<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

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
     *
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
     *
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
     *
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
            $term = str_replace(array(
                "\\",
                '%',
                '_'
            ), array(
                "\\\\",
                '\%',
                '\_'
            ), $studyDataAndCode);
            if (preg_match("/(.+)\ \[([0-9]+)\]/", $term, $matches) > 0) {
                // Auto complete tool has been used
                $selectedStudies = $this->find('all', array(
                    'conditions' => array(
                        "StudySummary.title LIKE " => '%' . $matches[1] . '%',
                        'StudySummary.id' => $matches[2]
                    )
                ));
            } else {
                // consider $studyDataAndCode contains just study title
                $terms = array();
                foreach (explode(' ', $term) as $keyWord) {
                    $terms[] = array(
                        "StudySummary.title LIKE " => '%' . $keyWord . '%'
                    );
                }
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
     *
     * @return array
     */
    public function getStudyPermissibleValuesForView()
    {
        $result = $this->getStudyPermissibleValues();
        $result['-1'] = __('not applicable');
        return $result;
    }

    /**
     *
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
            'recursive' => - 1
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
            'recursive' => - 1
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
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a tma slide'
            );
        }
        
        $ctrlModel = AppModel::getInstance("StorageLayout", "TmaSlideUse", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'TmaSlideUse.study_summary_id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if ($ctrlValue > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'study/project is assigned to a tma slide use'
            );
        }
        
        $ctrlModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $ctrlValue = $ctrlModel->find('count', array(
            'conditions' => array(
                'MiscIdentifier.study_summary_id' => $studySummaryId
            ),
            'recursive' => - 1
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
            'recursive' => - 1
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
            'recursive' => - 1
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
            'recursive' => - 1
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
            'recursive' => - 1
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
            'recursive' => - 1
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
    
    public function getSLLs()
    {
        $query = "SELECT id1, id2, ceil((flag_active_1_to_2 + flag_active_2_to_1)/2) active , ds2.`model` model, ds2.`plugin` plugin " .
                "FROM `datamart_browsing_controls` dbc " .
                "JOIN `datamart_structures` ds ON ds.id = dbc.id1 " .
                "JOIN `datamart_structures` ds2 ON ds2.id = dbc.id2 " .
                "where ds.model = 'StudySummary' and ds.plugin = 'Study' " .
                "union " .
                "SELECT id1, id2, ceil((flag_active_1_to_2 + flag_active_2_to_1)/2) active, ds.`model` model, ds.`plugin` plugin " .
                "FROM `datamart_browsing_controls` dbc " .
                "JOIN `datamart_structures` ds2 ON ds2.id = dbc.id2 " .
                "JOIN `datamart_structures` ds ON ds.id = dbc.id1 " .
                "where ds2.model = 'StudySummary' and ds2.plugin = 'Study' ";
        $result = $this->query($query);
        foreach ($result as $k=>$v){
            $result[$v[0]['model']] = $v[0];
            unset ($result[$k]);
        }
        return $result;
    }
}