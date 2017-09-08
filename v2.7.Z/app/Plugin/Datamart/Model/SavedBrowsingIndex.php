<?php

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