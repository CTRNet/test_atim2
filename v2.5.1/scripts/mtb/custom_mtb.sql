-- ------------------
-- after running a v243a backup then the v250 and v251 upgrade scripts do this
-- fix code affected by camel case change
-- ------------------



-- ------------------
-- MENUS
-- ------------------


-- fix camel case on Imaging

update atimv251.menus
set use_link='/ClinicalAnnotation/EventMasters/listall/imaging/%%Participant.id%%'
where id='clin_CAN_35'
;


-- !!! Menu Chronology does not work	  on DEVmode, but yes works on prod mode


-- --------------------------------------------------------------------------------------
-- check for forms/ fields that uses the coding tools, check to make sure tools work
-- --------------------------------------------------------------------------------------

select distinct tablename from structure_fields where `type`='autocomplete';

-- RESULTS OF THE ABOVE

-- CHECKED 'ed_breast_clinical_followups'
-- CHECKED ''txd_brachytherapies'
-- CHECKED ''txd_chemos'
-- CHECKED ''txd_hormonals'
-- CHECKED ''txd_immunos'
-- CHECKED ''txd_radiations'
-- CHECKED ''txd_surgeries'
-- CHECKED ''participants'
-- CHECKED ''ed_all_clinical_comorbidities'
-- CHECKED ''family_histories'
-- CHECKED ''dxd_bloods'
-- CHECKED ''diagnosis_masters'
-- CHECKED ''ed_all_comorbidities'
-- CHECKED ''dxd_tissues'
-- CHECKED ''ed_breast_lab_pathologies'
-- NOT NEEDED 'derivative_details'
-- NOT NEEDED 'realiquotings'
-- CHECKED ''treatment_masters'


-- ------------------
-- REP HIST - code from nicolas on how to fix the missing rep hist in data browser
-- ------------------

-- !!! dont need  this is already in v251, was fixed
-- INSERT INTO `datamart_structures`
-- (`id`, `plugin`, `model`,
-- `structure_id`,
-- `adv_search_structure_alias`, `display_name`, `control_master_model`,
-- `index_link`, `batch_edit_link`)
-- VALUES
-- (null, 'ClinicalAnnotation', 'ReproductiveHistory',
-- (SELECT id FROM structures WHERE alias = 'reproductivehistories'),
-- NULL, 'reproductive histories', '',
-- '/ClinicalAnnotation/ReproductiveHistories/detail/%%ReproductiveHistory.participant_id%%/%%ReproductiveHistory.id%%',
-- '');
-- 
-- 
-- INSERT INTO `datamart_browsing_controls` (`id1`, `id2`,
-- `flag_active_1_to_2`, `flag_active_2_to_1`, `use_field`) VALUES
-- ((SELECT id FROM datamart_structures WHERE model  =
-- 'ReproductiveHistory'), (SELECT id FROM datamart_structures WHERE
-- model  = 'Participant'), 1, 1, 'participant_id');
-- 
