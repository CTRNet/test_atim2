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

// Visit of a collection can only be changed when no aliquot exists
if ($collectionData['Collection']['tfri_m4s_visit_id'] != $this->request->data['Collection']['tfri_m4s_visit_id']) {
    if ($this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collectionId)))) {
        $submittedDataValidates = false;
        $this->Collection->validationErrors['participant_id'][] = __('visit of a collection can not be modified when at least one aliquot already exists');
    }
}
