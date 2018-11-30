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

// Sfs stands for Structure Format Simplified

/**
 * Class Sfs
 */
class Sfs extends AppModel
{

    public $useTable = 'view_structure_formats_simplified';

    public $name = 'Sfs';

    public $hasMany = array(
        // fetched manually in model/structure
        'StructureValidation' => array(
            'foreignKey' => 'structure_field_id'
        )
    );

    public $belongsTo = array(
        'StructureValueDomain' => array(
            'className' => 'StructureValueDomain',
            'foreignKey' => 'structure_value_domain'
        )
    );
}