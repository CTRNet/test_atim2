<?php

class MiscIdentifierCustom extends MiscIdentifier
{

    var $name = "MiscIdentifier";

    var $useTable = "misc_identifiers";

    public function allowDeletion($id)
    {
        $arrAllowDeletion = array(
            'allow_deletion' => true,
            'msg' => ''
        );
        
        $colModel = AppModel::getInstance("InventoryManagement", "Collection", true);
        $nbrLinkedCollection = $colModel->find('count', array(
            'conditions' => array(
                'Collection.misc_identifier_id' => $id,
                'Collection.deleted' => 0
            ),
            'recursive' => -1
        ));
        if ($nbrLinkedCollection > 0) {
            $arrAllowDeletion['allow_deletion'] = false;
            $arrAllowDeletion['msg'] = 'error_fk_frsq_number_linked_collection';
            return $arrAllowDeletion;
        }
        return parent::allowDeletion($id);
    }
}