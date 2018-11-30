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
 * Class Config
 */
class Config extends AppModel
{

    /**
     *
     * @param $groupId
     * @param $userId
     * @return array|null
     */
    public function getConfig($groupId, $userId)
    {
        $configResults = $this->find('first', array(
            'conditions' => array(
                'Config.user_id' => $userId,
                'Config.group_id' => $groupId
            )
        ));
        if ($configResults) {
            return $configResults;
        }
        
        $configResults = $this->find('first', array(
            'conditions' => array(
                array(
                    'OR' => array(
                        'Config.bank_id' => 0,
                        'Config.bank_id IS NULL'
                    )
                ),
                array(
                    'OR' => array(
                        'Config.group_id' => 0,
                        'Config.group_id IS NULL'
                    )
                ),
                'Config.user_id' => $userId
            )
        ));
        if ($configResults) {
            return $configResults;
        }
        
        $configResults = $this->find('first', array(
            'conditions' => array(
                array(
                    'OR' => array(
                        'Config.bank_id' => "0",
                        'Config.bank_id IS NULL'
                    )
                ),
                'Config.group_id' => $groupId,
                array(
                    'OR' => array(
                        'Config.user_id' => "0",
                        'Config.user_id IS NULL'
                    )
                )
            )
        ));
        if ($configResults) {
            return $configResults;
        }
        
        return $this->find('first', array(
            'conditions' => array(
                array(
                    'OR' => array(
                        'Config.bank_id' => "0",
                        'Config.bank_id IS NULL'
                    )
                ),
                array(
                    'OR' => array(
                        'Config.group_id' => "0",
                        'Config.group_id IS NULL'
                    )
                ),
                array(
                    'OR' => array(
                        'Config.user_id' => "0",
                        'Config.user_id IS NULL'
                    )
                )
            )
        ));
    }

    /**
     *
     * @param $configResults
     * @param $requestData
     * @param $groupId
     * @param $userId
     */
    public function preSave($configResults, &$requestData, $groupId, $userId)
    {
        if ($configResults['Config']['user_id'] != 0) {
            // own config, edit, otherwise will create a new one
            $this->id = $configResults['Config']['id'];
        } else {
            $requestData['Config']['user_id'] = $userId;
            $requestData['Config']['group_id'] = $groupId;
            // $this->request->data['Config']['bank_id'] = TODO is it needed here???
            $this->addWritableField(array(
                'user_id',
                'group_id',
                'bank_id'
            ));
        }
        
        // fixes a cakePHP 2.0 issue with integer enums
        $requestData['Config']['define_time_format'] = $requestData['Config']['define_time_format'] == 24 ? 2 : 1;
    }
}