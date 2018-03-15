<?php

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