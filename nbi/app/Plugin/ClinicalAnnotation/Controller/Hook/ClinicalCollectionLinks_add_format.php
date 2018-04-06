<?php
/** **********************************************************************
 * NBI Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// By pass the collection selection form if no participant event exists
// (collection can not be linked to both a consent and a treatment).
if (empty($this->request->data)) {
    $unlinkedCollectionConditions = array(
        'Collection.participant_id IS NULL'
    );
    $collectionCount = $this->Collection->find('count', array('conditions' => $unlinkedCollectionConditions, 'recursive' => '-1'));
    if ($collectionCount) {
        // No unlinked collection should exist into the system! Generate a system error.
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
    $participantEventConditions = array(
        'EventMaster.participant_id' => $participantId
    );
    $eventCount = $this->EventMaster->find('count', array('conditions' => $participantEventConditions, 'recursive' => '-1'));
    if (!$eventCount) {
        // No participant event (Parthology Review) exists. By path the collection link creation step 
        // and force system to display the collection 'add' form.
        $this->request->data['Collection']['id'] = null;
    }
}