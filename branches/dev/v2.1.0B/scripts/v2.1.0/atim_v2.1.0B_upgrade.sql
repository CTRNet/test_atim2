-- Fix bug 1275 : unable to set a pariticipant message due date 

ALTER TABLE participant_messages
 MODIFY `due_date` date  DEFAULT NULL;
ALTER TABLE participant_messages_revs
 MODIFY `due_date` date  DEFAULT NULL;