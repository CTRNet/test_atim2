<?php

class TreatmentMasterCustom extends TreatmentMaster
{

    var $useTable = 'treatment_masters';

    var $name = 'TreatmentMaster';

    var $belongsTo = array(
        'TreatmentControl' => array(
            'className' => 'ClinicalAnnotation.TreatmentControl',
            'foreignKey' => 'treatment_control_id'
        ),
        'Drug' => array(
            'className' => 'Drug.Drug',
            'foreignKey' => 'procure_drug_id'
        )
    );

    private $txMethodForDataEntryValidation = null;

    public static $drugModel = null;

    public function setTxMethodForDataEntryValidation($txMethodForDataEntryValidation)
    {
        $this->txMethodForDataEntryValidation = $txMethodForDataEntryValidation;
    }

    public function validates($options = array())
    {
        $result = parent::validates($options);
        
        $treatmentData = & $this->data;
        
        // Validate and set procure_drug_id
        
        $tmpArrToCheck = array_values($treatmentData);
        if ((! is_array($treatmentData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['TreatmentExtendMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (array_key_exists('FunctionManagement', $treatmentData) && array_key_exists('autocomplete_treatment_drug_id', $treatmentData['FunctionManagement'])) {
            $treatmentData['TreatmentMaster']['procure_drug_id'] = null;
            $treatmentData['FunctionManagement']['autocomplete_treatment_drug_id'] = trim($treatmentData['FunctionManagement']['autocomplete_treatment_drug_id']);
            if (strlen($treatmentData['FunctionManagement']['autocomplete_treatment_drug_id'])) {
                // Load model
                if (self::$drugModel == null)
                    self::$drugModel = AppModel::getInstance("Drug", "Drug", true);
                    
                    // Check the treatment extend drug definition
                $arrDrugSelectionResults = self::$drugModel->getDrugIdFromDrugDataAndCode($treatmentData['FunctionManagement']['autocomplete_treatment_drug_id']);
                if (isset($arrDrugSelectionResults['Drug'])) {
                    // Set drug id
                    $treatmentData['TreatmentMaster']['procure_drug_id'] = $arrDrugSelectionResults['Drug']['id'];
                    $this->addWritableField(array(
                        'procure_drug_id'
                    ));
                } elseif (isset($arrDrugSelectionResults['error'])) {
                    // Set error
                    $this->validationErrors['autocomplete_treatment_drug_id'][] = $arrDrugSelectionResults['error'];
                    $result = false;
                } else {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
        
        if (array_key_exists('TreatmentDetail', $this->data)) {
            $fieldControls = array(
                // 'treatment_line' => array(
                // 'line',
                // array('chemotherapy', 'experimental treatment', 'hormonotherapy'),
                // __('chemotherapy').' & '. __('experimental treatment').' & '. __('hormonotherapy')),
                'surgery_type' => array(
                    'TreatmentDetail',
                    'surgery detail',
                    array(
                        'surgery'
                    ),
                    __('surgery')
                ),
                'treatment_site' => array(
                    'TreatmentDetail',
                    'site',
                    array(
                        'antalgic radiotherapy',
                        'radiotherapy',
                        'brachytherapy',
                        'surgery'
                    ),
                    __('antalgic radiotherapy') . ' & ' . __('radiotherapy') . ' & ' . __('brachytherapy') . ' & ' . __('surgery')
                ),
                'treatment_combination' => array(
                    'TreatmentDetail',
                    'treatment combination',
                    array(
                        'antalgic radiotherapy',
                        'radiotherapy',
                        'brachytherapy',
                        'chemotherapy',
                        'experimental treatment',
                        'hormonotherapy'
                    ),
                    __('antalgic radiotherapy') . ' & ' . __('radiotherapy') . ' & ' . __('brachytherapy') . ' & ' . __('chemotherapy') . ' & ' . __('experimental treatment') . ' & ' . __('hormonotherapy')
                ),
                'procure_drug_id' => array(
                    'TreatmentMaster',
                    'drug',
                    array(
                        'chemotherapy',
                        'experimental treatment',
                        'hormonotherapy',
                        'immunotherapy',
                        'medication',
                        'other diseases medication',
                        'prostate medication'
                    ),
                    __('chemotherapy') . ' & ' . __('experimental treatment') . ' & ' . __('hormonotherapy') . ' & ' . __('immunotherapy') . ' & ' . __('medication') . ' & ' . __('other diseases medication') . ' & ' . __('prostate medication')
                )
            );
            foreach ($fieldControls as $fied => $fiedData) {
                ;
                list ($tmpModel, $fieldLabel, $txTypes, $msg) = $fiedData;
                if (array_key_exists($fied, $this->data[$tmpModel]) && $this->data[$tmpModel][$fied]) {
                    if (! in_array($this->data['TreatmentDetail']['treatment_type'], $txTypes)) {
                        $result = false;
                        $this->validationErrors[$fied][] = __('field [%s] can only be completed for following treatment(s) : %s', __($fieldLabel), $msg);
                    }
                }
            }
        }
        
        return $result;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        foreach ($results as &$newTx) {
            if (isset($newTx['Drug']['procure_study']) && $newTx['Drug']['procure_study']) {
                $newTx['Drug']['generic_name'] .= ' (' . __('experimental treatment') . ')';
            }
        }
        return $results;
    }
}