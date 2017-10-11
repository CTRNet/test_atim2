<?php
$alreadyCreated = $this->ReproductiveHistory->find('count', array(
    'conditions' => array(
        'ReproductiveHistory.participant_id' => $participantId
    )
));
if ($alreadyCreated) {
    $this->atimFlashWarning(__('an infomration has already been recorded for this patient'), '/ClinicalAnnotation/ReproductiveHistories/listall/' . $participantId);
    return;
}