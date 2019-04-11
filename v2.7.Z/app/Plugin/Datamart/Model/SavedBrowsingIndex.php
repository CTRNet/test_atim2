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
 * Class SavedBrowsingIndex
 */
class SavedBrowsingIndex extends DatamartAppModel
{

    public $useTable = 'datamart_saved_browsing_indexes';

    public $hasMany = array(
        'SavedBrowsingStep' => array(
            'className' => 'Datamart.SavedBrowsingStep',
            'foreignKey' => 'datamart_saved_browsing_index_id'
        )
    );

    public $belongsTo = array(
        'DatamartStructure' => array(
            'className' => 'DatamartStructure',
            'foreignKey' => 'starting_datamart_structure_id'
        )
    );
}