ALTER TABLE `ed_allsolid_lab_pathology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_adverse_events_adverse_event`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_clinical_followup`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_clinical_presentation`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_lifestyle_base`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_protocol_followup`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_all_study_research`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_breast_lab_pathology`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;

ALTER TABLE `ed_breast_screening_mammogram`
  ADD FOREIGN KEY (`event_master_id`) REFERENCES `event_masters` (`id`)
  ON DELETE RESTRICT
  ON UPDATE RESTRICT;
  
 /* Clinical Annotation */
    -- /Diagnosis/
    UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =830 LIMIT 1 ;
    UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =831 LIMIT 1 ;
    UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =832 LIMIT 1 ;
    UPDATE `structure_fields` SET `language_label` = '',
    `language_tag` = 'summary',
    `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =833 LIMIT 1 ;

    UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =834 LIMIT 1 ;
    UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =835 LIMIT 1 ;
    UPDATE `structure_fields` SET `setting` = 'size=1,maxlength=3' WHERE `structure_fields`.`id` =836 LIMIT 1 ;
    UPDATE `structure_fields` SET `language_label` = '',
    `language_tag` = 'summary',
    `setting` = 'size=1, maxlength=3' WHERE `structure_fields`.`id` =837 LIMIT 1 ;
    
    -- flag Origin to index
    
    UPDATE `structure_formats` SET `flag_index` = '1' WHERE `structure_formats`.`id` =2207 LIMIT 1 ;
    
    
 DELETE FROM structure_formats
WHERE old_id = 'CAN-999-999-000-999-1004_CAN-999-999-000-999-1027';
 