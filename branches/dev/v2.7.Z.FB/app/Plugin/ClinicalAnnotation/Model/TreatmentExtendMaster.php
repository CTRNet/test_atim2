<?php

/**
 * Class TreatmentExtendMaster
 */
class TreatmentExtendMaster extends ClinicalAnnotationAppModel
{

    public $belongsTo = array(
        'TreatmentMaster' => array(
            'className' => 'ClinicalAnnotation.TreatmentMaster',
            'foreignKey' => 'treatment_master_id'
        ),
        'TreatmentExtendControl' => array(
            'className' => 'ClinicalAnnotation.TreatmentExtendControl',
            'foreignKey' => 'treatment_extend_control_id'
        ),
        'Drug' => array(
            'className' => 'Drug.Drug',
            'foreignKey' => 'drug_id'
        )
    );

    public static $drugModel = null;

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $this->validateAndUpdateTreatmentExtendDrugData();
        
        return parent::validates($options);
    }

    public function validateAndUpdateTreatmentExtendDrugData()
    {
        $treatmentExtendData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($treatmentExtendData);
        if ((! is_array($treatmentExtendData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['TreatmentExtendMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $treatmentExtendData) && array_key_exists('autocomplete_treatment_drug_id', $treatmentExtendData['FunctionManagement'])) {
            $treatmentExtendData['TreatmentExtendMaster']['drug_id'] = null;
            $treatmentExtendData['FunctionManagement']['autocomplete_treatment_drug_id'] = trim($treatmentExtendData['FunctionManagement']['autocomplete_treatment_drug_id']);
            if (strlen($treatmentExtendData['FunctionManagement']['autocomplete_treatment_drug_id'])) {
                // Load model
                if (self::$drugModel == null)
                    self::$drugModel = AppModel::getInstance("Drug", "Drug", true);
                    
                    // Check the treatment extend drug definition
                $arrDrugSelectionResults = self::$drugModel->getDrugIdFromDrugDataAndCode($treatmentExtendData['FunctionManagement']['autocomplete_treatment_drug_id']);
                
                // Set drug id
                if (isset($arrDrugSelectionResults['Drug'])) {
                    $treatmentExtendData['TreatmentExtendMaster']['drug_id'] = $arrDrugSelectionResults['Drug']['id'];
                    $this->addWritableField(array(
                        'drug_id'
                    ));
                }
                
                // Set error
                if (isset($arrDrugSelectionResults['error'])) {
                    $this->validationErrors['autocomplete_treatment_drug_id'][] = $arrDrugSelectionResults['error'];
                }
            }
        }
    }
}