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

// Keep MRN Number search criteria in memory to search them on hospital system
$uhnUnformatedSearchCriteria = null;
if (! empty($searchId) && $this->request->data && isset($this->request->data['Participant']['uhn_mrn_number'])) {
    $uhnUnformatedSearchCriteria = array_filter($this->request->data['Participant']['uhn_mrn_number']);
}
