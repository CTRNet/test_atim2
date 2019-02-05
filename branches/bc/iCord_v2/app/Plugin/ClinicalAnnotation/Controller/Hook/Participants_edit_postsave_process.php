<?php 


    //pr($this->request->data);
    //pr($participant_id);

    $participantType = $this->request->data['Participant']['participant_type'];

    $this->Participant->generateSciCode($participant_id, $participantType);

    //exit("I am at the edit post save hook");