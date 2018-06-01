<?php
/** **********************************************************************
 * CHUM
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-28
 */

// By pass the collection selection form if no 'unlinked' collection exists
if (empty($this->request->data)) {
    if (! $this->Collection->find('count', array(
        'conditions' => array(
            'Collection.participant_id IS NULL'
        ),
        'recursive' => '-1'
    ))) {
        if (! $consentFound && ! $foundDx && ! $foundTx && ! $foundEvent) {
            // To skip collection selection step
            $this->request->data['Collection']['id'] = null;
        }
    }
}
