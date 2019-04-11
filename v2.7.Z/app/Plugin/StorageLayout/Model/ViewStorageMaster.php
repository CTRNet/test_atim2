<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class ViewStorageMaster
 */
class ViewStorageMaster extends StorageLayoutAppModel
{

    public $primaryKey = 'id';

    public $baseModel = "StorageMaster";

    public $basePlugin = 'StorageLayout';

    public $belongsTo = array(
        'StorageControl' => array(
            'className' => 'StorageLayout.StorageControl',
            'foreignKey' => 'storage_control_id'
        ),
        'StorageMaster' => array(
            'className' => 'StorageLayout.StorageMaster',
            'foreignKey' => 'id',
            'type' => 'INNER'
        )
    );

    public $alias = 'ViewStorageMaster';

    public static $tableQuery = '
		SELECT StorageMaster.*, 
		StorageControl.is_tma_block,
		IF(coord_x_size IS NULL AND coord_y_size IS NULL, 
        NULL, 
        IF(
            (IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - IFNULL(SUM(storage_contents_count),0)) < 0,
            0,
            IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - IFNULL(SUM(storage_contents_count),0))
        ) AS empty_spaces  
		FROM storage_masters AS StorageMaster
		INNER JOIN storage_controls AS StorageControl ON StorageMaster.storage_control_id=StorageControl.id
		LEFT JOIN (
            SELECT COUNT(*) as storage_contents_count, StorageMaster.id AS storage_master_id
            FROM storage_masters AS StorageMaster
            INNER JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.storage_master_id=StorageMaster.id AND AliquotMaster.deleted=0
            WHERE StorageMaster.deleted=0 %%WHERE%%
            GROUP BY StorageMaster.id
            UNION 
            SELECT COUNT(*) as storage_contents_count, StorageMaster.id AS storage_master_id
            FROM storage_masters AS StorageMaster
            INNER JOIN tma_slides AS TmaSlide ON TmaSlide.storage_master_id=StorageMaster.id AND TmaSlide.deleted=0
            WHERE StorageMaster.deleted=0 %%WHERE%%
            GROUP BY StorageMaster.id
            UNION 
            SELECT COUNT(*) as storage_contents_count, StorageMaster.id AS storage_master_id
            FROM storage_masters AS StorageMaster
            INNER JOIN storage_masters AS ChildStorageMaster ON ChildStorageMaster.parent_id=StorageMaster.id AND ChildStorageMaster.deleted=0
            WHERE StorageMaster.deleted=0 %%WHERE%%
            GROUP BY StorageMaster.id
        ) TmpCountRes ON StorageMaster.id=TmpCountRes.storage_master_id
        WHERE StorageMaster.deleted=0 %%WHERE%% 
		GROUP BY StorageMaster.id';
}