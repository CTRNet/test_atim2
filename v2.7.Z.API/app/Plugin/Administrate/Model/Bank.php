<?php

/**
 * Class Bank
 */
class Bank extends AdministrateAppModel
{

    public $registeredView = array(
        'InventoryManagement.ViewCollection' => array(
            'Collection.bank_id'
        ),
        'InventoryManagement.ViewSample' => array(
            'Collection.bank_id'
        ),
        'InventoryManagement.ViewAliquot' => array(
            'Collection.bank_id'
        )
    );

    /**
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        if (isset($variables['Bank.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Bank.id' => $variables['Bank.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $result['Bank']['name']
                ),
                'title' => array(
                    null,
                    $result['Bank']['name']
                ),
                'data' => $result,
                'structure alias' => 'banks'
            );
        }
        return $return;
    }

    /**
     * Get permissible values array gathering all existing banks.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getBankPermissibleValues()
    {
        $result = array();
        foreach ($this->find('all', array(
            'order' => 'Bank.name ASC'
        )) as $bank) {
            $result[$bank["Bank"]["id"]] = $bank["Bank"]["name"];
        }
        return $result;
    }

    /**
     * @param int $bankId
     * @return array
     */
    public function allowDeletion($bankId)
    {
        $GroupModel = AppModel::getInstance("", "Group", true);
        $data = $GroupModel->find('first', array(
            'conditions' => array(
                'Group.bank_id' => $bankId
            )
        ));
        if ($data) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one group is linked to that bank'
            );
        }
        
        $CollectionModel = AppModel::getInstance('InventoryManagement', 'Collection', true);
        $data = $CollectionModel->find('first', array(
            'conditions' => array(
                'Collection.bank_id' => $bankId
            )
        ));
        if ($data) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one collection is linked to that bank'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}