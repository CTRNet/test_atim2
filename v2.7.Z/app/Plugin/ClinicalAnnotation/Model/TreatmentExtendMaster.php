<?php

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

    public static $drug_model = null;

    function validates($options = array())
    {
        $this->validateAndUpdateTreatmentExtendDrugData();
        
        return parent::validates($options);
    }

    function validateAndUpdateTreatmentExtendDrugData()
    {
        $treatment_extend_data = & $this->data;
        
        // check data structure
        $tmp_arr_to_check = array_values($treatment_extend_data);
        if ((! is_array($treatment_extend_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['TreatmentExtendMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $treatment_extend_data) && array_key_exists('autocomplete_treatment_drug_id', $treatment_extend_data['FunctionManagement'])) {
            $treatment_extend_data['TreatmentExtendMaster']['drug_id'] = null;
            $treatment_extend_data['FunctionManagement']['autocomplete_treatment_drug_id'] = trim($treatment_extend_data['FunctionManagement']['autocomplete_treatment_drug_id']);
            if (strlen($treatment_extend_data['FunctionManagement']['autocomplete_treatment_drug_id'])) {
                // Load model
                if (self::$drug_model == null)
                    self::$drug_model = AppModel::getInstance("Drug", "Drug", true);
                    
                    // Check the treatment extend drug definition
                $arr_drug_selection_results = self::$drug_model->getDrugIdFromDrugDataAndCode($treatment_extend_data['FunctionManagement']['autocomplete_treatment_drug_id']);
                
                // Set drug id
                if (isset($arr_drug_selection_results['Drug'])) {
                    $treatment_extend_data['TreatmentExtendMaster']['drug_id'] = $arr_drug_selection_results['Drug']['id'];
                    $this->addWritableField(array(
                        'drug_id'
                    ));
                }
                
                // Set error
                if (isset($arr_drug_selection_results['error'])) {
                    $this->validationErrors['autocomplete_treatment_drug_id'][] = $arr_drug_selection_results['error'];
                }
            }
        }
    }
}