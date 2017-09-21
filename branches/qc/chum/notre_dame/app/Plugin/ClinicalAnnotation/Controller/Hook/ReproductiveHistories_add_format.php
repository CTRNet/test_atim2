<?php
$already_created = $this->ReproductiveHistory->find('count', array(
    'conditions' => array(
        'ReproductiveHistory.participant_id' => $participant_id
    )
));
if ($already_created) {
    $this->atimFlashWarning(__('an infomration has already been recorded for this patient'), '/ClinicalAnnotation/ReproductiveHistories/listall/' . $participant_id);
    return;
}