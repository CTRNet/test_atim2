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
 * Class ParticipantContact
 */
class ParticipantContact extends ClinicalAnnotationAppModel
{

    /**
     *
     * @param array $queryData
     * @return array
     */
    public function beforeFind($queryData)
    {
        if (! AppController::getInstance()->Session->read('flag_show_confidential') && ! preg_match('/ParticipantContact\.confidential/', serialize($queryData['conditions']))) {
            $queryData['conditions'][] = 'ParticipantContact.confidential != 1';
        }
        return $queryData;
    }
}