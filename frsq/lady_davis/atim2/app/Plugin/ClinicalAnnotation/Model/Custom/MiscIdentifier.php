<?php

class MiscIdentifierCustom extends MiscIdentifier
{

    var $name = "MiscIdentifier";

    var $useTable = "misc_identifiers";

    public function validates($options = array())
    {
        $errors = parent::validates($options);
        if (! isset($this->data['MiscIdentifier']['deleted']) || $this->data['MiscIdentifier']['deleted'] == 0) {
            if (isset($this->validationErrors['identifier_value']) && ! is_array($this->validationErrors['identifier_value'])) {
                $this->validationErrors['identifier_value'] = array(
                    $this->validationErrors['identifier_value']
                );
            }
            $current = ($this->id) ? $this->findById($this->id) : $this->data;
            if ($current['MiscIdentifier']['misc_identifier_control_id'] == 11 && ! preg_match("/^(MET|NEO)-[\d]+$/", $this->data['MiscIdentifier']['identifier_value'])) {
                $this->validationErrors['identifier_value'][] = sprintf(__('the identifier expected format is %s'), 'MET-# ' . __('or', true) . ' NEO-#');
                return false;
            }
        }
        return $errors;
    }

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