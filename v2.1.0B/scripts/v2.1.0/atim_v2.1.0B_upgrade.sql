-- Fix bug 1275 : unable to set a pariticipant message due date 

ALTER TABLE participant_messages
 MODIFY `due_date` date  DEFAULT NULL;
ALTER TABLE participant_messages_revs
 MODIFY `due_date` date  DEFAULT NULL;
 
-- FMLH
ALTER TABLE structure_formats 
 MODIFY flag_override_label BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_override_tag BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_override_help BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_override_type BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_override_setting BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_override_default BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_add BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_add_readonly BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_edit BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_edit_readonly BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_search BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_search_readonly BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_datagrid BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_datagrid_readonly BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_index BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_detail BOOLEAN NOT NULL DEFAULT false;

UPDATE structure_formats SET flag_override_label =0 where flag_override_label =1;
UPDATE structure_formats SET flag_override_tag =0 where flag_override_tag =1;
UPDATE structure_formats SET flag_override_help =0 where flag_override_help =1;
UPDATE structure_formats SET flag_override_type =0 where flag_override_type =1;
UPDATE structure_formats SET flag_override_setting =0 where flag_override_setting =1;
UPDATE structure_formats SET flag_override_default =0 where flag_override_default =1;
UPDATE structure_formats SET flag_add =0 where flag_add =1;
UPDATE structure_formats SET flag_add_readonly =0 where flag_add_readonly =1;
UPDATE structure_formats SET flag_edit =0 where flag_edit =1;
UPDATE structure_formats SET flag_edit_readonly =0 where flag_edit_readonly =1;
UPDATE structure_formats SET flag_search =0 where flag_search =1;
UPDATE structure_formats SET flag_search_readonly =0 where flag_search_readonly =1;
UPDATE structure_formats SET flag_datagrid =0 where flag_datagrid =1;
UPDATE structure_formats SET flag_datagrid_readonly =0 where flag_datagrid_readonly =1;
UPDATE structure_formats SET flag_index =0 where flag_index =1;
UPDATE structure_formats SET flag_detail =0 where flag_detail =1;
UPDATE structure_formats SET flag_override_label =1 where flag_override_label =2;
UPDATE structure_formats SET flag_override_tag =1 where flag_override_tag =2;
UPDATE structure_formats SET flag_override_help =1 where flag_override_help =2;
UPDATE structure_formats SET flag_override_type =1 where flag_override_type =2;
UPDATE structure_formats SET flag_override_setting =1 where flag_override_setting =2;
UPDATE structure_formats SET flag_override_default =1 where flag_override_default =2;
UPDATE structure_formats SET flag_add =1 where flag_add =2;
UPDATE structure_formats SET flag_add_readonly =1 where flag_add_readonly =2;
UPDATE structure_formats SET flag_edit =1 where flag_edit =2;
UPDATE structure_formats SET flag_edit_readonly =1 where flag_edit_readonly =2;
UPDATE structure_formats SET flag_search =1 where flag_search =2;
UPDATE structure_formats SET flag_search_readonly =1 where flag_search_readonly =2;
UPDATE structure_formats SET flag_datagrid =1 where flag_datagrid =2;
UPDATE structure_formats SET flag_datagrid_readonly =1 where flag_datagrid_readonly =2;
UPDATE structure_formats SET flag_index =1 where flag_index =2;
UPDATE structure_formats SET flag_detail =1 where flag_detail =2;

ALTER TABLE structure_validations
 MODIFY flag_empty BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_required BOOLEAN NOT NULL DEFAULT false;

UPDATE structure_validations SET flag_empty=0 WHERE flag_empty=1;
UPDATE structure_validations SET flag_empty=1 WHERE flag_empty=2;
UPDATE structure_validations SET flag_required=0 WHERE flag_empty=1;
UPDATE structure_validations SET flag_required=1 WHERE flag_empty=2;

ALTER TABLE structures 
 MODIFY flag_add_columns BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_edit_columns BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_search_columns BOOLEAN NOT NULL DEFAULT false,
 MODIFY flag_detail_columns BOOLEAN NOT NULL DEFAULT false;
 
UPDATE structures SET flag_add_columns=0 WHERE flag_add_columns=1;
UPDATE structures SET flag_add_columns=1 WHERE flag_add_columns=2;
UPDATE structures SET flag_edit_columns=0 WHERE flag_edit_columns=1;
UPDATE structures SET flag_edit_columns=1 WHERE flag_edit_columns=2;
UPDATE structures SET flag_search_columns=0 WHERE flag_search_columns=1;
UPDATE structures SET flag_search_columns=1 WHERE flag_search_columns=2;
UPDATE structures SET flag_detail_columns=0 WHERE flag_detail_columns=1;
UPDATE structures SET flag_detail_columns=1 WHERE flag_detail_columns=2;
