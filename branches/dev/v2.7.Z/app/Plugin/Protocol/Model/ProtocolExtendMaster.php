<?php

class ProtocolExtendMaster extends ProtocolAppModel
{

    var $belongsTo = array(
        'ProtocolExtendControl' => array(
            'className' => 'Protocol.ProtocolExtendControl',
            'foreignKey' => 'protocol_extend_control_id'
        ),
        'Drug' => array(
            'className' => 'Drug.Drug',
            'foreignKey' => 'drug_id'
        )
    );

    public static $drug_model = null;

    function validates($options = array())
    {
        $this->validateAndUpdateProtocolExtendDrugData();
        
        return parent::validates($options);
    }

    function validateAndUpdateProtocolExtendDrugData()
    {
        $protocol_extend_data = & $this->data;
        
        // check data structure
        $tmp_arr_to_check = array_values($protocol_extend_data);
        if ((! is_array($protocol_extend_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['ProtocolExtendMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $protocol_extend_data) && array_key_exists('autocomplete_protocol_drug_id', $protocol_extend_data['FunctionManagement'])) {
            $protocol_extend_data['ProtocolExtendMaster']['drug_id'] = null;
            $protocol_extend_data['FunctionManagement']['autocomplete_protocol_drug_id'] = trim($protocol_extend_data['FunctionManagement']['autocomplete_protocol_drug_id']);
            if (strlen($protocol_extend_data['FunctionManagement']['autocomplete_protocol_drug_id'])) {
                // Load model
                if (self::$drug_model == null)
                    self::$drug_model = AppModel::getInstance("Drug", "Drug", true);
                    
                    // Check the protocol extend drug definition
                $arr_drug_selection_results = self::$drug_model->getDrugIdFromDrugDataAndCode($protocol_extend_data['FunctionManagement']['autocomplete_protocol_drug_id']);
                
                // Set drug id
                if (isset($arr_drug_selection_results['Drug'])) {
                    $protocol_extend_data['ProtocolExtendMaster']['drug_id'] = $arr_drug_selection_results['Drug']['id'];
                    $this->addWritableField(array(
                        'drug_id'
                    ));
                }
                
                // Set error
                if (isset($arr_drug_selection_results['error'])) {
                    $this->validationErrors['autocomplete_protocol_drug_id'][] = $arr_drug_selection_results['error'];
                }
            }
        }
    }
}

?>