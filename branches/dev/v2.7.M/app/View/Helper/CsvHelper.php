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
 * Class CsvHelper
 */
class CsvHelper extends AppHelper
{

    public $enclosure = '"';

    public $filename = 'export';

    public $line = array();

    public $buffer;

    public $csvSeparator = ";";
    
    // var $csvSeparator = CSV_SEPARATOR; See Issue# 3318: Fixe following notice: Notice (8): Use of undefined constant CSV_SEPARATOR
    public static $nodesInfo = null;

    public static $structures = null;
    
    // function CsvHelper() : This methode of calling constructor is deprecated in PHP 7.0
    
    /**
     * CsvHelper constructor.
     *
     * @param View $view
     */
    public function __construct(View $view)
    {
        parent::__construct($view);
        $this->clear();
    }

    public function clear()
    {
        $this->line = array();
        $this->buffer = fopen('php://temp/maxmemory:' . (5 * 1024 * 1024), 'r+');
    }

    /**
     *
     * @param $value
     */
    public function addField($value)
    {
        $this->line[] = $value;
    }

    public function endRow()
    {
        $this->addRow($this->line);
        $this->line = array();
    }

    /**
     *
     * @param $row
     */
    public function addRow($row)
    {
        fputcsv($this->buffer, $row, $this->csvSeparator, $this->enclosure);
    }

    public function renderHeaders()
    {
        header("Content-Type: application/force-download");
        header("Content-Type: application/octet-stream");
        header("Content-Type: application/download");
        header("Content-Type: text/csv");
        header("Content-disposition:attachment;filename=" . $this->filename . '_' . date('YMd_Hi') . '.csv');
    }

    /**
     *
     * @param $filename
     */
    public function setFilename($filename)
    {
        $this->filename = $filename;
        /*
         * if (strtolower(substr($this->filename, -4)) != '.csv') {
         * $this->filename .= '.csv';
         * }
         */
    }

    /**
     *
     * @param bool $outputHeaders
     * @param null $toEncoding
     * @param string $fromEncoding
     * @return string
     */
    public function render($outputHeaders = true, $toEncoding = null, $fromEncoding = "auto")
    {
        if ($outputHeaders) {
            if (is_string($outputHeaders)) {
                $this->setFilename($outputHeaders);
            }
            $this->renderHeaders();
        }
        rewind($this->buffer);
        $output = stream_get_contents($this->buffer);
        if ($toEncoding) {
            $output = mb_convert_encoding($output, $toEncoding, $fromEncoding);
        }
        return $this->output($output);
    }
}