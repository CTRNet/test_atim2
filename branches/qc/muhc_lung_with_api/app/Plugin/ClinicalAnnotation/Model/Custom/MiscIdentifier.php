<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
class MiscIdentifierCustom extends MiscIdentifier
{

    var $useTable = 'misc_identifiers';

    var $name = "MiscIdentifier";

    public function allowDeletion($miscIdentifierId)
    {
        // --------------------------------------------------------------------------------
        // Collection to participant bank foreign key
        // --------------------------------------------------------------------------------
                
        $groupModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $data = $groupModel->find('first', array(
            'conditions' => array(
                'Collection.misc_identifier_id' => $miscIdentifierId
            )
        ));
        if ($data) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one collection is linked to that participant identifier'
            );
        }
        
        return parent::allowDeletion($miscIdentifierId);
    }
}