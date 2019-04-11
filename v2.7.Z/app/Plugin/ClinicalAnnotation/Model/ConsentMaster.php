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
 * Class ConsentMaster
 */
class ConsentMaster extends ClinicalAnnotationAppModel
{

    public $belongsTo = array(
        'ConsentControl' => array(
            'className' => 'ClinicalAnnotation.ConsentControl',
            'foreignKey' => 'consent_control_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    public $hasMany = array(
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'consent_master_id'
        )
    );

    public static $joinConsentControlOnDup = array(
        'table' => 'consent_controls',
        'alias' => 'ConsentControl',
        'type' => 'LEFT',
        'conditions' => array(
            'consent_masters_dup.consent_control_id = ConsentControl.id'
        )
    );

    public static $studyModel = null;

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $this->validateAndUpdateConsentStudyData();
        
        return parent::validates($options);
    }

    /**
     * Check consent study definition and set error if required.
     */
    public function validateAndUpdateConsentStudyData()
    {
        $consentData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($consentData);
        if ((! is_array($consentData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['ConsentMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $consentData) && array_key_exists('autocomplete_consent_study_summary_id', $consentData['FunctionManagement'])) {
            $consentData['ConsentMaster']['study_summary_id'] = null;
            $consentData['FunctionManagement']['autocomplete_consent_study_summary_id'] = trim($consentData['FunctionManagement']['autocomplete_consent_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($consentData['FunctionManagement']['autocomplete_consent_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($consentData['FunctionManagement']['autocomplete_consent_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $consentData['ConsentMaster']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_consent_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $consentMasterId Id of the studied record.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($consentMasterId)
    {
        $arrAllowDeletion = array(
            'allow_deletion' => true,
            'msg' => ''
        );
        
        $collectionModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $returnedNbr = $collectionModel->find('count', array(
            'conditions' => array(
                'Collection.consent_master_id' => $consentMasterId
            )
        ));
        if ($returnedNbr > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_consent_linked_collection';
        }
        return $arrAllowDeletion;
    }

    /**
     *
     * @param $onField
     * @return array
     */
    public static function joinOnConsentDup($onField)
    {
        return array(
            'table' => 'consent_masters',
            'alias' => 'consent_masters_dup',
            'type' => 'LEFT',
            'conditions' => array(
                $onField . ' = consent_masters_dup.id'
            )
        );
    }
}