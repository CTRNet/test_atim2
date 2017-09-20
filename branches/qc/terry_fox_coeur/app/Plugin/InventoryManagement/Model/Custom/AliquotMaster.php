<?php

class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function generateDefaultAliquotLabel($viewSample, $aliquotControlData)
    {
        
        // Parameters check: Verify parameters have been set
        if (empty($viewSample) || empty($aliquotControlData))
            AppController::getInstance()->redirect('/pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $sampleType = $viewSample['ViewSample']['sample_type'];
        $qcTfBankId = empty($viewSample['ViewSample']['qc_tf_bank_id']) ? null : $viewSample['ViewSample']['qc_tf_bank_id'];
        // $qcTfBankName = '?';
        // if($qcTfBankId) {
        // $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
        // $bankData = $bankModel->getOrRedirect($qcTfBankId);
        // $qcTfBankName = $bankData['Bank']['name'];
        // }
        // $qcTfBankIdentifier = empty($viewSample['ViewSample']['qc_tf_bank_identifier'])? '?' : $viewSample['ViewSample']['qc_tf_bank_identifier'];
        $participantIdentifier = $viewSample['ViewSample']['participant_identifier'];
        
        switch ($viewSample['ViewSample']['sample_type']) {
            case 'blood':
                $sampleLabel = 'S';
                break;
            case 'tissue':
                $sampleLabel = '' . (($aliquotControlData['AliquotControl']['aliquot_type'] == 'tube') ? 'FT' : 'FFPE');
                break;
            case 'blood cell':
                $sampleLabel = 'BC';
                break;
            case 'amplified dna':
                $sampleLabel = 'aDNA';
                break;
            case 'amplified rna':
                $sampleLabel = 'aRNA';
                break;
            case 'purified rna':
                $sampleLabel = 'pRNA';
                break;
            case 'plasma':
                $sampleLabel = 'PLA';
                break;
            case 'serum':
                $sampleLabel = 'SER';
                break;
            case 'dna':
                $sampleLabel = 'DNA';
                break;
            case 'rna':
                $sampleLabel = 'RNA';
                break;
            case 'ascite':
                $sampleLabel = 'ASC';
                break;
            default:
                $sampleLabel = '?';
        }
        
        $defaultSampleLabel = "$sampleLabel $participantIdentifier"; // [$qcTfBankIdentifier $qcTfBankName]";
        
        return $defaultSampleLabel;
    }

    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }
}