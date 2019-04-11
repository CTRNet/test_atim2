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
 * Class StructureValueDomain
 */
class StructureValueDomain extends AppModel
{

    public $name = 'StructureValueDomain';

    public $hasMany = array(
        'StructureValueDomainsPermissibleValue' => array(
            'className' => 'StructureValueDomainsPermissibleValue',
            'foreignKey' => 'structure_value_domain_id'
        )
    );

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        if (isset($results[0])) {
            $permissibleValues = array();
            foreach ($results as &$subResult) {
                if (isset($subResult['StructureValueDomainsPermissibleValue'])) {
                    $oldResult = $subResult;
                    $svd = $oldResult['StructureValueDomain'];
                    $subResult = array(
                        "id" => $svd['id'],
                        "domain_name" => $svd['domain_name'],
                        "overrive" => $svd['override'],
                        "category" => $svd['category'],
                        "source" => $svd['source']
                    );
                    foreach ($oldResult['StructureValueDomainsPermissibleValue'] as $svdpv) {
                        $permissibleValues[] = array(
                            "id" => $svdpv['id'],
                            "value" => $svdpv['StructurePermissibleValue']['value'],
                            "language_alias" => $svdpv['StructurePermissibleValue']['language_alias'],
                            "display_order" => $svdpv['display_order'],
                            "flag_active" => $svdpv['flag_active'],
                            "use_as_input" => $svdpv['use_as_input']
                        );
                    }
                    $subResult['StructurePermissibleValue'] = $permissibleValues;
                } else {
                    break;
                }
            }
            $results['StructurePermissibleValue'] = $permissibleValues;
        }
        return $results;
    }

    /**
     *
     * @param array $structureValueDomain
     * @param $dropdownResult
     */
    public function updateDropdownResult(array $structureValueDomain, &$dropdownResult)
    {
        if (strlen($structureValueDomain['source']) > 0) {
            // load source
            $tmpDropdownResult = StructuresComponent::getPulldownFromSource($structureValueDomain['source']);
            if (array_key_exists('defined', $tmpDropdownResult)) {
                $dropdownResult['defined'] += $tmpDropdownResult['defined'];
                if (array_key_exists('previously_defined', $tmpDropdownResult)) {
                    $dropdownResult['previously_defined'] += $tmpDropdownResult['previously_defined'];
                }
            } else {
                $dropdownResult['defined'] += $tmpDropdownResult;
            }
        } else {
            $this->cacheQueries = true;
            $tmpDropdownResult = $this->find('first', array(
                'recursive' => 2, // cakephp has a memory leak when recursive = 2
                'conditions' => array(
                    'StructureValueDomain.id' => $structureValueDomain['id']
                )
            ));
            if (isset($tmpDropdownResult['StructurePermissibleValue']) && count($tmpDropdownResult['StructurePermissibleValue']) > 0) {
                $tmpResult = array(
                    'defined' => array(),
                    'previously_defined' => array()
                );
                // sort based on flag and on order
                foreach ($tmpDropdownResult['StructurePermissibleValue'] as $tmpEntry) {
                    if ($tmpEntry['flag_active']) {
                        if ($tmpEntry['use_as_input']) {
                            $tmpResult['defined'][$tmpEntry['value']] = sprintf("%04d", $tmpEntry['display_order']) . __($tmpEntry['language_alias'], null);
                        } else {
                            $tmpResult['previously_defined'][$tmpEntry['value']] = sprintf("%04d", $tmpEntry['display_order']) . __($tmpEntry['language_alias'], null);
                        }
                    }
                }
                asort($tmpResult['defined']);
                asort($tmpResult['previously_defined']);
                $substr4Func = create_function('$str', 'return substr($str, 4);');
                $tmpResult['defined'] = array_map($substr4Func, $tmpResult['defined']);
                $tmpResult['previously_defined'] = array_map($substr4Func, $tmpResult['previously_defined']);
                
                $dropdownResult['defined'] += $tmpResult['defined']; // merging arrays and keeping numeric keys intact
                $dropdownResult['previously_defined'] += $tmpResult['previously_defined'];
            }
        }
    }
}