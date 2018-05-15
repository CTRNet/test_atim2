<?php

/**
 * Class CollectionProtocol
 */
class CollectionProtocol extends ToolsAppModel
{

    public $useTable = 'collection_protocols';

    /**
     * Check if protocol can be deleted.
     *
     * @param integer $collectionProtocolId
     *            Id of the protocol
     *            
     * @return array Results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     */
    public function allowDeletion($collectionProtocolId)
    {
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}