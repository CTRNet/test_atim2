<?php

/**
 * Class ConsentMasterCustom
 *
 * @author Nicolas Luc
 *
 * @package ATiM CUSM
 */
class ConsentMasterCustom extends ConsentMaster
{

    var $useTable = 'consent_masters';

    var $name = "ConsentMaster";

//     private static $consentControlModel = null;

//     private static $bankModel = null;

//     /**
//      * Generate warning if the witness is not a person of a/the bank.
//      *
//      *
//      * @author Nicolas Luc 2017-11-15
//      *        
//      * @param array $options An optional array of custom options to be made available in the beforeValidate callback
//      * 
//      * @return bool True if there are no errors
//      */
//     public function validates($options = array())
//     {
//         $result = parent::validates($options);
        
//         // Validate Witness - Bank Staff
//         // ----------------------------------------------------------
        
//         if (isset($this->data['ConsentMaster']) && isset($this->data['ConsentMaster']['consent_person']) && strlen($this->data['ConsentMaster']['consent_person'])) {
            
//             // Get Bank Name
//             $consentControlType = null;
//             if (isset($this->data['ConsentMaster']['consent_control_id'])) {
//                 $consentControlId = $this->data['ConsentMaster']['consent_control_id'];
//                 if (self::$consentControlModel == null) {
//                     self::$consentControlModel = AppModel::getInstance('ClinicalAnnotation', 'ConsentControl', true);
//                 }
//                 $consentControl = self::$consentControlModel->getOrRedirect($consentControlId);
//                 $consentControlType = $consentData['ConsentControl']['controls_type'];
//             } elseif ($this->id) {
//                 $consentData = $this->find('first', array(
//                     'conditions' => array(
//                         'ConsentMaster.id' => $this->id
//                     ),
//                     'fields' => array(
//                         'ConsentControl.controls_type'
//                     ),
//                     'recursive' => '-1'
//                 ));
//                 if ($consentData) {
//                     $consentControlType = $consentData['ConsentControl']['controls_type'];
//                 }
//             }
//             $bank = '';
//             if ($consentControlType && preg_match('/^([a-z]+)\ \- consent$/', $consentControlType, $matches)) {
//                 $bank = $matches[1];
//             }
            
//             // Validate Witness (bank person)
//             if (self::$bankModel == null) {
//                 self::$bankModel = AppModel::getInstance('Administrate', 'Bank', true);
//             }
//             $validatedBankStaff = self::$bankModel->validateBankStaff($this->data['ConsentMaster']['consent_person'], $bank);
//             if ($validatedBankStaff) {
//                 if (sizeof($validatedBankStaff) > 1) {
//                     $this->validationErrors['consent_person'][] = "more than one bank staff matches the value entered into the 'witness' field - please select the exact name";
//                     $result = false;
//                 } else {
//                     $validatedBankStaff = array_shift($validatedBankStaff);
//                     if ($this->data['ConsentMaster']['consent_person'] != $validatedBankStaff) {
//                         AppController::addWarningMsg(__("the value entered into the 'witness' field has been replaced by the name of the bank staff '%s' matching the entered value - please validate", $validatedBankStaff));
//                     }
//                     $this->data['ConsentMaster']['consent_person'] = $validatedBankStaff;
//                 }
//             } else {
//                 AppController::addWarningMsg(__("no staff of the bank(s) corresponds to the value '%s' entered into the 'witness' field - please validate", $this->data['ConsentMaster']['consent_person']));
//             }
//         }
//         return $result;
//     }
}