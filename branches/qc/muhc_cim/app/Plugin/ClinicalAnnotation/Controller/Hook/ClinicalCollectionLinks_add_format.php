<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// By pass the collection selection form if no 'unlinked' collection exists
if (empty($this->request->data)) {
    if (! $this->Collection->find('count', array(
        'conditions' => array(
            'Collection.participant_id IS NULL',
            'Collection.collection_property' => 'participant collection'
        ),
        'recursive' => '-1'
    ))) {
        // To skip collection selection step
        $this->request->data['Collection']['id'] = null;
    } else {
        // No unlinked collection should exist into the system
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
} else {
    // No unlinked collection should exist into the system
    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}
