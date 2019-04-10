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
        
        $defaultSampleLabel = "$sampleLabel $participantIdentifier";
        
        return $defaultSampleLabel;
    }

    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }

    public function getUserList()
    {
        $UserModel = AppModel::getInstance('', 'User', true);
        $usersList = array();
        $userConditions = array(
            'User.deleted' => array(
                '0',
                '1'
            )
        );
        foreach ($UserModel->find('all', array('conditions' => $userConditions)) as $newUser) {
            $usersList[$newUser['User']['id']] = str_replace('administrator', 'System', $newUser['User']['username']);
        }
        return $usersList;
    }
    
}