UPDATE `versions` SET branch_build_number = 'xxx' WHERE version_number = '2.5.4';

UPDATE menus SET use_link = '/ClinicalAnnotation/EventMasters/listall/lab/%%Participant.id%%' WHERE id = 'clin_CAN_4';



