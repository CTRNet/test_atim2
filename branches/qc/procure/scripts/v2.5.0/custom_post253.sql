SET @id = (SELECT id FROM datamart_structures WHERE model = 'DiagnosisMaster');
UPDATE datamart_browsing_controls SET flag_active_1_to_2 = 0, flag_active_2_to_1 = 0 WHERE id1 = @id OR id2 = @id;

UPDATE structure_fields SET language_label = 'consent form identification' WHERE field = 'procure_form_identification' AND model = 'ConsentMaster';
UPDATE structure_fields SET language_label = 'event form identification' WHERE field = 'procure_form_identification' AND model = 'EventMaster';
UPDATE structure_fields SET language_label = 'treatment form identification' WHERE field = 'procure_form_identification' AND model = 'TreatmentMaster';
REPLACE INTO i18n (id,en,fr) 
VALUES 
('aliquot procure identification','Identification (alq.)','Identification (alq.)'),
('participant identifier','Identification (part.)','Identification (part.)'),
('tissue identification','Identification (tiss.)','Identification (tiss.)');
INSERT INTO i18n (id,en,fr) 
VALUES 
('consent form identification','Identification (cst.)','Identification (cst.)'),
('event form identification','Identification (ann.)','Identification (ann.)'),
('treatment form identification','Identification (trt.)','Identification (trt.)');

UPDATE storage_controls SET display_x_size = '10' WHERE storage_type = 'box100';

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) 
VALUES
(null, 'rack4', 'column', 'integer', 4, NULL, NULL, NULL, 4, 0, 0, 0, 0, 0, 0, 1, 'storage_w_spaces', 'std_racks', 'rack4', 0),
(null, 'box16', 'position', 'integer', 16, NULL, NULL, NULL, 1, 16, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'box16', 1);
INSERT INTO i18n (id,en,fr) VALUES ('rack4','Rack 4','Râtelier 4'), ('box16','Box 16','Boîte 16');

INSERT INTO `storage_controls` (`id`, `storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`, `reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, `detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
(null, 'boxPAR', 'position', 'integer', 8, NULL, NULL, NULL, 4, 2, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'boxPAR', 1),
(null, 'drawer2', 'row', 'integer', 2, NULL, NULL, NULL, 2, 1, 0, 0, 1, 0, 0, 1, 'storage_w_spaces', 'std_boxs', 'drawer2', 0);
INSERT INTO i18n (id,en,fr) VALUES ('drawer2','Drawer 2','Tiroir 2'), ('boxPAR','Box PAR','Boîte PAR');
