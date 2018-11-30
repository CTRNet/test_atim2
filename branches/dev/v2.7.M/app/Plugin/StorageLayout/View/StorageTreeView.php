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

/*
 * This Model has been created to build storage tree view including both TMAs and aliquots data contained
 * into the root storage and each children storages. Only Master data are included into the tree view whatever the data type is:
 * aliquot, storage, TMA.
 * This model helps for the tree view build that was complex using just StorageMaster model that will return details
 * data all the time.
 */

/**
 * Class StorageTreeView
 */
class StorageTreeView extends StorageLayoutAppModel
{

    public $useTable = 'storage_masters';

    public $hasMany = array(
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'storage_master_id',
            'order' => 'CAST(AliquotMaster.storage_coord_x AS signed), CAST(AliquotMaster.storage_coord_y AS signed)'
        ),
        'TmaSlide' => array(
            'className' => 'StorageLayout.TmaSlide',
            'foreignKey' => 'storage_master_id',
            'order' => 'CAST(TmaSlide.storage_coord_x AS signed), CAST(TmaSlide.storage_coord_y AS signed)'
        )
    );

    public $actsAs = array(
        'Tree'
    );
}