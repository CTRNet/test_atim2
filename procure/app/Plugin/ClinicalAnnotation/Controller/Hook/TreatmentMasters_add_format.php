<?php

// Clinical file update process
if (empty($this->request->data))
    $this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participantId, $this->passedArgs);
$this->Participant->addClinicalFileUpdateProcessInfo();