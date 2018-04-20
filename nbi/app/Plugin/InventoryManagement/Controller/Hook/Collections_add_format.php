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

// A collection should be linked to a participant.
// No collection could be created if not linked to a participant.
if (! $collectionId && ! $copySource) {
    $this->flash(__('a created collection should be linked to a participant'), "javascript:history.back();", 5);
    return;
} elseif ($copySource && ! isset($this->request->data['Participant'])) {
    // Add Participant information when a collection is copied and the validation process just detected an error.
    // Code use to add participant information to the re-displayed form.
    if (! $copySrcData) {
        $copySrcData = $this->Collection->getOrRedirect($copySource);
    }
    $this->request->data['Participant'] = $copySrcData['Participant'];
}
    
// Set default values
if (! $needToSave) {
    // Set bank_id
    $this->request->data['Collection']['bank_id'] = 1;
}
