<?php

/**
 * Class BanksControllerCustom
 * 
 * @author Nicolas Luc
 * 
 * @package ATiM CUSM
 */
class BanksControllerCustom extends BanksController
{

    /**
     * Set a variable 'result' with limited list of the persons of the bank of the user (excepted for users of the 'Administrators' group)
     * that match characters entered into the form field linked to this autocomplete function.
     *
     * @author Nicolas Luc
     * 
     * @param -
     *        
     * @return -
     */
//     public function autocompleteBankPerson()
//     {
        
//         // layout = ajax to avoid printing layout
//         $this->layout = 'ajax';
//         // debug = 0 to avoid printing debug queries that would break the javascript array
//         Configure::write('debug', 0);
        
//         $userBankName = $this->Bank->getUserBankName();
        
//         // query the database
//         $conditions = array(
//             "StructurePermissibleValuesCustomControl.name LIKE" => $userBankName . ' - bank staff'
//         );
//         $term = trim(str_replace(array("\\", '%', '_' ), array("\\\\", '\%', '\_' ), $_GET['term']));
//         foreach (explode(' ', $term) as $newTerm) {
//             $conditions['AND'][] = array(
//                 "StructurePermissibleValuesCustom.value LIKE" => '%' . $newTerm . '%'
//             );
//         }
//         $this->StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
//         $bankStaff = $this->StructurePermissibleValuesCustom->find('all', array(
//             'conditions' => $conditions,
//             'fields' => 'StructurePermissibleValuesCustom.value',
//             'order' => 'StructurePermissibleValuesCustom.value ASC'
//         ));
        
//         // build javascript textual array
//         $result = "";
//         $count = 0;
//         foreach ($bankStaff as $newPerson) {
//             $result .= '"' . str_replace(array('\\', '"'), array('\\\\', '\"'), $newPerson['StructurePermissibleValuesCustom']['value']) . '", ';
//             ++ $count;
//             if ($count > 9) {
//                 break;
//             }
//         }
//         if (sizeof($result) > 0) {
//             $result = substr($result, 0, - 2);
//         }
//         $this->set('result', "[" . $result . "]");
//     }
}