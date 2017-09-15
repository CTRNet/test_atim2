<?php
$modelParticipant = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
$modelParticipant->updateParticipantLastEventRecorded($collectionData['Collection']['participant_id']);