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

// Unset UHN session data in case
unset($_SESSION['uhn']['participants_found_in_hospital_system']);

// Check participant exists into hospital system based on MRN number
$participantFoundInHospitalSystem = false;
if (empty($this->request->data) && ! empty($uhnUnformatedSearchCriteria)) {
    // No result in ATiM based on search criteria. MRN number(s) is part of the criteria.
    
    // TODO: Launch Nazish Qazi code
    
    // TODO: Replace following array by the result of Nazish Qazi code
    $nazishQaziSourceCodeResult = array(
        array(
            'mrn' => 'QWE12345',
            'first name' => 'James',
            'last name' => 'Bond',
            'birth date' => '1946-05-02'
        ),
        array(
            'mrn' => 'QWE14447',
            'first name' => 'Bat',
            'last name' => 'Man',
            'birth date' => '1933-01-22'
        )
    );
    
    if (empty($nazishQaziSourceCodeResult)) {
        AppController::addWarningMsg(__('uhn_warning_participant_not_found_in_hospital_system'));
    } else {
        AppController::addWarningMsg(__('uhn_warning_participant_found_in_hospital_system'));
        foreach ($nazishQaziSourceCodeResult as $uhnResultKey => $uhnResultData) {
            $participantFoundInHospitalSystem = true;
            $this->request->data[$uhnResultKey] = array(
                'Participant' => array(
                    'uhn_result_key' => $uhnResultKey,
                    'participant_identifier' => 'To create',
                    'uhn_mrn_number' => $uhnResultData['mrn'],
                    'first_name' => $uhnResultData['first name'],
                    'last_name' => $uhnResultData['last name'],
                    'date_of_birth' => $uhnResultData['birth date']
                )
            );
        }
        
        $_SESSION['uhn']['participants_found_in_hospital_system'] = $this->request->data;
        
        // TODO: Sort on 'field' has to me manager
    }
}
$this->set('participantFoundInHospitalSystem', $participantFoundInHospitalSystem);
