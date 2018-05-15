<?php

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

    /**
     * Format the default values enterred for a created/modified protocol visit (collection data)
     *
     * @param string $visitDefaultValues
     *            Collection visit default values
     *            
     * @return string Formatted ollection visit default values
     */
    function fromateProtocolVisitDefaultValuesToSave($visitDefaultValues)
    {
        foreach ($visitDefaultValues as $tmpField => $tmpData) {
            if (is_array($tmpData) && array_key_exists('year', $tmpData)) {
                $dateFinal = '';
                if ($tmpData['year']) {
                    $dateFinal = $tmpData['year'];
                    if ($tmpData['month']) {
                        $dateFinal .= '-' . $tmpData['month'];
                        if ($tmpData['day']) {
                            $dateFinal .= '-' . $tmpData['day'];
                            if ($tmpData['hour']) {
                                $dateFinal .= ' ' . $tmpData['hour'];
                                if ($tmpData['min']) {
                                    $dateFinal .= ' ' . $tmpData['min'];
                                    if ($tmpData['sec']) {
                                        $dateFinal .= ' ' . $tmpData['sec'];
                                    }
                                }
                            }
                        }
                    }
                }
                if ($dateFinal) {
                    $visitDefaultValues[$tmpField] = $dateFinal;
                } else {
                    unset($visitDefaultValues[$tmpField]);
                }
            }
        }
        return $visitDefaultValues;
    }
}