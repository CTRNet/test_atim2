<?php

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