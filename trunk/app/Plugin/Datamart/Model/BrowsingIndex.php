<?php

/**
 * Class BrowsingIndex
 */
class BrowsingIndex extends DatamartAppModel
{

    public $useTable = "datamart_browsing_indexes";

    public $belongsTo = array(
        'BrowsingResult' => array(
            'className' => 'BrowsingResult',
            'foreignKey' => 'root_node_id'
        )
    );

    public $tmpBrowsingLimit = 5;
}