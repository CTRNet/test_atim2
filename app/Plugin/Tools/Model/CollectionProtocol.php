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
 * Class CollectionProtocol
 */
class CollectionProtocol extends ToolsAppModel
{

    public $useTable = 'collection_protocols';

    /**
     * Check if protocol can be deleted.
     *
     * @param integer $collectionProtocolId Id of the protocol
     *       
     * @return array Results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     */
    public function allowDeletion($collectionProtocolId)
    {
        $tmpModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $returnedNbr = $tmpModel->find('count', array(
            'conditions' => array(
                'Collection.collection_protocol_id' => $collectionProtocolId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'collection protocol is linked to a collection - data can not be deleted'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Get list of collection protocols that can be used by the user.
     *
     * @return array List of protocols
     */
    public function getProtocolsList($useDefinition = 'use')
    {
        if (empty($useDefinition)) {
            $useDefinition = 'use';
        }
        $visibleProtocols = $this->getTools($useDefinition);
        $protocolsList = array();
        foreach ($visibleProtocols as $protocol) {
            $protocolsList[$protocol['CollectionProtocol']['name']] = $protocol['CollectionProtocol']['id'];
        }
        uksort($protocolsList, "strnatcasecmp");
        $protocolsList = array_flip($protocolsList);
        return $protocolsList;
    }
}