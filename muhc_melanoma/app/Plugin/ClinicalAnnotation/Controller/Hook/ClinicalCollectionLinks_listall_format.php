<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

foreach( $this->request->data as &$cusmSlBkNewCollection) {
    $sampelTypes = array();
    foreach($cusmSlBkNewCollection['SampleMaster'] as $cusmSlBkNewSample) {
        $sampelTypes[$cusmSlBkNewSample['initial_specimen_sample_type']] = __($cusmSlBkNewSample['initial_specimen_sample_type']);
    }
    $cusmSlBkNewCollection['Generated']['cusm_sl_bk_collection_specimens'] = implode(' & ', $sampelTypes);
}