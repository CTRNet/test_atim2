<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = CONCAT('ATiM#', id) WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }

    public function getDefaultAliquotLabel($viewSample)
    {
        $participantBankIdentifier = isset($viewSample['ViewSample']['cusm_collection_participant_bank_number']) ? $viewSample['ViewSample']['cusm_collection_participant_bank_number'] : '?';
        $tubeSuffix = '?';
        switch ($viewSample['ViewSample']['sample_type']) {
            case 'buffy coat':
                $tubeSuffix = 'BC';
                break;
            case 'plasma':
                $tubeSuffix = 'P';
                break;
            case 'serum':
                $tubeSuffix = 'S';
                break;
        }
        return "$participantBankIdentifier $tubeSuffix";
    }
}