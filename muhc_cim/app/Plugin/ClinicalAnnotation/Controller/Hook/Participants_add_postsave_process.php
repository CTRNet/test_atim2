<?php

/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * CLinicalAnnotaion plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// Generate the participant identifier being equal to the id of the record
$queryToUpdate = "UPDATE participants SET participants.participant_identifier = participants.id WHERE participants.id = " . $this->Participant->id . ";";
$this->Participant->tryCatchQuery($queryToUpdate);
$this->Participant->tryCatchQuery(str_replace("participants", "participants_revs", $queryToUpdate));
