<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// Collection could only be linked to a participant
if (($collectionData && ! $collectionData['Collection']['participant_id']) || (! $collectionData && ! isset($this->request->data['Collection']['participant_id']))) {
    $submittedDataValidates = false;
    $this->Collection->validationErrors['participant_id'][] = __('a created collection should be linked to a participant');
}

if ($submittedDataValidates) {
    $this->request->data['Collection']['acquisition_label'] = $this->Collection->getNextAcquisitionNumber();
    $this->Collection->addWritableField('acquisition_label');
}