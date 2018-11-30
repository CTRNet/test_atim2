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
 * Class AliquotInternalUse
 */
class AliquotInternalUse extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'aliquot_master_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'AliquotInternalUse.id'
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
        $this->validateAndUpdateAliquotInternalUseStudyData();
        
        return parent::validates($options);
    }

    /**
     * Check internal use study definition and set error if required.
     */
    public function validateAndUpdateAliquotInternalUseStudyData()
    {
        $aliquotInternalUseData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($aliquotInternalUseData);
        if ((! is_array($aliquotInternalUseData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['AliquotInternalUse']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $aliquotInternalUseData) && array_key_exists('autocomplete_aliquot_internal_use_study_summary_id', $aliquotInternalUseData['FunctionManagement'])) {
            $aliquotInternalUseData['AliquotInternalUse']['study_summary_id'] = null;
            $aliquotInternalUseData['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id'] = trim($aliquotInternalUseData['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id']);
            if (strlen($aliquotInternalUseData['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($aliquotInternalUseData['FunctionManagement']['autocomplete_aliquot_internal_use_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $aliquotInternalUseData['AliquotInternalUse']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_aliquot_internal_use_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }
}