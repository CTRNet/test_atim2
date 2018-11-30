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
 * Model developped to be able to list both:
 * - TMA blocks of a slides set.
 * - Storages that contains TMA slides.
 * See issue#3283 : Be able to search storages that contain TMA slide into the databrowser
 */
class TmaBlock extends StorageLayoutAppModel
{

    public $useTable = 'view_storage_masters';

    /**
     *
     * @param array $queryData
     * @return array
     */
    public function beforeFind($queryData)
    {
        if (! is_array($queryData['conditions']))
            $queryData['conditions'] = array(
                $queryData['conditions']
            );
        $queryData['conditions'][] = "TmaBlock.is_tma_block = '1'";
        return $queryData;
    }
}