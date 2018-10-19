<?php

/**
 * Class ProtocolControl
 */
class ProtocolControl extends ProtocolAppModel
{

    public $masterFormAlias = 'protocolmasters';

    /**
     * Get permissible values array gathering all existing protocol types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getProtocolTypePermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $protocolControl) {
            $result[$protocolControl['ProtocolControl']['type']] = __($protocolControl['ProtocolControl']['type']);
        }
        natcasesort($result);
        
        return $result;
    }

    /**
     * Get array gathering all existing protocol tumour groups.
     *
     * @author N. Luc
     * @since 2009-09-11
     *        @updated N. Luc
     */
    public function getProtocolTumourGroupPermissibleValues()
    {
        $result = array();
        
        // Build tmp array to sort according translation
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $protocolControl) {
            $result[$protocolControl['ProtocolControl']['tumour_group']] = __($protocolControl['ProtocolControl']['tumour_group']);
        }
        natcasesort($result);
        
        return $result;
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