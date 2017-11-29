<?php

/**
 * Hook :: Modify generated bank identifiers 
 *   - Lung : Add year to the Lung Bank Identifier
 *
 * @author Nicolas Luc
 *
 * @package ATiM CUSM
 */

foreach( $this->request->data as &$cusm_new_collection) {
    $sampel_types = array();
    foreach($cusm_new_collection['SampleMaster'] as $cusm_new_sample) {
        $sampel_types[$cusm_new_sample['initial_specimen_sample_type']] = __($cusm_new_sample['initial_specimen_sample_type']);
    }
    $cusm_new_collection['Generated']['cusm_collection_specimens'] = implode(' & ', $sampel_types);
}
