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
     *
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
     * Return the ids of all the groups linked to the bank.
     *
     * @param $bankId integer Id of the studied bank.
     *       
     * @return array Ids of the groups
     *        
     * @author N. Luc
     * @since 2019-07-16
     *        @updated N. Luc
     */
    public function getBankGroupIds($bankId)
    {
        // $groupModel = AppModel::getInstance('', 'Group', true);
        // $tmpGroupIds = $groupModel->find('all', array(
        // 'conditions' => array('Group.bank_id' => $userBankId),
        // 'fields' => array(
        // "GROUP_CONCAT(DISTINCT Group.id SEPARATOR ',') as ids"
        // )));
        // Note: Code above does not work
        $userBankGroupIds = array();
        $query = "SELECT GROUP_CONCAT(DISTINCT Group.id SEPARATOR ',') as ids FROM groups AS `Group` WHERE Group.bank_id = '$bankId' AND Group.deleted != 1";
        $tmpBankGroupIds = $this->query($query);
        if ($tmpBankGroupIds) {
            $userBankGroupIds = explode(',', $tmpBankGroupIds[0][0]['ids']);
        }
        return $userBankGroupIds;
    }

    /**
     *
     * @param int $bankId
     * @return array
     */
    public function allowDeletion($bankId)
    {
        $groupModel = AppModel::getInstance("", "Group", true);
        $data = $groupModel->find('first', array(
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
        
        $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection', true);
        $data = $collectionModel->find('first', array(
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
        
        $announcementModel = AppModel::getInstance('', 'Announcement', true);
        $data = $announcementModel->find('first', array(
            'conditions' => array(
                'Announcement.bank_id' => $bankId
            )
        ));
        if ($data) {
            return array(
                'allow_deletion' => false,
                'msg' => 'at least one announcement is linked to that bank'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}