<?php
$already_created = $this->ReproductiveHistory->find('count', array(
    'conditions' => array(
        'ReproductiveHistory.participant_id' => $participant_id
    )
));
if ($already_created) {
    $this->flash(__('an infomration has already been recorded for this patient'), '/ClinicalAnnotation/ReproductiveHistories/listall/' . $participant_id, 5);
    return;
}	
