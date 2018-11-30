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
 * Class SourceAliquot
 */
class SourceAliquot extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'SampleMaster' => array(
            'className' => 'InventoryManagement.SampleMaster',
            'foreignKey' => 'sample_master_id'
        ),
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'aliquot_master_id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'SourceAliquot.id'
        )
    );
}