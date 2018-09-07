<?php

/**
 * Class ProtocolExtendMaster
 */
class ProtocolExtendMaster extends ProtocolAppModel
{

    public $belongsTo = array(
        'ProtocolExtendControl' => array(
            'className' => 'Protocol.ProtocolExtendControl',
            'foreignKey' => 'protocol_extend_control_id'
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
        $this->validateAndUpdateProtocolExtendDrugData();
        
        return parent::validates($options);
    }

    public function validateAndUpdateProtocolExtendDrugData()
    {
        $protocolExtendData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($protocolExtendData);
        if ((! is_array($protocolExtendData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['ProtocolExtendMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $protocolExtendData) && array_key_exists('autocomplete_protocol_drug_id', $protocolExtendData['FunctionManagement'])) {
            $protocolExtendData['ProtocolExtendMaster']['drug_id'] = null;
            $protocolExtendData['FunctionManagement']['autocomplete_protocol_drug_id'] = trim($protocolExtendData['FunctionManagement']['autocomplete_protocol_drug_id']);
            if (strlen($protocolExtendData['FunctionManagement']['autocomplete_protocol_drug_id'])) {
                // Load model
                if (self::$drugModel == null)
                    self::$drugModel = AppModel::getInstance("Drug", "Drug", true);
                    
                    // Check the protocol extend drug definition
                $arrDrugSelectionResults = self::$drugModel->getDrugIdFromDrugDataAndCode($protocolExtendData['FunctionManagement']['autocomplete_protocol_drug_id']);
                
                // Set drug id
                if (isset($arrDrugSelectionResults['Drug'])) {
                    $protocolExtendData['ProtocolExtendMaster']['drug_id'] = $arrDrugSelectionResults['Drug']['id'];
                    $this->addWritableField(array(
                        'drug_id'
                    ));
                }
                
                // Set error
                if (isset($arrDrugSelectionResults['error'])) {
                    $this->validationErrors['autocomplete_protocol_drug_id'][] = $arrDrugSelectionResults['error'];
                }
            }
        }
    }
}