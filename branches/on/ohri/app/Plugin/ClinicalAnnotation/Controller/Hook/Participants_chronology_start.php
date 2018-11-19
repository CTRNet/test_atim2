<?php
$domainNamesToValues = array(
    'intent' => array(
        'data' => array(),
        'isCustom' => false
    ),
    'response' => array(
        'data' => array(),
        'isCustom' => false
    ),
    'ohri_disease_status' => array(
        'data' => array(),
        'isCustom' => false
    ),
    'ohri_residual_disease' => array(
        'data' => array(),
        'isCustom' => false
    ),
    'ohri_tumour_site' => array(
        'data' => array(),
        'isCustom' => false
    ),
    'Surgery: Description' => array(
        'data' => array(),
        'isCustom' => true
    )
);
foreach ($domainNamesToValues as $domainName => $tmp) {
    if ($tmp['isCustom']) {
        $tmpResponse = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
            $domainName
        ));
        $domainNamesToValues[$domainName]['data'] = array_merge($tmpResponse['defined'], $tmpResponse['previously_defined']);
    } else {
        $tmpResponse = $this->StructureValueDomain->find('first', array(
            'conditions' => array(
                'StructureValueDomain.domain_name' => $domainName
            ),
            'recursive' => 2
        ));
        if (isset($tmpResponse['StructurePermissibleValue'])) {
            foreach ($tmpResponse['StructurePermissibleValue'] as $newValue) {
                $domainNamesToValues[$domainName]['data'][$newValue['value']] = __($newValue['language_alias']);
            }
        }
    }
}