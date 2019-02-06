<?php

class ParticipantCustom extends Participant
{

    var $name = 'Participant';

    var $useTable = 'participants';
    
    public function generateSciCode($participantId, $participantType)
    {
        // TODO Need to do error checking, what if participantType or participantId is null
        if ($participantType == 'animal') {
            // For animals, use an A to start
            $id = 'A' . str_pad($participantId, 6, 0, STR_PAD_LEFT);
        } else {
            // For human, use a H to start
            $id = 'H' . str_pad($participantId, 6, 0, STR_PAD_LEFT);
        }
        
        //TODO if $participantId > 999999 it will probably generate an errror with the UNIQUE constraint.
        
        $query = "UPDATE participants SET `participant_identifier`='" . $id . "' WHERE `id`=" . $participantId . ";";
        $this->tryCatchQuery($query);
        
        $query = "UPDATE participants_revs SET `participant_identifier`='" . $id . "' WHERE `id`=" . $participantId . " ORDER BY `version_id` DESC LIMIT 1;";
        $this->tryCatchQuery($query);
    }
}