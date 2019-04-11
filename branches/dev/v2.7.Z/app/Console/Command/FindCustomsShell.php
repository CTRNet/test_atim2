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
 * Class FindCustomsShell
 */
class FindCustomsShell extends AppShell
{

    public function main()
    {
        $toDo = array(
            getcwd()
        );
        
        if (! is_dir($toDo[0])) {
            die("Invalid directory\n");
        }
        
        echo "*** Program start ***\n";
        echo "Parsing directory ", $toDo[0], "\n";
        while ($toDo) {
            $parentDir = array_pop($toDo);
            $d = dir($parentDir);
            while (false !== ($current = $d->read())) {
                if ($current == '.' || $current == '..') {
                    continue;
                }
                $val = $parentDir . '/' . $current;
                if (is_dir($val)) {
                    $toDo[] = $val;
                }
                
                $lower = strtolower($current);
                if ($lower == 'hooks' || $lower == 'customs') {
                    echo $val, "\n";
                }
            }
        }
        echo "*** Program terminated ***\n";
    }
}