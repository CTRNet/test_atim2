REPLACE INTO `i18n` (`id`, `en`, `fr`)
	VALUES ('core_installname', 'iCord v0.1.2', '');
    
INSERT INTO storage_controls
(`storage_type`, `coord_x_title`, `coord_x_type`, `coord_x_size`, `coord_y_title`, `coord_y_type`, `coord_y_size`, `display_x_size`, `display_y_size`,
`reverse_x_numbering`, `reverse_y_numbering`, `horizontal_increment`, `set_temperature`, `is_tma_block`, `flag_active`, `detail_form_alias`, 
`detail_tablename`, `databrowser_label`, `check_conflicts`) VALUES
('Rack-Large', 'position', 'integer', 5, NULL, NULL, NULL, 1, 5, 
0 ,0, 1, 1, 0, 1, '', 
'std_racks', 'custom#storagetypes#Rack-Large', 1),
('Rack-Small', 'position', 'integer', 4, NULL, NULL, NULL, 1, 4, 
0 ,0, 1, 1, 0, 1, '', 
'std_racks', 'custom#storagetypes#Rack-Small', 1);

UPDATE storage_controls
SET `coord_x_title` = 'position', `coord_x_type` = 'integer', `coord_x_size` = 4, `display_x_size` = 1, `display_y_size` = 4
WHERE `storage_type` = 'freezer';

UPDATE storage_controls
SET `flag_active` = 0
WHERE `storage_type` != 'freezer' AND `storage_type` != 'rack-large' AND `storage_type` != 'rack-small' AND `storage_type` != 'box81' AND `storage_type` != 'box81 1A-9I';


REPLACE INTO `i18n` (`id`, `en`, `fr`) VALUES
('Rack-Large', 'Rack-Large', ''),
('Rack-Small', 'Rack-Small', '');
