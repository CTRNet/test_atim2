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

foreach( $this->request->data as &$cusm_new_collection) {
    $sampel_types = array();
    foreach($cusm_new_collection['SampleMaster'] as $cusm_new_sample) {
        $sampel_types[$cusm_new_sample['initial_specimen_sample_type']] = __($cusm_new_sample['initial_specimen_sample_type']);
    }
    $cusm_new_collection['Generated']['cusm_collection_specimens'] = implode(' & ', $sampel_types);
}
