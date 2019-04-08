<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class AliquotMasterCustom
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */
 
class AliquotMasterCustom extends AliquotMaster
{
    var $useTable = 'aliquot_masters';
    
    var $name = "AliquotMaster";
    
    /**
     * Will return an empty array considering that no consent exists into CUSM-CIM version.
     *
     * @param array $aliquot
     *            with either a key 'id' referring to an array
     *            of ids, or a key 'data' referring to AliquotMaster.
     * @param If|string $modelName If
     *            the aliquot array contains data, the model name
     *            to use.
     * @return an array having unconsented aliquot as key and their consent
     *         status as value. This function refers to
     * ViewCollection->getUnconsentedCollections.
     */
    public function getUnconsentedAliquots(array $aliquot, $modelName = 'AliquotMaster')
    {
        return array();
    }

}