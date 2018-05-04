<?php

/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class CollectionCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */
class SampleControlCustom extends SampleControl
{
    var $useTable = 'sample_controls';
    
    var $name = "SampleControl";
    
    /**
     * Generate a list gathering all the values of the sample sub types custom lists:
     *    - 'Tissue Sub Types'
     *    - 'Fluid Sub Types'
     *    - 'Cell Sub Types'
     *    - 'Molecular Sub Types'
     * 
     * @return array List of all sample sub types
     */
    public function getSampleSubTypes()
    {
        $structurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
        $results = array();
        foreach (array('Tissue Sub Types','Fluid Sub Types','Cell Sub Types','Molecular Sub Types') as $newCustomListName) {
            $tmpResults = $structurePermissibleValuesCustom->getCustomDropdown(array(
                $newCustomListName
            ));
            $tmpResults = array_merge($tmpResults['defined'], $tmpResults['previously_defined']);
            $results = array_merge($tmpResults, $results);
        }
        $results = array_flip($results);
        ksort($results);
        $results = array_flip($results);
        return $results;
    }
    
}