<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

// --------------------------------------------------------------------------------
// Add specimen types to view collection
// --------------------------------------------------------------------------------

foreach ($this->request->data as &$cusmNewCollection) {
    $sampelTypes = array();
    foreach ($cusmNewCollection['SampleMaster'] as $cusmNewSample) {
        $sampelTypes[$cusmNewSample['initial_specimen_sample_type']] = __($cusmNewSample['initial_specimen_sample_type']);
    }
    $cusmNewCollection['Generated']['cusm_collection_specimens'] = implode(' & ', $sampelTypes);
}