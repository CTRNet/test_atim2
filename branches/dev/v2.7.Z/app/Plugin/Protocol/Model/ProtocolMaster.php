<?php

/**
 * Class ProtocolMaster
 */
class ProtocolMaster extends ProtocolAppModel
{

    public $name = 'ProtocolMaster';

    public $useTable = 'protocol_masters';

    public static $protocolDropdown = array();

    private static $protocolDropdownSet = false;

    public $belongsTo = array(
        'ProtocolControl' => array(
            'className' => 'Protocol.ProtocolControl',
            'foreignKey' => 'protocol_control_id'
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
        
        if (isset($variables['ProtocolMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'ProtocolMaster.id' => $variables['ProtocolMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['ProtocolControl']['type'], true) . ' - ' . $result['ProtocolMaster']['code']
                ),
                'title' => array(
                    null,
                    $result['ProtocolMaster']['code']
                ),
                'data' => $result,
                'structure alias' => 'protocolmasters'
            );
        }
        
        return $return;
    }

    /**
     * Get permissible values array gathering all existing protocol.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     * @param null $protocolControlId
     * @return array
     */
    public function getProtocolPermissibleValuesFromId($protocolControlId = null)
    {
        // Build tmp array to sort according translation
        $criteria = array();
        if (! self::$protocolDropdownSet) {
            if (! is_null($protocolControlId)) {
                $criteria['ProtocolMaster.protocol_control_id'] = $protocolControlId;
            }
            foreach ($this->find('all', array(
                'conditions' => $criteria,
                'order' => 'ProtocolMaster.code'
            )) as $newProtocol) {
                self::$protocolDropdown[$newProtocol['ProtocolMaster']['id']] = __($newProtocol['ProtocolControl']['type']) . ' : ' . $newProtocol['ProtocolMaster']['code'] . (empty($newProtocol['ProtocolMaster']['name']) ? '' : ' (' . $newProtocol['ProtocolMaster']['name'] . ')');
            }
            self::$protocolDropdownSet = true;
        }
        
        return self::$protocolDropdown;
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $protocolMasterId Id of the studied record.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2010-04-18
     *        @moved from controller to model on 2010-06-08 by Mich
     */
    public function isLinkedToTreatment($protocolMasterId)
    {
        $this->TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $nbrTrtMasters = $this->TreatmentMaster->find('count', array(
            'conditions' => array(
                'TreatmentMaster.protocol_master_id' => $protocolMasterId
            ),
            'recursive' => - 1
        ));
        if ($nbrTrtMasters > 0) {
            return array(
                'is_used' => true,
                'msg' => 'protocol is defined as protocol of at least one participant treatment'
            );
        }
        
        return array(
            'is_used' => false,
            'msg' => ''
        );
    }

    /**
     *
     * @param int $protocolMasterId
     * @return array
     */
    public function allowDeletion($protocolMasterId)
    {
        if ($protocolMasterId != $this->id) {
            // not the same, fetch
            $data = $this->findById($protocolMasterId);
        } else {
            $data = $this->data;
        }
        
        $res = $this->isLinkedToTreatment($protocolMasterId);
        if ($res['is_used']) {
            return array(
                'allow_deletion' => false,
                'msg' => $res['msg']
            );
        }
        
        if (! empty($data['ProtocolControl']['protocol_extend_control_id'])) {
            $protocolExtendMaster = AppModel::getInstance('Protocol', 'ProtocolExtendMaster', true);
            $nbrExtends = $protocolExtendMaster->find('count', array(
                'conditions' => array(
                    'ProtocolExtendMaster.protocol_master_id' => $protocolMasterId,
                    'ProtocolExtendMaster.protocol_extend_control_id' => $data['ProtocolControl']['protocol_extend_control_id']
                ),
                'recursive' => - 1
            ));
            if ($nbrExtends > 0) {
                return array(
                    'allow_deletion' => false,
                    'msg' => 'at least one precision is defined as protocol component'
                );
            }
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}