<?php
$modelParticipant = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
$modelParticipant->updateParticipantLastEventRecorded(isset($this->request->data['Collection']['participant_id']) ? $this->request->data['Collection']['participant_id'] : $collectionData['Collection']['participant_id']);