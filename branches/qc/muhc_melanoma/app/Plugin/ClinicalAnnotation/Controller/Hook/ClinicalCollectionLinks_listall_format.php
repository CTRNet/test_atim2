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

foreach( $this->request->data as &$cusmMelanomaBkNewCollection) {
    $sampelTypes = array();
    foreach($cusmMelanomaBkNewCollection['SampleMaster'] as $cusmMelanomaBkNewSample) {
        $sampelTypes[$cusmMelanomaBkNewSample['initial_specimen_sample_type']] = __($cusmMelanomaBkNewSample['initial_specimen_sample_type']);
    }
    $cusmMelanomaBkNewCollection['Generated']['cusm_melanoma_bk_next_identifier_controls'] = implode(' & ', $sampelTypes);
}