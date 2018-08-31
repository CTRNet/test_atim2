<?php

class MiscIdentifierCustom extends MiscIdentifier
{

    var $useTable = 'misc_identifiers';

    var $name = "MiscIdentifier";

    /**
     * Return the next kidney transplant bank no lab expected
     */
    public function getNextKidneyMiscIdentifierNumber()
    {
        $nextIdentifierValue = $this->find('first', array(
            'conditions' => array(
                "MiscIdentifierControl.misc_identifier_name IN ('kidney transplant bank no lab', 'other kidney transplant bank no lab')"
            ),
            'fields' => array(
                'MAX(MiscIdentifier.identifier_value) AS last_identifier_value'
            )
        ));
        if (! $nextIdentifierValue['0']['last_identifier_value']) {
            return 'CHUM00001';
        } else {
            if (preg_match('/^CHUM([0-9]{5})$/', $nextIdentifierValue['0']['last_identifier_value'], $matches)) {
                return 'CHUM' . (str_pad(($matches[1] + 1), 5, '0', STR_PAD_LEFT));
            } else {
                return 'CHUM0';
            }
            return $result;
        }
    }

    public function validates($options = array())
    {
        if (isset($this->data['MiscIdentifier']['identifier_value'])) {
            if (! isset($this->data['MiscIdentifierControl']['misc_identifier_name'])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            } elseif (in_array($this->data['MiscIdentifierControl']['misc_identifier_name'], array(
                'kidney transplant bank no lab',
                'other kidney transplant bank no lab'
            ))) {
                $this->data['MiscIdentifier']['identifier_value'] = strtoupper($this->data['MiscIdentifier']['identifier_value']);
                $result = parent::validates($options);
                if ($result) {
                    $conditions = array(
                        "MiscIdentifier.identifier_value" => $this->data['MiscIdentifier']['identifier_value'],
                        "MiscIdentifierControl.misc_identifier_name IN ('kidney transplant bank no lab', 'other kidney transplant bank no lab')"
                    );
                    if ($this->id) {
                        $conditions[] = "MiscIdentifier.id != " . $this->id;
                    }
                    $duplicatedValue = $this->find('count', array(
                        'conditions' => $conditions
                    ));
                    if ($duplicatedValue) {
                        $this->validationErrors['identifier_value'][] = __('kidney transplant bank no lab must be unique');
                        $result = false;
                    }
                }
                return $result;
            } else {
                return parent::validates($options);
            }
        } else {
            return parent::validates($options);
        }
    }
}