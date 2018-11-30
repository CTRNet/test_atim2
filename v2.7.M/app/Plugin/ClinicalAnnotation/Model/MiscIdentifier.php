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
 * Class MiscIdentifier
 */
class MiscIdentifier extends ClinicalAnnotationAppModel
{

    public $belongsTo = array(
        'Participant' => array(
            'className' => 'ClinicalAnnotation.Participant',
            'foreignKey' => 'participant_id'
        ),
        'MiscIdentifierControl' => array(
            'className' => 'ClinicalAnnotation.MiscIdentifierControl',
            'foreignKey' => 'misc_identifier_control_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    private $confidWarningAbsent = true;

    public static $studyModel = null;

    /**
     *
     * @param array $variables
     * @return bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        // if ( isset($variables['MiscIdentifier.id']) ) {
        //
        // $result = $this->find('first', array('conditions'=>array('MiscIdentifier.id'=>$variables['MiscIdentifier.id'])));
        //
        // $return = array(
        // 'name' => array( null, $result['MiscIdentifier']['name']),
        // 'participant_id' => array( null, $result['MiscIdentifier']['participant_id']),
        // 'data' => $result,
        // 'structure alias'=>'miscidentifiers'
        // );
        // }
        
        return $return;
    }

    /**
     *
     * @param array $queryData
     * @return array
     */
    public function beforeFind($queryData)
    {
        if (! AppController::getInstance()->Session->read('flag_show_confidential') && is_array($queryData['conditions']) && AppModel::isFieldUsedAsCondition("MiscIdentifier.identifier_value", $queryData['conditions'])) {
            if ($this->confidWarningAbsent) {
                AppController::addWarningMsg(__('due to your restriction on confidential data, your search did not return confidential identifiers'));
                $this->confidWarningAbsent = false;
            }
            $miscControlModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
            $confidentialControlIds = $miscControlModel->getConfidentialIds();
            $queryData['conditions'][] = array(
                "MiscIdentifier.misc_identifier_control_id NOT" => $miscControlModel->getConfidentialIds()
            );
        }
        return $queryData;
    }

    /**
     *
     * @param string $type
     * @param array $query
     * @return array|null
     */
    public function find($type = 'first', $query = array())
    {
        if (isset($query['conditions'])) {
            $gtKey = array_key_exists('MiscIdentifier.identifier_value >=', $query['conditions']);
            $ltKey = array_key_exists('MiscIdentifier.identifier_value <=', $query['conditions']);
            if ($gtKey || $ltKey) {
                $infValue = $gtKey ? str_replace(',', '.', $query['conditions']['MiscIdentifier.identifier_value >=']) : '';
                $supValue = $ltKey ? str_replace(',', '.', $query['conditions']['MiscIdentifier.identifier_value <=']) : '';
                if (strlen($infValue . $supValue) && (is_numeric($infValue) || ! strlen($infValue)) && (is_numeric($supValue) || ! strlen($supValue))) {
                    // Return just numeric
                    $query['conditions']['MiscIdentifier.identifier_value REGEXP'] = "^[0-9]+([\,\.][0-9]+){0,1}$";
                    // Define range
                    if ($gtKey) {
                        $query['conditions']["(REPLACE(MiscIdentifier.identifier_value, ',','.') * 1) >="] = $infValue;
                        unset($query['conditions']['MiscIdentifier.identifier_value >=']);
                    }
                    if ($ltKey) {
                        $query['conditions']["(REPLACE(MiscIdentifier.identifier_value, ',','.') * 1) <="] = $supValue;
                        unset($query['conditions']['MiscIdentifier.identifier_value <=']);
                    }
                    // Manage Order
                    if (! isset($query['order'])) {
                        // supperfluou?s
                        $query['order'][] = "(REPLACE(MiscIdentifier.identifier_value, ',','.') * 1)";
                    } elseif (is_array($query['order']) && isset($query['order']['MiscIdentifier.identifier_value'])) {
                        $query['order']["(REPLACE(MiscIdentifier.identifier_value, ',','.') * 1)"] = $query['order']['MiscIdentifier.identifier_value'];
                        unset($query['order']['MiscIdentifier.identifier_value']);
                    } elseif (is_string($query['order']) && preg_match('/^MiscIdentifier.identifier_value\ ([A-Za-z]+)$/', $query['order'], $matches)) {
                        $orderBy = $matches[1];
                        $query['order'] = "IF(concat('', REPLACE(MiscIdentifier.identifier_value, ',', '.') * 1) = REPLACE(MiscIdentifier.identifier_value, ',', '.'), '0', '1') $orderBy, MiscIdentifier.identifier_value*IF(concat('',REPLACE(MiscIdentifier.identifier_value, ',', '.') * 1) = REPLACE(MiscIdentifier.identifier_value, ',', '.'), '1', '') $orderBy, MiscIdentifier.identifier_value $orderBy";
                    }
                }
            }
        }
        
        if (isset($query['order'])) {
            if (is_array($query['order']) && isset($query['order']['MiscIdentifier.identifier_value']) && sizeof($query['order']) == 1) {
                // Display first numerical values then alphanumerical values
                $orderBy = $query['order']['MiscIdentifier.identifier_value'];
                $query['order'][] = "IF(concat('',REPLACE(MiscIdentifier.identifier_value, ',', '.') * 1) = REPLACE(MiscIdentifier.identifier_value, ',', '.'), '0', '1') $orderBy, MiscIdentifier.identifier_value*IF(concat('',REPLACE(MiscIdentifier.identifier_value, ',', '.') * 1) = REPLACE(MiscIdentifier.identifier_value, ',', '.'), '1', '') $orderBy, MiscIdentifier.identifier_value $orderBy";
                unset($query['order']['MiscIdentifier.identifier_value']);
            } elseif (is_string($query['order']) && preg_match('/^MiscIdentifier.identifier_value\ ([A-Za-z]+)$/', $query['order'], $matches)) {
                $orderBy = $matches[1];
                $query['order'] = "IF(concat('', REPLACE(MiscIdentifier.identifier_value, ',', '.') * 1) = REPLACE(MiscIdentifier.identifier_value, ',', '.'), '0', '1') $orderBy, MiscIdentifier.identifier_value*IF(concat('',REPLACE(MiscIdentifier.identifier_value, ',', '.') * 1) = REPLACE(MiscIdentifier.identifier_value, ',', '.'), '1', '') $orderBy, MiscIdentifier.identifier_value $orderBy";
            }
        }
        
        return parent::find($type, $query);
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        if (! AppController::getInstance()->Session->read('flag_show_confidential') && isset($results[0]) && isset($results[0]['MiscIdentifier'])) {
            $miscControlModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
            $confidentialControlIds = $miscControlModel->getConfidentialIds();
            if (! empty($confidentialControlIds)) {
                if (isset($results[0]) && isset($results[0]['MiscIdentifier'])) {
                    if (isset($results[0]['MiscIdentifier']['misc_identifier_control_id'])) {
                        foreach ($results as &$result) {
                            if (in_array($result['MiscIdentifier']['misc_identifier_control_id'], $confidentialControlIds)) {
                                $result['MiscIdentifier']['identifier_value'] = CONFIDENTIAL_MARKER;
                            }
                        }
                    } elseif (isset($results[0]['MiscIdentifier'][0]) && isset($results[0]['MiscIdentifier'][0]['misc_identifier_control_id'])) {
                        foreach ($results[0]['MiscIdentifier'] as &$result) {
                            if (in_array($result['misc_identifier_control_id'], $confidentialControlIds)) {
                                $result['identifier_value'] = CONFIDENTIAL_MARKER;
                            }
                        }
                    } else {
                        $warn = true;
                    }
                } else {
                    $warn = true;
                }
                if (isset($warn) && $warn && Configure::read('debug') > 0) {
                    AppController::addWarningMsg('unable to parse MiscIdentifier result', true);
                }
            }
        }
        return $results;
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $errors = parent::validates($options);
        
        if (! isset($this->data['MiscIdentifier']['deleted']) || $this->data['MiscIdentifier']['deleted'] == 0) {
            if (isset($this->validationErrors['identifier_value']) && ! is_array($this->validationErrors['identifier_value'])) {
                $this->validationErrors['identifier_value'] = array(
                    $this->validationErrors['identifier_value']
                );
            }
            $rule = null;
            $current = null;
            if ($this->id) {
                $current = $this->findById($this->id);
            } else {
                assert($this->data['MiscIdentifier']['misc_identifier_control_id']) or die('Missing Identifier Control Id');
                $miscIdentifierControlModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifierControl');
                $current = $miscIdentifierControlModel->findById($this->data['MiscIdentifier']['misc_identifier_control_id']);
            }
            if ($current && $current['MiscIdentifierControl']['reg_exp_validation']) {
                $rule = $current['MiscIdentifierControl']['reg_exp_validation'];
            }
            if ($rule && isset($this->data['MiscIdentifier']['identifier_value']) && ! preg_match('/' . $rule . '/', $this->data['MiscIdentifier']['identifier_value'])) {
                $msg = __('the format of the identifier is incorrect');
                if (! empty($current['MiscIdentifierControl']['user_readable_format']))
                    $msg .= ' ' . __('expected misc identifier format is %s', $current['MiscIdentifierControl']['user_readable_format']);
                $this->validationErrors['identifier_value'][] = $msg;
                return false;
            }
        }
        
        if (! $this->validateAndUpdateMiscIdentifierStudyData())
            return false;
        
        return $errors;
    }

    /**
     * Check MiscIdentifier study definition and set error if required.
     */
    public function validateAndUpdateMiscIdentifierStudyData()
    {
        $miscIdentifierData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($miscIdentifierData);
        if ((! is_array($miscIdentifierData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['MiscIdentifier']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $miscIdentifierData) && array_key_exists('autocomplete_misc_identifier_study_summary_id', $miscIdentifierData['FunctionManagement'])) {
            $miscIdentifierData['MiscIdentifier']['study_summary_id'] = null;
            $miscIdentifierData['FunctionManagement']['autocomplete_misc_identifier_study_summary_id'] = trim($miscIdentifierData['FunctionManagement']['autocomplete_misc_identifier_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($miscIdentifierData['FunctionManagement']['autocomplete_misc_identifier_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($miscIdentifierData['FunctionManagement']['autocomplete_misc_identifier_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $miscIdentifierData['MiscIdentifier']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_misc_identifier_study_summary_id'][] = $arrStudySelectionResults['error'];
                    return false;
                }
            }
        }
        
        return true;
    }
    
    public function saveValidateState($displayAddForm) {
        $validationRules = $this->validate;
        if (!$displayAddForm) {
            if (isset($this->validate["identifier_value"]) && is_array($this->validate["identifier_value"])) {
                foreach ($this->validate["identifier_value"] as &$value) {
                    if (isset($value['allowEmpty'])){
                        $value['allowEmpty'] = true;
                    }
                }
            }
        }
        return $validationRules;
    }

    public function restoreValidateState($saveState) {
        $this->validate = $saveState;
    }

}