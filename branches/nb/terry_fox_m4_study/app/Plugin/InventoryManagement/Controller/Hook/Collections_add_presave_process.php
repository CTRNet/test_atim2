<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

// Collection could only be linked to a participant
if (($collectionData && ! $collectionData['Collection']['participant_id']) || (! $collectionData && ! isset($this->request->data['Collection']['participant_id']))) {
    $submittedDataValidates = false;
    $this->Collection->validationErrors['participant_id'][] = __('a created collection should be linked to a participant');
}
// Add '0' to a 1 digit visit id
if(preg_match('/^[1-9]$/', $this->request->data['Collection']['tfri_m4s_visit_id'])) {
    $this->request->data['Collection']['tfri_m4s_visit_id'] = '0'.$this->request->data['Collection']['tfri_m4s_visit_id'];
}