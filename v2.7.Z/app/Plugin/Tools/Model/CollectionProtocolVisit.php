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
 * Class CollectionProtocolVisit
 */
class CollectionProtocolVisit extends ToolsAppModel
{

    public $useTable = 'collection_protocol_visits';

    /**
     * Additional validation rule to validate time from first visit
     *
     * @see Model::validates()
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (isset($this->data['CollectionProtocolVisit']['time_from_first_visit']) && strlen($this->data['CollectionProtocolVisit']['time_from_first_visit'])) {
            if (! isset($this->data['CollectionProtocolVisit']['time_from_first_visit_unit']) || empty($this->data['CollectionProtocolVisit']['time_from_first_visit_unit'])) {
                $this->validationErrors['time_from_first_visit_unit'][] = 'a time unit should be defined';
            }
        }
        
        return parent::validates($options);
    }

    /**
     * Manage the collection structures to limit list of fields to the fields
     * that could be used to set the default values for the futur inventory data creation.
     *
     * @return array Formatted structures (including fields)
     */
    public function getCollectionProtocolVisitStructures()
    {
        $structuresComponent = AppController::getInstance()->Structures;
        $collectionProtocolVisitStructure = $structuresComponent->get('form', 'collection_protocol_visit,linked_collections');
        $firstFieldDisplay = array();
        foreach ($collectionProtocolVisitStructure['Sfs'] as $k => &$newLinkedStructuresField) {
            if ($newLinkedStructuresField['structure_alias'] == 'linked_collections') {
                // Remove validation
                $newLinkedStructuresField['StructureValidation'] = array();
                // Remove default value
                $newLinkedStructuresField['default'] = '';
                if (! ($newLinkedStructuresField['flag_add'] && ! $newLinkedStructuresField['flag_add_readonly'])) {
                    unset($collectionProtocolVisitStructure['Sfs'][$k]);
                } else {
                    $newLinkedStructuresField['flag_addgrid'] = '1';
                    $newLinkedStructuresField['flag_editgrid'] = '1';
                    $newLinkedStructuresField['display_column'] += 1000;
                    $newLinkedStructuresField['display_order'] += 1000;
                    $firstFieldDisplay[$newLinkedStructuresField['display_column']][$newLinkedStructuresField['display_order']][] = $k;
                }
            }
        }
        ksort($firstFieldDisplay);
        $firstFieldDisplay = array_shift($firstFieldDisplay);
        ksort($firstFieldDisplay);
        $firstFieldDisplay = array_shift($firstFieldDisplay);
        $collectionProtocolVisitStructure['Sfs'][$firstFieldDisplay[0]]['language_heading'] = __('collection', null) . ' : ' . __('set default values', null);
        return $collectionProtocolVisitStructure;
    }

    public function getCollectionProtocolVisitsData($collectionProtocolId)
    {
        $collectionProtocolVisitsData = $this->find('all', array(
            'conditions' => array(
                'CollectionProtocolVisit.collection_protocol_id' => $collectionProtocolId
            ),
            'order' => array(
                'CollectionProtocolVisit.first_visit DESC'
            )
        ));
        foreach ($collectionProtocolVisitsData as &$newVisit) {
            $newVisit['CollectionProtocolVisit']['default_values'] = json_decode($newVisit['CollectionProtocolVisit']['default_values'], true);
        }
        return $collectionProtocolVisitsData;
    }
}