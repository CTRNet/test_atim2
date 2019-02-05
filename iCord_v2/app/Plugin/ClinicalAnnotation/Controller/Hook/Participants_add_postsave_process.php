<?php 


    //exit("Postsave Hook");

    //pr($this->Participant->getLastInsertID());
    //pr($this->request->data);

    $participantId = $this->Participant->getLastInsertID();
    $participantType = $this->request->data['Participant']['participant_type'];

    //pr($participantType);

    $this->Participant->generateSciCode($participantId, $participantType);