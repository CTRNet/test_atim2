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