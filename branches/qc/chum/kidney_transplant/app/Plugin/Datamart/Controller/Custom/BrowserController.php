<?php

class BrowserControllerCustom extends BrowserController
{

    public function browse($nodeId = 0, $controlId = 0, $mergeTo = 0)
    {
        if ($nodeId && ! $controlId) {
            $tmpResult = $this->BrowsingResult->getOrRedirect($nodeId);
            if (in_array($tmpResult['DatamartStructure']['model'], array(
                'ViewSample',
                'ViewAliquot'
            ))) {
                $tmpBrowsingModel = AppModel::getInstance($tmpResult['DatamartStructure']['plugin'], $tmpResult['DatamartStructure']['model'], true);
                $tmpResultBiohazard = $tmpBrowsingModel->find('first', array(
                    'conditions' => array(
                        $tmpResult['DatamartStructure']['model'] . '.' . ($tmpResult['DatamartStructure']['model'] == 'ViewSample' ? 'sample_master_id' : 'aliquot_master_id') => explode(',', $tmpResult['BrowsingResult']['id_csv'])
                    ),
                    'fields' => array(
                        'GROUP_CONCAT(DISTINCT IFNULL(' . $tmpResult['DatamartStructure']['model'] . '.chum_kidney_transp_biohazard,"") SEPARATOR "") AS res_biohazard'
                    )
                ));
                if (preg_match('/u/', $tmpResultBiohazard[0]['res_biohazard'])) {
                    AppController::addWarningMsg(__('at least one aliquot/sample is not linked to a collection - biological hazard can not be evaluated'));
                }
                if (preg_match('/y/', $tmpResultBiohazard[0]['res_biohazard'])) {
                    AppController::addWarningMsg(__('at least one aliquot/sample presents a confirmed biological hazard'));
                }
            }
        }
        parent::browse($nodeId, $controlId, $mergeTo);
    }
}