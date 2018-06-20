<?php

/** **********************************************************************
 * UHN
 * ***********************************************************************
 *
 * CLinicalAnnotation plugin custom code
 *
 * Class AliquotMasterCustom
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-06-20
 */

// User is creating a new participant found in hospital system
// Set default data
if ($this->passedArgs && isset($this->passedArgs[0]) && preg_match('/^uhn_result_key=([0-9]+)$/', $this->passedArgs[0], $matches)) {
    if (isset($_SESSION['uhn']['participants_found_in_hospital_system'][$matches[1]])) {
        $uhnOverrideData = array();
        foreach ($_SESSION['uhn']['participants_found_in_hospital_system'][$matches[1]] as $uhnModel => $uhnModelData) {
            foreach ($uhnModelData as $uhnField => $uhnValue) {
                if ($uhnField != 'uhn_result_key') {
                    $uhnOverrideData[$uhnModel . '.' . $uhnField] = $uhnValue;
                }
            }
        }
    }
    $this->set('uhnOverrideData', $uhnOverrideData);
    AppController::addWarningMsg(__('uhn_warning_create_participant_form_hospital_system'));
}
unset($_SESSION['uhn']['participants_found_in_hospital_system']);
