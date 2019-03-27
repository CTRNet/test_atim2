<?php

/**
 * Class EventControl
 */
class EventControl extends ClinicalAnnotationAppModel
{

    public $masterFormAlias = 'eventmasters';

    /**
     * Get permissible values array gathering all existing event disease sites.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getEventDiseaseSitePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $eventControl) {
            $result[$eventControl['EventControl']['disease_site']] = __($eventControl['EventControl']['disease_site']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getEventGroupPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $eventControl) {
            $result[$eventControl['EventControl']['event_group']] = __($eventControl['EventControl']['event_group']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     * Get permissible values array gathering all existing event types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getEventTypePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $eventControl) {
            $result[$eventControl['EventControl']['event_type']] = __($eventControl['EventControl']['event_type']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     *
     * @param $eventCtrlData
     * @param $participantId
     * @param $eventGroup
     * @return array
     */
    public function buildAddLinks($eventCtrlData, $participantId, $eventGroup)
    {
        $links = array();
        foreach ($eventCtrlData as $eventCtrl) {
            $links[] = array(
                'order' => $eventCtrl['EventControl']['display_order'],
                'label' => __($eventCtrl['EventControl']['event_type']) . (empty($eventCtrl['EventControl']['disease_site']) ? '' : ' - ' . __($eventCtrl['EventControl']['disease_site'])),
                'link' => '/ClinicalAnnotation/EventMasters/add/' . $participantId . '/' . $eventCtrl['EventControl']['id']
            );
        }
        AppController::buildBottomMenuOptions($links);
        return $links;
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}