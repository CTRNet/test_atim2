<?php

/**
 * Class BankCustom
 * 
 * @author Nicolas Luc
 * 
 * @package ATiM CUSM
 */
class BankCustom extends Bank
{

    var $useTable = 'banks';

    var $name = "Bank";

    /**
     * Block any modification of bank data.
     *
     * @author Nicolas Luc
     *        
     * @param array $options
     *            An optional array of custom options to be made available in the beforeValidate callback
     *            
     * @return bool True if there are no errors
     */
    public function validates($options = array())
    {
        $result = parent::validates($options);
        $this->validationErrors['name'][] = 'you are not allowed to create/modify the data';
        $result = false;
        return false;
    }
    /**
     * Block any modification of bank data.
     *
     * @author Nicolas Luc
     * 
     * @param int $bankId Id of the bank to deleted.
     * 
     * @return array Information about the right to delete or not the bank.
     */
    public function allowDeletion($bankId)
    {
        return array(
            'allow_deletion' => false,
            'msg' => 'you are not allowed to create/modify the data'
        );
    }

//     private static $structurePermissibleValuesCustomModel = null;

//     /**
//      * Return the name of the bank linked to the group of the user.
//      *
//      * @author Nicolas Luc
//      *        
//      * @param None
//      *            
//      * @return string The bank name (in english) of the user group
//      *         or '-1' if the user group is not linked to a bank
//      *         or '%' if the user is part of the 'Administrators' group
//      */
//     public function getUserBankName()
//     {
//         $userGroupData = AppController::getInstance()->Session->read('Auth.User.Group');
//         if (! isset($_SESSION['CUSM_SESSION_DATA']['user_bank']['name']) || $_SESSION['CUSM_SESSION_DATA']['user_bank']['id'] != $userGroupData['bank_id']) {
//             $_SESSION['CUSM_SESSION_DATA']['user_bank']['id'] = $userGroupData['bank_id'];
//             if ($userGroupData['name'] == 'Administrators') {
//                 $_SESSION['CUSM_SESSION_DATA']['user_bank_name'] = '%';
//             } elseif (! $userGroupData['bank_id']) {
//                 $_SESSION['CUSM_SESSION_DATA']['user_bank_name'] = '-1';
//             } else {
//                 $bankData = $this->find('first', array(
//                     'conditions' => array(
//                         'Bank.id' => $userGroupData['bank_id']
//                     )
//                 ));
//                 $bankNames = explode('/', $bankData['Bank']['name']);
//                 $_SESSION['CUSM_SESSION_DATA']['user_bank_name'] = strtolower($bankNames[0]);
//             }
//         }
//         return $_SESSION['CUSM_SESSION_DATA']['user_bank_name'];
//     }
    
    
    
    
    
    
    
    
    
    
//     //TODO
//     function validateBankStaff($bankStaff) {
//         if(self::$structurePermissibleValuesCustomModel == null) {
//             self::$structurePermissibleValuesCustomModel = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
//         }
//         $conditions = array("StructurePermissibleValuesCustomControl.name LIKE" => (strlen($bankName)? $bankName : '%') . ' - Bank Staff');
//         $term = trim(str_replace(array( "\\", '%', '_'), array("\\\\", '\%', '\_'), $bankStaff));
//         $term_conditions = array();
//         foreach(explode(' ', $term) as $new_term) {
//             $conditions['AND'][] = array("StructurePermissibleValuesCustom.value LIKE" => '%'.$new_term.'%');
//         }
//         $resStaff = self::$structurePermissibleValuesCustomModel->find('all', array('conditions' => $conditions, 'fields' => 'StructurePermissibleValuesCustom.value', 'order' => 'StructurePermissibleValuesCustom.value ASC'));
//         $valdiatedResStaff = array();
//         foreach($resStaff as $newResStaff) {
//             $valdiatedResStaff[$newResStaff['StructurePermissibleValuesCustom']['value']] = $newResStaff['StructurePermissibleValuesCustom']['value'];
//         }
//         return $valdiatedResStaff;
//     }
}