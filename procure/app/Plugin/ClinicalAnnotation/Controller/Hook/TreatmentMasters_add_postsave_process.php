<?php

// Redirect visit data entry worklfow
if (isset($_SESSION['procure_clinical_file_update_process']))
    $urlToFlash = $_SESSION['procure_clinical_file_update_process']['next_page_url'];